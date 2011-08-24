Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66iRw014477 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5042510519B
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XPjUzKIjmN12vCqa for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:43 -0700 (PDT)
Message-Id: <20110824060642.672916365@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/25] xfs: factor unwritten extent map manipulations out of
	xfs_bmapi
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-bmapi-factor-unwrittent-extent-conversion
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

To further improve the readability of xfs_bmapi(), factor the unwritten
extent conversion out into a separate function. This removes
large block of logic from the xfs_bmapi() code loop and makes it
easier to see the operational logic flow for xfs_bmapi().

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:13:33.855748845 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:13:35.465740123 +0200
@@ -4089,7 +4089,6 @@ xfs_bmap_read_extents(
 		xfs_extnum_t	num_recs;
 		xfs_extnum_t	start;
 
-
 		num_recs = xfs_btree_get_numrecs(block);
 		if (unlikely(i + num_recs > room)) {
 			ASSERT(i + num_recs <= room);
@@ -4743,6 +4742,69 @@ xfs_bmapi_allocate(
 	return 0;
 }
 
+STATIC int
+xfs_bmapi_convert_unwritten(
+	struct xfs_bmalloca	*bma,
+	struct xfs_bmbt_irec	*mval,
+	xfs_filblks_t		len,
+	xfs_extnum_t		*lastx,
+	struct xfs_btree_cur	**cur,
+	xfs_fsblock_t		*firstblock,
+	struct xfs_bmap_free	*flist,
+	int			flags,
+	int			*logflags)
+{
+	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
+						XFS_ATTR_FORK : XFS_DATA_FORK;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	int			error;
+
+	*logflags = 0;
+
+	/* check if we need to do unwritten->real conversion */
+	if (mval->br_state == XFS_EXT_UNWRITTEN &&
+	    (flags & XFS_BMAPI_PREALLOC))
+		return 0;
+
+	/* check if we need to do real->unwritten conversion */
+	if (mval->br_state == XFS_EXT_NORM &&
+	    (flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT)) !=
+			(XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT))
+		return 0;
+
+	/*
+	 * Modify (by adding) the state flag, if writing.
+	 */
+	ASSERT(mval->br_blockcount <= len);
+	if ((ifp->if_flags & XFS_IFBROOT) && !*cur) {
+		*cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
+					bma->ip, whichfork);
+		(*cur)->bc_private.b.firstblock = *firstblock;
+		(*cur)->bc_private.b.flist = flist;
+	}
+	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
+				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
+
+	error = xfs_bmap_add_extent(bma->tp, bma->ip, lastx, cur, mval,
+				firstblock, flist, logflags, whichfork);
+	if (error)
+		return error;
+
+	/*
+	 * Update our extent pointer, given that xfs_bmap_add_extent  might
+	 * have merged it into one of the neighbouring ones.
+	 */
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), bma->gotp);
+
+	/*
+	 * We may have combined previously unwritten space with written space,
+	 * so generate another request.
+	 */
+	if (mval->br_blockcount < len)
+		return EAGAIN;
+	return 0;
+}
+
 /*
  * Map file blocks to filesystem blocks.
  * File range is given by the bno/len pair.
@@ -4937,45 +4999,16 @@ xfs_bmapi(
 		/* Deal with the allocated space we found.  */
 		xfs_bmapi_trim_map(mval, &got, &bno, len, obno, end, n, flags);
 
-		/*
-		 * Check if writing previously allocated but
-		 * unwritten extents.
-		 */
-		if (wr &&
-		    ((mval->br_state == XFS_EXT_UNWRITTEN &&
-		      ((flags & XFS_BMAPI_PREALLOC) == 0)) ||
-		     (mval->br_state == XFS_EXT_NORM &&
-		      ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)) ==
-				(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT))))) {
-			/*
-			 * Modify (by adding) the state flag, if writing.
-			 */
-			ASSERT(mval->br_blockcount <= len);
-			if ((ifp->if_flags & XFS_IFBROOT) && !cur) {
-				cur = xfs_bmbt_init_cursor(mp,
-					tp, ip, whichfork);
-				cur->bc_private.b.firstblock =
-					*firstblock;
-				cur->bc_private.b.flist = flist;
-			}
-			mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
-						? XFS_EXT_NORM
-						: XFS_EXT_UNWRITTEN;
-			error = xfs_bmap_add_extent(tp, ip, &lastx, &cur, mval,
-				firstblock, flist, &tmp_logflags,
-				whichfork);
+		/* Execute unwritten extent conversion if necessary */
+		if (wr) {
+			error = xfs_bmapi_convert_unwritten(&bma, mval, len,
+						&lastx, &cur, firstblock, flist, flags,
+						&tmp_logflags);
 			logflags |= tmp_logflags;
+			if (error == EAGAIN)
+				continue;
 			if (error)
 				goto error0;
-			ep = xfs_iext_get_ext(ifp, lastx);
-			xfs_bmbt_get_all(ep, &got);
-			/*
-			 * We may have combined previously unwritten
-			 * space with written space, so generate
-			 * another request.
-			 */
-			if (mval->br_blockcount < len)
-				continue;
 		}
 
 		/* update the extent map to return */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
