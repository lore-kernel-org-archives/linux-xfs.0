Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752496AbeGBO60 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:26 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/22] xfs: move all writeback buffer_head manipulation into xfs_map_at_offset
Date: Mon,  2 Jul 2018 08:58:07 -0600
Message-Id: <20180702145813.22496-17-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

This keeps it in a single place so it can be made otional more easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6402e4323031..71b4ca60ff40 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -494,21 +494,6 @@ xfs_map_blocks(
 	return 0;
 }
 
-STATIC void
-xfs_start_buffer_writeback(
-	struct buffer_head	*bh)
-{
-	ASSERT(buffer_mapped(bh));
-	ASSERT(buffer_locked(bh));
-	ASSERT(!buffer_delay(bh));
-	ASSERT(!buffer_unwritten(bh));
-
-	bh->b_end_io = NULL;
-	set_buffer_async_write(bh);
-	set_buffer_uptodate(bh);
-	clear_buffer_dirty(bh);
-}
-
 STATIC void
 xfs_start_page_writeback(
 	struct page		*page,
@@ -728,6 +713,7 @@ xfs_map_at_offset(
 	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
 	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
+	lock_buffer(bh);
 	xfs_map_buffer(inode, bh, imap, offset);
 	set_buffer_mapped(bh);
 	clear_buffer_delay(bh);
@@ -740,6 +726,10 @@ xfs_map_at_offset(
 	 * set the bdev now.
 	 */
 	bh->b_bdev = xfs_find_bdev_for_inode(inode);
+	bh->b_end_io = NULL;
+	set_buffer_async_write(bh);
+	set_buffer_uptodate(bh);
+	clear_buffer_dirty(bh);
 }
 
 STATIC void
@@ -861,11 +851,9 @@ xfs_writepage_map(
 		if (wpc->io_type == XFS_IO_HOLE)
 			continue;
 
-		lock_buffer(bh);
 		xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
 		xfs_add_to_ioend(inode, file_offset, page, wpc, wbc,
 				&submit_list);
-		xfs_start_buffer_writeback(bh);
 		count++;
 	}
 
-- 
2.18.0

