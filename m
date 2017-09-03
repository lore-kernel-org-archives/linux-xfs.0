Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbdICHav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:30:51 -0400
Received: from [91.114.64.3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doPMo-0007MW-GQ
        for linux-xfs@vger.kernel.org; Sun, 03 Sep 2017 07:30:50 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/17] xfs: remove xfs_bmbt_get_state
Date: Sun,  3 Sep 2017 09:29:56 +0200
Message-Id: <20170903072956.3175-18-hch@lst.de>
In-Reply-To: <20170903072956.3175-1-hch@lst.de>
References: <20170903072956.3175-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Unused after the big bmap refactor.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap_btree.c | 29 +----------------------------
 fs/xfs/libxfs/xfs_bmap_btree.h |  1 -
 2 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index e66ebd982cfb..086e6fc8e4fc 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -38,22 +38,6 @@
 #include "xfs_rmap.h"
 
 /*
- * Determine the extent state.
- */
-/* ARGSUSED */
-STATIC xfs_exntst_t
-xfs_extent_state(
-	xfs_filblks_t		blks,
-	int			extent_flag)
-{
-	if (extent_flag) {
-		ASSERT(blks != 0);	/* saved for DMIG */
-		return XFS_EXT_UNWRITTEN;
-	}
-	return XFS_EXT_NORM;
-}
-
-/*
  * Convert on-disk form of btree root to in-memory form.
  */
 void
@@ -90,7 +74,7 @@ xfs_bmdr_to_bmbt(
 /*
  * Convert a compressed bmap extent record to an uncompressed form.
  * This code must be in sync with the routines xfs_bmbt_get_startoff,
- * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
+ * xfs_bmbt_get_startblock and xfs_bmbt_get_blockcount.
  */
 STATIC void
 __xfs_bmbt_get_all(
@@ -156,17 +140,6 @@ xfs_bmbt_get_startoff(
 		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
-xfs_exntst_t
-xfs_bmbt_get_state(
-	xfs_bmbt_rec_host_t	*r)
-{
-	int	ext_flag;
-
-	ext_flag = (int)((r->l0) >> (64 - BMBT_EXNTFLAG_BITLEN));
-	return xfs_extent_state(xfs_bmbt_get_blockcount(r),
-				ext_flag);
-}
-
 /*
  * Extract the blockcount field from an on disk bmap extent record.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 93f95bcee915..6f891eeb88f6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -102,7 +102,6 @@ extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
 extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_host_t *r);
 extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
-extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
 
 void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
-- 
2.11.0

