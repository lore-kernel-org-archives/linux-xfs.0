Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 86E377F47
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 12:13:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 754A18F8033
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 10:13:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 84vtbxlvAMJQiAAE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Dec 2014 10:13:08 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBHID7cP011516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 13:13:07 -0500
Received: from lenovo-rd230-04.lab.bos.redhat.com
	(lenovo-rd230-04.lab.bos.redhat.com [10.16.42.190])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sBHID6Kq019215
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 13:13:07 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/2] Add support to RENAME_EXCHANGE flag 
Date: Wed, 17 Dec 2014 13:13:04 -0500
Message-Id: <1418839984-2514-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1418839984-2514-1-git-send-email-cmaiolino@redhat.com>
References: <1418839984-2514-1-git-send-email-cmaiolino@redhat.com>
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

Adds a new function named xfs_cross_rename(), responsible for handling requests
from sys_renameat2() using RENAME_EXCHANGE flag.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_inode.c | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h |   2 +-
 fs/xfs/xfs_iops.c  |  12 +++--
 3 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ed049d..61c796a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2669,6 +2669,124 @@ xfs_sort_for_rename(
 }
 
 /*
+ * xfs_cross_rename()
+ *
+ * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
+ */
+STATIC int
+xfs_cross_rename(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp1,
+	struct xfs_name		*name1,
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*dp2,
+	struct xfs_name		*name2,
+	struct xfs_inode	*ip2,
+	struct xfs_bmap_free	*free_list,
+	xfs_fsblock_t		*first_block,
+	int			spaceres)
+{
+	int		error = 0;
+	int		ip1_flags = 0;
+	int		ip2_flags = 0;
+	int		dp2_flags = 0;
+
+	/* Swap inode number for dirent in first parent */
+	error = xfs_dir_replace(tp, dp1, name1,
+				ip2->i_ino,
+				first_block, free_list, spaceres);
+	if (error)
+		goto out;
+
+	/* Swap inode number for dirent in second parent */
+	error = xfs_dir_replace(tp, dp2, name2,
+				ip1->i_ino,
+				first_block, free_list, spaceres);
+	if (error)
+		goto out;
+
+	/*
+	 * If we're renaming one or more directories across different parents,
+	 * update the respective ".." entries (and link counts) to match the new
+	 * parents.
+	 */
+	if (dp1 != dp2) {
+		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+
+		if (S_ISDIR(ip2->i_d.di_mode)) {
+			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
+						dp1->i_ino, first_block,
+						free_list, spaceres);
+			if (error)
+				goto out;
+
+			/* transfer ip2 ".." reference to dp1 */
+			if (!S_ISDIR(ip1->i_d.di_mode)) {
+				error = xfs_droplink(tp, dp2);
+				if (error)
+					goto out;
+				error = xfs_bumplink(tp, dp1);
+				if (error)
+					goto out;
+			}
+
+			/*
+			 * Although ip1 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+		}
+
+		if (S_ISDIR(ip1->i_d.di_mode)) {
+			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
+						dp2->i_ino, first_block,
+						free_list, spaceres);
+			if (error)
+				goto out;
+
+			/* transfer ip1 ".." reference to dp2 */
+			if (!S_ISDIR(ip2->i_d.di_mode)) {
+				error = xfs_droplink(tp, dp1);
+				if (error)
+					goto out;
+				error = xfs_bumplink(tp, dp2);
+				if (error)
+					goto out;
+			}
+
+			/*
+			 * Although ip2 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_CHG;
+		}
+	}
+
+	if (ip1_flags) {
+		xfs_trans_ichgtime(tp, ip1, ip1_flags);
+		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
+	}
+	if (ip2_flags) {
+		xfs_trans_ichgtime(tp, ip2, ip2_flags);
+		xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
+	}
+	if (dp2_flags) {
+		xfs_trans_ichgtime(tp, dp2, dp2_flags);
+		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
+	}
+	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+out:
+	return error;
+}
+
+/*
  * xfs_rename
  */
 int
@@ -2678,7 +2796,8 @@ xfs_rename(
 	xfs_inode_t	*src_ip,
 	xfs_inode_t	*target_dp,
 	struct xfs_name	*target_name,
-	xfs_inode_t	*target_ip)
+	xfs_inode_t	*target_ip,
+	unsigned int	flags)
 {
 	xfs_trans_t	*tp = NULL;
 	xfs_mount_t	*mp = src_dp->i_mount;
@@ -2756,6 +2875,18 @@ xfs_rename(
 	}
 
 	/*
+	 * Handle RENAME_EXCHANGE flags
+	 */
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
+					 target_dp, target_name, target_ip,
+					 &free_list, &first_block, spaceres);
+		if (error)
+			goto abort_return;
+		goto finish_rename;
+	}
+
+	/*
 	 * Set up the target.
 	 */
 	if (target_ip == NULL) {
@@ -2894,6 +3025,7 @@ xfs_rename(
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
+finish_rename:
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * rename transaction goes to disk before returning to
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9af2882..051d9f0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -340,7 +340,7 @@ int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
 int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 			   struct xfs_name *target_name,
-			   struct xfs_inode *target_ip);
+			   struct xfs_inode *target_ip, unsigned int flags);
 
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0b8704c..3049eb3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -387,19 +387,23 @@ xfs_vn_rename(
 	unsigned int	flags)
 {
 	struct inode	*new_inode = ndentry->d_inode;
+	int		omode = 0;
 	struct xfs_name	oname;
 	struct xfs_name	nname;
 
-	/* XFS does not support RENAME_EXCHANGE yet */
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
-	xfs_dentry_to_name(&oname, odentry, 0);
+	/* if we are exchanging files, we need to set i_mode of both files */
+	if (flags & RENAME_EXCHANGE)
+		omode = ndentry->d_inode->i_mode;
+
+	xfs_dentry_to_name(&oname, odentry, omode);
 	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
 
 	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
 			  XFS_I(ndir), &nname,
-			  new_inode ? XFS_I(new_inode) : NULL);
+			  new_inode ? XFS_I(new_inode) : NULL, flags);
 }
 
 /*
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
