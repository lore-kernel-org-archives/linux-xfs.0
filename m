Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 04:03:08 -0700 (PDT)
Received: from cernmxlb.cern.ch (cernmx07.cern.ch [137.138.166.171])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9IB2pHl003284
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 04:03:00 -0700
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Transfer-Encoding: 7bit
Message-Id: <B4D42128-E5B2-48B1-AEF1-586FD90AF605@cern.ch>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
From: Mario Kadastik <mario.kadastik@cern.ch>
Subject: raw vs XFS sequential write and system load
Date: Thu, 18 Oct 2007 12:50:44 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

I have a slight problem. Namely we have 4 systems with each having 2x  
3ware 9550SX cards in them each with hardware RAID5. Everything is  
running the latest FW etc. The systems have at least 3GB of memory  
and at least 2 CPU-s (one has 4GB and 4 cpu-s).

Now my problem is that as this is a Grid storage node and we transfer  
constantly files 2+ GB back and forth with tens of them in parallel,  
then the system seems to be having serious problems.

We can do read speeds basically with only limit being the network  
without the system picking up any load (we do use the blockdev -- 
setra 16384) and can keep running combined 200MB/s to the network  
over a long period of time. However if we get writes to the systems  
then even at low speeds they hog the systems and send the load of the  
systems to 20+ (largest I have recovered from is 150, usually they  
are between 20-60). As this makes the system basically unusable I did  
a lot of digging to try to understand what causes such a high load.

The basic thing is that with vmstat I can see a number of blocked  
processes during the writes and high io wait for the system. All of  
the RAID5-s have XFS on top of them. Finally after weeks of not  
getting any adequate response from 3ware etc I freed up one of the  
systems to do some extra tests. Just yesterday I measured the basic  
difference of doing a direct dd to the actual raw device versus doing  
the dd to a local file in XFS. The results are in detail here:

http://hep.kbfi.ee/dbg/jupiter_test.txt

As you can see the system is quite responsive during the read and  
write sequentially to the raw device. There are no blocked processes  
and the io wait is < 5%. However going to XFS we immediately see  
blocked processes which over time leads to very high load on the system.

Is there something I'm missing? I did create the XFS with the correct  
RAID 5 su,sw settings, but is there a way to tune the XFS or general  
kernel parameters in a way that this blocking doesn't occur that much  
with XFS. I don't really care if I don't get 400MB/s read/write  
performance, I'd be satisfied with 10% of that during production load  
as long as the system is able to not fall over because of it.

Just as a clarification, the io done is sequential write or read of  
2.5GB files, there will be a number of files accessed in parallel  
(I'd say up to 20 in parallel, but I can limit the number).

I have googled around a lot, but to be honest have not enough inside  
info on the kernel tunables to make an educated guess on where to  
begin. I'd assume the io patterns of XFS differ from raw sequential  
read/write, but probably it could be tuned to some extent to better  
match the hardware and probably there are ways to make sure that  
instead of load going up the speed goes down.

Thanks in advance,

Mario Kadastik
