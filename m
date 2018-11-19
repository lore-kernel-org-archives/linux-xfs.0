Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33088 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbeKTAKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Nov 2018 19:10:11 -0500
Received: from 089144201193.atnat0010.highway.a1.net ([89.144.201.193] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gOjsk-0004td-LK
        for linux-xfs@vger.kernel.org; Mon, 19 Nov 2018 13:46:31 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] xfs: avoid an extent tree lookup in xfs_iomap_write_allocate
Date: Mon, 19 Nov 2018 14:46:13 +0100
Message-Id: <20181119134619.16812-4-hch@lst.de>
In-Reply-To: <20181119134619.16812-1-hch@lst.de>
References: <20181119134619.16812-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Instead of checking for the offset of the last extent to reduce the
size passed into xfs_bmapi_write reuse the existing code to deal with
that case for the COW fork in xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |  27 +++------
 fs/xfs/xfs_iomap.c       | 127 ++++++++++++++-------------------------
 2 files changed, 55 insertions(+), 99 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 74d7228e755b..ec48652e6325 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4313,28 +4313,21 @@ xfs_bmapi_write(
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
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 27c93b5f029d..c45fe427be4a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -685,7 +685,7 @@ xfs_iomap_write_allocate(
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_fileoff_t	offset_fsb, last_block;
+	xfs_fileoff_t	offset_fsb;
 	xfs_fileoff_t	end_fsb, map_start_fsb;
 	xfs_filblks_t	count_fsb;
 	xfs_trans_t	*tp;
@@ -711,96 +711,59 @@ xfs_iomap_write_allocate(
 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, count_fsb));
 
 	while (count_fsb != 0) {
+		nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 		/*
-		 * Set up a transaction with which to allocate the
-		 * backing store for the file.  Do allocations in a
-		 * loop until we get some space in the range we are
-		 * interested in.  The other space that might be allocated
-		 * is in the delayed allocation extent on which we sit
-		 * but before our buffer starts.
+		 * We have already reserved space for the extent and any
+		 * indirect blocks when creating the delalloc extent,
+		 * there is no need to reserve space in this transaction
+		 * again.
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
+		xfs_trans_ijoin(tp, ip, 0);
 
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
+		 * We also need to check that we don't go beyond EOF;
+		 * this is a truncate optimisation as a truncate sets
+		 * the new file size before block on the pages we
+		 * currently have locked under writeback. Because they
+		 * are about to be tossed, we don't need to write them
+		 * back....
+		 */
+		nimaps = 1;
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
+		/*
+		 * From this point onwards we overwrite the imap
+		 * pointer that the caller gave to us.
+		 */
+		error = xfs_bmapi_write(tp, ip, map_start_fsb,
+					count_fsb, flags, nres, imap,
+					&nimaps);
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
+		if (nimaps == 0 || imap->br_startblock == HOLESTARTBLOCK)
+			return -EAGAIN;
 
 		/*
 		 * See if we were able to allocate an extent that
-- 
2.19.1
