Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38628 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfAACVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:21:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012FIv0174254
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:23 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx44h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:21:23 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012LMJJ013005
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:22 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012LM4k028152
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:22 GMT
Subject: [PATCH 20/22] xfs: create libxfs helper to rename two directory
 entries
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:21:21 -0800
Message-ID: <154630928115.18437.2231570781604405334.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new libxfs function to rename two directory entries.  The
upcoming metadata directory feature will need this to replace a metadata
inode directory entry.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |  195 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    5 +
 fs/xfs/xfs_inode.c       |  160 --------------------------------------
 3 files changed, 202 insertions(+), 158 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index fbd5ce580b4a..77286d4f6e72 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -964,3 +964,198 @@ xfs_dir_exchange(
 
 	return 0;
 }
+
+
+/*
+ * Given an entry (@src_name, @src_ip) in directory @src_dp, make the entry
+ * @target_name in directory @target_dp point to @src_ip and remove the
+ * original entry, cleaning up everything left behind.
+ *
+ * Cleanup involves dropping a link count on @target_ip, and either removing
+ * the (@src_name, @src_ip) entry from @src_dp or simply replacing the entry
+ * with (@src_name, @wip) if a whiteout inode @wip is supplied.
+ *
+ * All inodes must have the ILOCK held.  We assume that if @src_ip is a
+ * directory then its '..' doesn't already point to @target_dp, and that @wip
+ * is a freshly allocated whiteout.
+ */
+int
+xfs_dir_rename(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*src_dp,
+	struct xfs_name		*src_name,
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*target_dp,
+	struct xfs_name		*target_name,
+	struct xfs_inode	*target_ip,
+	unsigned int		spaceres,
+	struct xfs_inode	*wip)
+{
+	bool			new_parent = (src_dp != target_dp);
+	bool			src_is_directory;
+	int			error;
+
+	src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
+
+	/*
+	 * Set up the target.
+	 */
+	if (target_ip == NULL) {
+		/*
+		 * If there's no space reservation, check the entry will
+		 * fit before actually inserting it.
+		 */
+		if (!spaceres) {
+			error = xfs_dir_canenter(tp, target_dp, target_name);
+			if (error)
+				return error;
+		}
+		/*
+		 * If target does not exist and the rename crosses
+		 * directories, adjust the target directory link count
+		 * to account for the ".." reference from the new entry.
+		 */
+		error = xfs_dir_createname(tp, target_dp, target_name,
+					   src_ip->i_ino, spaceres);
+		if (error)
+			return error;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		if (new_parent && src_is_directory) {
+			error = xfs_bumplink(tp, target_dp);
+			if (error)
+				return error;
+		}
+	} else { /* target_ip != NULL */
+		/*
+		 * If target exists and it's a directory, check that both
+		 * target and source are directories and that target can be
+		 * destroyed, or that neither is a directory.
+		 */
+		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
+			/*
+			 * Make sure target dir is empty.
+			 */
+			if (!(xfs_dir_isempty(target_ip)) ||
+			    (VFS_I(target_ip)->i_nlink > 2))
+				return -EEXIST;
+		}
+
+		/*
+		 * Link the source inode under the target name.
+		 * If the source inode is a directory and we are moving
+		 * it across directories, its ".." entry will be
+		 * inconsistent until we replace that down below.
+		 *
+		 * In case there is already an entry with the same
+		 * name at the destination directory, remove it first.
+		 */
+		error = xfs_dir_replace(tp, target_dp, target_name,
+					src_ip->i_ino, spaceres);
+		if (error)
+			return error;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		/*
+		 * Decrement the link count on the target since the target
+		 * dir no longer points to it.
+		 */
+		error = xfs_droplink(tp, target_ip);
+		if (error)
+			return error;
+
+		if (src_is_directory) {
+			/*
+			 * Drop the link from the old "." entry.
+			 */
+			error = xfs_droplink(tp, target_ip);
+			if (error)
+				return error;
+		}
+	} /* target_ip != NULL */
+
+	/*
+	 * Remove the source.
+	 */
+	if (new_parent && src_is_directory) {
+		/*
+		 * Rewrite the ".." entry to point to the new
+		 * directory.
+		 */
+		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+					target_dp->i_ino, spaceres);
+		ASSERT(error != -EEXIST);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * We always want to hit the ctime on the source inode.
+	 *
+	 * This isn't strictly required by the standards since the source
+	 * inode isn't really being changed, but old unix file systems did
+	 * it and some incremental backup programs won't work without it.
+	 */
+	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+
+	/*
+	 * Adjust the link count on src_dp.  This is necessary when
+	 * renaming a directory, either within one parent when
+	 * the target existed, or across two parent directories.
+	 */
+	if (src_is_directory && (new_parent || target_ip != NULL)) {
+
+		/*
+		 * Decrement link count on src_directory since the
+		 * entry that's moved no longer points to it.
+		 */
+		error = xfs_droplink(tp, src_dp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * For whiteouts, we only need to update the source dirent with the
+	 * inode number of the whiteout inode rather than removing it
+	 * altogether.
+	 */
+	if (wip) {
+		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
+					spaceres);
+	} else
+		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+					   spaceres);
+	if (error)
+		return error;
+
+	/*
+	 * For whiteouts, we need to bump the link count on the whiteout inode.
+	 * This means that failures all the way up to this point leave the inode
+	 * on the unlinked list and so cleanup is a simple matter of dropping
+	 * the remaining reference to it. If we fail here after bumping the link
+	 * count, we're shutting down the filesystem so we'll never see the
+	 * intermediate state on disk.
+	 */
+	if (wip) {
+		ASSERT(VFS_I(wip)->i_nlink == 0);
+		error = xfs_bumplink(tp, wip);
+		if (error)
+			return error;
+		error = xfs_iunlink_remove(tp, wip);
+		if (error)
+			return error;
+		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
+	}
+
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+	if (new_parent)
+		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 09765f010f90..d89552b49791 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -340,5 +340,10 @@ int xfs_dir_exchange(struct xfs_trans *tp, struct xfs_inode *dp1,
 		struct xfs_name *name1, struct xfs_inode *ip1,
 		struct xfs_inode *dp2, struct xfs_name *name2,
 		struct xfs_inode *ip2, unsigned int spaceres);
+int xfs_dir_rename(struct xfs_trans *tp, struct xfs_inode *src_dp,
+		struct xfs_name *src_name, struct xfs_inode *src_ip,
+		struct xfs_inode *target_dp, struct xfs_name *target_name,
+		struct xfs_inode *target_ip, unsigned int spaceres,
+		struct xfs_inode *wip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3bed0db609bd..52e29a27f514 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2111,7 +2111,6 @@ xfs_rename(
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
 	int			error;
 
@@ -2195,162 +2194,12 @@ xfs_rename(
 					target_dp, target_name, target_ip,
 					spaceres);
 
-	/*
-	 * Set up the target.
-	 */
-	if (target_ip == NULL) {
-		/*
-		 * If there's no space reservation, check the entry will
-		 * fit before actually inserting it.
-		 */
-		if (!spaceres) {
-			error = xfs_dir_canenter(tp, target_dp, target_name);
-			if (error)
-				goto out_trans_cancel;
-		}
-		/*
-		 * If target does not exist and the rename crosses
-		 * directories, adjust the target directory link count
-		 * to account for the ".." reference from the new entry.
-		 */
-		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-		if (new_parent && src_is_directory) {
-			error = xfs_bumplink(tp, target_dp);
-			if (error)
-				goto out_trans_cancel;
-		}
-	} else { /* target_ip != NULL */
-		/*
-		 * If target exists and it's a directory, check that both
-		 * target and source are directories and that target can be
-		 * destroyed, or that neither is a directory.
-		 */
-		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
-			/*
-			 * Make sure target dir is empty.
-			 */
-			if (!(xfs_dir_isempty(target_ip)) ||
-			    (VFS_I(target_ip)->i_nlink > 2)) {
-				error = -EEXIST;
-				goto out_trans_cancel;
-			}
-		}
-
-		/*
-		 * Link the source inode under the target name.
-		 * If the source inode is a directory and we are moving
-		 * it across directories, its ".." entry will be
-		 * inconsistent until we replace that down below.
-		 *
-		 * In case there is already an entry with the same
-		 * name at the destination directory, remove it first.
-		 */
-		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-		/*
-		 * Decrement the link count on the target since the target
-		 * dir no longer points to it.
-		 */
-		error = xfs_droplink(tp, target_ip);
-		if (error)
-			goto out_trans_cancel;
-
-		if (src_is_directory) {
-			/*
-			 * Drop the link from the old "." entry.
-			 */
-			error = xfs_droplink(tp, target_ip);
-			if (error)
-				goto out_trans_cancel;
-		}
-	} /* target_ip != NULL */
-
-	/*
-	 * Remove the source.
-	 */
-	if (new_parent && src_is_directory) {
-		/*
-		 * Rewrite the ".." entry to point to the new
-		 * directory.
-		 */
-		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
-		ASSERT(error != -EEXIST);
-		if (error)
-			goto out_trans_cancel;
-	}
-
-	/*
-	 * We always want to hit the ctime on the source inode.
-	 *
-	 * This isn't strictly required by the standards since the source
-	 * inode isn't really being changed, but old unix file systems did
-	 * it and some incremental backup programs won't work without it.
-	 */
-	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
-
-	/*
-	 * Adjust the link count on src_dp.  This is necessary when
-	 * renaming a directory, either within one parent when
-	 * the target existed, or across two parent directories.
-	 */
-	if (src_is_directory && (new_parent || target_ip != NULL)) {
-
-		/*
-		 * Decrement link count on src_directory since the
-		 * entry that's moved no longer points to it.
-		 */
-		error = xfs_droplink(tp, src_dp);
-		if (error)
-			goto out_trans_cancel;
-	}
-
-	/*
-	 * For whiteouts, we only need to update the source dirent with the
-	 * inode number of the whiteout inode rather than removing it
-	 * altogether.
-	 */
-	if (wip) {
-		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
-	} else
-		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+	error = xfs_dir_rename(tp, src_dp, src_name, src_ip, target_dp,
+			target_name, target_ip, spaceres, wip);
 	if (error)
 		goto out_trans_cancel;
 
-	/*
-	 * For whiteouts, we need to bump the link count on the whiteout inode.
-	 * This means that failures all the way up to this point leave the inode
-	 * on the unlinked list and so cleanup is a simple matter of dropping
-	 * the remaining reference to it. If we fail here after bumping the link
-	 * count, we're shutting down the filesystem so we'll never see the
-	 * intermediate state on disk.
-	 */
 	if (wip) {
-		ASSERT(VFS_I(wip)->i_nlink == 0);
-		error = xfs_bumplink(tp, wip);
-		if (error)
-			goto out_trans_cancel;
-		error = xfs_iunlink_remove(tp, wip);
-		if (error)
-			goto out_trans_cancel;
-		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
-
 		/*
 		 * Now we have a real link, clear the "I'm a tmpfile" state
 		 * flag from the inode so it doesn't accidentally get misused in
@@ -2359,11 +2208,6 @@ xfs_rename(
 		VFS_I(wip)->i_state &= ~I_LINKABLE;
 	}
 
-	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
-	if (new_parent)
-		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
-
 	error = xfs_finish_rename(tp);
 	if (wip)
 		xfs_irele(wip);
