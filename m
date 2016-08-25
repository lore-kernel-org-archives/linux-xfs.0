Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 921B48178
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:49:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8F77AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:41 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id hPliTcX2xjlk91yF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:39 -0700 (PDT)
Subject: [PATCH 29/71] xfs: support allocating delayed extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:49:35 -0700
Message-ID: <147216897506.4420.17994208428591127794.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Modify xfs_bmap_add_extent_delay_real() so that we can convert delayed
allocation extents in the CoW fork to real allocations, and wire this
up all the way back to xfs_iomap_write_allocate().  In a subsequent
patch, we'll modify the writepage handler to call this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c |   51 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cdc1ed3..6503241 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -133,7 +133,8 @@ xfs_bmbt_lookup_ge(
  */
 static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
 {
-	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+	return whichfork != XFS_COW_FORK &&
+		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
 		XFS_IFORK_NEXTENTS(ip, whichfork) >
 			XFS_IFORK_MAXEXT(ip, whichfork);
 }
@@ -143,7 +144,8 @@ static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
  */
 static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 {
-	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
+	return whichfork != XFS_COW_FORK &&
+		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
 		XFS_IFORK_NEXTENTS(ip, whichfork) <=
 			XFS_IFORK_MAXEXT(ip, whichfork);
 }
@@ -633,6 +635,7 @@ xfs_bmap_btree_to_extents(
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 	rblock = ifp->if_broot;
@@ -699,6 +702,7 @@ xfs_bmap_extents_to_btree(
 	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
 
 	mp = ip->i_mount;
+	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS);
 
@@ -830,6 +834,7 @@ xfs_bmap_local_to_extents_empty(
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 
+	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
 	ASSERT(ifp->if_bytes == 0);
 	ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
@@ -1663,7 +1668,8 @@ xfs_bmap_one_block(
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
-	struct xfs_bmalloca	*bma)
+	struct xfs_bmalloca	*bma,
+	int			whichfork)
 {
 	struct xfs_bmbt_irec	*new = &bma->got;
 	int			diff;	/* temp value */
@@ -1682,10 +1688,13 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp2=0;/* value for da_new calculations */
 	int			tmp_rval;	/* partial logging flags */
 	struct xfs_mount	*mp;
-	int			whichfork = XFS_DATA_FORK;
+	xfs_extnum_t		*nextents;
 
 	mp = bma->ip->i_mount;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	ASSERT(whichfork != XFS_ATTR_FORK);
+	nextents = (whichfork == XFS_COW_FORK ? &bma->ip->i_cnextents :
+						&bma->ip->i_d.di_nextents);
 
 	ASSERT(bma->idx >= 0);
 	ASSERT(bma->idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
@@ -1699,6 +1708,9 @@ xfs_bmap_add_extent_delay_real(
 #define	RIGHT		r[1]
 #define	PREV		r[2]
 
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
+
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
@@ -1785,7 +1797,7 @@ xfs_bmap_add_extent_delay_real(
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 2, state);
-		bma->ip->i_d.di_nextents--;
+		(*nextents)--;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -1887,7 +1899,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -1957,7 +1969,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2041,7 +2053,7 @@ xfs_bmap_add_extent_delay_real(
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_iext_insert(bma->ip, bma->idx + 1, 1, new, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2110,7 +2122,7 @@ xfs_bmap_add_extent_delay_real(
 		RIGHT.br_blockcount = temp2;
 		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
 		xfs_iext_insert(bma->ip, bma->idx + 1, 2, &LEFT, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2208,7 +2220,8 @@ xfs_bmap_add_extent_delay_real(
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:
-	bma->logflags |= rval;
+	if (whichfork != XFS_COW_FORK)
+		bma->logflags |= rval;
 	return error;
 #undef	LEFT
 #undef	RIGHT
@@ -3849,7 +3862,8 @@ xfs_bmap_btalloc(
 		ASSERT(nullfb || fb_agno == args.agno ||
 		       (ap->dfops->dop_low && fb_agno < args.agno));
 		ap->length = args.len;
-		ap->ip->i_d.di_nblocks += args.len;
+		if (!(ap->flags & XFS_BMAPI_COWFORK))
+			ap->ip->i_d.di_nblocks += args.len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
 			ap->ip->i_delayed_blks -= args.len;
@@ -4323,8 +4337,7 @@ xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
-	int			whichfork = (bma->flags & XFS_BMAPI_ATTRFORK) ?
-						XFS_ATTR_FORK : XFS_DATA_FORK;
+	int			whichfork = xfs_bmapi_whichfork(bma->flags);
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
@@ -4413,7 +4426,7 @@ xfs_bmapi_allocate(
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel)
-		error = xfs_bmap_add_extent_delay_real(bma);
+		error = xfs_bmap_add_extent_delay_real(bma, whichfork);
 	else
 		error = xfs_bmap_add_extent_hole_real(bma, whichfork);
 
@@ -4567,8 +4580,7 @@ xfs_bmapi_write(
 	orig_mval = mval;
 	orig_nmap = *nmap;
 #endif
-	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-		XFS_ATTR_FORK : XFS_DATA_FORK;
+	whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
@@ -4579,6 +4591,11 @@ xfs_bmapi_write(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (whichfork == XFS_ATTR_FORK)
 		ASSERT(!(flags & XFS_BMAPI_REMAP));
+	if (whichfork == XFS_COW_FORK) {
+		ASSERT(!(flags & XFS_BMAPI_REMAP));
+		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
+		ASSERT(!(flags & XFS_BMAPI_CONVERT));
+	}
 	if (flags & XFS_BMAPI_REMAP) {
 		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
 		ASSERT(!(flags & XFS_BMAPI_CONVERT));
@@ -4648,6 +4665,8 @@ xfs_bmapi_write(
 		 */
 		if (flags & XFS_BMAPI_REMAP)
 			ASSERT(inhole);
+		if (flags & XFS_BMAPI_COWFORK)
+			ASSERT(!inhole);
 
 		/*
 		 * First, deal with the hole before the allocated space

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
