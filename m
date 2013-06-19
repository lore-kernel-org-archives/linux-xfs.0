Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2AFF029E2D
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:51:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB9DAAC004
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:51:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1oJSwmNTbB6bDTBk for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:51:39 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpAMq-0002yk-Jf
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:36 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpAMq-0008WC-FL
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/60] xfs: remove local fork format handling from
	xfs_bmapi_write()
Date: Wed, 19 Jun 2013 14:50:21 +1000
Message-Id: <1371617468-32559-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The conversion from local format to extent format requires
interpretation of the data in the fork being converted, so it cannot
be done in a generic way. It is up to the caller to convert the fork
format to extent format before calling into xfs_bmapi_write() so
format conversion can be done correctly.

The code in xfs_bmapi_write() to convert the format is used
implicitly by the attribute and directory code, but they
specifically zero the fork size so that the conversion does not do
any allocation or manipulation. Move this conversion into the
shortform to leaf functions for the dir/attr code so the conversions
are explicitly controlled by all callers.

Now we can remove the conversion code in xfs_bmapi_write.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c  |    2 +
 fs/xfs/xfs_bmap.c       |  199 ++++++++++++++++++++---------------------------
 fs/xfs/xfs_bmap.h       |    1 +
 fs/xfs/xfs_dir2_block.c |   20 +++--
 4 files changed, 98 insertions(+), 124 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 31d3cd1..b800fbc 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -690,6 +690,8 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	sf = (xfs_attr_shortform_t *)tmpbuffer;
 
 	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
+	xfs_bmap_local_to_extents_empty(dp, XFS_ATTR_FORK);
+
 	bp = NULL;
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error) {
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 8904284..05c698c 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1161,6 +1161,24 @@ xfs_bmap_extents_to_btree(
  * since the file data needs to get logged so things will stay consistent.
  * (The bmap-level manipulations are ok, though).
  */
+void
+xfs_bmap_local_to_extents_empty(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+
+	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ifp->if_bytes == 0);
+	ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
+
+	xfs_bmap_forkoff_reset(ip->i_mount, ip, whichfork);
+	ifp->if_flags &= ~XFS_IFINLINE;
+	ifp->if_flags |= XFS_IFEXTENTS;
+	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+}
+
+
 STATIC int				/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
@@ -1174,9 +1192,12 @@ xfs_bmap_local_to_extents(
 				   struct xfs_inode *ip,
 				   struct xfs_ifork *ifp))
 {
-	int		error;		/* error return value */
+	int		error = 0;
 	int		flags;		/* logging flags returned */
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
+	xfs_alloc_arg_t	args;		/* allocation arguments */
+	xfs_buf_t	*bp;		/* buffer for extent block */
+	xfs_bmbt_rec_host_t *ep;	/* extent record pointer */
 
 	/*
 	 * We don't want to deal with the case of keeping inode data inline yet.
@@ -1185,68 +1206,65 @@ xfs_bmap_local_to_extents(
 	ASSERT(!(S_ISREG(ip->i_d.di_mode) && whichfork == XFS_DATA_FORK));
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
+
+	if (!ifp->if_bytes) {
+		xfs_bmap_local_to_extents_empty(ip, whichfork);
+		flags = XFS_ILOG_CORE;
+		goto done;
+	}
+
 	flags = 0;
 	error = 0;
-	if (ifp->if_bytes) {
-		xfs_alloc_arg_t	args;	/* allocation arguments */
-		xfs_buf_t	*bp;	/* buffer for extent block */
-		xfs_bmbt_rec_host_t *ep;/* extent record pointer */
-
-		ASSERT((ifp->if_flags &
-			(XFS_IFINLINE|XFS_IFEXTENTS|XFS_IFEXTIREC)) == XFS_IFINLINE);
-		memset(&args, 0, sizeof(args));
-		args.tp = tp;
-		args.mp = ip->i_mount;
-		args.firstblock = *firstblock;
-		/*
-		 * Allocate a block.  We know we need only one, since the
-		 * file currently fits in an inode.
-		 */
-		if (*firstblock == NULLFSBLOCK) {
-			args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
-			args.type = XFS_ALLOCTYPE_START_BNO;
-		} else {
-			args.fsbno = *firstblock;
-			args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		}
-		args.total = total;
-		args.minlen = args.maxlen = args.prod = 1;
-		error = xfs_alloc_vextent(&args);
-		if (error)
-			goto done;
-
-		/* Can't fail, the space was reserved. */
-		ASSERT(args.fsbno != NULLFSBLOCK);
-		ASSERT(args.len == 1);
-		*firstblock = args.fsbno;
-		bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
-
-		/* initialise the block and copy the data */
-		init_fn(tp, bp, ip, ifp);
-
-		/* account for the change in fork size and log everything */
-		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
-		xfs_bmap_forkoff_reset(args.mp, ip, whichfork);
-		xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
-		xfs_iext_add(ifp, 0, 1);
-		ep = xfs_iext_get_ext(ifp, 0);
-		xfs_bmbt_set_allf(ep, 0, args.fsbno, 1, XFS_EXT_NORM);
-		trace_xfs_bmap_post_update(ip, 0,
-				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0,
-				_THIS_IP_);
-		XFS_IFORK_NEXT_SET(ip, whichfork, 1);
-		ip->i_d.di_nblocks = 1;
-		xfs_trans_mod_dquot_byino(tp, ip,
-			XFS_TRANS_DQ_BCOUNT, 1L);
-		flags |= xfs_ilog_fext(whichfork);
+	ASSERT((ifp->if_flags & (XFS_IFINLINE|XFS_IFEXTENTS|XFS_IFEXTIREC)) ==
+								XFS_IFINLINE);
+	memset(&args, 0, sizeof(args));
+	args.tp = tp;
+	args.mp = ip->i_mount;
+	args.firstblock = *firstblock;
+	/*
+	 * Allocate a block.  We know we need only one, since the
+	 * file currently fits in an inode.
+	 */
+	if (*firstblock == NULLFSBLOCK) {
+		args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
+		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
-		ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
-		xfs_bmap_forkoff_reset(ip->i_mount, ip, whichfork);
+		args.fsbno = *firstblock;
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	}
-	ifp->if_flags &= ~XFS_IFINLINE;
-	ifp->if_flags |= XFS_IFEXTENTS;
-	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	args.total = total;
+	args.minlen = args.maxlen = args.prod = 1;
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto done;
+
+	/* Can't fail, the space was reserved. */
+	ASSERT(args.fsbno != NULLFSBLOCK);
+	ASSERT(args.len == 1);
+	*firstblock = args.fsbno;
+	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
+
+	/* initialise the block and copy the data */
+	init_fn(tp, bp, ip, ifp);
+
+	/* account for the change in fork size and log everything */
+	xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
+	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
+	xfs_bmap_local_to_extents_empty(ip, whichfork);
 	flags |= XFS_ILOG_CORE;
+
+	xfs_iext_add(ifp, 0, 1);
+	ep = xfs_iext_get_ext(ifp, 0);
+	xfs_bmbt_set_allf(ep, 0, args.fsbno, 1, XFS_EXT_NORM);
+	trace_xfs_bmap_post_update(ip, 0,
+			whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0,
+			_THIS_IP_);
+	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
+	ip->i_d.di_nblocks = 1;
+	xfs_trans_mod_dquot_byino(tp, ip,
+		XFS_TRANS_DQ_BCOUNT, 1L);
+	flags |= xfs_ilog_fext(whichfork);
+
 done:
 	*logflagsp = flags;
 	return error;
@@ -1323,25 +1341,6 @@ xfs_bmap_add_attrfork_extents(
 }
 
 /*
- * Block initialisation function for local to extent format conversion.
- *
- * This shouldn't actually be called by anyone, so make sure debug kernels cause
- * a noticable failure.
- */
-STATIC void
-xfs_bmap_local_to_extents_init_fn(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
-	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
-{
-	ASSERT(0);
-	bp->b_ops = &xfs_bmbt_buf_ops;
-	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
-	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
-}
-
-/*
  * Called from xfs_bmap_add_attrfork to handle local format files. Each
  * different data fork content type needs a different callout to do the
  * conversion. Some are basic and only require special block initialisation
@@ -1381,9 +1380,9 @@ xfs_bmap_add_attrfork_local(
 						 flags, XFS_DATA_FORK,
 						 xfs_symlink_local_to_remote);
 
-	return xfs_bmap_local_to_extents(tp, ip, firstblock, 1, flags,
-					 XFS_DATA_FORK,
-					 xfs_bmap_local_to_extents_init_fn);
+	/* should only be called for types that support local format data */
+	ASSERT(0);
+	return EFSCORRUPTED;
 }
 
 /*
@@ -4907,20 +4906,19 @@ xfs_bmapi_write(
 	orig_mval = mval;
 	orig_nmap = *nmap;
 #endif
+	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
+		XFS_ATTR_FORK : XFS_DATA_FORK;
 
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
 	ASSERT(!(flags & XFS_BMAPI_IGSTATE));
 	ASSERT(tp != NULL);
 	ASSERT(len > 0);
-
-	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-		XFS_ATTR_FORK : XFS_DATA_FORK;
+	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL),
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_write", XFS_ERRLEVEL_LOW, mp);
 		return XFS_ERROR(EFSCORRUPTED);
@@ -4933,37 +4931,6 @@ xfs_bmapi_write(
 
 	XFS_STATS_INC(xs_blk_mapw);
 
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
-		/*
-		 * XXX (dgc): This assumes we are only called for inodes that
-		 * contain content neutral data in local format. Anything that
-		 * contains caller-specific data in local format that needs
-		 * transformation to move to a block format needs to do the
-		 * conversion to extent format itself.
-		 *
-		 * Directory data forks and attribute forks handle this
-		 * themselves, but with the addition of metadata verifiers every
-		 * data fork in local format now contains caller specific data
-		 * and as such conversion through this function is likely to be
-		 * broken.
-		 *
-		 * The only likely user of this branch is for remote symlinks,
-		 * but we cannot overwrite the data fork contents of the symlink
-		 * (EEXIST occurs higher up the stack) and so it will never go
-		 * from local format to extent format here. Hence I don't think
-		 * this branch is ever executed intentionally and we should
-		 * consider removing it and asserting that xfs_bmapi_write()
-		 * cannot be called directly on local format forks. i.e. callers
-		 * are completely responsible for local to extent format
-		 * conversion, not xfs_bmapi_write().
-		 */
-		error = xfs_bmap_local_to_extents(tp, ip, firstblock, total,
-					&bma.logflags, whichfork,
-					xfs_bmap_local_to_extents_init_fn);
-		if (error)
-			goto error0;
-	}
-
 	if (*firstblock == NULLFSBLOCK) {
 		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
 			bma.minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 5f469c3..1cf1292 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -172,6 +172,7 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 #endif
 
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
 		struct xfs_bmap_free *flist, struct xfs_mount *mp);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index e59f5fc..53b9aa2 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -29,6 +29,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
+#include "xfs_bmap.h"
 #include "xfs_buf_item.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
@@ -1167,13 +1168,15 @@ xfs_dir2_sf_to_block(
 	__be16			*tagp;		/* end of data entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_name		name;
+	struct xfs_ifork	*ifp;
 
 	trace_xfs_dir2_sf_to_block(args);
 
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
+	ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
+	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	/*
 	 * Bomb out if the shortform directory is way too short.
 	 */
@@ -1182,22 +1185,23 @@ xfs_dir2_sf_to_block(
 		return XFS_ERROR(EIO);
 	}
 
-	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
 
-	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
-	ASSERT(dp->i_df.if_u1.if_data != NULL);
+	ASSERT(ifp->if_bytes == dp->i_d.di_size);
+	ASSERT(ifp->if_u1.if_data != NULL);
 	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
+	ASSERT(dp->i_d.di_nextents == 0);
 
 	/*
 	 * Copy the directory into a temporary buffer.
 	 * Then pitch the incore inode data so we can make extents.
 	 */
-	sfp = kmem_alloc(dp->i_df.if_bytes, KM_SLEEP);
-	memcpy(sfp, oldsfp, dp->i_df.if_bytes);
+	sfp = kmem_alloc(ifp->if_bytes, KM_SLEEP);
+	memcpy(sfp, oldsfp, ifp->if_bytes);
 
-	xfs_idata_realloc(dp, -dp->i_df.if_bytes, XFS_DATA_FORK);
+	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
+	xfs_bmap_local_to_extents_empty(dp, XFS_DATA_FORK);
 	dp->i_d.di_size = 0;
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
 	/*
 	 * Add block 0 to the inode.
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
