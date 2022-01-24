Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE1EC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 22:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbiAXWRr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 17:17:47 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43437 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1580166AbiAXWJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 17:09:04 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 950A110C477B;
        Tue, 25 Jan 2022 09:08:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nC7W9-003nvk-Ai; Tue, 25 Jan 2022 09:08:53 +1100
Date:   Tue, 25 Jan 2022 09:08:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220124220853.GN59729@dread.disaster.area>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye6/g+XMSyp9vYvY@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61ef2377
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=wgKFQiR74xbiopXbU28A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 24, 2022 at 10:02:27AM -0500, Brian Foster wrote:
> On Fri, Jan 21, 2022 at 09:24:54AM -0500, Brian Foster wrote:
> > The XFS inode allocation algorithm aggressively reuses recently
> > freed inodes. This is historical behavior that has been in place for
> > quite some time, since XFS was imported to mainline Linux. Once the
> > VFS adopted RCUwalk path lookups (also some time ago), this behavior
> > became slightly incompatible because the inode recycle path doesn't
> > isolate concurrent access to the inode from the VFS.
> > 
> > This has recently manifested as problems in the VFS when XFS happens
> > to change the type or properties of a recently unlinked inode while
> > still involved in an RCU lookup. For example, if the VFS refers to a
> > previous incarnation of a symlink inode, obtains the ->get_link()
> > callback from inode_operations, and the latter happens to change to
> > a non-symlink type via a recycle event, the ->get_link() callback
> > pointer is reset to NULL and the lookup results in a crash.
> > 
> > To avoid this class of problem, isolate in-core inodes for recycling
> > with an RCU grace period. This is the same level of protection the
> > VFS expects for inactivated inodes that are never reused, and so
> > guarantees no further concurrent access before the type or
> > properties of the inode change. We don't want an unconditional
> > synchronize_rcu() event here because that would result in a
> > significant performance impact to mixed inode allocation workloads.
> > 
> > Fortunately, we can take advantage of the recently added deferred
> > inactivation mechanism to mitigate the need for an RCU wait in most
> > cases. Deferred inactivation queues and batches the on-disk freeing
> > of recently destroyed inodes, and so significantly increases the
> > likelihood that a grace period has elapsed by the time an inode is
> > freed and observable by the allocation code as a reuse candidate.
> > Capture the current RCU grace period cookie at inode destroy time
> > and refer to it at allocation time to conditionally wait for an RCU
> > grace period if one hadn't expired in the meantime.  Since only
> > unlinked inodes are recycle candidates and unlinked inodes always
> > require inactivation, we only need to poll and assign RCU state in
> > the inactivation codepath. Slightly adjust struct xfs_inode to fit
> > the new field into padding holes that conveniently preexist in the
> > same cacheline as the deferred inactivation list.
> > 
> > Finally, note that the ideal long term solution here is to
> > rearchitect bits of XFS' internal inode lifecycle management such
> > that this additional stall point is not required, but this requires
> > more thought, time and work to address. This approach restores
> > functional correctness in the meantime.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > Here's the RCU fixup patch for inode reuse that I've been playing with,
> > re: the vfs patch discussion [1]. I've put it in pretty much the most
> > basic form, but I think there are a couple aspects worth thinking about:
> > 
> > 1. Use and frequency of start_poll_synchronize_rcu() (vs.
> > get_state_synchronize_rcu()). The former is a bit more active than the
> > latter in that it triggers the start of a grace period, when necessary.
> > This currently invokes per inode, which is the ideal frequency in
> > theory, but could be reduced, associated with the xfs_inogegc thresholds
> > in some manner, etc., if there is good reason to do that.
> > 
> > 2. The rcu cookie lifecycle. This variant updates it on inactivation
> > queue and nowhere else because the RCU docs imply that counter rollover
> > is not a significant problem. In practice, I think this means that if an
> > inode is stamped at least once, and the counter rolls over, future
> > (non-inactivation, non-unlinked) eviction -> repopulation cycles could
> > trigger rcu syncs. I think this would require repeated
> > eviction/reinstantiation cycles within a small window to be noticeable,
> > so I'm not sure how likely this is to occur. We could be more defensive
> > by resetting or refreshing the cookie. E.g., refresh (or reset to zero)
> > at recycle time, unconditionally refresh at destroy time (using
> > get_state_synchronize_rcu() for non-inactivation), etc.
> > 
> > Otherwise testing is ongoing, but this version at least survives an
> > fstests regression run.
> > 
> 
> FYI, I modified my repeated alloc/free test to do some batching and form
> it into something more able to measure the potential side effect / cost
> of the grace period sync. The test is a single threaded, file alloc/free
> loop using a variable per iteration batch size. The test runs for ~60s
> and reports how many total files were allocated/freed in that period
> with the specified batch size. Note that this particular test ran
> without any background workload. Results are as follows:
> 
> 	files		baseline	test
> 
> 	1		38480		38437
> 	4		126055		111080
> 	8		218299		134469
> 	16		306619		141968
> 	32		397909		152267
> 	64		418603		200875
> 	128		469077		289365
> 	256		684117		566016
> 	512		931328		878933
> 	1024		1126741		1118891

Can you post the test code, because 38,000 alloc/unlinks in 60s is
extremely slow for a single tight open-unlink-close loop. I'd be
expecting at least ~10,000 alloc/unlink iterations per second, not
650/second.

A quick test here with "batch size == 1" main loop on a vanilla
5.17-rc1 kernel:

        for (i = 0; i < iters; i++) {
                int fd = open(file, O_CREAT|O_RDWR, 0777);

                if (fd < 0) {
                        perror("open");
                        exit(1);
                }
                unlink(file);
                close(fd);
        }


$ time ./open-unlink 10000 /mnt/scratch/blah

real    0m0.962s
user    0m0.022s
sys     0m0.775s

Shows pretty much 10,000 alloc/unlinks a second without any specific
batching on my slow machine. And my "fast" machine (3yr old 2.1GHz
Xeons)

$ time sudo ./open-unlink 40000 /mnt/scratch/foo

real    0m0.958s
user    0m0.033s
sys     0m0.770s

Runs single loop iterations at 40,000 alloc/unlink iterations per
second.

So I'm either not understanding the test you are running and/or the
kernel/patches that you are comparing here. Is the "baseline" just a
vanilla, unmodified upstream kernel, or something else?

> That's just a test of a quick hack, however. Since there is no real
> urgency to inactivate an unlinked inode (it has no potential users until
> it's freed),

On the contrary, there is extreme urgency to inactivate inodes
quickly.

Darrick made the original assumption that we could delay
inactivation indefinitely and so he allowed really deep queues of up
to 64k deferred inactivations. But with queues this deep, we could
never get that background inactivation code to perform anywhere near
the original synchronous background inactivation code. e.g. I
measured 60-70% performance degradataions on my scalability tests,
and nothing stood out in the profiles until I started looking at
CPU data cache misses.

What we found was that if we don't run the background inactivation
while the inodes are still hot in the CPU cache, the cost of bring
the inodes back into the CPU cache at a later time is extremely
expensive and cannot be avoided. That's where all the performance
was lost and so this is exactly what the current per-cpu background
inactivation implementation avoids. i.e. we have shallow queues,
early throttling and CPU affinity to ensure that the inodes are
processed before they are evicted from the CPU caches and ensure we
don't take a performance hit.

IOWs, the deferred inactivation queues are designed to minimise
inactivation delay, generally trying to delay inactivation for a
couple of milliseconds at most during typical fast-path
inactivations (i.e. an extent or two per inode needing to be freed,
plus maybe the inode itself). Such inactivations generally take
50-100us of CPU time each to process, and we try to keep the
inactivation batch size down to 32 inodes...

> I suspect that result can be further optimized to absorb
> the cost of an rcu delay by deferring the steps that make the inode
> available for reallocation in the first place.

A typical RCU grace period delay is longer than the latency we
require to keep the inodes hot in cache for efficient background
inactivation. We can't move the "we need to RCU delay inactivation"
overhead to the background inactivation code without taking a
global performance hit to the filesystem performance due to the CPU
cache thrashing it will introduce....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
