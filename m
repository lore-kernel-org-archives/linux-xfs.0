Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731961AbeHBOBe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Aug 2018 10:01:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B74BD40150EA
        for <linux-xfs@vger.kernel.org>; Thu,  2 Aug 2018 12:10:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99EB72142F20
        for <linux-xfs@vger.kernel.org>; Thu,  2 Aug 2018 12:10:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 12/15] xfs: replace xfs_defer_ops ->dop_pending with on-stack list
Date: Thu,  2 Aug 2018 08:10:38 -0400
Message-Id: <20180802121038.1202-1-bfoster@redhat.com>
In-Reply-To: <20180801131952.60250-13-bfoster@redhat.com>
References: <20180801131952.60250-13-bfoster@redhat.com>
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

v3:
- Refactor xfs_defer_trans_abort() usage to eliminate NULL dop_pending
  case.
- Drop use of metadata I/O error shutdown value.
- Refactor trans pointer usage in xfs_defer_trans_roll().

 fs/xfs/libxfs/xfs_defer.c | 146 ++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_defer.h |   1 -
 fs/xfs/xfs_trace.h        |   5 +-
 fs/xfs/xfs_trans.c        |   2 +-
 fs/xfs/xfs_trans.h        |   1 -
 5 files changed, 71 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index b656a399cd71..1cbddcf539da 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -180,7 +180,7 @@ static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
  * the pending list.
  */
 STATIC void
-xfs_defer_intake_work(
+xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
 	struct xfs_defer_ops		*dop = tp->t_dfops;
@@ -190,21 +190,19 @@ xfs_defer_intake_work(
 	list_for_each_entry(dfp, &dop->dop_intake, dfp_list) {
 		dfp->dfp_intent = dfp->dfp_type->create_intent(tp,
 				dfp->dfp_count);
-		trace_xfs_defer_intake_work(tp->t_mountp, dfp);
+		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
 		list_sort(tp->t_mountp, &dfp->dfp_work,
 				dfp->dfp_type->diff_items);
 		list_for_each(li, &dfp->dfp_work)
 			dfp->dfp_type->log_item(tp, dfp->dfp_intent, li);
 	}
-
-	list_splice_tail_init(&dop->dop_intake, &dop->dop_pending);
 }
 
 /* Abort all the intents that were committed. */
 STATIC void
 xfs_defer_trans_abort(
 	struct xfs_trans		*tp,
-	int				error)
+	struct list_head		*dop_pending)
 {
 	struct xfs_defer_ops		*dop = tp->t_dfops;
 	struct xfs_defer_pending	*dfp;
@@ -212,24 +210,21 @@ xfs_defer_trans_abort(
 	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
 
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
+	list_for_each_entry(dfp, dop_pending, dfp_list) {
 		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
 		if (dfp->dfp_intent && !dfp->dfp_done) {
 			dfp->dfp_type->abort_intent(dfp->dfp_intent);
 			dfp->dfp_intent = NULL;
 		}
 	}
-
-	/* Shut down FS. */
-	xfs_force_shutdown(tp->t_mountp, (error == -EFSCORRUPTED) ?
-			SHUTDOWN_CORRUPT_INCORE : SHUTDOWN_META_IO_ERROR);
 }
 
 /* Roll a transaction so we can do some deferred op processing. */
 STATIC int
 xfs_defer_trans_roll(
-	struct xfs_trans		**tp)
+	struct xfs_trans		**tpp)
 {
+	struct xfs_trans		*tp = *tpp;
 	struct xfs_buf_log_item		*bli;
 	struct xfs_inode_log_item	*ili;
 	struct xfs_log_item		*lip;
@@ -239,7 +234,7 @@ xfs_defer_trans_roll(
 	int				i;
 	int				error;
 
-	list_for_each_entry(lip, &(*tp)->t_items, li_trans) {
+	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		switch (lip->li_type) {
 		case XFS_LI_BUF:
 			bli = container_of(lip, struct xfs_buf_log_item,
@@ -249,7 +244,7 @@ xfs_defer_trans_roll(
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
-				xfs_trans_dirty_buf(*tp, bli->bli_buf);
+				xfs_trans_dirty_buf(tp, bli->bli_buf);
 				bplist[bpcount++] = bli->bli_buf;
 			}
 			break;
@@ -261,7 +256,7 @@ xfs_defer_trans_roll(
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
-				xfs_trans_log_inode(*tp, ili->ili_inode,
+				xfs_trans_log_inode(tp, ili->ili_inode,
 						    XFS_ILOG_CORE);
 				iplist[ipcount++] = ili->ili_inode;
 			}
@@ -271,39 +266,30 @@ xfs_defer_trans_roll(
 		}
 	}
 
-	trace_xfs_defer_trans_roll((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
+	trace_xfs_defer_trans_roll(tp->t_mountp, tp->t_dfops, _RET_IP_);
 
 	/* Roll the transaction. */
-	error = xfs_trans_roll(tp);
+	error = xfs_trans_roll(tpp);
+	tp = *tpp;
 	if (error) {
-		trace_xfs_defer_trans_roll_error((*tp)->t_mountp,
-						 (*tp)->t_dfops, error);
-		xfs_defer_trans_abort(*tp,  error);
+		trace_xfs_defer_trans_roll_error(tp->t_mountp,
+						 tp->t_dfops, error);
 		return error;
 	}
 
 	/* Rejoin the joined inodes. */
 	for (i = 0; i < ipcount; i++)
-		xfs_trans_ijoin(*tp, iplist[i], 0);
+		xfs_trans_ijoin(tp, iplist[i], 0);
 
 	/* Rejoin the buffers and dirty them so the log moves forward. */
 	for (i = 0; i < bpcount; i++) {
-		xfs_trans_bjoin(*tp, bplist[i]);
-		xfs_trans_bhold(*tp, bplist[i]);
+		xfs_trans_bjoin(tp, bplist[i]);
+		xfs_trans_bhold(tp, bplist[i]);
 	}
 
 	return error;
 }
 
-/* Do we have any work items to finish? */
-bool
-xfs_defer_has_unfinished_work(
-	struct xfs_trans		*tp)
-{
-	return !list_empty(&tp->t_dfops->dop_pending) ||
-		!list_empty(&tp->t_dfops->dop_intake);
-}
-
 /*
  * Reset an already used dfops after finish.
  */
@@ -311,7 +297,7 @@ static void
 xfs_defer_reset(
 	struct xfs_trans	*tp)
 {
-	ASSERT(!xfs_defer_has_unfinished_work(tp));
+	ASSERT(list_empty(&tp->t_dfops->dop_intake));
 
 	/*
 	 * Low mode state transfers across transaction rolls to mirror dfops
@@ -320,6 +306,36 @@ xfs_defer_reset(
 	tp->t_flags &= ~XFS_TRANS_LOWMODE;
 }
 
+/*
+ * Free up any items left in the list.
+ */
+static void
+xfs_defer_cancel_list(
+	struct xfs_mount		*mp,
+	struct list_head		*dop_list)
+{
+	struct xfs_defer_pending	*dfp;
+	struct xfs_defer_pending	*pli;
+	struct list_head		*pwi;
+	struct list_head		*n;
+
+	/*
+	 * Free the pending items.  Caller should already have arranged
+	 * for the intent items to be released.
+	 */
+	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list) {
+		trace_xfs_defer_cancel_list(mp, dfp);
+		list_del(&dfp->dfp_list);
+		list_for_each_safe(pwi, n, &dfp->dfp_work) {
+			list_del(pwi);
+			dfp->dfp_count--;
+			dfp->dfp_type->cancel_item(pwi);
+		}
+		ASSERT(dfp->dfp_count == 0);
+		kmem_free(dfp);
+	}
+}
+
 /*
  * Finish all the pending work.  This involves logging intent items for
  * any work items that wandered in since the last transaction roll (if
@@ -338,15 +354,19 @@ xfs_defer_finish_noroll(
 	void				*state;
 	int				error = 0;
 	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
+	LIST_HEAD(dop_pending);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	trace_xfs_defer_finish((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
 
 	/* Until we run out of pending work to finish... */
-	while (xfs_defer_has_unfinished_work(*tp)) {
-		/* Log intents for work items sitting in the intake. */
-		xfs_defer_intake_work(*tp);
+	while (!list_empty(&dop_pending) ||
+	       !list_empty(&(*tp)->t_dfops->dop_intake)) {
+		/* log intents and pull in intake items */
+		xfs_defer_create_intents(*tp);
+		list_splice_tail_init(&(*tp)->t_dfops->dop_intake,
+				      &dop_pending);
 
 		/*
 		 * Roll the transaction.
@@ -356,8 +376,8 @@ xfs_defer_finish_noroll(
 			goto out;
 
 		/* Log an intent-done item for the first pending item. */
-		dfp = list_first_entry(&(*tp)->t_dfops->dop_pending,
-				struct xfs_defer_pending, dfp_list);
+		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
+				       dfp_list);
 		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
 		dfp->dfp_done = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
 				dfp->dfp_count);
@@ -387,7 +407,6 @@ xfs_defer_finish_noroll(
 				 */
 				if (cleanup_fn)
 					cleanup_fn(*tp, state, error);
-				xfs_defer_trans_abort(*tp, error);
 				goto out;
 			}
 		}
@@ -417,8 +436,11 @@ xfs_defer_finish_noroll(
 
 out:
 	if (error) {
+		xfs_defer_trans_abort(*tp, &dop_pending);
+		xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 		trace_xfs_defer_finish_error((*tp)->t_mountp, (*tp)->t_dfops,
 					     error);
+		xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
 		xfs_defer_cancel(*tp);
 		return error;
 	}
@@ -442,54 +464,24 @@ xfs_defer_finish(
 		return error;
 	if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
 		error = xfs_defer_trans_roll(tp);
-		if (error)
+		if (error) {
+			xfs_force_shutdown((*tp)->t_mountp,
+					   SHUTDOWN_CORRUPT_INCORE);
 			return error;
+		}
 	}
 	xfs_defer_reset(*tp);
 	return 0;
 }
 
-/*
- * Free up any items left in the list.
- */
 void
 xfs_defer_cancel(
-	struct xfs_trans		*tp)
+	struct xfs_trans	*tp)
 {
-	struct xfs_defer_ops		*dop = tp->t_dfops;
-	struct xfs_defer_pending	*dfp;
-	struct xfs_defer_pending	*pli;
-	struct list_head		*pwi;
-	struct list_head		*n;
+	struct xfs_mount	*mp = tp->t_mountp;
 
-	trace_xfs_defer_cancel(NULL, dop, _RET_IP_);
-
-	/*
-	 * Free the pending items.  Caller should already have arranged
-	 * for the intent items to be released.
-	 */
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
-		trace_xfs_defer_pending_cancel(NULL, dfp);
-		list_del(&dfp->dfp_list);
-		list_for_each_safe(pwi, n, &dfp->dfp_work) {
-			list_del(pwi);
-			dfp->dfp_count--;
-			dfp->dfp_type->cancel_item(pwi);
-		}
-		ASSERT(dfp->dfp_count == 0);
-		kmem_free(dfp);
-	}
+	trace_xfs_defer_cancel(mp, tp->t_dfops, _RET_IP_);
+	xfs_defer_cancel_list(mp, &tp->t_dfops->dop_intake);
 }
 
 /* Add an item for later deferred processing. */
@@ -547,7 +539,6 @@ xfs_defer_init(
 
 	memset(dop, 0, sizeof(struct xfs_defer_ops));
 	INIT_LIST_HEAD(&dop->dop_intake);
-	INIT_LIST_HEAD(&dop->dop_pending);
 	if (tp) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
 		tp->t_dfops = dop;
@@ -571,7 +562,6 @@ xfs_defer_move(
 	ASSERT(dst != src);
 
 	list_splice_init(&src->dop_intake, &dst->dop_intake);
-	list_splice_init(&src->dop_pending, &dst->dop_pending);
 
 	/*
 	 * Low free space mode was historically controlled by a dfops field.
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index f051c8056141..f091bf3abeaf 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -41,7 +41,6 @@ int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
 void xfs_defer_cancel(struct xfs_trans *);
 void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
-bool xfs_defer_has_unfinished_work(struct xfs_trans *tp);
 void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8807f1bb814a..fec9cfe3dfb4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2392,9 +2392,8 @@ DEFINE_DEFER_EVENT(xfs_defer_finish_done);
 DEFINE_DEFER_ERROR_EVENT(xfs_defer_trans_roll_error);
 DEFINE_DEFER_ERROR_EVENT(xfs_defer_finish_error);
 
-DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_work);
-DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_cancel);
-DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_create_intent);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7c99aa6c04e2..413e4138357f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -929,7 +929,7 @@ __xfs_trans_commit(
 	 * Finish deferred items on final commit. Only permanent transactions
 	 * should ever have deferred ops.
 	 */
-	WARN_ON_ONCE(xfs_defer_has_unfinished_work(tp->t_dfops) &&
+	WARN_ON_ONCE(!list_empty(&tp->t_dfops->dop_intake) &&
 		     !(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
 	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
 		error = xfs_defer_finish_noroll(&tp);
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

