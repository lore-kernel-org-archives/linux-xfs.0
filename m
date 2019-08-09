Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49444 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfHIVhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYPQj071860
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:35 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNMj0072043
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxjtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:34 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LbX7Q018948
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:33 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v2 02/18] xfs: Replace attribute parameters with struct xfs_name
Date: Fri,  9 Aug 2019 14:37:10 -0700
Message-Id: <20190809213726.32336-3-allison.henderson@oracle.com>
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch replaces the attribute name, length and flags parameters with a
single struct xfs_name parameter.  This helps to clean up the numbers of
parameters being passed around and pre-simplifies the code some.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 40 ++++++++++++++++------------------------
 fs/xfs/libxfs/xfs_attr.h | 12 +++++-------
 fs/xfs/xfs_acl.c         | 26 +++++++++++++-------------
 fs/xfs/xfs_ioctl.c       | 26 ++++++++++++++++----------
 fs/xfs/xfs_iops.c        | 10 ++++++----
 fs/xfs/xfs_xattr.c       | 21 +++++++++------------
 6 files changed, 65 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7761925..0c91116 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -61,9 +61,7 @@ STATIC int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
+	struct xfs_name		*name)
 {
 
 	if (!name)
@@ -73,9 +71,9 @@ xfs_attr_args_init(
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
-	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
+	args->flags = name->type;
+	args->name = name->name;
+	args->namelen = name->len;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -120,11 +118,9 @@ xfs_attr_get_ilocked(
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
-	int			*valuelenp,
-	int			flags)
+	int			*valuelenp)
 {
 	struct xfs_da_args	args;
 	uint			lock_mode;
@@ -135,7 +131,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
+	error = xfs_attr_args_init(&args, ip, name);
 	if (error)
 		return error;
 
@@ -306,16 +302,14 @@ xfs_attr_remove_args(
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
-	int			valuelen,
-	int			flags)
+	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			rsvd = (name->type & ATTR_ROOT) != 0;
 	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
@@ -323,7 +317,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name);
 	if (error)
 		return error;
 
@@ -386,7 +380,7 @@ xfs_attr_set(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
+	if ((name->type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
@@ -411,9 +405,7 @@ xfs_attr_set(
 int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
+	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
@@ -424,7 +416,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name);
 	if (error)
 		return error;
 
@@ -445,7 +437,7 @@ xfs_attr_remove(
 	 */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
 			XFS_ATTRRM_SPACE_RES(mp), 0,
-			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
+			(name->type & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
 			&args.trans);
 	if (error)
 		return error;
@@ -468,7 +460,7 @@ xfs_attr_remove(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
+	if ((name->type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 69493b5..aa7261a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -142,14 +142,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char *value, int *valuelenp);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index abb17a7..3da2568 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -113,7 +113,7 @@ xfs_get_acl(struct inode *inode, int type)
 	struct xfs_inode *ip = XFS_I(inode);
 	struct posix_acl *acl = NULL;
 	struct xfs_acl *xfs_acl;
-	unsigned char *ea_name;
+	struct xfs_name name;
 	int error;
 	int len;
 
@@ -121,10 +121,10 @@ xfs_get_acl(struct inode *inode, int type)
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
+		name.name = SGI_ACL_FILE;
 		break;
 	case ACL_TYPE_DEFAULT:
-		ea_name = SGI_ACL_DEFAULT;
+		name.name = SGI_ACL_DEFAULT;
 		break;
 	default:
 		BUG();
@@ -139,8 +139,9 @@ xfs_get_acl(struct inode *inode, int type)
 	if (!xfs_acl)
 		return ERR_PTR(-ENOMEM);
 
-	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
-			     (unsigned char *)xfs_acl, &len, ATTR_ROOT);
+	name.len = strlen(name.name);
+	name.type = ATTR_ROOT;
+	error = xfs_attr_get(ip, &name, (unsigned char *)xfs_acl, &len);
 	if (error) {
 		/*
 		 * If the attribute doesn't exist make sure we have a negative
@@ -160,17 +161,17 @@ int
 __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct xfs_inode *ip = XFS_I(inode);
-	unsigned char *ea_name;
+	struct xfs_name name;
 	int error;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
+		name.name = SGI_ACL_FILE;
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))
 			return acl ? -EACCES : 0;
-		ea_name = SGI_ACL_DEFAULT;
+		name.name = SGI_ACL_DEFAULT;
 		break;
 	default:
 		return -EINVAL;
@@ -190,17 +191,16 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		len -= sizeof(struct xfs_acl_entry) *
 			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 
-		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
-				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
+		name.len = strlen(name.name);
+		name.type = ATTR_ROOT;
+		error = xfs_attr_set(ip, &name, (unsigned char *)xfs_acl, len);
 
 		kmem_free(xfs_acl);
 	} else {
 		/*
 		 * A NULL ACL argument means we want to remove the ACL.
 		 */
-		error = xfs_attr_remove(ip, ea_name,
-					strlen(ea_name),
-					ATTR_ROOT);
+		error = xfs_attr_remove(ip, &name);
 
 		/*
 		 * If the attribute didn't exist to start with that's fine.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f3c7ba5..b6a7220 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -431,7 +431,7 @@ xfs_attrmulti_attr_get(
 {
 	unsigned char		*kbuf;
 	int			error = -EFAULT;
-	size_t			namelen;
+	struct xfs_name		xname;
 
 	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
@@ -439,9 +439,10 @@ xfs_attrmulti_attr_get(
 	if (!kbuf)
 		return -ENOMEM;
 
-	namelen = strlen(name);
-	error = xfs_attr_get(XFS_I(inode), name, namelen,
-			     kbuf, (int *)len, flags);
+	xname.name = name;
+	xname.len = strlen(name);
+	xname.type = flags;
+	error = xfs_attr_get(XFS_I(inode), &xname, kbuf, (int *)len);
 	if (error)
 		goto out_kfree;
 
@@ -463,7 +464,7 @@ xfs_attrmulti_attr_set(
 {
 	unsigned char		*kbuf;
 	int			error;
-	size_t			namelen;
+	struct xfs_name		xname;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
@@ -474,8 +475,10 @@ xfs_attrmulti_attr_set(
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	namelen = strlen(name);
-	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
+	xname.name = name;
+	xname.len = strlen(name);
+	xname.type = flags;
+	error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	kfree(kbuf);
@@ -489,12 +492,15 @@ xfs_attrmulti_attr_remove(
 	uint32_t		flags)
 {
 	int			error;
-	size_t			namelen;
+	struct xfs_name		xname;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	namelen = strlen(name);
-	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
+
+	xname.name = name;
+	xname.len = strlen(name);
+	xname.type = flags;
+	error = xfs_attr_remove(XFS_I(inode), &xname);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b1b7b1b..bdf925c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -46,13 +46,15 @@ xfs_initxattrs(
 {
 	const struct xattr	*xattr;
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_name		name;
 	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		error = xfs_attr_set(ip, xattr->name,
-				     strlen(xattr->name),
-				     xattr->value, xattr->value_len,
-				     ATTR_SECURE);
+		name.name = xattr->name;
+		name.len = strlen(xattr->name);
+		name.type = ATTR_SECURE;
+		error = xfs_attr_set(ip, &name,
+				     xattr->value, xattr->value_len);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index fe12d11..3c63930 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -20,18 +20,17 @@ static int
 xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, void *value, size_t size)
 {
-	int xflags = handler->flags;
 	struct xfs_inode *ip = XFS_I(inode);
 	int error, asize = size;
-	size_t namelen = strlen(name);
+	struct xfs_name xname = {name, strlen(name), handler->flags};
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (!size) {
-		xflags |= ATTR_KERNOVAL;
+		xname.type |= ATTR_KERNOVAL;
 		value = NULL;
 	}
 
-	error = xfs_attr_get(ip, name, namelen, value, &asize, xflags);
+	error = xfs_attr_get(ip, &xname, value, &asize);
 	if (error)
 		return error;
 	return asize;
@@ -64,23 +63,21 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, const void *value,
 		size_t size, int flags)
 {
-	int			xflags = handler->flags;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
-	size_t			namelen = strlen(name);
+	struct xfs_name		xname = {name, strlen(name), handler->flags};
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (flags & XATTR_CREATE)
-		xflags |= ATTR_CREATE;
+		xname.type |= ATTR_CREATE;
 	if (flags & XATTR_REPLACE)
-		xflags |= ATTR_REPLACE;
+		xname.type |= ATTR_REPLACE;
 
 	if (!value)
-		return xfs_attr_remove(ip, name,
-				       namelen, xflags);
-	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
+		return xfs_attr_remove(ip, &xname);
+	error = xfs_attr_set(ip, &xname, (void *)value, size);
 	if (!error)
-		xfs_forget_acl(inode, name, xflags);
+		xfs_forget_acl(inode, name, xname.type);
 
 	return error;
 }
-- 
2.7.4
