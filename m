Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E1bMOw208858 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 19:37:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C9421C4D8BD
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 17:38:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Q0aiBgthl7JLOPD8 for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 17:38:17 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11630444-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:08:16 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVEf8-0007MZ-VC
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 12:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVEb5-0003UN-Ma
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 12:34:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: clean up inconsistent variable naming in
	xfs_swap_extent
Date: Thu, 14 Jan 2010 12:33:56 +1100
Message-Id: <1263432836-13368-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263432836-13368-1-git-send-email-david@fromorbit.com>
References: <1263432836-13368-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The swap extent ioctl passes in a target inode and a temporary
inode which are clearly named in the ioctl structure. The code
then assigns temp to target and vice versa, making it extremely
difficult to work out which inode is which later in the code.
Make this consistent throughout the code.

Also make xfs_swap_extent static as there are no external users
of the function.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_dfrag.c |   38 ++++++++++++++++++++++----------------
 fs/xfs/xfs_dfrag.h |    3 ---
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index eb4e404..e339e89 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -45,15 +45,21 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
+
+static int xfs_swap_extents(
+	xfs_inode_t	*ip,	/* target inode */
+	xfs_inode_t	*tip,	/* tmp inode */
+	xfs_swapext_t	*sxp);
+
 /*
- * Syssgi interface for swapext
+ * ioctl interface for swapext
  */
 int
 xfs_swapext(
 	xfs_swapext_t	*sxp)
 {
 	xfs_inode_t     *ip, *tip;
-	struct file	*file, *target_file;
+	struct file	*file, *tmp_file;
 	int		error = 0;
 
 	/* Pull information for the target fd */
@@ -68,46 +74,46 @@ xfs_swapext(
 		goto out_put_file;
 	}
 
-	target_file = fget((int)sxp->sx_fdtmp);
-	if (!target_file) {
+	tmp_file = fget((int)sxp->sx_fdtmp);
+	if (!tmp_file) {
 		error = XFS_ERROR(EINVAL);
 		goto out_put_file;
 	}
 
-	if (!(target_file->f_mode & FMODE_WRITE) ||
-	    (target_file->f_flags & O_APPEND)) {
+	if (!(tmp_file->f_mode & FMODE_WRITE) ||
+	    (tmp_file->f_flags & O_APPEND)) {
 		error = XFS_ERROR(EBADF);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	if (IS_SWAPFILE(file->f_path.dentry->d_inode) ||
-	    IS_SWAPFILE(target_file->f_path.dentry->d_inode)) {
+	    IS_SWAPFILE(tmp_file->f_path.dentry->d_inode)) {
 		error = XFS_ERROR(EINVAL);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	ip = XFS_I(file->f_path.dentry->d_inode);
-	tip = XFS_I(target_file->f_path.dentry->d_inode);
+	tip = XFS_I(tmp_file->f_path.dentry->d_inode);
 
 	if (ip->i_mount != tip->i_mount) {
 		error = XFS_ERROR(EINVAL);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	if (ip->i_ino == tip->i_ino) {
 		error = XFS_ERROR(EINVAL);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		error = XFS_ERROR(EIO);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	error = xfs_swap_extents(ip, tip, sxp);
 
- out_put_target_file:
-	fput(target_file);
+ out_put_tmp_file:
+	fput(tmp_file);
  out_put_file:
 	fput(file);
  out:
@@ -186,7 +192,7 @@ xfs_swap_extents_check_format(
 	return 0;
 }
 
-int
+static int
 xfs_swap_extents(
 	xfs_inode_t	*ip,	/* target inode */
 	xfs_inode_t	*tip,	/* tmp inode */
diff --git a/fs/xfs/xfs_dfrag.h b/fs/xfs/xfs_dfrag.h
index 4f55a63..20bdd93 100644
--- a/fs/xfs/xfs_dfrag.h
+++ b/fs/xfs/xfs_dfrag.h
@@ -48,9 +48,6 @@ typedef struct xfs_swapext
  */
 int	xfs_swapext(struct xfs_swapext *sx);
 
-int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
-		struct xfs_swapext *sxp);
-
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_DFRAG_H__ */
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
