Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66kG9014522 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EED51397587
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:09:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FUCioPQ9QKtKE4WH for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:09:30 -0700 (PDT)
Message-Id: <20110824060644.595373085@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 19/25] xfs: move btree cursor into bmalloca
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmalloca-cursor
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-08-23 21:14:41.288716862 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-08-23 21:14:42.535376777 +0200
@@ -120,6 +120,8 @@ typedef struct xfs_bmalloca {
 	xfs_extlen_t		length;	/* i/o length asked/allocated */
 	xfs_fsblock_t		blkno;	/* starting block of new extent */
 
+	struct xfs_btree_cur	*cur;	/* btree cursor */
+
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:14:41.285383547 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:14:42.542043407 +0200
@@ -4602,7 +4602,6 @@ STATIC int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma,
 	xfs_extnum_t		*lastx,
-	struct xfs_btree_cur	**cur,
 	int			flags,
 	int			*nallocs,
 	int			*logflags)
@@ -4665,14 +4664,14 @@ xfs_bmapi_allocate(
 
 	if (bma->flist->xbf_low)
 		bma->minleft = 0;
-	if (*cur)
-		(*cur)->bc_private.b.firstblock = *bma->firstblock;
+	if (bma->cur)
+		bma->cur->bc_private.b.firstblock = *bma->firstblock;
 	if (bma->blkno == NULLFSBLOCK)
 		return 0;
-	if ((ifp->if_flags & XFS_IFBROOT) && !*cur) {
-		(*cur) = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
-		(*cur)->bc_private.b.firstblock = *bma->firstblock;
-		(*cur)->bc_private.b.flist = bma->flist;
+	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
+		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
+		bma->cur->bc_private.b.firstblock = *bma->firstblock;
+		bma->cur->bc_private.b.flist = bma->flist;
 	}
 	/*
 	 * Bump the number of extents we've allocated
@@ -4680,8 +4679,8 @@ xfs_bmapi_allocate(
 	 */
 	(*nallocs)++;
 
-	if (*cur)
-		(*cur)->bc_private.b.flags =
+	if (bma->cur)
+		bma->cur->bc_private.b.flags =
 			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 
 	bma->got.br_startoff = bma->offset;
@@ -4699,12 +4698,12 @@ xfs_bmapi_allocate(
 
 	if (bma->wasdel) {
 		error = xfs_bmap_add_extent_delay_real(bma->tp, bma->ip, lastx,
-				cur, &bma->got, bma->firstblock, bma->flist,
-				logflags);
+				&bma->cur, &bma->got, bma->firstblock,
+				bma->flist, logflags);
 	} else {
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip, lastx,
-				cur, &bma->got, bma->firstblock, bma->flist,
-				logflags, whichfork);
+				&bma->cur, &bma->got, bma->firstblock,
+				bma->flist, logflags, whichfork);
 	}
 
 	if (error)
@@ -4731,7 +4730,6 @@ xfs_bmapi_convert_unwritten(
 	struct xfs_bmbt_irec	*mval,
 	xfs_filblks_t		len,
 	xfs_extnum_t		*lastx,
-	struct xfs_btree_cur	**cur,
 	int			flags,
 	int			*logflags)
 {
@@ -4757,17 +4755,17 @@ xfs_bmapi_convert_unwritten(
 	 * Modify (by adding) the state flag, if writing.
 	 */
 	ASSERT(mval->br_blockcount <= len);
-	if ((ifp->if_flags & XFS_IFBROOT) && !*cur) {
-		*cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
+	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
+		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
 					bma->ip, whichfork);
-		(*cur)->bc_private.b.firstblock = *bma->firstblock;
-		(*cur)->bc_private.b.flist = bma->flist;
+		bma->cur->bc_private.b.firstblock = *bma->firstblock;
+		bma->cur->bc_private.b.flist = bma->flist;
 	}
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
 
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, lastx,
-			cur, mval, bma->firstblock, bma->flist, logflags);
+			&bma->cur, mval, bma->firstblock, bma->flist, logflags);
 	if (error)
 		return error;
 
@@ -4815,7 +4813,6 @@ xfs_bmapi_write(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmalloca	bma = { 0 };	/* args for xfs_bmap_alloc */
-	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	int			eof;		/* after the end of extents */
 	int			error;		/* error return */
@@ -4872,7 +4869,6 @@ xfs_bmapi_write(
 
 	logflags = 0;
 	nallocs = 0;
-	cur = NULL;
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_local_to_extents(tp, ip, firstblock, total,
@@ -4924,12 +4920,12 @@ xfs_bmapi_write(
 			bma.length = len;
 			bma.offset = bno;
 
-			error = xfs_bmapi_allocate(&bma, &lastx, &cur, flags,
+			error = xfs_bmapi_allocate(&bma, &lastx, flags,
 						   &nallocs, &tmp_logflags);
 			if (error == ENOSPC || error == EDQUOT) {
 				if (n == 0) {
 					*nmap = 0;
-					ASSERT(cur == NULL);
+					ASSERT(bma.cur == NULL);
 					return error;
 				}
 			}
@@ -4947,7 +4943,7 @@ xfs_bmapi_write(
 
 		/* Execute unwritten extent conversion if necessary */
 		error = xfs_bmapi_convert_unwritten(&bma, mval, len, &lastx,
-						    &cur, flags, &tmp_logflags);
+						    flags, &tmp_logflags);
 		logflags |= tmp_logflags;
 		if (error == EAGAIN)
 			continue;
@@ -4979,8 +4975,8 @@ xfs_bmapi_write(
 	 */
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
 	    XFS_IFORK_NEXTENTS(ip, whichfork) <= ifp->if_ext_max) {
-		ASSERT(cur);
-		error = xfs_bmap_btree_to_extents(tp, ip, cur,
+		ASSERT(bma.cur);
+		error = xfs_bmap_btree_to_extents(tp, ip, bma.cur,
 			&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
@@ -5010,19 +5006,19 @@ error0:
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 
-	if (cur) {
+	if (bma.cur) {
 		if (!error) {
 			ASSERT(*firstblock == NULLFSBLOCK ||
 			       XFS_FSB_TO_AGNO(mp, *firstblock) ==
 			       XFS_FSB_TO_AGNO(mp,
-				       cur->bc_private.b.firstblock) ||
+				       bma.cur->bc_private.b.firstblock) ||
 			       (flist->xbf_low &&
 				XFS_FSB_TO_AGNO(mp, *firstblock) <
 				XFS_FSB_TO_AGNO(mp,
-					cur->bc_private.b.firstblock)));
-			*firstblock = cur->bc_private.b.firstblock;
+					bma.cur->bc_private.b.firstblock)));
+			*firstblock = bma.cur->bc_private.b.firstblock;
 		}
-		xfs_btree_del_cursor(cur,
+		xfs_btree_del_cursor(bma.cur,
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	}
 	if (!error)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
