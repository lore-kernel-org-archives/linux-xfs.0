Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:32800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732159AbeG3SVM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 14:21:12 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 201A4402316D
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09AEE112D179
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 10/15] xfs: clean out superfluous dfops dop params/vars
Date: Mon, 30 Jul 2018 12:45:15 -0400
Message-Id: <20180730164520.36882-11-bfoster@redhat.com>
In-Reply-To: <20180730164520.36882-1-bfoster@redhat.com>
References: <20180730164520.36882-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The dfops code still passes around the xfs_defer_ops pointer
superfluously in a few places. Clean this up wherever the
transaction will suffice.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c | 43 +++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_defer.h |  2 +-
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 7fb7edd5d63e..7b84e3a4b7f3 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -181,9 +181,9 @@ static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
  */
 STATIC void
 xfs_defer_intake_work(
-	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop)
+	struct xfs_trans		*tp)
 {
+	struct xfs_defer_ops		*dop = tp->t_dfops;
 	struct list_head		*li;
 	struct xfs_defer_pending	*dfp;
 
@@ -204,9 +204,9 @@ xfs_defer_intake_work(
 STATIC void
 xfs_defer_trans_abort(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop,
 	int				error)
 {
+	struct xfs_defer_ops		*dop = tp->t_dfops;
 	struct xfs_defer_pending	*dfp;
 
 	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
@@ -230,7 +230,6 @@ STATIC int
 xfs_defer_trans_roll(
 	struct xfs_trans		**tp)
 {
-	struct xfs_defer_ops		*dop = (*tp)->t_dfops;
 	struct xfs_buf_log_item		*bli;
 	struct xfs_inode_log_item	*ili;
 	struct xfs_log_item		*lip;
@@ -266,14 +265,14 @@ xfs_defer_trans_roll(
 		}
 	}
 
-	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop, _RET_IP_);
+	trace_xfs_defer_trans_roll((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
 
 	/* Roll the transaction. */
 	error = xfs_trans_roll(tp);
-	dop = (*tp)->t_dfops;
 	if (error) {
-		trace_xfs_defer_trans_roll_error((*tp)->t_mountp, dop, error);
-		xfs_defer_trans_abort(*tp, dop, error);
+		trace_xfs_defer_trans_roll_error((*tp)->t_mountp,
+						 (*tp)->t_dfops, error);
+		xfs_defer_trans_abort(*tp,  error);
 		return error;
 	}
 
@@ -293,9 +292,10 @@ xfs_defer_trans_roll(
 /* Do we have any work items to finish? */
 bool
 xfs_defer_has_unfinished_work(
-	struct xfs_defer_ops		*dop)
+	struct xfs_trans		*tp)
 {
-	return !list_empty(&dop->dop_pending) || !list_empty(&dop->dop_intake);
+	return !list_empty(&tp->t_dfops->dop_pending) ||
+		!list_empty(&tp->t_dfops->dop_intake);
 }
 
 /*
@@ -305,7 +305,7 @@ static void
 xfs_defer_reset(
 	struct xfs_trans	*tp)
 {
-	ASSERT(!xfs_defer_has_unfinished_work(tp->t_dfops));
+	ASSERT(!xfs_defer_has_unfinished_work(tp));
 
 	/*
 	 * Low mode state transfers across transaction rolls to mirror dfops
@@ -326,7 +326,6 @@ int
 xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
-	struct xfs_defer_ops		*dop = (*tp)->t_dfops;
 	struct xfs_defer_pending	*dfp;
 	struct list_head		*li;
 	struct list_head		*n;
@@ -336,24 +335,22 @@ xfs_defer_finish_noroll(
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
-	trace_xfs_defer_finish((*tp)->t_mountp, dop, _RET_IP_);
+	trace_xfs_defer_finish((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
 
 	/* Until we run out of pending work to finish... */
-	while (xfs_defer_has_unfinished_work(dop)) {
+	while (xfs_defer_has_unfinished_work(*tp)) {
 		/* Log intents for work items sitting in the intake. */
-		xfs_defer_intake_work(*tp, dop);
+		xfs_defer_intake_work(*tp);
 
 		/*
-		 * Roll the transaction and update dop in case dfops was
-		 * embedded in the transaction.
+		 * Roll the transaction.
 		 */
 		error = xfs_defer_trans_roll(tp);
 		if (error)
 			goto out;
-		dop = (*tp)->t_dfops;
 
 		/* Log an intent-done item for the first pending item. */
-		dfp = list_first_entry(&dop->dop_pending,
+		dfp = list_first_entry(&(*tp)->t_dfops->dop_pending,
 				struct xfs_defer_pending, dfp_list);
 		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
 		dfp->dfp_done = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
@@ -384,7 +381,7 @@ xfs_defer_finish_noroll(
 				 */
 				if (cleanup_fn)
 					cleanup_fn(*tp, state, error);
-				xfs_defer_trans_abort(*tp, dop, error);
+				xfs_defer_trans_abort(*tp, error);
 				goto out;
 			}
 		}
@@ -414,9 +411,11 @@ xfs_defer_finish_noroll(
 
 out:
 	if (error)
-		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
+		trace_xfs_defer_finish_error((*tp)->t_mountp, (*tp)->t_dfops,
+					     error);
 	 else
-		trace_xfs_defer_finish_done((*tp)->t_mountp, dop, _RET_IP_);
+		trace_xfs_defer_finish_done((*tp)->t_mountp, (*tp)->t_dfops,
+					    _RET_IP_);
 
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 0de7504e5651..f051c8056141 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -41,7 +41,7 @@ int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
 void xfs_defer_cancel(struct xfs_trans *);
 void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
-bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
+bool xfs_defer_has_unfinished_work(struct xfs_trans *tp);
 void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
-- 
2.17.1

