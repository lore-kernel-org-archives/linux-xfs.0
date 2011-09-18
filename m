Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfmBY201011 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA66217206C
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:47 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GrFyIXRbhPvPeyXn for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:47 -0700 (PDT)
Message-Id: <20110918204147.015140236@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:41:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 23/27] rearrange bmapi and bmalloca structures for best packing
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmalloca-shrink
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

Minimise the stack overhead of the remaining stack variables and
structures placed on the stack by packing them without holes. pahole
is used to optimise allocation args structures, stack variables are
done manually.

[hch: various updates while forward porting the changes]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-09-11 08:46:48.000000000 -0400
+++ xfs/fs/xfs/xfs_bmap.h	2011-09-11 09:06:45.279781419 -0400
@@ -118,6 +118,7 @@ typedef struct xfs_bmalloca {
 
 	xfs_fileoff_t		offset;	/* offset in file filling in */
 	xfs_extlen_t		length;	/* i/o length asked/allocated */
+	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_fsblock_t		blkno;	/* starting block of new extent */
 
 	struct xfs_btree_cur	*cur;	/* btree cursor */
@@ -125,14 +126,13 @@ typedef struct xfs_bmalloca {
 	int			nallocs;/* number of extents alloc'd */
 	int			logflags;/* flags for transaction logging */
 
-	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
-	xfs_extlen_t		minleft; /* amount must be left after alloc */
-	char			eof;	/* set if allocating past last extent */
-	char			wasdel;	/* replacing a delayed allocation */
-	char			userdata;/* set if is user data */
-	char			aeof;	/* allocated space at eof */
-	char			conv;	/* overwriting unwritten extents */
+	xfs_extlen_t		minleft;/* amount must be left after alloc */
+	unsigned int		eof : 1;/* set if allocating past last extent */
+	unsigned int		wasdel : 1;  /* replacing a delayed allocation */
+	unsigned int		userdata : 1;/* set if is user data */
+	unsigned int		aeof : 1;/* allocated space at eof */
+	unsigned int		conv : 1;/* overwriting unwritten extents */
 } xfs_bmalloca_t;
 
 /*
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:47:11.743121736 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 09:05:37.706448434 -0400
@@ -2359,11 +2359,11 @@ xfs_bmap_btalloc(
 	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
+	xfs_alloc_arg_t	args;
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
 	xfs_extlen_t	align;		/* minimum allocation alignment */
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	ag;
-	xfs_alloc_arg_t	args;
 	xfs_extlen_t	blen;
 	xfs_extlen_t	nextminlen = 0;
 	int		nullfb;		/* true if ap->firstblock isn't set */
@@ -4813,30 +4813,19 @@ xfs_bmapi_write(
 	int			*nmap,		/* i/o: mval size/count */
 	struct xfs_bmap_free	*flist)		/* i/o: list extents to free */
 {
+	struct xfs_bmalloca	bma = { 0 };	/* args for xfs_bmap_alloc */
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
-	struct xfs_bmalloca	bma = { 0 };	/* args for xfs_bmap_alloc */
 	xfs_fileoff_t		end;		/* end of mapped file region */
-	int			eof;		/* after the end of extents */
-	int			error;		/* error return */
-	int			n;		/* current extent index */
 	xfs_fileoff_t		obno;		/* old block number (offset) */
+	int			error;		/* error return */
+	int			n = 0;		/* current extent index */
 	int			whichfork;	/* data or attr fork */
-	char			inhole;		/* current location is hole in file */
-	char			wasdelay;	/* old extent was delayed */
-
 #ifdef DEBUG
-	xfs_fileoff_t		orig_bno;	/* original block number value */
-	int			orig_flags;	/* original flags arg value */
-	xfs_filblks_t		orig_len;	/* original value of len arg */
-	struct xfs_bmbt_irec	*orig_mval;	/* original value of mval */
-	int			orig_nmap;	/* original value of *nmap */
-
-	orig_bno = bno;
-	orig_len = len;
-	orig_flags = flags;
-	orig_mval = mval;
-	orig_nmap = *nmap;
+	xfs_fileoff_t		orig_bno = bno;
+	xfs_filblks_t		orig_len = len;
+	struct xfs_bmbt_irec	*orig_mval = mval;
+	int			orig_nmap = *nmap;
 #endif
 
 	ASSERT(*nmap >= 1);
@@ -4887,11 +4876,9 @@ xfs_bmapi_write(
 			goto error0;
 	}
 
-	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &bma.idx, &bma.got,
+	/* we abuse n as a local variable for eof, as bma.eof is a bitfield */
+	xfs_bmap_search_extents(ip, bno, whichfork, &n, &bma.idx, &bma.got,
 				&bma.prev);
-	n = 0;
-	end = bno + len;
-	obno = bno;
 
 	bma.tp = tp;
 	bma.ip = ip;
@@ -4899,19 +4886,21 @@ xfs_bmapi_write(
 	bma.userdata = 0;
 	bma.flist = flist;
 	bma.firstblock = firstblock;
+	bma.eof = n;
+	bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 
+	n = 0;
+	end = bno + len;
+	obno = bno;
 	while (bno < end && n < *nmap) {
-		inhole = eof || bma.got.br_startoff > bno;
-		wasdelay = !inhole && isnullstartblock(bma.got.br_startblock);
-
 		/*
-		 * First, deal with the hole before the allocated space
-		 * that we found, if any.
+		 * If we are past EOF, in a hole in a delayed allocation call
+		 * the allocator to get us a real allocation first.
 		 */
-		if (inhole || wasdelay) {
-			bma.eof = eof;
-			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
-			bma.wasdel = wasdelay;
+		if (bma.eof || bma.got.br_startoff > bno ||
+		    isnullstartblock(bma.got.br_startblock)) {
+			bma.wasdel = isnullstartblock(bma.got.br_startblock) &&
+					!bma.eof && bma.got.br_startoff <= bno;
 			bma.length = len;
 			bma.offset = bno;
 
@@ -4950,7 +4939,7 @@ xfs_bmapi_write(
 			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma.idx),
 					 &bma.got);
 		} else
-			eof = 1;
+			bma.eof = 1;
 	}
 	*nmap = n;
 
@@ -5008,7 +4997,7 @@ error0:
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	}
 	if (!error)
-		xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
+		xfs_bmap_validate_ret(orig_bno, orig_len, flags, orig_mval,
 			orig_nmap, *nmap);
 	return error;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
