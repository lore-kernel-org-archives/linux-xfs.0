Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3331029DFE
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 11:41:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B73EEAC1CD
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 09:41:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tOlRbxto6DOKbQlS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Nov 2014 09:41:36 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAAHfZ9Z012041
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 12:41:35 -0500
Received: from hades.localdomain.com (ovpn-113-69.phx2.redhat.com
	[10.3.113.69])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAAHfShQ015852
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 12:41:34 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/2] Add support to RENAME_EXCHANGE flag
Date: Mon, 10 Nov 2014 15:41:12 -0200
Message-Id: <1415641272-29383-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1415641272-29383-1-git-send-email-cmaiolino@redhat.com>
References: <1415641272-29383-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Adds a new function named xfs_cross_rename(), responsible to handle requests
from sys_renameat2() using RENAME_EXCHANGE flag.

Changelog:

	V2: refactor xfs_cross_rename() to not duplicate code from xfs_rename()

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_inode.c | 315 +++++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_inode.h |   8 +-
 fs/xfs/xfs_iops.c  |   4 +-
 3 files changed, 220 insertions(+), 107 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fea3c92..bf09bfc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2674,12 +2674,14 @@ xfs_rename(
 	xfs_inode_t	*src_ip,
 	xfs_inode_t	*target_dp,
 	struct xfs_name	*target_name,
-	xfs_inode_t	*target_ip)
+	xfs_inode_t	*target_ip,
+	unsigned int	flags)
 {
 	xfs_trans_t	*tp = NULL;
 	xfs_mount_t	*mp = src_dp->i_mount;
 	int		new_parent;		/* moving to a new dir */
 	int		src_is_directory;	/* src_name is a directory */
+	int		tgt_is_directory;
 	int		error;
 	xfs_bmap_free_t free_list;
 	xfs_fsblock_t   first_block;
@@ -2752,141 +2754,158 @@ xfs_rename(
 	}
 
 	/*
-	 * Set up the target.
-	 */
-	if (target_ip == NULL) {
+	 * Handle RENAME_EXCHANGE flags
+	*/
+	if (flags & RENAME_EXCHANGE) {
 		/*
-		 * If there's no space reservation, check the entry will
-		 * fit before actually inserting it.
+		 * target_ip will always exist if RENAME_EXCHANGE flag is set
 		 */
-		error = xfs_dir_canenter(tp, target_dp, target_name, spaceres);
+		tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);
+
+		error = xfs_cross_rename(src_dp, src_name, src_ip, target_dp, target_name, target_ip,
+					 new_parent, src_is_directory, tgt_is_directory,
+					 &free_list, &first_block, tp, spaceres);
 		if (error)
-			goto error_return;
+			goto abort_return;
+	} else {
 		/*
-		 * If target does not exist and the rename crosses
-		 * directories, adjust the target directory link count
-		 * to account for the ".." reference from the new entry.
+		 * Set up the target.
 		 */
-		error = xfs_dir_createname(tp, target_dp, target_name,
-						src_ip->i_ino, &first_block,
-						&free_list, spaceres);
-		if (error == -ENOSPC)
-			goto error_return;
-		if (error)
-			goto abort_return;
+		if (target_ip == NULL) {
+			/*
+			 * If there's no space reservation, check the entry will
+			 * fit before actually inserting it.
+			 */
+			error = xfs_dir_canenter(tp, target_dp, target_name, spaceres);
+			if (error)
+				goto error_return;
+			/*
+			 * If target does not exist and the rename crosses
+			 * directories, adjust the target directory link count
+			 * to account for the ".." reference from the new entry.
+			 */
+			error = xfs_dir_createname(tp, target_dp, target_name,
+							src_ip->i_ino, &first_block,
+							&free_list, spaceres);
+			if (error == -ENOSPC)
+				goto error_return;
+			if (error)
+				goto abort_return;
 
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+			xfs_trans_ichgtime(tp, target_dp,
+						XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
-		if (new_parent && src_is_directory) {
-			error = xfs_bumplink(tp, target_dp);
+			if (new_parent && src_is_directory) {
+				error = xfs_bumplink(tp, target_dp);
+				if (error)
+					goto abort_return;
+			}
+		} else { /* target_ip != NULL */
+			/*
+			 * If target exists and it's a directory, check that both
+			 * target and source are directories and that target can be
+			 * destroyed, or that neither is a directory.
+			 */
+			if (S_ISDIR(target_ip->i_d.di_mode)) {
+				/*
+				 * Make sure target dir is empty.
+				 */
+				if (!(xfs_dir_isempty(target_ip)) ||
+				    (target_ip->i_d.di_nlink > 2)) {
+					error = -EEXIST;
+					goto error_return;
+				}
+			}
+
+			/*
+			 * Link the source inode under the target name.
+			 * If the source inode is a directory and we are moving
+			 * it across directories, its ".." entry will be
+			 * inconsistent until we replace that down below.
+			 *
+			 * In case there is already an entry with the same
+			 * name at the destination directory, remove it first.
+			 */
+			error = xfs_dir_replace(tp, target_dp, target_name,
+						src_ip->i_ino,
+						&first_block, &free_list, spaceres);
 			if (error)
 				goto abort_return;
-		}
-	} else { /* target_ip != NULL */
+
+			xfs_trans_ichgtime(tp, target_dp,
+						XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+			/*
+			 * Decrement the link count on the target since the target
+			 * dir no longer points to it.
+			 */
+			error = xfs_droplink(tp, target_ip);
+			if (error)
+				goto abort_return;
+
+			if (src_is_directory) {
+				/*
+				 * Drop the link from the old "." entry.
+				 */
+				error = xfs_droplink(tp, target_ip);
+				if (error)
+					goto abort_return;
+			}
+		} /* target_ip != NULL */
+
 		/*
-		 * If target exists and it's a directory, check that both
-		 * target and source are directories and that target can be
-		 * destroyed, or that neither is a directory.
+		 * Remove the source.
 		 */
-		if (S_ISDIR(target_ip->i_d.di_mode)) {
+		if (new_parent && src_is_directory) {
 			/*
-			 * Make sure target dir is empty.
+			 * Rewrite the ".." entry to point to the new
+			 * directory.
 			 */
-			if (!(xfs_dir_isempty(target_ip)) ||
-			    (target_ip->i_d.di_nlink > 2)) {
-				error = -EEXIST;
-				goto error_return;
-			}
+			error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+						target_dp->i_ino,
+						&first_block, &free_list, spaceres);
+			ASSERT(error != -EEXIST);
+			if (error)
+				goto abort_return;
 		}
 
 		/*
-		 * Link the source inode under the target name.
-		 * If the source inode is a directory and we are moving
-		 * it across directories, its ".." entry will be
-		 * inconsistent until we replace that down below.
+		 * We always want to hit the ctime on the source inode.
 		 *
-		 * In case there is already an entry with the same
-		 * name at the destination directory, remove it first.
+		 * This isn't strictly required by the standards since the source
+		 * inode isn't really being changed, but old unix file systems did
+		 * it and some incremental backup programs won't work without it.
 		 */
-		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino,
-					&first_block, &free_list, spaceres);
-		if (error)
-			goto abort_return;
-
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+		xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
+		xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
 
 		/*
-		 * Decrement the link count on the target since the target
-		 * dir no longer points to it.
+		 * Adjust the link count on src_dp.  This is necessary when
+		 * renaming a directory, either within one parent when
+		 * the target existed, or across two parent directories.
 		 */
-		error = xfs_droplink(tp, target_ip);
-		if (error)
-			goto abort_return;
+		if (src_is_directory && (new_parent || target_ip != NULL)) {
 
-		if (src_is_directory) {
 			/*
-			 * Drop the link from the old "." entry.
+			 * Decrement link count on src_directory since the
+			 * entry that's moved no longer points to it.
 			 */
-			error = xfs_droplink(tp, target_ip);
+			error = xfs_droplink(tp, src_dp);
 			if (error)
 				goto abort_return;
 		}
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
-					target_dp->i_ino,
-					&first_block, &free_list, spaceres);
-		ASSERT(error != -EEXIST);
-		if (error)
-			goto abort_return;
-	}
 
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
+		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+						&first_block, &free_list, spaceres);
 		if (error)
 			goto abort_return;
-	}
 
-	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					&first_block, &free_list, spaceres);
-	if (error)
-		goto abort_return;
+		xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+		if (new_parent)
+			xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
-	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
-	if (new_parent)
-		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+	} /* RENAME_EXCHANGE */
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -2920,6 +2939,94 @@ xfs_rename(
 	return error;
 }
 
+/* xfs_cross_rename()
+ *
+ * responsible to handle RENAME_EXCHANGE flag
+ * in renameat2() sytemcall
+ */
+int
+xfs_cross_rename(
+	xfs_inode_t	*src_dp,
+	struct xfs_name	*src_name,
+	xfs_inode_t	*src_ip,
+	xfs_inode_t	*target_dp,
+	struct xfs_name	*target_name,
+	xfs_inode_t	*target_ip,
+	int		new_parent,
+	int		src_is_directory,
+	int		tgt_is_directory,
+	xfs_bmap_free_t	*free_list,
+	xfs_fsblock_t	*first_block,
+	xfs_trans_t	*tp,
+	int		spaceres)
+{
+	int		error = 0;
+
+	/* Replace source inode */
+	error = xfs_dir_replace(tp, src_dp, src_name,
+				target_ip->i_ino,
+				first_block, free_list, spaceres);
+	if (error)
+		goto out_abort;
+
+	/* Replace target inode */
+	error = xfs_dir_replace(tp, target_dp, target_name,
+				src_ip->i_ino,
+				first_block, free_list, spaceres);
+	if (error)
+		goto out_abort;
+
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+	/*
+	 * Update ".." entry to match the new parents
+	 *
+	 * In case we are crossing different file types between different
+	 * parents, we must update parent's link count to match the ".."
+	 * entry of the new child (or the removal of it).
+	 */
+	if (new_parent) {
+		xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		if (tgt_is_directory) {
+			error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot, src_dp->i_ino,
+						first_block, free_list, spaceres);
+			if (error)
+				goto out_abort;
+			if (!src_is_directory) {
+				error = xfs_droplink(tp, target_dp);
+				if (error)
+					goto out_abort;
+				error = xfs_bumplink(tp, src_dp);
+				if (error)
+					goto out_abort;
+			}
+		}
+
+		if (src_is_directory) {
+			error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot, target_dp->i_ino,
+						first_block, free_list, spaceres);
+			if (error)
+				goto out_abort;
+			if (!tgt_is_directory) {
+				error = xfs_droplink(tp, src_dp);
+				if (error)
+					goto out_abort;
+				error = xfs_bumplink(tp, target_dp);
+				if (error)
+					goto out_abort;
+			}
+		}
+		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+	}
+	xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, target_ip, XFS_ILOG_CORE);
+
+out_abort:
+	return error;
+}
+
 STATIC int
 xfs_iflush_cluster(
 	xfs_inode_t	*ip,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c10e3fa..c34dd41 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -340,7 +340,13 @@ int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
 int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 			   struct xfs_name *target_name,
-			   struct xfs_inode *target_ip);
+			   struct xfs_inode *target_ip, unsigned int flags);
+int		xfs_cross_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
+			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
+			   struct xfs_name *target_name, struct xfs_inode *target_ip,
+			   int new_parent, int src_is_directory, int tgt_is_directory,
+			   struct xfs_bmap_free *free_list, xfs_fsblock_t *first_block,
+			   struct xfs_trans *tp, int spaceres);
 
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8519442..d5ba974 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -391,7 +391,7 @@ xfs_vn_rename(
 	struct xfs_name	nname;
 
 	/* XFS does not support RENAME_EXCHANGE yet */
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
 	xfs_dentry_to_name(&oname, odentry, 0);
@@ -399,7 +399,7 @@ xfs_vn_rename(
 
 	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
 			  XFS_I(ndir), &nname,
-			  new_inode ? XFS_I(new_inode) : NULL);
+			  new_inode ? XFS_I(new_inode) : NULL, flags);
 }
 
 /*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
