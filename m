Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933565AbeGCRXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6574D81A8A1B
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 507C91117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 17/25] xfs: remove bmap format helpers firstblock params
Date: Tue,  3 Jul 2018 13:23:11 -0400
Message-Id: <20180703172319.24509-18-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The bmap format helpers receive firstblock via ->t_firstblock. Drop
the param and access it directly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 63 ++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index adc45a0941ff..016712434aa5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -646,7 +646,6 @@ STATIC int					/* error */
 xfs_bmap_extents_to_btree(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode pointer */
-	xfs_fsblock_t		*firstblock,	/* first-block-allocated */
 	struct xfs_btree_cur	**curp,		/* cursor returned to caller */
 	int			wasdel,		/* converting a delayed alloc */
 	int			*logflagsp,	/* inode logging flags */
@@ -689,7 +688,7 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_private.b.firstblock = *firstblock;
+	cur->bc_private.b.firstblock = tp->t_firstblock;
 	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
@@ -699,16 +698,16 @@ xfs_bmap_extents_to_btree(
 	args.tp = tp;
 	args.mp = mp;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
-	args.firstblock = *firstblock;
-	if (*firstblock == NULLFSBLOCK) {
+	args.firstblock = tp->t_firstblock;
+	if (tp->t_firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
 	} else if (tp->t_dfops->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = *firstblock;
+		args.fsbno = tp->t_firstblock;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.fsbno = *firstblock;
+		args.fsbno = tp->t_firstblock;
 	}
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
@@ -731,9 +730,9 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Allocation can't fail, the space was reserved.
 	 */
-	ASSERT(*firstblock == NULLFSBLOCK ||
-	       args.agno >= XFS_FSB_TO_AGNO(mp, *firstblock));
-	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
+	ASSERT(tp->t_firstblock == NULLFSBLOCK ||
+	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
+	tp->t_firstblock = cur->bc_private.b.firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
@@ -810,7 +809,6 @@ STATIC int				/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_fsblock_t	*firstblock,	/* first block allocated in xaction */
 	xfs_extlen_t	total,		/* total blocks needed by transaction */
 	int		*logflagsp,	/* inode logging flags */
 	int		whichfork,
@@ -848,16 +846,16 @@ xfs_bmap_local_to_extents(
 	args.tp = tp;
 	args.mp = ip->i_mount;
 	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
-	args.firstblock = *firstblock;
+	args.firstblock = tp->t_firstblock;
 	/*
 	 * Allocate a block.  We know we need only one, since the
 	 * file currently fits in an inode.
 	 */
-	if (*firstblock == NULLFSBLOCK) {
+	if (tp->t_firstblock == NULLFSBLOCK) {
 		args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
-		args.fsbno = *firstblock;
+		args.fsbno = tp->t_firstblock;
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	}
 	args.total = total;
@@ -869,7 +867,7 @@ xfs_bmap_local_to_extents(
 	/* Can't fail, the space was reserved. */
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(args.len == 1);
-	*firstblock = args.fsbno;
+	tp->t_firstblock = args.fsbno;
 	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
 
 	/*
@@ -964,8 +962,8 @@ xfs_bmap_add_attrfork_extents(
 	if (ip->i_d.di_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
 		return 0;
 	cur = NULL;
-	error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock, &cur, 0,
-					  flags, XFS_DATA_FORK);
+	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
+					  XFS_DATA_FORK);
 	if (cur) {
 		cur->bc_private.b.allocated = 0;
 		xfs_btree_del_cursor(cur,
@@ -1007,8 +1005,8 @@ xfs_bmap_add_attrfork_local(
 	}
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
-		return xfs_bmap_local_to_extents(tp, ip, &tp->t_firstblock, 1,
-						 flags, XFS_DATA_FORK,
+		return xfs_bmap_local_to_extents(tp, ip, 1, flags,
+						 XFS_DATA_FORK,
 						 xfs_symlink_local_to_remote);
 
 	/* should only be called for types that support local format data */
@@ -1794,8 +1792,7 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-					&bma->tp->t_firstblock, &bma->cur, 1,
-					&tmp_rval, whichfork);
+					&bma->cur, 1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -1872,8 +1869,7 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				&bma->tp->t_firstblock, &bma->cur, 1, &tmp_rval,
-				whichfork);
+				&bma->cur, 1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -1953,8 +1949,7 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-					&bma->tp->t_firstblock, &bma->cur, 1,
-					&tmp_rval, whichfork);
+					&bma->cur, 1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -1991,8 +1986,8 @@ xfs_bmap_add_extent_delay_real(
 
 		ASSERT(bma->cur == NULL);
 		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				&bma->tp->t_firstblock, &bma->cur, da_old > 0,
-				&tmp_logflags, whichfork);
+				&bma->cur, da_old > 0, &tmp_logflags,
+				whichfork);
 		bma->logflags |= tmp_logflags;
 		if (error)
 			goto done;
@@ -2472,8 +2467,8 @@ xfs_bmap_add_extent_unwritten_real(
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock,
-				&cur, 0, &tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0,
+				&tmp_logflags, whichfork);
 		*logflagsp |= tmp_logflags;
 		if (error)
 			goto done;
@@ -2835,8 +2830,8 @@ xfs_bmap_add_extent_hole_real(
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock,
-				curp, 0, &tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, curp, 0,
+				&tmp_logflags, whichfork);
 		*logflagsp |= tmp_logflags;
 		cur = *curp;
 		if (error)
@@ -5425,8 +5420,8 @@ __xfs_bunmapi(
 	 */
 	if (xfs_bmap_needs_btree(ip, whichfork)) {
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock,
-				&cur, 0, &tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0,
+				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
@@ -5969,8 +5964,8 @@ xfs_bmap_split_extent_at(
 		int tmp_logflags; /* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock,
-				&cur, 0, &tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0,
+				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 	}
 
-- 
2.17.1

