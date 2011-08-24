Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66i40014459 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5C40105197
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5vXsurYcYUGRdBA9 for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6bq-0005Av-15
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:06:42 +0000
Message-Id: <20110824060641.979845427@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/25] xfs: introduce xfs_bmapi_delay()
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-add-xfs_bmapi_delay
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

Delalloc reservations are much simpler than allocations, so give them a
separate bmapi-level interface.  Using the previously added
xfs_bmapi_reserve_delalloc we get a function that is only minimally
more complicated than xfs_bmapi_read, which is far from the complexity
in xfs_bmapi.  Also remove the XFS_BMAPI_DELAY code after switching
over the only user to xfs_bmapi_delay.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:12:56.272619118 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:12:59.355935746 +0200
@@ -4238,7 +4238,7 @@ xfs_bmap_validate_ret(
 		ASSERT(i == 0 ||
 		       mval[i - 1].br_startoff + mval[i - 1].br_blockcount ==
 		       mval[i].br_startoff);
-		if ((flags & XFS_BMAPI_WRITE) && !(flags & XFS_BMAPI_DELAY))
+		if (flags & XFS_BMAPI_WRITE)
 			ASSERT(mval[i].br_startblock != DELAYSTARTBLOCK &&
 			       mval[i].br_startblock != HOLESTARTBLOCK);
 		ASSERT(mval[i].br_state == XFS_EXT_NORM ||
@@ -4553,6 +4553,90 @@ out_unreserve_quota:
 }
 
 /*
+ * Map file blocks to filesystem blocks, adding delayed allocations as needed.
+ */
+int
+xfs_bmapi_delay(
+	struct xfs_inode	*ip,	/* incore inode */
+	xfs_fileoff_t		bno,	/* starting file offs. mapped */
+	xfs_filblks_t		len,	/* length to map in file */
+	struct xfs_bmbt_irec	*mval,	/* output: map values */
+	int			*nmap,	/* i/o: mval size/count */
+	int			flags)	/* XFS_BMAPI_... */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_bmbt_irec	got;	/* current file extent record */
+	struct xfs_bmbt_irec	prev;	/* previous file extent record */
+	xfs_fileoff_t		obno;	/* old block number (offset) */
+	xfs_fileoff_t		end;	/* end of mapped file region */
+	xfs_extnum_t		lastx;	/* last useful extent number */
+	int			eof;	/* we've hit the end of extents */
+	int			n = 0;	/* current extent index */
+	int			error = 0;
+
+	ASSERT(*nmap >= 1);
+	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
+	ASSERT(!(flags & ~XFS_BMAPI_ENTIRE));
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_bmapi_delay", XFS_ERRLEVEL_LOW, mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	XFS_STATS_INC(xs_blk_mapw);
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	xfs_bmap_search_extents(ip, bno, XFS_DATA_FORK, &eof, &lastx, &got, &prev);
+	end = bno + len;
+	obno = bno;
+
+	while (bno < end && n < *nmap) {
+		if (eof || got.br_startoff > bno) {
+			error = xfs_bmapi_reserve_delalloc(ip, bno, len, &got,
+							   &prev, &lastx, eof);
+			if (error) {
+				if (n == 0) {
+					*nmap = 0;
+					return error;
+				}
+				break;
+			}
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
+		prev = got;
+		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
+		else
+			eof = 1;
+	}
+
+	*nmap = n;
+	return 0;
+}
+
+
+/*
  * Map file blocks to filesystem blocks.
  * File range is given by the bno/len pair.
  * Adds blocks to file if a write ("flags & XFS_BMAPI_WRITE" set)
@@ -4660,7 +4744,6 @@ xfs_bmapi(
 	 */
 	if ((flags & XFS_BMAPI_IGSTATE) && wr)	/* if writing unwritten space */
 		wr = 0;				/* no allocations are allowed */
-	ASSERT(wr || !(flags & XFS_BMAPI_DELAY));
 	logflags = 0;
 	nallocs = 0;
 	cur = NULL;
@@ -4695,8 +4778,7 @@ xfs_bmapi(
 		if (eof && !wr)
 			got.br_startoff = end;
 		inhole = eof || got.br_startoff > bno;
-		wasdelay = wr && !inhole && !(flags & XFS_BMAPI_DELAY) &&
-			isnullstartblock(got.br_startblock);
+		wasdelay = wr && !inhole && isnullstartblock(got.br_startblock);
 		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
@@ -4724,20 +4806,7 @@ xfs_bmapi(
 				aoff = bno;
 			}
 			minlen = (flags & XFS_BMAPI_CONTIG) ? alen : 1;
-			if (flags & XFS_BMAPI_DELAY) {
-				error = xfs_bmapi_reserve_delalloc(ip, bno, len, &got,
-								   &prev, &lastx, eof);
-				if (error) {
-					if (n == 0) {
-						*nmap = 0;
-						ASSERT(cur == NULL);
-						return error;
-					}
-					break;
-				}
-
-				goto trim_extent;
-			} else {
+			{
 				/*
 				 * If first time, allocate and fill in
 				 * once-only bma fields.
@@ -4848,14 +4917,8 @@ xfs_bmapi(
 			ASSERT(got.br_startoff <= aoff);
 			ASSERT(got.br_startoff + got.br_blockcount >=
 				aoff + alen);
-#ifdef DEBUG
-			if (flags & XFS_BMAPI_DELAY) {
-				ASSERT(isnullstartblock(got.br_startblock));
-				ASSERT(startblockval(got.br_startblock) > 0);
-			}
 			ASSERT(got.br_state == XFS_EXT_NORM ||
 			       got.br_state == XFS_EXT_UNWRITTEN);
-#endif
 			/*
 			 * Fall down into the found allocated space case.
 			 */
@@ -4874,7 +4937,7 @@ xfs_bmapi(
 			n++;
 			continue;
 		}
-trim_extent:
+
 		/* Deal with the allocated space we found.  */
 		xfs_bmapi_trim_map(mval, &got, &bno, len, obno, end, n, flags);
 
@@ -4884,7 +4947,7 @@ trim_extent:
 		 */
 		if (wr &&
 		    ((mval->br_state == XFS_EXT_UNWRITTEN &&
-		      ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_DELAY)) == 0)) ||
+		      ((flags & XFS_BMAPI_PREALLOC) == 0)) ||
 		     (mval->br_state == XFS_EXT_NORM &&
 		      ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)) ==
 				(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT))))) {
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-08-23 21:10:14.383496146 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-08-23 21:12:59.355935746 +0200
@@ -65,7 +65,6 @@ typedef	struct xfs_bmap_free
  * Flags for xfs_bmapi
  */
 #define	XFS_BMAPI_WRITE		0x001	/* write operation: allocate space */
-#define XFS_BMAPI_DELAY		0x002	/* delayed write operation */
 #define XFS_BMAPI_ENTIRE	0x004	/* return entire extent, not trimmed */
 #define XFS_BMAPI_METADATA	0x008	/* mapping metadata not user data */
 #define XFS_BMAPI_ATTRFORK	0x010	/* use attribute fork not data */
@@ -82,7 +81,6 @@ typedef	struct xfs_bmap_free
 
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_WRITE,	"WRITE" }, \
-	{ XFS_BMAPI_DELAY,	"DELAY" }, \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
 	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
@@ -297,6 +295,9 @@ xfs_bmapi(
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
+int	xfs_bmapi_delay(struct xfs_inode *ip, xfs_fileoff_t bno,
+		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
+		int *nmap, int flags);
 
 /*
  * Unmap (remove) blocks from a file.
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2011-08-23 21:09:32.923720752 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2011-08-23 21:12:59.355935746 +0200
@@ -381,7 +381,6 @@ xfs_iomap_write_delay(
 	xfs_fileoff_t	last_fsb;
 	xfs_off_t	aligned_offset;
 	xfs_fileoff_t	ioalign;
-	xfs_fsblock_t	firstblock;
 	xfs_extlen_t	extsz;
 	int		nimaps;
 	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
@@ -425,12 +424,8 @@ retry:
 	}
 
 	nimaps = XFS_WRITE_IMAPS;
-	firstblock = NULLFSBLOCK;
-	error = xfs_bmapi(NULL, ip, offset_fsb,
-			  (xfs_filblks_t)(last_fsb - offset_fsb),
-			  XFS_BMAPI_DELAY | XFS_BMAPI_WRITE |
-			  XFS_BMAPI_ENTIRE, &firstblock, 1, imap,
-			  &nimaps, NULL);
+	error = xfs_bmapi_delay(ip, offset_fsb, last_fsb - offset_fsb,
+				imap, &nimaps, XFS_BMAPI_ENTIRE);
 	switch (error) {
 	case 0:
 	case ENOSPC:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
