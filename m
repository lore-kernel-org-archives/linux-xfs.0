Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbeFJFH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:07:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A56Pl0141614
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:26 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2jgecx94m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:26 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57Pes002015
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:25 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A57Pll000443
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:25 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v7 05/23] xfs: Add attibute remove and helper functions
Date: Sat,  9 Jun 2018 22:04:50 -0700
Message-Id: <1528607108-11059-6-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds xfs_attr_remove_args. These sub-routines remove
the attributes specified in @args. We will use this later for setting
parent pointers as a deferred attribute operation.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 37 +++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr.h |  1 +
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 856c816..ab769e5 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -344,6 +344,32 @@ xfs_attr_set_args(
 	return error;
 }
 
+/*
+ * Remove the attribute specified in @args.
+ */
+int
+xfs_attr_remove_args(
+	struct xfs_da_args      *args,
+	int			flags,
+	bool                    roll_trans)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (!xfs_inode_hasattr(dp)) {
+		error = -ENOATTR;
+	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		error = xfs_attr_shortform_remove(args, roll_trans);
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		error = xfs_attr_leaf_removename(args, roll_trans);
+	} else {
+		error = xfs_attr_node_removename(args, roll_trans);
+	}
+
+	return error;
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -507,16 +533,7 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	if (!xfs_inode_hasattr(dp)) {
-		error = -ENOATTR;
-	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		error = xfs_attr_shortform_remove(&args, true);
-	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(&args, true);
-	} else {
-		error = xfs_attr_node_removename(&args, true);
-	}
+	error = xfs_attr_remove_args(&args, flags, true);
 
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b5dc02c..ef6b47e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -155,6 +155,7 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 int xfs_attr_set_args(struct xfs_da_args *args, int flags,
 			struct xfs_buf *leaf_bp, bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove_args(struct xfs_da_args *args, int flags, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 
-- 
2.7.4

