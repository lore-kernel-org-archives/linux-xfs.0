Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932280AbeF1Qgk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CCB78AB407
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7000111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 18/24] xfs: remove dfops param from internal bmap extent helpers
Date: Thu, 28 Jun 2018 12:36:30 -0400
Message-Id: <20180628163636.52564-19-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All callers of the various bmap extent helpers now use ->t_dfops.
Remove the unnecessary dfops params and access ->t_dfops directly.
This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 92 +++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1ce1d10a4140..710e7d0bbf6a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -644,25 +644,24 @@ xfs_bmap_btree_to_extents(
  */
 STATIC int					/* error */
 xfs_bmap_extents_to_btree(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_inode_t		*ip,		/* incore inode pointer */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first-block-allocated */
-	struct xfs_defer_ops	*dfops,		/* blocks freed in xaction */
-	xfs_btree_cur_t		**curp,		/* cursor returned to caller */
+	struct xfs_btree_cur	**curp,		/* cursor returned to caller */
 	int			wasdel,		/* converting a delayed alloc */
 	int			*logflagsp,	/* inode logging flags */
 	int			whichfork)	/* data or attr fork */
 {
 	struct xfs_btree_block	*ablock;	/* allocated (child) bt block */
-	xfs_buf_t		*abp;		/* buffer for ablock */
-	xfs_alloc_arg_t		args;		/* allocation arguments */
-	xfs_bmbt_rec_t		*arp;		/* child record pointer */
+	struct xfs_buf		*abp;		/* buffer for ablock */
+	struct xfs_alloc_arg	args;		/* allocation arguments */
+	struct xfs_bmbt_rec	*arp;		/* child record pointer */
 	struct xfs_btree_block	*block;		/* btree root block */
-	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
+	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
 	int			error;		/* error return value */
-	xfs_ifork_t		*ifp;		/* inode fork pointer */
-	xfs_bmbt_key_t		*kp;		/* root block key pointer */
-	xfs_mount_t		*mp;		/* mount structure */
+	struct xfs_ifork	*ifp;		/* inode fork pointer */
+	struct xfs_bmbt_key	*kp;		/* root block key pointer */
+	struct xfs_mount	*mp;		/* mount structure */
 	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	rec;
@@ -691,7 +690,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	cur->bc_private.b.firstblock = *firstblock;
-	cur->bc_private.b.dfops = dfops;
+	cur->bc_private.b.dfops = tp->t_dfops;
 	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
@@ -705,7 +704,7 @@ xfs_bmap_extents_to_btree(
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-	} else if (dfops->dop_low) {
+	} else if (tp->t_dfops->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = *firstblock;
 	} else {
@@ -958,8 +957,8 @@ xfs_bmap_add_attrfork_btree(
  */
 STATIC int					/* error */
 xfs_bmap_add_attrfork_extents(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_inode_t		*ip,		/* incore inode pointer */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
 	int			*flags)		/* inode logging flags */
 {
@@ -969,8 +968,8 @@ xfs_bmap_add_attrfork_extents(
 	if (ip->i_d.di_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
 		return 0;
 	cur = NULL;
-	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, tp->t_dfops, &cur, 0,
-		flags, XFS_DATA_FORK);
+	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, &cur, 0, flags,
+					  XFS_DATA_FORK);
 	if (cur) {
 		cur->bc_private.b.allocated = 0;
 		xfs_btree_del_cursor(cur,
@@ -1806,8 +1805,8 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-					bma->firstblock, bma->tp->t_dfops,
-					&bma->cur, 1, &tmp_rval, whichfork);
+					bma->firstblock, &bma->cur, 1,
+					&tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -1884,8 +1883,8 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				bma->firstblock, bma->tp->t_dfops, &bma->cur, 1,
-				&tmp_rval, whichfork);
+				bma->firstblock, &bma->cur, 1, &tmp_rval,
+				whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -1965,8 +1964,8 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-					bma->firstblock, bma->tp->t_dfops,
-					&bma->cur, 1, &tmp_rval, whichfork);
+					bma->firstblock, &bma->cur, 1,
+					&tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -2003,8 +2002,8 @@ xfs_bmap_add_extent_delay_real(
 
 		ASSERT(bma->cur == NULL);
 		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				bma->firstblock, bma->tp->t_dfops, &bma->cur,
-				da_old > 0, &tmp_logflags, whichfork);
+				bma->firstblock, &bma->cur, da_old > 0,
+				&tmp_logflags, whichfork);
 		bma->logflags |= tmp_logflags;
 		if (error)
 			goto done;
@@ -2044,7 +2043,6 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	struct xfs_defer_ops	*dfops,	/* list of extents to be freed */
 	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
@@ -2058,6 +2056,7 @@ xfs_bmap_add_extent_unwritten_real(
 	int			state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmbt_irec	old;
+	struct xfs_defer_ops	*dfops = tp ? tp->t_dfops : NULL;
 
 	*logflagsp = 0;
 
@@ -2485,8 +2484,8 @@ xfs_bmap_add_extent_unwritten_real(
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, first, dfops, &cur,
-				0, &tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, first, &cur, 0,
+				&tmp_logflags, whichfork);
 		*logflagsp |= tmp_logflags;
 		if (error)
 			goto done;
@@ -2658,7 +2657,6 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_btree_cur	**curp,
 	struct xfs_bmbt_irec	*new,
 	xfs_fsblock_t		*first,
-	struct xfs_defer_ops	*dfops,
 	int			*logflagsp,
 	int			flags)
 {
@@ -2839,7 +2837,8 @@ xfs_bmap_add_extent_hole_real(
 
 	/* add reverse mapping unless caller opted out */
 	if (!(flags & XFS_BMAPI_NORMAP)) {
-		error = xfs_rmap_map_extent(mp, dfops, ip, whichfork, new);
+		error = xfs_rmap_map_extent(mp, tp->t_dfops, ip, whichfork,
+				new);
 		if (error)
 			goto done;
 	}
@@ -2849,8 +2848,8 @@ xfs_bmap_add_extent_hole_real(
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, first, dfops, curp,
-				0, &tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, first, curp, 0,
+				&tmp_logflags, whichfork);
 		*logflagsp |= tmp_logflags;
 		cur = *curp;
 		if (error)
@@ -4119,8 +4118,7 @@ xfs_bmapi_allocate(
 	else
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				whichfork, &bma->icur, &bma->cur, &bma->got,
-				bma->firstblock, bma->tp->t_dfops,
-				&bma->logflags, bma->flags);
+				bma->firstblock, &bma->logflags, bma->flags);
 
 	bma->logflags |= tmp_logflags;
 	if (error)
@@ -4190,7 +4188,7 @@ xfs_bmapi_convert_unwritten(
 
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, whichfork,
 			&bma->icur, &bma->cur, mval, bma->firstblock,
-			bma->tp->t_dfops, &tmp_logflags);
+			&tmp_logflags);
 	/*
 	 * Log the inode core unconditionally in the unwritten extent conversion
 	 * path because the conversion might not have done so (e.g., if the
@@ -4575,7 +4573,7 @@ xfs_bmapi_remap(
 		got.br_state = XFS_EXT_NORM;
 
 	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
-			&cur, &got, &firstblock, tp->t_dfops, &logflags, flags);
+			&cur, &got, &firstblock, &logflags, flags);
 	if (error)
 		goto error0;
 
@@ -4894,7 +4892,6 @@ xfs_bmap_del_extent_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_trans_t		*tp,	/* current transaction pointer */
 	struct xfs_iext_cursor	*icur,
-	struct xfs_defer_ops	*dfops,	/* list of extents to be freed */
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
@@ -4917,6 +4914,7 @@ xfs_bmap_del_extent_real(
 	uint			qfield;	/* quota field to update */
 	int			state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
+	struct xfs_defer_ops	*dfops = tp ? tp->t_dfops : NULL;
 
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
@@ -5343,7 +5341,7 @@ __xfs_bunmapi(
 			del.br_state = XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
 					whichfork, &icur, &cur, &del,
-					firstblock, dfops, &logflags);
+					firstblock, &logflags);
 			if (error)
 				goto error0;
 			goto nodelete;
@@ -5400,8 +5398,7 @@ __xfs_bunmapi(
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, whichfork, &icur, &cur,
-						&prev, firstblock, dfops,
-						&logflags);
+						&prev, firstblock, &logflags);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5410,8 +5407,7 @@ __xfs_bunmapi(
 				del.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, whichfork, &icur, &cur,
-						&del, firstblock, dfops,
-						&logflags);
+						&del, firstblock, &logflags);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5423,8 +5419,8 @@ __xfs_bunmapi(
 			error = xfs_bmap_del_extent_delay(ip, whichfork, &icur,
 					&got, &del);
 		} else {
-			error = xfs_bmap_del_extent_real(ip, tp, &icur, dfops,
-					cur, &del, &tmp_logflags, whichfork,
+			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
+					&del, &tmp_logflags, whichfork,
 					flags);
 			logflags |= tmp_logflags;
 		}
@@ -5458,8 +5454,8 @@ __xfs_bunmapi(
 	 */
 	if (xfs_bmap_needs_btree(ip, whichfork)) {
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, dfops,
-			&cur, 0, &tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, &cur, 0,
+				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
@@ -6009,8 +6005,8 @@ xfs_bmap_split_extent_at(
 		int tmp_logflags; /* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, tp->t_dfops,
-				&cur, 0, &tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, &cur, 0,
+				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 	}
 
-- 
2.17.1

