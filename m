Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeGLN7R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jul 2018 09:59:17 -0400
Received: from 213-225-6-92.nat.highway.a1.net ([213.225.6.92] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fdbyU-0008HK-BH
        for linux-xfs@vger.kernel.org; Thu, 12 Jul 2018 13:49:38 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if the fork didn't change
Date: Thu, 12 Jul 2018 15:49:10 +0200
Message-Id: <20180712134910.30298-7-hch@lst.de>
In-Reply-To: <20180712134910.30298-1-hch@lst.de>
References: <20180712134910.30298-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Used the per-fork sequence counter to avoid lookups in the writeback code
unless the COW fork actually changed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_iomap.c |  5 ++++-
 fs/xfs/xfs_iomap.h |  2 +-
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 814100d27343..aff9d44fa338 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -29,6 +29,7 @@
 struct xfs_writepage_ctx {
 	struct xfs_bmbt_irec    imap;
 	unsigned int		io_type;
+	unsigned int		cow_seq;
 	struct xfs_ioend	*ioend;
 };
 
@@ -310,6 +311,7 @@ xfs_map_blocks(
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset), end_fsb;
+	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
 	struct xfs_bmbt_irec	imap;
 	int			whichfork = XFS_DATA_FORK;
 	struct xfs_iext_cursor	icur;
@@ -333,12 +335,15 @@ xfs_map_blocks(
 	 * COW fork blocks can overlap data fork blocks even if the blocks
 	 * aren't shared.  COW I/O always takes precedent, so we must always
 	 * check for overlap on reflink inodes unless the mapping is already a
-	 * COW one.
+	 * COW one, or the COW fork hasn't changed from the last time we looked
+	 * at it.
 	 */
 	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
 		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
 	if (imap_valid &&
-	    (!xfs_inode_has_cow_data(ip) || wpc->io_type == XFS_IO_COW))
+	    (!xfs_inode_has_cow_data(ip) ||
+	     wpc->io_type == XFS_IO_COW ||
+	     wpc->cow_seq == ip->i_cowfp->if_seq))
 		return 0;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -364,8 +369,10 @@ xfs_map_blocks(
 	 * it directly instead of looking up anything in the data fork.
 	 */
 	if (xfs_inode_has_cow_data(ip) &&
-	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap) &&
-	    imap.br_startoff <= offset_fsb) {
+	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap))
+		cow_fsb = imap.br_startoff;
+	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
+		wpc->cow_seq = ip->i_cowfp->if_seq;
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		/*
 		 * Truncate can race with writeback since writeback doesn't
@@ -411,6 +418,16 @@ xfs_map_blocks(
 		imap.br_startblock = HOLESTARTBLOCK;
 		wpc->io_type = XFS_IO_HOLE;
 	} else {
+		/*
+		 * Truncate to the next COW extent if there is one.  This is the
+		 * only opportunity to do this because we can skip COW fork
+		 * lookups for the subsequent blocks in the mapping; however,
+		 * the requirement to treat the COW range separately remains.
+		 */
+		if (cow_fsb != NULLFILEOFF &&
+		    cow_fsb < imap.br_startoff + imap.br_blockcount)
+			imap.br_blockcount = cow_fsb - imap.br_startoff;
+
 		if (isnullstartblock(imap.br_startblock)) {
 			/* got a delalloc extent */
 			wpc->io_type = XFS_IO_DELALLOC;
@@ -427,9 +444,12 @@ xfs_map_blocks(
 	trace_xfs_map_blocks_found(ip, offset, count, wpc->io_type, &imap);
 	return 0;
 allocate_blocks:
-	error = xfs_iomap_write_allocate(ip, whichfork, offset, &imap);
+	error = xfs_iomap_write_allocate(ip, whichfork, offset, &imap,
+			&wpc->cow_seq);
 	if (error)
 		return error;
+	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
+	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
 	wpc->imap = imap;
 	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->io_type, &imap);
 	return 0;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 756694219f77..43a7ff7f450c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -658,7 +658,8 @@ xfs_iomap_write_allocate(
 	xfs_inode_t	*ip,
 	int		whichfork,
 	xfs_off_t	offset,
-	xfs_bmbt_irec_t *imap)
+	xfs_bmbt_irec_t *imap,
+	unsigned int	*cow_seq)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb, last_block;
@@ -780,6 +781,8 @@ xfs_iomap_write_allocate(
 			if (error)
 				goto error0;
 
+			if (whichfork == XFS_COW_FORK)
+				*cow_seq = XFS_IFORK_PTR(ip, whichfork)->if_seq;
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		}
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 83474c9cede9..c6170548831b 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -14,7 +14,7 @@ struct xfs_bmbt_irec;
 int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *, int);
 int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
-			struct xfs_bmbt_irec *);
+			struct xfs_bmbt_irec *, unsigned int *);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 
 void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
-- 
2.18.0

