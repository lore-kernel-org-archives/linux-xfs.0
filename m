Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F2CC08152
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:35:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C4CEAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ozjmMWjjkAWa4Tir (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:36 -0700 (PDT)
Subject: [PATCH 045/145] xfs: enable the xfs_defer mechanism to process
	rmaps to update
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:35:29 -0700
Message-ID: <146612732898.16048.12128402877492848247.stgit@birch.djwong.org>
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
handle deferred rmap updates.  We'll wire up the existing code to
our new deferred mechanism later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/defer_item.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_defer.h  |    1 +
 2 files changed, 101 insertions(+)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 777875c..cd88cfd 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -30,6 +30,7 @@
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
+#include "xfs_rmap_btree.h"
 
 /* Extent Freeing */
 
@@ -126,11 +127,110 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_bmap_free_cancel_item,
 };
 
+/* Reverse Mapping */
+
+/* Sort rmap intents by AG. */
+static int
+xfs_rmap_update_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_mount		*mp = priv;
+	struct xfs_rmap_intent		*ra;
+	struct xfs_rmap_intent		*rb;
+
+	ra = container_of(a, struct xfs_rmap_intent, ri_list);
+	rb = container_of(b, struct xfs_rmap_intent, ri_list);
+	return  XFS_FSB_TO_AGNO(mp, ra->ri_bmap.br_startblock) -
+		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
+}
+
+/* Get an RUI. */
+STATIC void *
+xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Log rmap updates in the intent item. */
+STATIC void
+xfs_rmap_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+}
+
+/* Get an RUD so we can process all the deferred rmap updates. */
+STATIC void *
+xfs_rmap_update_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Process a deferred rmap update. */
+STATIC int
+xfs_rmap_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dop,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	return -EFSCORRUPTED;
+}
+
+/* Clean up after processing deferred rmaps. */
+STATIC void
+xfs_rmap_update_finish_cleanup(
+	struct xfs_trans	*tp,
+	void			*state,
+	int			error)
+{
+}
+
+/* Abort all pending RUIs. */
+STATIC void
+xfs_rmap_update_abort_intent(
+	void				*intent)
+{
+}
+
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_rmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_rmap_intent		*rmap;
+
+	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
+	kmem_free(rmap);
+}
+
+const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_RMAP,
+	.diff_items	= xfs_rmap_update_diff_items,
+	.create_intent	= xfs_rmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.log_item	= xfs_rmap_update_log_item,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rmap_update_finish_item,
+	.finish_cleanup = xfs_rmap_update_finish_cleanup,
+	.cancel_item	= xfs_rmap_update_cancel_item,
+};
+
 /* Deferred Item Initialization */
 
 /* Initialize the deferred operation types. */
 void
 xfs_defer_init_types(void)
 {
+	xfs_defer_init_op_type(&xfs_rmap_update_defer_type);
 	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
 }
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 743fc32..920642e 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -51,6 +51,7 @@ struct xfs_defer_pending {
  * find all the space it needs.
  */
 enum xfs_defer_ops_type {
+	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_MAX,
 };

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
