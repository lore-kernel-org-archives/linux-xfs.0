Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:36516 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757702AbcKCQQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 12:16:08 -0400
Message-ID: <581B601A.4060403@tlinx.org>
Date: Thu, 03 Nov 2016 09:04:42 -0700
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [rfe]: finobt option separable from crc option? (was [rfc] larger
 batches for crc32c)
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com> <20161027214244.GO14023@dastard> <20161028131234.24a5cb6f@roar.ozlabs.ibm.com> <20161028160218.1af40906@roar.ozlabs.ibm.com> <20161031030853.GK22126@dastard> <20161101143918.4f154154@roar.ozlabs.ibm.com> <20161101054725.GZ14023@dastard> <58194CF8.1000501@tlinx.org> <20161103082950.GJ9920@dastard>
In-Reply-To: <20161103082950.GJ9920@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



Dave Chinner wrote:
> 
> As most users never have things go wrong, all they think is "CRCs
> are unnecessary overhead". It's just like backups - how many people
> don't make backups because they cost money right now and there's no
> tangible benefit until something goes wrong which almost never
> happens?
----
	But it's not like backups.  You can't run a util
program upon discovering bad CRC's that will fix the file system
because the file system is no longer usable.  That means you
have to restore from backup.  Thus, for those keeping
backups, there is no benefit, as they'll have to restore
from backups in either case.

> Exactly my point. Humans are terrible at risk assessment and
> mitigation because most people are unaware of the unconcious
> cognitive biases that affect this sort of decision making.
---
	My risk is near 0 since my file systems are monitored
by a raid controller with read patrols made over the data on
a period basis.  I'll assert that the chance of data randomly
going corrupt is much higher because there is ALOT more data than
metadata.  On top of that, because I keep backups, my risk, is
at worst, the same without crc's as with them.

>  It actually slows down
> allocation on an empty filesystem and trades off that increase in
> "empty filesystem" overhead for significantly better aged filesystem
> inode allocation performance.
----
	Ok, let's see, ages of my file systems:
4 from 2009 (7 years)
1 from 2013 (3 years)
9 from 2014 (2 years)
---
	I don't think I have any empty or new filesystems
(FWIW, I store the creation time in the UUID).

 i.e. the finobt provides more
> deterministic inode allocation overhead, not "faster" allocation.
> 
> Let me demonstrate with some numbers on empty filesystem create
> rate:
> 
> 			create rate	sys CPU time	write rate
> 			(files/s)	(seconds)	  (MB/s)
> crc = 0, finobt = 0:	238943		  2629		 ~200
> crc = 1, finobt = 0:	231582		  2711		  ~40
> crc = 1, finobt = 1:	232563		  2766		  ~40
> *hacked* crc disable:   231435	  2789		  ~40


> We can see that the system CPU time increased by 3.1% with the
> "addition of CRCs".  The CPU usage increases by a further 2% with
> the addition of the free inode btree,
---
	On an empty file system or older ones that are >50%
used?  It's *nice* to be able to benchmarks, but not allowing
crc to be disabled, disables that possibility -- and that's
sorta the point.  In order to prove you point, you created a
benchmark with crc's disabled. But the thing about benchmarks
is making so others can reproduce your results.  That's
the problem.  If I could do the same benchmarks, and get 
similar results, I'd give up as finobt not being worth it.

	But I'm not able to run such tests on my workload
and/or filesystems.  The common advice about performance numbers
and how they are affected by options is to do benchmarks
on your own systems with your own workload and see if the option
helps.  That's what I want to do.  Why deny that?



 which should give you an idea
> of how much CPU time even a small btree consumes.
---
	In a non-real-world case on empty file systems. How
does it work in the real world on file systems like mine?
I know the MB/s isn't close, w/my max sustained I/O rates
being about 1GB/s (all using direct i/o -- rate drops
significantly if I use kernel buffering).  Even not
pre-allocating and defragmenting the test file will noticeable
affect I/O rates.  

	Showing the result on an empty file
system is when finobt would have the *least* affect, since
it is when the kernel has to search for space that things
slow down, but if the free space is pre-allocated in a 
dedicated b-tree, then the kernel doesn't have to search --
which would be a much bigger difference than on an empty
file system.


 The allocated
> inode btree is huge in comparison to the finobt in this workload,
> which is why even a small change in header size (when CRCs are
> enabled) makes a large difference in CPU usage.
> 
> To verify that CRC has no significant impact on inode allocation,
> let's look at the actual CPU being used by the CRC calculations in
> this workload are:
> 
>   0.28%  [kernel]  [k] crc32c_pcl_intel_update
---
	And how much is spent searching for free space?
On multi-gig files it can reduces I/O rates by 30% or more.

> 
> Only a small proportion of the entire increase in CPU consumption
> that comes from "turning on CRCS". Indeed, the "*hacked* CRC
> disable" results are from skipping CRC calculations in the code
> altogether and returning "verify ok" without calculating them. The
> create rate is identical to the crc=1,finobt=1 numbers and the CPU
> usage is /slightly higher/ than when CRCs are enabled.
> 
> IOWs, for most workloads CRCs have no impact on filesystem
> performance.  
---
	Too bad no one can test such the effect on their
own workloads, though if not doing crc's takes more CPU, then
it sounds like an algorithm problem: crc calculations don't
take "negative time", and a benchmark showing they do indicates
something else is causing the slowdown.

> Cheers,
> Dave.
----
Sigh... and Cheers to you too! ;-)
Linda

