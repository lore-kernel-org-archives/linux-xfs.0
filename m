Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55578 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfAACVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:21:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EQQj168536
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:17 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2pnxedxau0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:21:17 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012LGNu027760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:16 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012LGsE028132
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:16 GMT
Subject: [PATCH 19/22] xfs: create libxfs helper to exchange two directory
 entries
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:21:15 -0800
Message-ID: <154630927502.18437.9946178523553956744.stgit@magnolia>
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

Create a new libxfs function to exchange two directory entries.
The upcoming metadata directory feature will need this to replace a
metadata inode directory entry.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    4 ++
 fs/xfs/xfs_inode.c       |   89 +------------------------------------
 3 files changed, 119 insertions(+), 86 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 59f8d887f8ce..fbd5ce580b4a 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -852,3 +852,115 @@ xfs_dir_remove_child(
 
 	return 0;
 }
+
+/*
+ * Exchange the entry (@name1, @ip1) in directory @dp1 with the entry (@name2,
+ * @ip2) in directory @dp2, and update '..' @ip1 and @ip2's entries as needed.
+ * @ip1 and @ip2 need not be of the same type.
+ *
+ * All inodes must have the ILOCK held, and both entries must already exist.
+ */
+int
+xfs_dir_exchange(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp1,
+	struct xfs_name		*name1,
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*dp2,
+	struct xfs_name		*name2,
+	struct xfs_inode	*ip2,
+	unsigned int		spaceres)
+{
+	int			ip1_flags = 0;
+	int			ip2_flags = 0;
+	int			dp2_flags = 0;
+	int			error;
+
+	/* Swap inode number for dirent in first parent */
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/* Swap inode number for dirent in second parent */
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/*
+	 * If we're renaming one or more directories across different parents,
+	 * update the respective ".." entries (and link counts) to match the new
+	 * parents.
+	 */
+	if (dp1 != dp2) {
+		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+
+		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
+			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
+						dp1->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip2 ".." reference to dp1 */
+			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
+				error = xfs_droplink(tp, dp2);
+				if (error)
+					return error;
+				error = xfs_bumplink(tp, dp1);
+				if (error)
+					return error;
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
+		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
+			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
+						dp2->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip1 ".." reference to dp2 */
+			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
+				error = xfs_droplink(tp, dp1);
+				if (error)
+					return error;
+				error = xfs_bumplink(tp, dp2);
+				if (error)
+					return error;
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
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 3da87780388e..09765f010f90 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -336,5 +336,9 @@ int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
 int xfs_dir_remove_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_exchange(struct xfs_trans *tp, struct xfs_inode *dp1,
+		struct xfs_name *name1, struct xfs_inode *ip1,
+		struct xfs_inode *dp2, struct xfs_name *name2,
+		struct xfs_inode *ip2, unsigned int spaceres);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a882563118c8..3bed0db609bd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2034,96 +2034,13 @@ xfs_cross_rename(
 	struct xfs_inode	*ip2,
 	int			spaceres)
 {
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
-
-	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
-	if (error)
-		goto out_trans_abort;
+	int			error;
 
-	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_exchange(tp, dp1, name1, ip1, dp2, name2, ip2,
+			spaceres);
 	if (error)
 		goto out_trans_abort;
 
-	/*
-	 * If we're renaming one or more directories across different parents,
-	 * update the respective ".." entries (and link counts) to match the new
-	 * parents.
-	 */
-	if (dp1 != dp2) {
-		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-
-		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
-			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
-			if (error)
-				goto out_trans_abort;
-
-			/* transfer ip2 ".." reference to dp1 */
-			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
-				error = xfs_droplink(tp, dp2);
-				if (error)
-					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp1);
-				if (error)
-					goto out_trans_abort;
-			}
-
-			/*
-			 * Although ip1 isn't changed here, userspace needs
-			 * to be warned about the change, so that applications
-			 * relying on it (like backup ones), will properly
-			 * notify the change
-			 */
-			ip1_flags |= XFS_ICHGTIME_CHG;
-			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-		}
-
-		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
-			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
-			if (error)
-				goto out_trans_abort;
-
-			/* transfer ip1 ".." reference to dp2 */
-			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
-				error = xfs_droplink(tp, dp1);
-				if (error)
-					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp2);
-				if (error)
-					goto out_trans_abort;
-			}
-
-			/*
-			 * Although ip2 isn't changed here, userspace needs
-			 * to be warned about the change, so that applications
-			 * relying on it (like backup ones), will properly
-			 * notify the change
-			 */
-			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-			ip2_flags |= XFS_ICHGTIME_CHG;
-		}
-	}
-
-	if (ip1_flags) {
-		xfs_trans_ichgtime(tp, ip1, ip1_flags);
-		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
-	}
-	if (ip2_flags) {
-		xfs_trans_ichgtime(tp, ip2, ip2_flags);
-		xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
-	}
-	if (dp2_flags) {
-		xfs_trans_ichgtime(tp, dp2, dp2_flags);
-		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
-	}
-	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
