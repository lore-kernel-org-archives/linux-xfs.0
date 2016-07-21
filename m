Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18DE97CDE
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:57:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFE4B8F8037
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GjxAxWCEQymx96vc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:33 -0700 (PDT)
Subject: [PATCH 12/47] xfs: add tracepoints for the deferred ops mechanism
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:57:23 -0700
Message-ID: <146907704362.25461.15182558837136422077.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Add tracepoints for the internals of the deferred ops mechanism
and tracepoint classes for clients of the dops, to make debugging
easier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c |   19 ++++
 fs/xfs/xfs_trace.c        |    1 
 fs/xfs/xfs_trace.h        |  198 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 218 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 2809db7..054a203 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -159,6 +159,7 @@ xfs_defer_intake_work(
 	struct xfs_defer_pending	*dfp;
 
 	list_for_each_entry(dfp, &dop->dop_intake, dfp_list) {
+		trace_xfs_defer_intake_work(tp->t_mountp, dfp);
 		dfp->dfp_intent = dfp->dfp_type->create_intent(tp,
 				dfp->dfp_count);
 		list_sort(tp->t_mountp, &dfp->dfp_work,
@@ -179,6 +180,7 @@ xfs_defer_trans_abort(
 {
 	struct xfs_defer_pending	*dfp;
 
+	trace_xfs_defer_trans_abort(tp->t_mountp, dop);
 	/*
 	 * If the transaction was committed, drop the intent reference
 	 * since we're bailing out of here. The other reference is
@@ -191,6 +193,7 @@ xfs_defer_trans_abort(
 
 	/* Abort intent items. */
 	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
+		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
 		if (dfp->dfp_committed)
 			dfp->dfp_type->abort_intent(dfp->dfp_intent);
 	}
@@ -217,9 +220,12 @@ xfs_defer_trans_roll(
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
@@ -291,6 +297,8 @@ xfs_defer_finish(
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
+	trace_xfs_defer_finish((*tp)->t_mountp, dop);
+
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
 		/* Log intents for work items sitting in the intake. */
@@ -305,12 +313,14 @@ xfs_defer_finish(
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
@@ -343,6 +353,10 @@ xfs_defer_finish(
 	}
 
 out:
+	if (error)
+		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
+	else
+		trace_xfs_defer_finish_done((*tp)->t_mountp, dop);
 	return error;
 }
 
@@ -358,11 +372,14 @@ xfs_defer_cancel(
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
@@ -373,6 +390,7 @@ xfs_defer_cancel(
 		kmem_free(dfp);
 	}
 	list_for_each_entry_safe(dfp, pli, &dop->dop_pending, dfp_list) {
+		trace_xfs_defer_pending_cancel(NULL, dfp);
 		list_del(&dfp->dfp_list);
 		list_for_each_safe(pwi, n, &dfp->dfp_work) {
 			list_del(pwi);
@@ -441,4 +459,5 @@ xfs_defer_init(
 	*fbp = NULLFSBLOCK;
 	INIT_LIST_HEAD(&dop->dop_intake);
 	INIT_LIST_HEAD(&dop->dop_pending);
+	trace_xfs_defer_init(NULL, dop);
 }
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 13a0298..3971527 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -22,6 +22,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a586268..a45b030 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2222,6 +2222,204 @@ DEFINE_EVENT(xfs_btree_cur_class, name, \
 DEFINE_BTREE_CUR_EVENT(xfs_btree_updkeys);
 DEFINE_BTREE_CUR_EVENT(xfs_btree_overlapped_query_range);
 
+/* deferred ops */
+struct xfs_defer_pending;
+struct xfs_defer_intake;
+struct xfs_defer_ops;
+
+DECLARE_EVENT_CLASS(xfs_defer_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop),
+	TP_ARGS(mp, dop),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(void *, dop)
+		__field(bool, committed)
+		__field(bool, low)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->dop = dop;
+		__entry->committed = dop->dop_committed;
+		__entry->low = dop->dop_low;
+	),
+	TP_printk("dev %d:%d ops %p committed %d low %d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dop,
+		  __entry->committed,
+		  __entry->low)
+)
+#define DEFINE_DEFER_EVENT(name) \
+DEFINE_EVENT(xfs_defer_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop), \
+	TP_ARGS(mp, dop))
+
+DECLARE_EVENT_CLASS(xfs_defer_error_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop, int error),
+	TP_ARGS(mp, dop, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(void *, dop)
+		__field(bool, committed)
+		__field(bool, low)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->dop = dop;
+		__entry->committed = dop->dop_committed;
+		__entry->low = dop->dop_low;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d ops %p committed %d low %d err %d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dop,
+		  __entry->committed,
+		  __entry->low,
+		  __entry->error)
+)
+#define DEFINE_DEFER_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_defer_error_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop, int error), \
+	TP_ARGS(mp, dop, error))
+
+DECLARE_EVENT_CLASS(xfs_defer_pending_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp),
+	TP_ARGS(mp, dfp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, type)
+		__field(void *, intent)
+		__field(bool, committed)
+		__field(int, nr)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->type = dfp->dfp_type->type;
+		__entry->intent = dfp->dfp_intent;
+		__entry->committed = dfp->dfp_committed;
+		__entry->nr = dfp->dfp_count;
+	),
+	TP_printk("dev %d:%d optype %d intent %p committed %d nr %d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->intent,
+		  __entry->committed,
+		  __entry->nr)
+)
+#define DEFINE_DEFER_PENDING_EVENT(name) \
+DEFINE_EVENT(xfs_defer_pending_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp), \
+	TP_ARGS(mp, dfp))
+
+DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, type, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, type)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->type = type;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d op %d agno %u agbno %u len %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+);
+#define DEFINE_PHYS_EXTENT_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_phys_extent_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int type, \
+		 xfs_agblock_t bno, \
+		 xfs_extlen_t len), \
+	TP_ARGS(mp, agno, type, bno, len))
+
+DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int op,
+		 xfs_agblock_t agbno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 xfs_fileoff_t offset,
+		 xfs_filblks_t len,
+		 xfs_exntst_t state),
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agblock_t, agbno)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_filblks_t, l_len)
+		__field(xfs_exntst_t, l_state)
+		__field(int, op)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->agbno = agbno;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = offset;
+		__entry->l_len = len;
+		__entry->l_state = state;
+		__entry->op = op;
+	),
+	TP_printk("dev %d:%d op %d agno %u agbno %u owner %lld %s offset %llu len %llu state %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->op,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->ino,
+		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __entry->l_loff,
+		  __entry->l_len,
+		  __entry->l_state)
+);
+#define DEFINE_MAP_EXTENT_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_map_extent_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int op, \
+		 xfs_agblock_t agbno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 xfs_fileoff_t offset, \
+		 xfs_filblks_t len, \
+		 xfs_exntst_t state), \
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
+
+DEFINE_DEFER_EVENT(xfs_defer_init);
+DEFINE_DEFER_EVENT(xfs_defer_cancel);
+DEFINE_DEFER_EVENT(xfs_defer_trans_roll);
+DEFINE_DEFER_EVENT(xfs_defer_trans_abort);
+DEFINE_DEFER_EVENT(xfs_defer_finish);
+DEFINE_DEFER_EVENT(xfs_defer_finish_done);
+
+DEFINE_DEFER_ERROR_EVENT(xfs_defer_trans_roll_error);
+DEFINE_DEFER_ERROR_EVENT(xfs_defer_finish_error);
+DEFINE_DEFER_ERROR_EVENT(xfs_defer_op_finish_error);
+
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_work);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_cancel);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_commit);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
+
+DEFINE_PHYS_EXTENT_DEFERRED_EVENT(xfs_defer_phys_extent);
+DEFINE_MAP_EXTENT_DEFERRED_EVENT(xfs_defer_map_extent);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
