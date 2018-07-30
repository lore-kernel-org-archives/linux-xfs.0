Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731971AbeG3SVN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 14:21:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 582934219DC8
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 418CF112D179
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 12/15] xfs: replace xfs_defer_ops ->dop_pending with on-stack list
Date: Mon, 30 Jul 2018 12:45:17 -0400
Message-Id: <20180730164520.36882-13-bfoster@redhat.com>
In-Reply-To: <20180730164520.36882-1-bfoster@redhat.com>
References: <20180730164520.36882-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The xfs_defer_ops ->dop_pending list is used to track active
deferred operations once intents are logged. These items must be
aborted in the event of an error. The list is populated as intents
are logged and items are removed as they complete (or are aborted).

Now that xfs_defer_finish() cancels on error, there is no need to
ever access ->dop_pending outside of xfs_defer_finish(). The list is
only ever populated after xfs_defer_finish() begins and is either
completed or cancelled before it returns.

Remove ->dop_pending from xfs_defer_ops and replace it with a local
list in the xfs_defer_finish() path. Pass the local list to the
various helpers now that it is not accessible via dfops. Note that
we have to check for NULL in the abort case as the final tx roll
occurs outside of the scope of the new local list (once the dfops
has completed and thus drained the list).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c | 80 ++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_defer.h |  3 +-
 fs/xfs/xfs_trace.h        |  1 -
 fs/xfs/xfs_trans.h        |  1 -
 4 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 66848ede62c0..6bf792e2d61b 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -174,6 +174,8 @@
 
 static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
 
+static void __xfs_defer_cancel(struct list_head *);
+
 /*
  * For each pending item in the intake list, log its intent item and the
  * associated extents, then add the entire intake list to the end of
@@ -181,7 +183,8 @@ static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
  */
 STATIC void
 xfs_defer_intake_work(
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct list_head		*dop_pending)
 {
 	struct xfs_defer_ops		*dop = tp->t_dfops;
 	struct list_head		*li;
@@ -197,13 +200,14 @@ xfs_defer_intake_work(
 			dfp->dfp_type->log_item(tp, dfp->dfp_intent, li);
 	}
 
-	list_splice_tail_init(&dop->dop_intake, &dop->dop_pending);
+	list_splice_tail_init(&dop->dop_intake, dop_pending);
 }
 
 /* Abort all the intents that were committed. */
 STATIC void
 xfs_defer_trans_abort(
 	struct xfs_trans		*tp,
+	struct list_head		*dop_pending,
 	int				error)
 {
 	struct xfs_defer_ops		*dop = tp->t_dfops;
@@ -212,11 +216,13 @@ xfs_defer_trans_abort(
 	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
 
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
-		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
-		if (dfp->dfp_intent && !dfp->dfp_done) {
-			dfp->dfp_type->abort_intent(dfp->dfp_intent);
-			dfp->dfp_intent = NULL;
+	if (dop_pending) {
+		list_for_each_entry(dfp, dop_pending, dfp_list) {
+			trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
+			if (dfp->dfp_intent && !dfp->dfp_done) {
+				dfp->dfp_type->abort_intent(dfp->dfp_intent);
+				dfp->dfp_intent = NULL;
+			}
 		}
 	}
 
@@ -228,7 +234,8 @@ xfs_defer_trans_abort(
 /* Roll a transaction so we can do some deferred op processing. */
 STATIC int
 xfs_defer_trans_roll(
-	struct xfs_trans		**tp)
+	struct xfs_trans		**tp,
+	struct list_head		*dop_pending)
 {
 	struct xfs_buf_log_item		*bli;
 	struct xfs_inode_log_item	*ili;
@@ -272,7 +279,7 @@ xfs_defer_trans_roll(
 	if (error) {
 		trace_xfs_defer_trans_roll_error((*tp)->t_mountp,
 						 (*tp)->t_dfops, error);
-		xfs_defer_trans_abort(*tp,  error);
+		xfs_defer_trans_abort(*tp,  dop_pending, error);
 		return error;
 	}
 
@@ -292,9 +299,10 @@ xfs_defer_trans_roll(
 /* Do we have any work items to finish? */
 bool
 xfs_defer_has_unfinished_work(
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct list_head		*dop_pending)
 {
-	return !list_empty(&tp->t_dfops->dop_pending) ||
+	return !list_empty(dop_pending) ||
 		!list_empty(&tp->t_dfops->dop_intake);
 }
 
@@ -305,7 +313,7 @@ static void
 xfs_defer_reset(
 	struct xfs_trans	*tp)
 {
-	ASSERT(!xfs_defer_has_unfinished_work(tp));
+	ASSERT(list_empty(&tp->t_dfops->dop_intake));
 
 	/*
 	 * Low mode state transfers across transaction rolls to mirror dfops
@@ -332,26 +340,27 @@ xfs_defer_finish_noroll(
 	void				*state;
 	int				error = 0;
 	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
+	LIST_HEAD(dop_pending);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	trace_xfs_defer_finish((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
 
 	/* Until we run out of pending work to finish... */
-	while (xfs_defer_has_unfinished_work(*tp)) {
+	while (xfs_defer_has_unfinished_work(*tp, &dop_pending)) {
 		/* Log intents for work items sitting in the intake. */
-		xfs_defer_intake_work(*tp);
+		xfs_defer_intake_work(*tp, &dop_pending);
 
 		/*
 		 * Roll the transaction.
 		 */
-		error = xfs_defer_trans_roll(tp);
+		error = xfs_defer_trans_roll(tp, &dop_pending);
 		if (error)
 			goto out;
 
 		/* Log an intent-done item for the first pending item. */
-		dfp = list_first_entry(&(*tp)->t_dfops->dop_pending,
-				struct xfs_defer_pending, dfp_list);
+		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
+				       dfp_list);
 		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
 		dfp->dfp_done = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
 				dfp->dfp_count);
@@ -381,7 +390,7 @@ xfs_defer_finish_noroll(
 				 */
 				if (cleanup_fn)
 					cleanup_fn(*tp, state, error);
-				xfs_defer_trans_abort(*tp, error);
+				xfs_defer_trans_abort(*tp, &dop_pending, error);
 				goto out;
 			}
 		}
@@ -413,6 +422,7 @@ xfs_defer_finish_noroll(
 	if (error) {
 		trace_xfs_defer_finish_error((*tp)->t_mountp, (*tp)->t_dfops,
 					     error);
+		__xfs_defer_cancel(&dop_pending);
 		xfs_defer_cancel(*tp);
 		return error;
 	}
@@ -435,7 +445,7 @@ xfs_defer_finish(
 	if (error)
 		return error;
 	if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
-		error = xfs_defer_trans_roll(tp);
+		error = xfs_defer_trans_roll(tp, NULL);
 		if (error)
 			return error;
 	}
@@ -446,34 +456,20 @@ xfs_defer_finish(
 /*
  * Free up any items left in the list.
  */
-void
-xfs_defer_cancel(
-	struct xfs_trans		*tp)
+static void
+__xfs_defer_cancel(
+	struct list_head		*dop_list)
 {
-	struct xfs_defer_ops		*dop = tp->t_dfops;
 	struct xfs_defer_pending	*dfp;
 	struct xfs_defer_pending	*pli;
 	struct list_head		*pwi;
 	struct list_head		*n;
 
-	trace_xfs_defer_cancel(NULL, dop, _RET_IP_);
-
 	/*
 	 * Free the pending items.  Caller should already have arranged
 	 * for the intent items to be released.
 	 */
-	list_for_each_entry_safe(dfp, pli, &dop->dop_intake, dfp_list) {
-		trace_xfs_defer_intake_cancel(NULL, dfp);
-		list_del(&dfp->dfp_list);
-		list_for_each_safe(pwi, n, &dfp->dfp_work) {
-			list_del(pwi);
-			dfp->dfp_count--;
-			dfp->dfp_type->cancel_item(pwi);
-		}
-		ASSERT(dfp->dfp_count == 0);
-		kmem_free(dfp);
-	}
-	list_for_each_entry_safe(dfp, pli, &dop->dop_pending, dfp_list) {
+	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list) {
 		trace_xfs_defer_pending_cancel(NULL, dfp);
 		list_del(&dfp->dfp_list);
 		list_for_each_safe(pwi, n, &dfp->dfp_work) {
@@ -486,6 +482,14 @@ xfs_defer_cancel(
 	}
 }
 
+void
+xfs_defer_cancel(
+	struct xfs_trans	*tp)
+{
+	trace_xfs_defer_cancel(NULL, tp->t_dfops, _RET_IP_);
+	__xfs_defer_cancel(&tp->t_dfops->dop_intake);
+}
+
 /* Add an item for later deferred processing. */
 void
 xfs_defer_add(
@@ -541,7 +545,6 @@ xfs_defer_init(
 
 	memset(dop, 0, sizeof(struct xfs_defer_ops));
 	INIT_LIST_HEAD(&dop->dop_intake);
-	INIT_LIST_HEAD(&dop->dop_pending);
 	if (tp) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
 		tp->t_dfops = dop;
@@ -565,7 +568,6 @@ xfs_defer_move(
 	ASSERT(dst != src);
 
 	list_splice_init(&src->dop_intake, &dst->dop_intake);
-	list_splice_init(&src->dop_pending, &dst->dop_pending);
 
 	/*
 	 * Low free space mode was historically controlled by a dfops field.
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index f051c8056141..363af16328cb 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -41,7 +41,8 @@ int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
 void xfs_defer_cancel(struct xfs_trans *);
 void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
-bool xfs_defer_has_unfinished_work(struct xfs_trans *tp);
+bool xfs_defer_has_unfinished_work(struct xfs_trans *tp,
+		struct list_head *dop_pending);
 void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8807f1bb814a..6b55bbc09578 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2393,7 +2393,6 @@ DEFINE_DEFER_ERROR_EVENT(xfs_defer_trans_roll_error);
 DEFINE_DEFER_ERROR_EVENT(xfs_defer_finish_error);
 
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_work);
-DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_cancel);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 299656dbf324..1cdc7c0ebeac 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -96,7 +96,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 struct xfs_defer_ops {
 	struct list_head	dop_intake;	/* unlogged pending work */
-	struct list_head	dop_pending;	/* logged pending work */
 };
 
 /*
-- 
2.17.1

