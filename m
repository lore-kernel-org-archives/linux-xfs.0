Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33620 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbeIZQiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QAO8Fc073358
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mnd5thjs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPllg004812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPlFb023182
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 12/30] xfsprogs: Remove all strlen calls in all xfs_attr_* functions for attr names
Date: Wed, 26 Sep 2018 03:23:15 -0700
Message-Id: <1537957413-10630-13-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Parent pointer attributes use a binary name, so strlen will not work.
Calling functions will need to pass in the name length

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c | 16 ++++++++++------
 libxfs/xfs_attr.h | 10 ++++++----
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b71d9ed..1e86c94 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -66,6 +66,7 @@ xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 
@@ -78,7 +79,7 @@ xfs_attr_args_init(
 	args->dp = dp;
 	args->flags = flags;
 	args->name = name;
-	args->namelen = strlen((const char *)name);
+	args->namelen = namelen;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -124,6 +125,7 @@ int
 xfs_attr_get(
 	struct xfs_inode	*ip,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			*valuelenp,
 	int			flags)
@@ -137,7 +139,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, flags);
+	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -366,6 +368,7 @@ int
 xfs_attr_set(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -382,7 +385,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -434,7 +437,7 @@ xfs_attr_set(
 
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_set_deferred(dp, args.trans, name, strlen(name),
+	error = xfs_attr_set_deferred(dp, args.trans, name, namelen,
 			value, valuelen, flags);
 	if (error)
 		goto out;
@@ -521,6 +524,7 @@ int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -532,7 +536,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -571,7 +575,7 @@ xfs_attr_remove(
 
 
 	error = xfs_attr_remove_deferred(dp, args.trans,
-			name, strlen(name), flags);
+			name, namelen, flags);
 	if (error)
 		goto out;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index c076f0c..d3407f1 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -171,18 +171,20 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 unsigned char *value, int *valuelenp, int flags);
+		size_t namelen, unsigned char *value, int *valuelenp,
+		int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 unsigned char *value, int valuelen, int flags);
+		 size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
 		 xfs_attr_state_t *state);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
+		size_t namelen, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
-		       const unsigned char *name, int flags);
+		       const unsigned char *name, size_t namelen, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
 			  const unsigned char *name, unsigned int name_len,
-- 
2.7.4
