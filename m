Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75D2D810D
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:48:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF1E5AC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:14 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pihmGfAuU9rwIzMp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:12 -0700 (PDT)
Subject: [PATCH 15/71] xfs: connect refcount adjust functions to upper layers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:48:07 -0700
Message-ID: <147216888791.4420.9015511823939396368.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Plumb in the upper level interface to schedule and finish deferred
refcount operations via the deferred ops mechanism.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h   |    1 
 libxfs/defer_item.c   |  129 +++++++++++++++++++++++++++++++++++++
 libxfs/init.c         |    1 
 libxfs/xfs_defer.h    |    1 
 libxfs/xfs_refcount.c |  170 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount.h |   12 +++
 6 files changed, 314 insertions(+)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index ab5d59b..739a792 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -147,5 +147,6 @@ libxfs_trans_read_buf(
 
 void xfs_extent_free_init_defer_op(void);
 void xfs_rmap_update_init_defer_op(void);
+void xfs_refcount_update_init_defer_op(void);
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index f60a11b..133e6e1 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -31,6 +31,7 @@
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -257,3 +258,131 @@ xfs_rmap_update_init_defer_op(void)
 {
 	xfs_defer_init_op_type(&xfs_rmap_update_defer_type);
 }
+
+/* Reference Counting */
+
+/* Sort refcount intents by AG. */
+static int
+xfs_refcount_update_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_mount		*mp = priv;
+	struct xfs_refcount_intent	*ra;
+	struct xfs_refcount_intent	*rb;
+
+	ra = container_of(a, struct xfs_refcount_intent, ri_list);
+	rb = container_of(b, struct xfs_refcount_intent, ri_list);
+	return  XFS_FSB_TO_AGNO(mp, ra->ri_startblock) -
+		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
+}
+
+/* Get an CUI. */
+STATIC void *
+xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Log refcount updates in the intent item. */
+STATIC void
+xfs_refcount_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+}
+
+/* Get an CUD so we can process all the deferred refcount updates. */
+STATIC void *
+xfs_refcount_update_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Process a deferred refcount update. */
+STATIC int
+xfs_refcount_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dop,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_refcount_intent	*refc;
+	xfs_extlen_t			adjusted;
+	int				error;
+
+	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+	error = xfs_refcount_finish_one(tp, dop,
+			refc->ri_type,
+			refc->ri_startblock,
+			refc->ri_blockcount,
+			&adjusted,
+			(struct xfs_btree_cur **)state);
+	/* Did we run out of reservation?  Requeue what we didn't finish. */
+	if (!error && adjusted < refc->ri_blockcount) {
+		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
+		       refc->ri_type == XFS_REFCOUNT_DECREASE);
+		refc->ri_startblock += adjusted;
+		refc->ri_blockcount -= adjusted;
+		return -EAGAIN;
+	}
+	kmem_free(refc);
+	return error;
+}
+
+/* Clean up after processing deferred refcounts. */
+STATIC void
+xfs_refcount_update_finish_cleanup(
+	struct xfs_trans	*tp,
+	void			*state,
+	int			error)
+{
+	struct xfs_btree_cur	*rcur = state;
+
+	xfs_refcount_finish_one_cleanup(tp, rcur, error);
+}
+
+/* Abort all pending CUIs. */
+STATIC void
+xfs_refcount_update_abort_intent(
+	void				*intent)
+{
+}
+
+/* Cancel a deferred refcount update. */
+STATIC void
+xfs_refcount_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_refcount_intent	*refc;
+
+	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+	kmem_free(refc);
+}
+
+static const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_REFCOUNT,
+	.diff_items	= xfs_refcount_update_diff_items,
+	.create_intent	= xfs_refcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.log_item	= xfs_refcount_update_log_item,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_refcount_update_finish_item,
+	.finish_cleanup = xfs_refcount_update_finish_cleanup,
+	.cancel_item	= xfs_refcount_update_cancel_item,
+};
+
+/* Register the deferred op type. */
+void
+xfs_refcount_update_init_defer_op(void)
+{
+	xfs_defer_init_op_type(&xfs_refcount_update_defer_type);
+}
diff --git a/libxfs/init.c b/libxfs/init.c
index 706925d..2d1bb58 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -266,6 +266,7 @@ libxfs_init(libxfs_init_t *a)
 
 	xfs_extent_free_init_defer_op();
 	xfs_rmap_update_init_defer_op();
+	xfs_refcount_update_init_defer_op();
 
 	radix_tree_init();
 
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index cc3981c..d47a482 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -51,6 +51,7 @@ struct xfs_defer_pending {
  * find all the space it needs.
  */
 enum xfs_defer_ops_type {
+	XFS_DEFER_OPS_TYPE_REFCOUNT,
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_MAX,
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 08866f8..31028bf 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -957,3 +957,173 @@ out_error:
 			error, _RET_IP_);
 	return error;
 }
+
+/* Clean up after calling xfs_refcount_finish_one. */
+void
+xfs_refcount_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	struct xfs_buf		*agbp;
+
+	if (rcur == NULL)
+		return;
+	agbp = rcur->bc_private.a.agbp;
+	xfs_btree_del_cursor(rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	if (error)
+		xfs_trans_brelse(tp, agbp);
+}
+
+/*
+ * Process one of the deferred refcount operations.  We pass back the
+ * btree cursor to maintain our lock on the btree between calls.
+ * This saves time and eliminates a buffer deadlock between the
+ * superblock and the AGF because we'll always grab them in the same
+ * order.
+ */
+int
+xfs_refcount_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dfops,
+	enum xfs_refcount_intent_type	type,
+	xfs_fsblock_t			startblock,
+	xfs_extlen_t			blockcount,
+	xfs_extlen_t			*adjusted,
+	struct xfs_btree_cur		**pcur)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*rcur;
+	struct xfs_buf			*agbp = NULL;
+	int				error = 0;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+	unsigned long			nr_ops = 0;
+	int				shape_changes = 0;
+
+	agno = XFS_FSB_TO_AGNO(mp, startblock);
+	ASSERT(agno != NULLAGNUMBER);
+	bno = XFS_FSB_TO_AGBNO(mp, startblock);
+
+	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, startblock),
+			type, XFS_FSB_TO_AGBNO(mp, startblock),
+			blockcount);
+
+	if (XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_REFCOUNT_FINISH_ONE,
+			XFS_RANDOM_REFCOUNT_FINISH_ONE))
+		return -EIO;
+
+	/*
+	 * If we haven't gotten a cursor or the cursor AG doesn't match
+	 * the startblock, get one now.
+	 */
+	rcur = *pcur;
+	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
+		nr_ops = rcur->bc_private.a.priv.refc.nr_ops;
+		shape_changes = rcur->bc_private.a.priv.refc.shape_changes;
+		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
+		rcur = NULL;
+		*pcur = NULL;
+	}
+	if (rcur == NULL) {
+		error = xfs_alloc_read_agf(tp->t_mountp, tp, agno,
+				XFS_ALLOC_FLAG_FREEING, &agbp);
+		if (error)
+			return error;
+		if (!agbp)
+			return -EFSCORRUPTED;
+
+		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, dfops);
+		if (!rcur) {
+			error = -ENOMEM;
+			goto out_cur;
+		}
+		rcur->bc_private.a.priv.refc.nr_ops = nr_ops;
+		rcur->bc_private.a.priv.refc.shape_changes = shape_changes;
+	}
+	*pcur = rcur;
+
+	switch (type) {
+	case XFS_REFCOUNT_INCREASE:
+		error = xfs_refcount_adjust(rcur, bno, blockcount, adjusted,
+			XFS_REFCOUNT_ADJUST_INCREASE, dfops, NULL);
+		break;
+	case XFS_REFCOUNT_DECREASE:
+		error = xfs_refcount_adjust(rcur, bno, blockcount, adjusted,
+			XFS_REFCOUNT_ADJUST_DECREASE, dfops, NULL);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+	}
+	if (!error && *adjusted != blockcount)
+		trace_xfs_refcount_finish_one_leftover(mp, agno, type,
+				bno, blockcount, *adjusted);
+	return error;
+
+out_cur:
+	xfs_trans_brelse(tp, agbp);
+
+	return error;
+}
+
+/*
+ * Record a refcount intent for later processing.
+ */
+static int
+__xfs_refcount_add(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	enum xfs_refcount_intent_type	type,
+	xfs_fsblock_t			startblock,
+	xfs_extlen_t			blockcount)
+{
+	struct xfs_refcount_intent	*ri;
+
+	trace_xfs_refcount_defer(mp, XFS_FSB_TO_AGNO(mp, startblock),
+			type, XFS_FSB_TO_AGBNO(mp, startblock),
+			blockcount);
+
+	ri = kmem_alloc(sizeof(struct xfs_refcount_intent),
+			KM_SLEEP | KM_NOFS);
+	INIT_LIST_HEAD(&ri->ri_list);
+	ri->ri_type = type;
+	ri->ri_startblock = startblock;
+	ri->ri_blockcount = blockcount;
+
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
+	return 0;
+}
+
+/*
+ * Increase the reference count of the blocks backing a file's extent.
+ */
+int
+xfs_refcount_increase_extent(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	struct xfs_bmbt_irec		*PREV)
+{
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_INCREASE,
+			PREV->br_startblock, PREV->br_blockcount);
+}
+
+/*
+ * Decrease the reference count of the blocks backing a file's extent.
+ */
+int
+xfs_refcount_decrease_extent(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	struct xfs_bmbt_irec		*PREV)
+{
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_DECREASE,
+			PREV->br_startblock, PREV->br_blockcount);
+}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 2ef2b28..605d7d7 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -41,4 +41,16 @@ struct xfs_refcount_intent {
 	xfs_extlen_t				ri_blockcount;
 };
 
+extern int xfs_refcount_increase_extent(struct xfs_mount *mp,
+		struct xfs_defer_ops *dfops, struct xfs_bmbt_irec *irec);
+extern int xfs_refcount_decrease_extent(struct xfs_mount *mp,
+		struct xfs_defer_ops *dfops, struct xfs_bmbt_irec *irec);
+
+extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
+		struct xfs_btree_cur *rcur, int error);
+extern int xfs_refcount_finish_one(struct xfs_trans *tp,
+		struct xfs_defer_ops *dfops, enum xfs_refcount_intent_type type,
+		xfs_fsblock_t startblock, xfs_extlen_t blockcount,
+		xfs_extlen_t *adjusted, struct xfs_btree_cur **pcur);
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
