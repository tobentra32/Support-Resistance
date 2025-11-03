//+------------------------------------------------------------------+
//|                                           Support&Resistance.mq5 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"


input ENUM_TIMEFRAMES timeframe = PERIOD_H4; //SUPPORT AND RESISTANCE TIMEFRAME

double open[];
double close[];
double low[];
double high[];
datetime time[];

int bars_check = 200;

double first_sup_price;
double first_sup_min_body_price;
datetime first_sup_time;

string support_object;
ulong chart_id =  ChartID();

int total_symbol_bars;
int z = 7;

double second_sup_price;
datetime second_sup_time;
string first_low_txt;
string second_low_txt;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

   ObjectsDeleteAll(chart_id);

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   CopyOpen(_Symbol, timeframe, TimeCurrent(), bars_check, open);
   CopyClose(_Symbol, timeframe, TimeCurrent(), bars_check, close);
   CopyLow(_Symbol, timeframe, TimeCurrent(), bars_check, low);
   CopyHigh(_Symbol, timeframe, TimeCurrent(), bars_check, high);
   CopyTime(_Symbol, timeframe, TimeCurrent(), bars_check, time);

   total_symbol_bars = Bars(_Symbol, timeframe);

   if(total_symbol_bars >= bars_check)
     {

      for(int i = z ; i < bars_check - z; i++)
        {

         if(IsSwingLow(low, i, z))
           {

            first_sup_price = low[i];
            first_sup_min_body_price = MathMin(close[i], open[i]);
            first_sup_time = time[i];


            for(int j = i+1; j < bars_check - z; j++)
              {

               if(IsSwingLow(low, j, z) && low[j] <= first_sup_min_body_price &&  low[j] >= first_sup_price)
                 {

                  second_sup_price = low[j];
                  second_sup_time = time[j];

                  support_object = StringFormat("SUPPORT %f",first_sup_price);

                  ObjectCreate(chart_id,support_object,OBJ_RECTANGLE,0,first_sup_time,first_sup_price,TimeCurrent(),first_sup_min_body_price);
                  ObjectSetInteger(chart_id,support_object,OBJPROP_COLOR,clrBlue);
                  ObjectSetInteger(chart_id,support_object,OBJPROP_BACK,true);
                  ObjectSetInteger(chart_id,support_object,OBJPROP_FILL,true);

                  first_low_txt = StringFormat("FIRST LOW%d",i);
                  ObjectCreate(chart_id,first_low_txt,OBJ_TEXT,0,first_sup_time,first_sup_price);
                  ObjectSetString(chart_id,first_low_txt,OBJPROP_TEXT,"1");

                  second_low_txt = StringFormat("SECOND LOW%d",i);
                  ObjectCreate(chart_id,second_low_txt,OBJ_TEXT,0,second_sup_time,second_sup_price);
                  ObjectSetString(chart_id,second_low_txt,OBJPROP_TEXT,"2");

                  break;
                 }
              }
           }
        }
     }


  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| FUNCTION FOR SWING LOW                                           |
//+------------------------------------------------------------------+
bool IsSwingLow(const double &low_price[], int index, int lookback)
  {
   for(int i = 1; i <= lookback; i++)
     {
      if(low_price[index] > low_price[index - i] || low_price[index] > low_price[index + i])
         return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| FUNCTION FOR SWING HIGH                                          |
//+------------------------------------------------------------------+
bool IsSwingHigh(const double &high_price[], int index, int lookback)
  {
   for(int i = 1; i <= lookback; i++)
     {
      if(high_price[index] < high_price[index - i] || high_price[index] < high_price[index + i])
         return false; // If the current high is not the highest, return false.
     }
   return true;
  }
//+------------------------------------------------------------------+
