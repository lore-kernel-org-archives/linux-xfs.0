Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55D9C7D94
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:35:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1A76AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AScoaIRT7Z8MROES (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:34:59 -0700 (PDT)
Subject: [PATCH 27/71] xfs: implement deferred bmbt map/unmap operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:34:55 -0700
Message-ID: <147216809522.867.17109256595026376153.stgit@birch.djwong.org>
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

Implement deferred versions of the inode block map/unmap functions.
These will be used in subsequent patches to make reflink operations
atomic.

v2: Only allow one item per BUI, and implement unmap too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |  141 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h  |   11 +++
 fs/xfs/libxfs/xfs_defer.h |    1 
 fs/xfs/xfs_bmap_item.c    |   71 ++++++++++++++++++++++
 fs/xfs/xfs_error.h        |    4 +
 fs/xfs/xfs_super.c        |    1 
 fs/xfs/xfs_trace.h        |    5 ++
 fs/xfs/xfs_trans.h        |    1 
 fs/xfs/xfs_trans_bmap.c   |  144 +++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 375 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2aa7eb6..6272cf6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6131,3 +6131,144 @@ out:
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Deferred mapping is only for real extents in the data fork. */
+static bool
+xfs_bmap_is_update_needed(
+	int			whichfork,
+	struct xfs_bmbt_irec	*bmap)
+{
+	ASSERT(whichfork == XFS_DATA_FORK);
+
+	return  bmap->br_startblock != HOLESTARTBLOCK &&
+		bmap->br_startblock != DELAYSTARTBLOCK;
+}
+
+/* Record a bmap intent. */
+static int
+__xfs_bmap_add(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	enum xfs_bmap_intent_type	type,
+	struct xfs_inode		*ip,
+	int				whichfork,
+	struct xfs_bmbt_irec		*bmap)
+{
+	int				error;
+	struct xfs_bmap_intent		*bi;
+
+	trace_xfs_bmap_defer(mp,
+			XFS_FSB_TO_AGNO(mp, bmap->br_startblock),
+			type,
+			XFS_FSB_TO_AGBNO(mp, bmap->br_startblock),
+			ip->i_ino, whichfork,
+			bmap->br_startoff,
+			bmap->br_blockcount,
+			bmap->br_state);
+
+	bi = kmem_alloc(sizeof(struct xfs_bmap_intent), KM_SLEEP | KM_NOFS);
+	INIT_LIST_HEAD(&bi->bi_list);
+	bi->bi_type = type;
+	bi->bi_owner = ip;
+	bi->bi_whichfork = whichfork;
+	bi->bi_bmap = *bmap;
+
+	error = xfs_defer_join(dfops, bi->bi_owner);
+	if (error) {
+		kmem_free(bi);
+		return error;
+	}
+
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
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
+	if (!xfs_bmap_is_update_needed(whichfork, PREV))
+		return 0;
+
+	return __xfs_bmap_add(mp, dfops, XFS_BMAP_MAP, ip, whichfork, PREV);
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
+	if (!xfs_bmap_is_update_needed(whichfork, PREV))
+		return 0;
+
+	return __xfs_bmap_add(mp, dfops, XFS_BMAP_UNMAP, ip, whichfork, PREV);
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
+	int				done;
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
+		error = xfs_bunmapi(tp, ip, bmap.br_startoff,
+				bmap.br_blockcount, XFS_BMAPI_REMAP, 1, &firstfsb,
+				dfops, &done);
+		ASSERT(done);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+	}
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 1a5d5f4..30f2294 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -227,4 +227,15 @@ struct xfs_bmap_intent {
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
index d47a482..aa57eaa 100644
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
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d192b57..9b1720c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -24,11 +24,16 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_log.h"
+#include "xfs_bmap.h"
+#include "xfs_icache.h"
+#include "xfs_trace.h"
 
 
 kmem_zone_t	*xfs_bui_zone;
@@ -425,6 +430,14 @@ xfs_bui_recover(
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			inode_fsb;
 	bool				op_ok;
+	struct xfs_bud_log_item		*budp;
+	enum xfs_bmap_intent_type	type;
+	int				whichfork;
+	xfs_exntst_t			state;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_defer_ops		dfops;
+	xfs_fsblock_t			firstfsb;
 
 	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
 
@@ -469,8 +482,62 @@ xfs_bui_recover(
 		return -EIO;
 	}
 
-	/* XXX: do nothing for now */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error)
+		return error;
+	budp = xfs_trans_get_bud(tp, buip);
+
+	/* Grab the inode. */
+	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
+	if (error)
+		goto err_inode;
+
+	xfs_defer_init(&dfops, &firstfsb);
+
+	/* Process deferred bmap item. */
+	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+			XFS_ATTR_FORK : XFS_DATA_FORK;
+	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	case XFS_BMAP_EXTENT_MAP:
+		type = XFS_BMAP_MAP;
+		break;
+	case XFS_BMAP_EXTENT_UNMAP:
+		type = XFS_BMAP_UNMAP;
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		goto err_dfops;
+	}
+	xfs_trans_ijoin(tp, ip, 0);
+
+	error = xfs_trans_log_finish_bmap_update(tp, budp, &dfops, type,
+			ip, whichfork, bmap->me_startoff,
+			bmap->me_startblock, bmap->me_len,
+			state);
+	if (error)
+		goto err_dfops;
+
+	/* Finish transaction, free inodes. */
+	error = xfs_defer_finish(&tp, &dfops, NULL);
+	if (error)
+		goto err_dfops;
+
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	xfs_bui_release(buip);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	IRELE(ip);
+
+	return error;
+
+err_dfops:
+	xfs_defer_cancel(&dfops);
+err_inode:
+	xfs_trans_cancel(tp);
+	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		IRELE(ip);
+	}
 	return error;
 }
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 641e090..8d8e1b07 100644
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
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ba73c562..f62d50c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1925,6 +1925,7 @@ init_xfs_fs(void)
 	xfs_extent_free_init_defer_op();
 	xfs_rmap_update_init_defer_op();
 	xfs_refcount_update_init_defer_op();
+	xfs_bmap_update_init_defer_op();
 
 	xfs_dir_startup();
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4324ada..d78b369d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2560,6 +2560,11 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
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
index 7cf02d3..7a4ea0c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -40,6 +40,7 @@ struct xfs_cui_log_item;
 struct xfs_cud_log_item;
 struct xfs_defer_ops;
 struct xfs_bui_log_item;
+struct xfs_bud_log_item;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index 3f21c57..3fce3c8 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -93,7 +93,8 @@ xfs_trans_log_finish_bmap_update(
 {
 	int				error;
 
-	error = -EFSCORRUPTED;
+	error = xfs_bmap_finish_one(tp, dop, ip, type, whichfork, startoff,
+			startblock, blockcount, state);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -107,3 +108,144 @@ xfs_trans_log_finish_bmap_update(
 
 	return error;
 }
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
+	struct xfs_bui_log_item		*buip;
+
+	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
+	ASSERT(tp != NULL);
+
+	buip = xfs_bui_init(tp->t_mountp);
+	ASSERT(buip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &buip->bui_item);
+	return buip;
+}
+
+/* Log bmap updates in the intent item. */
+STATIC void
+xfs_bmap_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_bui_log_item		*buip = intent;
+	struct xfs_bmap_intent		*bmap;
+	uint				next_extent;
+	struct xfs_map_extent		*map;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	buip->bui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&buip->bui_next_extent) - 1;
+	ASSERT(next_extent < buip->bui_format.bui_nextents);
+	map = &buip->bui_format.bui_extents[next_extent];
+	map->me_owner = bmap->bi_owner->i_ino;
+	map->me_startblock = bmap->bi_bmap.br_startblock;
+	map->me_startoff = bmap->bi_bmap.br_startoff;
+	map->me_len = bmap->bi_bmap.br_blockcount;
+	xfs_trans_set_bmap_flags(map, bmap->bi_type, bmap->bi_whichfork,
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
+	return xfs_trans_get_bud(tp, intent);
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
+static const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
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
+/* Register the deferred op type. */
+void
+xfs_bmap_update_init_defer_op(void)
+{
+	xfs_defer_init_op_type(&xfs_bmap_update_defer_type);
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
