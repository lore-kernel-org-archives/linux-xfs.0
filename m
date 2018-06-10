Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54724 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932124AbeFJFHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:07:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A56MEC071831
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:38 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2jg6b19w63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:37 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57aGw032648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:37 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A57ag3029716
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:36 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v7 19/23] xfs: Add parent pointers to rename
Date: Sat,  9 Jun 2018 22:05:04 -0700
Message-Id: <1528607108-11059-20-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch removes the old parent pointer attribute during the
rename operation, and re-adds the updated parent pointer

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 68 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aee05e5..d93e387 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2987,6 +2987,8 @@ xfs_rename(
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
 	int			error;
+	xfs_dir2_dataptr_t	new_diroffset;
+	xfs_dir2_dataptr_t	old_diroffset;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3041,14 +3043,14 @@ xfs_rename(
 	 * we can rely on either trans_commit or trans_cancel to unlock
 	 * them.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -3058,17 +3060,18 @@ xfs_rename(
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
 		error = -EXDEV;
-		goto out_trans_cancel;
+		goto out_unlock;
 	}
 
 	xfs_defer_init(&dfops, &first_block);
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					&dfops, &first_block, spaceres);
-
+		goto out;
+	}
 	/*
 	 * Set up the target.
 	 */
@@ -3080,7 +3083,7 @@ xfs_rename(
 		if (!spaceres) {
 			error = xfs_dir_canenter(tp, target_dp, target_name);
 			if (error)
-				goto out_trans_cancel;
+				goto out_unlock;
 		}
 		/*
 		 * If target does not exist and the rename crosses
@@ -3089,7 +3092,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
 					   src_ip->i_ino, &first_block, &dfops,
-					   spaceres, NULL);
+					   spaceres, &new_diroffset);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3114,7 +3117,7 @@ xfs_rename(
 			if (!(xfs_dir_isempty(target_ip)) ||
 			    (VFS_I(target_ip)->i_nlink > 2)) {
 				error = -EEXIST;
-				goto out_trans_cancel;
+				goto out_unlock;
 			}
 		}
 
@@ -3129,7 +3132,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, &first_block, &dfops,
-					spaceres, NULL);
+					spaceres, &new_diroffset);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3164,7 +3167,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
 					target_dp->i_ino, &first_block, &dfops,
-					spaceres, NULL);
+					spaceres, &new_diroffset);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_bmap_cancel;
@@ -3203,10 +3206,11 @@ xfs_rename(
 	 */
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					&first_block, &dfops, spaceres, NULL);
+					&first_block, &dfops, spaceres,
+					&old_diroffset);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-				&first_block, &dfops, spaceres, NULL);
+				&first_block, &dfops, spaceres, &old_diroffset);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -3236,18 +3240,50 @@ xfs_rename(
 		VFS_I(wip)->i_state &= ~I_LINKABLE;
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_add_deferred(target_dp, src_ip, target_name,
+				new_diroffset, &dfops);
+		if (error)
+			goto out_bmap_cancel;
+
+		error = xfs_parent_remove_deferred(src_dp, src_ip,
+						   old_diroffset, &dfops);
+		if (error)
+			goto out_bmap_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp, &dfops);
+out:
 	if (wip)
 		IRELE(wip);
+	if (wip)
+		xfs_iunlock(wip, XFS_ILOCK_EXCL);
+	if (target_ip)
+		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
+	if (new_parent)
+		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
+
 	return error;
 
 out_bmap_cancel:
 	xfs_defer_cancel(&dfops);
+out_unlock:
+	if (wip)
+		xfs_iunlock(wip, XFS_ILOCK_EXCL);
+	if (target_ip)
+		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
+	if (new_parent)
+		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
+
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 out_release_wip:
-- 
2.7.4

