Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935602AbeF1Qgi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B4894076538
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46606111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 14/24] xfs: remove xfs_bunmapi() dfops param
Date: Thu, 28 Jun 2018 12:36:26 -0400
Message-Id: <20180628163636.52564-15-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that all xfs_bunmapi() callers use ->t_dfops, remove the
unnecessary parameter and access ->t_dfops directly. This patch does
not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  2 +-
 fs/xfs/libxfs/xfs_bmap.c        | 20 +++++++++-----------
 fs/xfs/libxfs/xfs_bmap.h        |  5 ++---
 fs/xfs/libxfs/xfs_da_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_dir2.c        |  2 +-
 fs/xfs/xfs_bmap_util.c          |  2 +-
 fs/xfs/xfs_inode.c              |  2 +-
 fs/xfs/xfs_reflink.c            |  5 ++---
 fs/xfs/xfs_symlink.c            |  3 +--
 9 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 1f2bc86a28ed..179259fd1b5e 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -629,7 +629,7 @@ xfs_attr_rmtval_remove(
 		xfs_defer_init(args->trans->t_dfops, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
-				    args->trans->t_dfops, &done);
+				    &done);
 		if (error)
 			goto out_defer_cancel;
 		xfs_defer_ijoin(args->trans->t_dfops, args->dp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eabf9a151d6d..25769e4f424c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5145,26 +5145,26 @@ xfs_bmap_del_extent_real(
  */
 int						/* error */
 __xfs_bunmapi(
-	xfs_trans_t		*tp,		/* transaction pointer */
+	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode */
 	xfs_fileoff_t		start,		/* first file offset deleted */
 	xfs_filblks_t		*rlen,		/* i/o: amount remaining */
 	int			flags,		/* misc flags */
 	xfs_extnum_t		nexts,		/* number of extents max */
-	xfs_fsblock_t		*firstblock,	/* first allocated block
+	xfs_fsblock_t		*firstblock)	/* first allocated block
 						   controls a.g. for allocs */
-	struct xfs_defer_ops	*dfops)		/* i/o: deferred updates */
 {
-	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
-	xfs_bmbt_irec_t		del;		/* extent being deleted */
+	struct xfs_defer_ops	*dfops = tp ? tp->t_dfops : NULL;
+	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
+	struct xfs_bmbt_irec	del;		/* extent being deleted */
 	int			error;		/* error return value */
 	xfs_extnum_t		extno;		/* extent number in list */
-	xfs_bmbt_irec_t		got;		/* current extent record */
+	struct xfs_bmbt_irec	got;		/* current extent record */
 	xfs_ifork_t		*ifp;		/* inode fork pointer */
 	int			isrt;		/* freeing in rt area */
 	int			logflags;	/* transaction logging flags */
 	xfs_extlen_t		mod;		/* rt extent offset */
-	xfs_mount_t		*mp;		/* mount structure */
+	struct xfs_mount	*mp;		/* mount structure */
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
@@ -5518,13 +5518,11 @@ xfs_bunmapi(
 	int			flags,
 	xfs_extnum_t		nexts,
 	xfs_fsblock_t		*firstblock,
-	struct xfs_defer_ops	*dfops,
 	int			*done)
 {
 	int			error;
 
-	error = __xfs_bunmapi(tp, ip, bno, &len, flags, nexts, firstblock,
-			dfops);
+	error = __xfs_bunmapi(tp, ip, bno, &len, flags, nexts, firstblock);
 	*done = (len == 0);
 	return error;
 }
@@ -6195,7 +6193,7 @@ xfs_bmap_finish_one(
 		break;
 	case XFS_BMAP_UNMAP:
 		error = __xfs_bunmapi(tp, ip, startoff, blockcount,
-				XFS_BMAPI_REMAP, 1, &firstfsb, dfops);
+				XFS_BMAPI_REMAP, 1, &firstfsb);
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 4bd7eeebb6d9..4ff56f55f2bb 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -209,12 +209,11 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *mval, int *nmap);
 int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t *rlen, int flags,
-		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
-		struct xfs_defer_ops *dfops);
+		xfs_extnum_t nexts, xfs_fsblock_t *firstblock);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
-		struct xfs_defer_ops *dfops, int *done);
+		int *done);
 int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e43f1dda02e4..68a72e3d9f53 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2395,7 +2395,7 @@ xfs_da_shrink_inode(
 		 */
 		error = xfs_bunmapi(tp, dp, dead_blkno, count,
 				    xfs_bmapi_aflag(w), 0, args->firstblock,
-				    args->trans->t_dfops, &done);
+				    &done);
 		if (error == -ENOSPC) {
 			if (w != XFS_DATA_FORK)
 				break;
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index ffa288c37da0..26918c5bd819 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -663,7 +663,7 @@ xfs_dir2_shrink_inode(
 
 	/* Unmap the fsblock(s). */
 	error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount, 0, 0,
-			    args->firstblock, args->trans->t_dfops, &done);
+			    args->firstblock, &done);
 	if (error) {
 		/*
 		 * ENOSPC actually can happen if we're in a removename with no
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 78189cf385f2..58b51648240d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1045,7 +1045,7 @@ xfs_unmap_extent(
 	xfs_defer_init(&dfops, &firstfsb);
 	tp->t_dfops = &dfops;
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, &firstfsb,
-			tp->t_dfops, done);
+			    done);
 	if (error)
 		goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 539d96201666..f456df2e1394 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1588,7 +1588,7 @@ xfs_itruncate_extents_flags(
 		tp->t_dfops = &dfops;
 		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
 				    XFS_ITRUNC_MAX_EXTENTS, &first_block,
-				    tp->t_dfops, &done);
+				    &done);
 		if (error)
 			goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index bb22a17fbca8..2221c6c6a5d3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -766,7 +766,7 @@ xfs_reflink_end_cow(
 		tp->t_dfops = &dfops;
 		rlen = del.br_blockcount;
 		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1,
-				&firstfsb, tp->t_dfops);
+				&firstfsb);
 		if (error)
 			goto out_defer;
 
@@ -1115,8 +1115,7 @@ xfs_reflink_remap_extent(
 	while (rlen) {
 		xfs_defer_init(&dfops, &firstfsb);
 		tp->t_dfops = &dfops;
-		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1,
-				&firstfsb, tp->t_dfops);
+		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1, &firstfsb);
 		if (error)
 			goto out_defer;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 290ae13d4673..a54f095c1409 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -466,8 +466,7 @@ xfs_inactive_symlink_rmt(
 	/*
 	 * Unmap the dead block(s) to the dfops.
 	 */
-	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps,
-			    &first_block, tp->t_dfops, &done);
+	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps, &first_block, &done);
 	if (error)
 		goto error_bmap_cancel;
 	ASSERT(done);
-- 
2.17.1

