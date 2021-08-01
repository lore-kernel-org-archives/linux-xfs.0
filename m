Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07285C4338F
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 23:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF4E061042
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 23:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhHAXrW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 19:47:22 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:38756 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230368AbhHAXrW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 19:47:22 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id B309B8426F;
        Mon,  2 Aug 2021 09:47:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mALAj-00DSGc-Pc; Mon, 02 Aug 2021 09:47:09 +1000
Date:   Mon, 2 Aug 2021 09:47:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/20] xfs: defer inode inactivation to a workqueue
Message-ID: <20210801234709.GD2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210730042400.GB2757197@dread.disaster.area>
 <20210731042112.GM3601443@magnolia>
 <20210801214910.GC2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210801214910.GC2757197@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8
        a=dE6K4cpdCjOv5uqLm9YA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 02, 2021 at 07:49:10AM +1000, Dave Chinner wrote:
> On Fri, Jul 30, 2021 at 09:21:12PM -0700, Darrick J. Wong wrote:
> > On Fri, Jul 30, 2021 at 02:24:00PM +1000, Dave Chinner wrote:
> > > On Thu, Jul 29, 2021 at 11:44:10AM -0700, Darrick J. Wong wrote:
> > And since the shrinkers are always a source of amusement, what /is/ up
> > with it?  I don't really like having to feed it magic numbers just to
> > get it to do what I want, which is ... let it free some memory in the
> > first round, then we'll kick the background workers when the priority
> > bumps (er, decreases), and hope that's enough not to OOM the box.
> 
> Well, the shrinkers are intended as a one-shot memory pressure
> notification as you are trying to use them. They are intended to be
> told the amount of work that needs to be done to free memory, and
> they they calculate how much of that work should be done based on
> it's idea of the current level of memory pressure.
> 
> One shot shrinker triggers never tend to work well because they
> treat all memory pressure the same - very light memory pressure is
> dead with by the same big hammer than deals with OOM levels of
> memory pressure.
> 
> As it is, I'm more concerned right now with finding out why there's
> such large performance regressions in highly concurrent recursive
> chmod/unlink workloads. I spend most of friday looking at it trying
> to work out what behaviour was causing the regression, but I haven't
> isolated it yet.

So I pulled all of my patchsets out and I'm just looking at the
deferred inactivation changes now. rm -rf triggers a profile like:

-   68.94%     3.24%  [kernel]            [k] xlog_cil_commit
   - 65.70% xlog_cil_commit
      - 55.01% _raw_spin_lock
         - do_raw_spin_lock
              54.14% __pv_queued_spin_lock_slowpath
        2.26% memcpy_erms
      - 1.60% xfs_buf_item_committing
         - 1.57% xfs_buf_item_release
            - 0.70% xfs_buf_unlock
                 0.67% up
              0.57% xfs_buf_rele
        1.09% xfs_buf_item_format
      - 0.90% _raw_spin_unlock
         - 0.80% do_raw_spin_unlock
              0.61% __raw_callee_save___pv_queued_spin_unlock
      - 0.81% xfs_buf_item_size
           0.57% xfs_buf_item_size_segment.isra.0
        0.67% xfs_inode_item_format

And the path into here is split almost exactly 50/50 between
xfs_remove() (process context) and xfs_inactive (deferred context).

+   40.85%     0.02%  [kernel]            [k] xfs_remove
+   40.61%     0.00%  [kernel]            [k] xfs_inodegc_worker

rm -rf runtime without the patchset is 2m30s, but 3m41s with it.

So, essentially, the background inactivation increases the
concurrency through the transaction commit path and causes a massive
increase in CIL push lock contention (i.e. catastrophic lock
breakdown) which makes performance go backwards.

Nothing can be done about this except, well, merge the CIL
scalability patches in my patch stack that address this exact lock
contention problem.

> I suspect that it is lockstepping between user
> processes and background inactivation for the unlink - I'm seeing
> the backlink rhashtable show up in the profiles which indicates the
> unlinked list lengths are an issue and we're lockstepping the AGI.
> It also may simply be that there is too much parallelism hammering
> the transaction subsystem now....

The reason I've been seeing different symptoms is that my CIL
scalability patchset entirely eliminates this spinlock contention
and something else less obvious becomes the performance limiting
factor. i.e. the CPU profile looks like this instead:

+   33.33%     0.00%  [kernel]            [k] xfs_inodegc_worker
+   26.45%     5.49%  [kernel]            [k] xlog_cil_commit
+   23.13%     0.04%  [kernel]            [k] xfs_remove

And runtime is a little lower (3m20s) but still not "fast". The fact
that CPU time has gone down so much results in idle time  and
indicates we are now contending on a sleeping lock as the context
swtich profile indicates:

+   36.23%     0.00%  [kernel]            [k] xfs_buf_read_map
....
+   22.99%     0.00%  [kernel]            [k] down
+   22.99%     0.00%  [kernel]            [k] __down
+   22.99%     0.00%  [kernel]            [k] xfs_read_agi
....
+   11.83%     0.00%  [kernel]            [k] xfs_imap_to_bp

Over a third of the context switches are on locked buffers, 2/3s of
tehm on AGI buffers, and the rest are mostly on inode inode cluster
buffers likely doing unlinked list modifications.

IOWs, we traded CIL push lock contention for AGI and inode cluster
buffer lock stepping between the unlink() syscall context and the
background inactivation processes.

This isn't a new problem - I've known about it for years, and I have
been working towards solving it (e.g. the single unlinked list per
AGI patches).  In effect, the problem is that we always add newly
unlinked to the head - the AGI end - of the unlinked lists, so we
must always take the AGI lock in unlink() context just to update the
unlinked list. On the inactivation side, we always have to take the
AGI because we are freeing inodes.

With deferred inactivation, the unlinked lists grow large, so we
could avoid needing to modify the AGI by adding inodes to the tail
of the unlinked list instead of the head. Unfortunately, to do this
we currently need to store 64 agino tail pointers per AGI in memory.
I might try modifying my patches to do this so I can re-order the
unlinked list without needing to change on disk format. It's not
very data cache or memory efficient, but it likely will avoid most
of the AGI contention on these workloads.

However, none of this is ready for prime time, so the next thing
I'll look at is why both foreground and background are running at
the same time instead of batching effectively. i.e. unlink context
runs a bunch of unlinks adding inodes to the unlinked lists, then
background runs doing the deferred work while foreground stays out
of the way (e.g. is throttled). This will involve looking at traces,
so I suspect it's going to take me a day or two to extract repeating
patterns and understand them well enough to determine what to
do/look at next.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
