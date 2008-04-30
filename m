Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 04:22:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UBLmen006780
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:21:56 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8918416064D3
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:22:24 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id OVoRXhVDynEDZtvl for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:22:24 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3UBMHF3017487
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 13:22:17 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3UBMHpE017485
	for xfs@oss.sgi.com; Wed, 30 Apr 2008 13:22:17 +0200
Date: Wed, 30 Apr 2008 13:22:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] use generic_*xattr routines
Message-ID: <20080430112217.GB16966@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Use the generic set, get and removexattr methods and supply the s_xattr
array with fine-grained handlers.  All XFS/Linux highlevel attr handling is
rewritten from scratch and placed into fs/xfs/linux-2.6/xfs_xattr.c so
that it's separated from the generic low-level code.

The code size reduction is not as big as I had hoped, but it's still a
worthwile cleanup.

I didn't managed to get rid of struct attrnames yet, as it's still used
to hack the Linux string prefixes into the output inside the lowest
level xattr code.  I have some plans to clean that bit up aswell, but
that will have to wait for a while.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/Makefile
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile	2008-04-30 08:24:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Makefile	2008-04-30 08:43:49.000000000 +0200
@@ -97,6 +97,7 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   xfs_lrw.o \
 				   xfs_super.o \
 				   xfs_vnode.o \
+				   xfs_xattr.o \
 				   xfs_ksyms.o) 
 
 # Objects in support/
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-04-30 08:35:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-04-30 08:43:49.000000000 +0200
@@ -282,7 +282,7 @@ xfs_vn_mknod(
 	struct xfs_inode *ip = NULL;
 	xfs_acl_t	*default_acl = NULL;
 	struct xfs_name	name;
-	attrexists_t	test_default_acl = _ACL_DEFAULT_EXISTS;
+	int (*test_default_acl)(struct inode *) = _ACL_DEFAULT_EXISTS;
 	int		error;
 
 	/*
@@ -735,98 +735,6 @@ xfs_vn_truncate(
 	WARN_ON(error);
 }
 
-STATIC int
-xfs_vn_setxattr(
-	struct dentry	*dentry,
-	const char	*name,
-	const void	*data,
-	size_t		size,
-	int		flags)
-{
-	bhv_vnode_t	*vp = vn_from_inode(dentry->d_inode);
-	char		*attr = (char *)name;
-	attrnames_t	*namesp;
-	int		xflags = 0;
-
-	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
-	if (!namesp)
-		return -EOPNOTSUPP;
-	attr += namesp->attr_namelen;
-
-	/* Convert Linux syscall to XFS internal ATTR flags */
-	if (flags & XATTR_CREATE)
-		xflags |= ATTR_CREATE;
-	if (flags & XATTR_REPLACE)
-		xflags |= ATTR_REPLACE;
-	xflags |= namesp->attr_flag;
-	return namesp->attr_set(vp, attr, (void *)data, size, xflags);
-}
-
-STATIC ssize_t
-xfs_vn_getxattr(
-	struct dentry	*dentry,
-	const char	*name,
-	void		*data,
-	size_t		size)
-{
-	bhv_vnode_t	*vp = vn_from_inode(dentry->d_inode);
-	char		*attr = (char *)name;
-	attrnames_t	*namesp;
-	int		xflags = 0;
-
-	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
-	if (!namesp)
-		return -EOPNOTSUPP;
-	attr += namesp->attr_namelen;
-
-	/* Convert Linux syscall to XFS internal ATTR flags */
-	if (!size) {
-		xflags |= ATTR_KERNOVAL;
-		data = NULL;
-	}
-	xflags |= namesp->attr_flag;
-	return namesp->attr_get(vp, attr, (void *)data, size, xflags);
-}
-
-STATIC ssize_t
-xfs_vn_listxattr(
-	struct dentry		*dentry,
-	char			*data,
-	size_t			size)
-{
-	bhv_vnode_t		*vp = vn_from_inode(dentry->d_inode);
-	int			error, xflags = ATTR_KERNAMELS;
-	ssize_t			result;
-
-	if (!size)
-		xflags |= ATTR_KERNOVAL;
-	xflags |= capable(CAP_SYS_ADMIN) ? ATTR_KERNFULLS : ATTR_KERNORMALS;
-
-	error = attr_generic_list(vp, data, size, xflags, &result);
-	if (error < 0)
-		return error;
-	return result;
-}
-
-STATIC int
-xfs_vn_removexattr(
-	struct dentry	*dentry,
-	const char	*name)
-{
-	bhv_vnode_t	*vp = vn_from_inode(dentry->d_inode);
-	char		*attr = (char *)name;
-	attrnames_t	*namesp;
-	int		xflags = 0;
-
-	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
-	if (!namesp)
-		return -EOPNOTSUPP;
-	attr += namesp->attr_namelen;
-
-	xflags |= namesp->attr_flag;
-	return namesp->attr_remove(vp, attr, xflags);
-}
-
 STATIC long
 xfs_vn_fallocate(
 	struct inode	*inode,
@@ -874,10 +782,10 @@ const struct inode_operations xfs_inode_
 	.truncate		= xfs_vn_truncate,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= xfs_vn_setxattr,
-	.getxattr		= xfs_vn_getxattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
-	.removexattr		= xfs_vn_removexattr,
 	.fallocate		= xfs_vn_fallocate,
 };
 
@@ -894,10 +802,10 @@ const struct inode_operations xfs_dir_in
 	.permission		= xfs_vn_permission,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= xfs_vn_setxattr,
-	.getxattr		= xfs_vn_getxattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
-	.removexattr		= xfs_vn_removexattr,
 };
 
 const struct inode_operations xfs_symlink_inode_operations = {
@@ -907,8 +815,8 @@ const struct inode_operations xfs_symlin
 	.permission		= xfs_vn_permission,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= xfs_vn_setxattr,
-	.getxattr		= xfs_vn_getxattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
-	.removexattr		= xfs_vn_removexattr,
 };
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_xattr.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_xattr.c	2008-04-30 12:55:33.000000000 +0200
@@ -0,0 +1,266 @@
+/*
+ * Copyright (C) 2008 Christoph Hellwig.
+ *	Released under GPL v2.
+ */
+
+#include "xfs.h"
+#include "xfs_attr.h"
+#include "xfs_acl.h"
+#include "xfs_vnodeops.h"
+
+#include <linux/posix_acl_xattr.h>
+#include <linux/xattr.h>
+
+
+/*
+ * ACL handling.  Should eventually be moved into xfs_acl.c
+ */
+
+static int
+xfs_decode_acl(const char *name)
+{
+	if (strcmp(name, "posix_acl_access") == 0)
+		return _ACL_TYPE_ACCESS;
+	else if (strcmp(name, "posix_acl_default") == 0)
+		return _ACL_TYPE_DEFAULT;
+	return -EINVAL;
+}
+
+static int
+xfs_xattr_system_get(struct inode *inode, const char *name,
+		void *buffer, size_t size)
+{
+	int acl;
+
+	acl = xfs_decode_acl(name);
+	if (acl < 0)
+		return acl;
+
+	return xfs_acl_vget(inode, buffer, size, acl);
+}
+
+static int
+xfs_xattr_system_set(struct inode *inode, const char *name,
+		const void *value, size_t size, int flags)
+{
+	int error, acl;
+
+	acl = xfs_decode_acl(name);
+	if (acl < 0)
+		return acl;
+	if (flags & XATTR_CREATE)
+		return -EINVAL;
+
+	if (!value)
+		return xfs_acl_vremove(inode, acl);
+
+	error = xfs_acl_vset(inode, (void *)value, size, acl);
+	if (!error)
+		vn_revalidate(inode);
+	return error;
+}
+
+static struct xattr_handler xfs_xattr_system_handler = {
+	.prefix	= XATTR_SYSTEM_PREFIX,
+	.get	= xfs_xattr_system_get,
+	.set	= xfs_xattr_system_set,
+};
+
+
+/*
+ * Real xattr handling.  The only difference between the namespaces is
+ * a flag passed to the low-level attr code.
+ */
+
+static int
+__xfs_xattr_get(struct inode *inode, const char *name,
+		void *value, size_t size, int xflags)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	int error, asize = size;
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	/* Convert Linux syscall to XFS internal ATTR flags */
+	if (!size) {
+		xflags |= ATTR_KERNOVAL;
+		value = NULL;
+	}
+
+	error = -xfs_attr_get(ip, name, value, &asize, xflags);
+	if (error)
+		return error;
+	return asize;
+}
+
+static int
+__xfs_xattr_set(struct inode *inode, const char *name, const void *value,
+		size_t size, int flags, int xflags)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	/* Convert Linux syscall to XFS internal ATTR flags */
+	if (flags & XATTR_CREATE)
+		xflags |= ATTR_CREATE;
+	if (flags & XATTR_REPLACE)
+		xflags |= ATTR_REPLACE;
+
+	if (!value)
+		return -xfs_attr_remove(ip, name, xflags);
+	return -xfs_attr_set(ip, name, (void *)value, size, xflags);
+}
+
+static int
+xfs_xattr_user_get(struct inode *inode, const char *name,
+		void *value, size_t size)
+{
+	return __xfs_xattr_get(inode, name, value, size, 0);
+}
+
+static int
+xfs_xattr_user_set(struct inode *inode, const char *name,
+		const void *value, size_t size, int flags)
+{
+	return __xfs_xattr_set(inode, name, value, size, flags, 0);
+}
+
+struct attrnames attr_user = {
+	.attr_name	= "user.",
+	.attr_namelen	= sizeof("user.") - 1,
+};
+
+static struct xattr_handler xfs_xattr_user_handler = {
+	.prefix	= XATTR_USER_PREFIX,
+	.get	= xfs_xattr_user_get,
+	.set	= xfs_xattr_user_set,
+};
+
+
+static int
+xfs_xattr_trusted_get(struct inode *inode, const char *name,
+		void *value, size_t size)
+{
+	return __xfs_xattr_get(inode, name, value, size, ATTR_ROOT);
+}
+
+static int
+xfs_xattr_trusted_set(struct inode *inode, const char *name,
+		const void *value, size_t size, int flags)
+{
+	return __xfs_xattr_set(inode, name, value, size, flags, ATTR_ROOT);
+}
+
+struct attrnames attr_trusted = {
+	.attr_name	= "trusted.",
+	.attr_namelen	= sizeof("trusted.") - 1,
+};
+
+static struct xattr_handler xfs_xattr_trusted_handler = {
+	.prefix	= XATTR_TRUSTED_PREFIX,
+	.get	= xfs_xattr_trusted_get,
+	.set	= xfs_xattr_trusted_set,
+};
+
+
+static int
+xfs_xattr_secure_get(struct inode *inode, const char *name,
+		void *value, size_t size)
+{
+	return __xfs_xattr_get(inode, name, value, size, ATTR_SECURE);
+}
+
+static int
+xfs_xattr_secure_set(struct inode *inode, const char *name,
+		const void *value, size_t size, int flags)
+{
+	return __xfs_xattr_set(inode, name, value, size, flags, ATTR_SECURE);
+}
+
+struct attrnames attr_secure = {
+	.attr_name	= "security.",
+	.attr_namelen	= sizeof("security.") - 1,
+};
+
+static struct xattr_handler xfs_xattr_security_handler = {
+	.prefix	= XATTR_SECURITY_PREFIX,
+	.get	= xfs_xattr_secure_get,
+	.set	= xfs_xattr_secure_set,
+};
+
+
+struct xattr_handler *xfs_xattr_handlers[] = {
+	&xfs_xattr_user_handler,
+	&xfs_xattr_trusted_handler,
+	&xfs_xattr_security_handler,
+	&xfs_xattr_system_handler,
+	NULL
+};
+
+static int
+list_one_attr(const char *name, const size_t len, void *data,
+		size_t size, ssize_t *result)
+{
+	char *p = data + *result;
+
+	*result += len;
+	if (!size)
+		return 0;
+	if (*result > size)
+		return -ERANGE;
+
+	strcpy(p, name);
+	p += len;
+	return 0;
+}
+
+ssize_t
+xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
+{
+	struct inode		*inode = dentry->d_inode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	attrlist_cursor_kern_t	cursor = { 0 };
+	int			error, xflags;
+	ssize_t			result;
+
+	xflags = ATTR_KERNAMELS;
+	if (!size)
+		xflags |= ATTR_KERNOVAL;
+
+	if (capable(CAP_SYS_ADMIN))
+		xflags |= ATTR_KERNFULLS;
+	else
+		xflags |= ATTR_KERNORMALS;
+
+
+	/*
+	 * First read the regular on-disk attributes.
+	 */
+	result = -xfs_attr_list(ip, data, size, xflags, &cursor);
+	if (result < 0)
+		return result;
+
+	/*
+	 * Then add the two synthetic ACL attributes.
+	 */
+	if (xfs_acl_vhasacl_access(inode)) {
+		error = list_one_attr(POSIX_ACL_XATTR_ACCESS,
+				strlen(POSIX_ACL_XATTR_ACCESS) + 1,
+				data, size, &result);
+		if (error)
+			return error;
+	}
+
+	if (xfs_acl_vhasacl_default(inode)) {
+		error = list_one_attr(POSIX_ACL_XATTR_DEFAULT,
+				strlen(POSIX_ACL_XATTR_DEFAULT) + 1,
+				data, size, &result);
+		if (error)
+			return error;
+	}
+
+	return result;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2008-04-30 08:35:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2008-04-30 08:43:49.000000000 +0200
@@ -57,11 +57,6 @@
  * Provide the external interfaces to manage attribute lists.
  */
 
-#define ATTR_SYSCOUNT	2
-static struct attrnames posix_acl_access;
-static struct attrnames posix_acl_default;
-static struct attrnames *attr_system_names[ATTR_SYSCOUNT];
-
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -2435,270 +2430,3 @@ xfs_attr_trace_enter(int type, char *whe
 					 (void *)a14, (void *)a15);
 }
 #endif	/* XFS_ATTR_TRACE */
-
-
-/*========================================================================
- * System (pseudo) namespace attribute interface routines.
- *========================================================================*/
-
-STATIC int
-posix_acl_access_set(
-	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
-{
-	return xfs_acl_vset(vp, data, size, _ACL_TYPE_ACCESS);
-}
-
-STATIC int
-posix_acl_access_remove(
-	bhv_vnode_t *vp, char *name, int xflags)
-{
-	return xfs_acl_vremove(vp, _ACL_TYPE_ACCESS);
-}
-
-STATIC int
-posix_acl_access_get(
-	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
-{
-	return xfs_acl_vget(vp, data, size, _ACL_TYPE_ACCESS);
-}
-
-STATIC int
-posix_acl_access_exists(
-	bhv_vnode_t *vp)
-{
-	return xfs_acl_vhasacl_access(vp);
-}
-
-STATIC int
-posix_acl_default_set(
-	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
-{
-	return xfs_acl_vset(vp, data, size, _ACL_TYPE_DEFAULT);
-}
-
-STATIC int
-posix_acl_default_get(
-	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
-{
-	return xfs_acl_vget(vp, data, size, _ACL_TYPE_DEFAULT);
-}
-
-STATIC int
-posix_acl_default_remove(
-	bhv_vnode_t *vp, char *name, int xflags)
-{
-	return xfs_acl_vremove(vp, _ACL_TYPE_DEFAULT);
-}
-
-STATIC int
-posix_acl_default_exists(
-	bhv_vnode_t *vp)
-{
-	return xfs_acl_vhasacl_default(vp);
-}
-
-static struct attrnames posix_acl_access = {
-	.attr_name	= "posix_acl_access",
-	.attr_namelen	= sizeof("posix_acl_access") - 1,
-	.attr_get	= posix_acl_access_get,
-	.attr_set	= posix_acl_access_set,
-	.attr_remove	= posix_acl_access_remove,
-	.attr_exists	= posix_acl_access_exists,
-};
-
-static struct attrnames posix_acl_default = {
-	.attr_name	= "posix_acl_default",
-	.attr_namelen	= sizeof("posix_acl_default") - 1,
-	.attr_get	= posix_acl_default_get,
-	.attr_set	= posix_acl_default_set,
-	.attr_remove	= posix_acl_default_remove,
-	.attr_exists	= posix_acl_default_exists,
-};
-
-static struct attrnames *attr_system_names[] =
-	{ &posix_acl_access, &posix_acl_default };
-
-
-/*========================================================================
- * Namespace-prefix-style attribute name interface routines.
- *========================================================================*/
-
-STATIC int
-attr_generic_set(
-	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
-{
-	return -xfs_attr_set(xfs_vtoi(vp), name, data, size, xflags);
-}
-
-STATIC int
-attr_generic_get(
-	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
-{
-	int	error, asize = size;
-
-	error = xfs_attr_get(xfs_vtoi(vp), name, data, &asize, xflags);
-	if (!error)
-		return asize;
-	return -error;
-}
-
-STATIC int
-attr_generic_remove(
-	bhv_vnode_t *vp, char *name, int xflags)
-{
-	return -xfs_attr_remove(xfs_vtoi(vp), name, xflags);
-}
-
-STATIC int
-attr_generic_listadd(
-	attrnames_t		*prefix,
-	attrnames_t		*namesp,
-	void			*data,
-	size_t			size,
-	ssize_t			*result)
-{
-	char			*p = data + *result;
-
-	*result += prefix->attr_namelen;
-	*result += namesp->attr_namelen + 1;
-	if (!size)
-		return 0;
-	if (*result > size)
-		return -ERANGE;
-	strcpy(p, prefix->attr_name);
-	p += prefix->attr_namelen;
-	strcpy(p, namesp->attr_name);
-	p += namesp->attr_namelen + 1;
-	return 0;
-}
-
-STATIC int
-attr_system_list(
-	bhv_vnode_t		*vp,
-	void			*data,
-	size_t			size,
-	ssize_t			*result)
-{
-	attrnames_t		*namesp;
-	int			i, error = 0;
-
-	for (i = 0; i < ATTR_SYSCOUNT; i++) {
-		namesp = attr_system_names[i];
-		if (!namesp->attr_exists || !namesp->attr_exists(vp))
-			continue;
-		error = attr_generic_listadd(&attr_system, namesp,
-						data, size, result);
-		if (error)
-			break;
-	}
-	return error;
-}
-
-int
-attr_generic_list(
-	bhv_vnode_t *vp, void *data, size_t size, int xflags, ssize_t *result)
-{
-	attrlist_cursor_kern_t	cursor = { 0 };
-	int			error;
-
-	error = xfs_attr_list(xfs_vtoi(vp), data, size, xflags, &cursor);
-	if (error > 0)
-		return -error;
-	*result = -error;
-	return attr_system_list(vp, data, size, result);
-}
-
-attrnames_t *
-attr_lookup_namespace(
-	char			*name,
-	struct attrnames	**names,
-	int			nnames)
-{
-	int			i;
-
-	for (i = 0; i < nnames; i++)
-		if (!strncmp(name, names[i]->attr_name, names[i]->attr_namelen))
-			return names[i];
-	return NULL;
-}
-
-STATIC int
-attr_system_set(
-	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
-{
-	attrnames_t	*namesp;
-	int		error;
-
-	if (xflags & ATTR_CREATE)
-		return -EINVAL;
-
-	namesp = attr_lookup_namespace(name, attr_system_names, ATTR_SYSCOUNT);
-	if (!namesp)
-		return -EOPNOTSUPP;
-	error = namesp->attr_set(vp, name, data, size, xflags);
-	if (!error)
-		error = vn_revalidate(vp);
-	return error;
-}
-
-STATIC int
-attr_system_get(
-	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
-{
-	attrnames_t	*namesp;
-
-	namesp = attr_lookup_namespace(name, attr_system_names, ATTR_SYSCOUNT);
-	if (!namesp)
-		return -EOPNOTSUPP;
-	return namesp->attr_get(vp, name, data, size, xflags);
-}
-
-STATIC int
-attr_system_remove(
-	bhv_vnode_t *vp, char *name, int xflags)
-{
-	attrnames_t	*namesp;
-
-	namesp = attr_lookup_namespace(name, attr_system_names, ATTR_SYSCOUNT);
-	if (!namesp)
-		return -EOPNOTSUPP;
-	return namesp->attr_remove(vp, name, xflags);
-}
-
-struct attrnames attr_system = {
-	.attr_name	= "system.",
-	.attr_namelen	= sizeof("system.") - 1,
-	.attr_flag	= ATTR_SYSTEM,
-	.attr_get	= attr_system_get,
-	.attr_set	= attr_system_set,
-	.attr_remove	= attr_system_remove,
-};
-
-struct attrnames attr_trusted = {
-	.attr_name	= "trusted.",
-	.attr_namelen	= sizeof("trusted.") - 1,
-	.attr_flag	= ATTR_ROOT,
-	.attr_get	= attr_generic_get,
-	.attr_set	= attr_generic_set,
-	.attr_remove	= attr_generic_remove,
-};
-
-struct attrnames attr_secure = {
-	.attr_name	= "security.",
-	.attr_namelen	= sizeof("security.") - 1,
-	.attr_flag	= ATTR_SECURE,
-	.attr_get	= attr_generic_get,
-	.attr_set	= attr_generic_set,
-	.attr_remove	= attr_generic_remove,
-};
-
-struct attrnames attr_user = {
-	.attr_name	= "user.",
-	.attr_namelen	= sizeof("user.") - 1,
-	.attr_get	= attr_generic_get,
-	.attr_set	= attr_generic_set,
-	.attr_remove	= attr_generic_remove,
-};
-
-struct attrnames *attr_namespaces[] =
-	{ &attr_system, &attr_trusted, &attr_secure, &attr_user };
Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2008-04-30 08:35:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2008-04-30 08:43:49.000000000 +0200
@@ -38,30 +38,14 @@
 struct cred;
 struct xfs_attr_list_context;
 
-typedef int (*attrset_t)(bhv_vnode_t *, char *, void *, size_t, int);
-typedef int (*attrget_t)(bhv_vnode_t *, char *, void *, size_t, int);
-typedef int (*attrremove_t)(bhv_vnode_t *, char *, int);
-typedef int (*attrexists_t)(bhv_vnode_t *);
-
 typedef struct attrnames {
 	char *		attr_name;
 	unsigned int	attr_namelen;
-	unsigned int	attr_flag;
-	attrget_t	attr_get;
-	attrset_t	attr_set;
-	attrremove_t	attr_remove;
-	attrexists_t	attr_exists;
 } attrnames_t;
 
-#define ATTR_NAMECOUNT	4
 extern struct attrnames attr_user;
 extern struct attrnames attr_secure;
-extern struct attrnames attr_system;
 extern struct attrnames attr_trusted;
-extern struct attrnames *attr_namespaces[ATTR_NAMECOUNT];
-
-extern attrnames_t *attr_lookup_namespace(char *, attrnames_t **, int);
-extern int attr_generic_list(bhv_vnode_t *, void *, size_t, int, ssize_t *);
 
 #define ATTR_DONTFOLLOW	0x0001	/* -- unused, from IRIX -- */
 #define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
@@ -69,7 +53,6 @@ extern int attr_generic_list(bhv_vnode_t
 #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
-#define ATTR_SYSTEM	0x0100	/* use attrs in system (pseudo) namespace */
 
 #define ATTR_KERNACCESS	0x0400	/* [kernel] iaccess, inode held io-locked */
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.h	2008-04-30 08:24:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h	2008-04-30 08:43:49.000000000 +0200
@@ -26,6 +26,7 @@ extern const struct file_operations xfs_
 extern const struct file_operations xfs_dir_file_operations;
 extern const struct file_operations xfs_invis_file_operations;
 
+extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
 struct xfs_inode;
 extern void xfs_ichgtime(struct xfs_inode *, int);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-04-30 08:24:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-04-30 08:43:49.000000000 +0200
@@ -1328,6 +1328,7 @@ xfs_fs_fill_super(
 		goto fail_vfsop;
 
 	sb_min_blocksize(sb, BBSIZE);
+	sb->s_xattr = xfs_xattr_handlers;
 	sb->s_export_op = &xfs_export_operations;
 	sb->s_qcop = &xfs_quotactl_operations;
 	sb->s_op = &xfs_super_operations;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2008-04-30 08:24:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h	2008-04-30 08:43:49.000000000 +0200
@@ -84,6 +84,7 @@ extern void xfs_blkdev_put(struct block_
 extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 
 extern const struct export_operations xfs_export_operations;
+extern struct xattr_handler *xfs_xattr_handlers[];
 
 #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
 
