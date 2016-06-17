Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF94380C4
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:33:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 812318F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:03 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zHxBQt8G3kbbsekA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:01 -0700 (PDT)
Subject: [PATCH 021/145] xfs: add tracepoints for the deferred ops mechanism
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:32:55 -0700
Message-ID: <146612717592.16048.7184368661724183008.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h |   15 +++++++++++++++
 libxfs/xfs_defer.c  |   19 +++++++++++++++++++
 2 files changed, 34 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 56c4533..dd0d46f 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -169,6 +169,21 @@
 #define trace_xfs_btree_updkeys(...)		((void) 0)
 #define trace_xfs_btree_overlapped_query_range(...)	((void) 0)
 
+#define trace_xfs_defer_intake_work(...)	((void) 0)
+#define trace_xfs_defer_trans_abort(...)	((void) 0)
+#define trace_xfs_defer_pending_abort(...)	((void) 0)
+#define trace_xfs_defer_trans_roll(...)		((void) 0)
+#define trace_xfs_defer_trans_roll_error(...)	((void) 0)
+#define trace_xfs_defer_finish(...)		((void) 0)
+#define trace_xfs_defer_pending_commit(...)	((void) 0)
+#define trace_xfs_defer_pending_finish(...)	((void) 0)
+#define trace_xfs_defer_finish_error(...)	((void) 0)
+#define trace_xfs_defer_finish_done(...)	((void) 0)
+#define trace_xfs_defer_cancel(...)		((void) 0)
+#define trace_xfs_defer_intake_cancel(...)	((void) 0)
+#define trace_xfs_defer_pending_cancel(...)	((void) 0)
+#define trace_xfs_defer_init(...)		((void) 0)
+
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5ae5e0d..069b7bb 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -163,6 +163,7 @@ xfs_defer_intake_work(
 	struct xfs_defer_pending	*dfp;
 
 	list_for_each_entry(dfp, &dop->dop_intake, dfp_list) {
+		trace_xfs_defer_intake_work(tp->t_mountp, dfp);
 		dfp->dfp_intent = dfp->dfp_type->create_intent(tp,
 				dfp->dfp_count);
 		list_sort(tp->t_mountp, &dfp->dfp_work,
@@ -183,6 +184,7 @@ xfs_defer_trans_abort(
 {
 	struct xfs_defer_pending	*dfp;
 
+	trace_xfs_defer_trans_abort(tp->t_mountp, dop);
 	/*
 	 * If the transaction was committed, drop the intent reference
 	 * since we're bailing out of here. The other reference is
@@ -195,6 +197,7 @@ xfs_defer_trans_abort(
 
 	/* Abort intent items. */
 	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
+		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
 		if (dfp->dfp_committed)
 			dfp->dfp_type->abort_intent(dfp->dfp_intent);
 	}
@@ -221,9 +224,12 @@ xfs_defer_trans_roll(
 		xfs_trans_log_inode(*tp, dop->dop_inodes[i], XFS_ILOG_CORE);
 	}
 
+	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop);
+
 	/* Roll the transaction. */
 	error = xfs_trans_roll(tp, ip);
 	if (error) {
+		trace_xfs_defer_trans_roll_error((*tp)->t_mountp, dop, error);
 		xfs_defer_trans_abort(*tp, dop, error);
 		return error;
 	}
@@ -295,6 +301,8 @@ xfs_defer_finish(
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
+	trace_xfs_defer_finish((*tp)->t_mountp, dop);
+
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
 		/* Log intents for work items sitting in the intake. */
@@ -309,12 +317,14 @@ xfs_defer_finish(
 		list_for_each_entry_reverse(dfp, &dop->dop_pending, dfp_list) {
 			if (dfp->dfp_committed)
 				break;
+			trace_xfs_defer_pending_commit((*tp)->t_mountp, dfp);
 			dfp->dfp_committed = true;
 		}
 
 		/* Log an intent-done item for the first pending item. */
 		dfp = list_first_entry(&dop->dop_pending,
 				struct xfs_defer_pending, dfp_list);
+		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
 		done_item = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
 				dfp->dfp_count);
 		cleanup_fn = dfp->dfp_type->finish_cleanup;
@@ -370,6 +380,10 @@ xfs_defer_finish(
 	}
 
 out:
+	if (error)
+		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
+	else
+		trace_xfs_defer_finish_done((*tp)->t_mountp, dop);
 	return error;
 }
 
@@ -385,11 +399,14 @@ xfs_defer_cancel(
 	struct list_head		*pwi;
 	struct list_head		*n;
 
+	trace_xfs_defer_cancel(NULL, dop);
+
 	/*
 	 * Free the pending items.  Caller should already have arranged
 	 * for the intent items to be released.
 	 */
 	list_for_each_entry_safe(dfp, pli, &dop->dop_intake, dfp_list) {
+		trace_xfs_defer_intake_cancel(NULL, dfp);
 		list_del(&dfp->dfp_list);
 		list_for_each_safe(pwi, n, &dfp->dfp_work) {
 			list_del(pwi);
@@ -400,6 +417,7 @@ xfs_defer_cancel(
 		kmem_free(dfp);
 	}
 	list_for_each_entry_safe(dfp, pli, &dop->dop_pending, dfp_list) {
+		trace_xfs_defer_pending_cancel(NULL, dfp);
 		list_del(&dfp->dfp_list);
 		list_for_each_safe(pwi, n, &dfp->dfp_work) {
 			list_del(pwi);
@@ -468,4 +486,5 @@ xfs_defer_init(
 	*fbp = NULLFSBLOCK;
 	INIT_LIST_HEAD(&dop->dop_intake);
 	INIT_LIST_HEAD(&dop->dop_pending);
+	trace_xfs_defer_init(NULL, dop);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
