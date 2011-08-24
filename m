Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66hu5014439 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 416A5105192
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tHP42CrAmYcBv316 for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:42 -0700 (PDT)
Message-Id: <20110824060641.541211477@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/25] xfs: remove xfs_bmapi_single()
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-remove-xfs_bmapi_single
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

Now we have xfs_bmapi_read, there is no need for xfs_bmapi_single().
Change the remaining caller over and kill the function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:09:32.913720807 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:10:14.383496146 +0200
@@ -4966,58 +4966,6 @@ error0:
 }
 
 /*
- * Map file blocks to filesystem blocks, simple version.
- * One block (extent) only, read-only.
- * For flags, only the XFS_BMAPI_ATTRFORK flag is examined.
- * For the other flag values, the effect is as if XFS_BMAPI_METADATA
- * was set and all the others were clear.
- */
-int						/* error */
-xfs_bmapi_single(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_inode_t	*ip,		/* incore inode */
-	int		whichfork,	/* data or attr fork */
-	xfs_fsblock_t	*fsb,		/* output: mapped block */
-	xfs_fileoff_t	bno)		/* starting file offs. mapped */
-{
-	int		eof;		/* we've hit the end of extents */
-	int		error;		/* error return */
-	xfs_bmbt_irec_t	got;		/* current file extent record */
-	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_extnum_t	lastx;		/* last useful extent number */
-	xfs_bmbt_irec_t	prev;		/* previous file extent record */
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (unlikely(
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)) {
-	       XFS_ERROR_REPORT("xfs_bmapi_single", XFS_ERRLEVEL_LOW,
-				ip->i_mount);
-	       return XFS_ERROR(EFSCORRUPTED);
-	}
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return XFS_ERROR(EIO);
-	XFS_STATS_INC(xs_blk_mapr);
-	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
-	    (error = xfs_iread_extents(tp, ip, whichfork)))
-		return error;
-	(void)xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got,
-		&prev);
-	/*
-	 * Reading past eof, act as though there's a hole
-	 * up to end.
-	 */
-	if (eof || got.br_startoff > bno) {
-		*fsb = NULLFSBLOCK;
-		return 0;
-	}
-	ASSERT(!isnullstartblock(got.br_startblock));
-	ASSERT(bno < got.br_startoff + got.br_blockcount);
-	*fsb = got.br_startblock + (bno - got.br_startoff);
-	return 0;
-}
-
-/*
  * Unmap (remove) blocks from a file.
  * If nexts is nonzero then the number of extents to remove is limited to
  * that value.  If not all extents in the block range can be removed then
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-08-23 21:09:32.917054122 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-08-23 21:10:14.383496146 +0200
@@ -299,21 +299,6 @@ int	xfs_bmapi_read(struct xfs_inode *ip,
 		int *nmap, int flags);
 
 /*
- * Map file blocks to filesystem blocks, simple version.
- * One block only, read-only.
- * For flags, only the XFS_BMAPI_ATTRFORK flag is examined.
- * For the other flag values, the effect is as if XFS_BMAPI_METADATA
- * was set and all the others were clear.
- */
-int						/* error */
-xfs_bmapi_single(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* incore inode */
-	int			whichfork,	/* data or attr fork */
-	xfs_fsblock_t		*fsb,		/* output: mapped block */
-	xfs_fileoff_t		bno);		/* starting file offs. mapped */
-
-/*
  * Unmap (remove) blocks from a file.
  * If nexts is nonzero then the number of extents to remove is limited to
  * that value.  If not all extents in the block range can be removed then
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2011-08-12 04:36:18.000000000 +0200
+++ xfs/fs/xfs/xfs_rtalloc.c	2011-08-23 21:12:01.472915992 +0200
@@ -856,33 +856,23 @@ xfs_rtbuf_get(
 	xfs_buf_t	**bpp)		/* output: buffer for the block */
 {
 	xfs_buf_t	*bp;		/* block buffer, result */
-	xfs_daddr_t	d;		/* disk addr of block */
-	int		error;		/* error value */
-	xfs_fsblock_t	fsb;		/* fs block number for block */
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
+	xfs_bmbt_irec_t	map;
+	int		nmap;
+	int		error;		/* error value */
 
 	ip = issum ? mp->m_rsumip : mp->m_rbmip;
-	/*
-	 * Map from the file offset (block) and inode number to the
-	 * file system block.
-	 */
-	error = xfs_bmapi_single(tp, ip, XFS_DATA_FORK, &fsb, block);
-	if (error) {
+
+	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, XFS_DATA_FORK);
+	if (error)
 		return error;
-	}
-	ASSERT(fsb != NULLFSBLOCK);
-	/*
-	 * Convert to disk address for buffer cache.
-	 */
-	d = XFS_FSB_TO_DADDR(mp, fsb);
-	/*
-	 * Read the buffer.
-	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
+
+	ASSERT(map.br_startblock != NULLFSBLOCK);
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp);
-	if (error) {
+	if (error)
 		return error;
-	}
 	ASSERT(!xfs_buf_geterror(bp));
 	*bpp = bp;
 	return 0;
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-08-23 21:09:32.000000000 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2011-08-23 21:10:14.390162776 +0200
@@ -1975,32 +1975,16 @@ xfs_da_do_buf(
 		/*
 		 * Optimize the one-block case.
 		 */
-		if (nfsb == 1) {
-			xfs_fsblock_t	fsb;
-
-			if ((error =
-			    xfs_bmapi_single(trans, dp, whichfork, &fsb,
-				    (xfs_fileoff_t)bno))) {
-				return error;
-			}
+		if (nfsb == 1)
 			mapp = &map;
-			if (fsb == NULLFSBLOCK) {
-				nmap = 0;
-			} else {
-				map.br_startblock = fsb;
-				map.br_startoff = (xfs_fileoff_t)bno;
-				map.br_blockcount = 1;
-				nmap = 1;
-			}
-		} else {
+		else
 			mapp = kmem_alloc(sizeof(*mapp) * nfsb, KM_SLEEP);
-			nmap = nfsb;
-			error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb,
-					       mapp, &nmap,
-					       xfs_bmapi_aflag(whichfork));
-			if (error)
-				goto exit0;
-		}
+
+		nmap = nfsb;
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, mapp,
+				       &nmap, xfs_bmapi_aflag(whichfork));
+		if (error)
+			goto exit0;
 	} else {
 		map.br_startblock = XFS_DADDR_TO_FSB(mp, mappedbno);
 		map.br_startoff = (xfs_fileoff_t)bno;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
