#!/bin/gprolog --consult-file

:- include('data.pl').



overlaps(slot(X1,Y1),slot(X2,_)) 	:- isBefore(X1,X2),isAfter(Y1,X2).
overlaps(slot(X1,Y1),slot(_,Y2)) 	:- isBefore(X1,Y2),isAfter(Y1,Y2).
overlaps(slot(X1,Y1),slot(X2,Y2)) 	:- isBefore(Y1,Y2),isAfter(X1,X2).
overlaps(slot(X1,Y1),slot(X2,Y2)) 	:- isBefore(X1,X2),isAfter(Y1,Y2).

isSame(S1,S2) :- (S1=am,S2=am);(S1=pm,S2=pm).

isEarlier(S1,S2) :- S1=am,S2=pm.

isLater(S1,S2) :- S1=pm,S2=am.

isAfter(time(H1,_,S1),time(H2,_,S2)) 	:- H1>H2,isSame(S1,S2).
isAfter(time(H1,M1,S1),time(H2,M2,S2)) 	:- H1=H2, M1>M2, isSame(S1,S2).
isAfter(time(_,_,S1),time(_,_,S2)) 		:- isLater(S1,S2).

isBefore(time(H1,_,S1),time(H2,_,S2)) 	:- H1<H2, isSame(S1,S2).
isBefore(time(H1,M1,S1),time(H2,M2,S2)) :- H1=H2, M1<M2, isSame(S1,S2).
isBefore(time(_,_,S1),time(_,_,S2)) 	:- isEarlier(S1,S2).

meetone(Person,Slot2,People) :- free(Person,Slot1),overlaps(Slot1,Slot2),[Person|People].



main :- findall(Person,
		meetone(Person,slot(time(8,30,am),time(8,45,am))),
		People),
	write(People), nl, halt.

:- initialization(main).



test1 	:- isAfter(time(8,15,am),time(8,13,am)),halt. 											/*yes*/ 
test2 	:- isAfter(time(8,13,am),time(8,15,am)),halt. 											/*no*/
test3 	:- isAfter(time(9,13,am),time(9,13,pm)),halt. 											/*no*/
test4 	:- isAfter(time(9,13,pm),time(9,13,am)),halt. 											/*yes*/
test5 	:- isAfter(time(9,13,pm),time(9,13,pm)),halt. 											/*no*/

test6 	:- isBefore(time(8,15,am),time(8,13,am)),halt. 											/*no*/ 
test7 	:- isBefore(time(8,13,am),time(8,15,am)),halt. 											/*yes*/ 
test8 	:- isBefore(time(9,13,am),time(9,13,pm)),halt. 											/*yes*/ 
test9 	:- isBefore(time(9,13,pm),time(9,13,am)),halt. 											/*no*/ 
test10 	:- isBefore(time(9,13,pm),time(9,13,pm)),halt. 											/*no*/ 

test11 	:- isSame(am,am),halt. 																	/*yes*/ 
test12 	:- isSame(am,pm),halt. 																	/*no*/ 
test13 	:- isSame(pm,am),halt. 																	/*no*/ 
test14 	:- isSame(pm,pm),halt. 																	/*yes*/ 

test15 	:- isLater(am,pm),halt. 																/*no*/ 
test16 	:- isLater(am,am),halt. 																/*no*/ 
test17 	:- isLater(pm,pm),halt. 																/*no*/ 
test18 	:- isLater(pm,am),halt. 																/*yes*/ 

test19 	:- isEarlier(am,pm),halt. 																/*yes*/ 
test20 	:- isEarlier(am,am),halt. 																/*no*/ 
test21 	:- isEarlier(pm,pm),halt. 																/*no*/ 
test22 	:- isEarlier(pm,am),halt. 																/*no*/ 

test23 	:- overlaps(slot(time(8,15,am),time(8,45,am)),slot(time(8,30,am),time(8,45,am))),halt. 	/*yes*/ 
test24 	:- overlaps(slot(time(8,45,am),time(9,15,am)),slot(time(8,30,am),time(8,45,am))),halt. 	/*no*/ 
test25 	:- overlaps(slot(time(8,00,am),time(8,30,am)),slot(time(8,30,am),time(8,45,am))),halt. 	/*no*/ 
test26 	:- overlaps(slot(time(9,00,am),time(9,30,am)),slot(time(8,30,am),time(8,45,am))),halt. 	/*no*/ 
test27 	:- overlaps(slot(time(8,00,am),time(9,00,am)),slot(time(8,30,am),time(8,45,am))),halt. 	/*yes*/ 

test28 	:- meetone(ann,slot(time(8,30,am),time(8,45,am)),Person),halt. 							/*error*/ 
test29 	:- meetone(bob,slot(time(8,30,am),time(8,45,am)),Person),halt. 							/*no*/ 
test30 	:- meetone(carla,slot(time(8,30,am),time(8,45,am)),Person),halt. 						/*error*/ 
test31 	:- meetone(dave,slot(time(8,30,am),time(8,45,am)),Person),halt. 						/*error*/ 
test32 	:- meetone(ed,slot(time(8,30,am),time(8,45,am)),Person),halt. 							/*no*/ 