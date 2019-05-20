Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732368AbfETQPc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:15:32 -0400
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkwl-0006xF-NZ
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:15:32 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/17] xfs: remove the b_io_length field in struct xfs_buf
Date: Mon, 20 May 2019 18:13:47 +0200
Message-Id: <20190520161347.3044-18-hch@lst.de>
In-Reply-To: <20190520161347.3044-1-hch@lst.de>
References: <20190520161347.3044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This field is now always idential to b_length.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c         | 5 ++---
 fs/xfs/xfs_buf.h         | 1 -
 fs/xfs/xfs_log_recover.c | 9 ++++-----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d44097e645a5..bb37e7a683e7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -263,7 +263,6 @@ _xfs_buf_alloc(
 		bp->b_maps[i].bm_len = map[i].bm_len;
 		bp->b_length += map[i].bm_len;
 	}
-	bp->b_io_length = bp->b_length;
 
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
@@ -1407,7 +1406,7 @@ _xfs_buf_ioapply(
 	 * subsequent call.
 	 */
 	offset = bp->b_offset;
-	size = BBTOB(bp->b_io_length);
+	size = BBTOB(bp->b_length);
 	blk_start_plug(&plug);
 	for (i = 0; i < bp->b_map_count; i++) {
 		xfs_buf_ioapply_map(bp, i, &offset, &size, op, op_flags);
@@ -1540,7 +1539,7 @@ xfs_buf_zero(
 		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
 		page = bp->b_pages[page_index];
 		csize = min_t(size_t, PAGE_SIZE - page_offset,
-				      BBTOB(bp->b_io_length) - boff);
+				      BBTOB(bp->b_length) - boff);
 
 		ASSERT((csize + page_offset) <= PAGE_SIZE);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 27f05db07214..178fdfc747b3 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -158,7 +158,6 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	*b_maps;	/* compound buffer map */
 	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
-	int			b_io_length;	/* IO size in BBs */
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 350c9a123dad..fc968d67813f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2152,7 +2152,7 @@ xlog_recover_do_inode_buffer(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		bp->b_ops = &xfs_inode_buf_ops;
 
-	inodes_per_buf = BBTOB(bp->b_io_length) >> mp->m_sb.sb_inodelog;
+	inodes_per_buf = BBTOB(bp->b_length) >> mp->m_sb.sb_inodelog;
 	for (i = 0; i < inodes_per_buf; i++) {
 		next_unlinked_offset = (i * mp->m_sb.sb_inodesize) +
 			offsetof(xfs_dinode_t, di_next_unlinked);
@@ -2194,8 +2194,7 @@ xlog_recover_do_inode_buffer(
 
 		ASSERT(item->ri_buf[item_index].i_addr != NULL);
 		ASSERT((item->ri_buf[item_index].i_len % XFS_BLF_CHUNK) == 0);
-		ASSERT((reg_buf_offset + reg_buf_bytes) <=
-							BBTOB(bp->b_io_length));
+		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
 
 		/*
 		 * The current logged region contains a copy of the
@@ -2660,7 +2659,7 @@ xlog_recover_do_reg_buffer(
 		ASSERT(nbits > 0);
 		ASSERT(item->ri_buf[i].i_addr != NULL);
 		ASSERT(item->ri_buf[i].i_len % XFS_BLF_CHUNK == 0);
-		ASSERT(BBTOB(bp->b_io_length) >=
+		ASSERT(BBTOB(bp->b_length) >=
 		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
 
 		/*
@@ -2883,7 +2882,7 @@ xlog_recover_buffer_pass2(
 	 */
 	if (XFS_DINODE_MAGIC ==
 	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
-	    (BBTOB(bp->b_io_length) != max(log->l_mp->m_sb.sb_blocksize,
+	    (BBTOB(bp->b_length) != max(log->l_mp->m_sb.sb_blocksize,
 			(uint32_t)log->l_mp->m_inode_cluster_size))) {
 		xfs_buf_stale(bp);
 		error = xfs_bwrite(bp);
-- 
2.20.1
