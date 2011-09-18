Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfnmj201018 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9079A1DA9C2B
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CeEEpwM9LMkSWD1t for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:46 -0700 (PDT)
Message-Id: <20110918204145.971705752@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 18/27] xfs: rename allocation range fields in struct
	xfs_bmalloca
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmalloca-rename-ranges
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
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:45:09.973122492 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:45:11.126455817 -0400
@@ -2017,15 +2017,15 @@ xfs_bmap_adjacent(
 	    !isnullstartblock(ap->prev.br_startblock) &&
 	    ISVALID(ap->prev.br_startblock + ap->prev.br_blockcount,
 		    ap->prev.br_startblock)) {
-		ap->rval = ap->prev.br_startblock + ap->prev.br_blockcount;
+		ap->blkno = ap->prev.br_startblock + ap->prev.br_blockcount;
 		/*
 		 * Adjust for the gap between prevp and us.
 		 */
-		adjust = ap->off -
+		adjust = ap->offset -
 			(ap->prev.br_startoff + ap->prev.br_blockcount);
 		if (adjust &&
-		    ISVALID(ap->rval + adjust, ap->prev.br_startblock))
-			ap->rval += adjust;
+		    ISVALID(ap->blkno + adjust, ap->prev.br_startblock))
+			ap->blkno += adjust;
 	}
 	/*
 	 * If not at eof, then compare the two neighbor blocks.
@@ -2050,7 +2050,7 @@ xfs_bmap_adjacent(
 			/*
 			 * Calculate gap to end of previous block.
 			 */
-			adjust = prevdiff = ap->off -
+			adjust = prevdiff = ap->offset -
 				(ap->prev.br_startoff +
 				 ap->prev.br_blockcount);
 			/*
@@ -2061,7 +2061,7 @@ xfs_bmap_adjacent(
 			 * allocating, or using it gives us an invalid block
 			 * number, then just use the end of the previous block.
 			 */
-			if (prevdiff <= XFS_ALLOC_GAP_UNITS * ap->alen &&
+			if (prevdiff <= XFS_ALLOC_GAP_UNITS * ap->length &&
 			    ISVALID(prevbno + prevdiff,
 				    ap->prev.br_startblock))
 				prevbno += adjust;
@@ -2088,7 +2088,7 @@ xfs_bmap_adjacent(
 			/*
 			 * Calculate gap to start of next block.
 			 */
-			adjust = gotdiff = ap->got.br_startoff - ap->off;
+			adjust = gotdiff = ap->got.br_startoff - ap->offset;
 			/*
 			 * Figure the startblock based on the next block's
 			 * start and the gap size.
@@ -2101,12 +2101,12 @@ xfs_bmap_adjacent(
 			 * number, then just use the start of the next block
 			 * offset by our length.
 			 */
-			if (gotdiff <= XFS_ALLOC_GAP_UNITS * ap->alen &&
+			if (gotdiff <= XFS_ALLOC_GAP_UNITS * ap->length &&
 			    ISVALID(gotbno - gotdiff, gotbno))
 				gotbno -= adjust;
-			else if (ISVALID(gotbno - ap->alen, gotbno)) {
-				gotbno -= ap->alen;
-				gotdiff += adjust - ap->alen;
+			else if (ISVALID(gotbno - ap->length, gotbno)) {
+				gotbno -= ap->length;
+				gotdiff += adjust - ap->length;
 			} else
 				gotdiff += adjust;
 			/*
@@ -2124,14 +2124,14 @@ xfs_bmap_adjacent(
 			gotbno = NULLFSBLOCK;
 		/*
 		 * If both valid, pick the better one, else the only good
-		 * one, else ap->rval is already set (to 0 or the inode block).
+		 * one, else ap->blkno is already set (to 0 or the inode block).
 		 */
 		if (prevbno != NULLFSBLOCK && gotbno != NULLFSBLOCK)
-			ap->rval = prevdiff <= gotdiff ? prevbno : gotbno;
+			ap->blkno = prevdiff <= gotdiff ? prevbno : gotbno;
 		else if (prevbno != NULLFSBLOCK)
-			ap->rval = prevbno;
+			ap->blkno = prevbno;
 		else if (gotbno != NULLFSBLOCK)
-			ap->rval = gotbno;
+			ap->blkno = gotbno;
 	}
 #undef ISVALID
 }
@@ -2153,22 +2153,22 @@ xfs_bmap_rtalloc(
 	prod = align / mp->m_sb.sb_rextsize;
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
-					ap->conv, &ap->off, &ap->alen);
+					ap->conv, &ap->offset, &ap->length);
 	if (error)
 		return error;
-	ASSERT(ap->alen);
-	ASSERT(ap->alen % mp->m_sb.sb_rextsize == 0);
+	ASSERT(ap->length);
+	ASSERT(ap->length % mp->m_sb.sb_rextsize == 0);
 
 	/*
 	 * If the offset & length are not perfectly aligned
 	 * then kill prod, it will just get us in trouble.
 	 */
-	if (do_mod(ap->off, align) || ap->alen % align)
+	if (do_mod(ap->offset, align) || ap->length % align)
 		prod = 1;
 	/*
 	 * Set ralen to be the actual requested length in rtextents.
 	 */
-	ralen = ap->alen / mp->m_sb.sb_rextsize;
+	ralen = ap->length / mp->m_sb.sb_rextsize;
 	/*
 	 * If the old value was close enough to MAXEXTLEN that
 	 * we rounded up to it, cut it back so it's valid again.
@@ -2189,15 +2189,15 @@ xfs_bmap_rtalloc(
 	 * If it's an allocation to an empty file at offset 0,
 	 * pick an extent that will space things out in the rt area.
 	 */
-	if (ap->eof && ap->off == 0) {
+	if (ap->eof && ap->offset == 0) {
 		xfs_rtblock_t uninitialized_var(rtx); /* realtime extent no */
 
 		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
 		if (error)
 			return error;
-		ap->rval = rtx * mp->m_sb.sb_rextsize;
+		ap->blkno = rtx * mp->m_sb.sb_rextsize;
 	} else {
-		ap->rval = 0;
+		ap->blkno = 0;
 	}
 
 	xfs_bmap_adjacent(ap);
@@ -2205,23 +2205,23 @@ xfs_bmap_rtalloc(
 	/*
 	 * Realtime allocation, done through xfs_rtallocate_extent.
 	 */
-	atype = ap->rval == 0 ?  XFS_ALLOCTYPE_ANY_AG : XFS_ALLOCTYPE_NEAR_BNO;
-	do_div(ap->rval, mp->m_sb.sb_rextsize);
-	rtb = ap->rval;
-	ap->alen = ralen;
-	if ((error = xfs_rtallocate_extent(ap->tp, ap->rval, 1, ap->alen,
+	atype = ap->blkno == 0 ?  XFS_ALLOCTYPE_ANY_AG : XFS_ALLOCTYPE_NEAR_BNO;
+	do_div(ap->blkno, mp->m_sb.sb_rextsize);
+	rtb = ap->blkno;
+	ap->length = ralen;
+	if ((error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
 				&ralen, atype, ap->wasdel, prod, &rtb)))
 		return error;
 	if (rtb == NULLFSBLOCK && prod > 1 &&
-	    (error = xfs_rtallocate_extent(ap->tp, ap->rval, 1,
-					   ap->alen, &ralen, atype,
+	    (error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1,
+					   ap->length, &ralen, atype,
 					   ap->wasdel, 1, &rtb)))
 		return error;
-	ap->rval = rtb;
-	if (ap->rval != NULLFSBLOCK) {
-		ap->rval *= mp->m_sb.sb_rextsize;
+	ap->blkno = rtb;
+	if (ap->blkno != NULLFSBLOCK) {
+		ap->blkno *= mp->m_sb.sb_rextsize;
 		ralen *= mp->m_sb.sb_rextsize;
-		ap->alen = ralen;
+		ap->length = ralen;
 		ap->ip->i_d.di_nblocks += ralen;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
@@ -2234,7 +2234,7 @@ xfs_bmap_rtalloc(
 			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
 					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
 	} else {
-		ap->alen = 0;
+		ap->length = 0;
 	}
 	return 0;
 }
@@ -2349,7 +2349,7 @@ xfs_bmap_btalloc_nullfb(
 	 * AG as the stream may have moved.
 	 */
 	if (xfs_inode_is_filestream(ap->ip))
-		ap->rval = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+		ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
 
 	return 0;
 }
@@ -2376,9 +2376,9 @@ xfs_bmap_btalloc(
 	if (unlikely(align)) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 						align, 0, ap->eof, 0, ap->conv,
-						&ap->off, &ap->alen);
+						&ap->offset, &ap->length);
 		ASSERT(!error);
-		ASSERT(ap->alen);
+		ASSERT(ap->length);
 	}
 	nullfb = *ap->firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
@@ -2386,33 +2386,33 @@ xfs_bmap_btalloc(
 		if (ap->userdata && xfs_inode_is_filestream(ap->ip)) {
 			ag = xfs_filestream_lookup_ag(ap->ip);
 			ag = (ag != NULLAGNUMBER) ? ag : 0;
-			ap->rval = XFS_AGB_TO_FSB(mp, ag, 0);
+			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
 		} else {
-			ap->rval = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
+			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
 		}
 	} else
-		ap->rval = *ap->firstblock;
+		ap->blkno = *ap->firstblock;
 
 	xfs_bmap_adjacent(ap);
 
 	/*
-	 * If allowed, use ap->rval; otherwise must use firstblock since
+	 * If allowed, use ap->blkno; otherwise must use firstblock since
 	 * it's in the right allocation group.
 	 */
-	if (nullfb || XFS_FSB_TO_AGNO(mp, ap->rval) == fb_agno)
+	if (nullfb || XFS_FSB_TO_AGNO(mp, ap->blkno) == fb_agno)
 		;
 	else
-		ap->rval = *ap->firstblock;
+		ap->blkno = *ap->firstblock;
 	/*
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
 	args.tp = ap->tp;
 	args.mp = mp;
-	args.fsbno = ap->rval;
+	args.fsbno = ap->blkno;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
-	args.maxlen = MIN(ap->alen, XFS_ALLOC_AG_MAX_USABLE(mp));
+	args.maxlen = MIN(ap->length, XFS_ALLOC_AG_MAX_USABLE(mp));
 	args.firstblock = *ap->firstblock;
 	blen = 0;
 	if (nullfb) {
@@ -2433,14 +2433,14 @@ xfs_bmap_btalloc(
 	/* apply extent size hints if obtained earlier */
 	if (unlikely(align)) {
 		args.prod = align;
-		if ((args.mod = (xfs_extlen_t)do_mod(ap->off, args.prod)))
+		if ((args.mod = (xfs_extlen_t)do_mod(ap->offset, args.prod)))
 			args.mod = (xfs_extlen_t)(args.prod - args.mod);
 	} else if (mp->m_sb.sb_blocksize >= PAGE_CACHE_SIZE) {
 		args.prod = 1;
 		args.mod = 0;
 	} else {
 		args.prod = PAGE_CACHE_SIZE >> mp->m_sb.sb_blocklog;
-		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))
+		if ((args.mod = (xfs_extlen_t)(do_mod(ap->offset, args.prod))))
 			args.mod = (xfs_extlen_t)(args.prod - args.mod);
 	}
 	/*
@@ -2453,7 +2453,7 @@ xfs_bmap_btalloc(
 	 * at the end of file.
 	 */
 	if (!ap->flist->xbf_low && ap->aeof) {
-		if (!ap->off) {
+		if (!ap->offset) {
 			args.alignment = mp->m_dalign;
 			atype = args.type;
 			isaligned = 1;
@@ -2506,7 +2506,7 @@ xfs_bmap_btalloc(
 		 * turned on.
 		 */
 		args.type = atype;
-		args.fsbno = ap->rval;
+		args.fsbno = ap->blkno;
 		args.alignment = mp->m_dalign;
 		args.minlen = nextminlen;
 		args.minalignslop = 0;
@@ -2520,7 +2520,7 @@ xfs_bmap_btalloc(
 		 * try again.
 		 */
 		args.type = atype;
-		args.fsbno = ap->rval;
+		args.fsbno = ap->blkno;
 		args.alignment = 0;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
@@ -2529,7 +2529,7 @@ xfs_bmap_btalloc(
 	    args.minlen > ap->minlen) {
 		args.minlen = ap->minlen;
 		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = ap->rval;
+		args.fsbno = ap->blkno;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
@@ -2554,12 +2554,12 @@ xfs_bmap_btalloc(
 			XFS_FSB_TO_AGNO(mp, *ap->firstblock) <
 			XFS_FSB_TO_AGNO(mp, args.fsbno)));
 
-		ap->rval = args.fsbno;
+		ap->blkno = args.fsbno;
 		if (*ap->firstblock == NULLFSBLOCK)
 			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno == args.agno ||
 		       (ap->flist->xbf_low && fb_agno < args.agno));
-		ap->alen = args.len;
+		ap->length = args.len;
 		ap->ip->i_d.di_nblocks += args.len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
@@ -2573,8 +2573,8 @@ xfs_bmap_btalloc(
 					XFS_TRANS_DQ_BCOUNT,
 			(long) args.len);
 	} else {
-		ap->rval = NULLFSBLOCK;
-		ap->alen = 0;
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
 	}
 	return 0;
 }
@@ -3902,8 +3902,8 @@ xfs_bmap_isaeof(
 	 * Check if we are allocation or past the last extent, or at least into
 	 * the last delayed allocated extent.
 	 */
-	bma->aeof = bma->off >= rec.br_startoff + rec.br_blockcount ||
-		(bma->off >= rec.br_startoff &&
+	bma->aeof = bma->offset >= rec.br_startoff + rec.br_blockcount ||
+		(bma->offset >= rec.br_startoff &&
 		 isnullstartblock(rec.br_startblock));
 	return 0;
 }
@@ -4637,11 +4637,11 @@ xfs_bmapi_allocate(
 					 &bma->prev);
 		}
 	} else {
-		alen = (xfs_extlen_t)XFS_FILBLKS_MIN(bma->alen, MAXEXTLEN);
+		alen = (xfs_extlen_t)XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
 		if (!bma->eof)
 			alen = (xfs_extlen_t)XFS_FILBLKS_MIN(alen,
-					bma->got.br_startoff - bma->off);
-		aoff = bma->off;
+					bma->got.br_startoff - bma->offset);
+		aoff = bma->offset;
 	}
 
 	/*
@@ -4656,8 +4656,8 @@ xfs_bmapi_allocate(
 	/*
 	 * Fill in changeable bma fields.
 	 */
-	bma->alen = alen;
-	bma->off = aoff;
+	bma->length = alen;
+	bma->offset = aoff;
 	bma->minlen = (flags & XFS_BMAPI_CONTIG) ? alen : 1;
 	bma->aeof = 0;
 
@@ -4679,9 +4679,9 @@ xfs_bmapi_allocate(
 	/*
 	 * Copy out result fields.
 	 */
-	abno = bma->rval;
-	alen = bma->alen;
-	aoff = bma->off;
+	abno = bma->blkno;
+	alen = bma->length;
+	aoff = bma->offset;
 	if (bma->flist->xbf_low)
 		bma->minleft = 0;
 	if (*cur)
@@ -4939,15 +4939,15 @@ xfs_bmapi_write(
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
-			bma.alen = len;
-			bma.off = bno;
+			bma.length = len;
+			bma.offset = bno;
 
 			error = xfs_bmapi_allocate(&bma, &lastx, &cur, flags,
 					&nallocs, &tmp_logflags);
 			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
-			if (bma.rval == NULLFSBLOCK)
+			if (bma.blkno == NULLFSBLOCK)
 				break;
 		}
 
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-09-11 08:45:09.976455825 -0400
+++ xfs/fs/xfs/xfs_bmap.h	2011-09-11 08:45:11.129789151 -0400
@@ -111,13 +111,15 @@ static inline void xfs_bmap_init(xfs_bma
 typedef struct xfs_bmalloca {
 	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
 	struct xfs_bmap_free	*flist;	/* bmap freelist */
-	xfs_fsblock_t		rval;	/* starting block of new extent */
-	xfs_fileoff_t		off;	/* offset in file filling in */
 	struct xfs_trans	*tp;	/* transaction pointer */
 	struct xfs_inode	*ip;	/* incore inode pointer */
 	struct xfs_bmbt_irec	prev;	/* extent before the new one */
 	struct xfs_bmbt_irec	got;	/* extent after, or delayed */
-	xfs_extlen_t		alen;	/* i/o length asked/allocated */
+
+	xfs_fileoff_t		offset;	/* offset in file filling in */
+	xfs_extlen_t		length;	/* i/o length asked/allocated */
+	xfs_fsblock_t		blkno;	/* starting block of new extent */
+
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2011-09-11 08:45:09.976455825 -0400
+++ xfs/fs/xfs/xfs_filestream.c	2011-09-11 08:45:11.129789151 -0400
@@ -682,7 +682,7 @@ xfs_filestream_new_ag(
 	ip = ap->ip;
 	mp = ip->i_mount;
 	cache = mp->m_filestream;
-	minlen = ap->alen;
+	minlen = ap->length;
 	*agp = NULLAGNUMBER;
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
