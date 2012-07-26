Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8WnTD000397 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:32:50 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gMBri6H43SE6Q8qV for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:32:46 -0700 (PDT)
Date: Thu, 26 Jul 2012 18:32:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A little RAID experiment
Message-ID: <20120726083242.GA2877@dastard>
References: <20120717052621.GB23387@dastard>
	<50061CEA.4070609@hardwarefreak.com>
	<CAAxjCEwgDKLF=RY0aCCNTMsc1oefXWfyHKh+morYB9zVUrnH-A@mail.gmail.com>
	<50066115.7070807@hardwarefreak.com>
	<CAAxjCExFUJOKaD-LMPfZvCrS34V1VHgtrhgvPP0jZ3Hm1YV=6g@mail.gmail.com>
	<50068EC5.5020704@hardwarefreak.com>
	<CAAxjCEy2Yj=XWctNg2gACbFy81aTu70YJ13Ee8G6-E3Tqvvs7g@mail.gmail.com>
	<CAAxjCEzF3nTFoedyKf1o5Nv4yPUJkgvC8nCJcx_2dDx8xqWtWA@mail.gmail.com>
	<50077A34.5070304@hardwarefreak.com>
	<CAAxjCEy=N9ceAA5V6bnrcMc3961gs-Z2NgNyenPJ+gjE2mYUXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCEy=N9ceAA5V6bnrcMc3961gs-Z2NgNyenPJ+gjE2mYUXQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Wed, Jul 25, 2012 at 11:29:58AM +0200, Stefan Ring wrote:
> In this particular case, performance was conspicuously poor, and after
> some digging with blktrace and seekwatcher, I identified the cause of
> this slowness to be a write pattern that looked like this (in block
> numbers), where the step width (arbitrarily displayed as 10000 here
> for illustration purposes) was 1/4 of the size of the volume, clearly
> because the volume had 4 allocation groups (the default). Of course it
> was not entirely regular, but overall it was very similar to this:
> 
> 10001
> 20001
> 30001
> 40001
> 10002
> 20002
> 30002
> 40002
> 10003
> 20003
> ...

That's the problem you should have reported. Not something
artificial from a benchmark. What you seemed to report was a "random
writes behave differently on different RAID setups, not that
"writeback is not sorting efficiently".

Indeed, if the above is metadata, then there's something really
weird going on, because metadata writeback is not sorted that way by
XFS, and nothing should cause writeback in that style. i.e. if it is
metadata, it shoul dbe:

10001 (queue)
10002 (merge)
10003 (merge)
....
20001 (queue)
20002 (merge)
20003 (merge)
....

and so on for any metadata dispatched in close temporal proximity.

If it is data writeback, then there's still something funny going on
as it implies that the temporal data locality the allocator
providing is non-existent. i.e. inodes that are dirtied sequentially
in the same directory should be written in the same order and
allocation should be to a similar region on disk. Hence you should
get similar IO patterns to the metadata, though not as well formed.

Using xfs_bmap will tell you where the files are located, and often
comparing c/mtime will tell you th order in which files were
written. That can tell you whether data allocation was jumping all
over the place or not...

> It has been pointed out that XFS schedules the writes like this on
> purpose so that they can be done in parallel,

XFs doesn't schedule writes like that - it only spreads the
allocation out. writeback and the IO elevators are what do the IO
scheduling, and sometimes they don't play nicely with XFS.

If you create files in this manner:

/a/file1
/b/file1
/c/file1
/d/file1
/a/file2
/b/file2
....

Then writeback is going to schedule them in the same order, and that
will result in IO being rotored across all AGs because writeback
retains the creation/dirtying order. There's only so much reordering
that can be done when writes are scheduled like this.

If you create files like this:

/a/file1
/a/file2
/a/file3
.....
/b/file1
/b/file2
/b/file3
.....

The writeback will issue them in that order, and data allocation
will be contiguous and hence writes much more sequential.

This is often a problem with naive multi-threaded applications - the
thought that more IO in flight will be faster than what a single
thread can do. If you cause IO to interleave like above, then it
won't go faster and could turn sequential workloads into random IO
workloads.

OTOH, well designed applications can take advantage of XFS's
segregation and scale IO linearly by a combination of careful
placement and scalable block device design (e.g. a concat rather
than a flat stripe).

But, I really don't knwo what you application is - all I know
is that you used sysbench to generate random IO that showed similar
problems. posting the blktraces for us to analyse ourselves
(I can tell an awful lot from repeating patterns of block
numbers and IO sizes) rather than telling use what you saw is an
example of what we need to see to understand your problem. This
pretty much says it all:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> and that I should create
> a concatenated volume with physical devices matching the allocation
> groups. I actually went through this exercise, and yes, it was very
> beneficial, but that's not the point. I don't want to (have to) do
> that.

If you want to maximise storage performance, then that's what you do
for certain workloads. Saying "I want" fllowed by  "I'm too lazy to
do that, but I still want" won't get you very far....

> And it's not always feasible, anyway. What about home usage with
> a single SATA disk? Is it not worthwile to perform well on low-end
> devices?

Not really.  XFS is mostly optimised for large scale HPC and enterprise
workloads and hardware. The only small scale system optimisations we
make are generally for your cheap 1-4 disk ARM/MIPS based NAS
devices. The workloads on those are effectively a server workload
anyway, so most of the optimisations we make benefit them as well.

As for desktops, well, it's fast enough for my workstation and
laptop, so I don't really care much more than that.. ;)

> You might ask then, why even bother using XFS instead of ext4?

No, I don't. If ext4 is better or XFS is too much trouble for you,
then it is better for you to use ext4. No-one here will argue
against you doing that - use what works for you.

However, if you do use XFS, and ask for advice, then it pays to
listen to the people who respond because they tend to be power users
with lots of experience or subject matter experts.....

> I care about the multi-user case. The problem I have with ext is that
> it is unbearably unresponsive when someone writes a semi-large amount
> of data (a few gigs) at once -- like extracting a large-ish tarball.
> Just using vim, even with :set nofsync, is almost impossible during
> that time. I have adopted various disgusting hacks like extracting to
> a ramdisk instead and rsyncing the lot over to the real disk with a
> very low --bwlimit, but I'm thoroughly fed up with this kind of crap,
> and in general, XFS works very well.
> 
> If noone cares about my findings, I will henceforth be quiet on this topic.

I care about the problems you are having, but I don't care about a
-simulation- of what you think is the problem. Report the real
problem (data allocation or writeback is not sequential when it
should be) and we might be able to get to the bottom of your issue.

Report a simulation of an issue, and we'll just tell you what is
wrong with your simulation (i.e. random IO and RAID5/6 don't mix. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
