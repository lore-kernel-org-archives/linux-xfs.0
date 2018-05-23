Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933485AbeEWOpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 10:45:35 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/34] xfs: move all writeback buffer_head manipulation into xfs_map_at_offset
Date: Wed, 23 May 2018 16:43:53 +0200
Message-Id: <20180523144357.18985-31-hch@lst.de>
In-Reply-To: <20180523144357.18985-1-hch@lst.de>
References: <20180523144357.18985-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

This keeps it in a single place so it can be made otional more easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 592b33b35a30..951b329abb23 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -505,21 +505,6 @@ xfs_imap_valid(
 		offset < imap->br_startoff + imap->br_blockcount;
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
@@ -885,11 +875,9 @@ xfs_writepage_map(
 			continue;
 		}
 
-		lock_buffer(bh);
 		xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
 		xfs_add_to_ioend(inode, file_offset, page, wpc, wbc,
 				&submit_list);
-		xfs_start_buffer_writeback(bh);
 		count++;
 	}
 
-- 
2.17.0

