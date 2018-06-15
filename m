Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37370 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936251AbeFONDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 09:03:01 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/24] xfs: remove the imap_valid flag
Date: Fri, 15 Jun 2018 15:02:02 +0200
Message-Id: <20180615130209.1970-18-hch@lst.de>
In-Reply-To: <20180615130209.1970-1-hch@lst.de>
References: <20180615130209.1970-1-hch@lst.de>
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
 fs/xfs/xfs_aops.c | 75 ++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 25239bc189d4..7da3fe49b4de 100644
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
@@ -382,15 +381,41 @@ xfs_map_blocks(
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
+	if (imap_valid &&
+	    (!xfs_is_reflink_inode(ip) || wpc->io_type == XFS_IO_COW))
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
@@ -399,7 +424,6 @@ xfs_map_blocks(
 	if (offset > mp->m_super->s_maxbytes - count)
 		count = mp->m_super->s_maxbytes - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
 	/*
 	 * Check if this is offset is covered by a COW extents, and if yes use
@@ -432,7 +456,7 @@ xfs_map_blocks(
 	/*
 	 * Map valid and no COW extent in the way?  We're done.
 	 */
-	if (wpc->imap_valid) {
+	if (imap_valid) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return 0;
 	}
@@ -477,31 +501,6 @@ xfs_map_blocks(
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
@@ -858,20 +857,11 @@ xfs_writepage_map(
 			continue;
 		}
 
-		if (wpc->imap_valid)
-			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 file_offset);
-		if (!wpc->imap_valid ||
-		    (xfs_is_reflink_inode(XFS_I(inode)) &&
-		     wpc->io_type != XFS_IO_COW)) {
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
@@ -881,7 +871,6 @@ xfs_writepage_map(
 	}
 
 	ASSERT(wpc->ioend || list_empty(&submit_list));
-
 out:
 	/*
 	 * On error, we have to fail the ioend here because we have locked
-- 
2.17.1

