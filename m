Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50372 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727527AbfA3ERV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 23:17:21 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] [REGRESSION v4.19-20] mm: shrinkers are now way too aggressive
Date: Wed, 30 Jan 2019 15:17:05 +1100
Message-Id: <20190130041707.27750-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: guro@fb.com, akpm@linux-foundation.org, mhocko@kernel.org, vdavydov.dev@gmail.com

Hi mm-folks,

TL;DR: these two commits break system wide memory VFS cache reclaim
balance badly, cause severe performance regressions in stable
kernels and they need to be reverted ASAP.

For background, let's start with the bug reports that have come from
desktop users on 4.19 stable kernels. First this one:

https://bugzilla.kernel.org/show_bug.cgi?id=202349

Whereby copying a large amount of data to files on an XFS filesystem
would cause the desktop to freeze for multiple seconds and,
apparently occasionally hang completely. Basically, GPU based
GFP_KERNEL allocations getting stuck in shrinkers under realtively
light memory loads killing desktop interactivity. Kernel 4.19.16

The second:

https://bugzilla.kernel.org/show_bug.cgi?id=202441

Whereby copying a large data set across NFS filesystems at the same
time as running a kernel compile on a local XFS filesystem results
in the kernel compile going from 3m30s to over an hour and file copy
performance tanking.

We ran an abbreviated bisect from 4.18 through to 4.19.18, and found
two things:

	1: there was a major change in page cache reclaim behaviour
	introduced in 4.19-rc5. Basically the page cache would get
	trashed periodically for no apparent reason, the
	characteristic being a sawtooth cache usage pattern.

	2: in 4.19.3, kernel compile performance turned to crap.

The kernel compile regression is essentially caused by memory
reclaim driving the XFS inode shrinker hard in to reclaiming dirty
inodes and getting blocked, essentially slowing reclaim down to the
rate at which a slow SATA drive could write back inodes. There were
also indications of a similar GPU-based GFP_KERNEL allocation
stalls, but most of the testing was done from the CLI with no X so
that could be discounted.

It was reported that less severe slowdowns also occurred on ext2,
ext3, ext4 and jfs, so XFS is really just the messenger here - it is
most definitely not the cause of the problem being seen, so stop and
thing before you go and blame XFS.

Looking at the change history of the mm/ subsystem after the first
bug report, I noticed and red-flagged this commit for deeper
analysis:

172b06c32b94 ("mm: slowly shrink slabs with a relatively small number of objects")

That "simple" change ran a read flag because it makes shrinker
reclaim far, far more agressive at initial priority reclaims (ie..
reclaim priority = 12). And it also means that small caches that
don't need reclaim (because they are small) will be agressively
scanned and reclaimed when there is very little memory pressure,
too. It also means tha tlarge caches are reclaimed very agressively
under light memory pressure - pressure that would have resulted in
single digit scan count now gets run out to batch size, which for
filesystems is 1024 objects. i.e. we increase reclaim filesystem
superblock shrinker pressure by an order of 100x at light reclaim.

That's a *bad thing* because it means we can't retain working sets
of small caches even under light memory pressure - they get
excessively reclaimed in comparison to large caches instead of in
proptortion to the rest of the system caches.

So, yeah, red flag. Big one. And the patch never got sent to
linux-fsdevel so us filesystem people didn't ahve any idea that
there were changes to VFS cache balances coming down the line. Hence
our users reporting problems ar the first sign we get of a
regression...

So when Roger reported that the page cache behaviour changed
massively in 4.19-rc5, and I found that commit was between -rc4 and
-rc5? Yeah, that kinda proved my theory that it changed the
fundamental cache balance of the system and the red flag is real...

So, the second, performance killing change? Well, I think you all
know what's coming:

a76cf1a474d7 mm: don't reclaim inodes with many attached pages

[ Yup, a "MM" tagged patch that changed code in fs/inode.c and wasn't
cc'd to any fileystem list. There's a pattern emerging here. Did
anyone think to cc the guy who originally designed ithe numa aware
shrinker infrastucture and helped design the memcg shrinker
infrastructure on fundamental changes? ]

So, that commit was an attempt to fix the shitty behaviour
introduced by 172b06c32b94 - it's a bandaid over a symptom rather
than something that attempts to correct the actual bug that was
introduced. i.e. the increased inode cache reclaim pressure was now
reclaiming inodes faster than the page cache reclaim was reclaiming
pages on the inode, and so inode cache reclaim is trashing the
working set of the page cache.

This is actually necessary behaviour - when you have lots of
temporary inodes and are turning the inode cache over really fast
(think recursive grep) we want the inode cache to immediately
reclaim the cached pages on the inode because it's typically a
single use file. Why wait for the page cache to detect it's single
use when we already know it's not part of the working file set?

And what's a kernel compile? it's a recursive read of a large number
of files, intermixed with the creation of a bunch of temporary
files.  What happens when you have a mixed large file workload
(background file copy) and lots of small files being created and
removed (kernel compile)?

Yup, we end up in a situation where inode reclaim can no longer
reclaim clean inodes because they have cached pages, yet page reclaim
doesn't keep up  in reclaiming pages because it hasn't realised they
are single use pages yet and hence don't get reclaimed. And
because the page cache preossure is relatively light, we are
putting a huge amount of scanning pressure put on the shrinkers.

The result is the shrinkers are driven into corners where they try
*really hard* to free objects because there's nothing left that is
easy to reclaim. e.g. it drives the XFS inode cache shrinker into
"need to clean dirty reclaimable inodes" land on workloads where the
working set of cached inodes should never, ever get anywhere near
that threshold because there are hge amounts of clean pages and
inodes that should have been reclaimed first.

IOWs, the fix to prevent inode cache reclaim from reclaiming inodes
with pages attached to them essentially breaks a key page cache
memory reclaim interlock that our systems have implicitly depended
on for ages.

And, in reality, changing fundamental memory reclaim balance is not
the way to fix a "dying memcg" memory leak. Trying to solve a "we've
got referenced memory we need to clean up" by faking memory
pressure and winding up shrinker based reclaim so dying memcg's are
reclaimed fast is, well, just insane. It's a nasty hack at best.

e.g. add a garbage collector via a background workqueue that sits on
the dying memcg calling something like:

void drop_slab_memcg(struct mem_cgroup *dying_memcg)
{
        unsigned long freed;

        do {
                struct mem_cgroup *memcg = NULL;

                freed = 0;
                memcg = mem_cgroup_iter(dying_memcg, NULL, NULL);
                do {
                        freed += shrink_slab_memcg(GFP_KERNEL, 0, memcg, 0);
                } while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
        } while (freed > 0);
}

(or whatever the NUMA aware, rate limited variant should really be)

so that it kills off all the slab objects accounted to the memcg
as quickly as possible? The memcg teardown code is full of these
"put it on a work queue until something goes away and calls the next
teardown function" operations, so it makes no sense to me to be
relying on system wide memory pressure to drive this reclaim faster.

Sure, it won't get rid of all of the dying memcgs all of the time,
but it's a hell of a lot better changing memory reclaim behaviour
and cache balance for everyone to fix what is, at it's core, a memcg
lifecycle problem, not a memory reclaim problem.

So, revert these broken, misguided commits ASAP, please.

-Dave.
