Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55330 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdDLKa1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 06:30:27 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyFXe-0004js-TL
        for linux-xfs@vger.kernel.org; Wed, 12 Apr 2017 10:30:27 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] xfs: introduce xfs_bmapi_remap
Date: Wed, 12 Apr 2017 12:30:11 +0200
Message-Id: <20170412103013.9355-5-hch@lst.de>
In-Reply-To: <20170412103013.9355-1-hch@lst.de>
References: <20170412103013.9355-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add a new helper to be used for reflink extent list additions instead of
funneling them through xfs_bmapi_write and overloading the firstblock
member in struct xfs_bmalloca and struct xfs_alloc_args.

With some small changes to xfs_bmap_remap_alloc this also means we do
not need a xfs_bmalloca structure for this case at all.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 157 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 112 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f32b2dab16a4..a1d9086ac737 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3862,11 +3862,12 @@ xfs_bmap_btalloc(
  */
 STATIC int
 xfs_bmap_remap_alloc(
-	struct xfs_bmalloca	*ap)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		startblock,
+	xfs_extlen_t		length)
 {
-	struct xfs_trans	*tp = ap->tp;
 	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_fsblock_t		bno;
 	struct xfs_alloc_arg	args;
 	int			error;
 
@@ -3875,24 +3876,24 @@ xfs_bmap_remap_alloc(
 	 * and handle a silent filesystem corruption rather than crashing.
 	 */
 	memset(&args, 0, sizeof(struct xfs_alloc_arg));
-	args.tp = ap->tp;
-	args.mp = ap->tp->t_mountp;
-	bno = *ap->firstblock;
-	args.agno = XFS_FSB_TO_AGNO(mp, bno);
-	args.agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	args.tp = tp;
+	args.mp = mp;
+	args.agno = XFS_FSB_TO_AGNO(mp, startblock);
+	args.agbno = XFS_FSB_TO_AGBNO(mp, startblock);
+
 	if (args.agno >= mp->m_sb.sb_agcount ||
 	    args.agbno >= mp->m_sb.sb_agblocks)
 		return -EFSCORRUPTED;
 
 	/* "Allocate" the extent from the range we passed in. */
-	trace_xfs_bmap_remap_alloc(ap->ip, *ap->firstblock, ap->length);
-	ap->blkno = bno;
-	ap->ip->i_d.di_nblocks += ap->length;
-	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+	trace_xfs_bmap_remap_alloc(ip, startblock, length);
+
+	ip->i_d.di_nblocks += length;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	/* Fix the freelist, like a real allocator does. */
-	args.datatype = ap->datatype;
-	args.pag = xfs_perag_get(args.mp, args.agno);
+	args.datatype = XFS_ALLOC_USERDATA | XFS_ALLOC_NOBUSY;
+	args.pag = xfs_perag_get(mp, args.agno);
 	ASSERT(args.pag);
 
 	/*
@@ -3905,7 +3906,7 @@ xfs_bmap_remap_alloc(
 	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
 	xfs_perag_put(args.pag);
 	if (error)
-		trace_xfs_bmap_remap_alloc_error(ap->ip, error, _RET_IP_);
+		trace_xfs_bmap_remap_alloc_error(ip, error, _RET_IP_);
 	return error;
 }
 
@@ -3917,8 +3918,6 @@ STATIC int
 xfs_bmap_alloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
-	if (ap->flags & XFS_BMAPI_REMAP)
-		return xfs_bmap_remap_alloc(ap);
 	if (XFS_IS_REALTIME_INODE(ap->ip) &&
 	    xfs_alloc_is_userdata(ap->datatype))
 		return xfs_bmap_rtalloc(ap);
@@ -4554,9 +4553,7 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!(flags & XFS_BMAPI_REMAP) || whichfork == XFS_DATA_FORK);
-	ASSERT(!(flags & XFS_BMAPI_PREALLOC) || !(flags & XFS_BMAPI_REMAP));
-	ASSERT(!(flags & XFS_BMAPI_CONVERT) || !(flags & XFS_BMAPI_REMAP));
+	ASSERT(!(flags & XFS_BMAPI_REMAP));
 
 	/* zeroing is for currently only for data extents, not metadata */
 	ASSERT((flags & (XFS_BMAPI_METADATA | XFS_BMAPI_ZERO)) !=
@@ -4640,13 +4637,8 @@ xfs_bmapi_write(
 			} else {
 				need_alloc = true;
 			}
-		} else {
-			/*
-			 * Make sure we only reflink into a hole.
-			 */
-			ASSERT(!(flags & XFS_BMAPI_REMAP));
-			if (isnullstartblock(bma.got.br_startblock))
-				wasdelay = true;
+		} else if (isnullstartblock(bma.got.br_startblock)) {
+			wasdelay = true;
 		}
 
 		/*
@@ -4775,6 +4767,94 @@ xfs_bmapi_write(
 	return error;
 }
 
+static int
+xfs_bmapi_remap(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		bno,
+	xfs_filblks_t		len,
+	xfs_fsblock_t		startblock,
+	struct xfs_defer_ops	*dfops)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_btree_cur	*cur = NULL;
+	xfs_fsblock_t		firstblock = NULLFSBLOCK;
+	struct xfs_bmbt_irec	got;
+	xfs_extnum_t		idx;
+	int			logflags = 0, error;
+
+	ASSERT(len > 0);
+	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	if (xfs_iext_lookup_extent(ip, ifp, bno, &idx, &got)) {
+		/* make sure we only reflink into a hole. */
+		ASSERT(got.br_startoff > bno);
+		ASSERT(got.br_startoff - bno >= len);
+	}
+
+	error = xfs_bmap_remap_alloc(tp, ip, startblock, len);
+	if (error)
+		goto error0;
+
+	if (ifp->if_flags & XFS_IFBROOT) {
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
+		cur->bc_private.b.firstblock = firstblock;
+		cur->bc_private.b.dfops = dfops;
+		cur->bc_private.b.flags = 0;
+	}
+
+	got.br_startoff = bno;
+	got.br_startblock = startblock;
+	got.br_blockcount = len;
+	got.br_state = XFS_EXT_NORM;
+
+	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &idx, &cur,
+			&got, &firstblock, dfops, &logflags);
+	if (error)
+		goto error0;
+
+	if (xfs_bmap_wants_extents(ip, XFS_DATA_FORK)) {
+		int		tmp_logflags = 0;
+
+		error = xfs_bmap_btree_to_extents(tp, ip, cur,
+			&tmp_logflags, XFS_DATA_FORK);
+		logflags |= tmp_logflags;
+	}
+
+error0:
+	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS)
+		logflags &= ~XFS_ILOG_DEXT;
+	else if (ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
+		logflags &= ~XFS_ILOG_DBROOT;
+
+	if (logflags)
+		xfs_trans_log_inode(tp, ip, logflags);
+	if (cur) {
+		xfs_btree_del_cursor(cur,
+				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	}
+	return error;
+}
+
 /*
  * When a delalloc extent is split (e.g., due to a hole punch), the original
  * indlen reservation must be shared across the two new extents that are left
@@ -6493,16 +6573,7 @@ xfs_bmap_finish_one(
 	xfs_filblks_t			blockcount,
 	xfs_exntst_t			state)
 {
-	struct xfs_bmbt_irec		bmap;
-	int				nimaps = 1;
-	xfs_fsblock_t			firstfsb;
-	int				done;
-	int				error = 0;
-
-	bmap.br_startblock = startblock;
-	bmap.br_startoff = startoff;
-	bmap.br_blockcount = blockcount;
-	bmap.br_state = state;
+	int				error = 0, done;
 
 	trace_xfs_bmap_deferred(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
@@ -6519,16 +6590,12 @@ xfs_bmap_finish_one(
 
 	switch (type) {
 	case XFS_BMAP_MAP:
-		firstfsb = bmap.br_startblock;
-		error = xfs_bmapi_write(tp, ip, bmap.br_startoff,
-					bmap.br_blockcount, XFS_BMAPI_REMAP, &firstfsb,
-					bmap.br_blockcount, &bmap, &nimaps,
-					dfops);
+		error = xfs_bmapi_remap(tp, ip, startoff, blockcount,
+				startblock, dfops);
 		break;
 	case XFS_BMAP_UNMAP:
-		error = xfs_bunmapi(tp, ip, bmap.br_startoff,
-				bmap.br_blockcount, XFS_BMAPI_REMAP, 1, &firstfsb,
-				dfops, &done);
+		error = xfs_bunmapi(tp, ip, startoff, blockcount,
+				XFS_BMAPI_REMAP, 1, &startblock, dfops, &done);
 		ASSERT(done);
 		break;
 	default:
-- 
2.11.0

