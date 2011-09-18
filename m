Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfkdg200912 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CEC217205C
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lQeAQGNDLBHcBH40 for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:43 -0700 (PDT)
Message-Id: <20110918204143.391202640@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/27] xfs: introduce xfs_bmapi_read()
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-add-xfs_bmapi_read
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

xfs_bmapi() currently handles both extent map reading and
allocation. As a result, the code is littered with "if (wr)"
branches to conditionally do allocation operations if required.
This makes the code much harder to follow and causes significant
indent issues with the code.

Given that read mapping is much simpler than allocation, we can
split out read mapping from xfs_bmapi() and reuse the logic that
we have already factored out do do all the hard work of handling the
extent map manipulations. The results in a much simpler function for
the common extent read operations, and will allow the allocation
code to be simplified in another commit.

Once xfs_bmapi_read() is implemented, convert all the callers of
xfs_bmapi() that are only reading extents to use the new function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-09-11 08:41:46.569790373 -0400
+++ xfs/fs/xfs/xfs_aops.c	2011-09-11 08:41:50.999790350 -0400
@@ -315,8 +315,8 @@ xfs_map_blocks(
 		count = mp->m_maxioffset - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
-			  bmapi_flags,  NULL, 0, imap, &nimaps, NULL);
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				imap, &nimaps, bmapi_flags);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (error)
@@ -1138,8 +1138,8 @@ __xfs_get_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
-			  XFS_BMAPI_ENTIRE,  NULL, 0, &imap, &nimaps, NULL);
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				&imap, &nimaps, XFS_BMAPI_ENTIRE);
 	if (error)
 		goto out_unlock;
 
Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2011-09-11 08:41:46.579790373 -0400
+++ xfs/fs/xfs/xfs_file.c	2011-09-11 09:07:20.349781210 -0400
@@ -509,11 +509,9 @@ xfs_zero_last_block(
 
 	last_fsb = XFS_B_TO_FSBT(mp, isize);
 	nimaps = 1;
-	error = xfs_bmapi(NULL, ip, last_fsb, 1, 0, NULL, 0, &imap,
-			  &nimaps, NULL);
-	if (error) {
+	error = xfs_bmapi_read(ip, last_fsb, 1, &imap, &nimaps, 0);
+	if (error)
 		return error;
-	}
 	ASSERT(nimaps > 0);
 	/*
 	 * If the block underlying isize is just a hole, then there
@@ -604,8 +602,8 @@ xfs_zero_eof(
 	while (start_zero_fsb <= end_zero_fsb) {
 		nimaps = 1;
 		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
-		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
-				  0, NULL, 0, &imap, &nimaps, NULL);
+		error = xfs_bmapi_read(ip, start_zero_fsb, zero_count_fsb,
+					  &imap, &nimaps, 0);
 		if (error) {
 			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 			return error;
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-09-11 08:41:46.593123706 -0400
+++ xfs/fs/xfs/xfs_dquot.c	2011-09-11 09:18:47.819777104 -0400
@@ -485,9 +485,8 @@ xfs_qm_dqtobp(
 	/*
 	 * Find the block map; no allocations yet
 	 */
-	error = xfs_bmapi(NULL, quotip, dqp->q_fileoffset,
-			  XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
-			  NULL, 0, &map, &nmaps, NULL);
+	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
+			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
 
 	xfs_iunlock(quotip, XFS_ILOCK_SHARED);
 	if (error)
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-09-11 08:41:46.603123706 -0400
+++ xfs/fs/xfs/xfs_qm.c	2011-09-11 08:41:51.003123683 -0400
@@ -1347,11 +1347,8 @@ xfs_qm_dqiterate(
 		 * the inode is never added to the transaction.
 		 */
 		xfs_ilock(qip, XFS_ILOCK_SHARED);
-		error = xfs_bmapi(NULL, qip, lblkno,
-				  maxlblkcnt - lblkno,
-				  XFS_BMAPI_METADATA,
-				  NULL,
-				  0, map, &nmaps, NULL);
+		error = xfs_bmapi_read(qip, lblkno, maxlblkcnt - lblkno,
+				       map, &nmaps, 0);
 		xfs_iunlock(qip, XFS_ILOCK_SHARED);
 		if (error)
 			break;
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-09-11 08:41:46.613123706 -0400
+++ xfs/fs/xfs/xfs_attr.c	2011-09-11 09:18:47.829777104 -0400
@@ -1963,10 +1963,9 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 	lblkno = args->rmtblkno;
 	while (valuelen > 0) {
 		nmap = ATTR_RMTVALUE_MAPSIZE;
-		error = xfs_bmapi(args->trans, args->dp, (xfs_fileoff_t)lblkno,
-				  args->rmtblkcnt,
-				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-				  NULL, 0, map, &nmap, NULL);
+		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
+				       args->rmtblkcnt, map, &nmap,
+				       XFS_BMAPI_ATTRFORK);
 		if (error)
 			return(error);
 		ASSERT(nmap >= 1);
@@ -2092,14 +2091,11 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
-		error = xfs_bmapi(NULL, dp, (xfs_fileoff_t)lblkno,
-				  args->rmtblkcnt,
-				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-				  args->firstblock, 0, &map, &nmap,
-				  NULL);
-		if (error) {
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
+				       args->rmtblkcnt, &map, &nmap,
+				       XFS_BMAPI_ATTRFORK);
+		if (error)
 			return(error);
-		}
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
@@ -2155,16 +2151,12 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
-		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
-		error = xfs_bmapi(NULL, args->dp, (xfs_fileoff_t)lblkno,
-					args->rmtblkcnt,
-					XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-					args->firstblock, 0, &map, &nmap,
-					args->flist);
-		if (error) {
+		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
+				       args->rmtblkcnt, &map, &nmap,
+				       XFS_BMAPI_ATTRFORK);
+		if (error)
 			return(error);
-		}
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2011-09-11 08:41:46.626457040 -0400
+++ xfs/fs/xfs/xfs_attr_leaf.c	2011-09-11 08:41:51.006457016 -0400
@@ -2926,9 +2926,8 @@ xfs_attr_leaf_freextent(xfs_trans_t **tr
 		 * Try to remember where we decided to put the value.
 		 */
 		nmap = 1;
-		error = xfs_bmapi(*trans, dp, (xfs_fileoff_t)tblkno, tblkcnt,
-					XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-					NULL, 0, &map, &nmap, NULL);
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
+				       &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error) {
 			return(error);
 		}
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:41:46.636457040 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 09:19:41.439776780 -0400
@@ -4350,6 +4350,98 @@ xfs_bmapi_update_map(
 }
 
 /*
+ * Map file blocks to filesystem blocks without allocation.
+ */
+int
+xfs_bmapi_read(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		bno,
+	xfs_filblks_t		len,
+	struct xfs_bmbt_irec	*mval,
+	int			*nmap,
+	int			flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp;
+	struct xfs_bmbt_irec	got;
+	struct xfs_bmbt_irec	prev;
+	xfs_fileoff_t		obno;
+	xfs_fileoff_t		end;
+	xfs_extnum_t		lastx;
+	int			error;
+	int			eof;
+	int			n = 0;
+	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
+						XFS_ATTR_FORK : XFS_DATA_FORK;
+
+	ASSERT(*nmap >= 1);
+	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
+			   XFS_BMAPI_IGSTATE)));
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_bmapi_read", XFS_ERRLEVEL_LOW, mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	XFS_STATS_INC(xs_blk_mapr);
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ASSERT(ifp->if_ext_max ==
+	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, whichfork);
+		if (error)
+			return error;
+	}
+
+	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got, &prev);
+	end = bno + len;
+	obno = bno;
+
+	while (bno < end && n < *nmap) {
+		/* Reading past eof, act as though there's a hole up to end. */
+		if (eof)
+			got.br_startoff = end;
+		if (got.br_startoff > bno) {
+			/* Reading in a hole.  */
+			mval->br_startoff = bno;
+			mval->br_startblock = HOLESTARTBLOCK;
+			mval->br_blockcount =
+				XFS_FILBLKS_MIN(len, got.br_startoff - bno);
+			mval->br_state = XFS_EXT_NORM;
+			bno += mval->br_blockcount;
+			len -= mval->br_blockcount;
+			mval++;
+			n++;
+			continue;
+		}
+
+		/* set up the extent map to return. */
+		xfs_bmapi_trim_map(mval, &got, &bno, len, obno, end, n, flags);
+		xfs_bmapi_update_map(&mval, &bno, &len, obno, end, &n, flags);
+
+		/* If we're done, stop now. */
+		if (bno >= end || n >= *nmap)
+			break;
+
+		/* Else go on to the next record. */
+		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
+		else
+			eof = 1;
+	}
+	*nmap = n;
+	return 0;
+}
+
+/*
  * Map file blocks to filesystem blocks.
  * File range is given by the bno/len pair.
  * Adds blocks to file if a write ("flags & XFS_BMAPI_WRITE" set)
@@ -5490,10 +5582,9 @@ xfs_getbmap(
 
 	do {
 		nmap = (nexleft > subnex) ? subnex : nexleft;
-		error = xfs_bmapi(NULL, ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
-				  XFS_BB_TO_FSB(mp, bmv->bmv_length),
-				  bmapi_flags, NULL, 0, map, &nmap,
-				  NULL);
+		error = xfs_bmapi_read(ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
+				       XFS_BB_TO_FSB(mp, bmv->bmv_length),
+				       map, &nmap, bmapi_flags);
 		if (error)
 			goto out_free_map;
 		ASSERT(nmap <= subnex);
@@ -6084,9 +6175,8 @@ xfs_bmap_punch_delalloc_range(
 		 * trying to remove a real extent (which requires a
 		 * transaction) or a hole, which is probably a bad idea...
 		 */
-		error = xfs_bmapi(NULL, ip, start_fsb, 1,
-				XFS_BMAPI_ENTIRE,  NULL, 0, &imap,
-				&nimaps, NULL);
+		error = xfs_bmapi_read(ip, start_fsb, 1, &imap, &nimaps,
+				       XFS_BMAPI_ENTIRE);
 
 		if (error) {
 			/* something screwed, just bail */
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-09-11 08:41:46.649790373 -0400
+++ xfs/fs/xfs/xfs_bmap.h	2011-09-11 09:18:50.286443755 -0400
@@ -294,6 +294,10 @@ xfs_bmapi(
 	int			*nmap,		/* i/o: mval size/count */
 	xfs_bmap_free_t		*flist);	/* i/o: list extents to free */
 
+int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
+		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
+		int *nmap, int flags);
+
 /*
  * Map file blocks to filesystem blocks, simple version.
  * One block only, read-only.
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-09-11 08:41:46.659790373 -0400
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-09-11 08:41:51.009790348 -0400
@@ -888,12 +888,10 @@ xfs_dir2_leaf_getdents(
 				 * we already have in the table.
 				 */
 				nmap = map_size - map_valid;
-				error = xfs_bmapi(NULL, dp,
-					map_off,
+				error = xfs_bmapi_read(dp, map_off,
 					xfs_dir2_byte_to_da(mp,
 						XFS_DIR2_LEAF_OFFSET) - map_off,
-					XFS_BMAPI_METADATA, NULL, 0,
-					&map[map_valid], &nmap, NULL);
+					&map[map_valid], &nmap, 0);
 				/*
 				 * Don't know if we should ignore this or
 				 * try to return an error.
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-09-11 08:41:46.673123706 -0400
+++ xfs/fs/xfs/xfs_inode.c	2011-09-11 08:41:51.013123680 -0400
@@ -1187,6 +1187,7 @@ xfs_isize_check(
 	xfs_fileoff_t		map_first;
 	int			nimaps;
 	xfs_bmbt_irec_t		imaps[2];
+	int			error;
 
 	if (!S_ISREG(ip->i_d.di_mode))
 		return;
@@ -1203,13 +1204,12 @@ xfs_isize_check(
 	 * The filesystem could be shutting down, so bmapi may return
 	 * an error.
 	 */
-	if (xfs_bmapi(NULL, ip, map_first,
+	error = xfs_bmapi_read(ip, map_first,
 			 (XFS_B_TO_FSB(mp,
-				       (xfs_ufsize_t)XFS_MAXIOFFSET(mp)) -
-			  map_first),
-			 XFS_BMAPI_ENTIRE, NULL, 0, imaps, &nimaps,
-			 NULL))
-	    return;
+			       (xfs_ufsize_t)XFS_MAXIOFFSET(mp)) - map_first),
+			 imaps, &nimaps, XFS_BMAPI_ENTIRE);
+	if (error)
+		return;
 	ASSERT(nimaps == 1);
 	ASSERT(imaps[0].br_startblock == HOLESTARTBLOCK);
 }
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2011-09-11 08:41:46.683123705 -0400
+++ xfs/fs/xfs/xfs_iomap.c	2011-09-11 09:18:49.453110427 -0400
@@ -300,8 +300,8 @@ xfs_iomap_eof_want_preallocate(
 	while (count_fsb > 0) {
 		imaps = nimaps;
 		firstblock = NULLFSBLOCK;
-		error = xfs_bmapi(NULL, ip, start_fsb, count_fsb, 0,
-				  &firstblock, 0, imap, &imaps, NULL);
+		error = xfs_bmapi_read(ip, start_fsb, count_fsb, imap, &imaps,
+				       0);
 		if (error)
 			return error;
 		for (n = 0; n < imaps; n++) {
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-09-11 08:41:46.693123705 -0400
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-09-11 09:18:47.903110436 -0400
@@ -72,8 +72,8 @@ xfs_readlink_bmap(
 	xfs_buf_t	*bp;
 	int		error = 0;
 
-	error = xfs_bmapi(NULL, ip, 0, XFS_B_TO_FSB(mp, pathlen), 0, NULL, 0,
-			mval, &nmaps, NULL);
+	error = xfs_bmapi_read(ip, 0, XFS_B_TO_FSB(mp, pathlen), mval, &nmaps,
+			       0);
 	if (error)
 		goto out;
 
@@ -178,8 +178,7 @@ xfs_free_eofblocks(
 
 	nimaps = 1;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_bmapi(NULL, ip, end_fsb, map_len, 0,
-			  NULL, 0, &imap, &nimaps, NULL);
+	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (!error && (nimaps != 0) &&
@@ -297,9 +296,9 @@ xfs_inactive_symlink_rmt(
 	done = 0;
 	xfs_bmap_init(&free_list, &first_block);
 	nmaps = ARRAY_SIZE(mval);
-	if ((error = xfs_bmapi(tp, ip, 0, XFS_B_TO_FSB(mp, size),
-			XFS_BMAPI_METADATA, &first_block, 0, mval, &nmaps,
-			&free_list)))
+	error = xfs_bmapi_read(ip, 0, XFS_B_TO_FSB(mp, size),
+				mval, &nmaps, 0);
+	if (error)
 		goto error0;
 	/*
 	 * Invalidate the block(s).
@@ -1974,8 +1973,7 @@ xfs_zero_remaining_bytes(
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
 		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 		nimap = 1;
-		error = xfs_bmapi(NULL, ip, offset_fsb, 1, 0,
-			NULL, 0, &imap, &nimap, NULL);
+		error = xfs_bmapi_read(ip, offset_fsb, 1, &imap, &nimap, 0);
 		if (error || nimap < 1)
 			break;
 		ASSERT(imap.br_blockcount >= 1);
@@ -2094,8 +2092,8 @@ xfs_free_file_space(
 	 */
 	if (rt && !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
 		nimap = 1;
-		error = xfs_bmapi(NULL, ip, startoffset_fsb,
-			1, 0, NULL, 0, &imap, &nimap, NULL);
+		error = xfs_bmapi_read(ip, startoffset_fsb, 1,
+					&imap, &nimap, 0);
 		if (error)
 			goto out_unlock_iolock;
 		ASSERT(nimap == 0 || nimap == 1);
@@ -2109,8 +2107,8 @@ xfs_free_file_space(
 				startoffset_fsb += mp->m_sb.sb_rextsize - mod;
 		}
 		nimap = 1;
-		error = xfs_bmapi(NULL, ip, endoffset_fsb - 1,
-			1, 0, NULL, 0, &imap, &nimap, NULL);
+		error = xfs_bmapi_read(ip, endoffset_fsb - 1, 1,
+					&imap, &nimap, 0);
 		if (error)
 			goto out_unlock_iolock;
 		ASSERT(nimap == 0 || nimap == 1);
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-09-11 08:41:46.709790372 -0400
+++ xfs/fs/xfs/xfs_da_btree.c	2011-09-11 09:18:50.313110423 -0400
@@ -1995,11 +1995,10 @@ xfs_da_do_buf(
 		} else {
 			mapp = kmem_alloc(sizeof(*mapp) * nfsb, KM_SLEEP);
 			nmap = nfsb;
-			if ((error = xfs_bmapi(trans, dp, (xfs_fileoff_t)bno,
-					nfsb,
-					XFS_BMAPI_METADATA |
-						xfs_bmapi_aflag(whichfork),
-					NULL, 0, mapp, &nmap, NULL)))
+			error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb,
+					       mapp, &nmap,
+					       xfs_bmapi_aflag(whichfork));
+			if (error)
 				goto exit0;
 		}
 	} else {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
