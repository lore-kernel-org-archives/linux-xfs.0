Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 377378051
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:33:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD18A30404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4va3BwPr73bCOH3R (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:07 -0700 (PDT)
Subject: [PATCH 022/145] xfs: enable the xfs_defer mechanism to process
	extents to free
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:02 -0700
Message-ID: <146612718210.16048.5959888533223391397.stgit@birch.djwong.org>
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

Connect the xfs_defer mechanism with the pieces that we'll need to
handle deferred extent freeing.  We'll wire up the existing code to
our new deferred mechanism later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/defer_item.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_defer.h  |    1 +
 2 files changed, 101 insertions(+)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 06d294f..72c28f8 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -28,9 +28,109 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
+#include "xfs_bmap.h"
+#include "xfs_alloc.h"
+
+/* Extent Freeing */
+
+/* Sort bmap items by AG. */
+static int
+xfs_bmap_free_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_mount		*mp = priv;
+	struct xfs_bmap_free_item	*ra;
+	struct xfs_bmap_free_item	*rb;
+
+	ra = container_of(a, struct xfs_bmap_free_item, xbfi_list);
+	rb = container_of(b, struct xfs_bmap_free_item, xbfi_list);
+	return  XFS_FSB_TO_AGNO(mp, ra->xbfi_startblock) -
+		XFS_FSB_TO_AGNO(mp, rb->xbfi_startblock);
+}
+
+/* Get an EFI. */
+STATIC void *
+xfs_bmap_free_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Log a free extent to the intent item. */
+STATIC void
+xfs_bmap_free_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+}
+
+/* Get an EFD so we can process all the free extents. */
+STATIC void *
+xfs_bmap_free_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Process a free extent. */
+STATIC int
+xfs_bmap_free_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dop,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_bmap_free_item	*free;
+	int				error;
+
+	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
+	error = xfs_free_extent(tp, free->xbfi_startblock,
+			free->xbfi_blockcount);
+	kmem_free(free);
+	return error;
+}
+
+/* Abort all pending EFIs. */
+STATIC void
+xfs_bmap_free_abort_intent(
+	void				*intent)
+{
+}
+
+/* Cancel a free extent. */
+STATIC void
+xfs_bmap_free_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_bmap_free_item	*free;
+
+	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
+	kmem_free(free);
+}
+
+const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_FREE,
+	.diff_items	= xfs_bmap_free_diff_items,
+	.create_intent	= xfs_bmap_free_create_intent,
+	.abort_intent	= xfs_bmap_free_abort_intent,
+	.log_item	= xfs_bmap_free_log_item,
+	.create_done	= xfs_bmap_free_create_done,
+	.finish_item	= xfs_bmap_free_finish_item,
+	.cancel_item	= xfs_bmap_free_cancel_item,
+};
+
+/* Deferred Item Initialization */
 
 /* Initialize the deferred operation types. */
 void
 xfs_defer_init_types(void)
 {
+	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
 }
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 85c7a3a..743fc32 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -51,6 +51,7 @@ struct xfs_defer_pending {
  * find all the space it needs.
  */
 enum xfs_defer_ops_type {
+	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
