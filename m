Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56360 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731331AbfEWRlq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:41:46 -0400
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrir-0002Ry-8e
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:41:45 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/20] xfs: return an offset instead of a pointer from xlog_align
Date: Thu, 23 May 2019 19:37:37 +0200
Message-Id: <20190523173742.15551-16-hch@lst.de>
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This simplifies both the helper and the callers.  We lost a bit of
size sanity checking, but that is already covered by KASAN if needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4139b907e9cd..74fd3784bcb7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -151,20 +151,14 @@ xlog_put_bp(
  * Return the address of the start of the given block number's data
  * in a log buffer.  The buffer covers a log sector-aligned region.
  */
-STATIC char *
+static inline unsigned int
 xlog_align(
 	struct xlog	*log,
-	xfs_daddr_t	blk_no,
-	int		nbblks,
-	struct xfs_buf	*bp)
+	xfs_daddr_t	blk_no)
 {
-	xfs_daddr_t	offset = blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1);
-
-	ASSERT(offset + nbblks <= bp->b_length);
-	return bp->b_addr + BBTOB(offset);
+	return BBTOB(blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1));
 }
 
-
 /*
  * nbblks should be uint, but oh well.  Just want to catch that 32-bit length.
  */
@@ -216,7 +210,7 @@ xlog_bread(
 	if (error)
 		return error;
 
-	*offset = xlog_align(log, blk_no, nbblks, bp);
+	*offset = bp->b_addr + xlog_align(log, blk_no);
 	return 0;
 }
 
@@ -1713,7 +1707,7 @@ xlog_write_log_records(
 
 		}
 
-		offset = xlog_align(log, start_block, endcount, bp);
+		offset = bp->b_addr + xlog_align(log, start_block);
 		for (; j < endcount; j++) {
 			xlog_add_record(log, offset, cycle, i+j,
 					tail_cycle, tail_block);
-- 
2.20.1
