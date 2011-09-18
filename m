Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfkji200937 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9028017205F
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rfleGhh5dlLbD2aD for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OBN-0004kQ-0k
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:41:45 +0000
Message-Id: <20110918204144.980555164@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/27] xfs: introduce xfs_bmap_last_extent
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-add-xfs_bmap_last_extent
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

Add a common helper for finding the last extent in a file.

Largely based on a patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:44:25.179789415 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:45:03.903122527 -0400
@@ -204,19 +204,6 @@ xfs_bmap_search_extents(
 	xfs_bmbt_irec_t	*prevp);	/* out: previous extent entry found */
 
 /*
- * Check the last inode extent to determine whether this allocation will result
- * in blocks being allocated at the end of the file. When we allocate new data
- * blocks at the end of the file which do not start at the previous data block,
- * we will try to align the new blocks at stripe unit boundaries.
- */
-STATIC int				/* error */
-xfs_bmap_isaeof(
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_fileoff_t   off,		/* file offset in fsblocks */
-	int             whichfork,	/* data or attribute fork */
-	char		*aeof);		/* return value */
-
-/*
  * Compute the worst-case number of indirect blocks that will be used
  * for ip's delayed extent of length "len".
  */
@@ -3924,42 +3911,122 @@ xfs_bmap_last_before(
 	return 0;
 }
 
+STATIC int
+xfs_bmap_last_extent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*rec,
+	int			*is_empty)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	int			error;
+	int			nextents;
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(tp, ip, whichfork);
+		if (error)
+			return error;
+	}
+
+	nextents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+	if (nextents == 0) {
+		*is_empty = 1;
+		return 0;
+	}
+
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, nextents - 1), rec);
+	*is_empty = 0;
+	return 0;
+}
+
+/*
+ * Check the last inode extent to determine whether this allocation will result
+ * in blocks being allocated at the end of the file. When we allocate new data
+ * blocks at the end of the file which do not start at the previous data block,
+ * we will try to align the new blocks at stripe unit boundaries.
+ *
+ * Returns 0 in *aeof if the file (fork) is empty as any new write will be at,
+ * or past the EOF.
+ */
+STATIC int
+xfs_bmap_isaeof(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		off,
+	int			whichfork,
+	char			*aeof)
+{
+	struct xfs_bmbt_irec	rec;
+	int			is_empty;
+	int			error;
+
+	*aeof = 0;
+	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
+	if (error || is_empty)
+		return error;
+
+	/*
+	 * Check if we are allocation or past the last extent, or at least into
+	 * the last delayed allocated extent.
+	 */
+	*aeof = off >= rec.br_startoff + rec.br_blockcount ||
+		(off >= rec.br_startoff && isnullstartblock(rec.br_startblock));
+	return 0;
+}
+
+/*
+ * Check if the endoff is outside the last extent. If so the caller will grow
+ * the allocation to a stripe unit boundary.  All offsets are considered outside
+ * the end of file for an empty fork, so 1 is returned in *eof in that case.
+ */
+int
+xfs_bmap_eof(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		endoff,
+	int			whichfork,
+	int			*eof)
+{
+	struct xfs_bmbt_irec	rec;
+	int			error;
+
+	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, eof);
+	if (error || *eof)
+		return error;
+
+	*eof = endoff >= rec.br_startoff + rec.br_blockcount;
+	return 0;
+}
+
 /*
  * Returns the file-relative block number of the first block past eof in
  * the file.  This is not based on i_size, it is based on the extent records.
  * Returns 0 for local files, as they do not have extent records.
  */
-int						/* error */
+int
 xfs_bmap_last_offset(
-	xfs_trans_t	*tp,			/* transaction pointer */
-	xfs_inode_t	*ip,			/* incore inode */
-	xfs_fileoff_t	*last_block,		/* last block */
-	int		whichfork)		/* data or attr fork */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		*last_block,
+	int			whichfork)
 {
-	xfs_bmbt_rec_host_t *ep;		/* pointer to last extent */
-	int		error;			/* error return value */
-	xfs_ifork_t	*ifp;			/* inode fork pointer */
-	xfs_extnum_t	nextents;		/* number of extent entries */
+	struct xfs_bmbt_irec	rec;
+	int			is_empty;
+	int			error;
+
+	*last_block = 0;
+
+	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL)
+		return 0;
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
+	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
 	       return XFS_ERROR(EIO);
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
-		*last_block = 0;
-		return 0;
-	}
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
-	    (error = xfs_iread_extents(tp, ip, whichfork)))
+
+	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
+	if (error || is_empty)
 		return error;
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	if (!nextents) {
-		*last_block = 0;
-		return 0;
-	}
-	ep = xfs_iext_get_ext(ifp, nextents - 1);
-	*last_block = xfs_bmbt_get_startoff(ep) + xfs_bmbt_get_blockcount(ep);
+
+	*last_block = rec.br_startoff + rec.br_blockcount;
 	return 0;
 }
 
@@ -5687,89 +5754,6 @@ xfs_getbmap(
 	return error;
 }
 
-/*
- * Check the last inode extent to determine whether this allocation will result
- * in blocks being allocated at the end of the file. When we allocate new data
- * blocks at the end of the file which do not start at the previous data block,
- * we will try to align the new blocks at stripe unit boundaries.
- */
-STATIC int				/* error */
-xfs_bmap_isaeof(
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_fileoff_t   off,		/* file offset in fsblocks */
-	int             whichfork,	/* data or attribute fork */
-	char		*aeof)		/* return value */
-{
-	int		error;		/* error return value */
-	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_bmbt_rec_host_t *lastrec;	/* extent record pointer */
-	xfs_extnum_t	nextents;	/* number of file extents */
-	xfs_bmbt_irec_t	s;		/* expanded extent record */
-
-	ASSERT(whichfork == XFS_DATA_FORK);
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
-	    (error = xfs_iread_extents(NULL, ip, whichfork)))
-		return error;
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	if (nextents == 0) {
-		*aeof = 1;
-		return 0;
-	}
-	/*
-	 * Go to the last extent
-	 */
-	lastrec = xfs_iext_get_ext(ifp, nextents - 1);
-	xfs_bmbt_get_all(lastrec, &s);
-	/*
-	 * Check we are allocating in the last extent (for delayed allocations)
-	 * or past the last extent for non-delayed allocations.
-	 */
-	*aeof = (off >= s.br_startoff &&
-		 off < s.br_startoff + s.br_blockcount &&
-		 isnullstartblock(s.br_startblock)) ||
-		off >= s.br_startoff + s.br_blockcount;
-	return 0;
-}
-
-/*
- * Check if the endoff is outside the last extent. If so the caller will grow
- * the allocation to a stripe unit boundary.
- */
-int					/* error */
-xfs_bmap_eof(
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_fileoff_t	endoff,		/* file offset in fsblocks */
-	int		whichfork,	/* data or attribute fork */
-	int		*eof)		/* result value */
-{
-	xfs_fsblock_t	blockcount;	/* extent block count */
-	int		error;		/* error return value */
-	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_bmbt_rec_host_t *lastrec;	/* extent record pointer */
-	xfs_extnum_t	nextents;	/* number of file extents */
-	xfs_fileoff_t	startoff;	/* extent starting file offset */
-
-	ASSERT(whichfork == XFS_DATA_FORK);
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
-	    (error = xfs_iread_extents(NULL, ip, whichfork)))
-		return error;
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	if (nextents == 0) {
-		*eof = 1;
-		return 0;
-	}
-	/*
-	 * Go to the last extent
-	 */
-	lastrec = xfs_iext_get_ext(ifp, nextents - 1);
-	startoff = xfs_bmbt_get_startoff(lastrec);
-	blockcount = xfs_bmbt_get_blockcount(lastrec);
-	*eof = endoff >= startoff + blockcount;
-	return 0;
-}
-
 #ifdef DEBUG
 STATIC struct xfs_buf *
 xfs_bmap_get_bp(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
