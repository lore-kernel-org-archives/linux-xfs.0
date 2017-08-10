Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22940 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbdHJBnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 21:43:55 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A1hspa010120
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hsSj012988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:54 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hsBX017108
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:54 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [RFC PATCH 12/13] Add parent pointers to rename
Date: Wed,  9 Aug 2017 18:41:32 -0700
Message-Id: <1502329293-4091-13-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
:100644 100644 f5d0d3d... bd99ae2... M	fs/xfs/libxfs/xfs_dir2.c
:100644 100644 0654ad8b.. 2bdade2... M	fs/xfs/xfs_inode.c
 fs/xfs/libxfs/xfs_dir2.c |  6 ++++--
 fs/xfs/xfs_inode.c       | 26 ++++++++++++++++++++------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index f5d0d3d..bd99ae2 100644
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
index 0654ad8b..2bdade2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2971,6 +2971,8 @@ xfs_rename(
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
 	int			error;
+	xfs_dir2_dataptr_t	new_diroffset;
+	xfs_dir2_dataptr_t	old_diroffset;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3073,13 +3075,12 @@ xfs_rename(
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
@@ -3113,7 +3114,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, &first_block, &dfops,
-					spaceres, NULL);
+					spaceres, &new_diroffset);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -3148,7 +3149,7 @@ xfs_rename(
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
 					target_dp->i_ino, &first_block, &dfops,
-					spaceres, NULL);
+					spaceres, &new_diroffset);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_bmap_cancel;
@@ -3187,11 +3188,12 @@ xfs_rename(
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
 
@@ -3221,6 +3223,18 @@ xfs_rename(
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

