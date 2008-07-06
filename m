Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 05:42:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m66Cfu9p029389
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 05:41:56 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6CE32BDB93
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 05:43:00 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id jkZzqKyEZvABOT2m for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 05:43:00 -0700 (PDT)
Date: Sun, 6 Jul 2008 08:42:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.DEB.1.10.0807060741010.4930@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807060841530.9996@p34.internal.lan>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan> <48700228.7060904@shaw.ca> <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan> <alpine.DEB.1.10.0807060447180.5005@p34.internal.lan>
 <alpine.DEB.1.10.0807060741010.4930@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

On Sun, 6 Jul 2008, Justin Piszcz wrote:
> On Sun, 6 Jul 2008, Justin Piszcz wrote:
>> On Sat, 5 Jul 2008, Justin Piszcz wrote:
>>> On Sat, 5 Jul 2008, Robert Hancock wrote:
>> After the rebuild is completed I will perform more testing.

The following setup is in-place:

       Kernel: 2.6.25.10
Boot options: none
          NCQ: disabled on all disks
   irqbalance: disabled/not running

Removal of all old test data:

$ for i in [0-9]*; do rm -rf $i & done
..
[468] 5158
[469] 5159
[470] 5160
[471] 5161
[472] 5162
$

-- no problems yet --

run untar test+copy test:

$ mkdir `seq 0 20`
$ ./runtest.sh

for i in `seq 0 20`
do
   cd $i
   tar xf ../linux-2.6.25.10.tar &
   cd ..
done

for b in `seq 21 40`
do
   cp linux-2.6.25.10.tar $b & 
done

-- waiting for problems --

If no problems at the end of this test, will start up IRQ balance (how I
normally ran my system) and re-test to see it is relegated to the irqbalance
daemon running.

-----------------------------

Success ..

$ du -sh `seq 0 40`
311M    0
311M    1
311M    2
311M    3
311M    4
311M    5
311M    6
311M    7
311M    8
311M    9
311M    10
311M    11
311M    12
311M    13
311M    14
311M    15
311M    16
311M    17
311M    18
311M    19
311M    20
272M    21
272M    22
272M    23
272M    24
272M    25
272M    26
272M    27
272M    28
272M    29
272M    30
272M    31
272M    32
272M    33
272M    34
272M    35
272M    36
272M    37
272M    38
272M    39
272M    40

-----------------------------

.. no problems ..
.. proceeded with test mentioned above ..

Second round:

The following setup is in-place:

       Kernel: 2.6.25.10
Boot options: none
          NCQ: disabled on all disks
   irqbalance: enabled

--

Remove old cruft:

$ for i in `seq 0 40`
> do
> rm -rf $i  &
> done

Create new directories, re-run test:

$ mkdir `seq 0 20`

$ ./runtest.sh

.. no problems either ..

--

I do not have a method to reproduce the problem at will unfortunately.

Justin.
