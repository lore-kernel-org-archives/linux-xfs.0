Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55402 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfAACU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:20:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012E4im168470
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:58 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxedxatp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:20:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012KvIi009787
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:57 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012KvHV026502
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:57 GMT
Subject: [PATCH 16/22] xfs: create libxfs helper to link an existing inode
 into a directory
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:20:49 -0800
Message-ID: <154630924968.18437.14431992739946835828.stgit@magnolia>
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

Create a new libxfs function to link an existing inode into a directory.
The upcoming metadata directory feature will need this to create a
metadata directory tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 +++
 fs/xfs/xfs_inode.c       |   24 +-----------------------
 3 files changed, 48 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index aaac55668e9d..4cd2afa234ca 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -748,3 +748,47 @@ xfs_dir_create_new_child(
 
 	return xfs_bumplink(tp, dp);
 }
+
+/*
+ * Given a directory @dp, an existing non-directory inode @ip, and a @name,
+ * link @ip into @dp under the given @name.  Both inodes must have the ILOCK
+ * held.
+ */
+int
+xfs_dir_link_existing_child(
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
+	ASSERT(!S_ISDIR(VFS_I(ip)->i_mode));
+
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, name);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Handle initial link state of O_TMPFILE inode
+	 */
+	if (VFS_I(ip)->i_nlink == 0) {
+		error = xfs_iunlink_remove(tp, ip);
+		if (error)
+			return error;
+	}
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	return xfs_bumplink(tp, ip);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 5219ca503012..7e713fcb4c40 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -330,5 +330,8 @@ void *xfs_dir3_data_endp(struct xfs_da_geometry *geo,
 int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1469f905be36..189f11bba539 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -974,29 +974,7 @@ xfs_link(
 		goto error_return;
 	}
 
-	if (!resblks) {
-		error = xfs_dir_canenter(tp, tdp, target_name);
-		if (error)
-			goto error_return;
-	}
-
-	/*
-	 * Handle initial link state of O_TMPFILE inode
-	 */
-	if (VFS_I(sip)->i_nlink == 0) {
-		error = xfs_iunlink_remove(tp, sip);
-		if (error)
-			goto error_return;
-	}
-
-	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
-	if (error)
-		goto error_return;
-	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
-
-	error = xfs_bumplink(tp, sip);
+	error = xfs_dir_link_existing_child(tp, resblks, tdp, target_name, sip);
 	if (error)
 		goto error_return;
 
