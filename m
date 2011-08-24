Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66kuU014521 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E38031051A6
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	smZ6f6s35XEWgdVH for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6bt-0005Hu-41
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:06:45 +0000
Message-Id: <20110824060645.058158817@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 21/25] xfs: move logflags into bmalloca
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmalloca-logflags
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:14:43.972035659 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:14:45.412027859 +0200
@@ -4601,13 +4601,13 @@ xfs_bmapi_delay(
 STATIC int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma,
-	int			flags,
-	int			*logflags)
+	int			flags)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
 	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 						XFS_ATTR_FORK : XFS_DATA_FORK;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	int			tmp_logflags = 0;
 	int			error;
 	int			rt;
 
@@ -4697,14 +4697,15 @@ xfs_bmapi_allocate(
 	if (bma->wasdel) {
 		error = xfs_bmap_add_extent_delay_real(bma->tp, bma->ip,
 				&bma->idx, &bma->cur, &bma->got,
-				bma->firstblock, bma->flist, logflags);
+				bma->firstblock, bma->flist, &tmp_logflags);
 	} else {
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				&bma->idx, &bma->cur, &bma->got,
-				bma->firstblock, bma->flist, logflags,
+				bma->firstblock, bma->flist, &tmp_logflags,
 				whichfork);
 	}
 
+	bma->logflags |= tmp_logflags;
 	if (error)
 		return error;
 
@@ -4728,16 +4729,14 @@ xfs_bmapi_convert_unwritten(
 	struct xfs_bmalloca	*bma,
 	struct xfs_bmbt_irec	*mval,
 	xfs_filblks_t		len,
-	int			flags,
-	int			*logflags)
+	int			flags)
 {
 	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 						XFS_ATTR_FORK : XFS_DATA_FORK;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	int			tmp_logflags = 0;
 	int			error;
 
-	*logflags = 0;
-
 	/* check if we need to do unwritten->real conversion */
 	if (mval->br_state == XFS_EXT_UNWRITTEN &&
 	    (flags & XFS_BMAPI_PREALLOC))
@@ -4763,7 +4762,9 @@ xfs_bmapi_convert_unwritten(
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
 
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
-			&bma->cur, mval, bma->firstblock, bma->flist, logflags);
+			&bma->cur, mval, bma->firstblock, bma->flist,
+			&tmp_logflags);
+	bma->logflags |= tmp_logflags;
 	if (error)
 		return error;
 
@@ -4815,10 +4816,8 @@ xfs_bmapi_write(
 	int			eof;		/* after the end of extents */
 	int			error;		/* error return */
 	xfs_ifork_t		*ifp;		/* inode fork pointer */
-	int			logflags;	/* flags for transaction logging */
 	int			n;		/* current extent index */
 	xfs_fileoff_t		obno;		/* old block number (offset) */
-	int			tmp_logflags;	/* temp flags holder */
 	int			whichfork;	/* data or attr fork */
 	char			inhole;		/* current location is hole in file */
 	char			wasdelay;	/* old extent was delayed */
@@ -4863,11 +4862,9 @@ xfs_bmapi_write(
 
 	XFS_STATS_INC(xs_blk_mapw);
 
-	logflags = 0;
-
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_local_to_extents(tp, ip, firstblock, total,
-						  &logflags, whichfork);
+						  &bma.logflags, whichfork);
 		if (error)
 			goto error0;
 	}
@@ -4915,7 +4912,7 @@ xfs_bmapi_write(
 			bma.length = len;
 			bma.offset = bno;
 
-			error = xfs_bmapi_allocate(&bma, flags, &tmp_logflags);
+			error = xfs_bmapi_allocate(&bma, flags);
 			if (error == ENOSPC || error == EDQUOT) {
 				if (n == 0) {
 					*nmap = 0;
@@ -4924,7 +4921,6 @@ xfs_bmapi_write(
 				}
 			}
 
-			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
 			if (bma.blkno == NULLFSBLOCK)
@@ -4936,9 +4932,7 @@ xfs_bmapi_write(
 							end, n, flags);
 
 		/* Execute unwritten extent conversion if necessary */
-		error = xfs_bmapi_convert_unwritten(&bma, mval, len,
-						    flags, &tmp_logflags);
-		logflags |= tmp_logflags;
+		error = xfs_bmapi_convert_unwritten(&bma, mval, len, flags);
 		if (error == EAGAIN)
 			continue;
 		if (error)
@@ -4970,10 +4964,12 @@ xfs_bmapi_write(
 	 */
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
 	    XFS_IFORK_NEXTENTS(ip, whichfork) <= ifp->if_ext_max) {
+		int		tmp_logflags = 0;
+
 		ASSERT(bma.cur);
 		error = xfs_bmap_btree_to_extents(tp, ip, bma.cur,
 			&tmp_logflags, whichfork);
-		logflags |= tmp_logflags;
+		bma.logflags |= tmp_logflags;
 		if (error)
 			goto error0;
 	}
@@ -4987,19 +4983,19 @@ error0:
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
 	 */
-	if ((logflags & xfs_ilog_fext(whichfork)) &&
+	if ((bma.logflags & xfs_ilog_fext(whichfork)) &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-		logflags &= ~xfs_ilog_fext(whichfork);
-	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
+		bma.logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((bma.logflags & xfs_ilog_fbroot(whichfork)) &&
 		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
-		logflags &= ~xfs_ilog_fbroot(whichfork);
+		bma.logflags &= ~xfs_ilog_fbroot(whichfork);
 	/*
 	 * Log whatever the flags say, even if error.  Otherwise we might miss
 	 * detecting a case where the data is changed, there's an error,
 	 * and it's not logged so we don't shutdown when we should.
 	 */
-	if (logflags)
-		xfs_trans_log_inode(tp, ip, logflags);
+	if (bma.logflags)
+		xfs_trans_log_inode(tp, ip, bma.logflags);
 
 	if (bma.cur) {
 		if (!error) {
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-08-23 21:14:43.972035659 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-08-23 21:14:45.412027859 +0200
@@ -123,6 +123,7 @@ typedef struct xfs_bmalloca {
 	struct xfs_btree_cur	*cur;	/* btree cursor */
 	xfs_extnum_t		idx;	/* current extent index */
 	int			nallocs;/* number of extents alloc'd */
+	int			logflags;/* flags for transaction logging */
 
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
