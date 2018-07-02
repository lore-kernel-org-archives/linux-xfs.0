Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752646AbeGBRhj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 13:37:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F6F081A4EBA
        for <linux-xfs@vger.kernel.org>; Mon,  2 Jul 2018 17:37:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6928A2026D5B
        for <linux-xfs@vger.kernel.org>; Mon,  2 Jul 2018 17:37:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: remove dfops param from high level dirname calls
Date: Mon,  2 Jul 2018 13:37:38 -0400
Message-Id: <20180702173738.9431-1-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-5-bfoster@redhat.com>
References: <20180628163636.52564-5-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All callers of the directory create, rename and remove interfaces
already associate the dfops with the transaction. Drop the dfops
parameters in these calls in preparation for further cleanups in the
layers below. This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

v2:
- Move asserts to function start.

 fs/xfs/libxfs/xfs_dir2.c | 17 +++++++-------
 fs/xfs/libxfs/xfs_dir2.h |  9 +++-----
 fs/xfs/xfs_inode.c       | 50 ++++++++++++++++++----------------------
 fs/xfs/xfs_symlink.c     |  2 +-
 4 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 59169aff30fe..c98250f0de50 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -244,7 +244,6 @@ xfs_dir_createname(
 	struct xfs_name		*name,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
 	struct xfs_da_args	*args;
@@ -252,6 +251,8 @@ xfs_dir_createname(
 	int			v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+	ASSERT(tp->t_dfops || !first);
+
 	if (inum) {
 		rval = xfs_dir_ino_validate(tp->t_mountp, inum);
 		if (rval)
@@ -270,11 +271,11 @@ xfs_dir_createname(
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
 	args->dp = dp;
-	args->firstblock = first;
-	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->dfops = tp->t_dfops;
+	args->firstblock = first;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
@@ -421,7 +422,6 @@ xfs_dir_removename(
 	struct xfs_name	*name,
 	xfs_ino_t	ino,
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
@@ -429,6 +429,7 @@ xfs_dir_removename(
 	int		v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+	ASSERT(tp->t_dfops);
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
@@ -443,10 +444,10 @@ xfs_dir_removename(
 	args->inumber = ino;
 	args->dp = dp;
 	args->firstblock = first;
-	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->dfops = tp->t_dfops;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -483,7 +484,6 @@ xfs_dir_replace(
 	struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
@@ -491,6 +491,7 @@ xfs_dir_replace(
 	int		v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+	ASSERT(tp->t_dfops);
 
 	rval = xfs_dir_ino_validate(tp->t_mountp, inum);
 	if (rval)
@@ -508,10 +509,10 @@ xfs_dir_replace(
 	args->inumber = inum;
 	args->dp = dp;
 	args->firstblock = first;
-	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->dfops = tp->t_dfops;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
@@ -547,7 +548,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, NULL, NULL, 0);
+	return xfs_dir_createname(tp, dp, name, 0, NULL, 0);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index ed385316c7dc..f203aebc07ed 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -118,19 +118,16 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
-				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				xfs_fsblock_t *first, xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				xfs_fsblock_t *first, xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
-				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				xfs_fsblock_t *first, xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f5649a023d46..e1bc686b70b4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1225,8 +1225,8 @@ xfs_create(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					&first_block, &dfops, resblks ?
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, &first_block,
+				   resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
 		ASSERT(error != -ENOSPC);
@@ -1464,7 +1464,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-					&first_block, &dfops, resblks);
+				   &first_block, resblks);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2659,8 +2659,8 @@ xfs_remove(
 
 	xfs_defer_init(&dfops, &first_block);
 	tp->t_dfops = &dfops;
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
-					&first_block, &dfops, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
+				   resblks);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_bmap_cancel;
@@ -2748,9 +2748,9 @@ xfs_sort_for_rename(
 
 static int
 xfs_finish_rename(
-	struct xfs_trans	*tp,
-	struct xfs_defer_ops	*dfops)
+	struct xfs_trans	*tp)
 {
+	struct xfs_defer_ops	*dfops = tp->t_dfops;
 	int			error;
 
 	/*
@@ -2784,7 +2784,6 @@ xfs_cross_rename(
 	struct xfs_inode	*dp2,
 	struct xfs_name		*name2,
 	struct xfs_inode	*ip2,
-	struct xfs_defer_ops	*dfops,
 	xfs_fsblock_t		*first_block,
 	int			spaceres)
 {
@@ -2794,16 +2793,14 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1,
-				ip2->i_ino,
-				first_block, dfops, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, first_block,
+				spaceres);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2,
-				ip1->i_ino,
-				first_block, dfops, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, first_block,
+				spaceres);
 	if (error)
 		goto out_trans_abort;
 
@@ -2818,7 +2815,7 @@ xfs_cross_rename(
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
 						dp1->i_ino, first_block,
-						dfops, spaceres);
+						spaceres);
 			if (error)
 				goto out_trans_abort;
 
@@ -2845,7 +2842,7 @@ xfs_cross_rename(
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
 						dp2->i_ino, first_block,
-						dfops, spaceres);
+						spaceres);
 			if (error)
 				goto out_trans_abort;
 
@@ -2884,10 +2881,10 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp, dfops);
+	return xfs_finish_rename(tp);
 
 out_trans_abort:
-	xfs_defer_cancel(dfops);
+	xfs_defer_cancel(tp->t_dfops);
 	xfs_trans_cancel(tp);
 	return error;
 }
@@ -3032,7 +3029,7 @@ xfs_rename(
 	if (flags & RENAME_EXCHANGE)
 		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
-					&dfops, &first_block, spaceres);
+					&first_block, spaceres);
 
 	/*
 	 * Set up the target.
@@ -3054,7 +3051,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
 						src_ip->i_ino, &first_block,
-						&dfops, spaceres);
+						spaceres);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3093,8 +3090,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino,
-					&first_block, &dfops, spaceres);
+					src_ip->i_ino, &first_block, spaceres);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3128,8 +3124,8 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino,
-					&first_block, &dfops, spaceres);
+					target_dp->i_ino, &first_block,
+					spaceres);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_bmap_cancel;
@@ -3168,10 +3164,10 @@ xfs_rename(
 	 */
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					&first_block, &dfops, spaceres);
+					&first_block, spaceres);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   &first_block, &dfops, spaceres);
+					   &first_block, spaceres);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -3206,7 +3202,7 @@ xfs_rename(
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
-	error = xfs_finish_rename(tp, &dfops);
+	error = xfs_finish_rename(tp);
 	if (wip)
 		IRELE(wip);
 	return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 44335bdebea2..e347a3db018f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -339,7 +339,7 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
-					&first_block, &dfops, resblks);
+				   &first_block, resblks);
 	if (error)
 		goto out_bmap_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.17.1

