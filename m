Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32279 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752778AbcJUBtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2016 21:49:09 -0400
Date: Fri, 21 Oct 2016 12:48:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Periodic fstrim job vs mounting with discard
Message-ID: <20161021014833.GP14023@dastard>
References: <CACQR=w17PSW8eNPr-ynPb2pB6UJPKCdPtfMYP-OCbaboo9HNzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACQR=w17PSW8eNPr-ynPb2pB6UJPKCdPtfMYP-OCbaboo9HNzQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Jared D. Cottrell" <jcottr@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 20, 2016 at 03:32:48PM -0700, Jared D. Cottrell wrote:
> We've been running our Ubuntu 14.04-based, SSD-backed databases with a
> weekly fstrim cron job, but have been finding more and more clusters

Command line for fstrim?

> that are locking all IO for a couple minutes as a result of the job.
> In theory, mounting with discard could be appropriate for our use case
> as file deletes are infrequent and handled in background threads.
> However, we read some dire warnings about using discard on this list
> (http://oss.sgi.com/archives/xfs/2014-08/msg00465.html) that make us
> want to avoid it.

discard is being improved - Christoph posted a patchset a few days
ago that solve many of the XFS specific issues. It also tries to
avoid the various deficiencies of underlying infrastructure as much
as possible.

> Is discard still to be avoided at all costs? Are the corruption and
> bricking problems mentioned still something to be expected even with
> the protection of Linux's built-in blacklist of broken SSD hardware?
> We happen to be using Amazon's in-chassis SSDs. I'm sure they use
> multiple vendors but I can't imagine they're taking short-cuts with
> cheap hardware.

Every so often we see a problem that manifests when discard is
enabled, and it goes away when it is turned off. Not just on XFS -
there's similar reports on the btrfs list. It's up to you to decide
whether you use it or not.

> If discard is still strongly discouraged, perhaps we can approach the
> problem from the other side: does the slow fstrim we're seeing sounds
> like a known issue? After a bunch of testing and research, we've
> determined the following:
> 
> Essentially, XFS looks to be iterating over every allocation group and
> issuing TRIM s for all free extents every time this ioctl is called.
> This, coupled with the facts that Linux's interface to the TRIM
> command is both synchronous and does not support a vectorized list of
> ranges (see: https://github.com/torvalds/linux/blob/3fc9d690936fb2e20e180710965ba2cc3a0881f8/block/blk-lib.c#L112),
> is leading to a large number of extraneous TRIM commands (each of
> which have been observed to be slow, see:
> http://oss.sgi.com/archives/xfs/2011-12/msg00311.html) being issued to
> the disk for ranges that both the filesystem and the disk know to be
> free. In practice, we have seen IO disruptions of up to 2 minutes. I
> realize that the duration of these disruptions may be controller
> dependent. Unfortunately, when running on a platform like AWS, one
> does not have the luxury of choosing specific hardware.

Many issues here, none of what have changed recently.

One of the common misconceptions about discard is that it will
improve performance. People are lead to think "empty drive" SSD
performance is what they should always get as that is what the
manufacturers quote, not the performance once the drive has been
completely written once. They are also lead to beleive that running
TRIM will restore their drive to "empty drive" performance. This is
not true - for most users, the "overwritten" performance is what
you'll get for the majority of the life of an active drive,
regardless of whether you use TRIM or not.

If you want an idea of how different misleading the performance
expectations manufacturers set for their SSDs, go have a look at the
SSD "performance consistency" tests that are run on all SSDs at
anandtech.com. e.g: Samsung's latest 960 Pro. Quoted at 360,000
random 4k write iops, it can actually only sustain 25,000 random 4k
write iops once the drive has been filled, which only takes a few
minutes to do:

http://www.anandtech.com/show/10754/samsung-960-pro-ssd-review/3

This matches what will happen in the few hours after a TRIM is run
on a SSD under constant write pressure where the filesystem used
space pattern at the time of the fstrim was significantly different
to the SSD's used space pattern. i.e.  fstrim will free up used
space in the SSD which means performance will go up and be fast
(yay!), but as soon as the "known free" area is exhausted it will
fall into the steady state where the garbage collection algorithm
limits performance.

At this point, running fstrim again won't make any difference to
performance unless there are new areas of the block device address
space have been freed by the filesystem. This is because SSD's
record of "used space" still closely matches the filesystem's view
of free space. Hence fstrim will fail to free any significant amount
of space in the SSD it could use to improve performance, and so the
SSD remains in the slow "garbage collection mode" to sustain ongoing
writes.

IOWs, fstrim/discard will not restore any significant SSD
performance unless your application has a very dynamic filesystem
usage pattern (i.e.  regularly fills and empties the filesystem).
That doesn't seem to be the situation your application is running in
("...  our use case [...] file deletes are infrequent .. "), so
maybe you're best to just disable fstrim altogether?

Put simply: fstrim needs to be considered similarly to online
defragmentation - it can be actively harmful to production workloads
when it is used unnecessarily or inappropriately.

> EXT4, on the other hand, tracks blocks that have been deleted since
> the previous FITRIM ioctl

ext4 tracks /block groups/, not blocks. Freeing a single 4k block in
a 128MB block group will mark it for processing on the next fstrim
run. IOWs if you are freeing blocks all over your filesystem between
weekly fstrim runs, ext4 will behave pretty much identically to XFS.

> and targets subsequent TRIM s to the
> appropriate block ranges (see:
> http://blog.taz.net.au/2012/01/07/fstrim-and-xfs/). In real-world
> tests this significantly reduces the impact of fstrim to the point
> that it is un-noticeable to the database / application.

IMO that's a completely meaningless benchmark/comparison. To start
with nobody runs fstrim twice in a row on production systems, so
back-to-back behaviour is irrelevant to us. Also, every test is run
on different hardware so the results simply cannot be compared to
each other. Now if were run on the same hardware, with some kind of
significant workload in between runs it would be slightly more
meaningful.(*)

A lot of the "interwebs knowledge" around discard, fstrim, TRIM, SSD
performance, etc that you find with google is really just cargo-cult
stuff. What impact fstrim is going to have on your SSDs is largely
workload dependent, and the reality is that a large number of
workloads don't have the dynamic allocation behaviour that allows
regular usage of fstrim to provide a meaningful, measurable and
sustained performance improvement.

So, with all that in mind, the first thing you need to do is gather
measurements to determine if SSD performance is actually improved
after running a weekly fstrim. If there's no /significant/ change in
IO latency or throughput, then fstrim is not doing anything useful
for you and you can reduce the frequency at which you run it, only
run it in scheduled maintenance windows, or simply stop using it.

If there is a significant improvement in IO performance as a result
of running fstrim, then we need to work out why your application is
getting stuck during fstrim.  sysrq-w output when fstrim is running
and the application is blocking will tell us where the blocking
issue lies (it may not be XFS!), and along with the various
information about your system here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

we should be able to determine what is causing the blocking and
hence determine if it's fixable or not....

Cheers,

Dave.

(*) This test it'll probably still come out in favour of ext4
because of empty filesystem allocation patterns.  i.e. ext4
allocation is all nice and compact until you dirty all the block
groups in the filesystem, then the allocation patterns become
scattered and non-deterministic. At that point, typical data
intensive workloads will always dirty a significant proportion of
the block groups in the filesystem, and fstrim behaviour becomes
much more like XFS.  XFS's behaviour does not change with workloads
- it only changes as free space patterns changes. Hence it should be
roughly consistent and predictable behaviour for a given free
space pattern regardless of the workload or the age of the
filesystem.

-- 
Dave Chinner
david@fromorbit.com
