Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38984 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752214AbeEHEn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484fMwn104907
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:27 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2hs5936sm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:27 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w484hQvt024113
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:26 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w484hQeL029372
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:26 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 04/21] xfsprogs: Add attibute remove and helper functions
Date: Mon,  7 May 2018 21:41:02 -0700
Message-Id: <1525754479-12177-5-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds xfs_attr_remove_args. This sub-routine removes
the attributes specified in @args. We will use this later for setting
parent pointers as a deferred attribute operation.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++++++----------
 libxfs/xfs_attr.h |  1 +
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3386799..0869bb1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -291,6 +291,34 @@ out:
 }
 
 /*
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
+	xfs_trans_ijoin(args->trans, dp, 0);
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
+/*
  * Calculate how many blocks we need for the new attribute,
  */
 STATIC int
@@ -434,6 +462,7 @@ out_defer_cancel:
 	return error;
 }
 
+
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
@@ -490,17 +519,9 @@ xfs_attr_remove(
 	 * blocks not allocate in the common case.
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
+	xfs_defer_init(args.dfops, args.firstblock);
 
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
@@ -525,6 +546,8 @@ xfs_attr_remove(
 	return error;
 
 out:
+	xfs_defer_cancel(&dfops);
+
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index adb1619..de2b99f 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -152,6 +152,7 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 int xfs_attr_set_args(struct xfs_da_args *args, int flags,
 			struct xfs_buf *leaf_bp, bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove_args(struct xfs_da_args *args, int flags, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 
-- 
2.7.4

