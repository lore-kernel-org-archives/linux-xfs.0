Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2270FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 02:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357166AbiD0C0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357161AbiD0C0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 22:26:13 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD3D714C3CD
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 19:23:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 14F15537335
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 12:23:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njXKX-004yyU-10
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 12:23:01 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-002uvP-W7
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 12:23:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: intent item whiteouts
Date:   Wed, 27 Apr 2022 12:22:59 +1000
Message-Id: <20220427022259.695399-9-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427022259.695399-1-david@fromorbit.com>
References: <20220427022259.695399-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6268a906
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=RvZt_G6gt4RYOewushoA:9
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
 fs/xfs/xfs_bmap_item.c     |  2 +
 fs/xfs/xfs_log_cil.c       | 80 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_refcount_item.c |  1 +
 fs/xfs/xfs_rmap_item.c     |  2 +
 fs/xfs/xfs_trace.h         |  3 ++
 fs/xfs/xfs_trans.h         |  6 ++-
 6 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 59aa5f9bf769..670d074a71cc 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -39,6 +39,7 @@ STATIC void
 xfs_bui_item_free(
 	struct xfs_bui_log_item	*buip)
 {
+	kmem_free(buip->bui_item.li_lv_shadow);
 	kmem_cache_free(xfs_bui_cache, buip);
 }
 
@@ -199,6 +200,7 @@ xfs_bud_item_release(
 {
 	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
 
+	kmem_free(budp->bud_item.li_lv_shadow);
 	xfs_bui_release(budp->bud_buip);
 	kmem_cache_free(xfs_bud_cache, budp);
 }
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 0d8d092447ad..d894511428f2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -476,7 +476,8 @@ xlog_cil_insert_format_items(
 static void
 xlog_cil_insert_items(
 	struct xlog		*log,
-	struct xfs_trans	*tp)
+	struct xfs_trans	*tp,
+	uint32_t		released_space)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
@@ -526,6 +527,7 @@ xlog_cil_insert_items(
 	}
 	tp->t_ticket->t_curr_res -= len;
 	ctx->space_used += len;
+	ctx->space_used -= released_space;
 
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
@@ -970,11 +972,16 @@ xlog_cil_build_trans_hdr(
  * Pull all the log vectors off the items in the CIL, and remove the items from
  * the CIL. We don't need the CIL lock here because it's only needed on the
  * transaction commit side which is currently locked out by the flush lock.
+ *
+ * If a log item is marked with a whiteout, we do not need to write it to the
+ * journal and so we just move them to the whiteout list for the caller to
+ * dispose of appropriately.
  */
 static void
 xlog_cil_build_lv_chain(
 	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx,
+	struct list_head	*whiteouts,
 	uint32_t		*num_iovecs,
 	uint32_t		*num_bytes)
 {
@@ -985,6 +992,13 @@ xlog_cil_build_lv_chain(
 
 		item = list_first_entry(&cil->xc_cil,
 					struct xfs_log_item, li_cil);
+
+		if (test_bit(XFS_LI_WHITEOUT, &item->li_flags)) {
+			list_move(&item->li_cil, whiteouts);
+			trace_xfs_cil_whiteout_skip(item);
+			continue;
+		}
+
 		list_del_init(&item->li_cil);
 		if (!ctx->lv_chain)
 			ctx->lv_chain = item->li_lv;
@@ -1030,6 +1044,7 @@ xlog_cil_push_work(
 	struct xfs_log_vec	lvhdr = { NULL };
 	xfs_csn_t		push_seq;
 	bool			push_commit_stable;
+	LIST_HEAD		(whiteouts);
 
 	new_ctx = xlog_cil_ctx_alloc();
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -1098,7 +1113,7 @@ xlog_cil_push_work(
 	list_add(&ctx->committing, &cil->xc_committing);
 	spin_unlock(&cil->xc_push_lock);
 
-	xlog_cil_build_lv_chain(cil, ctx, &num_iovecs, &num_bytes);
+	xlog_cil_build_lv_chain(cil, ctx, &whiteouts, &num_iovecs, &num_bytes);
 
 	/*
 	 * Switch the contexts so we can drop the context lock and move out
@@ -1201,6 +1216,15 @@ xlog_cil_push_work(
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
 	return;
 
 out_skip:
@@ -1212,6 +1236,14 @@ xlog_cil_push_work(
 out_abort_free_ticket:
 	xfs_log_ticket_ungrant(log, ctx->ticket);
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
 		xlog_cil_committed(ctx);
 		return;
@@ -1360,6 +1392,43 @@ xlog_cil_empty(
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
@@ -1382,6 +1451,7 @@ xlog_cil_commit(
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_log_item	*lip, *next;
+	uint32_t		released_space = 0;
 
 	/*
 	 * Do all necessary memory allocation before we lock the CIL.
@@ -1393,7 +1463,11 @@ xlog_cil_commit(
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
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 1b82b818f515..3fee1090e9a8 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -35,6 +35,7 @@ STATIC void
 xfs_cui_item_free(
 	struct xfs_cui_log_item	*cuip)
 {
+	kmem_free(cuip->cui_item.li_lv_shadow);
 	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
 		kmem_free(cuip);
 	else
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 99dfb3ae7e9c..546bd824cdf7 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -35,6 +35,7 @@ STATIC void
 xfs_rui_item_free(
 	struct xfs_rui_log_item	*ruip)
 {
+	kmem_free(ruip->rui_item.li_lv_shadow);
 	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
 		kmem_free(ruip);
 	else
@@ -228,6 +229,7 @@ xfs_rud_item_release(
 {
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
 
+	kmem_free(rudp->rud_item.li_lv_shadow);
 	xfs_rui_release(rudp->rud_ruip);
 	kmem_cache_free(xfs_rud_cache, rudp);
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e1197f9ad97e..75934e3c3f55 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1332,6 +1332,9 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
+DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
+DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
+DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
 
 DECLARE_EVENT_CLASS(xfs_ail_class,
 	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index d72a5995d33e..9561f193e7e1 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -55,13 +55,15 @@ struct xfs_log_item {
 #define	XFS_LI_IN_AIL	0
 #define	XFS_LI_ABORTED	1
 #define	XFS_LI_FAILED	2
-#define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
+#define	XFS_LI_DIRTY	3
+#define	XFS_LI_WHITEOUT	4
 
 #define XFS_LI_FLAGS \
 	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
 	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
-	{ (1u << XFS_LI_DIRTY),		"DIRTY" }
+	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
+	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
 
 struct xfs_item_ops {
 	unsigned flags;
-- 
2.35.1

