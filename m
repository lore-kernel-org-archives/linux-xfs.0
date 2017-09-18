Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53403 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752938AbdIRPYd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:24:33 -0400
Received: from [107.17.164.65] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dtxuS-0005FC-Mb
        for linux-xfs@vger.kernel.org; Mon, 18 Sep 2017 15:24:32 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/19] xfs: remove xfs_bmbt_get_state
Date: Mon, 18 Sep 2017 08:24:22 -0700
Message-Id: <20170918152422.24345-20-hch@lst.de>
In-Reply-To: <20170918152422.24345-1-hch@lst.de>
References: <20170918152422.24345-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Unused after the big bmap refactor.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c | 29 +----------------------------
 fs/xfs/libxfs/xfs_bmap_btree.h |  1 -
 2 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index e66ebd982cfb..086e6fc8e4fc 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -37,22 +37,6 @@
 #include "xfs_cksum.h"
 #include "xfs_rmap.h"
 
-/*
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
 /*
  * Convert on-disk form of btree root to in-memory form.
  */
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
2.14.1

