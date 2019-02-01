Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfBAOdA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 09:33:00 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 626A5394D34
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 14:32:59 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AE815D9D1
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 14:32:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 6/6] xfs: use the latest extent at writeback delalloc conversion time
Date: Fri,  1 Feb 2019 09:32:56 -0500
Message-Id: <20190201143256.43232-7-bfoster@redhat.com>
In-Reply-To: <20190201143256.43232-1-bfoster@redhat.com>
References: <20190201143256.43232-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The writeback delalloc conversion code is racy with respect to
changes in the currently cached file mapping outside of the current
page. This is because the ilock is cycled between the time the
caller originally looked up the mapping and across each real
allocation of the provided file range. This code has collected
various hacks over the years to help combat the symptoms of these
races (i.e., truncate race detection, allocation into hole
detection, etc.), but none address the fundamental problem that the
imap may not be valid at allocation time.

Rather than continue to use race detection hacks, update writeback
delalloc conversion to a model that explicitly converts the delalloc
extent backing the current file offset being processed. The current
file offset is the only block we can trust to remain once the ilock
is dropped because any operation that can remove the block
(truncate, hole punch, etc.) must flush and discard pagecache pages
first.

Modify xfs_iomap_write_allocate() to use the xfs_bmapi_delalloc()
mechanism to request allocation of the entire delalloc extent
backing the current offset instead of assuming the extent passed by
the caller is unchanged. Record the range specified by the caller
and apply it to the resulting allocated extent so previous checks by
the caller for COW fork overlap are not lost. Finally, overload the
bmapi delalloc flag with the range reval flag behavior since this is
the only use case for both.

This ensures that writeback always picks up the correct
and current extent associated with the page, regardless of races
with other extent modifying operations. If operating on a data fork
and the COW overlap state has changed since the ilock was cycled,
the caller revalidates against the COW fork sequence number before
using the imap for the next block.

[hch: Call updated delalloc conversion helper.]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |  16 ++--
 fs/xfs/libxfs/xfs_bmap.h |   2 -
 fs/xfs/xfs_iomap.c       | 170 +++++++++++++--------------------------
 3 files changed, 64 insertions(+), 124 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c629004d9a4c..f4a65330a2a9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4296,15 +4296,14 @@ xfs_bmapi_write(
 	bma.datatype = 0;
 
 	/*
-	 * The reval flag means the caller wants to allocate the entire delalloc
-	 * extent backing bno where bno may not necessarily match the startoff.
-	 * Now that we've looked up the extent, reset the range to map based on
-	 * the extent in the file. If we're in a hole, this may be an error so
-	 * don't adjust anything.
+	 * The delalloc flag means the caller wants to allocate the entire
+	 * delalloc extent backing bno where bno may not necessarily match the
+	 * startoff. Now that we've looked up the extent, reset the range to
+	 * map based on the extent in the file. If we're in a hole, this may be
+	 * an error so don't adjust anything.
 	 */
-	if ((flags & XFS_BMAPI_REVALRANGE) &&
+	if ((flags & XFS_BMAPI_DELALLOC) &&
 	    !eof && bno >= bma.got.br_startoff) {
-		ASSERT(flags & XFS_BMAPI_DELALLOC);
 		bno = bma.got.br_startoff;
 		len = bma.got.br_blockcount;
 #ifdef DEBUG
@@ -4495,10 +4494,9 @@ xfs_bmapi_convert_delalloc(
 		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
 
 	/*
-	 * The reval flag means to allocate the entire extent; pass a dummy
+	 * The delalloc flag means to allocate the entire extent; pass a dummy
 	 * length of 1.
 	 */
-	flags |= XFS_BMAPI_REVALRANGE;
 	error = xfs_bmapi_write(tp, ip, offset_fsb, 1, flags, total, imap,
 				&nimaps);
 	if (!error && !nimaps)
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 75586d56f7a5..4dc7d1a02b35 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -107,8 +107,6 @@ struct xfs_extent_free_item
 /* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
 #define XFS_BMAPI_NORMAP	0x2000
 
-#define XFS_BMAPI_REVALRANGE	0x4000
-
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ab69caa685b4..6af1d3ec0a9c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -677,25 +677,19 @@ xfs_file_iomap_begin_delay(
  */
 int
 xfs_iomap_write_allocate(
-	xfs_inode_t	*ip,
-	int		whichfork,
-	xfs_off_t	offset,
-	xfs_bmbt_irec_t *imap,
-	unsigned int	*seq)
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_off_t		offset,
+	struct xfs_bmbt_irec	*imap,
+	unsigned int		*seq)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_fileoff_t	offset_fsb, last_block;
-	xfs_fileoff_t	end_fsb, map_start_fsb;
-	xfs_filblks_t	count_fsb;
-	xfs_trans_t	*tp;
-	int		nimaps;
-	int		error = 0;
-	int		flags = XFS_BMAPI_DELALLOC;
-	int		nres;
-
-	if (whichfork == XFS_COW_FORK)
-		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	xfs_fileoff_t		offset_fsb;
+	xfs_fileoff_t		map_start_fsb;
+	xfs_extlen_t		map_count_fsb;
+	struct xfs_trans	*tp;
+	int			error = 0;
 
 	/*
 	 * Make sure that the dquots are there.
@@ -704,106 +698,60 @@ xfs_iomap_write_allocate(
 	if (error)
 		return error;
 
+	/*
+	 * Store the file range the caller is interested in because it encodes
+	 * state such as potential overlap with COW fork blocks. We must trim
+	 * the allocated extent down to this range to maintain consistency with
+	 * what the caller expects. Revalidation of the range itself is the
+	 * responsibility of the caller.
+	 */
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	count_fsb = imap->br_blockcount;
 	map_start_fsb = imap->br_startoff;
+	map_count_fsb = imap->br_blockcount;
 
-	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, count_fsb));
+	XFS_STATS_ADD(mp, xs_xstrat_bytes,
+		      XFS_FSB_TO_B(mp, imap->br_blockcount));
 
-	while (count_fsb != 0) {
+	while (true) {
 		/*
-		 * Set up a transaction with which to allocate the
-		 * backing store for the file.  Do allocations in a
-		 * loop until we get some space in the range we are
-		 * interested in.  The other space that might be allocated
-		 * is in the delayed allocation extent on which we sit
-		 * but before our buffer starts.
+		 * Allocate in a loop because it may take several attempts to
+		 * allocate real blocks for a contiguous delalloc extent if free
+		 * space is sufficiently fragmented. Note that space for the
+		 * extent and indirect blocks was reserved when the delalloc
+		 * extent was created so there's no need to do so here.
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
-
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip, 0);
-
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
-				goto trans_cancel;
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
+					XFS_TRANS_RESERVE, &tp);
+		if (error)
+			return error;
 
-			last_block = XFS_FILEOFF_MAX(last_block, end_fsb);
-			if ((map_start_fsb + count_fsb) > last_block) {
-				count_fsb = last_block - map_start_fsb;
-				if (count_fsb == 0) {
-					error = -EAGAIN;
-					goto trans_cancel;
-				}
-			}
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, 0);
 
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
+		 * ilock was dropped since imap was populated which means it
+		 * might no longer be valid. The current page is held locked so
+		 * nothing could have removed the block backing offset_fsb.
+		 * Attempt to allocate whatever delalloc extent currently backs
+		 * offset_fsb and put the result in the imap pointer from the
+		 * caller. We'll trim it down to the caller's most recently
+		 * validated range before we return.
+		 */
+		error = xfs_bmapi_convert_delalloc(tp, ip, offset_fsb,
+						   whichfork, imap);
+		if (error)
+			goto trans_cancel;
 
-			error = xfs_trans_commit(tp);
-			if (error)
-				goto error0;
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto error0;
 
-			*seq = READ_ONCE(ifp->if_seq);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
+		*seq = READ_ONCE(ifp->if_seq);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 		/*
-		 * See if we were able to allocate an extent that
-		 * covers at least part of the callers request
+		 * See if we were able to allocate an extent that covers at
+		 * least part of the callers request.
 		 */
 		if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
 			return xfs_alert_fsblock_zero(ip, imap);
@@ -812,15 +760,11 @@ xfs_iomap_write_allocate(
 		    (offset_fsb < (imap->br_startoff +
 				   imap->br_blockcount))) {
 			XFS_STATS_INC(mp, xs_xstrat_quick);
+			xfs_trim_extent(imap, map_start_fsb, map_count_fsb);
+			ASSERT(offset_fsb >= imap->br_startoff &&
+			       offset_fsb < imap->br_startoff + imap->br_blockcount);
 			return 0;
 		}
-
-		/*
-		 * So far we have not mapped the requested part of the
-		 * file, just surrounding data, try again.
-		 */
-		count_fsb -= imap->br_blockcount;
-		map_start_fsb = imap->br_startoff + imap->br_blockcount;
 	}
 
 trans_cancel:
-- 
2.17.2
