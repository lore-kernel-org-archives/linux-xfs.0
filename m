Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755974AbeEaSIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:08:47 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/21] xfs: remove xfs_reflink_find_cow_mapping
Date: Thu, 31 May 2018 20:07:52 +0200
Message-Id: <20180531180759.21631-15-hch@lst.de>
In-Reply-To: <20180531180759.21631-1-hch@lst.de>
References: <20180531180759.21631-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

We only have one caller left, and open coding the simple extent list
lookup in it allows us to make the code both more understandable and
reuse calculations and variables already present.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    | 19 +++++++++++++------
 fs/xfs/xfs_reflink.c | 30 ------------------------------
 fs/xfs/xfs_reflink.h |  2 --
 fs/xfs/xfs_trace.h   |  1 -
 4 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a0ecfd63b858..d49307312ca6 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -382,9 +382,10 @@ xfs_map_blocks(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			count = i_blocksize(inode);
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset), end_fsb;
+	xfs_fileoff_t		offset_fsb, end_fsb;
 	struct xfs_bmbt_irec	imap;
 	int			whichfork = XFS_DATA_FORK;
+	struct xfs_iext_cursor	icur;
 	int			error = 0;
 	int			nimaps = 1;
 
@@ -396,8 +397,18 @@ xfs_map_blocks(
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 
+	if (offset > mp->m_super->s_maxbytes - count)
+		count = mp->m_super->s_maxbytes - offset;
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+
+	/*
+	 * Check if this is offset is covered by a COW extents, and if yes use
+	 * it directly instead of looking up anything in the data fork.
+	 */
 	if (xfs_is_reflink_inode(ip) &&
-	    xfs_reflink_find_cow_mapping(ip, offset, &imap)) {
+	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap) &&
+	    imap.br_startoff <= offset_fsb) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		/*
 		 * Truncate can race with writeback since writeback doesn't
@@ -432,10 +443,6 @@ xfs_map_blocks(
 	 * offset.  This will convert delayed allocations (including COW ones)
 	 * into real extents.
 	 */
-	if (offset > mp->m_super->s_maxbytes - count)
-		count = mp->m_super->s_maxbytes - offset;
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 				&imap, &nimaps, XFS_BMAPI_ENTIRE);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d0092c864458..ff76bc56ff3d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -484,36 +484,6 @@ xfs_reflink_allocate_cow(
 	return error;
 }
 
-/*
- * Find the CoW reservation for a given byte offset of a file.
- */
-bool
-xfs_reflink_find_cow_mapping(
-	struct xfs_inode		*ip,
-	xfs_off_t			offset,
-	struct xfs_bmbt_irec		*imap)
-{
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	xfs_fileoff_t			offset_fsb;
-	struct xfs_bmbt_irec		got;
-	struct xfs_iext_cursor		icur;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
-
-	if (!xfs_is_reflink_inode(ip))
-		return false;
-	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
-	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got))
-		return false;
-	if (got.br_startoff > offset_fsb)
-		return false;
-
-	trace_xfs_reflink_find_cow_mapping(ip, offset, 1, XFS_IO_OVERWRITE,
-			&got);
-	*imap = got;
-	return true;
-}
-
 /*
  * Cancel CoW reservations for some block range of an inode.
  *
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c0a25609007b..e8d4d50c629f 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -32,8 +32,6 @@ extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode);
 extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
-extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
-		struct xfs_bmbt_irec *imap);
 
 extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
 		struct xfs_trans **tpp, xfs_fileoff_t offset_fsb,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 041045a8d65c..666844532030 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3227,7 +3227,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_bounce_dio_write);
-DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
-- 
2.17.0

