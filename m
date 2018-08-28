Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39142 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbeH1XSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJEFS125093
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:07 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2m2y2pdwm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:07 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJP1OG011855
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:01 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJP1am003527
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:01 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 23/28] xfs: Add parent pointers to rename
Date: Tue, 28 Aug 2018 12:22:36 -0700
Message-Id: <1535484161-11059-24-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch removes the old parent pointer attribute during the
rename operation, and re-adds the updated parent pointer

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 70 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 300ba90..043a5d6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2931,6 +2931,8 @@ xfs_rename(
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
 	int			error;
+	xfs_dir2_dataptr_t	new_diroffset;
+	xfs_dir2_dataptr_t	old_diroffset;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2985,14 +2987,14 @@ xfs_rename(
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
@@ -3002,15 +3004,16 @@ xfs_rename(
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
 		error = -EXDEV;
-		goto out_trans_cancel;
+		goto out_unlock;
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
-
+		goto out;
+	}
 	/*
 	 * Set up the target.
 	 */
@@ -3022,7 +3025,7 @@ xfs_rename(
 		if (!spaceres) {
 			error = xfs_dir_canenter(tp, target_dp, target_name);
 			if (error)
-				goto out_trans_cancel;
+				goto out_unlock;
 		}
 		/*
 		 * If target does not exist and the rename crosses
@@ -3030,7 +3033,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3055,7 +3058,7 @@ xfs_rename(
 			if (!(xfs_dir_isempty(target_ip)) ||
 			    (VFS_I(target_ip)->i_nlink > 2)) {
 				error = -EEXIST;
-				goto out_trans_cancel;
+				goto out_unlock;
 			}
 		}
 
@@ -3069,7 +3072,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3103,7 +3106,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres, NULL);
+					target_dp->i_ino, spaceres, &new_diroffset);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3142,10 +3145,10 @@ xfs_rename(
 	 */
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 	if (error)
 		goto out_trans_cancel;
 
@@ -3175,16 +3178,51 @@ xfs_rename(
 		VFS_I(wip)->i_state &= ~I_LINKABLE;
 	}
 
+out:
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_add_deferred(target_dp, tp, src_ip, target_name,
+				new_diroffset);
+		if (error)
+			goto out_bmap_cancel;
+
+		error = xfs_parent_remove_deferred(src_dp, tp, src_ip,
+						   old_diroffset);
+		if (error)
+			goto out_bmap_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
+
 	if (wip)
 		xfs_irele(wip);
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
 
+out_bmap_cancel:
+	xfs_defer_cancel(tp);
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
