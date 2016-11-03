Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:49752 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754647AbcKCIaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 04:30:19 -0400
Date: Thu, 3 Nov 2016 19:29:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfe]: finobt option separable from crc option? (was [rfc]
 larger batches for crc32c)
Message-ID: <20161103082950.GJ9920@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
 <20161027214244.GO14023@dastard>
 <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
 <20161028160218.1af40906@roar.ozlabs.ibm.com>
 <20161031030853.GK22126@dastard>
 <20161101143918.4f154154@roar.ozlabs.ibm.com>
 <20161101054725.GZ14023@dastard>
 <58194CF8.1000501@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58194CF8.1000501@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "L.A. Walsh" <xfs@tlinx.org>
Cc: linux-xfs@vger.kernel.org

Hi Linda,

On Tue, Nov 01, 2016 at 07:18:32PM -0700, L.A. Walsh wrote:
s
> Snipping in various places:
> 
> Dave Chinner wrote:
> >directory operations:
> >	lookups = 79418,  creates = 460612
> >	removes = 460544, getdents = 5685160
> >
> >SO, we have 80k directory lookups to instantiate an inode, but 460k
> >creates and removes, and 5.6M readdir calls. That's a lot of readdir
> >calls....
> >>trans 0 3491960 0
> >3.5 million asynchronous transaction commits. That's a lot, so far I
> >can account for about 1.5M of them (creates, removes and a handful
> >of data extents). Oh, a couple of million data writes - I bet the
> >rest are timestamp/i_version updates.
> >[...]
> >log force sleeps = 143932               (fsync waits!)
> >...
> >Identifying what that is will give you some idea
> >of how to reduce the fsync load and hence potentially decrease the
> >log and CRC overhead that it is causing....
> ----
>    Back when the free-inode performance enhancement was introduced,
> it was required that crc'ing of metadata also be enabled.  Have
> these options been separated yet?

No, and they won't be. The answer has not changed.

.....

>    I really, still, don't want the crc's on my disks, I don't see
> that they would provide any positive benefit in my usage -- nor in
> many uses of xfs -- which ISN'T to say I can't see the need and/or
> desire to have them for many classes of xfs users -- just not one
> that I belong to at this point.  I was more worried about performance
> than anything else (always trying to eek the most out of fixed budget!).

You may not want CRC's, but they /aren't for you/.  The benefits of
CRCs are realised when things go wrong, not when things go right.
IOWs, CRCs are most useful for the people supporting XFS as they
provide certainty about where errors and corruptions have
originated.

As most users never have things go wrong, all they think is "CRCs
are unnecessary overhead". It's just like backups - how many people
don't make backups because they cost money right now and there's no
tangible benefit until something goes wrong which almost never
happens?

>    I see the speedup from the free-inode tree in saving the
> time during the real-time-search for free space, but only saw the crc
> calculations as time-wasting overhead for the customer not needing
> such integrity guarantees.

Exactly my point. Humans are terrible at risk assessment and
mitigation because most people are unaware of the unconcious
cognitive biases that affect this sort of decision making.

>    Is the free-space inode feature anything more than something to
> offset the speed lost by crc calculations?

That's not what the free inode btree does. It actually slows down
allocation on an empty filesystem and trades off that increase in
"empty filesystem" overhead for significantly better aged filesystem
inode allocation performance. i.e. the finobt provides more
deterministic inode allocation overhead, not "faster" allocation.

Let me demonstrate with some numbers on empty filesystem create
rate:

			create rate	sys CPU time	write rate
			(files/s)	(seconds)	  (MB/s)
crc = 0, finobt = 0:	238943		  2629		 ~200
crc = 1, finobt = 0:	231582		  2711		  ~40
crc = 1, finobt = 1:	232563		  2766		  ~40
*hacked* crc disable:   231435		  2789		  ~40

Std deviation of the file create rate is about +/-10%, so the
differences between the create rate results (3%) are not
significant. Yes, there's a slight decrease in performance with CRCs
enabled, but that's because of the increased btree footprint  due to
the increased btree header size in the v5 format. Hence lookups,
modifications, etc take slightly longer and cost more CPU.

We can see that the system CPU time increased by 3.1% with the
"addition of CRCs".  The CPU usage increases by a further 2% with
the addition of the free inode btree, which should give you an idea
of how much CPU time even a small btree consumes. The allocated
inode btree is huge in comparison to the finobt in this workload,
which is why even a small change in header size (when CRCs are
enabled) makes a large difference in CPU usage.

To verify that CRC has no significant impact on inode allocation,
let's look at the actual CPU being used by the CRC calculations in
this workload are:

  0.28%  [kernel]  [k] crc32c_pcl_intel_update

Only a small proportion of the entire increase in CPU consumption
that comes from "turning on CRCS". Indeed, the "*hacked* CRC
disable" results are from skipping CRC calculations in the code
altogether and returning "verify ok" without calculating them. The
create rate is identical to the crc=1,finobt=1 numbers and the CPU
usage is /slightly higher/ than when CRCs are enabled.

IOWs, for most workloads CRCs have no impact on filesystem
performance.  Yes, there are cases where there is some impact (as
Nick has pointed out) but these are situations where minor
optimisations can make a big difference, such as Nick's suggestion
to zero before write rather than do two partial calcs. This is
not a severe issue - it's just the normal process of iterative
improvement.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
