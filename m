Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66j4Y014507 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1BB410519D
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sDuLnVT4T8c3olnk for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:43 -0700 (PDT)
Message-Id: <20110824060642.912147073@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/25] xfs: rename xfs_bmapi to xfs_bmapi_write
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-rename-xfs_bmapi
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

Once this is done, rename xfs_bmapi to xfs_bmapi_write to reflect the fact it
is for allocation only. This enables us to kill the XFS_BMAPI_WRITE flag as
well.

Also clean up xfs_bmapi_write to the style used in the newly added
xfs_bmapi_read/delay functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-23 21:09:32.900387547 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-23 21:13:59.315610918 +0200
@@ -379,14 +379,12 @@ xfs_qm_dqalloc(
 
 	xfs_trans_ijoin_ref(tp, quotip, XFS_ILOCK_EXCL);
 	nmaps = 1;
-	if ((error = xfs_bmapi(tp, quotip,
-			      offset_fsb, XFS_DQUOT_CLUSTER_SIZE_FSB,
-			      XFS_BMAPI_METADATA | XFS_BMAPI_WRITE,
-			      &firstblock,
-			      XFS_QM_DQALLOC_SPACE_RES(mp),
-			      &map, &nmaps, &flist))) {
+	error = xfs_bmapi_write(tp, quotip, offset_fsb,
+				XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
+				&firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
+				&map, &nmaps, &flist);
+	if (error)
 		goto error0;
-	}
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
 	ASSERT(nmaps == 1);
 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-08-23 21:09:32.000000000 +0200
+++ xfs/fs/xfs/xfs_attr.c	2011-08-23 21:13:59.315610918 +0200
@@ -2039,10 +2039,9 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
-		error = xfs_bmapi(args->trans, dp, (xfs_fileoff_t)lblkno,
+		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt,
-				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA |
-							XFS_BMAPI_WRITE,
+				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 				  args->firstblock, args->total, &map, &nmap,
 				  args->flist);
 		if (!error) {
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:13:35.000000000 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:13:59.318944234 +0200
@@ -4211,9 +4211,8 @@ xfs_bmap_validate_ret(
 		ASSERT(i == 0 ||
 		       mval[i - 1].br_startoff + mval[i - 1].br_blockcount ==
 		       mval[i].br_startoff);
-		if (flags & XFS_BMAPI_WRITE)
-			ASSERT(mval[i].br_startblock != DELAYSTARTBLOCK &&
-			       mval[i].br_startblock != HOLESTARTBLOCK);
+		ASSERT(mval[i].br_startblock != DELAYSTARTBLOCK &&
+		       mval[i].br_startblock != HOLESTARTBLOCK);
 		ASSERT(mval[i].br_state == XFS_EXT_NORM ||
 		       mval[i].br_state == XFS_EXT_UNWRITTEN);
 	}
@@ -4806,60 +4805,57 @@ xfs_bmapi_convert_unwritten(
 }
 
 /*
- * Map file blocks to filesystem blocks.
- * File range is given by the bno/len pair.
- * Adds blocks to file if a write ("flags & XFS_BMAPI_WRITE" set)
- * into a hole or past eof.
- * Only allocates blocks from a single allocation group,
- * to avoid locking problems.
+ * Map file blocks to filesystem blocks, and allocate blocks or convert the
+ * extent state if nessecary.  Details behaviour is controlled by the flags
+ * paramter.  Only allocates blocks from a single allocation group, to avoid
+ * locking problems.
+ *
  * The returned value in "firstblock" from the first call in a transaction
  * must be remembered and presented to subsequent calls in "firstblock".
  * An upper bound for the number of blocks to be allocated is supplied to
  * the first call in "total"; if no allocation group has that many free
  * blocks then the call will fail (return NULLFSBLOCK in "firstblock").
  */
-int					/* error */
-xfs_bmapi(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_inode_t	*ip,		/* incore inode */
-	xfs_fileoff_t	bno,		/* starting file offs. mapped */
-	xfs_filblks_t	len,		/* length to map in file */
-	int		flags,		/* XFS_BMAPI_... */
-	xfs_fsblock_t	*firstblock,	/* first allocated block
-					   controls a.g. for allocs */
-	xfs_extlen_t	total,		/* total blocks needed */
-	xfs_bmbt_irec_t	*mval,		/* output: map values */
-	int		*nmap,		/* i/o: mval size/count */
-	xfs_bmap_free_t	*flist)		/* i/o: list extents to free */
+int
+xfs_bmapi_write(
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* incore inode */
+	xfs_fileoff_t		bno,		/* starting file offs. mapped */
+	xfs_filblks_t		len,		/* length to map in file */
+	int			flags,		/* XFS_BMAPI_... */
+	xfs_fsblock_t		*firstblock,	/* first allocated block
+						   controls a.g. for allocs */
+	xfs_extlen_t		total,		/* total blocks needed */
+	struct xfs_bmbt_irec	*mval,		/* output: map values */
+	int			*nmap,		/* i/o: mval size/count */
+	struct xfs_bmap_free	*flist)		/* i/o: list extents to free */
 {
-	xfs_bmalloca_t	bma = { 0 };	/* args for xfs_bmap_alloc */
-	xfs_btree_cur_t	*cur;		/* bmap btree cursor */
-	xfs_fileoff_t	end;		/* end of mapped file region */
-	int		eof;		/* we've hit the end of extents */
-	xfs_bmbt_rec_host_t *ep;	/* extent record pointer */
-	int		error;		/* error return */
-	xfs_bmbt_irec_t	got;		/* current file extent record */
-	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_extnum_t	lastx;		/* last useful extent number */
-	int		logflags;	/* flags for transaction logging */
-	xfs_extlen_t	minleft;	/* min blocks left after allocation */
-	xfs_mount_t	*mp;		/* xfs mount structure */
-	int		n;		/* current extent index */
-	int		nallocs;	/* number of extents alloc'd */
-	xfs_fileoff_t	obno;		/* old block number (offset) */
-	xfs_bmbt_irec_t	prev;		/* previous file extent record */
-	int		tmp_logflags;	/* temp flags holder */
-	int		whichfork;	/* data or attr fork */
-	char		inhole;		/* current location is hole in file */
-	char		wasdelay;	/* old extent was delayed */
-	char		wr;		/* this is a write request */
-	char		rt;		/* this is a realtime file */
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmalloca	bma = { 0 };	/* args for xfs_bmap_alloc */
+	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
+	xfs_fileoff_t		end;		/* end of mapped file region */
+	int			eof;		/* after the end of extents */
+	int			error;		/* error return */
+	struct xfs_bmbt_irec	got;		/* current file extent record */
+	xfs_ifork_t		*ifp;		/* inode fork pointer */
+	xfs_extnum_t		lastx;		/* last useful extent number */
+	int			logflags;	/* flags for transaction logging */
+	xfs_extlen_t		minleft;	/* min blocks left after allocation */
+	int			n;		/* current extent index */
+	int			nallocs;	/* number of extents alloc'd */
+	xfs_fileoff_t		obno;		/* old block number (offset) */
+	struct xfs_bmbt_irec	prev;		/* previous file extent record */
+	int			tmp_logflags;	/* temp flags holder */
+	int			whichfork;	/* data or attr fork */
+	char			inhole;		/* current location is hole in file */
+	char			wasdelay;	/* old extent was delayed */
+
 #ifdef DEBUG
-	xfs_fileoff_t	orig_bno;	/* original block number value */
-	int		orig_flags;	/* original flags arg value */
-	xfs_filblks_t	orig_len;	/* original value of len arg */
-	xfs_bmbt_irec_t	*orig_mval;	/* original value of mval */
-	int		orig_nmap;	/* original value of *nmap */
+	xfs_fileoff_t		orig_bno;	/* original block number value */
+	int			orig_flags;	/* original flags arg value */
+	xfs_filblks_t		orig_len;	/* original value of len arg */
+	struct xfs_bmbt_irec	*orig_mval;	/* original value of mval */
+	int			orig_nmap;	/* original value of *nmap */
 
 	orig_bno = bno;
 	orig_len = len;
@@ -4867,69 +4863,60 @@ xfs_bmapi(
 	orig_mval = mval;
 	orig_nmap = *nmap;
 #endif
+
 	ASSERT(*nmap >= 1);
-	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP || !(flags & XFS_BMAPI_WRITE));
+	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
+	ASSERT(!(flags & XFS_BMAPI_IGSTATE));
+	ASSERT(tp != NULL);
+
 	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 		XFS_ATTR_FORK : XFS_DATA_FORK;
-	mp = ip->i_mount;
+
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
 	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
 	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmapi", XFS_ERRLEVEL_LOW, mp);
+		XFS_ERROR_REPORT("xfs_bmapi_write", XFS_ERRLEVEL_LOW, mp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
+
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
-	rt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(ifp->if_ext_max ==
 	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
-	if ((wr = (flags & XFS_BMAPI_WRITE)) != 0)
-		XFS_STATS_INC(xs_blk_mapw);
-	else
-		XFS_STATS_INC(xs_blk_mapr);
-	/*
-	 * IGSTATE flag is used to combine extents which
-	 * differ only due to the state of the extents.
-	 * This technique is used from xfs_getbmap()
-	 * when the caller does not wish to see the
-	 * separation (which is the default).
-	 *
-	 * This technique is also used when writing a
-	 * buffer which has been partially written,
-	 * (usually by being flushed during a chunkread),
-	 * to ensure one write takes place. This also
-	 * prevents a change in the xfs inode extents at
-	 * this time, intentionally. This change occurs
-	 * on completion of the write operation, in
-	 * xfs_strat_comp(), where the xfs_bmapi() call
-	 * is transactioned, and the extents combined.
-	 */
-	if ((flags & XFS_BMAPI_IGSTATE) && wr)	/* if writing unwritten space */
-		wr = 0;				/* no allocations are allowed */
+
+	XFS_STATS_INC(xs_blk_mapw);
+
 	logflags = 0;
 	nallocs = 0;
 	cur = NULL;
+
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(wr && tp);
-		if ((error = xfs_bmap_local_to_extents(tp, ip,
-				firstblock, total, &logflags, whichfork)))
+		error = xfs_bmap_local_to_extents(tp, ip, firstblock, total,
+						  &logflags, whichfork);
+		if (error)
 			goto error0;
 	}
-	if (wr && *firstblock == NULLFSBLOCK) {
+
+	if (*firstblock == NULLFSBLOCK) {
 		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
 			minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 		else
 			minleft = 1;
-	} else
+	} else {
 		minleft = 0;
-	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
-	    (error = xfs_iread_extents(tp, ip, whichfork)))
-		goto error0;
-	ep = xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got,
-		&prev);
+	}
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(tp, ip, whichfork);
+		if (error)
+			goto error0;
+	}
+
+	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got, &prev);
 	n = 0;
 	end = bno + len;
 	obno = bno;
@@ -4942,19 +4929,14 @@ xfs_bmapi(
 	bma.userdata = 0;
 
 	while (bno < end && n < *nmap) {
-		/*
-		 * Reading past eof, act as though there's a hole
-		 * up to end.
-		 */
-		if (eof && !wr)
-			got.br_startoff = end;
 		inhole = eof || got.br_startoff > bno;
-		wasdelay = wr && !inhole && isnullstartblock(got.br_startblock);
+		wasdelay = !inhole && isnullstartblock(got.br_startblock);
+
 		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
 		 */
-		if (wr && (inhole || wasdelay)) {
+		if (inhole || wasdelay) {
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
@@ -4980,36 +4962,20 @@ xfs_bmapi(
 				minleft = 0;
 			if (bma.rval == NULLFSBLOCK)
 				break;
-		} else if (inhole) {
-			/*
-			 * Reading in a hole.
-			 */
-			mval->br_startoff = bno;
-			mval->br_startblock = HOLESTARTBLOCK;
-			mval->br_blockcount =
-				XFS_FILBLKS_MIN(len, got.br_startoff - bno);
-			mval->br_state = XFS_EXT_NORM;
-			bno += mval->br_blockcount;
-			len -= mval->br_blockcount;
-			mval++;
-			n++;
-			continue;
 		}
 
 		/* Deal with the allocated space we found.  */
 		xfs_bmapi_trim_map(mval, &got, &bno, len, obno, end, n, flags);
 
 		/* Execute unwritten extent conversion if necessary */
-		if (wr) {
-			error = xfs_bmapi_convert_unwritten(&bma, mval, len,
-						&lastx, &cur, firstblock, flist, flags,
-						&tmp_logflags);
-			logflags |= tmp_logflags;
-			if (error == EAGAIN)
-				continue;
-			if (error)
-				goto error0;
-		}
+		error = xfs_bmapi_convert_unwritten(&bma, mval, len, &lastx,
+						    &cur, firstblock, flist,
+						    flags, &tmp_logflags);
+		logflags |= tmp_logflags;
+		if (error == EAGAIN)
+			continue;
+		if (error)
+			goto error0;
 
 		/* update the extent map to return */
 		xfs_bmapi_update_map(&mval, &bno, &len, obno, end, &n, flags);
@@ -5021,24 +4987,22 @@ xfs_bmapi(
 		 */
 		if (bno >= end || n >= *nmap || nallocs >= *nmap)
 			break;
-		/*
-		 * Else go on to the next record.
-		 */
+
+		/* Else go on to the next record. */
 		prev = got;
-		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) {
-			ep = xfs_iext_get_ext(ifp, lastx);
-			xfs_bmbt_get_all(ep, &got);
-		} else {
+		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
+		else
 			eof = 1;
-		}
 	}
 	*nmap = n;
+
 	/*
 	 * Transform from btree to extents, give it cur.
 	 */
-	if (tp && XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
+	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
 	    XFS_IFORK_NEXTENTS(ip, whichfork) <= ifp->if_ext_max) {
-		ASSERT(wr && cur);
+		ASSERT(cur);
 		error = xfs_bmap_btree_to_extents(tp, ip, cur,
 			&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
@@ -5066,10 +5030,9 @@ error0:
 	 * detecting a case where the data is changed, there's an error,
 	 * and it's not logged so we don't shutdown when we should.
 	 */
-	if (logflags) {
-		ASSERT(tp && wr);
+	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
-	}
+
 	if (cur) {
 		if (!error) {
 			ASSERT(*firstblock == NULLFSBLOCK ||
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-08-23 21:12:59.000000000 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-08-23 21:13:59.318944234 +0200
@@ -62,25 +62,23 @@ typedef	struct xfs_bmap_free
 #define	XFS_BMAP_MAX_NMAP	4
 
 /*
- * Flags for xfs_bmapi
+ * Flags for xfs_bmapi_*
  */
-#define	XFS_BMAPI_WRITE		0x001	/* write operation: allocate space */
-#define XFS_BMAPI_ENTIRE	0x004	/* return entire extent, not trimmed */
-#define XFS_BMAPI_METADATA	0x008	/* mapping metadata not user data */
-#define XFS_BMAPI_ATTRFORK	0x010	/* use attribute fork not data */
-#define	XFS_BMAPI_PREALLOC	0x040	/* preallocation op: unwritten space */
-#define	XFS_BMAPI_IGSTATE	0x080	/* Ignore state - */
+#define XFS_BMAPI_ENTIRE	0x001	/* return entire extent, not trimmed */
+#define XFS_BMAPI_METADATA	0x002	/* mapping metadata not user data */
+#define XFS_BMAPI_ATTRFORK	0x004	/* use attribute fork not data */
+#define XFS_BMAPI_PREALLOC	0x008	/* preallocation op: unwritten space */
+#define XFS_BMAPI_IGSTATE	0x010	/* Ignore state - */
 					/* combine contig. space */
-#define	XFS_BMAPI_CONTIG	0x100	/* must allocate only one extent */
+#define XFS_BMAPI_CONTIG	0x020	/* must allocate only one extent */
 /*
  * unwritten extent conversion - this needs write cache flushing and no additional
  * allocation alignments. When specified with XFS_BMAPI_PREALLOC it converts
  * from written to unwritten, otherwise convert from unwritten to written.
  */
-#define XFS_BMAPI_CONVERT	0x200
+#define XFS_BMAPI_CONVERT	0x040
 
 #define XFS_BMAPI_FLAGS \
-	{ XFS_BMAPI_WRITE,	"WRITE" }, \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
 	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
@@ -265,39 +263,17 @@ xfs_bmap_read_extents(
 	struct xfs_inode	*ip,		/* incore inode */
 	int			whichfork);	/* data or attr fork */
 
-/*
- * Map file blocks to filesystem blocks.
- * File range is given by the bno/len pair.
- * Adds blocks to file if a write ("flags & XFS_BMAPI_WRITE" set)
- * into a hole or past eof.
- * Only allocates blocks from a single allocation group,
- * to avoid locking problems.
- * The returned value in "firstblock" from the first call in a transaction
- * must be remembered and presented to subsequent calls in "firstblock".
- * An upper bound for the number of blocks to be allocated is supplied to
- * the first call in "total"; if no allocation group has that many free
- * blocks then the call will fail (return NULLFSBLOCK in "firstblock").
- */
-int						/* error */
-xfs_bmapi(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* incore inode */
-	xfs_fileoff_t		bno,		/* starting file offs. mapped */
-	xfs_filblks_t		len,		/* length to map in file */
-	int			flags,		/* XFS_BMAPI_... */
-	xfs_fsblock_t		*firstblock,	/* first allocated block
-						   controls a.g. for allocs */
-	xfs_extlen_t		total,		/* total blocks needed */
-	struct xfs_bmbt_irec	*mval,		/* output: map values */
-	int			*nmap,		/* i/o: mval size/count */
-	xfs_bmap_free_t		*flist);	/* i/o: list extents to free */
-
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
 int	xfs_bmapi_delay(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
+int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
+		xfs_fsblock_t *firstblock, xfs_extlen_t total,
+		struct xfs_bmbt_irec *mval, int *nmap,
+		struct xfs_bmap_free *flist);
 
 /*
  * Unmap (remove) blocks from a file.
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-08-23 21:10:14.000000000 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2011-08-23 21:13:59.322277549 +0200
@@ -1578,9 +1578,8 @@ xfs_da_grow_inode_int(
 	 */
 	nmap = 1;
 	ASSERT(args->firstblock != NULL);
-	error = xfs_bmapi(tp, dp, *bno, count,
-			xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
-			XFS_BMAPI_CONTIG,
+	error = xfs_bmapi_write(tp, dp, *bno, count,
+			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
 			args->flist);
 	if (error)
@@ -1602,9 +1601,8 @@ xfs_da_grow_inode_int(
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			nmap = MIN(XFS_BMAP_MAX_NMAP, count);
 			c = (int)(*bno + count - b);
-			error = xfs_bmapi(tp, dp, b, c,
-					xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|
-					XFS_BMAPI_METADATA,
+			error = xfs_bmapi_write(tp, dp, b, c,
+					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
 					&mapp[mapi], &nmap, args->flist);
 			if (error)
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2011-08-23 21:12:59.000000000 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2011-08-23 21:13:59.325610864 +0200
@@ -210,20 +210,18 @@ xfs_iomap_write_direct(
 
 	xfs_trans_ijoin(tp, ip);
 
-	bmapi_flag = XFS_BMAPI_WRITE;
+	bmapi_flag = 0;
 	if (offset < ip->i_size || extsz)
 		bmapi_flag |= XFS_BMAPI_PREALLOC;
 
 	/*
-	 * Issue the xfs_bmapi() call to allocate the blocks.
-	 *
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
 	 */
 	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
-	error = xfs_bmapi(tp, ip, offset_fsb, count_fsb, bmapi_flag,
-		&firstfsb, 0, imap, &nimaps, &free_list);
+	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flag,
+				&firstfsb, 0, imap, &nimaps, &free_list);
 	if (error)
 		goto error0;
 
@@ -582,14 +580,12 @@ xfs_iomap_write_allocate(
 			}
 
 			/*
-			 * Go get the actual blocks.
-	 	 	 *
 			 * From this point onwards we overwrite the imap
 			 * pointer that the caller gave to us.
 			 */
-			error = xfs_bmapi(tp, ip, map_start_fsb, count_fsb,
-					XFS_BMAPI_WRITE, &first_block, 1,
-					imap, &nimaps, &free_list);
+			error = xfs_bmapi_write(tp, ip, map_start_fsb,
+						count_fsb, 0, &first_block, 1,
+						imap, &nimaps, &free_list);
 			if (error)
 				goto trans_cancel;
 
@@ -703,8 +699,8 @@ xfs_iomap_write_unwritten(
 		 */
 		xfs_bmap_init(&free_list, &firstfsb);
 		nimaps = 1;
-		error = xfs_bmapi(tp, ip, offset_fsb, count_fsb,
-				  XFS_BMAPI_WRITE|XFS_BMAPI_CONVERT, &firstfsb,
+		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
+				  XFS_BMAPI_CONVERT, &firstfsb,
 				  1, &imap, &nimaps, &free_list);
 		if (error)
 			goto error_on_bmapi_transaction;
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2011-08-23 21:12:01.000000000 +0200
+++ xfs/fs/xfs/xfs_rtalloc.c	2011-08-23 21:13:59.328944179 +0200
@@ -120,9 +120,9 @@ xfs_growfs_rt_alloc(
 		 */
 		nmap = 1;
 		cancelflags |= XFS_TRANS_ABORT;
-		error = xfs_bmapi(tp, ip, oblocks, nblocks - oblocks,
-			XFS_BMAPI_WRITE | XFS_BMAPI_METADATA, &firstblock,
-			resblks, &map, &nmap, &flist);
+		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
+					XFS_BMAPI_METADATA, &firstblock,
+					resblks, &map, &nmap, &flist);
 		if (!error && nmap < 1)
 			error = XFS_ERROR(ENOSPC);
 		if (error)
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-08-23 21:09:32.000000000 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-08-23 21:13:59.332277494 +0200
@@ -1629,10 +1629,9 @@ xfs_symlink(
 		first_fsb = 0;
 		nmaps = SYMLINK_MAPS;
 
-		error = xfs_bmapi(tp, ip, first_fsb, fs_blocks,
-				  XFS_BMAPI_WRITE | XFS_BMAPI_METADATA,
-				  &first_block, resblks, mval, &nmaps,
-				  &free_list);
+		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
+				  XFS_BMAPI_METADATA, &first_block, resblks,
+				  mval, &nmaps, &free_list);
 		if (error)
 			goto error2;
 
@@ -1775,7 +1774,6 @@ xfs_alloc_file_space(
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_fsblock_t		firstfsb;
 	int			nimaps;
-	int			bmapi_flag;
 	int			quota_flag;
 	int			rt;
 	xfs_trans_t		*tp;
@@ -1803,7 +1801,6 @@ xfs_alloc_file_space(
 	count = len;
 	imapp = &imaps[0];
 	nimaps = 1;
-	bmapi_flag = XFS_BMAPI_WRITE | alloc_type;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
 	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
 
@@ -1876,14 +1873,10 @@ xfs_alloc_file_space(
 
 		xfs_trans_ijoin(tp, ip);
 
-		/*
-		 * Issue the xfs_bmapi() call to allocate the blocks
-		 */
 		xfs_bmap_init(&free_list, &firstfsb);
-		error = xfs_bmapi(tp, ip, startoffset_fsb,
-				  allocatesize_fsb, bmapi_flag,
-				  &firstfsb, 0, imapp, &nimaps,
-				  &free_list);
+		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
+					allocatesize_fsb, alloc_type, &firstfsb,
+					0, imapp, &nimaps, &free_list);
 		if (error) {
 			goto error0;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
