Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0F907FA7
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2B348F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	zdcjYZRLs56AQWs6 for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048Y-1V
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001yd-0V
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 25/49] xfs: consolidate xfs_rename.c
Date: Fri, 19 Jul 2013 16:24:56 +1000
Message-Id: <1374215120-7271-26-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Move the rename code to xfs_inode.c to continue consolidating
all the kernel xfs_inode operations in the one place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile     |   1 -
 fs/xfs/xfs_inode.c  | 308 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_rename.c | 347 ----------------------------------------------------
 3 files changed, 307 insertions(+), 349 deletions(-)
 delete mode 100644 fs/xfs/xfs_rename.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 8691dba..e5a0758 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -50,7 +50,6 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
-				   xfs_rename.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
 				   xfs_trans.o \
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aec7f15..29d41c4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2267,6 +2267,313 @@ xfs_remove(
 	return error;
 }
 
+/*
+ * Enter all inodes for a rename transaction into a sorted array.
+ */
+STATIC void
+xfs_sort_for_rename(
+	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
+	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
+	xfs_inode_t	*ip1,	/* in: inode of old entry */
+	xfs_inode_t	*ip2,	/* in: inode of new entry, if it
+				   already exists, NULL otherwise. */
+	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
+	int		*num_inodes)  /* out: number of inodes in array */
+{
+	xfs_inode_t		*temp;
+	int			i, j;
+
+	/*
+	 * i_tab contains a list of pointers to inodes.  We initialize
+	 * the table here & we'll sort it.  We will then use it to
+	 * order the acquisition of the inode locks.
+	 *
+	 * Note that the table may contain duplicates.  e.g., dp1 == dp2.
+	 */
+	i_tab[0] = dp1;
+	i_tab[1] = dp2;
+	i_tab[2] = ip1;
+	if (ip2) {
+		*num_inodes = 4;
+		i_tab[3] = ip2;
+	} else {
+		*num_inodes = 3;
+		i_tab[3] = NULL;
+	}
+
+	/*
+	 * Sort the elements via bubble sort.  (Remember, there are at
+	 * most 4 elements to sort, so this is adequate.)
+	 */
+	for (i = 0; i < *num_inodes; i++) {
+		for (j = 1; j < *num_inodes; j++) {
+			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino) {
+				temp = i_tab[j];
+				i_tab[j] = i_tab[j-1];
+				i_tab[j-1] = temp;
+			}
+		}
+	}
+}
+
+/*
+ * xfs_rename
+ */
+int
+xfs_rename(
+	xfs_inode_t	*src_dp,
+	struct xfs_name	*src_name,
+	xfs_inode_t	*src_ip,
+	xfs_inode_t	*target_dp,
+	struct xfs_name	*target_name,
+	xfs_inode_t	*target_ip)
+{
+	xfs_trans_t	*tp = NULL;
+	xfs_mount_t	*mp = src_dp->i_mount;
+	int		new_parent;		/* moving to a new dir */
+	int		src_is_directory;	/* src_name is a directory */
+	int		error;
+	xfs_bmap_free_t free_list;
+	xfs_fsblock_t   first_block;
+	int		cancel_flags;
+	int		committed;
+	xfs_inode_t	*inodes[4];
+	int		spaceres;
+	int		num_inodes;
+
+	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
+
+	new_parent = (src_dp != target_dp);
+	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
+
+	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
+				inodes, &num_inodes);
+
+	xfs_bmap_init(&free_list, &first_block);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
+	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
+	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
+	error = xfs_trans_reserve(tp, spaceres, XFS_RENAME_LOG_RES(mp), 0,
+			XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
+	if (error == ENOSPC) {
+		spaceres = 0;
+		error = xfs_trans_reserve(tp, 0, XFS_RENAME_LOG_RES(mp), 0,
+				XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
+	}
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto std_return;
+	}
+
+	/*
+	 * Attach the dquots to the inodes
+	 */
+	error = xfs_qm_vop_rename_dqattach(inodes);
+	if (error) {
+		xfs_trans_cancel(tp, cancel_flags);
+		goto std_return;
+	}
+
+	/*
+	 * Lock all the participating inodes. Depending upon whether
+	 * the target_name exists in the target directory, and
+	 * whether the target directory is the same as the source
+	 * directory, we can lock from 2 to 4 inodes.
+	 */
+	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
+
+	/*
+	 * Join all the inodes to the transaction. From this point on,
+	 * we can rely on either trans_commit or trans_cancel to unlock
+	 * them.
+	 */
+	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	if (new_parent)
+		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+	if (target_ip)
+		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * If we are using project inheritance, we only allow renames
+	 * into our tree when the project IDs are the same; else the
+	 * tree quota mechanism would be circumvented.
+	 */
+	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
+		error = XFS_ERROR(EXDEV);
+		goto error_return;
+	}
+
+	/*
+	 * Set up the target.
+	 */
+	if (target_ip == NULL) {
+		/*
+		 * If there's no space reservation, check the entry will
+		 * fit before actually inserting it.
+		 */
+		error = xfs_dir_canenter(tp, target_dp, target_name, spaceres);
+		if (error)
+			goto error_return;
+		/*
+		 * If target does not exist and the rename crosses
+		 * directories, adjust the target directory link count
+		 * to account for the ".." reference from the new entry.
+		 */
+		error = xfs_dir_createname(tp, target_dp, target_name,
+						src_ip->i_ino, &first_block,
+						&free_list, spaceres);
+		if (error == ENOSPC)
+			goto error_return;
+		if (error)
+			goto abort_return;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		if (new_parent && src_is_directory) {
+			error = xfs_bumplink(tp, target_dp);
+			if (error)
+				goto abort_return;
+		}
+	} else { /* target_ip != NULL */
+		/*
+		 * If target exists and it's a directory, check that both
+		 * target and source are directories and that target can be
+		 * destroyed, or that neither is a directory.
+		 */
+		if (S_ISDIR(target_ip->i_d.di_mode)) {
+			/*
+			 * Make sure target dir is empty.
+			 */
+			if (!(xfs_dir_isempty(target_ip)) ||
+			    (target_ip->i_d.di_nlink > 2)) {
+				error = XFS_ERROR(EEXIST);
+				goto error_return;
+			}
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
+					src_ip->i_ino,
+					&first_block, &free_list, spaceres);
+		if (error)
+			goto abort_return;
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
+			goto abort_return;
+
+		if (src_is_directory) {
+			/*
+			 * Drop the link from the old "." entry.
+			 */
+			error = xfs_droplink(tp, target_ip);
+			if (error)
+				goto abort_return;
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
+					target_dp->i_ino,
+					&first_block, &free_list, spaceres);
+		ASSERT(error != EEXIST);
+		if (error)
+			goto abort_return;
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
+			goto abort_return;
+	}
+
+	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+					&first_block, &free_list, spaceres);
+	if (error)
+		goto abort_return;
+
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+	if (new_parent)
+		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+
+	/*
+	 * If this is a synchronous mount, make sure that the
+	 * rename transaction goes to disk before returning to
+	 * the user.
+	 */
+	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
+		xfs_trans_set_sync(tp);
+	}
+
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error) {
+		xfs_bmap_cancel(&free_list);
+		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
+				 XFS_TRANS_ABORT));
+		goto std_return;
+	}
+
+	/*
+	 * trans_commit will unlock src_ip, target_ip & decrement
+	 * the vnode references.
+	 */
+	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+
+ abort_return:
+	cancel_flags |= XFS_TRANS_ABORT;
+ error_return:
+	xfs_bmap_cancel(&free_list);
+	xfs_trans_cancel(tp, cancel_flags);
+ std_return:
+	return error;
+}
+
 STATIC int
 xfs_iflush_cluster(
 	xfs_inode_t	*ip,
@@ -2523,7 +2830,6 @@ abort_out:
 	return error;
 }
 
-
 STATIC int
 xfs_iflush_int(
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
deleted file mode 100644
index c15c6c5..0000000
--- a/fs/xfs/xfs_rename.c
+++ /dev/null
@@ -1,347 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_format.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_da_btree.h"
-#include "xfs_dir2_format.h"
-#include "xfs_dir2.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_inode_item.h"
-#include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
-#include "xfs_error.h"
-#include "xfs_quota.h"
-#include "xfs_utils.h"
-#include "xfs_trans_space.h"
-#include "xfs_trace.h"
-
-
-/*
- * Enter all inodes for a rename transaction into a sorted array.
- */
-STATIC void
-xfs_sort_for_rename(
-	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
-	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
-	xfs_inode_t	*ip1,	/* in: inode of old entry */
-	xfs_inode_t	*ip2,	/* in: inode of new entry, if it
-				   already exists, NULL otherwise. */
-	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
-	int		*num_inodes)  /* out: number of inodes in array */
-{
-	xfs_inode_t		*temp;
-	int			i, j;
-
-	/*
-	 * i_tab contains a list of pointers to inodes.  We initialize
-	 * the table here & we'll sort it.  We will then use it to
-	 * order the acquisition of the inode locks.
-	 *
-	 * Note that the table may contain duplicates.  e.g., dp1 == dp2.
-	 */
-	i_tab[0] = dp1;
-	i_tab[1] = dp2;
-	i_tab[2] = ip1;
-	if (ip2) {
-		*num_inodes = 4;
-		i_tab[3] = ip2;
-	} else {
-		*num_inodes = 3;
-		i_tab[3] = NULL;
-	}
-
-	/*
-	 * Sort the elements via bubble sort.  (Remember, there are at
-	 * most 4 elements to sort, so this is adequate.)
-	 */
-	for (i = 0; i < *num_inodes; i++) {
-		for (j = 1; j < *num_inodes; j++) {
-			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino) {
-				temp = i_tab[j];
-				i_tab[j] = i_tab[j-1];
-				i_tab[j-1] = temp;
-			}
-		}
-	}
-}
-
-/*
- * xfs_rename
- */
-int
-xfs_rename(
-	xfs_inode_t	*src_dp,
-	struct xfs_name	*src_name,
-	xfs_inode_t	*src_ip,
-	xfs_inode_t	*target_dp,
-	struct xfs_name	*target_name,
-	xfs_inode_t	*target_ip)
-{
-	xfs_trans_t	*tp = NULL;
-	xfs_mount_t	*mp = src_dp->i_mount;
-	int		new_parent;		/* moving to a new dir */
-	int		src_is_directory;	/* src_name is a directory */
-	int		error;
-	xfs_bmap_free_t free_list;
-	xfs_fsblock_t   first_block;
-	int		cancel_flags;
-	int		committed;
-	xfs_inode_t	*inodes[4];
-	int		spaceres;
-	int		num_inodes;
-
-	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
-
-	new_parent = (src_dp != target_dp);
-	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
-
-	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
-				inodes, &num_inodes);
-
-	xfs_bmap_init(&free_list, &first_block);
-	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
-	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, spaceres, XFS_RENAME_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
-	if (error == ENOSPC) {
-		spaceres = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_RENAME_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
-	}
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		goto std_return;
-	}
-
-	/*
-	 * Attach the dquots to the inodes
-	 */
-	error = xfs_qm_vop_rename_dqattach(inodes);
-	if (error) {
-		xfs_trans_cancel(tp, cancel_flags);
-		goto std_return;
-	}
-
-	/*
-	 * Lock all the participating inodes. Depending upon whether
-	 * the target_name exists in the target directory, and
-	 * whether the target directory is the same as the source
-	 * directory, we can lock from 2 to 4 inodes.
-	 */
-	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
-
-	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
-	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
-	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
-	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * If we are using project inheritance, we only allow renames
-	 * into our tree when the project IDs are the same; else the
-	 * tree quota mechanism would be circumvented.
-	 */
-	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
-		error = XFS_ERROR(EXDEV);
-		goto error_return;
-	}
-
-	/*
-	 * Set up the target.
-	 */
-	if (target_ip == NULL) {
-		/*
-		 * If there's no space reservation, check the entry will
-		 * fit before actually inserting it.
-		 */
-		error = xfs_dir_canenter(tp, target_dp, target_name, spaceres);
-		if (error)
-			goto error_return;
-		/*
-		 * If target does not exist and the rename crosses
-		 * directories, adjust the target directory link count
-		 * to account for the ".." reference from the new entry.
-		 */
-		error = xfs_dir_createname(tp, target_dp, target_name,
-						src_ip->i_ino, &first_block,
-						&free_list, spaceres);
-		if (error == ENOSPC)
-			goto error_return;
-		if (error)
-			goto abort_return;
-
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-		if (new_parent && src_is_directory) {
-			error = xfs_bumplink(tp, target_dp);
-			if (error)
-				goto abort_return;
-		}
-	} else { /* target_ip != NULL */
-		/*
-		 * If target exists and it's a directory, check that both
-		 * target and source are directories and that target can be
-		 * destroyed, or that neither is a directory.
-		 */
-		if (S_ISDIR(target_ip->i_d.di_mode)) {
-			/*
-			 * Make sure target dir is empty.
-			 */
-			if (!(xfs_dir_isempty(target_ip)) ||
-			    (target_ip->i_d.di_nlink > 2)) {
-				error = XFS_ERROR(EEXIST);
-				goto error_return;
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
-					src_ip->i_ino,
-					&first_block, &free_list, spaceres);
-		if (error)
-			goto abort_return;
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
-			goto abort_return;
-
-		if (src_is_directory) {
-			/*
-			 * Drop the link from the old "." entry.
-			 */
-			error = xfs_droplink(tp, target_ip);
-			if (error)
-				goto abort_return;
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
-					target_dp->i_ino,
-					&first_block, &free_list, spaceres);
-		ASSERT(error != EEXIST);
-		if (error)
-			goto abort_return;
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
-			goto abort_return;
-	}
-
-	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					&first_block, &free_list, spaceres);
-	if (error)
-		goto abort_return;
-
-	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
-	if (new_parent)
-		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * rename transaction goes to disk before returning to
-	 * the user.
-	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
-		xfs_trans_set_sync(tp);
-	}
-
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
-	if (error) {
-		xfs_bmap_cancel(&free_list);
-		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
-				 XFS_TRANS_ABORT));
-		goto std_return;
-	}
-
-	/*
-	 * trans_commit will unlock src_ip, target_ip & decrement
-	 * the vnode references.
-	 */
-	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-
- abort_return:
-	cancel_flags |= XFS_TRANS_ABORT;
- error_return:
-	xfs_bmap_cancel(&free_list);
-	xfs_trans_cancel(tp, cancel_flags);
- std_return:
-	return error;
-}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
