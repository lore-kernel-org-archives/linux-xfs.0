Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66h1F014452 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E89DE105198
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AnsqCyp5rfYLpKpB for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6bq-0005BR-7y
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:06:42 +0000
Message-Id: <20110824060642.190850825@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/25] xfs: do not use xfs_bmap_add_extent for adding delalloc
	extents
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-delay-simplify
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

We can just call xfs_bmap_add_extent_hole_delay directly to add a delayed
allocated regions to the extent tree, instead of going through all the
complexities of xfs_bmap_add_extent that aren't needed for this simple
case.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:12:59.355935746 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:13:31.625760927 +0200
@@ -102,17 +102,6 @@ xfs_bmap_add_extent_delay_real(
 
 /*
  * Called by xfs_bmap_add_extent to handle cases converting a hole
- * to a delayed allocation.
- */
-STATIC int				/* error */
-xfs_bmap_add_extent_hole_delay(
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp); /* inode logging flags */
-
-/*
- * Called by xfs_bmap_add_extent to handle cases converting a hole
  * to a real allocation.
  */
 STATIC int				/* error */
@@ -431,8 +420,7 @@ xfs_bmap_add_attrfork_local(
 }
 
 /*
- * Called by xfs_bmapi to update file extent records and the btree
- * after allocating space (or doing a delayed allocation).
+ * Update file extent records and the btree after allocating space.
  */
 STATIC int				/* error */
 xfs_bmap_add_extent(
@@ -464,21 +452,12 @@ xfs_bmap_add_extent(
 
 	ASSERT(*idx >= 0);
 	ASSERT(*idx <= nextents);
+	ASSERT(!isnullstartblock(new->br_startblock));
 
 	/*
-	 * Any kind of new delayed allocation goes here.
-	 */
-	if (isnullstartblock(new->br_startblock)) {
-		if (cur)
-			ASSERT((cur->bc_private.b.flags &
-				XFS_BTCUR_BPRV_WASDEL) == 0);
-		error = xfs_bmap_add_extent_hole_delay(ip, idx, new,
-						       &logflags);
-	}
-	/*
 	 * Real allocation off the end of the file.
 	 */
-	else if (*idx == nextents) {
+	if (*idx == nextents) {
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
@@ -1581,16 +1560,13 @@ done:
 }
 
 /*
- * Called by xfs_bmap_add_extent to handle cases converting a hole
- * to a delayed allocation.
+ * Convert a hole to a delayed allocation.
  */
-/*ARGSUSED*/
-STATIC int				/* error */
+STATIC void
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp) /* inode logging flags */
+	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
 {
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
@@ -1725,8 +1701,6 @@ xfs_bmap_add_extent_hole_delay(
 		 * Nothing to do for disk quota accounting here.
 		 */
 	}
-	*logflagsp = 0;
-	return 0;
 }
 
 /*
@@ -4452,9 +4426,6 @@ xfs_bmapi_reserve_delalloc(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
-	xfs_fsblock_t		firstblock = NULLFSBLOCK;
-	struct xfs_btree_cur	*cur = NULL;
-	int			tmp_logflags = 0;
 	char			rt = XFS_IS_REALTIME_INODE(ip);
 	xfs_extlen_t		extsz;
 	int			error;
@@ -4521,16 +4492,11 @@ xfs_bmapi_reserve_delalloc(
 	got->br_startblock = nullstartblock(indlen);
 	got->br_blockcount = alen;
 	got->br_state = XFS_EXT_NORM;
-
-	error = xfs_bmap_add_extent(NULL, ip, lastx, &cur, got, &firstblock,
-				    NULL, &tmp_logflags, XFS_DATA_FORK);
-	ASSERT(!error);
-	ASSERT(!tmp_logflags);
-	ASSERT(!cur);
+	xfs_bmap_add_extent_hole_delay(ip, lastx, got);
 
 	/*
-	 * Update our extent pointer, given that xfs_bmap_add_extent might
-	 * have merged it into one of the neighbouring ones.
+	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
+	 * might have merged it into one of the neighbouring ones.
 	 */
 	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), got);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
