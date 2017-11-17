Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47574 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752589AbdKQSYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 13:24:06 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAHIO5vN005199
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAHIO4rl007984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:05 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAHIO4UG009055
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:04 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 04/17] Remove all strlen calls in all xfs_attr_* functions for attr names.
Date: Fri, 17 Nov 2017 11:21:32 -0700
Message-Id: <1510942905-12897-5-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

Parent pointer attributes use a binary name, so strlen will not work.
Calling functions will need to pass in the name length

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 12 ++++++++----
 fs/xfs/xfs_acl.c         | 12 +++++++-----
 fs/xfs/xfs_attr.h        | 10 ++++++----
 fs/xfs/xfs_ioctl.c       | 13 ++++++++++---
 fs/xfs/xfs_iops.c        |  6 ++++--
 fs/xfs/xfs_trans_attr.c  |  2 +-
 fs/xfs/xfs_xattr.c       | 10 +++++++---
 7 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 68dc7e04..61e8343 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -80,6 +80,7 @@ xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 
@@ -92,7 +93,7 @@ xfs_attr_args_init(
 	args->dp = dp;
 	args->flags = flags;
 	args->name = name;
-	args->namelen = strlen((const char *)name);
+	args->namelen = namelen;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -138,6 +139,7 @@ int
 xfs_attr_get(
 	struct xfs_inode	*ip,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			*valuelenp,
 	int			flags)
@@ -151,7 +153,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, flags);
+	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -397,6 +399,7 @@ int
 xfs_attr_set(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -413,7 +416,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -511,6 +514,7 @@ int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -524,7 +528,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3354140..d7ee630 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -153,8 +153,8 @@ xfs_get_acl(struct inode *inode, int type)
 	if (!xfs_acl)
 		return ERR_PTR(-ENOMEM);
 
-	error = xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
-							&len, ATTR_ROOT);
+	error = xfs_attr_get(ip, ea_name, strlen((const char *)ea_name),
+			     (unsigned char *)xfs_acl, &len, ATTR_ROOT);
 	if (error) {
 		/*
 		 * If the attribute doesn't exist make sure we have a negative
@@ -204,15 +204,17 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		len -= sizeof(struct xfs_acl_entry) *
 			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 
-		error = xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
-				len, ATTR_ROOT);
+		error = xfs_attr_set(ip, ea_name, strlen((const char *)ea_name),
+				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
 
 		kmem_free(xfs_acl);
 	} else {
 		/*
 		 * A NULL ACL argument means we want to remove the ACL.
 		 */
-		error = xfs_attr_remove(ip, ea_name, ATTR_ROOT);
+		error = xfs_attr_remove(ip, ea_name,
+					strlen((const char *)ea_name),
+					ATTR_ROOT);
 
 		/*
 		 * If the attribute didn't exist to start with that's fine.
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 8d4762a..10fc466 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -164,16 +164,18 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 unsigned char *value, int *valuelenp, int flags);
+		size_t namelen, unsigned char *value, int *valuelenp,
+		int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 unsigned char *value, int valuelen, int flags);
+		size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, int flags, bool roll_trans);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
+		size_t namelen, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
-		       const unsigned char *name, int flags);
+		       const unsigned char *name, size_t namelen, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
 			  void *name, unsigned int name_len, void *value,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index aa75389..4664314 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -448,6 +448,7 @@ xfs_attrmulti_attr_get(
 {
 	unsigned char		*kbuf;
 	int			error = -EFAULT;
+	size_t			namelen;
 
 	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
@@ -455,7 +456,9 @@ xfs_attrmulti_attr_get(
 	if (!kbuf)
 		return -ENOMEM;
 
-	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
+	namelen = strlen((const char *)name);
+	error = xfs_attr_get(XFS_I(inode), name, namelen,
+			     kbuf, (int *)len, flags);
 	if (error)
 		goto out_kfree;
 
@@ -477,6 +480,7 @@ xfs_attrmulti_attr_set(
 {
 	unsigned char		*kbuf;
 	int			error;
+	size_t			namelen;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
@@ -487,7 +491,8 @@ xfs_attrmulti_attr_set(
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
+	namelen = strlen((const char *)name);
+	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	kfree(kbuf);
@@ -501,10 +506,12 @@ xfs_attrmulti_attr_remove(
 	uint32_t		flags)
 {
 	int			error;
+	size_t			namelen;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	error = xfs_attr_remove(XFS_I(inode), name, flags);
+	namelen = strlen((const char *)name);
+	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 17081c7..5247bfc 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -70,8 +70,10 @@ xfs_initxattrs(
 	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		error = xfs_attr_set(ip, xattr->name, xattr->value,
-				      xattr->value_len, ATTR_SECURE);
+		error = xfs_attr_set(ip, xattr->name,
+				     strlen((const char *)xattr->name),
+				     xattr->value, xattr->value_len,
+				     ATTR_SECURE);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_trans_attr.c b/fs/xfs/xfs_trans_attr.c
index 7c3290f..da71cce 100644
--- a/fs/xfs/xfs_trans_attr.c
+++ b/fs/xfs/xfs_trans_attr.c
@@ -87,7 +87,7 @@ xfs_trans_attr(
 
 	tp->t_flags |= XFS_TRANS_RESERVE;
 
-	error = xfs_attr_args_init(&args, ip, name, flags);
+	error = xfs_attr_args_init(&args, ip, name, name_len, flags);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0594db4..10e58c6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -38,6 +38,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 	int xflags = handler->flags;
 	struct xfs_inode *ip = XFS_I(inode);
 	int error, asize = size;
+	size_t namelen = strlen((const char *)name);
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (!size) {
@@ -45,7 +46,8 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		value = NULL;
 	}
 
-	error = xfs_attr_get(ip, (unsigned char *)name, value, &asize, xflags);
+	error = xfs_attr_get(ip, (unsigned char *)name, namelen, value,
+			     &asize, xflags);
 	if (error)
 		return error;
 	return asize;
@@ -81,6 +83,7 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 	int			xflags = handler->flags;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
+	size_t			namelen = strlen((const char *)name);
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (flags & XATTR_CREATE)
@@ -89,8 +92,9 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 		xflags |= ATTR_REPLACE;
 
 	if (!value)
-		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
-	error = xfs_attr_set(ip, (unsigned char *)name,
+		return xfs_attr_remove(ip, (unsigned char *)name,
+				       namelen, xflags);
+	error = xfs_attr_set(ip, (unsigned char *)name, namelen,
 				(void *)value, size, xflags);
 	if (!error)
 		xfs_forget_acl(inode, name, xflags);
-- 
2.7.4

