Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIK1XaV241050 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 14:01:33 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	eXAb0gz4bWuhecYH for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 12:01:31 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RcMvL-0000vz-Bd
	for xfs@oss.sgi.com; Sun, 18 Dec 2011 20:01:31 +0000
Message-Id: <20111218200131.321997628@bombadil.infradead.org>
Date: Sun, 18 Dec 2011 15:00:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/11] xfs: remove the if_ext_max field in struct xfs_ifork
References: <20111218200003.557507716@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-ifp-if_ext_max
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

We spent a lot of effort to maintain this field, but it always equalts to the
fork size divided by the constant size of an extent.  The prime use of it is
to assert that the two stay in sync.  Just divide the fork size by the extent
size in the few places that we actually use it and remove the overhead
of maintaining it.  Also introduce a few helpers to consolidate the places
where we actually care about the value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_attr_leaf.c  |    9 ----
 fs/xfs/xfs_bmap.c       |  101 +++++++++++++++++++++---------------------------
 fs/xfs/xfs_dfrag.c      |   39 +++++++++---------
 fs/xfs/xfs_iget.c       |    2 
 fs/xfs/xfs_inode.c      |   30 ++++----------
 fs/xfs/xfs_inode.h      |    4 -
 fs/xfs/xfs_inode_item.c |    2 
 fs/xfs/xfs_trace.h      |    5 --
 8 files changed, 78 insertions(+), 114 deletions(-)

Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2011-12-12 10:33:55.735363609 -0800
+++ xfs/fs/xfs/xfs_attr_leaf.c	2011-12-14 05:15:20.609040372 -0800
@@ -271,10 +271,6 @@ xfs_attr_shortform_add(xfs_da_args_t *ar
 	dp = args->dp;
 	mp = dp->i_mount;
 	dp->i_d.di_forkoff = forkoff;
-	dp->i_df.if_ext_max =
-		XFS_IFORK_DSIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
-	dp->i_afp->if_ext_max =
-		XFS_IFORK_ASIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
 
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
@@ -326,7 +322,6 @@ xfs_attr_fork_reset(
 	ASSERT(ip->i_d.di_anextents == 0);
 	ASSERT(ip->i_afp == NULL);
 
-	ip->i_df.if_ext_max = XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
@@ -389,10 +384,6 @@ xfs_attr_shortform_remove(xfs_da_args_t
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
 				dp->i_d.di_format == XFS_DINODE_FMT_BTREE);
-		dp->i_afp->if_ext_max =
-			XFS_IFORK_ASIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
-		dp->i_df.if_ext_max =
-			XFS_IFORK_DSIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-12-12 10:33:55.748696870 -0800
+++ xfs/fs/xfs/xfs_bmap.c	2011-12-14 05:15:20.612373687 -0800
@@ -249,7 +249,27 @@ xfs_bmbt_lookup_ge(
 }
 
 /*
-* Update the record referred to by cur to the value given
+ * Check if the inode needs to be converted to btree format.
+ */
+static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
+{
+	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+		XFS_IFORK_NEXTENTS(ip, whichfork) >
+			XFS_IFORK_MAXEXT(ip, whichfork);
+}
+
+/*
+ * Check if the inode should be converted to extent format.
+ */
+static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
+{
+	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
+		XFS_IFORK_NEXTENTS(ip, whichfork) <=
+			XFS_IFORK_MAXEXT(ip, whichfork);
+}
+
+/*
+ * Update the record referred to by cur to the value given
  * by [off, bno, len, state].
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
@@ -683,8 +703,8 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		if (bma->ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-		    bma->ip->i_d.di_nextents > bma->ip->i_df.if_ext_max) {
+
+		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
 					bma->firstblock, bma->flist,
 					&bma->cur, 1, &tmp_rval, XFS_DATA_FORK);
@@ -767,8 +787,8 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		if (bma->ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-		    bma->ip->i_d.di_nextents > bma->ip->i_df.if_ext_max) {
+
+		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
 				bma->firstblock, bma->flist, &bma->cur, 1,
 				&tmp_rval, XFS_DATA_FORK);
@@ -836,8 +856,8 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		if (bma->ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-		    bma->ip->i_d.di_nextents > bma->ip->i_df.if_ext_max) {
+
+		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
 					bma->firstblock, bma->flist, &bma->cur,
 					1, &tmp_rval, XFS_DATA_FORK);
@@ -884,8 +904,7 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* convert to a btree if necessary */
-	if (XFS_IFORK_FORMAT(bma->ip, XFS_DATA_FORK) == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(bma->ip, XFS_DATA_FORK) > ifp->if_ext_max) {
+	if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(bma->cur == NULL);
@@ -1421,8 +1440,7 @@ xfs_bmap_add_extent_unwritten_real(
 	}
 
 	/* convert to a btree if necessary */
-	if (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > ifp->if_ext_max) {
+	if (xfs_bmap_needs_btree(ip, XFS_DATA_FORK)) {
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
@@ -1812,8 +1830,7 @@ xfs_bmap_add_extent_hole_real(
 	}
 
 	/* convert to a btree if necessary */
-	if (XFS_IFORK_FORMAT(bma->ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(bma->ip, whichfork) > ifp->if_ext_max) {
+	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(bma->cur == NULL);
@@ -3037,8 +3054,7 @@ xfs_bmap_extents_to_btree(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS);
-	ASSERT(ifp->if_ext_max ==
-	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
+
 	/*
 	 * Make space in the inode incore.
 	 */
@@ -3184,13 +3200,8 @@ xfs_bmap_forkoff_reset(
 	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE) {
 		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
 
-		if (dfl_forkoff > ip->i_d.di_forkoff) {
+		if (dfl_forkoff > ip->i_d.di_forkoff)
 			ip->i_d.di_forkoff = dfl_forkoff;
-			ip->i_df.if_ext_max =
-				XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t);
-			ip->i_afp->if_ext_max =
-				XFS_IFORK_ASIZE(ip) / sizeof(xfs_bmbt_rec_t);
-		}
 	}
 }
 
@@ -3430,8 +3441,6 @@ xfs_bmap_add_attrfork(
 	int			error;		/* error return value */
 
 	ASSERT(XFS_IFORK_Q(ip) == 0);
-	ASSERT(ip->i_df.if_ext_max ==
-	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
 
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
@@ -3486,12 +3495,9 @@ xfs_bmap_add_attrfork(
 		error = XFS_ERROR(EINVAL);
 		goto error1;
 	}
-	ip->i_df.if_ext_max =
-		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
+
 	ASSERT(ip->i_afp == NULL);
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
-	ip->i_afp->if_ext_max =
-		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
 	xfs_bmap_init(&flist, &firstblock);
@@ -3535,20 +3541,17 @@ xfs_bmap_add_attrfork(
 		} else
 			spin_unlock(&mp->m_sb_lock);
 	}
-	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
+
+	error = xfs_bmap_finish(&tp, &flist, &committed);
+	if (error)
 		goto error2;
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	ASSERT(ip->i_df.if_ext_max ==
-	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
-	return error;
+	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 error2:
 	xfs_bmap_cancel(&flist);
 error1:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 error0:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	ASSERT(ip->i_df.if_ext_max ==
-	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
 	return error;
 }
 
@@ -4379,8 +4382,6 @@ xfs_bmapi_read(
 	XFS_STATS_INC(xs_blk_mapr);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(ifp->if_ext_max ==
-	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, ip, whichfork);
@@ -4871,8 +4872,6 @@ xfs_bmapi_write(
 		return XFS_ERROR(EIO);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(ifp->if_ext_max ==
-	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
 
 	XFS_STATS_INC(xs_blk_mapw);
 
@@ -4981,8 +4980,7 @@ xfs_bmapi_write(
 	/*
 	 * Transform from btree to extents, give it cur.
 	 */
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_NEXTENTS(ip, whichfork) <= ifp->if_ext_max) {
+	if (xfs_bmap_wants_extents(ip, whichfork)) {
 		int		tmp_logflags = 0;
 
 		ASSERT(bma.cur);
@@ -4992,10 +4990,10 @@ xfs_bmapi_write(
 		if (error)
 			goto error0;
 	}
-	ASSERT(ifp->if_ext_max ==
-	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
+
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE ||
-	       XFS_IFORK_NEXTENTS(ip, whichfork) > ifp->if_ext_max);
+	       XFS_IFORK_NEXTENTS(ip, whichfork) >
+		XFS_IFORK_MAXEXT(ip, whichfork));
 	error = 0;
 error0:
 	/*
@@ -5095,8 +5093,7 @@ xfs_bunmapi(
 
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
-	ASSERT(ifp->if_ext_max ==
-	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
+
 	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
 	    (error = xfs_iread_extents(tp, ip, whichfork)))
 		return error;
@@ -5321,8 +5318,7 @@ xfs_bunmapi(
 		 * will be dirty.
 		 */
 		if (!wasdel && xfs_trans_get_block_res(tp) == 0 &&
-		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
-		    XFS_IFORK_NEXTENTS(ip, whichfork) >= ifp->if_ext_max &&
+		    xfs_bmap_needs_btree(ip, whichfork) &&
 		    del.br_startoff > got.br_startoff &&
 		    del.br_startoff + del.br_blockcount <
 		    got.br_startoff + got.br_blockcount) {
@@ -5353,13 +5349,11 @@ nodelete:
 		}
 	}
 	*done = bno == (xfs_fileoff_t)-1 || bno < start || lastx < 0;
-	ASSERT(ifp->if_ext_max ==
-	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
+
 	/*
 	 * Convert to a btree if necessary.
 	 */
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(ip, whichfork) > ifp->if_ext_max) {
+	if (xfs_bmap_needs_btree(ip, whichfork)) {
 		ASSERT(cur == NULL);
 		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, flist,
 			&cur, 0, &tmp_logflags, whichfork);
@@ -5370,8 +5364,7 @@ nodelete:
 	/*
 	 * transform from btree to extents, give it cur
 	 */
-	else if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
-		 XFS_IFORK_NEXTENTS(ip, whichfork) <= ifp->if_ext_max) {
+	else if (xfs_bmap_wants_extents(ip, whichfork)) {
 		ASSERT(cur != NULL);
 		error = xfs_bmap_btree_to_extents(tp, ip, cur, &tmp_logflags,
 			whichfork);
@@ -5382,8 +5375,6 @@ nodelete:
 	/*
 	 * transform from extents to local?
 	 */
-	ASSERT(ifp->if_ext_max ==
-	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
 	error = 0;
 error0:
 	/*
Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2011-12-12 10:33:55.758696817 -0800
+++ xfs/fs/xfs/xfs_dfrag.c	2011-12-14 05:16:50.911884493 -0800
@@ -163,12 +163,14 @@ xfs_swap_extents_check_format(
 
 	/* Check temp in extent form to max in target */
 	if (tip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) > ip->i_df.if_ext_max)
+	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) >
+			XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
 		return EINVAL;
 
 	/* Check target in extent form to max in temp */
 	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > tip->i_df.if_ext_max)
+	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) >
+			XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
 		return EINVAL;
 
 	/*
@@ -180,18 +182,25 @@ xfs_swap_extents_check_format(
 	 * (a common defrag case) which will occur when the temp inode is in
 	 * extent format...
 	 */
-	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
-	    ((XFS_IFORK_BOFF(ip) &&
-	      tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip)) ||
-	     XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <= ip->i_df.if_ext_max))
-		return EINVAL;
+	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+		if (XFS_IFORK_BOFF(ip) &&
+		    tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip))
+			return EINVAL;
+		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
+		    XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
+			return EINVAL;
+	}
 
 	/* Reciprocal target->temp btree format checks */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
-	    ((XFS_IFORK_BOFF(tip) &&
-	      ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip)) ||
-	     XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <= tip->i_df.if_ext_max))
-		return EINVAL;
+	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+		if (XFS_IFORK_BOFF(tip) &&
+		    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip))
+			return EINVAL;
+
+		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
+		    XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
+			return EINVAL;
+	}
 
 	return 0;
 }
@@ -349,16 +358,6 @@ xfs_swap_extents(
 	*tifp = *tempifp;	/* struct copy */
 
 	/*
-	 * Fix the in-memory data fork values that are dependent on the fork
-	 * offset in the inode. We can't assume they remain the same as attr2
-	 * has dynamic fork offsets.
-	 */
-	ifp->if_ext_max = XFS_IFORK_SIZE(ip, XFS_DATA_FORK) /
-					(uint)sizeof(xfs_bmbt_rec_t);
-	tifp->if_ext_max = XFS_IFORK_SIZE(tip, XFS_DATA_FORK) /
-					(uint)sizeof(xfs_bmbt_rec_t);
-
-	/*
 	 * Fix the on-disk inode values
 	 */
 	tmp = (__uint64_t)ip->i_d.di_nblocks;
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2011-12-12 10:33:55.772030077 -0800
+++ xfs/fs/xfs/xfs_iget.c	2011-12-14 05:15:20.612373687 -0800
@@ -451,8 +451,6 @@ again:
 
 	*ipp = ip;
 
-	ASSERT(ip->i_df.if_ext_max ==
-	       XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t));
 	/*
 	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
 	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-12-14 05:14:09.522758812 -0800
+++ xfs/fs/xfs/xfs_inode.c	2011-12-14 05:15:20.612373687 -0800
@@ -299,11 +299,8 @@ xfs_iformat(
 {
 	xfs_attr_shortform_t	*atp;
 	int			size;
-	int			error;
+	int			error = 0;
 	xfs_fsize_t             di_size;
-	ip->i_df.if_ext_max =
-		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
-	error = 0;
 
 	if (unlikely(be32_to_cpu(dip->di_nextents) +
 		     be16_to_cpu(dip->di_anextents) >
@@ -409,10 +406,10 @@ xfs_iformat(
 	}
 	if (!XFS_DFORK_Q(dip))
 		return 0;
+
 	ASSERT(ip->i_afp == NULL);
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP | KM_NOFS);
-	ip->i_afp->if_ext_max =
-		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
+
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
@@ -604,10 +601,11 @@ xfs_iformat_btree(
 	 * or the number of extents is greater than the number of
 	 * blocks.
 	 */
-	if (unlikely(XFS_IFORK_NEXTENTS(ip, whichfork) <= ifp->if_ext_max
-	    || XFS_BMDR_SPACE_CALC(nrecs) >
-			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork)
-	    || XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks)) {
+	if (unlikely(XFS_IFORK_NEXTENTS(ip, whichfork) <=
+			XFS_IFORK_MAXEXT(ip, whichfork) ||
+		     XFS_BMDR_SPACE_CALC(nrecs) >
+			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork) ||
+		     XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks)) {
 		xfs_warn(ip->i_mount, "corrupt inode %Lu (btree).",
 			(unsigned long long) ip->i_ino);
 		XFS_CORRUPTION_ERROR("xfs_iformat_btree", XFS_ERRLEVEL_LOW,
@@ -835,12 +833,6 @@ xfs_iread(
 		 * with the uninitialized part of it.
 		 */
 		ip->i_d.di_mode = 0;
-		/*
-		 * Initialize the per-fork minima and maxima for a new
-		 * inode here.  xfs_iformat will do it for old inodes.
-		 */
-		ip->i_df.if_ext_max =
-			XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	}
 
 	/*
@@ -1740,8 +1732,6 @@ xfs_ifree(
 	ip->i_d.di_flags = 0;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_df.if_ext_max =
-		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	/*
@@ -2408,7 +2398,7 @@ xfs_iflush(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(!completion_done(&ip->i_flush));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
-	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
+	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 
 	iip = ip->i_itemp;
 	mp = ip->i_mount;
@@ -2524,7 +2514,7 @@ xfs_iflush_int(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(!completion_done(&ip->i_flush));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
-	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
+	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 
 	iip = ip->i_itemp;
 	mp = ip->i_mount;
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-12-12 10:33:55.795363284 -0800
+++ xfs/fs/xfs/xfs_inode_item.c	2011-12-14 05:15:20.615707002 -0800
@@ -79,8 +79,6 @@ xfs_inode_item_size(
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(ip->i_df.if_ext_max ==
-		       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
 		iip->ili_format.ilf_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
 			  XFS_ILOG_DEV | XFS_ILOG_UUID);
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-12-14 05:14:09.526092127 -0800
+++ xfs/fs/xfs/xfs_trace.h	2011-12-14 05:15:20.615707002 -0800
@@ -1568,7 +1568,6 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_clas
 		__field(xfs_ino_t, ino)
 		__field(int, format)
 		__field(int, nex)
-		__field(int, max_nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
@@ -1578,18 +1577,16 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_clas
 		__entry->ino = ip->i_ino;
 		__entry->format = ip->i_d.di_format;
 		__entry->nex = ip->i_d.di_nextents;
-		__entry->max_nex = ip->i_df.if_ext_max;
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
 	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
-		  "Max in-fork extents %d, broot size %d, fork offset %d",
+		  "broot size %d, fork offset %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_symbolic(__entry->which, XFS_SWAPEXT_INODES),
 		  __print_symbolic(__entry->format, XFS_INODE_FORMAT_STR),
 		  __entry->nex,
-		  __entry->max_nex,
 		  __entry->broot_size,
 		  __entry->fork_off)
 )
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-12-14 05:15:18.779050287 -0800
+++ xfs/fs/xfs/xfs_inode.h	2011-12-14 05:15:20.615707002 -0800
@@ -66,7 +66,6 @@ typedef struct xfs_ifork {
 	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	unsigned char		if_flags;	/* per-fork flags */
-	unsigned char		if_ext_max;	/* max # of extent records */
 	union {
 		xfs_bmbt_rec_host_t *if_extents;/* linear map file exts */
 		xfs_ext_irec_t	*if_ext_irec;	/* irec map file exts */
@@ -206,7 +205,8 @@ typedef struct xfs_icdinode {
 	((w) == XFS_DATA_FORK ? \
 		((ip)->i_d.di_nextents = (n)) : \
 		((ip)->i_d.di_anextents = (n)))
-
+#define XFS_IFORK_MAXEXT(ip, w) \
+	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
 
 
 #ifdef __KERNEL__

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
