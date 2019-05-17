Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44084 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfEQHc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:29 -0400
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLw-0000kv-IU
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:28 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/20] xfs: add a flag to release log items on commit
Date: Fri, 17 May 2019 09:31:07 +0200
Message-Id: <20190517073119.30178-9-hch@lst.de>
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We have various items that are released from ->iop_comitting.  Add a
flag to just call ->iop_release from the commit path to avoid tons
of boilerplate code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c     | 27 +--------------------------
 fs/xfs/xfs_extfree_item.c  | 27 +--------------------------
 fs/xfs/xfs_icreate_item.c  | 18 +-----------------
 fs/xfs/xfs_refcount_item.c | 27 +--------------------------
 fs/xfs/xfs_rmap_item.c     | 27 +--------------------------
 fs/xfs/xfs_trans.c         |  5 +++++
 fs/xfs/xfs_trans.h         |  7 +++++++
 7 files changed, 17 insertions(+), 121 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 56c1ab161f3b..d7ceb2d1ae82 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -208,39 +208,14 @@ xfs_bud_item_release(
 	kmem_zone_free(xfs_bud_zone, budp);
 }
 
-/*
- * When the bud item is committed to disk, all we need to do is delete our
- * reference to our partner bui item and then free ourselves. Since we're
- * freeing ourselves we must return -1 to keep the transaction code from
- * further referencing this item.
- */
-STATIC xfs_lsn_t
-xfs_bud_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
-
-	/*
-	 * Drop the BUI reference regardless of whether the BUD has been
-	 * aborted. Once the BUD transaction is constructed, it is the sole
-	 * responsibility of the BUD to release the BUI (even if the BUI is
-	 * aborted due to log I/O error).
-	 */
-	xfs_bui_release(budp->bud_buip);
-	kmem_zone_free(xfs_bud_zone, budp);
-
-	return (xfs_lsn_t)-1;
-}
-
 /*
  * This is the ops vector shared by all bud log items.
  */
 static const struct xfs_item_ops xfs_bud_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_bud_item_size,
 	.iop_format	= xfs_bud_item_format,
 	.iop_release	= xfs_bud_item_release,
-	.iop_committed	= xfs_bud_item_committed,
 };
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a73a3cff8502..762eb288dfe8 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -307,39 +307,14 @@ xfs_efd_item_release(
 	xfs_efd_item_free(efdp);
 }
 
-/*
- * When the efd item is committed to disk, all we need to do is delete our
- * reference to our partner efi item and then free ourselves. Since we're
- * freeing ourselves we must return -1 to keep the transaction code from further
- * referencing this item.
- */
-STATIC xfs_lsn_t
-xfs_efd_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
-
-	/*
-	 * Drop the EFI reference regardless of whether the EFD has been
-	 * aborted. Once the EFD transaction is constructed, it is the sole
-	 * responsibility of the EFD to release the EFI (even if the EFI is
-	 * aborted due to log I/O error).
-	 */
-	xfs_efi_release(efdp->efd_efip);
-	xfs_efd_item_free(efdp);
-
-	return (xfs_lsn_t)-1;
-}
-
 /*
  * This is the ops vector shared by all efd log items.
  */
 static const struct xfs_item_ops xfs_efd_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_efd_item_size,
 	.iop_format	= xfs_efd_item_format,
 	.iop_release	= xfs_efd_item_release,
-	.iop_committed	= xfs_efd_item_committed,
 };
 
 /*
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 9aceb35dce24..eb9cb04635be 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -63,30 +63,14 @@ xfs_icreate_item_release(
 	kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
 }
 
-/*
- * Because we have ordered buffers being tracked in the AIL for the inode
- * creation, we don't need the create item after this. Hence we can free
- * the log item and return -1 to tell the caller we're done with the item.
- */
-STATIC xfs_lsn_t
-xfs_icreate_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
-
-	kmem_zone_free(xfs_icreate_zone, icp);
-	return (xfs_lsn_t)-1;
-}
-
 /*
  * This is the ops vector shared by all buf log items.
  */
 static const struct xfs_item_ops xfs_icreate_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_icreate_item_size,
 	.iop_format	= xfs_icreate_item_format,
 	.iop_release	= xfs_icreate_item_release,
-	.iop_committed	= xfs_icreate_item_committed,
 };
 
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 9f8fb23dcc81..b4ab71ce39fc 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -213,39 +213,14 @@ xfs_cud_item_release(
 	kmem_zone_free(xfs_cud_zone, cudp);
 }
 
-/*
- * When the cud item is committed to disk, all we need to do is delete our
- * reference to our partner cui item and then free ourselves. Since we're
- * freeing ourselves we must return -1 to keep the transaction code from
- * further referencing this item.
- */
-STATIC xfs_lsn_t
-xfs_cud_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
-
-	/*
-	 * Drop the CUI reference regardless of whether the CUD has been
-	 * aborted. Once the CUD transaction is constructed, it is the sole
-	 * responsibility of the CUD to release the CUI (even if the CUI is
-	 * aborted due to log I/O error).
-	 */
-	xfs_cui_release(cudp->cud_cuip);
-	kmem_zone_free(xfs_cud_zone, cudp);
-
-	return (xfs_lsn_t)-1;
-}
-
 /*
  * This is the ops vector shared by all cud log items.
  */
 static const struct xfs_item_ops xfs_cud_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_cud_item_size,
 	.iop_format	= xfs_cud_item_format,
 	.iop_release	= xfs_cud_item_release,
-	.iop_committed	= xfs_cud_item_committed,
 };
 
 /*
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e907bd169de5..1b35b3d38708 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -234,39 +234,14 @@ xfs_rud_item_release(
 	kmem_zone_free(xfs_rud_zone, rudp);
 }
 
-/*
- * When the rud item is committed to disk, all we need to do is delete our
- * reference to our partner rui item and then free ourselves. Since we're
- * freeing ourselves we must return -1 to keep the transaction code from
- * further referencing this item.
- */
-STATIC xfs_lsn_t
-xfs_rud_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
-
-	/*
-	 * Drop the RUI reference regardless of whether the RUD has been
-	 * aborted. Once the RUD transaction is constructed, it is the sole
-	 * responsibility of the RUD to release the RUI (even if the RUI is
-	 * aborted due to log I/O error).
-	 */
-	xfs_rui_release(rudp->rud_ruip);
-	kmem_zone_free(xfs_rud_zone, rudp);
-
-	return (xfs_lsn_t)-1;
-}
-
 /*
  * This is the ops vector shared by all rud log items.
  */
 static const struct xfs_item_ops xfs_rud_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_rud_item_size,
 	.iop_format	= xfs_rud_item_format,
 	.iop_release	= xfs_rud_item_release,
-	.iop_committed	= xfs_rud_item_committed,
 };
 
 /*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 45a39de65997..52a8a8ff2ae9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -849,6 +849,11 @@ xfs_trans_committed_bulk(
 		struct xfs_log_item	*lip = lv->lv_item;
 		xfs_lsn_t		item_lsn;
 
+		if (lip->li_ops->flags & XFS_ITEM_RELEASE_ON_COMMIT) {
+			lip->li_ops->iop_release(lip);
+			continue;
+		}
+
 		if (aborted)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
 		if (lip->li_ops->iop_committed)
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7bd1867613c2..a38af44344bf 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -67,6 +67,7 @@ typedef struct xfs_log_item {
 	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
 
 struct xfs_item_ops {
+	unsigned flags;
 	void (*iop_size)(xfs_log_item_t *, int *, int *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_vec *);
 	void (*iop_pin)(xfs_log_item_t *);
@@ -78,6 +79,12 @@ struct xfs_item_ops {
 	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
 };
 
+/*
+ * Release the log item as soon as committed.  This is for items just logging
+ * intents that never need to be written back in place.
+ */
+#define XFS_ITEM_RELEASE_ON_COMMIT	(1 << 0)
+
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 			  int type, const struct xfs_item_ops *ops);
 
-- 
2.20.1
