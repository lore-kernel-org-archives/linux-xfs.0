Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbeERQt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 12:49:58 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 28/34] xfs: remove the imap_valid flag
Date: Fri, 18 May 2018 18:48:24 +0200
Message-Id: <20180518164830.1552-29-hch@lst.de>
In-Reply-To: <20180518164830.1552-1-hch@lst.de>
References: <20180518164830.1552-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

Simplify the way we check for a valid imap - we know we have a valid
mapping after xfs_map_blocks returned successfully, and we know we can
call xfs_imap_valid on any imap, as it will always fail on a
zero-initialized map.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 82fd08c29f7f..f01c1dd737ec 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -42,7 +42,6 @@
  */
 struct xfs_writepage_ctx {
 	struct xfs_bmbt_irec    imap;
-	bool			imap_valid;
 	unsigned int		io_type;
 	struct xfs_ioend	*ioend;
 	sector_t		last_block;
@@ -868,10 +867,6 @@ xfs_writepage_map(
 			continue;
 		}
 
-		/* Check to see if current map spans this file offset */
-		if (wpc->imap_valid)
-			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 file_offset);
 		/*
 		 * If we don't have a valid map, now it's time to get a new one
 		 * for this offset.  This will convert delayed allocations
@@ -879,16 +874,14 @@ xfs_writepage_map(
 		 * a valid map, it means we landed in a hole and we skip the
 		 * block.
 		 */
-		if (!wpc->imap_valid) {
+		if (!xfs_imap_valid(inode, &wpc->imap, file_offset)) {
 			error = xfs_map_blocks(inode, file_offset, &wpc->imap,
 					     &wpc->io_type);
 			if (error)
 				goto out;
-			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 file_offset);
 		}
 
-		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE) {
+		if (wpc->io_type == XFS_IO_HOLE) {
 			/*
 			 * set_page_dirty dirties all buffers in a page, independent
 			 * of their state.  The dirty state however is entirely
-- 
2.17.0

