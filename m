Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E96C7F4E
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 19:45:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2DF2A30407B
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 17:45:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LDZ5aN9N1c7VDwfG for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 17:45:04 -0700 (PDT)
Date: Tue, 20 May 2014 10:44:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
Message-ID: <20140520004449.GE18954@dastard>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com

[cc xfs@oss.sgi.com]

On Mon, May 19, 2014 at 11:40:46PM +0900, Tetsuo Handa wrote:
> >From f016db5d7f84d6321132150b13c5888ef67d694f Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 19 May 2014 23:24:11 +0900
> Subject: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
> 
> I can observe that commit 35cd7815 "vmscan: throttle direct reclaim when
> too many pages are isolated already" causes RHEL7 environment to stall with
> 0% CPU usage when a certain type of memory pressure is given.
> 
> Upon memory pressure, kswapd calls xfs_vm_writepage() from shrink_page_list().
> xfs_vm_writepage() eventually calls wait_for_completion() which waits for
> xfs_bmapi_allocate_worker().
> 
> Then, a kernel worker thread calls xfs_bmapi_allocate_worker() and
> xfs_bmapi_allocate_worker() eventually calls xfs_btree_lookup_get_block().
> xfs_btree_lookup_get_block() eventually calls alloc_page().
> alloc_page() eventually calls shrink_inactive_list().
> 
> The stack trace showed that the kernel worker thread which the kswapd is
> waiting for was looping at a while loop in shrink_inactive_list().

[snip stack traces indicating XFS is deferring allocation work to the
allocation workqueue on behalf of kswapd]

> Since the kernel worker thread needs to escape from the while loop so that
> alloc_page() can allocate memory (and eventually allow xfs_vm_writepage()
> to release memory), I think that we should not block forever. This patch
> introduces 30 seconds timeout for userspace processes and 5 seconds timeout
> for kernel processes.

That's like trying to swat a fly with a runaway train. Eventually
you'll hit the fly with the train....

Q: What is missing from the workqueue context that results
in the workqueue being blocked in memory reclaim on congestion?

Hint: XFS is deferring allocation on behalf of kswapd to a
workqueue.

A: PF_KSWAPD.  shrink_inactive_list() has this guard:

        /*
         * Stall direct reclaim for IO completions if underlying BDIs or zone
         * is congested. Allow kswapd to continue until it starts encountering
         * unqueued dirty pages or cycling through the LRU too quickly.
         */
        if (!sc->hibernation_mode && !current_is_kswapd())
                wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);


So, XFS should be passing kswapd context to the workqueue allocation
context. The patch below does this.

Tetsuo-san, when it comes to problems involving XFS, you should
really CC xfs@oss.sgi.com because very few people really know how
XFS works and even fewer still know how it is supposed to interact
with memory reclaim....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: block allocation work needs to be kswapd aware

From: Dave Chinner <dchinner@redhat.com>

Upon memory pressure, kswapd calls xfs_vm_writepage() from
shrink_page_list(). This can result in delayed allocation occurring
and that gets deferred to the the allocation workqueue.

The allocation then runs outside kswapd context, which means if it
needs memory (and it does to demand page metadata from disk) it can
block in shrink_inactive_list() waiting for IO congestion. These
blocking waits are normally avoiding in kswapd context, so under
memory pressure writeback from kswapd can be arbitrarily delayed by
memory reclaim.

To avoid this, pass the kswapd context to the allocation being done
by the workqueue, so that memory reclaim understands correctly that
the work is being done for kswapd and therefore it is not blocked
and does not delay memory reclaim.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 16 +++++++++++++---
 fs/xfs/xfs_bmap_util.h |  1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 057f671..703b3ec 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -258,14 +258,23 @@ xfs_bmapi_allocate_worker(
 	struct xfs_bmalloca	*args = container_of(work,
 						struct xfs_bmalloca, work);
 	unsigned long		pflags;
+	unsigned long		new_pflags = PF_FSTRANS;
 
-	/* we are in a transaction context here */
-	current_set_flags_nested(&pflags, PF_FSTRANS);
+	/*
+	 * we are in a transaction context here, but may also be doing work
+	 * in kswapd context, and hence we may need to inherit that state
+	 * temporarily to ensure that we don't block waiting for memory reclaim
+	 * in any way.
+	 */
+	if (args->kswapd)
+		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+
+	current_set_flags_nested(&pflags, new_pflags);
 
 	args->result = __xfs_bmapi_allocate(args);
 	complete(args->done);
 
-	current_restore_flags_nested(&pflags, PF_FSTRANS);
+	current_restore_flags_nested(&pflags, new_pflags);
 }
 
 /*
@@ -284,6 +293,7 @@ xfs_bmapi_allocate(
 
 
 	args->done = &done;
+	args->kswapd = current_is_kswapd();
 	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 935ed2b..d227f9d 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -56,6 +56,7 @@ struct xfs_bmalloca {
 	char			aeof;	/* allocated space at eof */
 	char			conv;	/* overwriting unwritten extents */
 	char			stack_switch;
+	char			kswapd;	/* allocation in kswapd context */
 	int			flags;
 	struct completion	*done;
 	struct work_struct	work;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
