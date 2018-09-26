Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbeIZQ3e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:29:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QADwFe029204
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:20 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mnvtur87j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:20 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHJ6X031058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:19 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAHJ01027626
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:19 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v9 04/28] xfs: Add attibute remove and helper functions
Date: Wed, 26 Sep 2018 03:14:43 -0700
Message-Id: <1537956907-10244-5-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds xfs_attr_remove_args. These sub-routines remove
the attributes specified in @args. We will use this later for setting
parent pointers as a deferred attribute operation.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 36 +++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h |  1 +
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index bc70151..cecf950 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -315,6 +315,30 @@ xfs_attr_set_args(
 	return error;
 }
 
+/*
+ * Remove the attribute specified in @args.
+ */
+int
+xfs_attr_remove_args(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (!xfs_inode_hasattr(dp)) {
+		error = -ENOATTR;
+	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		error = xfs_attr_shortform_remove(args);
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		error = xfs_attr_leaf_removename(args);
+	} else {
+		error = xfs_attr_node_removename(args);
+	}
+
+	return error;
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -470,17 +494,7 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	if (!xfs_inode_hasattr(dp)) {
-		error = -ENOATTR;
-	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		error = xfs_attr_shortform_remove(&args);
-	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(&args);
-	} else {
-		error = xfs_attr_node_removename(&args);
-	}
-
+	error = xfs_attr_remove_args(&args);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index f608ac8..bdf52a3 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -142,6 +142,7 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 
-- 
2.7.4
