Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33518 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbeEHEn3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484fYsm066377
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:29 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2hs426euqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:28 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w484hRTY015890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:28 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w484hRjH025417
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:27 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 07/21] xfsprogs: Remove all strlen calls in all xfs_attr_* functions for attr names.
Date: Mon,  7 May 2018 21:41:05 -0700
Message-Id: <1525754479-12177-8-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Parent pointer attributes use a binary name, so strlen will not work.
Calling functions will need to pass in the name length

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 12 ++++++++----
 libxfs/xfs_attr.h | 10 ++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f6b69c8..f83aa33 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -76,6 +76,7 @@ xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 
@@ -88,7 +89,7 @@ xfs_attr_args_init(
 	args->dp = dp;
 	args->flags = flags;
 	args->name = name;
-	args->namelen = strlen((const char *)name);
+	args->namelen = namelen;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -134,6 +135,7 @@ int
 xfs_attr_get(
 	struct xfs_inode	*ip,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			*valuelenp,
 	int			flags)
@@ -147,7 +149,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, flags);
+	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -360,6 +362,7 @@ int
 xfs_attr_set(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -378,7 +381,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -509,6 +512,7 @@ int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -522,7 +526,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index c706976..d23cf4a 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -166,17 +166,19 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 unsigned char *value, int *valuelenp, int flags);
+		size_t namelen, unsigned char *value, int *valuelenp,
+		int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 unsigned char *value, int valuelen, int flags);
+		size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, int flags,
 			struct xfs_buf *leaf_bp, bool roll_trans);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
+		size_t namelen, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args, int flags, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
-		       const unsigned char *name, int flags);
+		       const unsigned char *name, size_t namelen, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
 			  void *name, unsigned int name_len, void *value,
-- 
2.7.4

