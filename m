Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D41C7CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 16:51:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5331304032
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LafEcu8ggDRaAQlm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:26 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bbaeL-0002Tf-P1
	for xfs@oss.sgi.com; Sun, 21 Aug 2016 21:51:26 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] xfs: rewrite and optimize the delalloc write path
Date: Sun, 21 Aug 2016 23:51:13 +0200
Message-Id: <1471816273-28940-5-git-send-email-hch@lst.de>
In-Reply-To: <1471816273-28940-1-git-send-email-hch@lst.de>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently xfs_iomap_write_delay does up to lookups in the inode extent
tree, which is rather costly especially with the new iomap based
write path and small write sizes.

But it turns out that the low-level xfs_bmap_search_extents gives us all
the information we need in the regular delalloc buffered write path:

 - it will return us an extent covering the block we are looking up if
   it exists.  In that case we can simply return that extent to the
   caller and are done
 - it will tell us if we are beyoned the last current allocated block
   with an eof return parameter.  In that case we can create a delalloc
   reservation and use the also returned information about the last
   extent in the file as the hint to size our delalloc reservation.
 - it can tell us that we are writing into a hole, but that there is
   an extent beyoned this hole.  In this case we can create a delalloc
   reservation that covers the requested size (possible capped to the
   next existing allocation).

All that can be done in one single routine instead of bouncing up
and down a few layers.  This reduced the CPU overhead of the block
mapping routines and also simplified the code a lot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |  89 +----------
 fs/xfs/libxfs/xfs_bmap.h |  10 +-
 fs/xfs/xfs_iomap.c       | 381 ++++++++++++++++++++---------------------------
 fs/xfs/xfs_iomap.h       |   2 -
 4 files changed, 169 insertions(+), 313 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b060bca..614803b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1388,7 +1388,7 @@ xfs_bmap_search_multi_extents(
  * Else, *lastxp will be set to the index of the found
  * entry; *gotp will contain the entry.
  */
-STATIC xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
+xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
 xfs_bmap_search_extents(
 	xfs_inode_t     *ip,            /* incore inode pointer */
 	xfs_fileoff_t   bno,            /* block number searched for */
@@ -4074,7 +4074,7 @@ xfs_bmapi_read(
 	return 0;
 }
 
-STATIC int
+int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		aoff,
@@ -4170,91 +4170,6 @@ out_unreserve_quota:
 	return error;
 }
 
-/*
- * Map file blocks to filesystem blocks, adding delayed allocations as needed.
- */
-int
-xfs_bmapi_delay(
-	struct xfs_inode	*ip,	/* incore inode */
-	xfs_fileoff_t		bno,	/* starting file offs. mapped */
-	xfs_filblks_t		len,	/* length to map in file */
-	struct xfs_bmbt_irec	*mval,	/* output: map values */
-	int			*nmap,	/* i/o: mval size/count */
-	int			flags)	/* XFS_BMAPI_... */
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	struct xfs_bmbt_irec	got;	/* current file extent record */
-	struct xfs_bmbt_irec	prev;	/* previous file extent record */
-	xfs_fileoff_t		obno;	/* old block number (offset) */
-	xfs_fileoff_t		end;	/* end of mapped file region */
-	xfs_extnum_t		lastx;	/* last useful extent number */
-	int			eof;	/* we've hit the end of extents */
-	int			n = 0;	/* current extent index */
-	int			error = 0;
-
-	ASSERT(*nmap >= 1);
-	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
-	ASSERT(!(flags & ~XFS_BMAPI_ENTIRE));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmapi_delay", XFS_ERRLEVEL_LOW, mp);
-		return -EFSCORRUPTED;
-	}
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	XFS_STATS_INC(mp, xs_blk_mapw);
-
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
-		if (error)
-			return error;
-	}
-
-	xfs_bmap_search_extents(ip, bno, XFS_DATA_FORK, &eof, &lastx, &got, &prev);
-	end = bno + len;
-	obno = bno;
-
-	while (bno < end && n < *nmap) {
-		if (eof || got.br_startoff > bno) {
-			error = xfs_bmapi_reserve_delalloc(ip, bno, len, &got,
-							   &prev, &lastx, eof);
-			if (error) {
-				if (n == 0) {
-					*nmap = 0;
-					return error;
-				}
-				break;
-			}
-		}
-
-		/* set up the extent map to return. */
-		xfs_bmapi_trim_map(mval, &got, &bno, len, obno, end, n, flags);
-		xfs_bmapi_update_map(&mval, &bno, &len, obno, end, &n, flags);
-
-		/* If we're done, stop now. */
-		if (bno >= end || n >= *nmap)
-			break;
-
-		/* Else go on to the next record. */
-		prev = got;
-		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
-		else
-			eof = 1;
-	}
-
-	*nmap = n;
-	return 0;
-}
-
-
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 254034f..d660069 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -181,9 +181,6 @@ int	xfs_bmap_read_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
-int	xfs_bmapi_delay(struct xfs_inode *ip, xfs_fileoff_t bno,
-		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
-		int *nmap, int flags);
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_fsblock_t *firstblock, xfs_extlen_t total,
@@ -202,5 +199,12 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_defer_ops *dfops, enum shift_direction direction,
 		int num_exts);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
+struct xfs_bmbt_rec_host *
+	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
+		int fork, int *eofp, xfs_extnum_t *lastxp,
+		struct xfs_bmbt_irec *gotp, struct xfs_bmbt_irec *prevp);
+int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, xfs_fileoff_t aoff,
+		xfs_filblks_t len, struct xfs_bmbt_irec *got,
+		struct xfs_bmbt_irec *prev, xfs_extnum_t *lastx, int eof);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 918511a..2b449f5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2016 Christoph Hellwig.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -42,7 +43,6 @@
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
 						<< mp->m_writeio_log)
-#define XFS_WRITE_IMAPS		XFS_BMAP_MAX_NMAP
 
 void
 xfs_bmbt_to_iomap(
@@ -311,130 +311,6 @@ out_trans_cancel:
 	goto out_unlock;
 }
 
-/*
- * If the caller is doing a write at the end of the file, then extend the
- * allocation out to the file system's write iosize.  We clean up any extra
- * space left over when the file is closed in xfs_inactive().
- *
- * If we find we already have delalloc preallocation beyond EOF, don't do more
- * preallocation as it it not needed.
- */
-STATIC int
-xfs_iomap_eof_want_preallocate(
-	xfs_mount_t	*mp,
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	size_t		count,
-	xfs_bmbt_irec_t *imap,
-	int		nimaps,
-	int		*prealloc)
-{
-	xfs_fileoff_t   start_fsb;
-	xfs_filblks_t   count_fsb;
-	int		n, error, imaps;
-	int		found_delalloc = 0;
-
-	*prealloc = 0;
-	if (offset + count <= XFS_ISIZE(ip))
-		return 0;
-
-	/*
-	 * If the file is smaller than the minimum prealloc and we are using
-	 * dynamic preallocation, don't do any preallocation at all as it is
-	 * likely this is the only write to the file that is going to be done.
-	 */
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
-	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_writeio_blocks))
-		return 0;
-
-	/*
-	 * If there are any real blocks past eof, then don't
-	 * do any speculative allocation.
-	 */
-	start_fsb = XFS_B_TO_FSBT(mp, ((xfs_ufsize_t)(offset + count - 1)));
-	count_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	while (count_fsb > 0) {
-		imaps = nimaps;
-		error = xfs_bmapi_read(ip, start_fsb, count_fsb, imap, &imaps,
-				       0);
-		if (error)
-			return error;
-		for (n = 0; n < imaps; n++) {
-			if ((imap[n].br_startblock != HOLESTARTBLOCK) &&
-			    (imap[n].br_startblock != DELAYSTARTBLOCK))
-				return 0;
-			start_fsb += imap[n].br_blockcount;
-			count_fsb -= imap[n].br_blockcount;
-
-			if (imap[n].br_startblock == DELAYSTARTBLOCK)
-				found_delalloc = 1;
-		}
-	}
-	if (!found_delalloc)
-		*prealloc = 1;
-	return 0;
-}
-
-/*
- * Determine the initial size of the preallocation. We are beyond the current
- * EOF here, but we need to take into account whether this is a sparse write or
- * an extending write when determining the preallocation size.  Hence we need to
- * look up the extent that ends at the current write offset and use the result
- * to determine the preallocation size.
- *
- * If the extent is a hole, then preallocation is essentially disabled.
- * Otherwise we take the size of the preceeding data extent as the basis for the
- * preallocation size. If the size of the extent is greater than half the
- * maximum extent length, then use the current offset as the basis. This ensures
- * that for large files the preallocation size always extends to MAXEXTLEN
- * rather than falling short due to things like stripe unit/width alignment of
- * real extents.
- */
-STATIC xfs_fsblock_t
-xfs_iomap_eof_prealloc_initial_size(
-	struct xfs_mount	*mp,
-	struct xfs_inode	*ip,
-	xfs_off_t		offset,
-	xfs_bmbt_irec_t		*imap,
-	int			nimaps)
-{
-	xfs_fileoff_t   start_fsb;
-	int		imaps = 1;
-	int		error;
-
-	ASSERT(nimaps >= imaps);
-
-	/* if we are using a specific prealloc size, return now */
-	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
-		return 0;
-
-	/* If the file is small, then use the minimum prealloc */
-	if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign))
-		return 0;
-
-	/*
-	 * As we write multiple pages, the offset will always align to the
-	 * start of a page and hence point to a hole at EOF. i.e. if the size is
-	 * 4096 bytes, we only have one block at FSB 0, but XFS_B_TO_FSB(4096)
-	 * will return FSB 1. Hence if there are blocks in the file, we want to
-	 * point to the block prior to the EOF block and not the hole that maps
-	 * directly at @offset.
-	 */
-	start_fsb = XFS_B_TO_FSB(mp, offset);
-	if (start_fsb)
-		start_fsb--;
-	error = xfs_bmapi_read(ip, start_fsb, 1, imap, &imaps, XFS_BMAPI_ENTIRE);
-	if (error)
-		return 0;
-
-	ASSERT(imaps == 1);
-	if (imap[0].br_startblock == HOLESTARTBLOCK)
-		return 0;
-	if (imap[0].br_blockcount <= (MAXEXTLEN >> 1))
-		return imap[0].br_blockcount << 1;
-	return XFS_B_TO_FSB(mp, offset);
-}
-
 STATIC bool
 xfs_quota_need_throttle(
 	struct xfs_inode *ip,
@@ -503,20 +379,37 @@ xfs_quota_calc_throttle(
  */
 STATIC xfs_fsblock_t
 xfs_iomap_prealloc_size(
-	struct xfs_mount	*mp,
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	struct xfs_bmbt_irec	*imap,
-	int			nimaps)
+	struct xfs_bmbt_irec	*prev)
 {
-	xfs_fsblock_t		alloc_blocks = 0;
+	struct xfs_mount	*mp = ip->i_mount;
 	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
 	int			qshift = 0;
+	xfs_fsblock_t		alloc_blocks = 0;
 
-	alloc_blocks = xfs_iomap_eof_prealloc_initial_size(mp, ip, offset,
-							   imap, nimaps);
+	/*
+	 * Determine the initial size of the preallocation. We are beyond the
+	 * current EOF here, but we need to take into account whether this is
+	 * a sparse write or an extending write when determining the
+	 * preallocation size.  Hence we need to look up the extent that ends
+	 * at the current write offset and use the result to determine the
+	 * preallocation size.
+	 *
+	 * If the extent is a hole, then preallocation is essentially disabled.
+	 * Otherwise we take the size of the preceding data extent as the basis
+	 * for the preallocation size. If the size of the extent is greater than
+	 * half the maximum extent length, then use the current offset as the
+	 * basis. This ensures that for large files the preallocation size
+	 * always extends to MAXEXTLEN rather than falling short due to things
+	 * like stripe unit/width alignment of real extents.
+	 */
+	if (prev->br_blockcount <= (MAXEXTLEN >> 1))
+		alloc_blocks = prev->br_blockcount << 1;
+	else
+		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	if (!alloc_blocks)
 		goto check_writeio;
 	qblocks = alloc_blocks;
@@ -587,120 +480,167 @@ xfs_iomap_prealloc_size(
 	 */
 	while (alloc_blocks && alloc_blocks >= freesp)
 		alloc_blocks >>= 4;
-
 check_writeio:
 	if (alloc_blocks < mp->m_writeio_blocks)
 		alloc_blocks = mp->m_writeio_blocks;
-
 	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift,
 				      mp->m_writeio_blocks);
-
 	return alloc_blocks;
 }
 
-int
-xfs_iomap_write_delay(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	size_t		count,
-	xfs_bmbt_irec_t *ret_imap)
+static int
+xfs_file_iomap_begin_delay(
+	struct inode		*inode,
+	loff_t			offset,
+	loff_t			count,
+	unsigned		flags,
+	struct iomap		*iomap)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_fileoff_t	offset_fsb;
-	xfs_fileoff_t	last_fsb;
-	xfs_off_t	aligned_offset;
-	xfs_fileoff_t	ioalign;
-	xfs_extlen_t	extsz;
-	int		nimaps;
-	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
-	int		prealloc;
-	int		error;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	/*
-	 * Make sure that the dquots are there. This doesn't hold
-	 * the ilock across a disk read.
-	 */
-	error = xfs_qm_dqattach_locked(ip, 0);
-	if (error)
-		return error;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		maxbytes_fsb =
+		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
+	xfs_fileoff_t		end_fsb, orig_end_fsb;
+	int			error = 0, eof = 0;
+	struct xfs_bmbt_irec	got;
+	struct xfs_bmbt_irec	prev;
+	xfs_extnum_t		idx;
 
-	extsz = xfs_get_extsz_hint(ip);
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+	ASSERT(!xfs_get_extsz_hint(ip));
 
-	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
-				imap, XFS_WRITE_IMAPS, &prealloc);
-	if (error)
-		return error;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-retry:
-	if (prealloc) {
-		xfs_fsblock_t	alloc_blocks;
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
 
-		alloc_blocks = xfs_iomap_prealloc_size(mp, ip, offset, imap,
-						       XFS_WRITE_IMAPS);
+	XFS_STATS_INC(mp, xs_blk_mapw);
 
-		aligned_offset = XFS_WRITEIO_ALIGN(mp, (offset + count - 1));
-		ioalign = XFS_B_TO_FSBT(mp, aligned_offset);
-		last_fsb = ioalign + alloc_blocks;
-	} else {
-		last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error)
+			goto out_unlock;
 	}
 
-	if (prealloc || extsz) {
-		error = xfs_iomap_eof_align_last_fsb(ip, extsz, &last_fsb);
-		if (error)
-			return error;
+	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
+			&got, &prev);
+	if (!eof && got.br_startoff <= offset_fsb) {
+		trace_xfs_iomap_found(ip, offset, count, 0, &got);
+		goto done;
 	}
 
+	error = xfs_qm_dqattach_locked(ip, 0);
+	if (error)
+		goto out_unlock;
+
 	/*
-	 * Make sure preallocation does not create extents beyond the range we
-	 * actually support in this filesystem.
+	 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES pages
+	 * to keep the chunks of work done where somewhat symmetric with the
+	 * work writeback does. This is a completely arbitrary number pulled
+	 * out of thin air as a best guess for initial testing.
+	 *
+	 * Note that the values needs to be less than 32-bits wide until
+	 * the lower level functions are updated.
 	 */
-	if (last_fsb > XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes))
-		last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
+	count = min_t(loff_t, count, 1024 * PAGE_SIZE);
+	end_fsb = orig_end_fsb =
+		min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
+
+	/*
+	 * If we are doing a write at the end of the file and there are no
+	 * allocations past this one, then extend the allocation out to the
+	 * file system's write iosize.
+	 *
+	 * As an exception we don't do any preallocation at all if the file
+	 * is smaller than the minimum preallocation and we are using the
+	 * default dynamic preallocation scheme, as it is likely this is the
+	 * only write to the file that is going to be done.
+	 *
+	 * We clean up any extra space left over when the file is closed in
+	 * xfs_inactive().
+	 */
+	if (eof && offset + count > XFS_ISIZE(ip) &&
+	    ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
+	     XFS_ISIZE(ip) >= XFS_FSB_TO_B(mp, mp->m_writeio_blocks))) {
+		xfs_fsblock_t		alloc_blocks;
+		xfs_off_t		aligned_offset;
+		xfs_extlen_t		align;
+
+		/*
+		 * If an explicit allocsize is set, the file is small, or we
+		 * are writing behind a hole, then use the minimum prealloc:
+		 */
+		if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
+		    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
+		    idx == 0 ||
+		    prev.br_startoff + prev.br_blockcount < offset_fsb)
+			alloc_blocks = mp->m_writeio_blocks;
+		else
+			alloc_blocks =
+				xfs_iomap_prealloc_size(ip, offset, &prev);
+
+		aligned_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
+		end_fsb = XFS_B_TO_FSBT(mp, aligned_offset) + alloc_blocks;
+
+		align = xfs_eof_alignment(ip, 0);
+		if (align)
+			end_fsb = roundup_64(end_fsb, align);
 
-	ASSERT(last_fsb > offset_fsb);
+		end_fsb = min(end_fsb, maxbytes_fsb);
+		ASSERT(end_fsb > offset_fsb);
+	}
 
-	nimaps = XFS_WRITE_IMAPS;
-	error = xfs_bmapi_delay(ip, offset_fsb, last_fsb - offset_fsb,
-				imap, &nimaps, XFS_BMAPI_ENTIRE);
+retry:
+	error = xfs_bmapi_reserve_delalloc(ip, offset_fsb,
+			end_fsb - offset_fsb, &got,
+			&prev, &idx, eof);
 	switch (error) {
 	case 0:
+		break;
 	case -ENOSPC:
 	case -EDQUOT:
-		break;
-	default:
-		return error;
-	}
-
-	/*
-	 * If bmapi returned us nothing, we got either ENOSPC or EDQUOT. Retry
-	 * without EOF preallocation.
-	 */
-	if (nimaps == 0) {
+		/* retry without any preallocation */
 		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (prealloc) {
-			prealloc = 0;
-			error = 0;
+		if (end_fsb != orig_end_fsb) {
+			end_fsb = orig_end_fsb;
 			goto retry;
 		}
-		return error ? error : -ENOSPC;
+		/*FALLTHRU*/
+	default:
+		goto out_unlock;
 	}
 
-	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
-		return xfs_alert_fsblock_zero(ip, &imap[0]);
-
 	/*
 	 * Tag the inode as speculatively preallocated so we can reclaim this
 	 * space on demand, if necessary.
 	 */
-	if (prealloc)
+	if (end_fsb != orig_end_fsb)
 		xfs_inode_set_eofblocks_tag(ip);
 
-	*ret_imap = imap[0];
-	return 0;
+	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
+done:
+	if (isnullstartblock(got.br_startblock))
+		got.br_startblock = DELAYSTARTBLOCK;
+
+	if (!got.br_startblock) {
+		error = xfs_alert_fsblock_zero(ip, &got);
+		if (error)
+			goto out_unlock;
+	}
+
+	xfs_bmbt_to_iomap(ip, iomap, &got);
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 /*
@@ -1008,6 +948,11 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	if ((flags & IOMAP_WRITE) && !xfs_get_extsz_hint(ip)) {
+		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
+				iomap);
+	}
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
@@ -1035,19 +980,13 @@ xfs_file_iomap_begin(
 		 * the lower level functions are updated.
 		 */
 		length = min_t(loff_t, length, 1024 * PAGE_SIZE);
-		if (xfs_get_extsz_hint(ip)) {
-			/*
-			 * xfs_iomap_write_direct() expects the shared lock. It
-			 * is unlocked on return.
-			 */
-			xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
-			error = xfs_iomap_write_direct(ip, offset, length, &imap,
-					nimaps);
-		} else {
-			error = xfs_iomap_write_delay(ip, offset, length, &imap);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
-
+		/*
+		 * xfs_iomap_write_direct() expects the shared lock. It
+		 * is unlocked on return.
+		 */
+		xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
+		error = xfs_iomap_write_direct(ip, offset, length, &imap,
+				nimaps);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index fb8aca3..6498be4 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -25,8 +25,6 @@ struct xfs_bmbt_irec;
 
 int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *, int);
-int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
-			struct xfs_bmbt_irec *);
 int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
 			struct xfs_bmbt_irec *);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
