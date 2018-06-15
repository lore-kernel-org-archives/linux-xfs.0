Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37418 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936262AbeFONDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 09:03:07 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/24] xfs: move all writeback buffer_head manipulation into xfs_map_at_offset
Date: Fri, 15 Jun 2018 15:02:04 +0200
Message-Id: <20180615130209.1970-20-hch@lst.de>
In-Reply-To: <20180615130209.1970-1-hch@lst.de>
References: <20180615130209.1970-1-hch@lst.de>
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
index d6bd38d4243e..261fb011ef9d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -500,21 +500,6 @@ xfs_map_blocks(
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
@@ -723,6 +708,7 @@ xfs_map_at_offset(
 	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
 	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
+	lock_buffer(bh);
 	xfs_map_buffer(inode, bh, imap, offset);
 	set_buffer_mapped(bh);
 	clear_buffer_delay(bh);
@@ -735,6 +721,10 @@ xfs_map_at_offset(
 	 * set the bdev now.
 	 */
 	bh->b_bdev = xfs_find_bdev_for_inode(inode);
+	bh->b_end_io = NULL;
+	set_buffer_async_write(bh);
+	set_buffer_uptodate(bh);
+	clear_buffer_dirty(bh);
 }
 
 STATIC void
@@ -858,11 +848,9 @@ xfs_writepage_map(
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
2.17.1

