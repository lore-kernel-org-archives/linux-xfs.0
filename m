Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfm1D201009 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7942016A92F3
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:46:54 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QQ76KEP1rnR9YpAJ for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:46:54 -0700 (PDT)
Message-Id: <20110918204145.781282634@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 17/27] xfs: move firstblock and bmap freelist cursor into
	bmalloca structure
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmalloca-freelist
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

Rather than passing the firstblock and freelist structure around, embed it
into the bmalloca structure and remove it from the function parameters.

This also enables the minleft parameter to be set only once in
xfs_bmapi_write(), and the freelist cursor directly queried in
xfs_bmapi_allocate to clear it when the lowspace algorithm is activated.
    
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:45:08.793122498 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:45:09.973122492 -0400
@@ -2006,9 +2006,9 @@ xfs_bmap_adjacent(
 		XFS_FSB_TO_AGBNO(mp, x) < mp->m_sb.sb_agblocks)
 
 	mp = ap->ip->i_mount;
-	nullfb = ap->firstblock == NULLFSBLOCK;
+	nullfb = *ap->firstblock == NULLFSBLOCK;
 	rt = XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata;
-	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, ap->firstblock);
+	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
 	/*
 	 * If allocating at eof, and there's a previous real block,
 	 * try to use its last block as our starting point.
@@ -2380,8 +2380,8 @@ xfs_bmap_btalloc(
 		ASSERT(!error);
 		ASSERT(ap->alen);
 	}
-	nullfb = ap->firstblock == NULLFSBLOCK;
-	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, ap->firstblock);
+	nullfb = *ap->firstblock == NULLFSBLOCK;
+	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
 	if (nullfb) {
 		if (ap->userdata && xfs_inode_is_filestream(ap->ip)) {
 			ag = xfs_filestream_lookup_ag(ap->ip);
@@ -2391,7 +2391,7 @@ xfs_bmap_btalloc(
 			ap->rval = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
 		}
 	} else
-		ap->rval = ap->firstblock;
+		ap->rval = *ap->firstblock;
 
 	xfs_bmap_adjacent(ap);
 
@@ -2402,7 +2402,7 @@ xfs_bmap_btalloc(
 	if (nullfb || XFS_FSB_TO_AGNO(mp, ap->rval) == fb_agno)
 		;
 	else
-		ap->rval = ap->firstblock;
+		ap->rval = *ap->firstblock;
 	/*
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
@@ -2413,13 +2413,13 @@ xfs_bmap_btalloc(
 
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = MIN(ap->alen, XFS_ALLOC_AG_MAX_USABLE(mp));
-	args.firstblock = ap->firstblock;
+	args.firstblock = *ap->firstblock;
 	blen = 0;
 	if (nullfb) {
 		error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
 		if (error)
 			return error;
-	} else if (ap->low) {
+	} else if (ap->flist->xbf_low) {
 		if (xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_FIRST_AG;
 		else
@@ -2452,7 +2452,7 @@ xfs_bmap_btalloc(
 	 * is >= the stripe unit and the allocation offset is
 	 * at the end of file.
 	 */
-	if (!ap->low && ap->aeof) {
+	if (!ap->flist->xbf_low && ap->aeof) {
 		if (!ap->off) {
 			args.alignment = mp->m_dalign;
 			atype = args.type;
@@ -2540,12 +2540,25 @@ xfs_bmap_btalloc(
 		args.minleft = 0;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
-		ap->low = 1;
+		ap->flist->xbf_low = 1;
 	}
 	if (args.fsbno != NULLFSBLOCK) {
-		ap->firstblock = ap->rval = args.fsbno;
+		/*
+		 * check the allocation happened at the same or higher AG than
+		 * the first block that was allocated.
+		 */
+		ASSERT(*ap->firstblock == NULLFSBLOCK ||
+		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) ==
+		       XFS_FSB_TO_AGNO(mp, args.fsbno) ||
+		       (ap->flist->xbf_low &&
+			XFS_FSB_TO_AGNO(mp, *ap->firstblock) <
+			XFS_FSB_TO_AGNO(mp, args.fsbno)));
+
+		ap->rval = args.fsbno;
+		if (*ap->firstblock == NULLFSBLOCK)
+			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno == args.agno ||
-		       (ap->low && fb_agno < args.agno));
+		       (ap->flist->xbf_low && fb_agno < args.agno));
 		ap->alen = args.len;
 		ap->ip->i_d.di_nblocks += args.len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
@@ -4596,8 +4609,6 @@ xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma,
 	xfs_extnum_t		*lastx,
 	struct xfs_btree_cur	**cur,
-	xfs_fsblock_t		*firstblock,
-	struct xfs_bmap_free	*flist,
 	int			flags,
 	int			*nallocs,
 	int			*logflags)
@@ -4647,9 +4658,7 @@ xfs_bmapi_allocate(
 	 */
 	bma->alen = alen;
 	bma->off = aoff;
-	bma->firstblock = *firstblock;
 	bma->minlen = (flags & XFS_BMAPI_CONTIG) ? alen : 1;
-	bma->low = flist->xbf_low;
 	bma->aeof = 0;
 
 	/*
@@ -4671,24 +4680,18 @@ xfs_bmapi_allocate(
 	 * Copy out result fields.
 	 */
 	abno = bma->rval;
-	flist->xbf_low = bma->low;
 	alen = bma->alen;
 	aoff = bma->off;
-	ASSERT(*firstblock == NULLFSBLOCK ||
-	       XFS_FSB_TO_AGNO(mp, *firstblock) ==
-	       XFS_FSB_TO_AGNO(mp, bma->firstblock) ||
-	       (flist->xbf_low &&
-		XFS_FSB_TO_AGNO(mp, *firstblock) <
-			XFS_FSB_TO_AGNO(mp, bma->firstblock)));
-	*firstblock = bma->firstblock;
+	if (bma->flist->xbf_low)
+		bma->minleft = 0;
 	if (*cur)
-		(*cur)->bc_private.b.firstblock = *firstblock;
+		(*cur)->bc_private.b.firstblock = *bma->firstblock;
 	if (abno == NULLFSBLOCK)
 		return 0;
 	if ((ifp->if_flags & XFS_IFBROOT) && !*cur) {
 		(*cur) = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
-		(*cur)->bc_private.b.firstblock = *firstblock;
-		(*cur)->bc_private.b.flist = flist;
+		(*cur)->bc_private.b.firstblock = *bma->firstblock;
+		(*cur)->bc_private.b.flist = bma->flist;
 	}
 	/*
 	 * Bump the number of extents we've allocated
@@ -4715,11 +4718,12 @@ xfs_bmapi_allocate(
 
 	if (bma->wasdel) {
 		error = xfs_bmap_add_extent_delay_real(bma->tp, bma->ip, lastx,
-				cur, &bma->got, firstblock, flist, logflags);
+				cur, &bma->got, bma->firstblock, bma->flist,
+				logflags);
 	} else {
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip, lastx,
-				cur, &bma->got, firstblock, flist, logflags,
-				whichfork);
+				cur, &bma->got, bma->firstblock, bma->flist,
+				logflags, whichfork);
 	}
 
 	if (error)
@@ -4746,8 +4750,6 @@ xfs_bmapi_convert_unwritten(
 	xfs_filblks_t		len,
 	xfs_extnum_t		*lastx,
 	struct xfs_btree_cur	**cur,
-	xfs_fsblock_t		*firstblock,
-	struct xfs_bmap_free	*flist,
 	int			flags,
 	int			*logflags)
 {
@@ -4776,14 +4778,14 @@ xfs_bmapi_convert_unwritten(
 	if ((ifp->if_flags & XFS_IFBROOT) && !*cur) {
 		*cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
 					bma->ip, whichfork);
-		(*cur)->bc_private.b.firstblock = *firstblock;
-		(*cur)->bc_private.b.flist = flist;
+		(*cur)->bc_private.b.firstblock = *bma->firstblock;
+		(*cur)->bc_private.b.flist = bma->flist;
 	}
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
 
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, lastx,
-			cur, mval, firstblock, flist, logflags);
+			cur, mval, bma->firstblock, bma->flist, logflags);
 	if (error)
 		return error;
 
@@ -4838,7 +4840,6 @@ xfs_bmapi_write(
 	int			error;		/* error return */
 	xfs_extnum_t		lastx;		/* last useful extent number */
 	int			logflags;	/* flags for transaction logging */
-	xfs_extlen_t		minleft;	/* min blocks left after allocation */
 	int			n;		/* current extent index */
 	int			nallocs;	/* number of extents alloc'd */
 	xfs_fileoff_t		obno;		/* old block number (offset) */
@@ -4900,11 +4901,11 @@ xfs_bmapi_write(
 
 	if (*firstblock == NULLFSBLOCK) {
 		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
-			minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+			bma.minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 		else
-			minleft = 1;
+			bma.minleft = 1;
 	} else {
-		minleft = 0;
+		bma.minleft = 0;
 	}
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -4923,6 +4924,8 @@ xfs_bmapi_write(
 	bma.ip = ip;
 	bma.total = total;
 	bma.userdata = 0;
+	bma.flist = flist;
+	bma.firstblock = firstblock;
 
 	while (bno < end && n < *nmap) {
 		inhole = eof || bma.got.br_startoff > bno;
@@ -4938,16 +4941,12 @@ xfs_bmapi_write(
 			bma.wasdel = wasdelay;
 			bma.alen = len;
 			bma.off = bno;
-			bma.minleft = minleft;
 
-			error = xfs_bmapi_allocate(&bma, &lastx, &cur,
-					firstblock, flist, flags, &nallocs,
-					&tmp_logflags);
+			error = xfs_bmapi_allocate(&bma, &lastx, &cur, flags,
+					&nallocs, &tmp_logflags);
 			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
-			if (flist && flist->xbf_low)
-				minleft = 0;
 			if (bma.rval == NULLFSBLOCK)
 				break;
 		}
@@ -4958,8 +4957,7 @@ xfs_bmapi_write(
 
 		/* Execute unwritten extent conversion if necessary */
 		error = xfs_bmapi_convert_unwritten(&bma, mval, len, &lastx,
-						    &cur, firstblock, flist,
-						    flags, &tmp_logflags);
+						    &cur, flags, &tmp_logflags);
 		logflags |= tmp_logflags;
 		if (error == EAGAIN)
 			continue;
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-09-11 08:45:08.793122498 -0400
+++ xfs/fs/xfs/xfs_bmap.h	2011-09-11 08:45:09.976455825 -0400
@@ -109,7 +109,8 @@ static inline void xfs_bmap_init(xfs_bma
  * Argument structure for xfs_bmap_alloc.
  */
 typedef struct xfs_bmalloca {
-	xfs_fsblock_t		firstblock; /* i/o first block allocated */
+	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
+	struct xfs_bmap_free	*flist;	/* bmap freelist */
 	xfs_fsblock_t		rval;	/* starting block of new extent */
 	xfs_fileoff_t		off;	/* offset in file filling in */
 	struct xfs_trans	*tp;	/* transaction pointer */
@@ -123,7 +124,6 @@ typedef struct xfs_bmalloca {
 	char			eof;	/* set if allocating past last extent */
 	char			wasdel;	/* replacing a delayed allocation */
 	char			userdata;/* set if is user data */
-	char			low;	/* low on space, using seq'l ags */
 	char			aeof;	/* allocated space at eof */
 	char			conv;	/* overwriting unwritten extents */
 } xfs_bmalloca_t;
Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2011-09-11 08:38:34.256458188 -0400
+++ xfs/fs/xfs/xfs_filestream.c	2011-09-11 08:45:09.976455825 -0400
@@ -761,7 +761,7 @@ xfs_filestream_new_ag(
 	 */
 	ag = (ag == NULLAGNUMBER) ? 0 : (ag + 1) % mp->m_sb.sb_agcount;
 	flags = (ap->userdata ? XFS_PICK_USERDATA : 0) |
-	        (ap->low ? XFS_PICK_LOWSPACE : 0);
+	        (ap->flist->xbf_low ? XFS_PICK_LOWSPACE : 0);
 
 	err = _xfs_filestream_pick_ag(mp, ag, agp, flags, minlen);
 	if (err || *agp == NULLAGNUMBER)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
