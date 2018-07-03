Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933860AbeGCRXU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DEBB2DFDA
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C965F1117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 04/25] xfs: remove firstblock param from xfs dir ops
Date: Tue,  3 Jul 2018 13:22:58 -0400
Message-Id: <20180703172319.24509-5-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All callers of the xfs_dir_*() functions pass ->t_firstblock as the
firstblock parameter. Drop the parameter and access ->t_firstblock
directly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2.c | 12 ++++--------
 fs/xfs/libxfs/xfs_dir2.h |  6 +++---
 fs/xfs/xfs_inode.c       | 32 ++++++++++++--------------------
 fs/xfs/xfs_symlink.c     |  3 +--
 4 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 26918c5bd819..8a55990ca3a5 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -243,7 +243,6 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
 	struct xfs_da_args	*args;
@@ -272,8 +271,7 @@ xfs_dir_createname(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
-	ASSERT(tp->t_dfops || !first);
-	args->firstblock = first;
+	args->firstblock = &tp->t_firstblock;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
@@ -419,7 +417,6 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
 	struct xfs_da_args	*args;
@@ -440,7 +437,7 @@ xfs_dir_removename(
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = ino;
 	args->dp = dp;
-	args->firstblock = first;
+	args->firstblock = &tp->t_firstblock;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
@@ -480,7 +477,6 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
 	struct xfs_da_args	*args;
@@ -504,7 +500,7 @@ xfs_dir_replace(
 	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
 	args->dp = dp;
-	args->firstblock = first;
+	args->firstblock = &tp->t_firstblock;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
@@ -544,7 +540,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, NULL, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f203aebc07ed..ba5acd03de94 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -118,16 +118,16 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
-				xfs_fsblock_t *first, xfs_extlen_t tot);
+				xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_fsblock_t *first, xfs_extlen_t tot);
+				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
-				xfs_fsblock_t *first, xfs_extlen_t tot);
+				xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6a3fe2d3df6c..ab1fd696500c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1223,7 +1223,7 @@ xfs_create(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino, &tp->t_firstblock,
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 				   resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
@@ -1460,7 +1460,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   &tp->t_firstblock, resblks);
+				   resblks);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2655,8 +2655,7 @@ xfs_remove(
 		goto out_trans_cancel;
 
 	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &tp->t_firstblock,
-				   resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_bmap_cancel;
@@ -2788,14 +2787,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, &tp->t_firstblock,
-				spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, &tp->t_firstblock,
-				spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
 	if (error)
 		goto out_trans_abort;
 
@@ -2809,8 +2806,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, &tp->t_firstblock,
-						spaceres);
+						dp1->i_ino, spaceres);
 			if (error)
 				goto out_trans_abort;
 
@@ -2836,8 +2832,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, &tp->t_firstblock,
-						spaceres);
+						dp2->i_ino, spaceres);
 			if (error)
 				goto out_trans_abort;
 
@@ -3043,8 +3038,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, &tp->t_firstblock,
-					   spaceres);
+					   src_ip->i_ino, spaceres);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3083,8 +3077,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, &tp->t_firstblock,
-					spaceres);
+					src_ip->i_ino, spaceres);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3118,8 +3111,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, &tp->t_firstblock,
-					spaceres);
+					target_dp->i_ino, spaceres);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_bmap_cancel;
@@ -3158,10 +3150,10 @@ xfs_rename(
 	 */
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					&tp->t_firstblock, spaceres);
+					spaceres);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   &tp->t_firstblock, spaceres);
+					   spaceres);
 	if (error)
 		goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8ddc7f1147dc..583ca83353f7 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -336,8 +336,7 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
-				   &tp->t_firstblock, resblks);
+	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
 	if (error)
 		goto out_bmap_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.17.1

