Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933568AbeGCRXU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C282781A6D23
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADA971117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 03/25] xfs: use ->t_firstblock in dir ops
Date: Tue,  3 Jul 2018 13:22:57 -0400
Message-Id: <20180703172319.24509-4-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Callers of the xfs_dir_*() functions currently pass an on-stack
firstblock variable. While the dirops infrastructure carries a
pointer to this variable, it never rolls the transaction and so it
is safe to use ->t_firstblock instead.

Fix up the various xfs_dir_*() callers to use ->t_firstblock. Also
remove the unnecessary parameter for xfs_cross_rename().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c   | 42 +++++++++++++++++++-----------------------
 fs/xfs/xfs_symlink.c |  9 ++++-----
 2 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 04e17234e5d7..6a3fe2d3df6c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1143,7 +1143,6 @@ xfs_create(
 	struct xfs_trans	*tp = NULL;
 	int			error;
 	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t		first_block;
 	bool                    unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
@@ -1195,7 +1194,7 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	xfs_defer_init(tp, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 
 	/*
 	 * Reserve disk quota and the inode.
@@ -1224,7 +1223,7 @@ xfs_create(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino, &first_block,
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, &tp->t_firstblock,
 				   resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
@@ -1401,7 +1400,6 @@ xfs_link(
 	xfs_trans_t		*tp;
 	int			error;
 	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t           first_block;
 	int			resblks;
 
 	trace_xfs_link(tdp, target_name);
@@ -1450,7 +1448,7 @@ xfs_link(
 			goto error_return;
 	}
 
-	xfs_defer_init(tp, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 
 	/*
 	 * Handle initial link state of O_TMPFILE inode
@@ -1462,7 +1460,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   &first_block, resblks);
+				   &tp->t_firstblock, resblks);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2577,7 +2575,6 @@ xfs_remove(
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int                     error = 0;
 	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t           first_block;
 	uint			resblks;
 
 	trace_xfs_remove(dp, name);
@@ -2657,8 +2654,8 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_defer_init(tp, &dfops, &first_block);
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &tp->t_firstblock,
 				   resblks);
 	if (error) {
 		ASSERT(error != -ENOENT);
@@ -2783,7 +2780,6 @@ xfs_cross_rename(
 	struct xfs_inode	*dp2,
 	struct xfs_name		*name2,
 	struct xfs_inode	*ip2,
-	xfs_fsblock_t		*first_block,
 	int			spaceres)
 {
 	int		error = 0;
@@ -2792,13 +2788,13 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, first_block,
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, &tp->t_firstblock,
 				spaceres);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, first_block,
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, &tp->t_firstblock,
 				spaceres);
 	if (error)
 		goto out_trans_abort;
@@ -2813,7 +2809,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, first_block,
+						dp1->i_ino, &tp->t_firstblock,
 						spaceres);
 			if (error)
 				goto out_trans_abort;
@@ -2840,7 +2836,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, first_block,
+						dp2->i_ino, &tp->t_firstblock,
 						spaceres);
 			if (error)
 				goto out_trans_abort;
@@ -2939,7 +2935,6 @@ xfs_rename(
 	struct xfs_mount	*mp = src_dp->i_mount;
 	struct xfs_trans	*tp;
 	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t		first_block;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
 	int			num_inodes = __XFS_SORT_INODES;
@@ -3021,13 +3016,13 @@ xfs_rename(
 		goto out_trans_cancel;
 	}
 
-	xfs_defer_init(tp, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
 		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
-					&first_block, spaceres);
+					spaceres);
 
 	/*
 	 * Set up the target.
@@ -3048,8 +3043,8 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-						src_ip->i_ino, &first_block,
-						spaceres);
+					   src_ip->i_ino, &tp->t_firstblock,
+					   spaceres);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3088,7 +3083,8 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, &first_block, spaceres);
+					src_ip->i_ino, &tp->t_firstblock,
+					spaceres);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3122,7 +3118,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, &first_block,
+					target_dp->i_ino, &tp->t_firstblock,
 					spaceres);
 		ASSERT(error != -EEXIST);
 		if (error)
@@ -3162,10 +3158,10 @@ xfs_rename(
 	 */
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					&first_block, spaceres);
+					&tp->t_firstblock, spaceres);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   &first_block, spaceres);
+					   &tp->t_firstblock, spaceres);
 	if (error)
 		goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index e50e97308f81..8ddc7f1147dc 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -164,7 +164,6 @@ xfs_symlink(
 	int			error = 0;
 	int			pathlen;
 	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t		first_block;
 	bool                    unlock_dp_on_error = false;
 	xfs_fileoff_t		first_fsb;
 	xfs_filblks_t		fs_blocks;
@@ -246,7 +245,7 @@ xfs_symlink(
 	 * Initialize the bmap freelist prior to calling either
 	 * bmapi or the directory create code.
 	 */
-	xfs_defer_init(tp, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 
 	/*
 	 * Allocate an inode for the symlink.
@@ -289,8 +288,8 @@ xfs_symlink(
 		nmaps = XFS_SYMLINK_MAPS;
 
 		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
-				  XFS_BMAPI_METADATA, &first_block, resblks,
-				  mval, &nmaps);
+				  XFS_BMAPI_METADATA, &tp->t_firstblock,
+				  resblks, mval, &nmaps);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -338,7 +337,7 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
-				   &first_block, resblks);
+				   &tp->t_firstblock, resblks);
 	if (error)
 		goto out_bmap_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.17.1

