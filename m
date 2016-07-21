Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0952E7CA4
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:57:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1FC230404E
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id KcECzOWceGU4t1gL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:43 -0700 (PDT)
Subject: [PATCH 14/47] xfs: enable the xfs_defer mechanism to process
	extents to free
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:57:37 -0700
Message-ID: <146907705713.25461.10249893969831969843.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Connect the xfs_defer mechanism with the pieces that we'll need to
handle deferred extent freeing.  We'll wire up the existing code to
our new deferred mechanism later.

v2: Move the deferred item code into xfs_trans_extfree.c. (kernel)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.h  |    1 
 fs/xfs/xfs_super.c         |    2 +
 fs/xfs/xfs_trans.h         |    2 +
 fs/xfs/xfs_trans_extfree.c |  110 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index a227bd2..b9b5a92 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -51,6 +51,7 @@ struct xfs_defer_pending {
  * find all the space it needs.
  */
 enum xfs_defer_ops_type {
+	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 258b594..ce50474 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1858,6 +1858,8 @@ init_xfs_fs(void)
 	printk(KERN_INFO XFS_VERSION_STRING " with "
 			 XFS_BUILD_OPTIONS " enabled\n");
 
+	xfs_extent_free_init_defer_op();
+
 	xfs_dir_startup();
 
 	error = xfs_init_zones();
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 5226511..005fbec 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -209,6 +209,8 @@ void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
+
+void		xfs_extent_free_init_defer_op(void);
 struct xfs_efi_log_item	*xfs_trans_get_efi(struct xfs_trans *, uint);
 void		xfs_trans_log_efi_extent(struct xfs_trans *,
 					 struct xfs_efi_log_item *,
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 380cc46..a9f34ee 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -22,10 +22,12 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
+#include "xfs_bmap.h"
 
 /*
  * This routine is called to allocate an "extent free intention"
@@ -145,3 +147,111 @@ xfs_trans_free_extent(
 
 	return error;
 }
+
+/* Sort bmap items by AG. */
+static int
+xfs_extent_free_diff_items(
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
+xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	return xfs_trans_get_efi(tp, count);
+}
+
+/* Log a free extent to the intent item. */
+STATIC void
+xfs_extent_free_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_bmap_free_item	*free;
+
+	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
+	xfs_trans_log_efi_extent(tp, intent, free->xbfi_startblock,
+			free->xbfi_blockcount);
+}
+
+/* Get an EFD so we can process all the free extents. */
+STATIC void *
+xfs_extent_free_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return xfs_trans_get_efd(tp, intent, count);
+}
+
+/* Process a free extent. */
+STATIC int
+xfs_extent_free_finish_item(
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
+	error = xfs_trans_free_extent(tp, done_item,
+			free->xbfi_startblock,
+			free->xbfi_blockcount);
+	kmem_free(free);
+	return error;
+}
+
+/* Abort all pending EFIs. */
+STATIC void
+xfs_extent_free_abort_intent(
+	void				*intent)
+{
+	xfs_efi_release(intent);
+}
+
+/* Cancel a free extent. */
+STATIC void
+xfs_extent_free_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_bmap_free_item	*free;
+
+	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
+	kmem_free(free);
+}
+
+static const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_FREE,
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.diff_items	= xfs_extent_free_diff_items,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.log_item	= xfs_extent_free_log_item,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_extent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+};
+
+/* Register the deferred op type. */
+void
+xfs_extent_free_init_defer_op(void)
+{
+	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
