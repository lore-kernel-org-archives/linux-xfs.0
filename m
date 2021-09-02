Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591C9C4320E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F3A860724
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhIBKAe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 06:00:34 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35572 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233374AbhIBKAd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 06:00:33 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D0C8782ACD7
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 19:59:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-007nIu-Pt
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-003pD0-He
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] [RFC] xfs: intent item whiteouts
Date:   Thu,  2 Sep 2021 19:59:26 +1000
Message-Id: <20210902095927.911100-7-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902095927.911100-1-david@fromorbit.com>
References: <20210902095927.911100-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=MU2QJs_iwlFiPCsiWkIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we log modifications based on intents, we add both intent
and intent done items to the modification being made. These get
written to the log to ensure that the operation is re-run if the
intent done is not found in the log.

However, for operations that complete wholly within a single
checkpoint, the change in the checkpoint is atomic and will never
need replay. In this case, we don't need to actually write the
intent and intent done items to the journal because log recovery
will never need to manually restart this modification.

Log recovery currently handles intent/intent done matching by
inserting the intent into the AIL, then removing it when a matching
intent done item is found. Hence for all the intent-based operations
that complete within a checkpoint, we spend all that time parsing
the intent/intent done items just to cancel them and do nothing with
them.

Hence it follows that the only time we actually need intents in the
log is when the modification crosses checkpoint boundaries in the
log and so may only be partially complete in the journal. Hence if
we commit and intent done item to the CIL and the intent item is in
the same checkpoint, we don't actually have to write them to the
journal because log recovery will always cancel the intents.

We've never really worried about the overhead of logging intents
unnecessarily like this because the intents we log are generally
very much smaller than the change being made. e.g. freeing an extent
involves modifying at lease two freespace btree blocks and the AGF,
so the EFI/EFD overhead is only a small increase in space and
processing time compared to the overall cost of freeing an extent.

However, delayed attributes change this cost equation dramatically,
especially for inline attributes. In the case of adding an inline
attribute, we only log the inode core and attribute fork at present.
With delayed attributes, we now log the attr intent which includes
the name and value, the inode core adn attr fork, and finally the
attr intent done item. We increase the number of items we log from 1
to 3, and the number of log vectors (regions) goes up from 3 to 7.
Hence we tripple the number of objects that the CIL has to process,
and more than double the number of log vectors that need to be
written to the journal.

At scale, this means delayed attributes cause a non-pipelined CIL to
become CPU bound processing all the extra items, resulting in a > 40%
performance degradation on 16-way file+xattr create worklaods.
Pipelining the CIL (as per 5.15) reduces the performance degradation
to 20%, but now the limitation is the rate at which the log items
can be written to the iclogs and iclogs be dispatched for IO and
completed.

Even log IO completion is slowed down by these intents, because it
now has to process 3x the number of items in the checkpoint.
Processing completed intents is especially inefficient here, because
we first insert the intent into the AIL, then remove it from the AIL
when the intent done is processed. IOWs, we are also doing expensive
operations in log IO completion we could completely avoid if we
didn't log completed intent/intent done pairs.

Enter log item whiteouts.

When an intent done is committed, we can check to see if the
associated intent is in the same checkpoint as we are currently
committing the intent done to. If so, we can mark the intent log
item with a whiteout and immediately free the intent done item
rather than committing it to the CIL. We can basically skip the
entire formatting and CIL insertion steps for the intent done item.

However, we cannot remove the intent item from the CIL at this point
because the unlocked per-cpu CIL item lists do not permit removal
without holding the CIL context lock exclusively. Transaction commit
only holds the context lock shared, hence the best we can do is mark
the intent item with a whiteout so that the CIL push can release it
rather than writing it to the log.

This means we never write the intent to the log if the intent done
has also been committed to the same checkpoint, but we'll always
write the intent if the intent done has not been committed or has
been committed to a different checkpoint. This will result in
correct log recovery behaviour in all cases, without the overhead of
logging unnecessary intents.

This intent whiteout concept is generic - we can apply it to all
intent/intent done pairs that have a direct 1:1 relationship. The
way deferred ops iterate and relog intents mean that all intents
currently have a 1:1 relationship with their done intent, and hence
we can apply this cancellation to all existing intent/intent done
implementations.

For delayed attributes with a 16-way 64kB xattr create workload,
whiteouts reduce the amount of journalled metadata from ~2.5GB/s
down to ~600MB/s and improve the creation rate from 9000/s to
14000/s.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 78 +++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trace.h   |  3 ++
 fs/xfs/xfs_trans.h   |  7 ++--
 3 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index bd2c8178255e..fff68aad254e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -502,7 +502,8 @@ xlog_cil_insert_format_items(
 static void
 xlog_cil_insert_items(
 	struct xlog		*log,
-	struct xfs_trans	*tp)
+	struct xfs_trans	*tp,
+	uint32_t		released_space)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
@@ -569,6 +570,7 @@ xlog_cil_insert_items(
 	 */
 	cilpcp = get_cpu_ptr(cil->xc_pcp);
 	cilpcp->space_reserved += ctx_res;
+	cilpcp->space_used -= released_space;
 	cilpcp->space_used += len;
 	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
 	    cilpcp->space_used >
@@ -1028,11 +1030,14 @@ xlog_cil_order_cmp(
 }
 
 /*
- * Build a log vector chain from the current CIL.
+ * Build a log vector chain from the current CIL. If a log item is marked with a
+ * whiteout, we do not need to write it to the journal and so we just move them
+ * to the whiteout list for the caller to dispose of appropriately.
  */
 static void
 xlog_cil_build_lv_chain(
 	struct xfs_cil_ctx	*ctx,
+	struct list_head	*whiteouts,
 	uint32_t		*num_iovecs,
 	uint32_t		*num_bytes)
 {
@@ -1043,6 +1048,11 @@ xlog_cil_build_lv_chain(
 
 		item = list_first_entry(&ctx->log_items,
 					struct xfs_log_item, li_cil);
+		if (test_bit(XFS_LI_WHITEOUT, &item->li_flags)) {
+			list_move(&item->li_cil, whiteouts);
+			trace_xfs_cil_whiteout_skip(item);
+			continue;
+		}
 
 		lv = item->li_lv;
 		lv->lv_order_id = item->li_order_id;
@@ -1092,6 +1102,7 @@ xlog_cil_push_work(
 	DECLARE_COMPLETION_ONSTACK(bdev_flush);
 	bool			push_commit_stable;
 	struct xlog_ticket	*ticket;
+	LIST_HEAD		(whiteouts);
 
 	new_ctx = xlog_cil_ctx_alloc();
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -1178,7 +1189,7 @@ xlog_cil_push_work(
 				&bdev_flush);
 
 	xlog_cil_pcp_aggregate(cil, ctx);
-	xlog_cil_build_lv_chain(ctx, &num_iovecs, &num_bytes);
+	xlog_cil_build_lv_chain(ctx, &whiteouts, &num_iovecs, &num_bytes);
 
 	/*
 	 * Switch the contexts so we can drop the context lock and move out
@@ -1312,6 +1323,15 @@ xlog_cil_push_work(
 	/* Not safe to reference ctx now! */
 
 	spin_unlock(&log->l_icloglock);
+
+	/* clean up log items that had whiteouts */
+	while (!list_empty(&whiteouts)) {
+		struct xfs_log_item *item = list_first_entry(&whiteouts,
+						struct xfs_log_item, li_cil);
+		list_del_init(&item->li_cil);
+		trace_xfs_cil_whiteout_unpin(item);
+		item->li_ops->iop_unpin(item, 1);
+	}
 	xfs_log_ticket_ungrant(log, ticket);
 	return;
 
@@ -1323,6 +1343,14 @@ xlog_cil_push_work(
 
 out_abort_free_ticket:
 	ASSERT(xlog_is_shutdown(log));
+	while (!list_empty(&whiteouts)) {
+		struct xfs_log_item *item = list_first_entry(&whiteouts,
+						struct xfs_log_item, li_cil);
+		list_del_init(&item->li_cil);
+		trace_xfs_cil_whiteout_unpin(item);
+		item->li_ops->iop_unpin(item, 1);
+	}
+
 	if (!ctx->commit_iclog) {
 		xfs_log_ticket_ungrant(log, ctx->ticket);
 		xlog_cil_committed(ctx);
@@ -1475,6 +1503,43 @@ xlog_cil_empty(
 	return empty;
 }
 
+/*
+ * If there are intent done items in this transaction and the related intent was
+ * committed in the current (same) CIL checkpoint, we don't need to write either
+ * the intent or intent done item to the journal as the change will be
+ * journalled atomically within this checkpoint. As we cannot remove items from
+ * the CIL here, mark the related intent with a whiteout so that the CIL push
+ * can remove it rather than writing it to the journal. Then remove the intent
+ * done item from the current transaction and release it so it doesn't get put
+ * into the CIL at all.
+ */
+static uint32_t
+xlog_cil_process_intents(
+	struct xfs_cil		*cil,
+	struct xfs_trans	*tp)
+{
+	struct xfs_log_item	*lip, *ilip, *next;
+	uint32_t		len = 0;
+
+	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
+		if (!(lip->li_ops->flags & XFS_ITEM_INTENT_DONE))
+			continue;
+
+		ilip = lip->li_ops->iop_intent(lip);
+		if (!ilip || !xlog_item_in_current_chkpt(cil, ilip))
+			continue;
+		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
+		trace_xfs_cil_whiteout_mark(ilip);
+		len += ilip->li_lv->lv_bytes;
+		kmem_free(ilip->li_lv);
+		ilip->li_lv = NULL;
+
+		xfs_trans_del_item(lip);
+		lip->li_ops->iop_release(lip);
+	}
+	return len;
+}
+
 /*
  * Commit a transaction with the given vector to the Committed Item List.
  *
@@ -1497,6 +1562,7 @@ xlog_cil_commit(
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_log_item	*lip, *next;
+	uint32_t		released_space = 0;
 
 	/*
 	 * Do all necessary memory allocation before we lock the CIL.
@@ -1508,7 +1574,11 @@ xlog_cil_commit(
 	/* lock out background commit */
 	down_read(&cil->xc_ctx_lock);
 
-	xlog_cil_insert_items(log, tp);
+	if (tp->t_flags & XFS_TRANS_HAS_INTENT_DONE)
+		released_space = xlog_cil_process_intents(cil, tp);
+
+	xlog_cil_insert_items(log, tp, released_space);
+	tp->t_ticket->t_curr_res += released_space;
 
 	if (regrant && !xlog_is_shutdown(log))
 		xfs_log_ticket_regrant(log, tp->t_ticket);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 77a78b5b1a29..d4f5a1410879 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1348,6 +1348,9 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
+DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
+DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
+DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
 
 DECLARE_EVENT_CLASS(xfs_ail_class,
 	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a6d7b3309bd7..5765ca6e2c84 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -55,13 +55,16 @@ struct xfs_log_item {
 #define	XFS_LI_IN_AIL	0
 #define	XFS_LI_ABORTED	1
 #define	XFS_LI_FAILED	2
-#define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
+#define	XFS_LI_DIRTY	3
+#define	XFS_LI_WHITEOUT	4
 
 #define XFS_LI_FLAGS \
 	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
 	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
-	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
+	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
+	{ (1 << XFS_LI_WHITEOUT),	"WHITEOUT" }
+
 
 struct xfs_item_ops {
 	unsigned flags;
-- 
2.31.1

