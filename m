Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731729AbeGSOci (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:32:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2944C40704A7
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14A9E1C5B0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 14/14] xfs: drop unnecessary xfs_defer_finish() dfops parameter
Date: Thu, 19 Jul 2018 09:49:19 -0400
Message-Id: <20180719134919.29939-15-bfoster@redhat.com>
In-Reply-To: <20180719134919.29939-1-bfoster@redhat.com>
References: <20180719134919.29939-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Every caller of xfs_defer_finish() now passes the transaction and
its associated ->t_dfops. The xfs_defer_ops parameter is therefore
no longer necessary and can be removed.

Since most xfs_defer_finish() callers also have to consider
xfs_defer_cancel() on error, update the latter to also receive the
transaction for consistency. The log recovery code contains an
outlier case that cancels a dfops directly without an available
transaction. Retain an internal wrapper to support this outlier case
for the time being.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 27 +++++++++++++--------------
 fs/xfs/libxfs/xfs_attr_remote.c |  8 ++++----
 fs/xfs/libxfs/xfs_defer.c       |  7 +++----
 fs/xfs/libxfs/xfs_defer.h       |  4 ++--
 fs/xfs/xfs_bmap_util.c          |  4 ++--
 fs/xfs/xfs_dquot.c              |  4 ++--
 fs/xfs/xfs_inode.c              |  4 ++--
 fs/xfs/xfs_log_recover.c        |  2 +-
 fs/xfs/xfs_reflink.c            |  8 ++++----
 fs/xfs/xfs_trans.c              |  6 +++---
 fs/xfs/xfs_trans.h              |  8 ++++++++
 11 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3e98f0af389c..3deb5cdadf08 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -322,7 +322,7 @@ xfs_attr_set(
 		xfs_trans_bhold(args.trans, leaf_bp);
 		xfs_defer_bjoin(args.trans->t_dfops, leaf_bp);
 		xfs_defer_ijoin(args.trans->t_dfops, dp);
-		error = xfs_defer_finish(&args.trans, args.trans->t_dfops);
+		error = xfs_defer_finish(&args.trans);
 		if (error)
 			goto out;
 
@@ -591,7 +591,7 @@ xfs_attr_leaf_addname(
 		if (error)
 			goto out_defer_cancel;
 		xfs_defer_ijoin(args->trans->t_dfops, dp);
-		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+		error = xfs_defer_finish(&args->trans);
 		if (error)
 			goto out_defer_cancel;
 
@@ -680,7 +680,7 @@ xfs_attr_leaf_addname(
 			if (error)
 				goto out_defer_cancel;
 			xfs_defer_ijoin(args->trans->t_dfops, dp);
-			error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out_defer_cancel;
 		}
@@ -698,7 +698,7 @@ xfs_attr_leaf_addname(
 	}
 	return error;
 out_defer_cancel:
-	xfs_defer_cancel(args->trans->t_dfops);
+	xfs_defer_cancel(args->trans);
 	return error;
 }
 
@@ -744,13 +744,13 @@ xfs_attr_leaf_removename(
 		if (error)
 			goto out_defer_cancel;
 		xfs_defer_ijoin(args->trans->t_dfops, dp);
-		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+		error = xfs_defer_finish(&args->trans);
 		if (error)
 			goto out_defer_cancel;
 	}
 	return 0;
 out_defer_cancel:
-	xfs_defer_cancel(args->trans->t_dfops);
+	xfs_defer_cancel(args->trans);
 	return error;
 }
 
@@ -871,8 +871,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out_defer_cancel;
 			xfs_defer_ijoin(args->trans->t_dfops, dp);
-			error = xfs_defer_finish(&args->trans,
-						 args->trans->t_dfops);
+			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out_defer_cancel;
 
@@ -897,7 +896,7 @@ xfs_attr_node_addname(
 		if (error)
 			goto out_defer_cancel;
 		xfs_defer_ijoin(args->trans->t_dfops, dp);
-		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+		error = xfs_defer_finish(&args->trans);
 		if (error)
 			goto out_defer_cancel;
 	} else {
@@ -994,7 +993,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out_defer_cancel;
 			xfs_defer_ijoin(args->trans->t_dfops, dp);
-			error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out_defer_cancel;
 		}
@@ -1023,7 +1022,7 @@ xfs_attr_node_addname(
 		return error;
 	return retval;
 out_defer_cancel:
-	xfs_defer_cancel(args->trans->t_dfops);
+	xfs_defer_cancel(args->trans);
 	goto out;
 }
 
@@ -1118,7 +1117,7 @@ xfs_attr_node_removename(
 		if (error)
 			goto out_defer_cancel;
 		xfs_defer_ijoin(args->trans->t_dfops, dp);
-		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+		error = xfs_defer_finish(&args->trans);
 		if (error)
 			goto out_defer_cancel;
 		/*
@@ -1150,7 +1149,7 @@ xfs_attr_node_removename(
 			if (error)
 				goto out_defer_cancel;
 			xfs_defer_ijoin(args->trans->t_dfops, dp);
-			error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out_defer_cancel;
 		} else
@@ -1162,7 +1161,7 @@ xfs_attr_node_removename(
 	xfs_da_state_free(state);
 	return error;
 out_defer_cancel:
-	xfs_defer_cancel(args->trans->t_dfops);
+	xfs_defer_cancel(args->trans);
 	goto out;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 0fbfb740949e..77ca38586913 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -487,7 +487,7 @@ xfs_attr_rmtval_set(
 		if (error)
 			goto out_defer_cancel;
 		xfs_defer_ijoin(args->trans->t_dfops, dp);
-		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+		error = xfs_defer_finish(&args->trans);
 		if (error)
 			goto out_defer_cancel;
 
@@ -555,7 +555,7 @@ xfs_attr_rmtval_set(
 	ASSERT(valuelen == 0);
 	return 0;
 out_defer_cancel:
-	xfs_defer_cancel(args->trans->t_dfops);
+	xfs_defer_cancel(args->trans);
 	return error;
 }
 
@@ -628,7 +628,7 @@ xfs_attr_rmtval_remove(
 		if (error)
 			goto out_defer_cancel;
 		xfs_defer_ijoin(args->trans->t_dfops, args->dp);
-		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
+		error = xfs_defer_finish(&args->trans);
 		if (error)
 			goto out_defer_cancel;
 
@@ -641,6 +641,6 @@ xfs_attr_rmtval_remove(
 	}
 	return 0;
 out_defer_cancel:
-	xfs_defer_cancel(args->trans->t_dfops);
+	xfs_defer_cancel(args->trans);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 415fcf720cc9..a46cf25b85db 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -352,9 +352,9 @@ xfs_defer_reset(
  */
 int
 xfs_defer_finish(
-	struct xfs_trans		**tp,
-	struct xfs_defer_ops		*dop)
+	struct xfs_trans		**tp)
 {
+	struct xfs_defer_ops		*dop = (*tp)->t_dfops;
 	struct xfs_defer_pending	*dfp;
 	struct list_head		*li;
 	struct list_head		*n;
@@ -363,7 +363,6 @@ xfs_defer_finish(
 	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
-	ASSERT((*tp)->t_dfops == dop);
 
 	trace_xfs_defer_finish((*tp)->t_mountp, dop, _RET_IP_);
 
@@ -456,7 +455,7 @@ xfs_defer_finish(
  * Free up any items left in the list.
  */
 void
-xfs_defer_cancel(
+__xfs_defer_cancel(
 	struct xfs_defer_ops		*dop)
 {
 	struct xfs_defer_pending	*dfp;
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 349b4d906fb2..b9687a0a5086 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -61,8 +61,8 @@ struct xfs_defer_ops {
 
 void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
 		struct list_head *h);
-int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop);
-void xfs_defer_cancel(struct xfs_defer_ops *dop);
+int xfs_defer_finish(struct xfs_trans **tp);
+void __xfs_defer_cancel(struct xfs_defer_ops *dop);
 void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
 bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
 int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6b0f31402a81..7b40e9fef381 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1624,7 +1624,7 @@ xfs_swap_extent_rmap(
 				goto out_defer;
 
 			xfs_defer_ijoin(tp->t_dfops, ip);
-			error = xfs_defer_finish(tpp, tp->t_dfops);
+			error = xfs_defer_finish(tpp);
 			tp = *tpp;
 			if (error)
 				goto out_defer;
@@ -1645,7 +1645,7 @@ xfs_swap_extent_rmap(
 	return 0;
 
 out_defer:
-	xfs_defer_cancel(tp->t_dfops);
+	xfs_defer_cancel(tp);
 out:
 	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
 	tip->i_d.di_flags2 = tip_flags2;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a57d5e8c3118..da5c55cec966 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -368,7 +368,7 @@ xfs_dquot_disk_alloc(
 		xfs_trans_brelse(tp, bp);
 		goto error1;
 	}
-	error = xfs_defer_finish(tpp, tp->t_dfops);
+	error = xfs_defer_finish(tpp);
 	tp = *tpp;
 	if (error) {
 		xfs_buf_relse(bp);
@@ -378,7 +378,7 @@ xfs_dquot_disk_alloc(
 	return 0;
 
 error1:
-	xfs_defer_cancel(tp->t_dfops);
+	xfs_defer_cancel(tp);
 error0:
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c47183a2f167..0e4bd559a6a7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1570,7 +1570,7 @@ xfs_itruncate_extents_flags(
 		 * reservation and commit the old transaction.
 		 */
 		xfs_defer_ijoin(tp->t_dfops, ip);
-		error = xfs_defer_finish(&tp, tp->t_dfops);
+		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1606,7 +1606,7 @@ xfs_itruncate_extents_flags(
 	 * the transaction can be properly aborted.  We just need to make sure
 	 * we're not holding any resources that we were not when we came in.
 	 */
-	xfs_defer_cancel(tp->t_dfops);
+	xfs_defer_cancel(tp);
 	goto out;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 265e1f561157..94908a4019e1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4946,7 +4946,7 @@ xlog_recover_process_intents(
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
 	if (error)
-		xfs_defer_cancel(&dfops);
+		__xfs_defer_cancel(&dfops);
 	else
 		error = xlog_finish_defer_ops(log->l_mp, &dfops);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f46983b1b302..8b394b60d9be 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -518,9 +518,9 @@ xfs_reflink_cancel_cow_blocks(
 
 			/* Roll the transaction */
 			xfs_defer_ijoin((*tpp)->t_dfops, ip);
-			error = xfs_defer_finish(tpp, (*tpp)->t_dfops);
+			error = xfs_defer_finish(tpp);
 			if (error) {
-				xfs_defer_cancel((*tpp)->t_dfops);
+				xfs_defer_cancel(*tpp);
 				break;
 			}
 
@@ -716,7 +716,7 @@ xfs_reflink_end_cow(
 		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 		xfs_defer_ijoin(tp->t_dfops, ip);
-		error = xfs_defer_finish(&tp, tp->t_dfops);
+		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out_cancel;
 		if (!xfs_iext_get_extent(ifp, &icur, &got))
@@ -1077,7 +1077,7 @@ xfs_reflink_remap_extent(
 next_extent:
 		/* Process all the deferred stuff. */
 		xfs_defer_ijoin(tp->t_dfops, ip);
-		error = xfs_defer_finish(&tp, tp->t_dfops);
+		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out_cancel;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 142410632a36..5c0ba0ed0878 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -933,9 +933,9 @@ __xfs_trans_commit(
 
 	/* finish deferred items on final commit */
 	if (!regrant && tp->t_dfops) {
-		error = xfs_defer_finish(&tp, tp->t_dfops);
+		error = xfs_defer_finish(&tp);
 		if (error) {
-			xfs_defer_cancel(tp->t_dfops);
+			xfs_defer_cancel(tp);
 			goto out_unreserve;
 		}
 	}
@@ -1030,7 +1030,7 @@ xfs_trans_cancel(
 	trace_xfs_trans_cancel(tp, _RET_IP_);
 
 	if (tp->t_dfops)
-		xfs_defer_cancel(tp->t_dfops);
+		xfs_defer_cancel(tp);
 
 	/*
 	 * See if the caller is relying on us to shut down the
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index bab857c36d3a..7badbe03c342 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -199,6 +199,14 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
+/* cancel dfops associated with a transaction */
+static inline void
+xfs_defer_cancel(
+	struct xfs_trans *tp)
+{
+	__xfs_defer_cancel(tp->t_dfops);
+}
+
 struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
-- 
2.17.1

