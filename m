Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932756AbeEaSIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:08:54 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/21] xfs: remove the imap_valid flag
Date: Thu, 31 May 2018 20:07:54 +0200
Message-Id: <20180531180759.21631-17-hch@lst.de>
In-Reply-To: <20180531180759.21631-1-hch@lst.de>
References: <20180531180759.21631-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Simplify the way we check for a valid imap - we know we have a valid
mapping after xfs_map_blocks returned successfully, and we know we can
call xfs_imap_valid on any imap, as it will always fail on a
zero-initialized map.

We can also remove the xfs_imap_valid function and fold it into
xfs_map_blocks now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 78 +++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5c4cc713edba..5f8e40a032b1 100644
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
@@ -382,15 +381,40 @@ xfs_map_blocks(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			count = i_blocksize(inode);
-	xfs_fileoff_t		offset_fsb, end_fsb;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset), end_fsb;
 	struct xfs_bmbt_irec	imap;
 	int			whichfork = XFS_DATA_FORK;
 	struct xfs_iext_cursor	icur;
+	bool			imap_valid;
 	int			error = 0;
 
+	/*
+	 * We have to make sure the cached mapping is within EOF to protect
+	 * against eofblocks trimming on file release leaving us with a stale
+	 * mapping. Otherwise, a page for a subsequent file extending buffered
+	 * write could get picked up by this writeback cycle and written to the
+	 * wrong blocks.
+	 *
+	 * Note that what we really want here is a generic mapping invalidation
+	 * mechanism to protect us from arbitrary extent modifying contexts, not
+	 * just eofblocks.
+	 */
+	xfs_trim_extent_eof(&wpc->imap, ip);
+
+	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
+		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
+	if (imap_valid && !xfs_is_reflink_inode(ip))
+		return 0;
+
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	/*
+	 * If we don't have a valid map, now it's time to get a new one for this
+	 * offset.  This will convert delayed allocations (including COW ones)
+	 * into real extents.  If we return without a valid map, it means we
+	 * landed in a hole and we skip the block.
+	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
@@ -399,7 +423,6 @@ xfs_map_blocks(
 	if (offset > mp->m_super->s_maxbytes - count)
 		count = mp->m_super->s_maxbytes - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
 	/*
 	 * Check if this is offset is covered by a COW extents, and if yes use
@@ -432,7 +455,7 @@ xfs_map_blocks(
 	/*
 	 * Map valid and no COW extent in the way?  We're done.
 	 */
-	if (wpc->imap_valid) {
+	if (imap_valid) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return 0;
 	}
@@ -477,31 +500,6 @@ xfs_map_blocks(
 	return 0;
 }
 
-STATIC bool
-xfs_imap_valid(
-	struct inode		*inode,
-	struct xfs_bmbt_irec	*imap,
-	xfs_off_t		offset)
-{
-	offset >>= inode->i_blkbits;
-
-	/*
-	 * We have to make sure the cached mapping is within EOF to protect
-	 * against eofblocks trimming on file release leaving us with a stale
-	 * mapping. Otherwise, a page for a subsequent file extending buffered
-	 * write could get picked up by this writeback cycle and written to the
-	 * wrong blocks.
-	 *
-	 * Note that what we really want here is a generic mapping invalidation
-	 * mechanism to protect us from arbitrary extent modifying contexts, not
-	 * just eofblocks.
-	 */
-	xfs_trim_extent_eof(imap, XFS_I(inode));
-
-	return offset >= imap->br_startoff &&
-		offset < imap->br_startoff + imap->br_blockcount;
-}
-
 STATIC void
 xfs_start_buffer_writeback(
 	struct buffer_head	*bh)
@@ -858,25 +856,11 @@ xfs_writepage_map(
 			continue;
 		}
 
-		if (wpc->imap_valid)
-			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 file_offset);
-		/*
-		 * If we don't have a valid map, now it's time to get a new one
-		 * for this offset.  This will convert delayed allocations
-		 * (including COW ones) into real extents.  If we return without
-		 * a valid map, it means we landed in a hole and we skip the
-		 * block.
-		 */
-		if (!wpc->imap_valid || xfs_is_reflink_inode(XFS_I(inode))) {
-			error = xfs_map_blocks(wpc, inode, file_offset);
-			if (error)
-				goto out;
-			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 file_offset);
-		}
+		error = xfs_map_blocks(wpc, inode, file_offset);
+		if (error)
+			goto out;
 
-		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE)
+		if (wpc->io_type == XFS_IO_HOLE)
 			continue;
 
 		lock_buffer(bh);
-- 
2.17.0

