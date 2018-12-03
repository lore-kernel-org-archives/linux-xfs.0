Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36452 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeLCWZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 17:25:09 -0500
Received: from ip-64-134-180-251.public.wayport.net ([64.134.180.251] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gTweK-0004Uh-U1
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 22:25:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/11] xfs: rework the truncate race handling in the writeback path
Date: Mon,  3 Dec 2018 17:24:56 -0500
Message-Id: <20181203222503.30649-5-hch@lst.de>
In-Reply-To: <20181203222503.30649-1-hch@lst.de>
References: <20181203222503.30649-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We currently try to handle the races with truncate and COW to data fork
conversion rather ad-hoc in a few places in the writeback path:

 - xfs_map_blocks contains an i_size check for the COW fork only, and
   returns an imap containing a hole to make the writeback code skip
   the rest of the page
 - xfs_iomap_write_allocate does another i_size check under ilock, and
   does an extent tree lookup to find the last extent to skip everthing
   beyond that, returning -EAGAIN if either is invalid to make the
   writeback code exit early
 - xfs_bmapi_write can ignore holes for delalloc conversions, but only
   does so if called for the COW fork

Replace this with a coherent scheme:

 - check i_size first in xfs_map_blocks, and skip any processing if we
   already are beyond i_size by presenting a hole until the end of the
   file to the caller
 - in xfs_iomap_write_allocate check i_size again, and return -EAGAIN
   if we are beyond it now that we've taken ilock.
 - Skip holes for all delalloc conversion in xfs_bmapi_write instead
   of doing a separate lookup before calling it
 - in xfs_map_blocks retry the case where xfs_iomap_write_allocate
   could not perform a conversion one single time if we were on a COW
   fork to handle the race where an extent moved from the COW to the
   data fork, and else return a hole to skip writeback as we must
   have races with writeback

Overall this greatly simplifies the code, makes it more robust and also
handles the COW to data fork race properly that we did not handle
previosuly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |  27 ++++-----
 fs/xfs/xfs_aops.c        |  61 +++++++++++++-------
 fs/xfs/xfs_iomap.c       | 121 ++++++++++++---------------------------
 3 files changed, 87 insertions(+), 122 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f16d42abc500..1992ed8a60b0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4305,28 +4305,21 @@ xfs_bmapi_write(
 		/* in hole or beyond EOF? */
 		if (eof || bma.got.br_startoff > bno) {
 			/*
-			 * CoW fork conversions should /never/ hit EOF or
-			 * holes.  There should always be something for us
-			 * to work on.
+			 * It is possible that the extents have changed since
+			 * we did the read call as we dropped the ilock for a
+			 * while.  We have to be careful about truncates or hole
+			 * punchs here - we are not allowed to allocate
+			 * non-delalloc blocks here.
+			 *
+			 * The only protection against truncation is the pages
+			 * for the range we are being asked to convert are
+			 * locked and hence a truncate will block on them
+			 * first.
 			 */
 			ASSERT(!((flags & XFS_BMAPI_CONVERT) &&
 			         (flags & XFS_BMAPI_COWFORK)));
 
 			if (flags & XFS_BMAPI_DELALLOC) {
-				/*
-				 * For the COW fork we can reasonably get a
-				 * request for converting an extent that races
-				 * with other threads already having converted
-				 * part of it, as there converting COW to
-				 * regular blocks is not protected using the
-				 * IOLOCK.
-				 */
-				ASSERT(flags & XFS_BMAPI_COWFORK);
-				if (!(flags & XFS_BMAPI_COWFORK)) {
-					error = -EIO;
-					goto error0;
-				}
-
 				if (eof || bno >= end)
 					break;
 			} else {
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5b6fab283316..124b8de37115 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -300,6 +300,7 @@ xfs_map_blocks(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	loff_t			isize = i_size_read(inode);
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
@@ -308,6 +309,15 @@ xfs_map_blocks(
 	struct xfs_iext_cursor	icur;
 	bool			imap_valid;
 	int			error = 0;
+	int			retries = 0;
+
+	/*
+	 * If the offset is beyong the inode size we know that we raced with
+	 * trunacte and are done now.  Note that we'll recheck this again
+	 * under the ilock later before doing delalloc conversions.
+	 */
+	if (offset > isize)
+		goto eof;
 
 	/*
 	 * We have to make sure the cached mapping is within EOF to protect
@@ -320,7 +330,7 @@ xfs_map_blocks(
 	 * mechanism to protect us from arbitrary extent modifying contexts, not
 	 * just eofblocks.
 	 */
-	xfs_trim_extent(&wpc->imap, 0, XFS_B_TO_FSB(mp, i_size_read(inode)));
+	xfs_trim_extent(&wpc->imap, 0, XFS_B_TO_FSB(mp, isize));
 
 	/*
 	 * COW fork blocks can overlap data fork blocks even if the blocks
@@ -354,6 +364,7 @@ xfs_map_blocks(
 	 * into real extents.  If we return without a valid map, it means we
 	 * landed in a hole and we skip the block.
 	 */
+retry:
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
@@ -370,26 +381,6 @@ xfs_map_blocks(
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 		wpc->fork = XFS_COW_FORK;
-
-		/*
-		 * Truncate can race with writeback since writeback doesn't
-		 * take the iolock and truncate decreases the file size before
-		 * it starts truncating the pages between new_size and old_size.
-		 * Therefore, we can end up in the situation where writeback
-		 * gets a CoW fork mapping but the truncate makes the mapping
-		 * invalid and we end up in here trying to get a new mapping.
-		 * bail out here so that we simply never get a valid mapping
-		 * and so we drop the write altogether.  The page truncation
-		 * will kill the contents anyway.
-		 */
-		if (offset > i_size_read(inode)) {
-			wpc->imap.br_blockcount = end_fsb - offset_fsb;
-			wpc->imap.br_startoff = offset_fsb;
-			wpc->imap.br_startblock = HOLESTARTBLOCK;
-			wpc->imap.br_state = XFS_EXT_NORM;
-			return 0;
-		}
-
 		goto allocate_blocks;
 	}
 
@@ -440,13 +431,39 @@ xfs_map_blocks(
 allocate_blocks:
 	error = xfs_iomap_write_allocate(ip, wpc->fork, offset, &imap,
 			&wpc->cow_seq);
-	if (error)
+	if (error) {
+		if (error == -EAGAIN)
+			goto truncate_race;
 		return error;
+	}
 	ASSERT(wpc->fork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
 	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
 	wpc->imap = imap;
 	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->fork, &imap);
 	return 0;
+
+truncate_race:
+	/*
+	 * If we failed to find the extent in the COW fork we might have raced
+	 * with a COW to data fork conversion or truncate.  Restart the lookup
+	 * to catch the extent in the data fork for the former case, but prevent
+	 * additional retries to avoid looping forever for the latter case.
+	 */
+	if (wpc->fork == XFS_COW_FORK && !retries++) {
+		imap_valid = false;
+		goto retry;
+	}
+eof:
+	/*
+	 * If we raced with truncate there might be no data left at this offset.
+	 * In that case we need to return a hole so that the writeback code
+	 * skips writeback for the rest of the file.
+	 */
+	wpc->imap.br_startoff = offset_fsb;
+	wpc->imap.br_blockcount = end_fsb - offset_fsb;
+	wpc->imap.br_startblock = HOLESTARTBLOCK;
+	wpc->imap.br_state = XFS_EXT_NORM;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 32a7c169e096..6acfed2ae858 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -685,14 +685,13 @@ xfs_iomap_write_allocate(
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_fileoff_t	offset_fsb, last_block;
+	xfs_fileoff_t	offset_fsb;
 	xfs_fileoff_t	end_fsb, map_start_fsb;
 	xfs_filblks_t	count_fsb;
 	xfs_trans_t	*tp;
 	int		nimaps;
 	int		error = 0;
 	int		flags = XFS_BMAPI_DELALLOC;
-	int		nres;
 
 	if (whichfork == XFS_COW_FORK)
 		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
@@ -712,95 +711,51 @@ xfs_iomap_write_allocate(
 
 	while (count_fsb != 0) {
 		/*
-		 * Set up a transaction with which to allocate the
-		 * backing store for the file.  Do allocations in a
-		 * loop until we get some space in the range we are
-		 * interested in.  The other space that might be allocated
-		 * is in the delayed allocation extent on which we sit
-		 * but before our buffer starts.
+		 * We have already reserved space for the extent and any
+		 * indirect blocks when creating the delalloc extent, there
+		 * is no need to reserve space in this transaction again.
 		 */
-		nimaps = 0;
-		while (nimaps == 0) {
-			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-			/*
-			 * We have already reserved space for the extent and any
-			 * indirect blocks when creating the delalloc extent,
-			 * there is no need to reserve space in this transaction
-			 * again.
-			 */
-			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0,
-					0, XFS_TRANS_RESERVE, &tp);
-			if (error)
-				return error;
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0,
+				0, XFS_TRANS_RESERVE, &tp);
+		if (error)
+			return error;
 
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip, 0);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-			/*
-			 * it is possible that the extents have changed since
-			 * we did the read call as we dropped the ilock for a
-			 * while. We have to be careful about truncates or hole
-			 * punchs here - we are not allowed to allocate
-			 * non-delalloc blocks here.
-			 *
-			 * The only protection against truncation is the pages
-			 * for the range we are being asked to convert are
-			 * locked and hence a truncate will block on them
-			 * first.
-			 *
-			 * As a result, if we go beyond the range we really
-			 * need and hit an delalloc extent boundary followed by
-			 * a hole while we have excess blocks in the map, we
-			 * will fill the hole incorrectly and overrun the
-			 * transaction reservation.
-			 *
-			 * Using a single map prevents this as we are forced to
-			 * check each map we look for overlap with the desired
-			 * range and abort as soon as we find it. Also, given
-			 * that we only return a single map, having one beyond
-			 * what we can return is probably a bit silly.
-			 *
-			 * We also need to check that we don't go beyond EOF;
-			 * this is a truncate optimisation as a truncate sets
-			 * the new file size before block on the pages we
-			 * currently have locked under writeback. Because they
-			 * are about to be tossed, we don't need to write them
-			 * back....
-			 */
-			nimaps = 1;
-			end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
-			error = xfs_bmap_last_offset(ip, &last_block,
-							XFS_DATA_FORK);
-			if (error)
+		/*
+		 * We need to check that we don't go beyond EOF; this is a
+		 * truncate optimisation as a truncate sets the new file size
+		 * before block on the pages we currently have locked under
+		 * writeback.  Because they are about to be tossed, we don't
+		 * need to write them back....
+		 */
+		end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
+		if (map_start_fsb + count_fsb > end_fsb) {
+			count_fsb = end_fsb - map_start_fsb;
+			if (count_fsb == 0) {
+				error = -EAGAIN;
 				goto trans_cancel;
-
-			last_block = XFS_FILEOFF_MAX(last_block, end_fsb);
-			if ((map_start_fsb + count_fsb) > last_block) {
-				count_fsb = last_block - map_start_fsb;
-				if (count_fsb == 0) {
-					error = -EAGAIN;
-					goto trans_cancel;
-				}
 			}
+		}
 
-			/*
-			 * From this point onwards we overwrite the imap
-			 * pointer that the caller gave to us.
-			 */
-			error = xfs_bmapi_write(tp, ip, map_start_fsb,
-						count_fsb, flags, nres, imap,
-						&nimaps);
-			if (error)
-				goto trans_cancel;
+		nimaps = 1;
+		xfs_trans_ijoin(tp, ip, 0);
+		error = xfs_bmapi_write(tp, ip, map_start_fsb, count_fsb, flags,
+				XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
+				imap, &nimaps);
+		if (error)
+			goto trans_cancel;
 
-			error = xfs_trans_commit(tp);
-			if (error)
-				goto error0;
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto error0;
 
-			if (whichfork == XFS_COW_FORK)
-				*cow_seq = READ_ONCE(ifp->if_seq);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
+		if (whichfork == XFS_COW_FORK)
+			*cow_seq = READ_ONCE(ifp->if_seq);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		if (nimaps == 0)
+			return -EAGAIN;
 
 		/*
 		 * See if we were able to allocate an extent that
-- 
2.19.1
