Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbeIZQiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QAPBJ3073963
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mnd5thjs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPkEk004776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPk2N023175
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:46 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 10/30] xfsprogs: Roll delayed attr operations by returning EAGAIN
Date: Wed, 26 Sep 2018 03:23:13 -0700
Message-Id: <1537957413-10630-11-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch modifies xfs_attr_set_args to return -EAGAIN
when a transaction needs to be rolled.  All functions
currently calling xfs_attr_set_args are modified to use
the deferred attr operation, or handle the -EAGAIN return
code

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++++++----------
 libxfs/xfs_attr.h |  2 +-
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ad0c5cd..1935128 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -233,12 +233,20 @@ int
 xfs_attr_set_args(
 	struct xfs_da_args	*args,
 	struct xfs_buf          **leaf_bp,
+	xfs_attr_state_t	*state,
 	bool			roll_trans)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error = 0;
 	int			sf_size;
 
+	switch (*state) {
+	case (XFS_ATTR_STATE1):
+		goto state1;
+	case (XFS_ATTR_STATE2):
+		goto state2;
+	}
+
 	/*
 	 * New inodes setting the parent pointer attr will
 	 * not have an attribute fork yet. So set the attribute
@@ -259,7 +267,6 @@ xfs_attr_set_args(
 	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
 	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
 	     dp->i_d.di_anextents == 0)) {
-
 		/*
 		 * Build initial attribute list (if required).
 		 */
@@ -273,6 +280,9 @@ xfs_attr_set_args(
 		if (error != -ENOSPC)
 			goto out;
 
+		*state = XFS_ATTR_STATE1;
+		return -EAGAIN;
+state1:
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
@@ -281,14 +291,14 @@ xfs_attr_set_args(
 		if (error)
 			goto out;
 
-		if (roll_trans) {
-			/*
-			 * Prevent the leaf buffer from being unlocked so that a
-			 * concurrent AIL push cannot grab the half-baked leaf
-			 * buffer and run into problems with the write verifier.
-			 */
-			xfs_trans_bhold(args->trans, *leaf_bp);
+		/*
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf
+		 * buffer and run into problems with the write verifier.
+		 */
+		xfs_trans_bhold(args->trans, *leaf_bp);
 
+		if (roll_trans) {
 			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out;
@@ -304,6 +314,12 @@ xfs_attr_set_args(
 			xfs_trans_bjoin(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
 		}
+
+		*state = XFS_ATTR_STATE2;
+		return -EAGAIN;
+state2:
+		if (*leaf_bp != NULL)
+			xfs_trans_brelse(args->trans, *leaf_bp);
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
@@ -436,7 +452,9 @@ xfs_attr_set(
 	}
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args, &leaf_bp, true);
+
+	error = xfs_attr_set_deferred(dp, args.trans, name, strlen(name),
+			value, valuelen, flags);
 	if (error)
 		goto out;
 
@@ -566,8 +584,13 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_remove_args(&args, true);
+	error = xfs_has_attr(&args);
+	if (error)
+		goto out;
+
 
+	error = xfs_attr_remove_deferred(dp, args.trans,
+			name, strlen(name), flags);
 	if (error)
 		goto out;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index ad2a73c..ee4bc13 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -175,7 +175,7 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
-		 bool roll_trans);
+		 xfs_attr_state_t *state, bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
-- 
2.7.4
