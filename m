Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752181AbeDJRqd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 13:46:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B84D98A03F
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86E598DD43
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 7/7] xfs: defer agfl frees from directory op transactions
Date: Tue, 10 Apr 2018 13:46:31 -0400
Message-Id: <20180410174631.4915-8-bfoster@redhat.com>
In-Reply-To: <20180410174631.4915-1-bfoster@redhat.com>
References: <20180410174631.4915-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Directory operations can perform block allocations as entries are
added/removed from directories. Defer AGFL block frees from the
remaining directory operation transactions. This covers the hard
link, remove and rename operations.

Since this fixes up all callers of the dir2 create, remove and
replace functions to pass dfops via the transaction, clean up the
associated interfaces to no longer require a dfops parameter.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2.c | 16 +++++++-------
 fs/xfs/libxfs/xfs_dir2.h |  9 +++-----
 fs/xfs/xfs_inode.c       | 56 ++++++++++++++++++++++--------------------------
 fs/xfs/xfs_symlink.c     |  2 +-
 4 files changed, 38 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92f94e190f04..3a6e126212ec 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -256,7 +256,6 @@ xfs_dir_createname(
 	struct xfs_name		*name,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
 	struct xfs_da_args	*args;
@@ -282,11 +281,12 @@ xfs_dir_createname(
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
 	args->dp = dp;
-	args->firstblock = first;
-	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	ASSERT(tp->t_dfops || !first);
+	args->dfops = tp->t_dfops;
+	args->firstblock = first;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
@@ -433,7 +433,6 @@ xfs_dir_removename(
 	struct xfs_name	*name,
 	xfs_ino_t	ino,
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
@@ -455,10 +454,11 @@ xfs_dir_removename(
 	args->inumber = ino;
 	args->dp = dp;
 	args->firstblock = first;
-	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	ASSERT(tp->t_dfops);
+	args->dfops = tp->t_dfops;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -495,7 +495,6 @@ xfs_dir_replace(
 	struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
@@ -520,10 +519,11 @@ xfs_dir_replace(
 	args->inumber = inum;
 	args->dp = dp;
 	args->firstblock = first;
-	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	ASSERT(tp->t_dfops);
+	args->dfops = tp->t_dfops;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
@@ -559,7 +559,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, NULL, NULL, 0);
+	return xfs_dir_createname(tp, dp, name, 0, NULL, 0);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 989e95a53db2..d9e508988fd8 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -130,19 +130,16 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
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
index fdf5d276b44c..9ca198dbd419 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1224,8 +1224,8 @@ xfs_create(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					&first_block, &dfops, resblks ?
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, &first_block,
+				   resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
 		ASSERT(error != -ENOSPC);
@@ -1450,7 +1450,7 @@ xfs_link(
 			goto error_return;
 	}
 
-	xfs_defer_init(NULL, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &first_block);
 
 	/*
 	 * Handle initial link state of O_TMPFILE inode
@@ -1462,7 +1462,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-					&first_block, &dfops, resblks);
+				   &first_block, resblks);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2648,9 +2648,9 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_defer_init(NULL, &dfops, &first_block);
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
-					&first_block, &dfops, resblks);
+	xfs_defer_init(tp, &dfops, &first_block);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
+				   resblks);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_bmap_cancel;
@@ -2738,9 +2738,9 @@ xfs_sort_for_rename(
 
 static int
 xfs_finish_rename(
-	struct xfs_trans	*tp,
-	struct xfs_defer_ops	*dfops)
+	struct xfs_trans	*tp)
 {
+	struct xfs_defer_ops	*dfops = tp->t_dfops;
 	int			error;
 
 	/*
@@ -2774,7 +2774,6 @@ xfs_cross_rename(
 	struct xfs_inode	*dp2,
 	struct xfs_name		*name2,
 	struct xfs_inode	*ip2,
-	struct xfs_defer_ops	*dfops,
 	xfs_fsblock_t		*first_block,
 	int			spaceres)
 {
@@ -2784,16 +2783,14 @@ xfs_cross_rename(
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
 
@@ -2808,7 +2805,7 @@ xfs_cross_rename(
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
 						dp1->i_ino, first_block,
-						dfops, spaceres);
+						spaceres);
 			if (error)
 				goto out_trans_abort;
 
@@ -2835,7 +2832,7 @@ xfs_cross_rename(
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
 						dp2->i_ino, first_block,
-						dfops, spaceres);
+						spaceres);
 			if (error)
 				goto out_trans_abort;
 
@@ -2874,10 +2871,10 @@ xfs_cross_rename(
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
@@ -3015,13 +3012,13 @@ xfs_rename(
 		goto out_trans_cancel;
 	}
 
-	xfs_defer_init(NULL, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &first_block);
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
 		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
-					&dfops, &first_block, spaceres);
+					&first_block, spaceres);
 
 	/*
 	 * Set up the target.
@@ -3043,7 +3040,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
 						src_ip->i_ino, &first_block,
-						&dfops, spaceres);
+						spaceres);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3082,8 +3079,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino,
-					&first_block, &dfops, spaceres);
+					src_ip->i_ino, &first_block, spaceres);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3117,8 +3113,8 @@ xfs_rename(
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
@@ -3157,10 +3153,10 @@ xfs_rename(
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
 
@@ -3195,7 +3191,7 @@ xfs_rename(
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
-	error = xfs_finish_rename(tp, &dfops);
+	error = xfs_finish_rename(tp);
 	if (wip)
 		IRELE(wip);
 	return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 0f3564741fa9..264b4196d540 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -350,7 +350,7 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
-					&first_block, &dfops, resblks);
+				   &first_block, resblks);
 	if (error)
 		goto out_bmap_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.13.6

