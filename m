Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 23:13:24 -0700 (PDT)
Received: from cernmxlb.cern.ch (cernmx07.cern.ch [137.138.166.171])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9J6DIPk031367
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 23:13:20 -0700
In-Reply-To: <20071018222357.GN995458@sgi.com>
References: <B4D42128-E5B2-48B1-AEF1-586FD90AF605@cern.ch> <20071018222357.GN995458@sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Message-Id: <F9DEBD65-7751-4187-97EF-1DF1F63B0888@cern.ch>
From: Mario Kadastik <mario.kadastik@cern.ch>
Subject: Re: raw vs XFS sequential write and system load
Date: Fri, 19 Oct 2007 08:12:16 +0200
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

>> I have a slight problem. Namely we have 4 systems with each having 2x
>> 3ware 9550SX cards in them each with hardware RAID5. Everything is
>> running the latest FW etc. The systems have at least 3GB of memory
>> and at least 2 CPU-s (one has 4GB and 4 cpu-s).
>
> Before going any further, what kernel are you using and what's
> the output of xfs_info </mntpt> of the filesytsem you are testing?

Well I did manage to accidentally kill that specific box (did the  
heavy dd to a file on the root disk instead of the XFS mount (forgot  
to mount first), filling it and losing the system from net, so will  
have to wait for it to come back after someone locally can go and  
have a look). But I moved over to another box where I had freed up  
one RAID5 for testing purposes and a number of things came apparent:

1. on the original box I had been running 2.6.9 SMP which was the  
default shipped with Scientific Linux 4. With that kernel the single  
stream to raw device seemed to go without no io wait and everything  
seemed very nice, however the XFS performance was as I wrote, under  
par the very least.
2. before I lost the box I had rebooted it to 2.6.22.9 SMP as I had  
been reading around about XFS and found that 2.6.15+ kernels had a  
few updates which might be of interest, however I immediately found  
that 2.6.22.9 behaved absolutely different. For one thing the single  
stream write to raw disk no longer had 0% io wait, but instead around  
40-50%. A quick look of the difference of the two kernels revealed  
for example that the /sys/block/sda/queue/nr_requests had gone from  
8192 in 2.6.9 to 128 in 2.6.22.9. Going back to 8192 decreased the  
load of single stream write to raw disk io wait to 10% region, but  
not to 0. Soon after however I killed the system so had to stop the  
tests for a while.
3. On the new box with 4 cpu-s, 4 GB of memory and 12 drive RAID5 I  
was running 2.6.23 SMP with CONFIG_4KSTACKS disabled (one of our  
admins thought that could cure a few crashes we had seen before on  
the system due to high network load, don't know if it's relevant, but  
just in case mentioned). On this box I first also discovered horrible  
io wait with single stream write to raw device and again the  
nr_requests seemed to cure that to 10% level. However here I also  
found that XFS was performing exactly the same as the direct raw  
device. Also in the 5-10% region of io wait. Doing 2 parallel writes  
to the filesystem increased the io wait to 25%. Doing parallel read  
and write had the system at around 15-20% of io wait, the more  
concrete numbers for some of the tests I did:

1 w 0 r: 10%
2 w 0 r: 20%
3 w 0 r: 33%
4 w 0 r: 45%
5 w 0 r: 50%

3 w 3 r: 50-60% (system still ca 20% idle)
3 w 10 r: 50-80% (system ca 10% idle, over time system load increased  
to 14)

the last one was already a more realistic scenario (8 RAID5-s, 3  
writes per one is 24 writes, that's about the order of magnitude I'm  
aiming for, 80 reads is quite conservative still, likely is 120  
accross the whole storage of 4 systems, though we will increase that  
number further to spread out the load even further). However I have  
been running the test on only one controller now while the other one  
was sitting idle, in reality both of them would be hit the same way  
at the same time.

Now as I have only access to the new box I'll provide the XFS info  
for that one:
meta-data=/dev/sdc               isize=256    agcount=32,  
agsize=62941568 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=2014129920,  
imaxpct=25
          =                       sunit=16     swidth=176 blks,  
unwritten=1
naming   =version 2              bsize=4096
   log      =internal log           bsize=4096   blocks=32768, version=1
          =                       sectsz=512   sunit=0 blks, lazy- 
count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

it was created with mkfs.xfs -d su=64k,sw=11 /dev/sdc to match the  
underlying RAID5 of 12 disks and stripe size 64k.

>
> FWIW, high iowait = high load average. High iowait is generally an
> indicator of an overloaded disk subsystem.  You tests to the raw
> device only used a single stream, so it's unlikely to show any of
> the issues you're complaining about when running tens of parallel
> streams....
>

Well I do understand that high io wait leads to high load over some  
time period. And I also do understand that high io wait indicates  
overloaded disk, however as the percentage of io wait seems to vary  
highly with what kernel is running and what the kernel settings are,  
then I think that the system should be able to cope with what I'm  
throwing at it.

Now, my main concern is not the speed. As long as I get around 2-3MB/ 
s per file/stream read/written I'm happy AS LONG AS the system  
remains responsive. I mean Linux kernel must have a way to gear down  
network traffic (or in the case of dd then memory access) to suit the  
underlying system which is taking the hit. It's probably a question  
of tuning the kernel to act correctly, not try to do all at maximum  
speed, but to do it in a stable way. All of the above tests were  
still going at high speed, average read and write speeds in total  
were around 150-200MB/s however I'd be happy with 10% of that if it  
were to make the system more stable.

It seems now that XFS may not be the big culprit here, but I do think  
that the kernel VM management is best tuned by people who do  
understand how XFS behaves to make sure that it can cope with  
something I'm hoping for it to do as well as tuning XFS itself to  
match the io patterns and underlying system. I do appreciate any help  
you could give me.

Thanks in advance,

Mario



[[HTML alternate version deleted]]
