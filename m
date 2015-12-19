Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96DF280D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:02:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8834E304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:49 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id CYbgiH4NTpsz59xZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:44 -0800 (PST)
Subject: [PATCH 56/76] xfs: support allocating delayed extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:02:41 -0800
Message-ID: <20151219090241.12713.36807.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Modify xfs_bmap_add_extent_delay_real() so that we can convert delayed
allocation extents in the CoW fork to real allocations, and wire this
up all the way back to xfs_iomap_write_allocate().  In a subsequent
patch, we'll modify the writepage handler to call this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   51 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_aops.c        |    6 ++++-
 fs/xfs/xfs_iomap.c       |    7 +++++-
 fs/xfs/xfs_iomap.h       |    2 +-
 4 files changed, 46 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9737353..de0ac37 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -139,7 +139,8 @@ xfs_bmbt_lookup_ge(
  */
 static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
 {
-	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+	return whichfork != XFS_COW_FORK &&
+		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
 		XFS_IFORK_NEXTENTS(ip, whichfork) >
 			XFS_IFORK_MAXEXT(ip, whichfork);
 }
@@ -149,7 +150,8 @@ static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
  */
 static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 {
-	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
+	return whichfork != XFS_COW_FORK &&
+		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
 		XFS_IFORK_NEXTENTS(ip, whichfork) <=
 			XFS_IFORK_MAXEXT(ip, whichfork);
 }
@@ -671,6 +673,7 @@ xfs_bmap_btree_to_extents(
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 	rblock = ifp->if_broot;
@@ -737,6 +740,7 @@ xfs_bmap_extents_to_btree(
 	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
 
 	mp = ip->i_mount;
+	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS);
 
@@ -868,6 +872,7 @@ xfs_bmap_local_to_extents_empty(
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 
+	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
 	ASSERT(ifp->if_bytes == 0);
 	ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
@@ -1703,7 +1708,8 @@ xfs_bmap_one_block(
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
-	struct xfs_bmalloca	*bma)
+	struct xfs_bmalloca	*bma,
+	int			whichfork)
 {
 	struct xfs_bmbt_irec	*new = &bma->got;
 	int			diff;	/* temp value */
@@ -1722,10 +1728,13 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp2=0;/* value for da_new calculations */
 	int			tmp_rval;	/* partial logging flags */
 	struct xfs_mount	*mp;
-	int			whichfork = XFS_DATA_FORK;
+	xfs_extnum_t		*nextents;
 
 	mp  = bma->tp ? bma->tp->t_mountp : NULL;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	ASSERT(whichfork != XFS_ATTR_FORK);
+	nextents = (whichfork == XFS_COW_FORK ? &bma->ip->i_cnextents :
+						&bma->ip->i_d.di_nextents);
 
 	ASSERT(bma->idx >= 0);
 	ASSERT(bma->idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
@@ -1739,6 +1748,9 @@ xfs_bmap_add_extent_delay_real(
 #define	RIGHT		r[1]
 #define	PREV		r[2]
 
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
+
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
@@ -1825,7 +1837,7 @@ xfs_bmap_add_extent_delay_real(
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 2, state);
-		bma->ip->i_d.di_nextents--;
+		(*nextents)--;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -1939,7 +1951,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2017,7 +2029,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2107,7 +2119,7 @@ xfs_bmap_add_extent_delay_real(
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_iext_insert(bma->ip, bma->idx + 1, 1, new, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2180,7 +2192,7 @@ xfs_bmap_add_extent_delay_real(
 		RIGHT.br_blockcount = temp2;
 		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
 		xfs_iext_insert(bma->ip, bma->idx + 1, 2, &LEFT, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2277,7 +2289,8 @@ xfs_bmap_add_extent_delay_real(
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:
-	bma->logflags |= rval;
+	if (whichfork != XFS_COW_FORK)
+		bma->logflags |= rval;
 	return error;
 #undef	LEFT
 #undef	RIGHT
@@ -3987,7 +4000,8 @@ xfs_bmap_btalloc(
 		ASSERT(nullfb || fb_agno == args.agno ||
 		       (ap->flist->xbf_low && fb_agno < args.agno));
 		ap->length = args.len;
-		ap->ip->i_d.di_nblocks += args.len;
+		if (!(ap->flags & XFS_BMAPI_COWFORK))
+			ap->ip->i_d.di_nblocks += args.len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
 			ap->ip->i_delayed_blks -= args.len;
@@ -4449,8 +4463,7 @@ xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
-	int			whichfork = (bma->flags & XFS_BMAPI_ATTRFORK) ?
-						XFS_ATTR_FORK : XFS_DATA_FORK;
+	int			whichfork = xfs_bmapi_whichfork(bma->flags);
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
@@ -4539,7 +4552,7 @@ xfs_bmapi_allocate(
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel)
-		error = xfs_bmap_add_extent_delay_real(bma);
+		error = xfs_bmap_add_extent_delay_real(bma, whichfork);
 	else
 		error = xfs_bmap_add_extent_hole_real(bma, whichfork);
 
@@ -4693,8 +4706,7 @@ xfs_bmapi_write(
 	orig_mval = mval;
 	orig_nmap = *nmap;
 #endif
-	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-		XFS_ATTR_FORK : XFS_DATA_FORK;
+	whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
@@ -4705,6 +4717,11 @@ xfs_bmapi_write(
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
@@ -4775,6 +4792,8 @@ xfs_bmapi_write(
 		 */
 		if (flags & XFS_BMAPI_REMAP)
 			ASSERT(inhole);
+		if (flags & XFS_BMAPI_COWFORK)
+			ASSERT(!inhole);
 
 		/*
 		 * First, deal with the hole before the allocated space
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index afb62e0..13629d2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -324,9 +324,11 @@ xfs_map_blocks(
 
 	if (type == XFS_IO_DELALLOC &&
 	    (!nimaps || isnullstartblock(imap->br_startblock))) {
-		error = xfs_iomap_write_allocate(ip, offset, imap);
+		error = xfs_iomap_write_allocate(ip, XFS_DATA_FORK, offset,
+				imap);
 		if (!error)
-			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
+			trace_xfs_map_blocks_alloc(ip, offset, count, type,
+					imap);
 		return error;
 	}
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 53e027c..d183b2a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -713,6 +713,7 @@ xfs_iomap_cow_delay(
 int
 xfs_iomap_write_allocate(
 	xfs_inode_t	*ip,
+	int		whichfork,
 	xfs_off_t	offset,
 	xfs_bmbt_irec_t *imap)
 {
@@ -725,8 +726,12 @@ xfs_iomap_write_allocate(
 	xfs_trans_t	*tp;
 	int		nimaps, committed;
 	int		error = 0;
+	int		flags = 0;
 	int		nres;
 
+	if (whichfork == XFS_COW_FORK)
+		flags |= XFS_BMAPI_COWFORK;
+
 	/*
 	 * Make sure that the dquots are there.
 	 */
@@ -818,7 +823,7 @@ xfs_iomap_write_allocate(
 			 * pointer that the caller gave to us.
 			 */
 			error = xfs_bmapi_write(tp, ip, map_start_fsb,
-						count_fsb, 0, &first_block,
+						count_fsb, flags, &first_block,
 						nres, imap, &nimaps,
 						&free_list);
 			if (error)
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index f6a9adf..ba037d6 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -25,7 +25,7 @@ int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *, int);
 int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *);
-int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
+int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
 			struct xfs_bmbt_irec *);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
 int xfs_iomap_cow_delay(struct xfs_inode *, xfs_off_t, size_t,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
