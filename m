Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49892 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752977AbcJOIxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2016 04:53:35 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/9] xfs: optimize xfs_reflink_end_cow
Date: Sat, 15 Oct 2016 10:52:33 +0200
Message-Id: <1476521554-1894-9-git-send-email-hch@lst.de>
In-Reply-To: <1476521554-1894-1-git-send-email-hch@lst.de>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, bfoster@redhat.com

Instead of doing a full extent list search for each extent that is to be
deleted using xfs_bmapi_read and then doing another one inside of
xfs_bunmapi_cow use the same scheme that xfs_bumapi uses:  look up the
last extent to be deleted and then use the extent index to walk downward
until we are outside the range to be deleted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 119 ++++++++++++++++++++++++---------------------------
 fs/xfs/xfs_trace.h   |   1 -
 2 files changed, 56 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7979d46..93a863e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -634,25 +634,26 @@ xfs_reflink_end_cow(
 	xfs_off_t			offset,
 	xfs_off_t			count)
 {
-	struct xfs_bmbt_irec		irec;
-	struct xfs_bmbt_irec		uirec;
+	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_bmbt_irec		got, prev, del;
 	struct xfs_trans		*tp;
 	xfs_fileoff_t			offset_fsb;
 	xfs_fileoff_t			end_fsb;
-	xfs_filblks_t			count_fsb;
 	xfs_fsblock_t			firstfsb;
 	struct xfs_defer_ops		dfops;
-	int				error;
+	int				error, eof = 0;
 	unsigned int			resblks;
-	xfs_filblks_t			ilen;
 	xfs_filblks_t			rlen;
-	int				nimaps;
+	xfs_extnum_t			idx;
 
 	trace_xfs_reflink_end_cow(ip, offset, count);
 
+	/* No COW extents?  That's easy! */
+	if (ifp->if_bytes == 0)
+		return 0;
+
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
-	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
 
 	/* Start a rolling transaction to switch the mappings */
 	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
@@ -664,72 +665,65 @@ xfs_reflink_end_cow(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	/* Go find the old extent in the CoW fork. */
-	while (offset_fsb < end_fsb) {
-		/* Read extent from the source file */
-		nimaps = 1;
-		count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
-		error = xfs_bmapi_read(ip, offset_fsb, count_fsb, &irec,
-				&nimaps, XFS_BMAPI_COWFORK);
-		if (error)
-			goto out_cancel;
-		ASSERT(nimaps == 1);
+	xfs_bmap_search_extents(ip, end_fsb - 1, XFS_COW_FORK, &eof, &idx,
+			&got, &prev);
 
-		ASSERT(irec.br_startblock != DELAYSTARTBLOCK);
-		trace_xfs_reflink_cow_remap(ip, &irec);
+	/* If there is a hole at end_fsb - 1 go to the previous extent */
+	if (eof || got.br_startoff > end_fsb) {
+		ASSERT(idx > 0);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, --idx), &got);
+	}
 
-		/*
-		 * We can have a hole in the CoW fork if part of a directio
-		 * write is CoW but part of it isn't.
-		 */
-		rlen = ilen = irec.br_blockcount;
-		if (irec.br_startblock == HOLESTARTBLOCK)
+	/* Walk backwards until we're out of the I/O range... */
+	while (got.br_startoff + got.br_blockcount > offset_fsb) {
+		del = got;
+		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
+
+		/* Extent delete may have bumped idx forward */
+		if (!del.br_blockcount) {
+			idx--;
 			goto next_extent;
+		}
+
+		ASSERT(!isnullstartblock(got.br_startblock));
 
 		/* Unmap the old blocks in the data fork. */
-		while (rlen) {
-			xfs_defer_init(&dfops, &firstfsb);
-			error = __xfs_bunmapi(tp, ip, irec.br_startoff,
-					&rlen, 0, 1, &firstfsb, &dfops);
-			if (error)
-				goto out_defer;
-
-			/*
-			 * Trim the extent to whatever got unmapped.
-			 * Remember, bunmapi works backwards.
-			 */
-			uirec.br_startblock = irec.br_startblock + rlen;
-			uirec.br_startoff = irec.br_startoff + rlen;
-			uirec.br_blockcount = irec.br_blockcount - rlen;
-			irec.br_blockcount = rlen;
-			trace_xfs_reflink_cow_remap_piece(ip, &uirec);
+		xfs_defer_init(&dfops, &firstfsb);
+		rlen = del.br_blockcount;
+		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1,
+				&firstfsb, &dfops);
+		if (error)
+			goto out_defer;
 
-			/* Free the CoW orphan record. */
-			error = xfs_refcount_free_cow_extent(tp->t_mountp,
-					&dfops, uirec.br_startblock,
-					uirec.br_blockcount);
-			if (error)
-				goto out_defer;
+		/* Trim the extent to whatever got unmapped. */
+		if (rlen) {
+			xfs_trim_extent(&del, del.br_startoff + rlen,
+				del.br_blockcount - rlen);
+		}
+		trace_xfs_reflink_cow_remap(ip, &del);
 
-			/* Map the new blocks into the data fork. */
-			error = xfs_bmap_map_extent(tp->t_mountp, &dfops,
-					ip, &uirec);
-			if (error)
-				goto out_defer;
+		/* Free the CoW orphan record. */
+		error = xfs_refcount_free_cow_extent(tp->t_mountp, &dfops,
+				del.br_startblock, del.br_blockcount);
+		if (error)
+			goto out_defer;
 
-			/* Remove the mapping from the CoW fork. */
-			error = xfs_bunmapi_cow(ip, &uirec);
-			if (error)
-				goto out_defer;
+		/* Map the new blocks into the data fork. */
+		error = xfs_bmap_map_extent(tp->t_mountp, &dfops, ip, &del);
+		if (error)
+			goto out_defer;
 
-			error = xfs_defer_finish(&tp, &dfops, ip);
-			if (error)
-				goto out_defer;
-		}
+		/* Remove the mapping from the CoW fork. */
+		xfs_bmap_del_extent_cow(ip, &idx, &got, &del);
+
+		error = xfs_defer_finish(&tp, &dfops, ip);
+		if (error)
+			goto out_defer;
 
 next_extent:
-		/* Roll on... */
-		offset_fsb = irec.br_startoff + ilen;
+		if (idx < 0)
+			break;
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
 	}
 
 	error = xfs_trans_commit(tp);
@@ -740,7 +734,6 @@ xfs_reflink_end_cow(
 
 out_defer:
 	xfs_defer_cancel(&dfops);
-out_cancel:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 72f9f6b..0907752 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3356,7 +3356,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
-DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_piece);
 
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_allocate_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
-- 
2.1.4

