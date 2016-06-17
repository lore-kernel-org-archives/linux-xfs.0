Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D185382EC
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:40:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91080304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:40:17 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id TLLwJUmDnk9l35Mh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:40:15 -0700 (PDT)
Subject: [PATCH 089/145] xfs: implement deferred bmbt map/unmap operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:40:11 -0700
Message-ID: <146612761130.16048.14802509002983794111.stgit@birch.djwong.org>
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

Implement deferred versions of the inode block map/unmap functions.
These will be used in subsequent patches to make reflink operations
atomic.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h |    2 +
 libxfs/defer_item.c |  101 ++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.c   |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h   |   11 +++++
 libxfs/xfs_defer.h  |    1 
 5 files changed, 239 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 6277b53..dfc92a6 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -258,6 +258,8 @@
 
 #define trace_xfs_bmap_remap_alloc(...)		((void) 0)
 #define trace_xfs_bmap_remap_alloc_error(...)	((void) 0)
+#define trace_xfs_bmap_deferred(...)		((void) 0)
+#define trace_xfs_bmap_defer(...)		((void) 0)
 
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index a383813..bd41808 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -32,6 +32,8 @@
 #include "xfs_alloc.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount.h"
+#include "xfs_bmap.h"
+#include "xfs_inode.h"
 
 /* Extent Freeing */
 
@@ -364,12 +366,111 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
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
+const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
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
 /* Deferred Item Initialization */
 
 /* Initialize the deferred operation types. */
 void
 xfs_defer_init_types(void)
 {
+	xfs_defer_init_op_type(&xfs_bmap_update_defer_type);
 	xfs_defer_init_op_type(&xfs_refcount_update_defer_type);
 	xfs_defer_init_op_type(&xfs_rmap_update_defer_type);
 	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 58f730e..dff4b7b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6119,3 +6119,127 @@ out:
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index fb2fd4c..394a22c 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
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
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 4081b00..47aa048 100644
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
