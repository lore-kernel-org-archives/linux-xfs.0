Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FD507E2D
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:25:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5DEA38F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 73oxhwZ9zOwxtuqg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:39 -0700 (PDT)
Subject: [PATCH 072/119] xfs: implement deferred bmbt map/unmap operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:25:33 -0700
Message-ID: <146612673365.12839.17819633232208042020.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Implement deferred versions of the inode block map/unmap functions.
These will be used in subsequent patches to make reflink operations
atomic.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |  124 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h  |   11 ++++
 fs/xfs/libxfs/xfs_defer.h |    1 
 fs/xfs/xfs_defer_item.c   |  113 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_error.h        |    4 +
 fs/xfs/xfs_log_recover.c  |   77 +++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h        |    5 ++
 fs/xfs/xfs_trans.h        |    3 -
 fs/xfs/xfs_trans_bmap.c   |    6 +-
 9 files changed, 336 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c29dcdb..63cfb1c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6127,3 +6127,127 @@ out:
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Record a bmap intent. */
+static int
+__xfs_bmap_add(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_bmap_intent	*bi)
+{
+	int			error;
+	struct xfs_bmap_intent	*new;
+
+	ASSERT(bi->bi_whichfork == XFS_DATA_FORK);
+
+	trace_xfs_bmap_defer(mp, XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock),
+			bi->bi_type,
+			XFS_FSB_TO_AGBNO(mp, bi->bi_bmap.br_startblock),
+			bi->bi_owner->i_ino, bi->bi_whichfork,
+			bi->bi_bmap.br_startoff,
+			bi->bi_bmap.br_blockcount,
+			bi->bi_bmap.br_state);
+
+	new = kmem_zalloc(sizeof(struct xfs_bmap_intent), KM_SLEEP | KM_NOFS);
+	*new = *bi;
+
+	error = xfs_defer_join(dfops, bi->bi_owner);
+	if (error)
+		return error;
+
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_BMAP, &new->bi_list);
+	return 0;
+}
+
+/* Map an extent into a file. */
+int
+xfs_bmap_map_extent(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV)
+{
+	struct xfs_bmap_intent	bi;
+
+	bi.bi_type = XFS_BMAP_MAP;
+	bi.bi_owner = ip;
+	bi.bi_whichfork = whichfork;
+	bi.bi_bmap = *PREV;
+
+	return __xfs_bmap_add(mp, dfops, &bi);
+}
+
+/* Unmap an extent out of a file. */
+int
+xfs_bmap_unmap_extent(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV)
+{
+	struct xfs_bmap_intent	bi;
+
+	bi.bi_type = XFS_BMAP_UNMAP;
+	bi.bi_owner = ip;
+	bi.bi_whichfork = whichfork;
+	bi.bi_bmap = *PREV;
+
+	return __xfs_bmap_add(mp, dfops, &bi);
+}
+
+/*
+ * Process one of the deferred bmap operations.  We pass back the
+ * btree cursor to maintain our lock on the bmapbt between calls.
+ */
+int
+xfs_bmap_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dfops,
+	struct xfs_inode		*ip,
+	enum xfs_bmap_intent_type	type,
+	int				whichfork,
+	xfs_fileoff_t			startoff,
+	xfs_fsblock_t			startblock,
+	xfs_filblks_t			blockcount,
+	xfs_exntst_t			state)
+{
+	struct xfs_bmbt_irec		bmap;
+	int				nimaps = 1;
+	xfs_fsblock_t			firstfsb;
+	int				error = 0;
+
+	bmap.br_startblock = startblock;
+	bmap.br_startoff = startoff;
+	bmap.br_blockcount = blockcount;
+	bmap.br_state = state;
+
+	trace_xfs_bmap_deferred(tp->t_mountp,
+			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
+			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
+			ip->i_ino, whichfork, startoff, blockcount, state);
+
+	if (XFS_TEST_ERROR(false, tp->t_mountp,
+			XFS_ERRTAG_BMAP_FINISH_ONE,
+			XFS_RANDOM_BMAP_FINISH_ONE))
+		return -EIO;
+
+	switch (type) {
+	case XFS_BMAP_MAP:
+		firstfsb = bmap.br_startblock;
+		error = xfs_bmapi_write(tp, ip, bmap.br_startoff,
+					bmap.br_blockcount,
+					XFS_BMAPI_REMAP, &firstfsb,
+					bmap.br_blockcount, &bmap, &nimaps,
+					dfops);
+		break;
+	case XFS_BMAP_UNMAP:
+		/* not implemented for now */
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+	}
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index fb2fd4c..394a22c 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -230,4 +230,15 @@ struct xfs_bmap_intent {
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
+int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_defer_ops *dfops,
+		struct xfs_inode *ip, enum xfs_bmap_intent_type type,
+		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount, xfs_exntst_t state);
+int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
+		struct xfs_inode *ip, int whichfork,
+		struct xfs_bmbt_irec *imap);
+int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
+		struct xfs_inode *ip, int whichfork,
+		struct xfs_bmbt_irec *imap);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 4081b00..47aa048 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -51,6 +51,7 @@ struct xfs_defer_pending {
  * find all the space it needs.
  */
 enum xfs_defer_ops_type {
+	XFS_DEFER_OPS_TYPE_BMAP,
 	XFS_DEFER_OPS_TYPE_REFCOUNT,
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
diff --git a/fs/xfs/xfs_defer_item.c b/fs/xfs/xfs_defer_item.c
index 2cac94f..c9ebddc 100644
--- a/fs/xfs/xfs_defer_item.c
+++ b/fs/xfs/xfs_defer_item.c
@@ -35,6 +35,9 @@
 #include "xfs_rmap_item.h"
 #include "xfs_refcount.h"
 #include "xfs_refcount_item.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_item.h"
+#include "xfs_inode.h"
 
 /* Extent Freeing */
 
@@ -394,12 +397,122 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
+/* Inode Block Mapping */
+
+/* Sort bmap intents by inode. */
+static int
+xfs_bmap_update_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_bmap_intent		*ba;
+	struct xfs_bmap_intent		*bb;
+
+	ba = container_of(a, struct xfs_bmap_intent, bi_list);
+	bb = container_of(b, struct xfs_bmap_intent, bi_list);
+	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+}
+
+/* Get an BUI. */
+STATIC void *
+xfs_bmap_update_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	return xfs_trans_get_bui(tp, count);
+}
+
+/* Log bmap updates in the intent item. */
+STATIC void
+xfs_bmap_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bmap;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	xfs_trans_log_start_bmap_update(tp, intent, bmap->bi_type,
+			bmap->bi_owner->i_ino, bmap->bi_whichfork,
+			bmap->bi_bmap.br_startoff,
+			bmap->bi_bmap.br_startblock,
+			bmap->bi_bmap.br_blockcount,
+			bmap->bi_bmap.br_state);
+}
+
+/* Get an BUD so we can process all the deferred rmap updates. */
+STATIC void *
+xfs_bmap_update_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return xfs_trans_get_bud(tp, intent, count);
+}
+
+/* Process a deferred rmap update. */
+STATIC int
+xfs_bmap_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dop,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_bmap_intent		*bmap;
+	int				error;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	error = xfs_trans_log_finish_bmap_update(tp, done_item, dop,
+			bmap->bi_type,
+			bmap->bi_owner, bmap->bi_whichfork,
+			bmap->bi_bmap.br_startoff,
+			bmap->bi_bmap.br_startblock,
+			bmap->bi_bmap.br_blockcount,
+			bmap->bi_bmap.br_state);
+	kmem_free(bmap);
+	return error;
+}
+
+/* Abort all pending BUIs. */
+STATIC void
+xfs_bmap_update_abort_intent(
+	void				*intent)
+{
+	xfs_bui_release(intent);
+}
+
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_bmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bmap;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	kmem_free(bmap);
+}
+
+const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_BMAP,
+	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
+	.diff_items	= xfs_bmap_update_diff_items,
+	.create_intent	= xfs_bmap_update_create_intent,
+	.abort_intent	= xfs_bmap_update_abort_intent,
+	.log_item	= xfs_bmap_update_log_item,
+	.create_done	= xfs_bmap_update_create_done,
+	.finish_item	= xfs_bmap_update_finish_item,
+	.cancel_item	= xfs_bmap_update_cancel_item,
+};
+
 /* Deferred Item Initialization */
 
 /* Initialize the deferred operation types. */
 void
 xfs_defer_init_types(void)
 {
+	xfs_defer_init_op_type(&xfs_bmap_update_defer_type);
 	xfs_defer_init_op_type(&xfs_refcount_update_defer_type);
 	xfs_defer_init_op_type(&xfs_rmap_update_defer_type);
 	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 83d7b62..16a60de 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -94,7 +94,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_RMAP_FINISH_ONE			23
 #define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
-#define XFS_ERRTAG_MAX					26
+#define XFS_ERRTAG_BMAP_FINISH_ONE			26
+#define XFS_ERRTAG_MAX					27
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -125,6 +126,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_RMAP_FINISH_ONE			1
 #define XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE		1
 #define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
+#define XFS_RANDOM_BMAP_FINISH_ONE			1
 
 #ifdef DEBUG
 extern int xfs_error_test_active;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 42000f4..3faaf10 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5201,6 +5201,14 @@ xlog_recover_process_bui(
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			inode_fsb;
 	bool				op_ok;
+	struct xfs_bud_log_item		*budp;
+	enum xfs_bmap_intent_type	type;
+	int				whichfork;
+	xfs_exntst_t			state;
+	struct xfs_trans		*tp;
+	struct xfs_inode		**ips;
+	struct xfs_defer_ops		dfops;
+	xfs_fsblock_t			firstfsb;
 
 	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
 
@@ -5241,9 +5249,74 @@ xlog_recover_process_bui(
 		}
 	}
 
-	/* XXX: do nothing for now */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error)
+		return error;
+	budp = xfs_trans_get_bud(tp, buip, buip->bui_format.bui_nextents);
+
+	xfs_defer_init(&dfops, &firstfsb);
+
+	/* Grab all the inodes we'll need. */
+	ips = kmem_zalloc(sizeof(struct xfs_inode *) *
+				buip->bui_format.bui_nextents, KM_SLEEP);
+	for (i = 0; i < buip->bui_format.bui_nextents; i++) {
+		bmap = &(buip->bui_format.bui_extents[i]);
+		error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL,
+				&ips[i]);
+		if (error)
+			goto err_inodes;
+	}
+
+	/* Process deferred bmap items. */
+	for (i = 0; i < buip->bui_format.bui_nextents; i++) {
+		bmap = &(buip->bui_format.bui_extents[i]);
+		state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+		whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+				XFS_ATTR_FORK : XFS_DATA_FORK;
+		switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+		case XFS_BMAP_EXTENT_MAP:
+			type = XFS_BMAP_MAP;
+			break;
+		case XFS_BMAP_EXTENT_UNMAP:
+			type = XFS_BMAP_UNMAP;
+			break;
+		default:
+			error = -EFSCORRUPTED;
+			goto err_dfops;
+		}
+		xfs_trans_ijoin(tp, ips[i], 0);
+
+		error = xfs_trans_log_finish_bmap_update(tp, budp, &dfops, type,
+				ips[i], whichfork, bmap->me_startoff,
+				bmap->me_startblock, bmap->me_len,
+				state);
+		if (error)
+			goto err_dfops;
+
+	}
+
+	/* Finish transaction, free inodes. */
+	error = xfs_defer_finish(&tp, &dfops, NULL);
+	if (error)
+		goto err_dfops;
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	xfs_bui_release(buip);
+	error = xfs_trans_commit(tp);
+	for (i = 0; i < buip->bui_format.bui_nextents; i++) {
+		xfs_iunlock(ips[i], XFS_ILOCK_EXCL);
+		IRELE(ips[i]);
+	}
+
+	return error;
+
+err_dfops:
+	xfs_defer_cancel(&dfops);
+err_inodes:
+	for (i = 0; i < buip->bui_format.bui_nextents; i++) {
+		xfs_iunlock(ips[i], XFS_ILOCK_EXCL);
+		IRELE(ips[i]);
+	}
+	xfs_trans_cancel(tp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8844c9f..a18e321 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2560,6 +2560,11 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_map_gtrec);
 DEFINE_RMAPBT_EVENT(xfs_rmap_convert_gtrec);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
+/* deferred bmbt updates */
+#define DEFINE_BMAP_DEFERRED_EVENT	DEFINE_RMAP_DEFERRED_EVENT
+DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_defer);
+DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_deferred);
+
 /* per-AG reservation */
 DECLARE_EVENT_CLASS(xfs_ag_resv_class,
 	TP_PROTO(struct xfs_perag *pag, enum xfs_ag_resv_type resv,
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index cda7d92..6e890bc 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -285,7 +285,6 @@ int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
 		struct xfs_bud_log_item *rudp, struct xfs_defer_ops *dfops,
 		enum xfs_bmap_intent_type type, struct xfs_inode *ip,
 		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
-		xfs_filblks_t blockcount, xfs_exntst_t state,
-		struct xfs_btree_cur **pcur);
+		xfs_filblks_t blockcount, xfs_exntst_t state);
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index 1517c83..97f395a 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -154,14 +154,14 @@ xfs_trans_log_finish_bmap_update(
 	xfs_fileoff_t			startoff,
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
-	xfs_exntst_t			state,
-	struct xfs_btree_cur		**pcur)
+	xfs_exntst_t			state)
 {
 	uint				next_extent;
 	struct xfs_map_extent		*bmap;
 	int				error;
 
-	error = -EFSCORRUPTED;
+	error = xfs_bmap_finish_one(tp, dop, ip, type, whichfork, startoff,
+			startblock, blockcount, state);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
