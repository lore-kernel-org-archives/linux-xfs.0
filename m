Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40312 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728435AbeJ3DQ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 23:16:27 -0400
Subject: [PATCH 2/2] libxfs: streamline defer op type handling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Oct 2018 11:26:33 -0700
Message-ID: <154083759379.17015.3772462618596721180.stgit@magnolia>
In-Reply-To: <154083758133.17015.16047588822481256587.stgit@magnolia>
References: <154083758133.17015.16047588822481256587.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's no need to bundle a pointer to the defer op type into the defer
op control structure.  Instead, store the defer op type enum, which
enables us to shorten some of the lines.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/defer_item.c |    5 -----
 libxfs/xfs_defer.c  |   50 +++++++++++++++++++++++++++-----------------------
 libxfs/xfs_defer.h  |   31 +++++++++++++++----------------
 3 files changed, 42 insertions(+), 44 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d36f9d9e..2ebc12bd 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -108,7 +108,6 @@ xfs_extent_free_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
-	.type		= XFS_DEFER_OPS_TYPE_FREE,
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
@@ -151,7 +150,6 @@ xfs_agfl_free_finish_item(
 
 /* sub-type with special handling for AGFL deferred frees */
 const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
-	.type		= XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
@@ -263,7 +261,6 @@ xfs_rmap_update_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
-	.type		= XFS_DEFER_OPS_TYPE_RMAP,
 	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
@@ -384,7 +381,6 @@ xfs_refcount_update_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
-	.type		= XFS_DEFER_OPS_TYPE_REFCOUNT,
 	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
@@ -489,7 +485,6 @@ xfs_bmap_update_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
-	.type		= XFS_DEFER_OPS_TYPE_BMAP,
 	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 68fe07a4..d9d42713 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -189,15 +189,15 @@ xfs_defer_create_intents(
 {
 	struct list_head		*li;
 	struct xfs_defer_pending	*dfp;
+	const struct xfs_defer_op_type	*ops;
 
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
-		dfp->dfp_intent = dfp->dfp_type->create_intent(tp,
-				dfp->dfp_count);
+		ops = defer_op_types[dfp->dfp_type];
+		dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
-		list_sort(tp->t_mountp, &dfp->dfp_work,
-				dfp->dfp_type->diff_items);
+		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
 		list_for_each(li, &dfp->dfp_work)
-			dfp->dfp_type->log_item(tp, dfp->dfp_intent, li);
+			ops->log_item(tp, dfp->dfp_intent, li);
 	}
 }
 
@@ -208,14 +208,16 @@ xfs_defer_trans_abort(
 	struct list_head		*dop_pending)
 {
 	struct xfs_defer_pending	*dfp;
+	const struct xfs_defer_op_type	*ops;
 
 	trace_xfs_defer_trans_abort(tp, _RET_IP_);
 
 	/* Abort intent items that don't have a done item. */
 	list_for_each_entry(dfp, dop_pending, dfp_list) {
+		ops = defer_op_types[dfp->dfp_type];
 		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
 		if (dfp->dfp_intent && !dfp->dfp_done) {
-			dfp->dfp_type->abort_intent(dfp->dfp_intent);
+			ops->abort_intent(dfp->dfp_intent);
 			dfp->dfp_intent = NULL;
 		}
 	}
@@ -319,18 +321,20 @@ xfs_defer_cancel_list(
 	struct xfs_defer_pending	*pli;
 	struct list_head		*pwi;
 	struct list_head		*n;
+	const struct xfs_defer_op_type	*ops;
 
 	/*
 	 * Free the pending items.  Caller should already have arranged
 	 * for the intent items to be released.
 	 */
 	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list) {
+		ops = defer_op_types[dfp->dfp_type];
 		trace_xfs_defer_cancel_list(mp, dfp);
 		list_del(&dfp->dfp_list);
 		list_for_each_safe(pwi, n, &dfp->dfp_work) {
 			list_del(pwi);
 			dfp->dfp_count--;
-			dfp->dfp_type->cancel_item(pwi);
+			ops->cancel_item(pwi);
 		}
 		ASSERT(dfp->dfp_count == 0);
 		kmem_free(dfp);
@@ -354,7 +358,7 @@ xfs_defer_finish_noroll(
 	struct list_head		*n;
 	void				*state;
 	int				error = 0;
-	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
+	const struct xfs_defer_op_type	*ops;
 	LIST_HEAD(dop_pending);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -377,18 +381,18 @@ xfs_defer_finish_noroll(
 		/* Log an intent-done item for the first pending item. */
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
+		ops = defer_op_types[dfp->dfp_type];
 		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
-		dfp->dfp_done = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
+		dfp->dfp_done = ops->create_done(*tp, dfp->dfp_intent,
 				dfp->dfp_count);
-		cleanup_fn = dfp->dfp_type->finish_cleanup;
 
 		/* Finish the work items. */
 		state = NULL;
 		list_for_each_safe(li, n, &dfp->dfp_work) {
 			list_del(li);
 			dfp->dfp_count--;
-			error = dfp->dfp_type->finish_item(*tp, li,
-					dfp->dfp_done, &state);
+			error = ops->finish_item(*tp, li, dfp->dfp_done,
+					&state);
 			if (error == -EAGAIN) {
 				/*
 				 * Caller wants a fresh transaction;
@@ -404,8 +408,8 @@ xfs_defer_finish_noroll(
 				 * xfs_defer_cancel will take care of freeing
 				 * all these lists and stuff.
 				 */
-				if (cleanup_fn)
-					cleanup_fn(*tp, state, error);
+				if (ops->finish_cleanup)
+					ops->finish_cleanup(*tp, state, error);
 				goto out;
 			}
 		}
@@ -417,20 +421,19 @@ xfs_defer_finish_noroll(
 			 * a Fresh Transaction while Finishing
 			 * Deferred Work" above.
 			 */
-			dfp->dfp_intent = dfp->dfp_type->create_intent(*tp,
+			dfp->dfp_intent = ops->create_intent(*tp,
 					dfp->dfp_count);
 			dfp->dfp_done = NULL;
 			list_for_each(li, &dfp->dfp_work)
-				dfp->dfp_type->log_item(*tp, dfp->dfp_intent,
-						li);
+				ops->log_item(*tp, dfp->dfp_intent, li);
 		} else {
 			/* Done with the dfp, free it. */
 			list_del(&dfp->dfp_list);
 			kmem_free(dfp);
 		}
 
-		if (cleanup_fn)
-			cleanup_fn(*tp, state, error);
+		if (ops->finish_cleanup)
+			ops->finish_cleanup(*tp, state, error);
 	}
 
 out:
@@ -490,6 +493,7 @@ xfs_defer_add(
 	struct list_head		*li)
 {
 	struct xfs_defer_pending	*dfp = NULL;
+	const struct xfs_defer_op_type	*ops;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
@@ -502,15 +506,15 @@ xfs_defer_add(
 	if (!list_empty(&tp->t_dfops)) {
 		dfp = list_last_entry(&tp->t_dfops,
 				struct xfs_defer_pending, dfp_list);
-		if (dfp->dfp_type->type != type ||
-		    (dfp->dfp_type->max_items &&
-		     dfp->dfp_count >= dfp->dfp_type->max_items))
+		ops = defer_op_types[dfp->dfp_type];
+		if (dfp->dfp_type != type ||
+		    (ops->max_items && dfp->dfp_count >= ops->max_items))
 			dfp = NULL;
 	}
 	if (!dfp) {
 		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
 				KM_SLEEP | KM_NOFS);
-		dfp->dfp_type = defer_op_types[type];
+		dfp->dfp_type = type;
 		dfp->dfp_intent = NULL;
 		dfp->dfp_done = NULL;
 		dfp->dfp_count = 0;
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 0a4b88e3..7c28d760 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -8,20 +8,6 @@
 
 struct xfs_defer_op_type;
 
-/*
- * Save a log intent item and a list of extents, so that we can replay
- * whatever action had to happen to the extent list and file the log done
- * item.
- */
-struct xfs_defer_pending {
-	const struct xfs_defer_op_type	*dfp_type;	/* function pointers */
-	struct list_head		dfp_list;	/* pending items */
-	void				*dfp_intent;	/* log intent item */
-	void				*dfp_done;	/* log done item */
-	struct list_head		dfp_work;	/* work items */
-	unsigned int			dfp_count;	/* # extent items */
-};
-
 /*
  * Header for deferred operation list.
  */
@@ -34,6 +20,20 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
+/*
+ * Save a log intent item and a list of extents, so that we can replay
+ * whatever action had to happen to the extent list and file the log done
+ * item.
+ */
+struct xfs_defer_pending {
+	struct list_head		dfp_list;	/* pending items */
+	struct list_head		dfp_work;	/* work items */
+	void				*dfp_intent;	/* log intent item */
+	void				*dfp_done;	/* log done item */
+	unsigned int			dfp_count;	/* # extent items */
+	enum xfs_defer_ops_type		dfp_type;
+};
+
 void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
@@ -43,8 +43,6 @@ void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
-	enum xfs_defer_ops_type	type;
-	unsigned int		max_items;
 	void (*abort_intent)(void *);
 	void *(*create_done)(struct xfs_trans *, void *, unsigned int);
 	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
@@ -54,6 +52,7 @@ struct xfs_defer_op_type {
 	int (*diff_items)(void *, struct list_head *, struct list_head *);
 	void *(*create_intent)(struct xfs_trans *, uint);
 	void (*log_item)(struct xfs_trans *, void *, struct list_head *);
+	unsigned int		max_items;
 };
 
 extern const struct xfs_defer_op_type xfs_bmap_update_defer_type;
