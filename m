Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 523037D5C
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:34:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24688304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:34:01 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ezwY8eoMA5vo09oO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:33:58 -0700 (PDT)
Subject: [PATCH 18/71] xfs: connect refcount adjust functions to upper layers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:33:53 -0700
Message-ID: <147216803348.867.13758665374298091849.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
 fs/xfs/libxfs/xfs_defer.h    |    1 
 fs/xfs/libxfs/xfs_refcount.c |  170 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |   12 +++
 fs/xfs/xfs_error.h           |    4 +
 fs/xfs/xfs_refcount_item.c   |   80 +++++++++++++++++++-
 fs/xfs/xfs_super.c           |    1 
 fs/xfs/xfs_trace.h           |    3 +
 fs/xfs/xfs_trans.h           |    8 +-
 fs/xfs/xfs_trans_refcount.c  |  167 +++++++++++++++++++++++++++++++++++++++++
 9 files changed, 439 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index cc3981c..d47a482 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -51,6 +51,7 @@ struct xfs_defer_pending {
  * find all the space it needs.
  */
 enum xfs_defer_ops_type {
+	XFS_DEFER_OPS_TYPE_REFCOUNT,
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_MAX,
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 4f82651..b52ecfe 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -958,3 +958,173 @@ out_error:
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
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 2ef2b28..605d7d7 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
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
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index d9675c64..641e090 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -93,7 +93,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_FREE_EXTENT				22
 #define XFS_ERRTAG_RMAP_FINISH_ONE			23
 #define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
-#define XFS_ERRTAG_MAX					25
+#define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
+#define XFS_ERRTAG_MAX					26
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -123,6 +124,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_FREE_EXTENT				1
 #define XFS_RANDOM_RMAP_FINISH_ONE			1
 #define XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE		1
+#define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
 
 #ifdef DEBUG
 extern int xfs_error_test_active;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a4a6c21..7be6029 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -24,11 +24,13 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_refcount_item.h"
 #include "xfs_log.h"
+#include "xfs_refcount.h"
 
 
 kmem_zone_t	*xfs_cui_zone;
@@ -437,6 +439,15 @@ xfs_cui_recover(
 	struct xfs_phys_extent		*refc;
 	xfs_fsblock_t			startblock_fsb;
 	bool				op_ok;
+	struct xfs_cud_log_item		*cudp;
+	struct xfs_trans		*tp;
+	struct xfs_btree_cur		*rcur = NULL;
+	enum xfs_refcount_intent_type	type;
+	xfs_fsblock_t			firstfsb;
+	xfs_extlen_t			adjusted;
+	struct xfs_bmbt_irec		irec;
+	struct xfs_defer_ops		dfops;
+	bool				requeue_only = false;
 
 	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
 
@@ -475,8 +486,73 @@ xfs_cui_recover(
 		}
 	}
 
-	/* XXX: do nothing for now */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error)
+		return error;
+	cudp = xfs_trans_get_cud(tp, cuip);
+
+	xfs_defer_init(&dfops, &firstfsb);
+	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
+		refc = &cuip->cui_format.cui_extents[i];
+		switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
+		case XFS_REFCOUNT_EXTENT_INCREASE:
+			type = XFS_REFCOUNT_INCREASE;
+			break;
+		case XFS_REFCOUNT_EXTENT_DECREASE:
+			type = XFS_REFCOUNT_DECREASE;
+			break;
+		case XFS_REFCOUNT_EXTENT_ALLOC_COW:
+			type = XFS_REFCOUNT_ALLOC_COW;
+			break;
+		case XFS_REFCOUNT_EXTENT_FREE_COW:
+			type = XFS_REFCOUNT_FREE_COW;
+			break;
+		default:
+			error = -EFSCORRUPTED;
+			goto abort_error;
+		}
+		if (requeue_only)
+			adjusted = 0;
+		else
+			error = xfs_trans_log_finish_refcount_update(tp, cudp,
+				&dfops, type, refc->pe_startblock, refc->pe_len,
+				&adjusted, &rcur);
+		if (error)
+			goto abort_error;
+
+		/* Requeue what we didn't finish. */
+		if (adjusted < refc->pe_len) {
+			irec.br_startblock = refc->pe_startblock + adjusted;
+			irec.br_blockcount = refc->pe_len - adjusted;
+			switch (type) {
+			case XFS_REFCOUNT_INCREASE:
+				error = xfs_refcount_increase_extent(
+						tp->t_mountp, &dfops, &irec);
+				break;
+			case XFS_REFCOUNT_DECREASE:
+				error = xfs_refcount_decrease_extent(
+						tp->t_mountp, &dfops, &irec);
+				break;
+			default:
+				ASSERT(0);
+			}
+			if (error)
+				goto abort_error;
+			requeue_only = true;
+		}
+	}
+
+	xfs_refcount_finish_one_cleanup(tp, rcur, error);
+	error = xfs_defer_finish(&tp, &dfops, NULL);
+	if (error)
+		goto abort_error;
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	xfs_cui_release(cuip);
+	error = xfs_trans_commit(tp);
+	return error;
+
+abort_error:
+	xfs_refcount_finish_one_cleanup(tp, rcur, error);
+	xfs_defer_cancel(&dfops);
+	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index be9a98b..a027e27 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1905,6 +1905,7 @@ init_xfs_fs(void)
 
 	xfs_extent_free_init_defer_op();
 	xfs_rmap_update_init_defer_op();
+	xfs_refcount_update_init_defer_op();
 
 	xfs_dir_startup();
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a195fc5..6175003 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2905,6 +2905,9 @@ DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_rec_order_error);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
 DEFINE_AG_ERROR_EVENT(xfs_refcount_find_shared_error);
+#define DEFINE_REFCOUNT_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
+DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_defer);
+DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_deferred);
 
 TRACE_EVENT(xfs_refcount_finish_one_leftover,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index fe69e20..a7a87d2 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -37,6 +37,8 @@ struct xfs_rud_log_item;
 struct xfs_rui_log_item;
 struct xfs_btree_cur;
 struct xfs_cui_log_item;
+struct xfs_cud_log_item;
+struct xfs_defer_ops;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -252,11 +254,13 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 /* refcount updates */
 enum xfs_refcount_intent_type;
 
+void xfs_refcount_update_init_defer_op(void);
 struct xfs_cud_log_item *xfs_trans_get_cud(struct xfs_trans *tp,
 		struct xfs_cui_log_item *cuip);
 int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
-		struct xfs_cud_log_item *cudp,
+		struct xfs_cud_log_item *cudp, struct xfs_defer_ops *dfops,
 		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
-		xfs_extlen_t blockcount, struct xfs_btree_cur **pcur);
+		xfs_extlen_t blockcount, xfs_extlen_t *adjusted,
+		struct xfs_btree_cur **pcur);
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
index 6398ff9..3358a13 100644
--- a/fs/xfs/xfs_trans_refcount.c
+++ b/fs/xfs/xfs_trans_refcount.c
@@ -81,15 +81,17 @@ int
 xfs_trans_log_finish_refcount_update(
 	struct xfs_trans		*tp,
 	struct xfs_cud_log_item		*cudp,
+	struct xfs_defer_ops		*dop,
 	enum xfs_refcount_intent_type	type,
 	xfs_fsblock_t			startblock,
 	xfs_extlen_t			blockcount,
+	xfs_extlen_t			*adjusted,
 	struct xfs_btree_cur		**pcur)
 {
 	int				error;
 
-	/* XXX: leave this empty for now */
-	error = -EFSCORRUPTED;
+	error = xfs_refcount_finish_one(tp, dop, type, startblock,
+			blockcount, adjusted, pcur);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -103,3 +105,164 @@ xfs_trans_log_finish_refcount_update(
 
 	return error;
 }
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
+	struct xfs_cui_log_item		*cuip;
+
+	ASSERT(tp != NULL);
+	ASSERT(count > 0);
+
+	cuip = xfs_cui_init(tp->t_mountp, count);
+	ASSERT(cuip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	return cuip;
+}
+
+/* Log refcount updates in the intent item. */
+STATIC void
+xfs_refcount_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_cui_log_item		*cuip = intent;
+	struct xfs_refcount_intent	*refc;
+	uint				next_extent;
+	struct xfs_phys_extent		*ext;
+
+	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	cuip->cui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
+	ASSERT(next_extent < cuip->cui_format.cui_nextents);
+	ext = &cuip->cui_format.cui_extents[next_extent];
+	ext->pe_startblock = refc->ri_startblock;
+	ext->pe_len = refc->ri_blockcount;
+	xfs_trans_set_refcount_flags(ext, refc->ri_type);
+}
+
+/* Get an CUD so we can process all the deferred refcount updates. */
+STATIC void *
+xfs_refcount_update_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return xfs_trans_get_cud(tp, intent);
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
+	error = xfs_trans_log_finish_refcount_update(tp, done_item, dop,
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
+	xfs_cui_release(intent);
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
+	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
