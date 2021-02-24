Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10D3C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 23:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D1C64F08
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 23:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhBXX0y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 18:26:54 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:48901 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbhBXX0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 18:26:50 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 13A6EE6AD6B
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 10:26:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF3Xc-002rG7-8F
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 10:26:00 +1100
Date:   Thu, 25 Feb 2021 10:26:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <20210224232600.GH4662@dread.disaster.area>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224211058.GA4662@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8
        a=oW3eqA5bG7hND0V6Ct8A:9 a=SngZyxhye2qizxjI:21 a=vbibiMn7O4cIS_wX:21
        a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The AIL pushing is stalling on log forces when it comes across
pinned items. This is happening on removal workloads where the AIL
is dominated by stale items that are removed from AIL when the
checkpoint that marks the items stale is committed to the journal.
This results is relatively few items in the AIL, but those that are
are often pinned as directories items are being removed from are
still being logged.

As a result, many push cycles through the CIL will first issue a
blocking log force to unpin the items. This can take some time to
complete, with tracing regularly showing push delays of half a
second and sometimes up into the range of several seconds. Sequences
like this aren't uncommon:

....
 399.829437:  xfsaild: last lsn 0x11002dd000 count 101 stuck 101 flushing 0 tout 20
<wanted 20ms, got 270ms delay>
 400.099622:  xfsaild: target 0x11002f3600, prev 0x11002f3600, last lsn 0x0
 400.099623:  xfsaild: first lsn 0x11002f3600
 400.099679:  xfsaild: last lsn 0x1100305000 count 16 stuck 11 flushing 0 tout 50
<wanted 50ms, got 500ms delay>
 400.589348:  xfsaild: target 0x110032e600, prev 0x11002f3600, last lsn 0x0
 400.589349:  xfsaild: first lsn 0x1100305000
 400.589595:  xfsaild: last lsn 0x110032e600 count 156 stuck 101 flushing 30 tout 50
<wanted 50ms, got 460ms delay>
 400.950341:  xfsaild: target 0x1100353000, prev 0x110032e600, last lsn 0x0
 400.950343:  xfsaild: first lsn 0x1100317c00
 400.950436:  xfsaild: last lsn 0x110033d200 count 105 stuck 101 flushing 0 tout 20
<wanted 20ms, got 200ms delay>
 401.142333:  xfsaild: target 0x1100361600, prev 0x1100353000, last lsn 0x0
 401.142334:  xfsaild: first lsn 0x110032e600
 401.142535:  xfsaild: last lsn 0x1100353000 count 122 stuck 101 flushing 8 tout 10
<wanted 10ms, got 10ms delay>
 401.154323:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x1100353000
 401.154328:  xfsaild: first lsn 0x1100353000
 401.154389:  xfsaild: last lsn 0x1100353000 count 101 stuck 101 flushing 0 tout 20
<wanted 20ms, got 300ms delay>
 401.451525:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x0
 401.451526:  xfsaild: first lsn 0x1100353000
 401.451804:  xfsaild: last lsn 0x1100377200 count 170 stuck 22 flushing 122 tout 50
<wanted 50ms, got 500ms delay>
 401.933581:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x0
....

In each of these cases, every AIL pass saw 101 log items stuck on
the AIL (pinned) with very few other items being found. Each pass, a
log force was issued, and delay between last/first is the sleep time
+ the sync log force time.

Some of these 101 items pinned the tail of the log. The tail of the
log does slowly creep forward (first lsn), but the problem is that
the log is actually out of reservation space because it's been
running so many transactions that stale items that never reach the
AIL but consume log space. Hence we have a largely empty AIL, with
long term pins on items that pin the tail of the log that don't get
pushed frequently enough to keep log space available.

The problem is the hundreds of milliseconds that we block in the log
force pushing the CIL out to disk. The AIL should not be stalled
like this - it needs to run and flush items that are at the tail of
the log with minimal latency. What we really need to do is trigger a
log flush, but then not wait for it at all - we've already done our
waiting for stuff to complete when we backed off prior to the log
force being issued.

Even if we remove the XFS_LOG_SYNC from the xfs_log_force() call, we
still do a blocking flush of the CIL and that is what is causing the
issue. Hence we need a new interface for the CIL to trigger an
immediate background push of the CIL to get it moving faster but not
to wait on that to occur. While the CIL is pushing, the AIL can also
be pushing.

We already have an internal interface to do this -
xlog_cil_push_now() - but we need a wrapper for it to be used
externally. xlog_cil_force_seq() can easily be extended to do what
we need as it already implements the synchronous CIL push via
xlog_cil_push_now(). Add the necessary flags and "push current
sequence" semantics to xlog_cil_force_seq() and convert the AIL
pushing to use it.

One of the complexities here is that the CIL push does not guarantee
that the commit record for the CIL checkpoint is written to disk.
The current log force ensures this by submitting the current ACTIVE
iclog that the commit record was written to. We need the CIL to
actually write this commit record to disk for an async push to
ensure that the checkpoint actually makes it to disk and unpins the
pinned items in the checkpoint on completion. Hence we need to pass
down to the CIL push that we are doing an async flush so that it can
switch out the commit_iclog if necessary to get written to disk when
the commit iclog is finally released.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
Version 2:
- ensure the CIL checkpoint issues the commit record to disk for an
  async push. Fixes generic/530 hang on small logs.
- increment log force stats when the CIL is forced and also when it
  sleeps to give insight into the amount of blocking being done when
  the CIL is forced.

 fs/xfs/xfs_log.c       | 59 +++++++++++++++++++---------------------------
 fs/xfs/xfs_log.h       |  2 +-
 fs/xfs/xfs_log_cil.c   | 64 +++++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_log_priv.h  | 10 ++++++--
 fs/xfs/xfs_sysfs.c     |  1 +
 fs/xfs/xfs_trace.c     |  1 +
 fs/xfs/xfs_trans.c     |  2 +-
 fs/xfs/xfs_trans_ail.c | 11 ++++++---
 8 files changed, 97 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 84cd9b6c6d1f..51acc0075699 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -50,11 +50,6 @@ xlog_state_get_iclog_space(
 	int			*continued_write,
 	int			*logoffsetp);
 STATIC void
-xlog_state_switch_iclogs(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	int			eventual_size);
-STATIC void
 xlog_grant_push_ail(
 	struct xlog		*log,
 	int			need_bytes);
@@ -511,7 +506,7 @@ __xlog_state_release_iclog(
  * Flush iclog to disk if this is the last reference to the given iclog and the
  * it is in the WANT_SYNC state.
  */
-static int
+int
 xlog_state_release_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
@@ -531,23 +526,6 @@ xlog_state_release_iclog(
 	return 0;
 }
 
-void
-xfs_log_release_iclog(
-	struct xlog_in_core	*iclog)
-{
-	struct xlog		*log = iclog->ic_log;
-	bool			sync = false;
-
-	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
-		if (iclog->ic_state != XLOG_STATE_IOERROR)
-			sync = __xlog_state_release_iclog(log, iclog);
-		spin_unlock(&log->l_icloglock);
-	}
-
-	if (sync)
-		xlog_sync(log, iclog);
-}
-
 /*
  * Mount a log filesystem
  *
@@ -3188,7 +3166,7 @@ xfs_log_ticket_ungrant(
  * This routine will mark the current iclog in the ring as WANT_SYNC and move
  * the current iclog pointer to the next iclog in the ring.
  */
-STATIC void
+void
 xlog_state_switch_iclogs(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
@@ -3335,6 +3313,20 @@ xfs_log_force(
 	return -EIO;
 }
 
+/*
+ * Force the log to a specific LSN.
+ *
+ * If an iclog with that lsn can be found:
+ *	If it is in the DIRTY state, just return.
+ *	If it is in the ACTIVE state, move the in-core log into the WANT_SYNC
+ *		state and go to sleep or return.
+ *	If it is in any other state, go to sleep or return.
+ *
+ * Synchronous forces are implemented with a wait queue.  All callers trying
+ * to force a given lsn to disk must wait on the queue attached to the
+ * specific in-core log.  When given in-core log finally completes its write
+ * to disk, that thread will wake up all threads waiting on the queue.
+ */
 static int
 xlog_force_lsn(
 	struct xlog		*log,
@@ -3398,18 +3390,15 @@ xlog_force_lsn(
 }
 
 /*
- * Force the in-core log to disk for a specific LSN.
+ * Force the log to a specific checkpoint sequence.
  *
- * Find in-core log with lsn.
- *	If it is in the DIRTY state, just return.
- *	If it is in the ACTIVE state, move the in-core log into the WANT_SYNC
- *		state and go to sleep or return.
- *	If it is in any other state, go to sleep or return.
+ * First force the CIL so that all the required changes have been flushed to the
+ * iclogs. If the CIL force completed it will return a commit LSN that indicates
+ * the iclog that needs to be flushed to stable storage.
  *
- * Synchronous forces are implemented with a wait queue.  All callers trying
- * to force a given lsn to disk must wait on the queue attached to the
- * specific in-core log.  When given in-core log finally completes its write
- * to disk, that thread will wake up all threads waiting on the queue.
+ * If the XFS_LOG_SYNC flag is not set, we only trigger a background CIL force
+ * and do not wait for it to complete, nor do we attempt to check/flush iclogs
+ * as the CIL will not have committed when xlog_cil_force_seq() returns.
  */
 int
 xfs_log_force_seq(
@@ -3426,7 +3415,7 @@ xfs_log_force_seq(
 	XFS_STATS_INC(mp, xs_log_force);
 	trace_xfs_log_force(mp, seq, _RET_IP_);
 
-	lsn = xlog_cil_force_seq(log, seq);
+	lsn = xlog_cil_force_seq(log, flags, seq);
 	if (lsn == NULLCOMMITLSN)
 		return 0;
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 33ae53401060..ff480d372dcf 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -104,6 +104,7 @@ struct xlog_ticket;
 struct xfs_log_item;
 struct xfs_item_ops;
 struct xfs_trans;
+struct xlog;
 
 int	  xfs_log_force(struct xfs_mount *mp, uint flags);
 int	  xfs_log_force_seq(struct xfs_mount *mp, uint64_t seq, uint flags,
@@ -117,7 +118,6 @@ void	xfs_log_mount_cancel(struct xfs_mount *);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
-void	  xfs_log_release_iclog(struct xlog_in_core *iclog);
 int	  xfs_log_reserve(struct xfs_mount *mp,
 			  int		   length,
 			  int		   count,
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 2fda8c4513b2..1b46559ef64a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -657,6 +657,7 @@ xlog_cil_push_work(
 	xfs_lsn_t		commit_lsn;
 	xfs_lsn_t		push_seq;
 	DECLARE_COMPLETION_ONSTACK(bdev_flush);
+	bool			commit_iclog_sync = false;
 
 	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -667,7 +668,12 @@ xlog_cil_push_work(
 	spin_lock(&cil->xc_push_lock);
 	push_seq = cil->xc_push_seq;
 	ASSERT(push_seq <= ctx->sequence);
+	commit_iclog_sync = cil->xc_push_async;
+	cil->xc_push_async = false;
 
+trace_printk("curseq %llu, ctxseq %llu pushseq %llu empty %d",
+		cil->xc_current_sequence, cil->xc_ctx->sequence,
+		cil->xc_push_seq, list_empty(&cil->xc_cil));
 	/*
 	 * As we are about to switch to a new, empty CIL context, we no longer
 	 * need to throttle tasks on CIL space overruns. Wake any waiters that
@@ -910,7 +916,11 @@ xlog_cil_push_work(
 		commit_iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
 
 	/* release the hounds! */
-	xfs_log_release_iclog(commit_iclog);
+	spin_lock(&log->l_icloglock);
+	if (commit_iclog_sync && commit_iclog->ic_state == XLOG_STATE_ACTIVE)
+		xlog_state_switch_iclogs(log, commit_iclog, 0);
+	xlog_state_release_iclog(log, commit_iclog);
+	spin_unlock(&log->l_icloglock);
 	return;
 
 out_skip:
@@ -993,13 +1003,26 @@ xlog_cil_push_background(
 /*
  * xlog_cil_push_now() is used to trigger an immediate CIL push to the sequence
  * number that is passed. When it returns, the work will be queued for
- * @push_seq, but it won't be completed. The caller is expected to do any
- * waiting for push_seq to complete if it is required.
+ * @push_seq, but it won't be completed.
+ *
+ * If the caller is performing a synchronous force, we will flush the workqueue
+ * to get previously queued work moving to minimise the wait time they will
+ * undergo waiting for all outstanding pushes to complete. The caller is
+ * expected to do the required waiting for push_seq to complete.
+ *
+ * If the caller is performing an async push, we need to ensure that the
+ * checkpoint is fully flushed out of the iclogs when we finish the push. If we
+ * don't do this, then the commit record may remain sitting in memory in an
+ * ACTIVE iclog. This then requires another full log force to push to disk,
+ * which defeats the purpose of having an async, non-blocking CIL force
+ * mechanism. Hence in this case we need to pass a flag to the push work to
+ * indicate it needs to flush the commit record itself.
  */
 static void
 xlog_cil_push_now(
 	struct xlog	*log,
-	xfs_lsn_t	push_seq)
+	xfs_lsn_t	push_seq,
+	bool		sync)
 {
 	struct xfs_cil	*cil = log->l_cilp;
 
@@ -1009,7 +1032,8 @@ xlog_cil_push_now(
 	ASSERT(push_seq && push_seq <= cil->xc_current_sequence);
 
 	/* start on any pending background push to minimise wait time on it */
-	flush_work(&cil->xc_push_work);
+	if (sync)
+		flush_work(&cil->xc_push_work);
 
 	/*
 	 * If the CIL is empty or we've already pushed the sequence then
@@ -1022,6 +1046,8 @@ xlog_cil_push_now(
 	}
 
 	cil->xc_push_seq = push_seq;
+	if (!sync)
+		cil->xc_push_async = true;
 	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
 	spin_unlock(&cil->xc_push_lock);
 }
@@ -1109,16 +1135,22 @@ xlog_cil_commit(
 /*
  * Conditionally push the CIL based on the sequence passed in.
  *
- * We only need to push if we haven't already pushed the sequence
- * number given. Hence the only time we will trigger a push here is
- * if the push sequence is the same as the current context.
+ * We only need to push if we haven't already pushed the sequence number given.
+ * Hence the only time we will trigger a push here is if the push sequence is
+ * the same as the current context.
  *
- * We return the current commit lsn to allow the callers to determine if a
- * iclog flush is necessary following this call.
+ * If the sequence is zero, push the current sequence. If XFS_LOG_SYNC is set in
+ * the flags wait for it to complete, otherwise jsut return NULLCOMMITLSN to
+ * indicate we didn't wait for a commit lsn.
+ *
+ * If we waited for the push to complete, then we return the current commit lsn
+ * to allow the callers to determine if a iclog flush is necessary following
+ * this call.
  */
 xfs_lsn_t
 xlog_cil_force_seq(
 	struct xlog	*log,
+	uint32_t	flags,
 	uint64_t	sequence)
 {
 	struct xfs_cil		*cil = log->l_cilp;
@@ -1127,13 +1159,22 @@ xlog_cil_force_seq(
 
 	ASSERT(sequence <= cil->xc_current_sequence);
 
+	if (!sequence)
+		sequence = cil->xc_current_sequence;
+trace_printk("seq %llu, curseq %llu, ctxseq %llu pushseq %llu flags 0x%x",
+		sequence, cil->xc_current_sequence, cil->xc_ctx->sequence,
+		cil->xc_push_seq, flags);
+
+	trace_xfs_log_force(log->l_mp, sequence, _RET_IP_);
 	/*
 	 * check to see if we need to force out the current context.
 	 * xlog_cil_push() handles racing pushes for the same sequence,
 	 * so no need to deal with it here.
 	 */
 restart:
-	xlog_cil_push_now(log, sequence);
+	xlog_cil_push_now(log, sequence, flags & XFS_LOG_SYNC);
+	if (!(flags & XFS_LOG_SYNC))
+		return commit_lsn;
 
 	/*
 	 * See if we can find a previous sequence still committing.
@@ -1157,6 +1198,7 @@ xlog_cil_force_seq(
 			 * It is still being pushed! Wait for the push to
 			 * complete, then start again from the beginning.
 			 */
+			XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
 			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
 			goto restart;
 		}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 7e8ec77bc6e6..6b1a251dd013 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -273,6 +273,7 @@ struct xfs_cil {
 
 	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
 	uint64_t		xc_push_seq;
+	bool			xc_push_async;
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
 	uint64_t		xc_current_sequence;
@@ -487,6 +488,10 @@ int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 		struct xlog_in_core **commit_iclog, uint optype);
 int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
 		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
+void	xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
+		int eventual_size);
+int	xlog_state_release_iclog(struct xlog *xlog, struct xlog_in_core *iclog);
+
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
@@ -558,12 +563,13 @@ void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
 /*
  * CIL force routines
  */
-xfs_lsn_t xlog_cil_force_seq(struct xlog *log, uint64_t sequence);
+xfs_lsn_t xlog_cil_force_seq(struct xlog *log, uint32_t flags,
+				uint64_t sequence);
 
 static inline void
 xlog_cil_force(struct xlog *log)
 {
-	xlog_cil_force_seq(log, log->l_cilp->xc_current_sequence);
+	xlog_cil_force_seq(log, XFS_LOG_SYNC, log->l_cilp->xc_current_sequence);
 }
 
 /*
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index f1bc88f4367c..18dc5eca6c04 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -10,6 +10,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sysfs.h"
+#include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_mount.h"
 
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 9b8d703dc9fd..d111a994b7b6 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -20,6 +20,7 @@
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
+#include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 697703f3be48..7d05694681e3 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -9,7 +9,6 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_log_priv.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_extent_busy.h"
@@ -17,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index dbb69b4bf3ed..dfc0206c0d36 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -17,6 +17,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 #ifdef DEBUG
 /*
@@ -429,8 +430,12 @@ xfsaild_push(
 
 	/*
 	 * If we encountered pinned items or did not finish writing out all
-	 * buffers the last time we ran, force the log first and wait for it
-	 * before pushing again.
+	 * buffers the last time we ran, force a background CIL push to get the
+	 * items unpinned in the near future. We do not wait on the CIL push as
+	 * that could stall us for seconds if there is enough background IO
+	 * load. Stalling for that long when the tail of the log is pinned and
+	 * needs flushing will hard stop the transaction subsystem when log
+	 * space runs out.
 	 */
 	if (ailp->ail_log_flush && ailp->ail_last_pushed_lsn == 0 &&
 	    (!list_empty_careful(&ailp->ail_buf_list) ||
@@ -438,7 +443,7 @@ xfsaild_push(
 		ailp->ail_log_flush = 0;
 
 		XFS_STATS_INC(mp, xs_push_ail_flush);
-		xfs_log_force(mp, XFS_LOG_SYNC);
+		xlog_cil_force_seq(mp->m_log, 0, 0);
 	}
 
 	spin_lock(&ailp->ail_lock);
