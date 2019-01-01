Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfAACVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:21:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012E407173564
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:10 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jqx44c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:21:10 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012LAXM027580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:10 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012LAk9007699
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:10 GMT
Subject: [PATCH 18/22] xfs: create libxfs helper to remove an existing
 inode/name from a directory
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:21:08 -0800
Message-ID: <154630926888.18437.14958418182955807427.stgit@magnolia>
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

Create a new libxfs function to remove a (name, inode) entry from a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 ++
 fs/xfs/xfs_inode.c       |   42 +-------------------------------
 3 files changed, 64 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 4cd2afa234ca..59f8d887f8ce 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -792,3 +792,63 @@ xfs_dir_link_existing_child(
 
 	return xfs_bumplink(tp, ip);
 }
+
+/*
+ * Given a directory @dp, a child @ip, and a @name, remove the (@name, @ip)
+ * entry from the directory.  Both inodes must have the ILOCK held.
+ */
+int
+xfs_dir_remove_child(
+	struct xfs_trans		*tp,
+	uint				resblks,
+	struct xfs_inode		*dp,
+	struct xfs_name			*name,
+	struct xfs_inode		*ip)
+{
+	int				error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+
+	/*
+	 * If we're removing a directory perform some additional validation.
+	 */
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		ASSERT(VFS_I(ip)->i_nlink >= 2);
+		if (VFS_I(ip)->i_nlink != 2)
+			return -ENOTEMPTY;
+		if (!xfs_dir_isempty(ip))
+			return -ENOTEMPTY;
+
+		/* Drop the link from ip's "..".  */
+		error = xfs_droplink(tp, dp);
+		if (error)
+			return error;
+
+		/* Drop the "." link from ip to self.  */
+		error = xfs_droplink(tp, ip);
+		if (error)
+			return error;
+	} else {
+		/*
+		 * When removing a non-directory we need to log the parent
+		 * inode here.  For a directory this is done implicitly
+		 * by the xfs_droplink call for the ".." entry.
+		 */
+		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+	}
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+	/* Drop the link from dp to ip. */
+	error = xfs_droplink(tp, ip);
+	if (error)
+		return error;
+
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	if (error) {
+		ASSERT(error != -ENOENT);
+		return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 7e713fcb4c40..3da87780388e 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -333,5 +333,8 @@ int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
 int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_remove_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 93a03cbbb9af..a882563118c8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1926,50 +1926,10 @@ xfs_remove(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	/*
-	 * If we're removing a directory perform some additional validation.
-	 */
-	if (is_dir) {
-		ASSERT(VFS_I(ip)->i_nlink >= 2);
-		if (VFS_I(ip)->i_nlink != 2) {
-			error = -ENOTEMPTY;
-			goto out_trans_cancel;
-		}
-		if (!xfs_dir_isempty(ip)) {
-			error = -ENOTEMPTY;
-			goto out_trans_cancel;
-		}
-
-		/* Drop the link from ip's "..".  */
-		error = xfs_droplink(tp, dp);
-		if (error)
-			goto out_trans_cancel;
-
-		/* Drop the "." link from ip to self.  */
-		error = xfs_droplink(tp, ip);
-		if (error)
-			goto out_trans_cancel;
-	} else {
-		/*
-		 * When removing a non-directory we need to log the parent
-		 * inode here.  For a directory this is done implicitly
-		 * by the xfs_droplink call for the ".." entry.
-		 */
-		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-	/* Drop the link from dp to ip. */
-	error = xfs_droplink(tp, ip);
+	error = xfs_dir_remove_child(tp, resblks, dp, name, ip);
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
-	if (error) {
-		ASSERT(error != -ENOENT);
-		goto out_trans_cancel;
-	}
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
