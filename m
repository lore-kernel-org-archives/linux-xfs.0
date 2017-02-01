Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44807 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdBAVm6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 16:42:58 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cZ2g5-000473-3Y
        for linux-xfs@vger.kernel.org; Wed, 01 Feb 2017 21:42:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] xfs: allocate direct I/O COW blocks in iomap_begin
Date: Wed,  1 Feb 2017 22:42:39 +0100
Message-Id: <1485985359-971-5-git-send-email-hch@lst.de>
In-Reply-To: <1485985359-971-1-git-send-email-hch@lst.de>
References: <1485985359-971-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Instead of preallocating all the required COW blocks in the high-level
write code do it inside the iomap code, like we do for all other I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c    |   8 ---
 fs/xfs/xfs_iomap.c   |  31 +++++------
 fs/xfs/xfs_reflink.c | 147 ++++++++++++++++++++-------------------------------
 fs/xfs/xfs_reflink.h |   5 +-
 fs/xfs/xfs_trace.h   |   2 -
 5 files changed, 71 insertions(+), 122 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 06236bf..56ac5b7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -559,14 +559,6 @@ xfs_file_dio_aio_write(
 	}
 
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
-
-	/* If this is a block-aligned directio CoW, remap immediately. */
-	if (xfs_is_reflink_inode(ip) && !unaligned_io) {
-		ret = xfs_reflink_allocate_cow_range(ip, iocb->ki_pos, count);
-		if (ret)
-			goto out;
-	}
-
 	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
 out:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9d811eb..de717e7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -995,37 +995,31 @@ xfs_file_iomap_begin(
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
-	if (xfs_is_reflink_inode(ip) &&
-	    (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT)) {
-		shared = xfs_reflink_find_cow_mapping(ip, offset, &imap);
-		if (shared) {
-			xfs_iunlock(ip, lockmode);
-			goto alloc_done;
-		}
-		ASSERT(!isnullstartblock(imap.br_startblock));
-	}
-
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, 0);
 	if (error)
 		goto out_unlock;
 
-	if ((flags & IOMAP_REPORT) ||
-	    (xfs_is_reflink_inode(ip) &&
-	     (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT))) {
+	if (flags & IOMAP_REPORT) {
 		/* Trim the mapping to the nearest shared extent boundary. */
 		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
 				&trimmed);
 		if (error)
 			goto out_unlock;
-
-		ASSERT((flags & IOMAP_REPORT) || !shared);
 	}
 
 	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
-		error = xfs_reflink_reserve_cow(ip, &imap, &shared);
-		if (error)
-			goto out_unlock;
+		if (flags & IOMAP_DIRECT) {
+			/* may drop and re-acquire the ilock */
+			error = xfs_reflink_allocate_cow(ip, offset_fsb, end_fsb,
+					&imap, &shared, &lockmode);
+			if (error)
+				goto out_unlock;
+		} else {
+			error = xfs_reflink_reserve_cow(ip, &imap, &shared);
+			if (error)
+				goto out_unlock;
+		}
 
 		end_fsb = imap.br_startoff + imap.br_blockcount;
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
@@ -1054,7 +1048,6 @@ xfs_file_iomap_begin(
 		if (error)
 			return error;
 
-alloc_done:
 		iomap->flags = IOMAP_F_NEW;
 		trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
 	} else {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1a96741..d5a2cf2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -384,74 +384,84 @@ xfs_reflink_convert_cow(
 }
 
 /* Allocate all CoW reservations covering a range of blocks in a file. */
-static int
-__xfs_reflink_allocate_cow(
+int
+xfs_reflink_allocate_cow(
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		*offset_fsb,
-	xfs_fileoff_t		end_fsb)
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		end_fsb,
+	struct xfs_bmbt_irec	*imap,
+	bool			*shared,
+	uint			*lockmode)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	imap, got;
+	struct xfs_bmbt_irec	got;
 	struct xfs_defer_ops	dfops;
-	struct xfs_trans	*tp;
+	struct xfs_trans	*tp = NULL;
 	xfs_fsblock_t		first_block;
-	int			nimaps, error, lockmode;
-	bool			shared, trimmed;
+	int			nimaps, error = 0;
+	bool			trimmed;
 	xfs_filblks_t		resaligned;
-	xfs_extlen_t		resblks;
+	xfs_extlen_t		resblks = 0;
 	xfs_extnum_t		idx;
 
-	resaligned = xfs_aligned_fsb_count(*offset_fsb, end_fsb - *offset_fsb,
-			xfs_get_cowextsz_hint(ip));
-	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
-	if (error)
-		return error;
-
-	lockmode = XFS_ILOCK_EXCL;
-	xfs_ilock(ip, lockmode);
+retry:
+	ASSERT(xfs_is_reflink_inode(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	/*
 	 * Even if the extent is not shared we might have a preallocation for
 	 * it in the COW fork.  If so use it.
 	 */
-	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, *offset_fsb, &idx, &got) &&
-	    got.br_startoff <= *offset_fsb) {
+	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &idx, &got) &&
+	    got.br_startoff <= offset_fsb) {
+		*shared = true;
+
 		/* If we have a real allocation in the COW fork we're done. */
 		if (!isnullstartblock(got.br_startblock)) {
-			xfs_trim_extent(&got, *offset_fsb,
-					end_fsb - *offset_fsb);
-			*offset_fsb = got.br_startoff + got.br_blockcount;
-			goto out_trans_cancel;
+			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
+			*imap = got;
+			goto out;
 		}
+
+		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
 	} else {
-		nimaps = 1;
-		error = xfs_bmapi_read(ip, *offset_fsb, end_fsb - *offset_fsb,
-				&imap, &nimaps, 0);
+		error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
+		if (error || !*shared)
+			goto out;
+	}
+
+	if (!tp) {
+		resaligned = xfs_aligned_fsb_count(offset_fsb,
+			end_fsb - offset_fsb, xfs_get_cowextsz_hint(ip));
+		resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+
+		xfs_iunlock(ip, *lockmode);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+		*lockmode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, *lockmode);
+
 		if (error)
-			goto out_trans_cancel;
-		ASSERT(nimaps == 1);
+			return error;
 
-		/* Trim the mapping to the nearest shared extent boundary. */
-		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
-				&trimmed);
+		error = xfs_qm_dqattach_locked(ip, 0);
 		if (error)
-			goto out_trans_cancel;
+			goto out;
 
-		if (!shared) {
-			*offset_fsb = imap.br_startoff + imap.br_blockcount;
-			goto out_trans_cancel;
-		}
+		/* Read extent from the source file. */
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				imap, &nimaps, 0);
+		if (error)
+			goto out;
+		ASSERT(nimaps == 1);
 
-		*offset_fsb = imap.br_startoff;
-		end_fsb = imap.br_startoff + imap.br_blockcount;
+		goto retry;
 	}
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
 			XFS_QMOPT_RES_REGBLKS);
 	if (error)
-		goto out_trans_cancel;
+		goto out;
 
 	xfs_trans_ijoin(tp, ip, 0);
 
@@ -459,9 +469,9 @@ __xfs_reflink_allocate_cow(
 	nimaps = 1;
 
 	/* Allocate the entire reservation as unwritten blocks. */
-	error = xfs_bmapi_write(tp, ip, *offset_fsb, end_fsb - *offset_fsb,
+	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, &first_block,
-			resblks, &imap, &nimaps, &dfops);
+			resblks, imap, &nimaps, &dfops);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -470,60 +480,15 @@ __xfs_reflink_allocate_cow(
 	if (error)
 		goto out_bmap_cancel;
 
-	error = xfs_trans_commit(tp);
-	if (error)
-		goto out_unlock;
-
-	*offset_fsb = imap.br_startoff + imap.br_blockcount;
-
-out_unlock:
-	xfs_iunlock(ip, lockmode);
-	return error;
+	return xfs_trans_commit(tp);
 
 out_bmap_cancel:
 	xfs_defer_cancel(&dfops);
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
 			XFS_QMOPT_RES_REGBLKS);
-out_trans_cancel:
-	xfs_trans_cancel(tp);
-	goto out_unlock;
-}
-
-/* Allocate all CoW reservations covering a part of a file. */
-int
-xfs_reflink_allocate_cow_range(
-	struct xfs_inode	*ip,
-	xfs_off_t		offset,
-	xfs_off_t		count)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
-	int			error;
-
-	ASSERT(xfs_is_reflink_inode(ip));
-
-	trace_xfs_reflink_allocate_cow_range(ip, offset, count);
-
-	/*
-	 * Make sure that the dquots are there.
-	 */
-	error = xfs_qm_dqattach(ip, 0);
-	if (error)
-		return error;
-
-	while (offset_fsb < end_fsb) {
-		error = __xfs_reflink_allocate_cow(ip, &offset_fsb, end_fsb);
-		if (error) {
-			trace_xfs_reflink_allocate_cow_range_error(ip, error,
-					_RET_IP_);
-			goto out;
-		}
-	}
-
-	/* Convert the CoW extents to regular. */
-	error = xfs_reflink_convert_cow(ip, offset, count);
 out:
+	if (tp)
+		xfs_trans_cancel(tp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 1583c47..08792a4 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -28,8 +28,9 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 
 extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap, bool *shared);
-extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
-		xfs_off_t offset, xfs_off_t count);
+extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
+		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb,
+		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode);
 extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d3d11905..5f0a0d6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3248,7 +3248,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 
 DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
-DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
 
 DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
 DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
@@ -3258,7 +3257,6 @@ DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
 
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_allocate_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
 
-- 
2.1.4

