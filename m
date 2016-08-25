Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 595967FBC
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:49:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F30CB8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:04 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id GgQUeyaOuN2whsnH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:02 -0700 (PDT)
Subject: [PATCH 23/71] xfs: implement deferred bmbt map/unmap operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:48:57 -0700
Message-ID: <147216893766.4420.12921405283472420891.stgit@birch.djwong.org>
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

Implement deferred versions of the inode block map/unmap functions.
These will be used in subsequent patches to make reflink operations
atomic.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h |    2 +
 include/xfs_trans.h |    1 
 libxfs/defer_item.c |  107 +++++++++++++++++++++++++++++++++++++++
 libxfs/init.c       |    1 
 libxfs/xfs_bmap.c   |  141 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h   |   11 ++++
 libxfs/xfs_defer.h  |    1 
 7 files changed, 264 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index cc0e960..506f23b 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -261,6 +261,8 @@
 
 #define trace_xfs_bmap_remap_alloc(...)		((void) 0)
 #define trace_xfs_bmap_remap_alloc_error(...)	((void) 0)
+#define trace_xfs_bmap_deferred(...)		((void) 0)
+#define trace_xfs_bmap_defer(...)		((void) 0)
 
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 739a792..44deebb 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -148,5 +148,6 @@ libxfs_trans_read_buf(
 void xfs_extent_free_init_defer_op(void);
 void xfs_rmap_update_init_defer_op(void);
 void xfs_refcount_update_init_defer_op(void);
+void xfs_bmap_update_init_defer_op(void);
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 133e6e1..d4cd876 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -32,6 +32,8 @@
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
+#include "xfs_bmap.h"
+#include "xfs_inode.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -386,3 +388,108 @@ xfs_refcount_update_init_defer_op(void)
 {
 	xfs_defer_init_op_type(&xfs_refcount_update_defer_type);
 }
+
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
+	return NULL;
+}
+
+/* Log bmap updates in the intent item. */
+STATIC void
+xfs_bmap_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+}
+
+/* Get an BUD so we can process all the deferred rmap updates. */
+STATIC void *
+xfs_bmap_update_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return NULL;
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
+	error = xfs_bmap_finish_one(tp, dop,
+			bmap->bi_owner,
+			bmap->bi_type, bmap->bi_whichfork,
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
diff --git a/libxfs/init.c b/libxfs/init.c
index 2d1bb58..9134879 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -267,6 +267,7 @@ libxfs_init(libxfs_init_t *a)
 	xfs_extent_free_init_defer_op();
 	xfs_rmap_update_init_defer_op();
 	xfs_refcount_update_init_defer_op();
+	xfs_bmap_update_init_defer_op();
 
 	radix_tree_init();
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ff99768..a919371 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6123,3 +6123,144 @@ out:
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 4d9b666..858788b 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -233,4 +233,15 @@ struct xfs_bmap_intent {
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
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index d47a482..aa57eaa 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -51,6 +51,7 @@ struct xfs_defer_pending {
  * find all the space it needs.
  */
 enum xfs_defer_ops_type {
+	XFS_DEFER_OPS_TYPE_BMAP,
 	XFS_DEFER_OPS_TYPE_REFCOUNT,
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
