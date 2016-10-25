Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45893 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932478AbcJYXET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:19 -0400
Subject: [PATCH 06/39] xfs: implement deferred bmbt map/unmap operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:14 -0700
Message-ID: <147743665492.11035.7727340576342066591.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Implement deferred versions of the inode block map/unmap functions.
These will be used in subsequent patches to make reflink operations
atomic.

[Plumb in bmap deferred op log items.]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |    1 
 libxfs/defer_item.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/init.c       |    1 
 3 files changed, 109 insertions(+)


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
index 1b7d037..49bf7f8 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -32,6 +32,8 @@
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
+#include "xfs_bmap.h"
+#include "xfs_inode.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -387,3 +389,108 @@ xfs_refcount_update_init_defer_op(void)
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
index 9d9e928..3721589 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -269,6 +269,7 @@ libxfs_init(libxfs_init_t *a)
 	xfs_extent_free_init_defer_op();
 	xfs_rmap_update_init_defer_op();
 	xfs_refcount_update_init_defer_op();
+	xfs_bmap_update_init_defer_op();
 
 	radix_tree_init();
 

