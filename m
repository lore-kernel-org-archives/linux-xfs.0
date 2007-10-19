Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Oct 2007 01:00:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9J7xsL1023030
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2007 00:59:57 -0700
Date: Fri, 19 Oct 2007 17:59:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raw vs XFS sequential write and system load
Message-ID: <20071019075949.GS995458@sgi.com>
References: <B4D42128-E5B2-48B1-AEF1-586FD90AF605@cern.ch> <20071018222357.GN995458@sgi.com> <F9DEBD65-7751-4187-97EF-1DF1F63B0888@cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F9DEBD65-7751-4187-97EF-1DF1F63B0888@cern.ch>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mario Kadastik <mario.kadastik@cern.ch>
Cc: xfs@oss.sgi.com

On Fri, Oct 19, 2007 at 08:12:16AM +0200, Mario Kadastik wrote:
> >>I have a slight problem. Namely we have 4 systems with each having 2x
> >>3ware 9550SX cards in them each with hardware RAID5. Everything is
> >>running the latest FW etc. The systems have at least 3GB of memory
> >>and at least 2 CPU-s (one has 4GB and 4 cpu-s).
> >
> >Before going any further, what kernel are you using and what's
> >the output of xfs_info </mntpt> of the filesytsem you are testing?
> 
> Well I did manage to accidentally kill that specific box (did the  
> heavy dd to a file on the root disk instead of the XFS mount (forgot  
> to mount first), filling it and losing the system from net, so will  
> have to wait for it to come back after someone locally can go and  
> have a look). But I moved over to another box where I had freed up  
> one RAID5 for testing purposes and a number of things came apparent:

Oops :/

> 1. on the original box I had been running 2.6.9 SMP which was the  
> default shipped with Scientific Linux 4. With that kernel the single  
> stream to raw device seemed to go without no io wait and everything  
> seemed very nice, however the XFS performance was as I wrote, under  
> par the very least.

Ah - 2.6.9. That explains the bad behaviour of XFS - it's locking all
the system memory in the elevator because the depth is so large.
i.e. throttle at 7/8 * 8192 requests, and each request will be
512k which means that we can have ~3.5GB of RAM locked in a single
elevator queue before it will throttle. Effectively your config
is running your machine out of available memory....

> 2. before I lost the box I had rebooted it to 2.6.22.9 SMP as I had  
> been reading around about XFS and found that 2.6.15+ kernels had a  
> few updates which might be of interest, however I immediately found  
> that 2.6.22.9 behaved absolutely different.

Absolutely. We fixed all the problems w.r.t. queue depth and
congestion, and we completely rewrote the write path....

> For one thing the single  
> stream write to raw disk no longer had 0% io wait, but instead around  
> 40-50%. A quick look of the difference of the two kernels revealed  
> for example that the /sys/block/sda/queue/nr_requests had gone from  
> 8192 in 2.6.9 to 128 in 2.6.22.9.

Yup, it was set to something sane and the block device is throttling
writes on device congestion.

> Going back to 8192 decreased the  
> load of single stream write to raw disk io wait to 10% region, but  
> not to 0. Soon after however I killed the system so had to stop the  
> tests for a while.

Yup, you probably had the OOM killer trigger because setting the
queue depth that deep is a Bad Thing To Do. Effectively, you
turned off all feedback from the I/o layer to the VM to say
the drive has enough I/O now so please stop sending me more
because all I'm doing is queing it.


> 3. On the new box with 4 cpu-s, 4 GB of memory and 12 drive RAID5 I  
> was running 2.6.23 SMP with CONFIG_4KSTACKS disabled (one of our  
> admins thought that could cure a few crashes we had seen before on  
> the system due to high network load, don't know if it's relevant, but  
> just in case mentioned). On this box I first also discovered horrible  
> io wait with single stream write to raw device and again the  
> nr_requests seemed to cure that to 10% level.

That's not a cure! that's asking for trouble. You're seeing high
I/O wait because the system can feed data to the disks *much* faster
than the disk can do the I/O and you're not consuming any
CPU time. This is *not wrong*.

XFS can feed disk subsystems many, many times faster than what you
have - you will always see iowait time on this sort of system
when using XFS. It's telling you the filesystem is far, far
faster than your disk. ;)

> However here I also  
> found that XFS was performing exactly the same as the direct raw  
> device. Also in the 5-10% region of io wait. Doing 2 parallel writes  
> to the filesystem increased the io wait to 25%. Doing parallel read  
> and write had the system at around 15-20% of io wait, the more  
> concrete numbers for some of the tests I did:
> 
> 1 w 0 r: 10%
> 2 w 0 r: 20%
> 3 w 0 r: 33%
> 4 w 0 r: 45%
> 5 w 0 r: 50%
> 
> 3 w 3 r: 50-60% (system still ca 20% idle)
> 3 w 10 r: 50-80% (system ca 10% idle, over time system load increased  
> to 14)

Now change thenr_request back to 128 and run the test again. What
happens to your iowait? What happens to responsiveness?

> Now as I have only access to the new box I'll provide the XFS info  
> for that one:
> meta-data=/dev/sdc               isize=256    agcount=32,  
> agsize=62941568 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=2014129920,  
> imaxpct=25
>          =                       sunit=16     swidth=176 blks,  
> unwritten=1
> naming   =version 2              bsize=4096
>   log      =internal log           bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy- 
> count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> it was created with mkfs.xfs -d su=64k,sw=11 /dev/sdc to match the  
> underlying RAID5 of 12 disks and stripe size 64k.

Add v2 logs, log stripe unit of 64k.

> Now, my main concern is not the speed. As long as I get around 2-3MB/ 
> s per file/stream read/written I'm happy AS LONG AS the system  
> remains responsive. I mean Linux kernel must have a way to gear down  
> network traffic (or in the case of dd then memory access) to suit the  
> underlying system which is taking the hit.

It *does*. It's the elevator queue depth! By setting it back to 8192
you turned off the mechanism linux uses to maintain responsiveness
under heavy I/O load.

> It's probably a question  
> of tuning the kernel to act correctly, not try to do all at maximum  
> speed, but to do it in a stable way.

By default it should do the right thing. You should not have to
tweak anything at all. You're tweaking is causing the unstableness
in the recent kernels. Use the defaults and your system should
remain responsive under any I/o load you throw at it. High iowait
time and/or high load average is *not* an indication of a problem,
just that your system is under load and you're not cpu bound.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
