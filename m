Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbeJ3DPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 23:15:45 -0400
Subject: [PATCH 1/2] xfs: idiotproof defer op type configuration
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Oct 2018 11:25:52 -0700
Message-ID: <154083755233.16857.4514650502336344947.stgit@magnolia>
In-Reply-To: <154083754598.16857.4909403030667946114.stgit@magnolia>
References: <154083754598.16857.4909403030667946114.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Recently, we forgot to port a new defer op type to xfsprogs, which
caused us some userspace pain.  Reorganize the way we make libxfs
clients supply defer op type information so that all type information
has to be provided at build time instead of risky runtime dynamic
configuration.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c   |   17 ++++++++---------
 fs/xfs/libxfs/xfs_defer.h   |    6 +++++-
 fs/xfs/xfs_super.c          |    6 +-----
 fs/xfs/xfs_trans.h          |    4 ----
 fs/xfs/xfs_trans_bmap.c     |   10 ++--------
 fs/xfs/xfs_trans_extfree.c  |   13 +++----------
 fs/xfs/xfs_trans_refcount.c |   10 ++--------
 fs/xfs/xfs_trans_rmap.c     |   10 ++--------
 8 files changed, 23 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e792b167150a..277117a8ad13 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -172,7 +172,13 @@
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
@@ -488,6 +494,7 @@ xfs_defer_add(
 	struct xfs_defer_pending	*dfp = NULL;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
 	/*
 	 * Add the item to a pending item at the end of the intake list.
@@ -517,14 +524,6 @@ xfs_defer_add(
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
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 2584a5b95b0d..0a4b88e3df74 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
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
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d3e6cd063688..a2e944b80d2a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -38,6 +38,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_defer.h"
 
 #include <linux/namei.h>
 #include <linux/dax.h>
@@ -2085,11 +2086,6 @@ init_xfs_fs(void)
 	printk(KERN_INFO XFS_VERSION_STRING " with "
 			 XFS_BUILD_OPTIONS " enabled\n");
 
-	xfs_extent_free_init_defer_op();
-	xfs_rmap_update_init_defer_op();
-	xfs_refcount_update_init_defer_op();
-	xfs_bmap_update_init_defer_op();
-
 	xfs_dir_startup();
 
 	error = xfs_init_zones();
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a0c5dbda18aa..3ba14ebb7a3b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -223,7 +223,6 @@ void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
 bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 
-void		xfs_extent_free_init_defer_op(void);
 struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
 				  struct xfs_efi_log_item *,
 				  uint);
@@ -248,7 +247,6 @@ extern kmem_zone_t	*xfs_trans_zone;
 /* rmap updates */
 enum xfs_rmap_intent_type;
 
-void xfs_rmap_update_init_defer_op(void);
 struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
 		struct xfs_rui_log_item *ruip);
 int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
@@ -260,7 +258,6 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 /* refcount updates */
 enum xfs_refcount_intent_type;
 
-void xfs_refcount_update_init_defer_op(void);
 struct xfs_cud_log_item *xfs_trans_get_cud(struct xfs_trans *tp,
 		struct xfs_cui_log_item *cuip);
 int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
@@ -272,7 +269,6 @@ int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
 /* mapping updates */
 enum xfs_bmap_intent_type;
 
-void xfs_bmap_update_init_defer_op(void);
 struct xfs_bud_log_item *xfs_trans_get_bud(struct xfs_trans *tp,
 		struct xfs_bui_log_item *buip);
 int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index 741c558b2179..e027e68b4f9e 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -17,6 +17,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_defer.h"
 
 /*
  * This routine is called to allocate a "bmap update done"
@@ -220,7 +221,7 @@ xfs_bmap_update_cancel_item(
 	kmem_free(bmap);
 }
 
-static const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_BMAP,
 	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
 	.diff_items	= xfs_bmap_update_diff_items,
@@ -231,10 +232,3 @@ static const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
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
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 855c0b651fd4..1872962aa470 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -18,6 +18,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
+#include "xfs_defer.h"
 
 /*
  * This routine is called to allocate an "extent free done"
@@ -206,7 +207,7 @@ xfs_extent_free_cancel_item(
 	kmem_free(free);
 }
 
-static const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_FREE,
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
 	.diff_items	= xfs_extent_free_diff_items,
@@ -274,7 +275,7 @@ xfs_agfl_free_finish_item(
 
 
 /* sub-type with special handling for AGFL deferred frees */
-static const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
 	.diff_items	= xfs_extent_free_diff_items,
@@ -285,11 +286,3 @@ static const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.finish_item	= xfs_agfl_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
-
-/* Register the deferred op type. */
-void
-xfs_extent_free_init_defer_op(void)
-{
-	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
-	xfs_defer_init_op_type(&xfs_agfl_free_defer_type);
-}
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
index 523c55663954..116c040d54bd 100644
--- a/fs/xfs/xfs_trans_refcount.c
+++ b/fs/xfs/xfs_trans_refcount.c
@@ -16,6 +16,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_alloc.h"
 #include "xfs_refcount.h"
+#include "xfs_defer.h"
 
 /*
  * This routine is called to allocate a "refcount update done"
@@ -227,7 +228,7 @@ xfs_refcount_update_cancel_item(
 	kmem_free(refc);
 }
 
-static const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_REFCOUNT,
 	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
 	.diff_items	= xfs_refcount_update_diff_items,
@@ -239,10 +240,3 @@ static const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.finish_cleanup = xfs_refcount_update_finish_cleanup,
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
-
-/* Register the deferred op type. */
-void
-xfs_refcount_update_init_defer_op(void)
-{
-	xfs_defer_init_op_type(&xfs_refcount_update_defer_type);
-}
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 05b00e40251f..f75cdc5b578a 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -16,6 +16,7 @@
 #include "xfs_rmap_item.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_defer.h"
 
 /* Set the map extent flags for this reverse mapping. */
 static void
@@ -244,7 +245,7 @@ xfs_rmap_update_cancel_item(
 	kmem_free(rmap);
 }
 
-static const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.type		= XFS_DEFER_OPS_TYPE_RMAP,
 	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
 	.diff_items	= xfs_rmap_update_diff_items,
@@ -256,10 +257,3 @@ static const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.finish_cleanup = xfs_rmap_update_finish_cleanup,
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
-
-/* Register the deferred op type. */
-void
-xfs_rmap_update_init_defer_op(void)
-{
-	xfs_defer_init_op_type(&xfs_rmap_update_defer_type);
-}
