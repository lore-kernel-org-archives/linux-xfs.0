Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Nov 2008 01:29:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA18TJrd016288
	for <xfs@oss.sgi.com>; Sat, 1 Nov 2008 01:29:19 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EE4E1B7166A
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 01:29:19 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id vVWnFyI7WlCbqGm4 for <xfs@oss.sgi.com>; Sat, 01 Nov 2008 01:29:19 -0700 (PDT)
Date: Sat, 1 Nov 2008 04:29:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Linux RAID & XFS Question - Multiple levels of concurrency = faster
 I/O on md/RAID 5?
Message-ID: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-raid@vger.kernel.org
Cc: xfs@oss.sgi.com


# echo 1 > /proc/sys/vm/drop_caches ; sync

* Single operation on RAID5 (read/write, like untar for example)
   - It starts when the jump of bi/bo occurs.
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  0  0    176 6423384     12 151356    0    0   173   212   34   48  1  1 98  0
  0  0    176 6421688     12 153004    0    0    16   127 5151 1634  2  1 97  0
  0  0    176 6419952     12 154724    0    0     0    89 5205 1691  2  0 98  0
  0  0    176 6418216     12 156452    0    0     0    32 5346 1768  2  1 97  0
  1  0    176 6323928     12 249380    0    0 50456     0 5350 1854 10  2 82  5
  1  0    176 6072840     12 497488    0    0 127696     0 5462 1565 21  5 73  1
  1  0    176 5829388     12 737636    0    0 116528   108 5576 1830 22  5 73  0
  1  0    176 5639876     12 924496    0    0 97896 98525 6761 2095 15 13 68  4
  1  0    176 5439212     12 1122796    0    0 97676 102516 7403 2697 17 14 67  2
  1  0    176 5241408     12 1318032    0    0 97668 94740 6460 2059 16 12 71  1
  2  0    176 5044000     12 1512528    0    0 97704 98848 8209 2430 17 13 70  1
  1  0    176 4845076     12 1708524    0    0 97668 98761 6879 2490 16 13 70  1

* Two of these operations run on two different sets of data.
  2  0    176 4631564     12 1917264    0    0 111416 78104 7713 3118 17 12 68  2
  2  0    176 4260696     12 2283256    0    0 181736 205732 7670 3028 31 23 45 
1
  2  0    176 3882464     12 2656564    0    0 195392 177052 7324 3271 31 23 39 
8
  1  1    176 3535608     12 2997788    0    0 160152 185052 9408 3724 32 25 36 
7
  0  2    176 3184864     12 3342392    0    0 163220 181252 8392 3582 32 24 37 
7
  3  1    176 2837420     12 3685484    0    0 170424 169939 9071 3242 30 21 43 
5
  2  1    176 2449528     12 4066656    0    0 190208 196776 7408 3178 33 25 38 
4
  3  0    176 2058540     12 4452064    0    0 194992 190408 8630 3230 33 24 39 
5
  7  0    176 1692204     12 4812832    0    0 176528 185336 8583 3838 32 21 40 
6
  8  0    176 1302428     12 5195400    0    0 195332 186460 9345 3663 33 25 37

* Three of these operations run on three different sets of data.
  2  1    176 910448     12 5580544    0    0 184484 204909 8533 3109 35 25 34  6
  2  1    176 487040     12 5997284    0    0 211716 205592 9795 3263 36 24 22 19
  2  0    176  40456     12 6437196    0    0 222324 229712 7932 2952 40 29 20 12
  6  0    176  45348     12 6433304    0    0 279344 230608 7553 4077 38 29 25  7
  3  1    176  44784     12 6434256    0    0 197052 247164 9109 4454 42 30 19 10
  3  0    176  44856     12 6433404    0    0 256128 250500 8505 3924 42 31 17 11
  7  0    176  43832     12 6435116    0    0 279352 250440 7998 4171 41 31 21  6
  2  1    176  43888     12 6434544    0    0 214440 234088 9106 4181 41 29 19 11
  5  0    176  45676     12 6433164    0    0 230512 263132 8720 4289 45 30 16  9
  5  0    176  45040     12 6433164    0    0 287536 229856 7886 4669 40 30 19 12
  8  0    176  46012     12 6432800    0    0 257844 147884 9291 4833 46 24 18 12
  9  1    176  46072     12 6432492    0    0 187156 361096 8643 3738 38 35 21  6

Overall the raw speed according to vmstat seems to increase as you add more
load to the server.  So I decided to time running three jobs on two parts 
of data and compare it with a single job that proceses them all.

Three jobs run con-currently: (2 parts/each):

1- 59.99user 18.25system 2:02.07elapsed 64%CPU (0avgtext+0avgdata 0maxresident)k
    0inputs+0outputs (0major+21000minor)pagefaults 0swaps

2- 59.86user 17.78system 1:59.96elapsed 64%CPU (0avgtext+0avgdata 0maxresident)k
    0inputs+0outputs (21major+20958minor)pagefaults 0swaps

3- 74.77user 22.83system 2:13.30elapsed 73%CPU (0avgtext+0avgdata 0maxresident)k
    0inputs+0outputs (36major+21827minor)pagefaults 0swaps

One job with (6 parts):

1 188.66user 56.84system 4:38.52elapsed 88%CPU (0avgtext+0avgdata 0maxresident)k
   0inputs+0outputs (71major+43245minor)pagefaults 0swaps

Why is running 3 jobs con-currently that take care of two parts each more than
twice as fast than running one job for six parts?

I am using XFS and md/RAID-5, the CFQ scheduler and kernel 2.6.27.4.
Is this more of an md/raid issue ( I am guessing ) than XFS? I remember 
reading of some RAID acceleration patches awhile back that were supposed 
to boost performance quite a bit, what happened to them?

Justin.
