Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66k1s014511 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6E5F139758D
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:09:29 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	D1iBu6sj3KQEaM7J for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:09:29 -0700 (PDT)
Message-Id: <20110824060643.900337846@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/25] xfs: move extent records into bmalloca structure
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmalloca-extents
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

Rather that putting extent records on the stack and then pointing to
them in the bmalloca structure which is in the same stack frame, put
the extent records directly in the bmalloca structure. This reduces
the number of args that need to be passed around.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:14:35.358748989 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:14:37.402071253 +0200
@@ -2013,18 +2013,18 @@ xfs_bmap_adjacent(
 	 * If allocating at eof, and there's a previous real block,
 	 * try to use its last block as our starting point.
 	 */
-	if (ap->eof && ap->prevp->br_startoff != NULLFILEOFF &&
-	    !isnullstartblock(ap->prevp->br_startblock) &&
-	    ISVALID(ap->prevp->br_startblock + ap->prevp->br_blockcount,
-		    ap->prevp->br_startblock)) {
-		ap->rval = ap->prevp->br_startblock + ap->prevp->br_blockcount;
+	if (ap->eof && ap->prev.br_startoff != NULLFILEOFF &&
+	    !isnullstartblock(ap->prev.br_startblock) &&
+	    ISVALID(ap->prev.br_startblock + ap->prev.br_blockcount,
+		    ap->prev.br_startblock)) {
+		ap->rval = ap->prev.br_startblock + ap->prev.br_blockcount;
 		/*
 		 * Adjust for the gap between prevp and us.
 		 */
 		adjust = ap->off -
-			(ap->prevp->br_startoff + ap->prevp->br_blockcount);
+			(ap->prev.br_startoff + ap->prev.br_blockcount);
 		if (adjust &&
-		    ISVALID(ap->rval + adjust, ap->prevp->br_startblock))
+		    ISVALID(ap->rval + adjust, ap->prev.br_startblock))
 			ap->rval += adjust;
 	}
 	/*
@@ -2042,17 +2042,17 @@ xfs_bmap_adjacent(
 		 * If there's a previous (left) block, select a requested
 		 * start block based on it.
 		 */
-		if (ap->prevp->br_startoff != NULLFILEOFF &&
-		    !isnullstartblock(ap->prevp->br_startblock) &&
-		    (prevbno = ap->prevp->br_startblock +
-			       ap->prevp->br_blockcount) &&
-		    ISVALID(prevbno, ap->prevp->br_startblock)) {
+		if (ap->prev.br_startoff != NULLFILEOFF &&
+		    !isnullstartblock(ap->prev.br_startblock) &&
+		    (prevbno = ap->prev.br_startblock +
+			       ap->prev.br_blockcount) &&
+		    ISVALID(prevbno, ap->prev.br_startblock)) {
 			/*
 			 * Calculate gap to end of previous block.
 			 */
 			adjust = prevdiff = ap->off -
-				(ap->prevp->br_startoff +
-				 ap->prevp->br_blockcount);
+				(ap->prev.br_startoff +
+				 ap->prev.br_blockcount);
 			/*
 			 * Figure the startblock based on the previous block's
 			 * end and the gap size.
@@ -2063,7 +2063,7 @@ xfs_bmap_adjacent(
 			 */
 			if (prevdiff <= XFS_ALLOC_GAP_UNITS * ap->alen &&
 			    ISVALID(prevbno + prevdiff,
-				    ap->prevp->br_startblock))
+				    ap->prev.br_startblock))
 				prevbno += adjust;
 			else
 				prevdiff += adjust;
@@ -2084,16 +2084,16 @@ xfs_bmap_adjacent(
 		 * If there's a following (right) block, select a requested
 		 * start block based on it.
 		 */
-		if (!isnullstartblock(ap->gotp->br_startblock)) {
+		if (!isnullstartblock(ap->got.br_startblock)) {
 			/*
 			 * Calculate gap to start of next block.
 			 */
-			adjust = gotdiff = ap->gotp->br_startoff - ap->off;
+			adjust = gotdiff = ap->got.br_startoff - ap->off;
 			/*
 			 * Figure the startblock based on the next block's
 			 * start and the gap size.
 			 */
-			gotbno = ap->gotp->br_startblock;
+			gotbno = ap->got.br_startblock;
 			/*
 			 * Heuristic!
 			 * If the gap is large relative to the piece we're
@@ -2151,7 +2151,7 @@ xfs_bmap_rtalloc(
 	mp = ap->ip->i_mount;
 	align = xfs_get_extsz_hint(ap->ip);
 	prod = align / mp->m_sb.sb_rextsize;
-	error = xfs_bmap_extsize_align(mp, ap->gotp, ap->prevp,
+	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
 					ap->conv, &ap->off, &ap->alen);
 	if (error)
@@ -2374,7 +2374,7 @@ xfs_bmap_btalloc(
 	mp = ap->ip->i_mount;
 	align = ap->userdata ? xfs_get_extsz_hint(ap->ip) : 0;
 	if (unlikely(align)) {
-		error = xfs_bmap_extsize_align(mp, ap->gotp, ap->prevp,
+		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 						align, 0, ap->eof, 0, ap->conv,
 						&ap->off, &ap->alen);
 		ASSERT(!error);
@@ -4613,17 +4613,17 @@ xfs_bmapi_allocate(
 	 * for in this bmap call but that wouldn't be as good.
 	 */
 	if (bma->wasdel) {
-		alen = (xfs_extlen_t)bma->gotp->br_blockcount;
-		aoff = bma->gotp->br_startoff;
+		alen = (xfs_extlen_t)bma->got.br_blockcount;
+		aoff = bma->got.br_startoff;
 		if (*lastx != NULLEXTNUM && *lastx) {
 			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx - 1),
-					 bma->prevp);
+					 &bma->prev);
 		}
 	} else {
 		alen = (xfs_extlen_t)XFS_FILBLKS_MIN(bma->alen, MAXEXTLEN);
 		if (!bma->eof)
 			alen = (xfs_extlen_t)XFS_FILBLKS_MIN(alen,
-					bma->gotp->br_startoff - bma->off);
+					bma->got.br_startoff - bma->off);
 		aoff = bma->off;
 	}
 
@@ -4694,10 +4694,10 @@ xfs_bmapi_allocate(
 		(*cur)->bc_private.b.flags =
 			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 
-	bma->gotp->br_startoff = aoff;
-	bma->gotp->br_startblock = abno;
-	bma->gotp->br_blockcount = alen;
-	bma->gotp->br_state = XFS_EXT_NORM;
+	bma->got.br_startoff = aoff;
+	bma->got.br_startblock = abno;
+	bma->got.br_blockcount = alen;
+	bma->got.br_state = XFS_EXT_NORM;
 
 	/*
 	 * A wasdelay extent has been initialized, so shouldn't be flagged
@@ -4705,14 +4705,14 @@ xfs_bmapi_allocate(
 	 */
 	if (!bma->wasdel && (flags & XFS_BMAPI_PREALLOC) &&
 	    xfs_sb_version_hasextflgbit(&mp->m_sb))
-		bma->gotp->br_state = XFS_EXT_UNWRITTEN;
+		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel) {
 		error = xfs_bmap_add_extent_delay_real(bma->tp, bma->ip, lastx,
-				cur, bma->gotp, firstblock, flist, logflags);
+				cur, &bma->got, firstblock, flist, logflags);
 	} else {
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip, lastx,
-				cur, bma->gotp, firstblock, flist, logflags,
+				cur, &bma->got, firstblock, flist, logflags,
 				whichfork);
 	}
 
@@ -4724,13 +4724,12 @@ xfs_bmapi_allocate(
 	 * or xfs_bmap_add_extent_hole_real might have merged it into one of
 	 * the neighbouring ones.
 	 */
-	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), bma->gotp);
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), &bma->got);
 
-	ASSERT(bma->gotp->br_startoff <= aoff);
-	ASSERT(bma->gotp->br_startoff + bma->gotp->br_blockcount >=
-		aoff + alen);
-	ASSERT(bma->gotp->br_state == XFS_EXT_NORM ||
-	       bma->gotp->br_state == XFS_EXT_UNWRITTEN);
+	ASSERT(bma->got.br_startoff <= aoff);
+	ASSERT(bma->got.br_startoff + bma->got.br_blockcount >= aoff + alen);
+	ASSERT(bma->got.br_state == XFS_EXT_NORM ||
+	       bma->got.br_state == XFS_EXT_UNWRITTEN);
 	return 0;
 }
 
@@ -4787,7 +4786,7 @@ xfs_bmapi_convert_unwritten(
 	 * xfs_bmap_add_extent_unwritten_real might have merged it into one
 	 * of the neighbouring ones.
 	 */
-	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), bma->gotp);
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), &bma->got);
 
 	/*
 	 * We may have combined previously unwritten space with written space,
@@ -4830,7 +4829,6 @@ xfs_bmapi_write(
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	int			eof;		/* after the end of extents */
 	int			error;		/* error return */
-	struct xfs_bmbt_irec	got;		/* current file extent record */
 	xfs_ifork_t		*ifp;		/* inode fork pointer */
 	xfs_extnum_t		lastx;		/* last useful extent number */
 	int			logflags;	/* flags for transaction logging */
@@ -4838,7 +4836,6 @@ xfs_bmapi_write(
 	int			n;		/* current extent index */
 	int			nallocs;	/* number of extents alloc'd */
 	xfs_fileoff_t		obno;		/* old block number (offset) */
-	struct xfs_bmbt_irec	prev;		/* previous file extent record */
 	int			tmp_logflags;	/* temp flags holder */
 	int			whichfork;	/* data or attr fork */
 	char			inhole;		/* current location is hole in file */
@@ -4910,21 +4907,20 @@ xfs_bmapi_write(
 			goto error0;
 	}
 
-	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got, &prev);
+	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &bma.got,
+				&bma.prev);
 	n = 0;
 	end = bno + len;
 	obno = bno;
 
 	bma.tp = tp;
 	bma.ip = ip;
-	bma.prevp = &prev;
-	bma.gotp = &got;
 	bma.total = total;
 	bma.userdata = 0;
 
 	while (bno < end && n < *nmap) {
-		inhole = eof || got.br_startoff > bno;
-		wasdelay = !inhole && isnullstartblock(got.br_startblock);
+		inhole = eof || bma.got.br_startoff > bno;
+		wasdelay = !inhole && isnullstartblock(bma.got.br_startblock);
 
 		/*
 		 * First, deal with the hole before the allocated space
@@ -4959,7 +4955,8 @@ xfs_bmapi_write(
 		}
 
 		/* Deal with the allocated space we found.  */
-		xfs_bmapi_trim_map(mval, &got, &bno, len, obno, end, n, flags);
+		xfs_bmapi_trim_map(mval, &bma.got, &bno, len, obno,
+							end, n, flags);
 
 		/* Execute unwritten extent conversion if necessary */
 		error = xfs_bmapi_convert_unwritten(&bma, mval, len, &lastx,
@@ -4983,9 +4980,9 @@ xfs_bmapi_write(
 			break;
 
 		/* Else go on to the next record. */
-		prev = got;
+		bma.prev = bma.got;
 		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &bma.got);
 		else
 			eof = 1;
 	}
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-08-23 21:13:59.318944234 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-08-23 21:14:37.402071253 +0200
@@ -114,8 +114,8 @@ typedef struct xfs_bmalloca {
 	xfs_fileoff_t		off;	/* offset in file filling in */
 	struct xfs_trans	*tp;	/* transaction pointer */
 	struct xfs_inode	*ip;	/* incore inode pointer */
-	struct xfs_bmbt_irec	*prevp;	/* extent before the new one */
-	struct xfs_bmbt_irec	*gotp;	/* extent after, or delayed */
+	struct xfs_bmbt_irec	prev;	/* extent before the new one */
+	struct xfs_bmbt_irec	got;	/* extent after, or delayed */
 	xfs_extlen_t		alen;	/* i/o length asked/allocated */
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
