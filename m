Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfjqr200900 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DE5B1D73901
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OOcEv1Clvntb3i52 for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:43 -0700 (PDT)
Message-Id: <20110918204143.592217024@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/27] xfs: remove xfs_bmapi_single()
References: <20110918204040.266805129@bombadil.infradead.org>
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

From: Dave Chinner <dchinner@redhat.com>

Now we have xfs_bmapi_read, there is no need for xfs_bmapi_single().
Change the remaining caller over and kill the function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:42:27.826456801 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:43:05.433123235 -0400
@@ -4969,58 +4969,6 @@ error0:
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
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-09-11 08:41:51.009790348 -0400
+++ xfs/fs/xfs/xfs_bmap.h	2011-09-11 08:43:05.433123235 -0400
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
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2011-09-11 08:41:45.813123711 -0400
+++ xfs/fs/xfs/xfs_rtalloc.c	2011-09-11 08:43:05.433123235 -0400
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
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-09-11 08:41:51.016457013 -0400
+++ xfs/fs/xfs/xfs_da_btree.c	2011-09-11 08:43:05.436456568 -0400
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
