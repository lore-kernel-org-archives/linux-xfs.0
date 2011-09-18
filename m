Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfmHE200984 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 354F0172065
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gtvywGnaGAVB8JT8 for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:46 -0700 (PDT)
Message-Id: <20110918204146.539020554@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:41:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 21/27] xfs: move lastx and nallocs into bmalloca
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmalloca-lastx
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:45:35.173122340 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:45:59.659788862 -0400
@@ -4607,9 +4607,7 @@ xfs_bmapi_delay(
 STATIC int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma,
-	xfs_extnum_t		*lastx,
 	int			flags,
-	int			*nallocs,
 	int			*logflags)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
@@ -4628,8 +4626,8 @@ xfs_bmapi_allocate(
 	if (bma->wasdel) {
 		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
 		bma->offset = bma->got.br_startoff;
-		if (*lastx != NULLEXTNUM && *lastx) {
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx - 1),
+		if (bma->idx != NULLEXTNUM && bma->idx) {
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx - 1),
 					 &bma->prev);
 		}
 	} else {
@@ -4680,7 +4678,7 @@ xfs_bmapi_allocate(
 	 * Bump the number of extents we've allocated
 	 * in this call.
 	 */
-	(*nallocs)++;
+	bma->nallocs++;
 
 	if (bma->cur)
 		bma->cur->bc_private.b.flags =
@@ -4700,13 +4698,14 @@ xfs_bmapi_allocate(
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel) {
-		error = xfs_bmap_add_extent_delay_real(bma->tp, bma->ip, lastx,
-				&bma->cur, &bma->got, bma->firstblock,
-				bma->flist, logflags);
+		error = xfs_bmap_add_extent_delay_real(bma->tp, bma->ip,
+				&bma->idx, &bma->cur, &bma->got,
+				bma->firstblock, bma->flist, logflags);
 	} else {
-		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip, lastx,
-				&bma->cur, &bma->got, bma->firstblock,
-				bma->flist, logflags, whichfork);
+		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
+				&bma->idx, &bma->cur, &bma->got,
+				bma->firstblock, bma->flist, logflags,
+				whichfork);
 	}
 
 	if (error)
@@ -4717,7 +4716,7 @@ xfs_bmapi_allocate(
 	 * or xfs_bmap_add_extent_hole_real might have merged it into one of
 	 * the neighbouring ones.
 	 */
-	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), &bma->got);
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx), &bma->got);
 
 	ASSERT(bma->got.br_startoff <= bma->offset);
 	ASSERT(bma->got.br_startoff + bma->got.br_blockcount >=
@@ -4732,7 +4731,6 @@ xfs_bmapi_convert_unwritten(
 	struct xfs_bmalloca	*bma,
 	struct xfs_bmbt_irec	*mval,
 	xfs_filblks_t		len,
-	xfs_extnum_t		*lastx,
 	int			flags,
 	int			*logflags)
 {
@@ -4767,7 +4765,7 @@ xfs_bmapi_convert_unwritten(
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
 
-	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, lastx,
+	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
 			&bma->cur, mval, bma->firstblock, bma->flist, logflags);
 	if (error)
 		return error;
@@ -4777,7 +4775,7 @@ xfs_bmapi_convert_unwritten(
 	 * xfs_bmap_add_extent_unwritten_real might have merged it into one
 	 * of the neighbouring ones.
 	 */
-	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), &bma->got);
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx), &bma->got);
 
 	/*
 	 * We may have combined previously unwritten space with written space,
@@ -4820,10 +4818,8 @@ xfs_bmapi_write(
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	int			eof;		/* after the end of extents */
 	int			error;		/* error return */
-	xfs_extnum_t		lastx;		/* last useful extent number */
 	int			logflags;	/* flags for transaction logging */
 	int			n;		/* current extent index */
-	int			nallocs;	/* number of extents alloc'd */
 	xfs_fileoff_t		obno;		/* old block number (offset) */
 	int			tmp_logflags;	/* temp flags holder */
 	int			whichfork;	/* data or attr fork */
@@ -4871,7 +4867,6 @@ xfs_bmapi_write(
 	XFS_STATS_INC(xs_blk_mapw);
 
 	logflags = 0;
-	nallocs = 0;
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_local_to_extents(tp, ip, firstblock, total,
@@ -4895,7 +4890,7 @@ xfs_bmapi_write(
 			goto error0;
 	}
 
-	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &bma.got,
+	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &bma.idx, &bma.got,
 				&bma.prev);
 	n = 0;
 	end = bno + len;
@@ -4923,8 +4918,7 @@ xfs_bmapi_write(
 			bma.length = len;
 			bma.offset = bno;
 
-			error = xfs_bmapi_allocate(&bma, &lastx, flags,
-					&nallocs, &tmp_logflags);
+			error = xfs_bmapi_allocate(&bma, flags, &tmp_logflags);
 			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
@@ -4937,7 +4931,7 @@ xfs_bmapi_write(
 							end, n, flags);
 
 		/* Execute unwritten extent conversion if necessary */
-		error = xfs_bmapi_convert_unwritten(&bma, mval, len, &lastx,
+		error = xfs_bmapi_convert_unwritten(&bma, mval, len,
 						    flags, &tmp_logflags);
 		logflags |= tmp_logflags;
 		if (error == EAGAIN)
@@ -4953,14 +4947,15 @@ xfs_bmapi_write(
 		 * XFS_BMAP_MAX_NMAP extents no matter what.  Otherwise
 		 * the transaction may get too big.
 		 */
-		if (bno >= end || n >= *nmap || nallocs >= *nmap)
+		if (bno >= end || n >= *nmap || bma.nallocs >= *nmap)
 			break;
 
 		/* Else go on to the next record. */
 		bma.prev = bma.got;
-		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &bma.got);
-		else
+		if (++bma.idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) {
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma.idx),
+					 &bma.got);
+		} else
 			eof = 1;
 	}
 	*nmap = n;
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-09-11 08:45:35.000000000 -0400
+++ xfs/fs/xfs/xfs_bmap.h	2011-09-11 08:45:42.006455635 -0400
@@ -121,6 +121,8 @@ typedef struct xfs_bmalloca {
 	xfs_fsblock_t		blkno;	/* starting block of new extent */
 
 	struct xfs_btree_cur	*cur;	/* btree cursor */
+	xfs_extnum_t		idx;	/* current extent index */
+	int			nallocs;/* number of extents alloc'd */
 
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
