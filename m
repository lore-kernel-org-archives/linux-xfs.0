Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:30 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/20] xfs: remove a pointless comment duplicated above all xfs_item_ops instances
Date: Thu, 13 Jun 2019 20:02:52 +0200
Message-Id: <20190613180300.30447-13-hch@lst.de>
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_item.c     | 6 ------
 fs/xfs/xfs_buf_item.c      | 3 ---
 fs/xfs/xfs_dquot_item.c    | 6 ------
 fs/xfs/xfs_extfree_item.c  | 6 ------
 fs/xfs/xfs_icreate_item.c  | 3 ---
 fs/xfs/xfs_inode_item.c    | 3 ---
 fs/xfs/xfs_refcount_item.c | 6 ------
 fs/xfs/xfs_rmap_item.c     | 6 ------
 8 files changed, 39 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6fb5263cb61d..e20ec733c8ae 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -125,9 +125,6 @@ xfs_bui_item_release(
 	xfs_bui_release(BUI_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all bui log items.
- */
 static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
@@ -208,9 +205,6 @@ xfs_bud_item_release(
 	kmem_zone_free(xfs_bud_zone, budp);
 }
 
-/*
- * This is the ops vector shared by all bud log items.
- */
 static const struct xfs_item_ops xfs_bud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_bud_item_size,
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ddeabb7ff18a..6d1e085c95d7 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -679,9 +679,6 @@ xfs_buf_item_committed(
 	return lsn;
 }
 
-/*
- * This is the ops vector shared by all buf log items.
- */
 static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_size	= xfs_buf_item_size,
 	.iop_format	= xfs_buf_item_format,
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index b8fd81641dfc..ade4520d3fdf 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -222,9 +222,6 @@ xfs_qm_dquot_logitem_committing(
 	return xfs_qm_dquot_logitem_release(lip);
 }
 
-/*
- * This is the ops vector for dquots
- */
 static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= xfs_qm_dquot_logitem_size,
 	.iop_format	= xfs_qm_dquot_logitem_format,
@@ -320,9 +317,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
 };
 
-/*
- * This is the ops vector shared by all quotaoff-start log items.
- */
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 92e182493000..e625df2eb09e 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -135,9 +135,6 @@ xfs_efi_item_release(
 	xfs_efi_release(EFI_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all efi log items.
- */
 static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
@@ -307,9 +304,6 @@ xfs_efd_item_release(
 	xfs_efd_item_free(efdp);
 }
 
-/*
- * This is the ops vector shared by all efd log items.
- */
 static const struct xfs_item_ops xfs_efd_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_efd_item_size,
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index ac9918da5f4a..c0376135889d 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -63,9 +63,6 @@ xfs_icreate_item_release(
 	kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all buf log items.
- */
 static const struct xfs_item_ops xfs_icreate_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_icreate_item_size,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a00f0b6aecc7..62847e95b399 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -627,9 +627,6 @@ xfs_inode_item_committing(
 	return xfs_inode_item_release(lip);
 }
 
-/*
- * This is the ops vector shared by all buf log items.
- */
 static const struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_size	= xfs_inode_item_size,
 	.iop_format	= xfs_inode_item_format,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 5b03478c5d1f..a4a2296546b6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -124,9 +124,6 @@ xfs_cui_item_release(
 	xfs_cui_release(CUI_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all cui log items.
- */
 static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
@@ -213,9 +210,6 @@ xfs_cud_item_release(
 	kmem_zone_free(xfs_cud_zone, cudp);
 }
 
-/*
- * This is the ops vector shared by all cud log items.
- */
 static const struct xfs_item_ops xfs_cud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_cud_item_size,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 3fbc7c5ffa96..c2f6acdc593d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -123,9 +123,6 @@ xfs_rui_item_release(
 	xfs_rui_release(RUI_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all rui log items.
- */
 static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
@@ -234,9 +231,6 @@ xfs_rud_item_release(
 	kmem_zone_free(xfs_rud_zone, rudp);
 }
 
-/*
- * This is the ops vector shared by all rud log items.
- */
 static const struct xfs_item_ops xfs_rud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_rud_item_size,
-- 
2.20.1
