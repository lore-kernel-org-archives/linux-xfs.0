Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55146 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbeJ3DQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 23:16:21 -0400
Subject: [PATCH 1/2] libxfs: idiotproof defer op type configuration
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Oct 2018 11:26:27 -0700
Message-ID: <154083758751.17015.518339201082241614.stgit@magnolia>
In-Reply-To: <154083758133.17015.16047588822481256587.stgit@magnolia>
References: <154083758133.17015.16047588822481256587.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Recently, we forgot to port a new defer op type to xfsprogs, which
caused us some userspace pain.  Reorganize the way we make libxfs
clients supply defer op type information so that all type information
has to be provided at build time instead of risky runtime dynamic
configuration.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |    5 -----
 libxfs/defer_item.c |   39 +++++----------------------------------
 libxfs/init.c       |    5 -----
 libxfs/xfs_defer.c  |   17 ++++++++---------
 libxfs/xfs_defer.h  |    6 +++++-
 5 files changed, 18 insertions(+), 54 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 31df1172..9e44d18e 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -152,9 +152,4 @@ libxfs_trans_read_buf(
 	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
 }
 
-void xfs_extent_free_init_defer_op(void);
-void xfs_rmap_update_init_defer_op(void);
-void xfs_refcount_update_init_defer_op(void);
-void xfs_bmap_update_init_defer_op(void);
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 4f7d5499..d36f9d9e 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -107,7 +107,7 @@ xfs_extent_free_cancel_item(
 	kmem_free(free);
 }
 
-static const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_FREE,
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
@@ -150,7 +150,7 @@ xfs_agfl_free_finish_item(
 }
 
 /* sub-type with special handling for AGFL deferred frees */
-static const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
@@ -161,14 +161,6 @@ static const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
-/* Register the deferred op type. */
-void
-xfs_extent_free_init_defer_op(void)
-{
-	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
-	xfs_defer_init_op_type(&xfs_agfl_free_defer_type);
-}
-
 /* Reverse Mapping */
 
 /* Sort rmap intents by AG. */
@@ -270,7 +262,7 @@ xfs_rmap_update_cancel_item(
 	kmem_free(rmap);
 }
 
-static const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_RMAP,
 	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
@@ -282,13 +274,6 @@ static const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
 
-/* Register the deferred op type. */
-void
-xfs_rmap_update_init_defer_op(void)
-{
-	xfs_defer_init_op_type(&xfs_rmap_update_defer_type);
-}
-
 /* Reference Counting */
 
 /* Sort refcount intents by AG. */
@@ -398,7 +383,7 @@ xfs_refcount_update_cancel_item(
 	kmem_free(refc);
 }
 
-static const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_REFCOUNT,
 	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
@@ -410,13 +395,6 @@ static const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
-/* Register the deferred op type. */
-void
-xfs_refcount_update_init_defer_op(void)
-{
-	xfs_defer_init_op_type(&xfs_refcount_update_defer_type);
-}
-
 /* Inode Block Mapping */
 
 /* Sort bmap intents by inode. */
@@ -510,7 +488,7 @@ xfs_bmap_update_cancel_item(
 	kmem_free(bmap);
 }
 
-static const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_BMAP,
 	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
@@ -520,10 +498,3 @@ static const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.finish_item	= xfs_bmap_update_finish_item,
 	.cancel_item	= xfs_bmap_update_cancel_item,
 };
-
-/* Register the deferred op type. */
-void
-xfs_bmap_update_init_defer_op(void)
-{
-	xfs_defer_init_op_type(&xfs_bmap_update_defer_type);
-}
diff --git a/libxfs/init.c b/libxfs/init.c
index 10dcbf3a..7c6548a8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -248,11 +248,6 @@ libxfs_init(libxfs_init_t *a)
 	fd = -1;
 	flags = (a->isreadonly | a->isdirect);
 
-	xfs_extent_free_init_defer_op();
-	xfs_rmap_update_init_defer_op();
-	xfs_refcount_update_init_defer_op();
-	xfs_bmap_update_init_defer_op();
-
 	radix_tree_init();
 
 	if (a->volname) {
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5a6da0f3..68fe07a4 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -170,7 +170,13 @@
  * reoccur.
  */
 
-static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
+static const struct xfs_defer_op_type *defer_op_types[] = {
+	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
+	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
+	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
+	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+};
 
 /*
  * For each pending item in the intake list, log its intent item and the
@@ -486,6 +492,7 @@ xfs_defer_add(
 	struct xfs_defer_pending	*dfp = NULL;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
 	/*
 	 * Add the item to a pending item at the end of the intake list.
@@ -515,14 +522,6 @@ xfs_defer_add(
 	dfp->dfp_count++;
 }
 
-/* Initialize a deferred operation list. */
-void
-xfs_defer_init_op_type(
-	const struct xfs_defer_op_type	*type)
-{
-	defer_op_types[type->type] = type;
-}
-
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 2584a5b9..0a4b88e3 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -56,6 +56,10 @@ struct xfs_defer_op_type {
 	void (*log_item)(struct xfs_trans *, void *, struct list_head *);
 };
 
-void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
+extern const struct xfs_defer_op_type xfs_bmap_update_defer_type;
+extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
+extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
+extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
+extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
 #endif /* __XFS_DEFER_H__ */
