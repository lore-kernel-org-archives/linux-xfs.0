Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46163 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932478AbcJYXEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:13 -0400
Subject: [PATCH 05/39] xfs: connect refcount adjust functions to upper layers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:08 -0700
Message-ID: <147743664880.11035.14935300477479467762.stgit@birch.djwong.org>
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

Plumb in the upper level interface to schedule and finish deferred
refcount operations via the deferred ops mechanism.

[Plumb in refcount deferred op log items.]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |    1 
 libxfs/defer_item.c |  130 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/init.c       |    1 
 3 files changed, 132 insertions(+)


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
index f60a11b..1b7d037 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -31,6 +31,7 @@
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -257,3 +258,132 @@ xfs_rmap_update_init_defer_op(void)
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
+	xfs_fsblock_t			new_fsb;
+	xfs_extlen_t			new_aglen;
+	int				error;
+
+	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+	error = xfs_refcount_finish_one(tp, dop,
+			refc->ri_type,
+			refc->ri_startblock,
+			refc->ri_blockcount,
+			&new_fsb, &new_aglen,
+			(struct xfs_btree_cur **)state);
+	/* Did we run out of reservation?  Requeue what we didn't finish. */
+	if (!error && new_aglen > 0) {
+		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
+		       refc->ri_type == XFS_REFCOUNT_DECREASE);
+		refc->ri_startblock = new_fsb;
+		refc->ri_blockcount = new_aglen;
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
index c962d3e..9d9e928 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -268,6 +268,7 @@ libxfs_init(libxfs_init_t *a)
 
 	xfs_extent_free_init_defer_op();
 	xfs_rmap_update_init_defer_op();
+	xfs_refcount_update_init_defer_op();
 
 	radix_tree_init();
 

