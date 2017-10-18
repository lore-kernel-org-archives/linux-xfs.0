Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28251 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdJRXAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:00:15 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9IN0Es6011969
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9IN0DVN031360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:14 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9IN0DD0021858
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:13 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 16/17] Add parent pointers to rename
Date: Wed, 18 Oct 2017 15:55:32 -0700
Message-Id: <1508367333-3237-17-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |  6 ++++--
 fs/xfs/xfs_inode.c       | 26 ++++++++++++++++++++------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 486f808..35667fd 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -324,10 +324,11 @@ xfs_dir_createname(
 	else
 		rval = xfs_dir2_node_addname(args);
 
+out_free:
 	/* return the location that this entry was place in the parent inode */
 	if (offset)
 		*offset = args->offset;
-out_free:
+
 	kmem_free(args);
 	return rval;
 }
@@ -496,9 +497,10 @@ xfs_dir_removename(
 		rval = xfs_dir2_leaf_removename(args);
 	else
 		rval = xfs_dir2_node_removename(args);
+out_free:
 	if (offset)
 		*offset = args->offset;
-out_free:
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a360c3d..98bd7c2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2989,6 +2989,8 @@ xfs_rename(
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
 	int			error;
+	xfs_dir2_dataptr_t	new_diroffset;
+	xfs_dir2_dataptr_t	old_diroffset;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3091,13 +3093,12 @@ xfs_rename(
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
 					   src_ip->i_ino, &first_block, &dfops,
-					   spaceres, NULL);
+					   spaceres, &new_diroffset);
 		if (error)
 			goto out_bmap_cancel;
 
 		xfs_trans_ichgtime(tp, target_dp,
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
 		if (new_parent && src_is_directory) {
 			error = xfs_bumplink(tp, target_dp);
 			if (error)
@@ -3131,7 +3132,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, &first_block, &dfops,
-					spaceres, NULL);
+					spaceres, &new_diroffset);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3166,7 +3167,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
 					target_dp->i_ino, &first_block, &dfops,
-					spaceres, NULL);
+					spaceres, &new_diroffset);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_bmap_cancel;
@@ -3205,11 +3206,12 @@ xfs_rename(
 	 */
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					&first_block, &dfops, spaceres, NULL);
+					&first_block, &dfops, spaceres,
+					&old_diroffset);
 	} else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   &first_block, &dfops, spaceres,
-					   NULL);
+					   &old_diroffset);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -3239,6 +3241,18 @@ xfs_rename(
 		VFS_I(wip)->i_state &= ~I_LINKABLE;
 	}
 
+	if (new_parent && xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_add(tp, target_dp, src_ip, target_name,
+				       new_diroffset, &dfops, &first_block);
+		if (error)
+			goto out_bmap_cancel;
+
+		error = xfs_parent_remove(tp, src_dp, src_ip,
+					  old_diroffset, &dfops, &first_block);
+		if (error)
+			goto out_bmap_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
-- 
2.7.4

