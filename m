Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38114 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbfAACUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:20:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EEng173616
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:31 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jqx43r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:20:31 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012KVxf026456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:31 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012KUcw001946
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:31 GMT
Subject: [PATCH 14/22] xfs: hoist xfs_{bump,drop}link to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:20:29 -0800
Message-ID: <154630922972.18437.15462501590109940738.stgit@magnolia>
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

Move xfs_bumplink and xfs_droplink to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |   37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    2 ++
 fs/xfs/xfs_inode.c             |   37 -------------------------------------
 3 files changed, 39 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index b67d72cb8e38..e7251f8fd96a 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -786,3 +786,40 @@ xfs_iunlink_remove(
 	}
 	return 0;
 }
+
+/*
+ * Decrement the link count on an inode & log the change.  If this causes the
+ * link count to go to zero, move the inode to AGI unlinked list so that it can
+ * be freed when the last active reference goes away via xfs_inactive().
+ */
+int
+xfs_droplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	drop_nlink(VFS_I(ip));
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	if (VFS_I(ip)->i_nlink)
+		return 0;
+
+	return xfs_iunlink(tp, ip);
+}
+
+/*
+ * Increment the link count on an inode & log the change.
+ */
+int
+xfs_bumplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	ASSERT(ip->i_d.di_version > 1);
+	inc_nlink(VFS_I(ip));
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index bb403d3386ad..7258e18aeed0 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -98,5 +98,7 @@ int xfs_dir_ialloc(struct xfs_trans **tpp, const struct xfs_ialloc_args *args,
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 30c2f1076db0..110ce01f183e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -690,43 +690,6 @@ const struct xfs_ialloc_ops xfs_default_ialloc_ops = {
 	.ichunk_roll	= xfs_dir_ialloc_roll,
 };
 
-/*
- * Decrement the link count on an inode & log the change.  If this causes the
- * link count to go to zero, move the inode to AGI unlinked list so that it can
- * be freed when the last active reference goes away via xfs_inactive().
- */
-static int			/* error */
-xfs_droplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
-{
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	drop_nlink(VFS_I(ip));
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	if (VFS_I(ip)->i_nlink)
-		return 0;
-
-	return xfs_iunlink(tp, ip);
-}
-
-/*
- * Increment the link count on an inode & log the change.
- */
-static int
-xfs_bumplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
-{
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	ASSERT(ip->i_d.di_version > 1);
-	inc_nlink(VFS_I(ip));
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return 0;
-}
-
 int
 xfs_create(
 	struct xfs_inode		*dp,
