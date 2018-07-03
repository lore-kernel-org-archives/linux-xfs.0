Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934261AbeGCRXW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82686C326
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CD671117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 18/25] xfs: remove xfs_btree_cur private firstblock field
Date: Tue,  3 Jul 2018 13:23:12 -0400
Message-Id: <20180703172319.24509-19-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The bmbt cursor private structure has a firstblock field that is
used to maintain locking order on bmbt allocations. The field holds
an actual firstblock value (as opposed to a pointer), so it is
initialized on cursor creation, updated on allocation and then the
value is transferred back to the source before the cursor is
destroyed.

This value is always transferred from and back to the ->t_firstblock
field. Since xfs_btree_cur already carries a reference to the
transaction, we can remove this field from xfs_btree_cur and the
associated copying. The bmbt allocations will update the value in
the transaction directly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 28 +++-------------------------
 fs/xfs/libxfs/xfs_bmap_btree.c | 10 ++++------
 fs/xfs/libxfs/xfs_btree.h      |  1 -
 3 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 016712434aa5..c83add15233b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -688,7 +688,6 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_private.b.firstblock = tp->t_firstblock;
 	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
@@ -732,7 +731,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	ASSERT(tp->t_firstblock == NULLFSBLOCK ||
 	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
-	tp->t_firstblock = cur->bc_private.b.firstblock = args.fsbno;
+	tp->t_firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
@@ -925,7 +924,6 @@ xfs_bmap_add_attrfork_btree(
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
-		cur->bc_private.b.firstblock = tp->t_firstblock;
 		error = xfs_bmbt_lookup_first(cur, &stat);
 		if (error)
 			goto error0;
@@ -937,7 +935,6 @@ xfs_bmap_add_attrfork_btree(
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 			return -ENOSPC;
 		}
-		tp->t_firstblock = cur->bc_private.b.firstblock;
 		cur->bc_private.b.allocated = 0;
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	}
@@ -4059,14 +4056,10 @@ xfs_bmapi_allocate(
 	if (error)
 		return error;
 
-	if (bma->cur)
-		bma->cur->bc_private.b.firstblock = bma->tp->t_firstblock;
 	if (bma->blkno == NULLFSBLOCK)
 		return 0;
-	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
+	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur)
 		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
-		bma->cur->bc_private.b.firstblock = bma->tp->t_firstblock;
-	}
 	/*
 	 * Bump the number of extents we've allocated
 	 * in this call.
@@ -4152,7 +4145,6 @@ xfs_bmapi_convert_unwritten(
 	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
 		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
 					bma->ip, whichfork);
-		bma->cur->bc_private.b.firstblock = bma->tp->t_firstblock;
 	}
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
@@ -4460,13 +4452,6 @@ xfs_bmapi_write(
 		xfs_trans_log_inode(tp, ip, bma.logflags);
 
 	if (bma.cur) {
-		if (!error) {
-			ASSERT(tp->t_firstblock == NULLFSBLOCK ||
-			       XFS_FSB_TO_AGNO(mp, tp->t_firstblock) <=
-			       XFS_FSB_TO_AGNO(mp,
-				       bma.cur->bc_private.b.firstblock));
-			tp->t_firstblock = bma.cur->bc_private.b.firstblock;
-		}
 		xfs_btree_del_cursor(bma.cur,
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	}
@@ -4530,7 +4515,6 @@ xfs_bmapi_remap(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -5191,7 +5175,6 @@ __xfs_bunmapi(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 	} else
 		cur = NULL;
@@ -5459,10 +5442,8 @@ __xfs_bunmapi(
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (cur) {
-		if (!error) {
-			tp->t_firstblock = cur->bc_private.b.firstblock;
+		if (!error)
 			cur->bc_private.b.allocated = 0;
-		}
 		xfs_btree_del_cursor(cur,
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	}
@@ -5678,7 +5659,6 @@ xfs_bmap_collapse_extents(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -5798,7 +5778,6 @@ xfs_bmap_insert_extents(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -5920,7 +5899,6 @@ xfs_bmap_split_extent_at(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index e8b01af09db5..8a9b98b11e34 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -175,7 +175,6 @@ xfs_bmbt_dup_cursor(
 	 * Copy the firstblock, dfops, and flags values,
 	 * since init cursor doesn't get them.
 	 */
-	new->bc_private.b.firstblock = cur->bc_private.b.firstblock;
 	new->bc_private.b.flags = cur->bc_private.b.flags;
 
 	return new;
@@ -186,11 +185,11 @@ xfs_bmbt_update_cursor(
 	struct xfs_btree_cur	*src,
 	struct xfs_btree_cur	*dst)
 {
-	ASSERT((dst->bc_private.b.firstblock != NULLFSBLOCK) ||
+	ASSERT((dst->bc_tp->t_firstblock != NULLFSBLOCK) ||
 	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
 
 	dst->bc_private.b.allocated += src->bc_private.b.allocated;
-	dst->bc_private.b.firstblock = src->bc_private.b.firstblock;
+	dst->bc_tp->t_firstblock = src->bc_tp->t_firstblock;
 
 	src->bc_private.b.allocated = 0;
 }
@@ -208,7 +207,7 @@ xfs_bmbt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.fsbno = cur->bc_private.b.firstblock;
+	args.fsbno = cur->bc_tp->t_firstblock;
 	args.firstblock = args.fsbno;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
 			cur->bc_private.b.whichfork);
@@ -263,7 +262,7 @@ xfs_bmbt_alloc_block(
 	}
 
 	ASSERT(args.len == 1);
-	cur->bc_private.b.firstblock = args.fsbno;
+	cur->bc_tp->t_firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
 	cur->bc_private.b.ip->i_d.di_nblocks++;
 	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
@@ -562,7 +561,6 @@ xfs_bmbt_init_cursor(
 
 	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.ip = ip;
-	cur->bc_private.b.firstblock = NULLFSBLOCK;
 	cur->bc_private.b.allocated = 0;
 	cur->bc_private.b.flags = 0;
 	cur->bc_private.b.whichfork = whichfork;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b986a8fc8d40..503615f4d729 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -214,7 +214,6 @@ typedef struct xfs_btree_cur
 		} a;
 		struct {			/* needed for BMAP */
 			struct xfs_inode *ip;	/* pointer to our inode */
-			xfs_fsblock_t	firstblock;	/* 1st blk allocated */
 			int		allocated;	/* count of alloced */
 			short		forksize;	/* fork's inode space */
 			char		whichfork;	/* data or attr fork */
-- 
2.17.1

