Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59559 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754004AbdKCOqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:35 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdEx-000251-5t
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/21] xfs: allow unaligned extent records in xfs_bmbt_disk_set_all
Date: Fri,  3 Nov 2017 17:45:34 +0300
Message-Id: <20171103144539.2187-17-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

To make life a little simpler make xfs_bmbt_set_all unaligned access
aware so that we can use it directly on the destination buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 086e6fc8e4fc..89260972a0f6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -199,14 +199,14 @@ xfs_bmbt_disk_set_all(
 	ASSERT(!(s->br_blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)));
 	ASSERT(!(s->br_startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)));
 
-	r->l0 = cpu_to_be64(
+	put_unaligned_be64(
 		((xfs_bmbt_rec_base_t)extent_flag << 63) |
 		 ((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
-		 ((xfs_bmbt_rec_base_t)s->br_startblock >> 43));
-	r->l1 = cpu_to_be64(
+		 ((xfs_bmbt_rec_base_t)s->br_startblock >> 43), &r->l0);
+	put_unaligned_be64(
 		((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
 		 ((xfs_bmbt_rec_base_t)s->br_blockcount &
-		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
+		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)), &r->l1);
 }
 
 /*
-- 
2.14.2

