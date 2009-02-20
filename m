Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1KKprTx200192 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 14:51:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37EC4197AD4C
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 12:51:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id o3845HKd9eK71jQs for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 12:51:21 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LacL7-00024c-Ok
	for xfs@oss.sgi.com; Fri, 20 Feb 2009 20:51:17 +0000
Date: Fri, 20 Feb 2009 15:51:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs: use generic Posix ACL code
Message-ID: <20090220205117.GA7943@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch rips out the XFS ACL handling code and uses the generic
fs/posix_acl.c code instead.  The ondisk format is of course left
unchanged.

This also introduces the same ACL caching all other Linux filesystems do
by adding pointers to the acl and default acl in struct xfs_inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_acl.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs/fs/xfs/linux-2.6/xfs_acl.c	2009-02-20 13:50:12.861950530 +0100
@@ -0,0 +1,510 @@
+/*
+ * Copyright (C) 2008 Christoph Hellwig.
+ *	Released under GPL v2.
+ */
+#include "xfs.h"
+#include "xfs_acl.h"
+#include "xfs_attr.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_vnodeops.h"
+#include <linux/xattr.h>
+#include <linux/posix_acl_xattr.h>
+
+
+#define XFS_ACL_NOT_CACHED	((void *)-1)
+
+/*
+ * Locking scheme:
+ *  - all ACL updates are protected by inode->i_mutex, which is taken before
+ *    calling into this file.
+ *  - access and updates to the ip->i_acl and ip->i_default_acl pointers are
+ *    protected by inode->i_lock.
+ */
+
+static struct posix_acl *
+xfs_acl_from_disk(struct xfs_acl *aclp)
+{
+	struct posix_acl_entry *acl_e;
+	struct posix_acl *acl;
+	struct xfs_acl_entry *ace;
+	int count, i;
+
+	count = be32_to_cpu(aclp->acl_cnt);
+
+	acl = posix_acl_alloc(count, GFP_KERNEL);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < count; i++) {
+		acl_e = &acl->a_entries[i];
+		ace = &aclp->acl_entry[i];
+
+		/*
+		 * The tag is 32 bits on disk and 16 bits in core.
+		 *
+		 * Because every access to it goes through the core
+		 * format first this is not a problem.
+		 */
+		acl_e->e_tag = be32_to_cpu(ace->ae_tag);
+		acl_e->e_perm = be16_to_cpu(ace->ae_perm);
+
+		switch (acl_e->e_tag) {
+		case ACL_USER:
+		case ACL_GROUP:
+			acl_e->e_id = be32_to_cpu(ace->ae_id);
+			break;
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			acl_e->e_id = ACL_UNDEFINED_ID;
+			break;
+		default:
+			goto fail;
+		}
+	}
+	return acl;
+
+fail:
+	posix_acl_release(acl);
+	return ERR_PTR(-EINVAL);
+}
+
+static void
+xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
+{
+	const struct posix_acl_entry *acl_e;
+	struct xfs_acl_entry *ace;
+	int i;
+
+	aclp->acl_cnt = cpu_to_be32(acl->a_count);
+	for (i = 0; i < acl->a_count; i++) {
+		ace = &aclp->acl_entry[i];
+		acl_e = &acl->a_entries[i];
+
+		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
+		ace->ae_id = cpu_to_be32(acl_e->e_id);
+		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
+	}
+}
+
+/*
+ * Update the cached ACL pointer in the inode.
+ *
+ * Because we don't hold any locks while reading/writing the attribute
+ * from/to disk another thread could have raced and updated the cached
+ * ACL value before us. In that case we release the previous cached value
+ * and update it with our new value.
+ */
+static void
+xfs_update_cached_acl(struct inode *inode, struct posix_acl **p_acl,
+		struct posix_acl *acl)
+{
+	spin_lock(&inode->i_lock);
+	if (*p_acl && *p_acl != XFS_ACL_NOT_CACHED)
+		posix_acl_release(*p_acl);
+	*p_acl = posix_acl_dup(acl);
+	spin_unlock(&inode->i_lock);
+}
+
+struct posix_acl *
+xfs_get_acl(struct inode *inode, int type)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct posix_acl *acl = NULL, **p_acl;
+	struct xfs_acl *xfs_acl;
+	int len = sizeof(struct xfs_acl);
+	char *ea_name;
+	int error;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		ea_name = SGI_ACL_FILE;
+		p_acl = &ip->i_acl;
+		break;
+	case ACL_TYPE_DEFAULT:
+		ea_name = SGI_ACL_DEFAULT;
+		p_acl = &ip->i_default_acl;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	spin_lock(&inode->i_lock);
+	if (*p_acl != XFS_ACL_NOT_CACHED)
+		acl = posix_acl_dup(*p_acl);
+	spin_unlock(&inode->i_lock);
+
+	/*
+	 * If we have a cached ACLs value just return it, not need to
+	 * go out to the disk.
+	 */
+	if (acl)
+		return acl;
+
+	xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
+	if (!xfs_acl)
+		return ERR_PTR(-ENOMEM);
+
+	error = -xfs_attr_get(ip, ea_name, (char *)xfs_acl, &len, ATTR_ROOT);
+	if (error) {
+		/*
+		 * If the attribute doesn't exist make sure we have a negative
+		 * cache entry, for any other error assume it is transient and
+		 * leave the cache entry as XFS_ACL_NOT_CACHED.
+		 */
+		if (error == -ENOATTR) {
+			acl = NULL;
+			goto out_update_cache;
+		}
+		goto out;
+	}
+
+	acl = xfs_acl_from_disk(xfs_acl);
+	if (IS_ERR(acl))
+		goto out;
+
+ out_update_cache:
+	xfs_update_cached_acl(inode, p_acl, acl);
+ out:
+	kfree(xfs_acl);
+	return acl;
+}
+
+static int
+xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct posix_acl **p_acl;
+	char *ea_name;
+	int error;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		ea_name = SGI_ACL_FILE;
+		p_acl = &ip->i_acl;
+		break;
+	case ACL_TYPE_DEFAULT:
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EACCES : 0;
+		ea_name = SGI_ACL_DEFAULT;
+		p_acl = &ip->i_default_acl;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (acl) {
+		struct xfs_acl *xfs_acl;
+		int len;
+
+		xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
+		if (!xfs_acl)
+			return -ENOMEM;
+
+		xfs_acl_to_disk(xfs_acl, acl);
+		len = sizeof(struct xfs_acl) -
+			(sizeof(struct xfs_acl_entry) *
+			 (XFS_ACL_MAX_ENTRIES - acl->a_count));
+
+		error = -xfs_attr_set(ip, ea_name, (char *)xfs_acl,
+				len, ATTR_ROOT);
+
+		kfree(xfs_acl);
+	} else {
+		/*
+		 * A NULL ACL argument means we want to remove the ACL.
+		 */
+		error = -xfs_attr_remove(ip, ea_name, ATTR_ROOT);
+
+		/*
+		 * If the attribute didn't exist to start with that's fine.
+		 */
+		if (error == -ENOATTR)
+			error = 0;
+	}
+
+	if (!error)
+		xfs_update_cached_acl(inode, p_acl, acl);
+	return error;
+}
+
+int
+xfs_check_acl(struct inode *inode, int mask)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct posix_acl *acl;
+	int error = -EAGAIN;
+
+	xfs_itrace_entry(ip);
+
+	/*
+	 * If there is no attribute fork no ACL exists on this inode and
+	 * we can skip the whole exercise.
+	 */
+	if (!XFS_IFORK_Q(ip))
+		return -EAGAIN;
+
+	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl) {
+		error = posix_acl_permission(inode, acl, mask);
+		posix_acl_release(acl);
+	}
+
+	return error;
+}
+
+static int
+xfs_set_mode(struct inode *inode, mode_t mode)
+{
+	int error = 0;
+
+	if (mode != inode->i_mode) {
+		struct iattr iattr;
+
+		iattr.ia_valid = ATTR_MODE;
+		iattr.ia_mode = mode;
+
+		error = -xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
+	}
+
+	return error;
+}
+
+static int
+xfs_acl_exists(struct inode *inode, char *name)
+{
+	int len = sizeof(struct xfs_acl);
+
+	return (xfs_attr_get(XFS_I(inode), name, NULL, &len,
+			    ATTR_ROOT|ATTR_KERNOVAL) == 0);
+}
+
+int
+posix_acl_access_exists(struct inode *inode)
+{
+	return xfs_acl_exists(inode, SGI_ACL_FILE);
+}
+
+int
+posix_acl_default_exists(struct inode *inode)
+{
+	if (!S_ISDIR(inode->i_mode))
+		return 0;
+	return xfs_acl_exists(inode, SGI_ACL_DEFAULT);
+}
+
+/*
+ * No need for i_mutex because the inode is not yet exposed to the VFS.
+ */
+int
+xfs_inherit_acl(struct inode *inode, struct posix_acl *default_acl)
+{
+	struct posix_acl *clone;
+	mode_t mode;
+	int error = 0, inherit = 0;
+
+	if (S_ISDIR(inode->i_mode)) {
+		error = xfs_set_acl(inode, ACL_TYPE_DEFAULT, default_acl);
+		if (error)
+			return error;
+	}
+
+	clone = posix_acl_clone(default_acl, GFP_KERNEL);
+	if (!clone)
+		return -ENOMEM;
+
+	mode = inode->i_mode;
+	error = posix_acl_create_masq(clone, &mode);
+	if (error < 0)
+		goto out_release_clone;
+
+	/*
+	 * If posix_acl_create_masq returns a positive value we need to
+	 * inherit a permission that can't be represented using the Unix
+	 * mode bits and we actually need to set an ACL.
+	 */
+	if (error > 0)
+		inherit = 1;
+
+	error = xfs_set_mode(inode, mode);
+	if (error)
+		goto out_release_clone;
+
+	if (inherit)
+		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, clone);
+
+ out_release_clone:
+	posix_acl_release(clone);
+	return error;
+}
+
+int
+xfs_acl_chmod(struct inode *inode)
+{
+	struct posix_acl *acl, *clone;
+	int error;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+
+	clone = posix_acl_clone(acl, GFP_KERNEL);
+	posix_acl_release(acl);
+	if (!clone)
+		return -ENOMEM;
+
+	error = posix_acl_chmod_masq(clone, inode->i_mode);
+	if (!error)
+		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, clone);
+
+	posix_acl_release(clone);
+	return error;
+}
+
+void
+xfs_inode_init_acls(struct xfs_inode *ip)
+{
+	/*
+	 * No need for locking, inode is not live yet.
+	 */
+	ip->i_acl = XFS_ACL_NOT_CACHED;
+	ip->i_default_acl = XFS_ACL_NOT_CACHED;
+}
+
+void
+xfs_inode_clear_acls(struct xfs_inode *ip)
+{
+	/*
+	 * No need for locking here, the inode is not live anymore
+	 * and just about to be freed.
+	 */
+	if (ip->i_acl != XFS_ACL_NOT_CACHED)
+		posix_acl_release(ip->i_acl);
+	if (ip->i_default_acl != XFS_ACL_NOT_CACHED)
+		posix_acl_release(ip->i_default_acl);
+}
+
+
+/*
+ * System xattr handlers.
+ *
+ * Currently Posix ACLs are the only system namespace extended attribute
+ * handlers supported by XFS, so we just implement the handlers here.
+ * If we ever support other system extended attributes this will need
+ * some refactoring.
+ */
+
+static int
+xfs_decode_acl(const char *name)
+{
+	if (strcmp(name, "posix_acl_access") == 0)
+		return ACL_TYPE_ACCESS;
+	else if (strcmp(name, "posix_acl_default") == 0)
+		return ACL_TYPE_DEFAULT;
+	return -EINVAL;
+}
+
+static int
+xfs_xattr_system_get(struct inode *inode, const char *name,
+		void *value, size_t size)
+{
+	struct posix_acl *acl;
+	int type, error;
+
+	type = xfs_decode_acl(name);
+	if (type < 0)
+		return type;
+
+	acl = xfs_get_acl(inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+
+	error = posix_acl_to_xattr(acl, value, size);
+	posix_acl_release(acl);
+
+	return error;
+}
+
+static int
+xfs_xattr_system_set(struct inode *inode, const char *name,
+		const void *value, size_t size, int flags)
+{
+	struct posix_acl *acl = NULL;
+	int error = 0, type;
+
+	type = xfs_decode_acl(name);
+	if (type < 0)
+		return type;
+	if (flags & XATTR_CREATE)
+		return -EINVAL;
+	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
+		return value ? -EACCES : 0;
+	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
+		return -EPERM;
+
+	if (!value)
+		goto set_acl;
+
+	acl = posix_acl_from_xattr(value, size);
+	if (!acl) {
+		 /*
+		  * acl_set_file(3) may request that we set default ACLs with
+		  * zero length -- defend (gracefully) against that here.
+		  */
+		goto out;
+	}
+	if (IS_ERR(acl)) {
+		error = PTR_ERR(acl);
+		goto out;
+	}
+
+	error = posix_acl_valid(acl);
+	if (error)
+		goto out_release;
+
+	error = -EINVAL;
+	if (acl->a_count > XFS_ACL_MAX_ENTRIES)
+		goto out_release;
+
+	if (type == ACL_TYPE_ACCESS) {
+		mode_t mode = inode->i_mode;
+		error = posix_acl_equiv_mode(acl, &mode);
+
+		if (error <= 0) {
+			posix_acl_release(acl);
+			acl = NULL;
+
+			if (error < 0)
+				return error;
+		}
+
+		error = xfs_set_mode(inode, mode);
+		if (error)
+			goto out_release;
+	}
+
+ set_acl:
+	error = xfs_set_acl(inode, type, acl);
+ out_release:
+	posix_acl_release(acl);
+ out:
+	return error;
+}
+
+struct xattr_handler xfs_xattr_system_handler = {
+	.prefix	= XATTR_SYSTEM_PREFIX,
+	.get	= xfs_xattr_system_get,
+	.set	= xfs_xattr_system_set,
+};
Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2009-02-09 08:38:02.335944473 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2009-02-20 13:52:02.936944827 +0100
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_acl.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
@@ -51,6 +52,7 @@
 #include <linux/capability.h>
 #include <linux/xattr.h>
 #include <linux/namei.h>
+#include <linux/posix_acl.h>
 #include <linux/security.h>
 #include <linux/falloc.h>
 #include <linux/fiemap.h>
@@ -202,9 +204,8 @@ xfs_vn_mknod(
 {
 	struct inode	*inode;
 	struct xfs_inode *ip = NULL;
-	xfs_acl_t	*default_acl = NULL;
+	struct posix_acl *default_acl = NULL;
 	struct xfs_name	name;
-	int (*test_default_acl)(struct inode *) = _ACL_DEFAULT_EXISTS;
 	int		error;
 
 	/*
@@ -219,18 +220,14 @@ xfs_vn_mknod(
 		rdev = 0;
 	}
 
-	if (test_default_acl && test_default_acl(dir)) {
-		if (!_ACL_ALLOC(default_acl)) {
-			return -ENOMEM;
-		}
-		if (!_ACL_GET_DEFAULT(dir, default_acl)) {
-			_ACL_FREE(default_acl);
-			default_acl = NULL;
-		}
-	}
+	if (IS_POSIXACL(dir)) {
+		default_acl = xfs_get_acl(dir, ACL_TYPE_DEFAULT);
+		if (IS_ERR(default_acl))
+			return -PTR_ERR(default_acl);
 
-	if (IS_POSIXACL(dir) && !default_acl)
-		mode &= ~current->fs->umask;
+		if (!default_acl)
+			mode &= ~current->fs->umask;
+	}
 
 	xfs_dentry_to_name(&name, dentry);
 	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip, NULL);
@@ -244,10 +241,10 @@ xfs_vn_mknod(
 		goto out_cleanup_inode;
 
 	if (default_acl) {
-		error = _ACL_INHERIT(inode, mode, default_acl);
+		error = -xfs_inherit_acl(inode, default_acl);
 		if (unlikely(error))
 			goto out_cleanup_inode;
-		_ACL_FREE(default_acl);
+		posix_acl_release(default_acl);
 	}
 
 
@@ -257,8 +254,7 @@ xfs_vn_mknod(
  out_cleanup_inode:
 	xfs_cleanup_inode(dir, inode, dentry);
  out_free_acl:
-	if (default_acl)
-		_ACL_FREE(default_acl);
+	posix_acl_release(default_acl);
 	return -error;
 }
 
@@ -488,26 +484,6 @@ xfs_vn_put_link(
 		kfree(s);
 }
 
-#ifdef CONFIG_XFS_POSIX_ACL
-STATIC int
-xfs_check_acl(
-	struct inode		*inode,
-	int			mask)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	int			error;
-
-	xfs_itrace_entry(ip);
-
-	if (XFS_IFORK_Q(ip)) {
-		error = xfs_acl_iaccess(ip, mask, NULL);
-		if (error != -1)
-			return -error;
-	}
-
-	return -EAGAIN;
-}
-
 STATIC int
 xfs_vn_permission(
 	struct inode		*inode,
@@ -515,9 +491,6 @@ xfs_vn_permission(
 {
 	return generic_permission(inode, mask, xfs_check_acl);
 }
-#else
-#define xfs_vn_permission NULL
-#endif
 
 STATIC int
 xfs_vn_getattr(
Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2009-02-20 11:59:36.563099502 +0100
+++ xfs/fs/xfs/Makefile	2009-02-20 13:09:52.821946386 +0100
@@ -40,7 +40,7 @@ xfs-$(CONFIG_PROC_FS)		+= quota/xfs_qm_s
 endif
 
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
-xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
+xfs-$(CONFIG_XFS_POSIX_ACL)	+= $(XFS_LINUX)/xfs_acl.o
 xfs-$(CONFIG_PROC_FS)		+= $(XFS_LINUX)/xfs_stats.o
 xfs-$(CONFIG_SYSCTL)		+= $(XFS_LINUX)/xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= $(XFS_LINUX)/xfs_ioctl32.o
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2009-02-15 19:40:08.647943507 +0100
+++ xfs/fs/xfs/xfs_inode.h	2009-02-20 13:14:57.825071856 +0100
@@ -18,6 +18,7 @@
 #ifndef	__XFS_INODE_H__
 #define	__XFS_INODE_H__
 
+struct posix_acl;
 struct xfs_dinode;
 struct xfs_inode;
 
@@ -272,6 +273,11 @@ typedef struct xfs_inode {
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
 
+#ifdef CONFIG_XFS_POSIX_ACL
+	struct posix_acl	*i_acl;
+	struct posix_acl	*i_default_acl;
+#endif
+
 	/* Trace buffers per inode. */
 #ifdef XFS_INODE_TRACE
 	struct ktrace		*i_trace;	/* general inode trace */
Index: xfs/fs/xfs/linux-2.6/xfs_xattr.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_xattr.c	2009-02-08 21:51:06.544981316 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_xattr.c	2009-02-20 13:09:52.850944000 +0100
@@ -29,67 +29,6 @@
 #include <linux/xattr.h>
 
 
-/*
- * ACL handling.  Should eventually be moved into xfs_acl.c
- */
-
-static int
-xfs_decode_acl(const char *name)
-{
-	if (strcmp(name, "posix_acl_access") == 0)
-		return _ACL_TYPE_ACCESS;
-	else if (strcmp(name, "posix_acl_default") == 0)
-		return _ACL_TYPE_DEFAULT;
-	return -EINVAL;
-}
-
-/*
- * Get system extended attributes which at the moment only
- * includes Posix ACLs.
- */
-static int
-xfs_xattr_system_get(struct inode *inode, const char *name,
-		void *buffer, size_t size)
-{
-	int acl;
-
-	acl = xfs_decode_acl(name);
-	if (acl < 0)
-		return acl;
-
-	return xfs_acl_vget(inode, buffer, size, acl);
-}
-
-static int
-xfs_xattr_system_set(struct inode *inode, const char *name,
-		const void *value, size_t size, int flags)
-{
-	int acl;
-
-	acl = xfs_decode_acl(name);
-	if (acl < 0)
-		return acl;
-	if (flags & XATTR_CREATE)
-		return -EINVAL;
-
-	if (!value)
-		return xfs_acl_vremove(inode, acl);
-
-	return xfs_acl_vset(inode, (void *)value, size, acl);
-}
-
-static struct xattr_handler xfs_xattr_system_handler = {
-	.prefix	= XATTR_SYSTEM_PREFIX,
-	.get	= xfs_xattr_system_get,
-	.set	= xfs_xattr_system_set,
-};
-
-
-/*
- * Real xattr handling.  The only difference between the namespaces is
- * a flag passed to the low-level attr code.
- */
-
 static int
 __xfs_xattr_get(struct inode *inode, const char *name,
 		void *value, size_t size, int xflags)
@@ -199,7 +138,9 @@ struct xattr_handler *xfs_xattr_handlers
 	&xfs_xattr_user_handler,
 	&xfs_xattr_trusted_handler,
 	&xfs_xattr_security_handler,
+#ifdef CONFIG_XFS_POSIX_ACL
 	&xfs_xattr_system_handler,
+#endif
 	NULL
 };
 
@@ -310,7 +251,7 @@ xfs_vn_listxattr(struct dentry *dentry, 
 	/*
 	 * Then add the two synthetic ACL attributes.
 	 */
-	if (xfs_acl_vhasacl_access(inode)) {
+	if (posix_acl_access_exists(inode)) {
 		error = list_one_attr(POSIX_ACL_XATTR_ACCESS,
 				strlen(POSIX_ACL_XATTR_ACCESS) + 1,
 				data, size, &context.count);
@@ -318,7 +259,7 @@ xfs_vn_listxattr(struct dentry *dentry, 
 			return error;
 	}
 
-	if (xfs_acl_vhasacl_default(inode)) {
+	if (posix_acl_default_exists(inode)) {
 		error = list_one_attr(POSIX_ACL_XATTR_DEFAULT,
 				strlen(POSIX_ACL_XATTR_DEFAULT) + 1,
 				data, size, &context.count);
Index: xfs/fs/xfs/Kconfig
===================================================================
--- xfs.orig/fs/xfs/Kconfig	2009-02-15 19:40:08.542944302 +0100
+++ xfs/fs/xfs/Kconfig	2009-02-20 13:09:52.850944000 +0100
@@ -39,6 +39,7 @@ config XFS_QUOTA
 config XFS_POSIX_ACL
 	bool "XFS POSIX ACL support"
 	depends on XFS_FS
+	select FS_POSIX_ACL
 	help
 	  POSIX Access Control Lists (ACLs) support permissions for users and
 	  groups beyond the owner/group/world scheme.
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-02-20 12:00:57.312071616 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-02-20 13:20:44.982070284 +0100
@@ -43,7 +43,6 @@
 #include "xfs_itable.h"
 #include "xfs_fsops.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
@@ -1742,18 +1741,8 @@ xfs_init_zones(void)
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
 
-#ifdef CONFIG_XFS_POSIX_ACL
-	xfs_acl_zone = kmem_zone_init(sizeof(xfs_acl_t), "xfs_acl");
-	if (!xfs_acl_zone)
-		goto out_destroy_ili_zone;
-#endif
-
 	return 0;
 
-#ifdef CONFIG_XFS_POSIX_ACL
- out_destroy_ili_zone:
-#endif
-	kmem_zone_destroy(xfs_ili_zone);
  out_destroy_inode_zone:
 	kmem_zone_destroy(xfs_inode_zone);
  out_destroy_efi_zone:
@@ -1787,9 +1776,6 @@ xfs_init_zones(void)
 STATIC void
 xfs_destroy_zones(void)
 {
-#ifdef CONFIG_XFS_POSIX_ACL
-	kmem_zone_destroy(xfs_acl_zone);
-#endif
 	kmem_zone_destroy(xfs_ili_zone);
 	kmem_zone_destroy(xfs_inode_zone);
 	kmem_zone_destroy(xfs_efi_zone);
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2009-02-20 11:59:36.374069305 +0100
+++ xfs/fs/xfs/xfs_attr.c	2009-02-20 13:09:52.869944253 +0100
@@ -45,7 +45,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
-#include "xfs_acl.h"
 #include "xfs_rw.h"
 #include "xfs_vnodeops.h"
 
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2009-02-20 11:59:36.376069211 +0100
+++ xfs/fs/xfs/xfs_iomap.c	2009-02-20 13:09:52.871944927 +0100
@@ -42,7 +42,6 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2009-02-08 21:51:06.602944002 +0100
+++ xfs/fs/xfs/xfs_rw.c	2009-02-20 13:09:52.872943378 +0100
@@ -41,7 +41,6 @@
 #include "xfs_ialloc.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
-#include "xfs_acl.h"
 #include "xfs_error.h"
 #include "xfs_buf_item.h"
 #include "xfs_rw.h"
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2009-02-20 11:59:36.371073114 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2009-02-20 13:09:52.880944186 +0100
@@ -40,7 +40,6 @@
 #include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_buf_item.h"
Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-02-08 21:51:06.531068863 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2009-02-20 13:09:52.881944174 +0100
@@ -42,7 +42,6 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_inode_item.h"
 #include "xfs_buf_item.h"
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2009-02-20 11:59:36.373069387 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.c	2009-02-20 13:09:52.883944009 +0100
@@ -42,7 +42,6 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2009-02-09 08:36:21.637944200 +0100
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2009-02-20 13:09:52.884944136 +0100
@@ -42,7 +42,6 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2009-02-20 11:59:36.544069567 +0100
+++ xfs/fs/xfs/quota/xfs_qm.c	2009-02-20 13:09:52.886944181 +0100
@@ -42,7 +42,6 @@
 #include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
Index: xfs/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2009-02-20 12:05:40.567944505 +0100
+++ xfs/fs/xfs/quota/xfs_qm_bhv.c	2009-02-20 13:09:52.887944239 +0100
@@ -42,7 +42,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
Index: xfs/fs/xfs/quota/xfs_qm_stats.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_stats.c	2009-02-08 21:51:06.547944472 +0100
+++ xfs/fs/xfs/quota/xfs_qm_stats.c	2009-02-20 13:09:52.887944239 +0100
@@ -42,7 +42,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-02-09 08:47:34.232068717 +0100
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2009-02-20 13:09:52.891944678 +0100
@@ -45,7 +45,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2009-02-20 11:59:35.920068940 +0100
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2009-02-20 13:09:52.894944222 +0100
@@ -42,7 +42,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-02-20 11:59:36.377068849 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-02-20 13:09:52.896943987 +0100
@@ -42,6 +42,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_rw.h"
 #include "xfs_error.h"
@@ -466,8 +467,20 @@ xfs_setattr(
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 
-	if (code) {
+	if (code)
 		return code;
+
+	/*
+	 * XXX(hch): Updating the ACL entries is not atomic vs the i_mode
+	 * 	     update.  We could avoid this with linked transactions
+	 * 	     and an passing down the transaction pointer all the
+	 * 	     way to attr_set.  No previous user of the generic
+	 * 	     Posix ACL code seems to care about this issue either.
+	 */
+	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
+		code = xfs_acl_chmod(inode);
+		if (code)
+			return code;
 	}
 
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE) &&
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2009-02-09 08:38:02.340944063 +0100
+++ xfs/fs/xfs/xfs_vnodeops.h	2009-02-20 13:09:52.900943868 +0100
@@ -18,6 +18,7 @@ int xfs_setattr(struct xfs_inode *ip, st
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
 #define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if operation would block */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
+#define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
 
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_fsync(struct xfs_inode *ip);
Index: xfs/fs/xfs/xfs_acl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_acl.c	2009-02-08 21:51:06.551972918 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,874 +0,0 @@
-/*
- * Copyright (c) 2001-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_bit.h"
-#include "xfs_inum.h"
-#include "xfs_ag.h"
-#include "xfs_dir2.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_acl.h"
-#include "xfs_attr.h"
-#include "xfs_vnodeops.h"
-
-#include <linux/capability.h>
-#include <linux/posix_acl_xattr.h>
-
-STATIC int	xfs_acl_setmode(struct inode *, xfs_acl_t *, int *);
-STATIC void     xfs_acl_filter_mode(mode_t, xfs_acl_t *);
-STATIC void	xfs_acl_get_endian(xfs_acl_t *);
-STATIC int	xfs_acl_access(uid_t, gid_t, xfs_acl_t *, mode_t, cred_t *);
-STATIC int	xfs_acl_invalid(xfs_acl_t *);
-STATIC void	xfs_acl_sync_mode(mode_t, xfs_acl_t *);
-STATIC void	xfs_acl_get_attr(struct inode *, xfs_acl_t *, int, int, int *);
-STATIC void	xfs_acl_set_attr(struct inode *, xfs_acl_t *, int, int *);
-STATIC int	xfs_acl_allow_set(struct inode *, int);
-
-kmem_zone_t *xfs_acl_zone;
-
-
-/*
- * Test for existence of access ACL attribute as efficiently as possible.
- */
-int
-xfs_acl_vhasacl_access(
-	struct inode	*vp)
-{
-	int		error;
-
-	xfs_acl_get_attr(vp, NULL, _ACL_TYPE_ACCESS, ATTR_KERNOVAL, &error);
-	return (error == 0);
-}
-
-/*
- * Test for existence of default ACL attribute as efficiently as possible.
- */
-int
-xfs_acl_vhasacl_default(
-	struct inode	*vp)
-{
-	int		error;
-
-	if (!S_ISDIR(vp->i_mode))
-		return 0;
-	xfs_acl_get_attr(vp, NULL, _ACL_TYPE_DEFAULT, ATTR_KERNOVAL, &error);
-	return (error == 0);
-}
-
-/*
- * Convert from extended attribute representation to in-memory for XFS.
- */
-STATIC int
-posix_acl_xattr_to_xfs(
-	posix_acl_xattr_header	*src,
-	size_t			size,
-	xfs_acl_t		*dest)
-{
-	posix_acl_xattr_entry	*src_entry;
-	xfs_acl_entry_t		*dest_entry;
-	int			n;
-
-	if (!src || !dest)
-		return EINVAL;
-
-	if (size < sizeof(posix_acl_xattr_header))
-		return EINVAL;
-
-	if (src->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
-		return EOPNOTSUPP;
-
-	memset(dest, 0, sizeof(xfs_acl_t));
-	dest->acl_cnt = posix_acl_xattr_count(size);
-	if (dest->acl_cnt < 0 || dest->acl_cnt > XFS_ACL_MAX_ENTRIES)
-		return EINVAL;
-
-	/*
-	 * acl_set_file(3) may request that we set default ACLs with
-	 * zero length -- defend (gracefully) against that here.
-	 */
-	if (!dest->acl_cnt)
-		return 0;
-
-	src_entry = (posix_acl_xattr_entry *)((char *)src + sizeof(*src));
-	dest_entry = &dest->acl_entry[0];
-
-	for (n = 0; n < dest->acl_cnt; n++, src_entry++, dest_entry++) {
-		dest_entry->ae_perm = le16_to_cpu(src_entry->e_perm);
-		if (_ACL_PERM_INVALID(dest_entry->ae_perm))
-			return EINVAL;
-		dest_entry->ae_tag  = le16_to_cpu(src_entry->e_tag);
-		switch(dest_entry->ae_tag) {
-		case ACL_USER:
-		case ACL_GROUP:
-			dest_entry->ae_id = le32_to_cpu(src_entry->e_id);
-			break;
-		case ACL_USER_OBJ:
-		case ACL_GROUP_OBJ:
-		case ACL_MASK:
-		case ACL_OTHER:
-			dest_entry->ae_id = ACL_UNDEFINED_ID;
-			break;
-		default:
-			return EINVAL;
-		}
-	}
-	if (xfs_acl_invalid(dest))
-		return EINVAL;
-
-	return 0;
-}
-
-/*
- * Comparison function called from xfs_sort().
- * Primary key is ae_tag, secondary key is ae_id.
- */
-STATIC int
-xfs_acl_entry_compare(
-	const void	*va,
-	const void	*vb)
-{
-	xfs_acl_entry_t	*a = (xfs_acl_entry_t *)va,
-			*b = (xfs_acl_entry_t *)vb;
-
-	if (a->ae_tag == b->ae_tag)
-		return (a->ae_id - b->ae_id);
-	return (a->ae_tag - b->ae_tag);
-}
-
-/*
- * Convert from in-memory XFS to extended attribute representation.
- */
-STATIC int
-posix_acl_xfs_to_xattr(
-	xfs_acl_t		*src,
-	posix_acl_xattr_header	*dest,
-	size_t			size)
-{
-	int			n;
-	size_t			new_size = posix_acl_xattr_size(src->acl_cnt);
-	posix_acl_xattr_entry	*dest_entry;
-	xfs_acl_entry_t		*src_entry;
-
-	if (size < new_size)
-		return -ERANGE;
-
-	/* Need to sort src XFS ACL by <ae_tag,ae_id> */
-	xfs_sort(src->acl_entry, src->acl_cnt, sizeof(src->acl_entry[0]),
-		 xfs_acl_entry_compare);
-
-	dest->a_version = cpu_to_le32(POSIX_ACL_XATTR_VERSION);
-	dest_entry = &dest->a_entries[0];
-	src_entry = &src->acl_entry[0];
-	for (n = 0; n < src->acl_cnt; n++, dest_entry++, src_entry++) {
-		dest_entry->e_perm = cpu_to_le16(src_entry->ae_perm);
-		if (_ACL_PERM_INVALID(src_entry->ae_perm))
-			return -EINVAL;
-		dest_entry->e_tag  = cpu_to_le16(src_entry->ae_tag);
-		switch (src_entry->ae_tag) {
-		case ACL_USER:
-		case ACL_GROUP:
-			dest_entry->e_id = cpu_to_le32(src_entry->ae_id);
-				break;
-		case ACL_USER_OBJ:
-		case ACL_GROUP_OBJ:
-		case ACL_MASK:
-		case ACL_OTHER:
-			dest_entry->e_id = cpu_to_le32(ACL_UNDEFINED_ID);
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
-	return new_size;
-}
-
-int
-xfs_acl_vget(
-	struct inode	*vp,
-	void		*acl,
-	size_t		size,
-	int		kind)
-{
-	int			error;
-	xfs_acl_t		*xfs_acl = NULL;
-	posix_acl_xattr_header	*ext_acl = acl;
-	int			flags = 0;
-
-	if(size) {
-		if (!(_ACL_ALLOC(xfs_acl))) {
-			error = ENOMEM;
-			goto out;
-		}
-		memset(xfs_acl, 0, sizeof(xfs_acl_t));
-	} else
-		flags = ATTR_KERNOVAL;
-
-	xfs_acl_get_attr(vp, xfs_acl, kind, flags, &error);
-	if (error)
-		goto out;
-
-	if (!size) {
-		error = -posix_acl_xattr_size(XFS_ACL_MAX_ENTRIES);
-	} else {
-		if (xfs_acl_invalid(xfs_acl)) {
-			error = EINVAL;
-			goto out;
-		}
-		if (kind == _ACL_TYPE_ACCESS)
-			xfs_acl_sync_mode(XFS_I(vp)->i_d.di_mode, xfs_acl);
-		error = -posix_acl_xfs_to_xattr(xfs_acl, ext_acl, size);
-	}
-out:
-	if(xfs_acl)
-		_ACL_FREE(xfs_acl);
-	return -error;
-}
-
-int
-xfs_acl_vremove(
-	struct inode	*vp,
-	int		kind)
-{
-	int		error;
-
-	error = xfs_acl_allow_set(vp, kind);
-	if (!error) {
-		error = xfs_attr_remove(XFS_I(vp),
-						kind == _ACL_TYPE_DEFAULT?
-						SGI_ACL_DEFAULT: SGI_ACL_FILE,
-						ATTR_ROOT);
-		if (error == ENOATTR)
-			error = 0;	/* 'scool */
-	}
-	return -error;
-}
-
-int
-xfs_acl_vset(
-	struct inode		*vp,
-	void			*acl,
-	size_t			size,
-	int			kind)
-{
-	posix_acl_xattr_header	*ext_acl = acl;
-	xfs_acl_t		*xfs_acl;
-	int			error;
-	int			basicperms = 0; /* more than std unix perms? */
-
-	if (!acl)
-		return -EINVAL;
-
-	if (!(_ACL_ALLOC(xfs_acl)))
-		return -ENOMEM;
-
-	error = posix_acl_xattr_to_xfs(ext_acl, size, xfs_acl);
-	if (error) {
-		_ACL_FREE(xfs_acl);
-		return -error;
-	}
-	if (!xfs_acl->acl_cnt) {
-		_ACL_FREE(xfs_acl);
-		return 0;
-	}
-
-	error = xfs_acl_allow_set(vp, kind);
-
-	/* Incoming ACL exists, set file mode based on its value */
-	if (!error && kind == _ACL_TYPE_ACCESS)
-		error = xfs_acl_setmode(vp, xfs_acl, &basicperms);
-
-	if (error)
-		goto out;
-
-	/*
-	 * If we have more than std unix permissions, set up the actual attr.
-	 * Otherwise, delete any existing attr.  This prevents us from
-	 * having actual attrs for permissions that can be stored in the
-	 * standard permission bits.
-	 */
-	if (!basicperms) {
-		xfs_acl_set_attr(vp, xfs_acl, kind, &error);
-	} else {
-		error = -xfs_acl_vremove(vp, _ACL_TYPE_ACCESS);
-	}
-
-out:
-	_ACL_FREE(xfs_acl);
-	return -error;
-}
-
-int
-xfs_acl_iaccess(
-	xfs_inode_t	*ip,
-	mode_t		mode,
-	cred_t		*cr)
-{
-	xfs_acl_t	*acl;
-	int		rval;
-	struct xfs_name	acl_name = {SGI_ACL_FILE, SGI_ACL_FILE_SIZE};
-
-	if (!(_ACL_ALLOC(acl)))
-		return -1;
-
-	/* If the file has no ACL return -1. */
-	rval = sizeof(xfs_acl_t);
-	if (xfs_attr_fetch(ip, &acl_name, (char *)acl, &rval, ATTR_ROOT)) {
-		_ACL_FREE(acl);
-		return -1;
-	}
-	xfs_acl_get_endian(acl);
-
-	/* If the file has an empty ACL return -1. */
-	if (acl->acl_cnt == XFS_ACL_NOT_PRESENT) {
-		_ACL_FREE(acl);
-		return -1;
-	}
-
-	/* Synchronize ACL with mode bits */
-	xfs_acl_sync_mode(ip->i_d.di_mode, acl);
-
-	rval = xfs_acl_access(ip->i_d.di_uid, ip->i_d.di_gid, acl, mode, cr);
-	_ACL_FREE(acl);
-	return rval;
-}
-
-STATIC int
-xfs_acl_allow_set(
-	struct inode	*vp,
-	int		kind)
-{
-	if (vp->i_flags & (S_IMMUTABLE|S_APPEND))
-		return EPERM;
-	if (kind == _ACL_TYPE_DEFAULT && !S_ISDIR(vp->i_mode))
-		return ENOTDIR;
-	if (vp->i_sb->s_flags & MS_RDONLY)
-		return EROFS;
-	if (XFS_I(vp)->i_d.di_uid != current_fsuid() && !capable(CAP_FOWNER))
-		return EPERM;
-	return 0;
-}
-
-/*
- * Note: cr is only used here for the capability check if the ACL test fails.
- *       It is not used to find out the credentials uid or groups etc, as was
- *       done in IRIX. It is assumed that the uid and groups for the current
- *       thread are taken from "current" instead of the cr parameter.
- */
-STATIC int
-xfs_acl_access(
-	uid_t		fuid,
-	gid_t		fgid,
-	xfs_acl_t	*fap,
-	mode_t		md,
-	cred_t		*cr)
-{
-	xfs_acl_entry_t	matched;
-	int		i, allows;
-	int		maskallows = -1;	/* true, but not 1, either */
-	int		seen_userobj = 0;
-
-	matched.ae_tag = 0;	/* Invalid type */
-	matched.ae_perm = 0;
-
-	for (i = 0; i < fap->acl_cnt; i++) {
-		/*
-		 * Break out if we've got a user_obj entry or
-		 * a user entry and the mask (and have processed USER_OBJ)
-		 */
-		if (matched.ae_tag == ACL_USER_OBJ)
-			break;
-		if (matched.ae_tag == ACL_USER) {
-			if (maskallows != -1 && seen_userobj)
-				break;
-			if (fap->acl_entry[i].ae_tag != ACL_MASK &&
-			    fap->acl_entry[i].ae_tag != ACL_USER_OBJ)
-				continue;
-		}
-		/* True if this entry allows the requested access */
-		allows = ((fap->acl_entry[i].ae_perm & md) == md);
-
-		switch (fap->acl_entry[i].ae_tag) {
-		case ACL_USER_OBJ:
-			seen_userobj = 1;
-			if (fuid != current_fsuid())
-				continue;
-			matched.ae_tag = ACL_USER_OBJ;
-			matched.ae_perm = allows;
-			break;
-		case ACL_USER:
-			if (fap->acl_entry[i].ae_id != current_fsuid())
-				continue;
-			matched.ae_tag = ACL_USER;
-			matched.ae_perm = allows;
-			break;
-		case ACL_GROUP_OBJ:
-			if ((matched.ae_tag == ACL_GROUP_OBJ ||
-			    matched.ae_tag == ACL_GROUP) && !allows)
-				continue;
-			if (!in_group_p(fgid))
-				continue;
-			matched.ae_tag = ACL_GROUP_OBJ;
-			matched.ae_perm = allows;
-			break;
-		case ACL_GROUP:
-			if ((matched.ae_tag == ACL_GROUP_OBJ ||
-			    matched.ae_tag == ACL_GROUP) && !allows)
-				continue;
-			if (!in_group_p(fap->acl_entry[i].ae_id))
-				continue;
-			matched.ae_tag = ACL_GROUP;
-			matched.ae_perm = allows;
-			break;
-		case ACL_MASK:
-			maskallows = allows;
-			break;
-		case ACL_OTHER:
-			if (matched.ae_tag != 0)
-				continue;
-			matched.ae_tag = ACL_OTHER;
-			matched.ae_perm = allows;
-			break;
-		}
-	}
-	/*
-	 * First possibility is that no matched entry allows access.
-	 * The capability to override DAC may exist, so check for it.
-	 */
-	switch (matched.ae_tag) {
-	case ACL_OTHER:
-	case ACL_USER_OBJ:
-		if (matched.ae_perm)
-			return 0;
-		break;
-	case ACL_USER:
-	case ACL_GROUP_OBJ:
-	case ACL_GROUP:
-		if (maskallows && matched.ae_perm)
-			return 0;
-		break;
-	case 0:
-		break;
-	}
-
-	/* EACCES tells generic_permission to check for capability overrides */
-	return EACCES;
-}
-
-/*
- * ACL validity checker.
- *   This acl validation routine checks each ACL entry read in makes sense.
- */
-STATIC int
-xfs_acl_invalid(
-	xfs_acl_t	*aclp)
-{
-	xfs_acl_entry_t	*entry, *e;
-	int		user = 0, group = 0, other = 0, mask = 0;
-	int		mask_required = 0;
-	int		i, j;
-
-	if (!aclp)
-		goto acl_invalid;
-
-	if (aclp->acl_cnt > XFS_ACL_MAX_ENTRIES)
-		goto acl_invalid;
-
-	for (i = 0; i < aclp->acl_cnt; i++) {
-		entry = &aclp->acl_entry[i];
-		switch (entry->ae_tag) {
-		case ACL_USER_OBJ:
-			if (user++)
-				goto acl_invalid;
-			break;
-		case ACL_GROUP_OBJ:
-			if (group++)
-				goto acl_invalid;
-			break;
-		case ACL_OTHER:
-			if (other++)
-				goto acl_invalid;
-			break;
-		case ACL_USER:
-		case ACL_GROUP:
-			for (j = i + 1; j < aclp->acl_cnt; j++) {
-				e = &aclp->acl_entry[j];
-				if (e->ae_id == entry->ae_id &&
-				    e->ae_tag == entry->ae_tag)
-					goto acl_invalid;
-			}
-			mask_required++;
-			break;
-		case ACL_MASK:
-			if (mask++)
-				goto acl_invalid;
-			break;
-		default:
-			goto acl_invalid;
-		}
-	}
-	if (!user || !group || !other || (mask_required && !mask))
-		goto acl_invalid;
-	else
-		return 0;
-acl_invalid:
-	return EINVAL;
-}
-
-/*
- * Do ACL endian conversion.
- */
-STATIC void
-xfs_acl_get_endian(
-	xfs_acl_t	*aclp)
-{
-	xfs_acl_entry_t	*ace, *end;
-
-	INT_SET(aclp->acl_cnt, ARCH_CONVERT, aclp->acl_cnt);
-	end = &aclp->acl_entry[0]+aclp->acl_cnt;
-	for (ace = &aclp->acl_entry[0]; ace < end; ace++) {
-		INT_SET(ace->ae_tag, ARCH_CONVERT, ace->ae_tag);
-		INT_SET(ace->ae_id, ARCH_CONVERT, ace->ae_id);
-		INT_SET(ace->ae_perm, ARCH_CONVERT, ace->ae_perm);
-	}
-}
-
-/*
- * Get the ACL from the EA and do endian conversion.
- */
-STATIC void
-xfs_acl_get_attr(
-	struct inode	*vp,
-	xfs_acl_t	*aclp,
-	int		kind,
-	int		flags,
-	int		*error)
-{
-	int		len = sizeof(xfs_acl_t);
-
-	ASSERT((flags & ATTR_KERNOVAL) ? (aclp == NULL) : 1);
-	flags |= ATTR_ROOT;
-	*error = xfs_attr_get(XFS_I(vp),
-					kind == _ACL_TYPE_ACCESS ?
-					SGI_ACL_FILE : SGI_ACL_DEFAULT,
-					(char *)aclp, &len, flags);
-	if (*error || (flags & ATTR_KERNOVAL))
-		return;
-	xfs_acl_get_endian(aclp);
-}
-
-/*
- * Set the EA with the ACL and do endian conversion.
- */
-STATIC void
-xfs_acl_set_attr(
-	struct inode	*vp,
-	xfs_acl_t	*aclp,
-	int		kind,
-	int		*error)
-{
-	xfs_acl_entry_t	*ace, *newace, *end;
-	xfs_acl_t	*newacl;
-	int		len;
-
-	if (!(_ACL_ALLOC(newacl))) {
-		*error = ENOMEM;
-		return;
-	}
-
-	len = sizeof(xfs_acl_t) -
-	      (sizeof(xfs_acl_entry_t) * (XFS_ACL_MAX_ENTRIES - aclp->acl_cnt));
-	end = &aclp->acl_entry[0]+aclp->acl_cnt;
-	for (ace = &aclp->acl_entry[0], newace = &newacl->acl_entry[0];
-	     ace < end;
-	     ace++, newace++) {
-		INT_SET(newace->ae_tag, ARCH_CONVERT, ace->ae_tag);
-		INT_SET(newace->ae_id, ARCH_CONVERT, ace->ae_id);
-		INT_SET(newace->ae_perm, ARCH_CONVERT, ace->ae_perm);
-	}
-	INT_SET(newacl->acl_cnt, ARCH_CONVERT, aclp->acl_cnt);
-	*error = xfs_attr_set(XFS_I(vp),
-				kind == _ACL_TYPE_ACCESS ?
-				SGI_ACL_FILE: SGI_ACL_DEFAULT,
-				(char *)newacl, len, ATTR_ROOT);
-	_ACL_FREE(newacl);
-}
-
-int
-xfs_acl_vtoacl(
-	struct inode	*vp,
-	xfs_acl_t	*access_acl,
-	xfs_acl_t	*default_acl)
-{
-	int		error = 0;
-
-	if (access_acl) {
-		/*
-		 * Get the Access ACL and the mode.  If either cannot
-		 * be obtained for some reason, invalidate the access ACL.
-		 */
-		xfs_acl_get_attr(vp, access_acl, _ACL_TYPE_ACCESS, 0, &error);
-		if (error)
-			access_acl->acl_cnt = XFS_ACL_NOT_PRESENT;
-		else /* We have a good ACL and the file mode, synchronize. */
-			xfs_acl_sync_mode(XFS_I(vp)->i_d.di_mode, access_acl);
-	}
-
-	if (default_acl) {
-		xfs_acl_get_attr(vp, default_acl, _ACL_TYPE_DEFAULT, 0, &error);
-		if (error)
-			default_acl->acl_cnt = XFS_ACL_NOT_PRESENT;
-	}
-	return error;
-}
-
-/*
- * This function retrieves the parent directory's acl, processes it
- * and lets the child inherit the acl(s) that it should.
- */
-int
-xfs_acl_inherit(
-	struct inode	*vp,
-	mode_t		mode,
-	xfs_acl_t	*pdaclp)
-{
-	xfs_acl_t	*cacl;
-	int		error = 0;
-	int		basicperms = 0;
-
-	/*
-	 * If the parent does not have a default ACL, or it's an
-	 * invalid ACL, we're done.
-	 */
-	if (!vp)
-		return 0;
-	if (!pdaclp || xfs_acl_invalid(pdaclp))
-		return 0;
-
-	/*
-	 * Copy the default ACL of the containing directory to
-	 * the access ACL of the new file and use the mode that
-	 * was passed in to set up the correct initial values for
-	 * the u::,g::[m::], and o:: entries.  This is what makes
-	 * umask() "work" with ACL's.
-	 */
-
-	if (!(_ACL_ALLOC(cacl)))
-		return ENOMEM;
-
-	memcpy(cacl, pdaclp, sizeof(xfs_acl_t));
-	xfs_acl_filter_mode(mode, cacl);
-	error = xfs_acl_setmode(vp, cacl, &basicperms);
-	if (error)
-		goto out_error;
-
-	/*
-	 * Set the Default and Access ACL on the file.  The mode is already
-	 * set on the file, so we don't need to worry about that.
-	 *
-	 * If the new file is a directory, its default ACL is a copy of
-	 * the containing directory's default ACL.
-	 */
-	if (S_ISDIR(vp->i_mode))
-		xfs_acl_set_attr(vp, pdaclp, _ACL_TYPE_DEFAULT, &error);
-	if (!error && !basicperms)
-		xfs_acl_set_attr(vp, cacl, _ACL_TYPE_ACCESS, &error);
-out_error:
-	_ACL_FREE(cacl);
-	return error;
-}
-
-/*
- * Set up the correct mode on the file based on the supplied ACL.  This
- * makes sure that the mode on the file reflects the state of the
- * u::,g::[m::], and o:: entries in the ACL.  Since the mode is where
- * the ACL is going to get the permissions for these entries, we must
- * synchronize the mode whenever we set the ACL on a file.
- */
-STATIC int
-xfs_acl_setmode(
-	struct inode	*vp,
-	xfs_acl_t	*acl,
-	int		*basicperms)
-{
-	struct iattr	iattr;
-	xfs_acl_entry_t	*ap;
-	xfs_acl_entry_t	*gap = NULL;
-	int		i, nomask = 1;
-
-	*basicperms = 1;
-
-	if (acl->acl_cnt == XFS_ACL_NOT_PRESENT)
-		return 0;
-
-	/*
-	 * Copy the u::, g::, o::, and m:: bits from the ACL into the
-	 * mode.  The m:: bits take precedence over the g:: bits.
-	 */
-	iattr.ia_valid = ATTR_MODE;
-	iattr.ia_mode = XFS_I(vp)->i_d.di_mode;
-	iattr.ia_mode &= ~(S_IRWXU|S_IRWXG|S_IRWXO);
-	ap = acl->acl_entry;
-	for (i = 0; i < acl->acl_cnt; ++i) {
-		switch (ap->ae_tag) {
-		case ACL_USER_OBJ:
-			iattr.ia_mode |= ap->ae_perm << 6;
-			break;
-		case ACL_GROUP_OBJ:
-			gap = ap;
-			break;
-		case ACL_MASK:	/* more than just standard modes */
-			nomask = 0;
-			iattr.ia_mode |= ap->ae_perm << 3;
-			*basicperms = 0;
-			break;
-		case ACL_OTHER:
-			iattr.ia_mode |= ap->ae_perm;
-			break;
-		default:	/* more than just standard modes */
-			*basicperms = 0;
-			break;
-		}
-		ap++;
-	}
-
-	/* Set the group bits from ACL_GROUP_OBJ if there's no ACL_MASK */
-	if (gap && nomask)
-		iattr.ia_mode |= gap->ae_perm << 3;
-
-	return xfs_setattr(XFS_I(vp), &iattr, 0);
-}
-
-/*
- * The permissions for the special ACL entries (u::, g::[m::], o::) are
- * actually stored in the file mode (if there is both a group and a mask,
- * the group is stored in the ACL entry and the mask is stored on the file).
- * This allows the mode to remain automatically in sync with the ACL without
- * the need for a call-back to the ACL system at every point where the mode
- * could change.  This function takes the permissions from the specified mode
- * and places it in the supplied ACL.
- *
- * This implementation draws its validity from the fact that, when the ACL
- * was assigned, the mode was copied from the ACL.
- * If the mode did not change, therefore, the mode remains exactly what was
- * taken from the special ACL entries at assignment.
- * If a subsequent chmod() was done, the POSIX spec says that the change in
- * mode must cause an update to the ACL seen at user level and used for
- * access checks.  Before and after a mode change, therefore, the file mode
- * most accurately reflects what the special ACL entries should permit/deny.
- *
- * CAVEAT: If someone sets the SGI_ACL_FILE attribute directly,
- *         the existing mode bits will override whatever is in the
- *         ACL. Similarly, if there is a pre-existing ACL that was
- *         never in sync with its mode (owing to a bug in 6.5 and
- *         before), it will now magically (or mystically) be
- *         synchronized.  This could cause slight astonishment, but
- *         it is better than inconsistent permissions.
- *
- * The supplied ACL is a template that may contain any combination
- * of special entries.  These are treated as place holders when we fill
- * out the ACL.  This routine does not add or remove special entries, it
- * simply unites each special entry with its associated set of permissions.
- */
-STATIC void
-xfs_acl_sync_mode(
-	mode_t		mode,
-	xfs_acl_t	*acl)
-{
-	int		i, nomask = 1;
-	xfs_acl_entry_t	*ap;
-	xfs_acl_entry_t	*gap = NULL;
-
-	/*
-	 * Set ACL entries. POSIX1003.1eD16 requires that the MASK
-	 * be set instead of the GROUP entry, if there is a MASK.
-	 */
-	for (ap = acl->acl_entry, i = 0; i < acl->acl_cnt; ap++, i++) {
-		switch (ap->ae_tag) {
-		case ACL_USER_OBJ:
-			ap->ae_perm = (mode >> 6) & 0x7;
-			break;
-		case ACL_GROUP_OBJ:
-			gap = ap;
-			break;
-		case ACL_MASK:
-			nomask = 0;
-			ap->ae_perm = (mode >> 3) & 0x7;
-			break;
-		case ACL_OTHER:
-			ap->ae_perm = mode & 0x7;
-			break;
-		default:
-			break;
-		}
-	}
-	/* Set the ACL_GROUP_OBJ if there's no ACL_MASK */
-	if (gap && nomask)
-		gap->ae_perm = (mode >> 3) & 0x7;
-}
-
-/*
- * When inheriting an Access ACL from a directory Default ACL,
- * the ACL bits are set to the intersection of the ACL default
- * permission bits and the file permission bits in mode. If there
- * are no permission bits on the file then we must not give them
- * the ACL. This is what what makes umask() work with ACLs.
- */
-STATIC void
-xfs_acl_filter_mode(
-	mode_t		mode,
-	xfs_acl_t	*acl)
-{
-	int		i, nomask = 1;
-	xfs_acl_entry_t	*ap;
-	xfs_acl_entry_t	*gap = NULL;
-
-	/*
-	 * Set ACL entries. POSIX1003.1eD16 requires that the MASK
-	 * be merged with GROUP entry, if there is a MASK.
-	 */
-	for (ap = acl->acl_entry, i = 0; i < acl->acl_cnt; ap++, i++) {
-		switch (ap->ae_tag) {
-		case ACL_USER_OBJ:
-			ap->ae_perm &= (mode >> 6) & 0x7;
-			break;
-		case ACL_GROUP_OBJ:
-			gap = ap;
-			break;
-		case ACL_MASK:
-			nomask = 0;
-			ap->ae_perm &= (mode >> 3) & 0x7;
-			break;
-		case ACL_OTHER:
-			ap->ae_perm &= mode & 0x7;
-			break;
-		default:
-			break;
-		}
-	}
-	/* Set the ACL_GROUP_OBJ if there's no ACL_MASK */
-	if (gap && nomask)
-		gap->ae_perm &= (mode >> 3) & 0x7;
-}
Index: xfs/fs/xfs/xfs_acl.h
===================================================================
--- xfs.orig/fs/xfs/xfs_acl.h	2009-02-08 21:51:06.552944480 +0100
+++ xfs/fs/xfs/xfs_acl.h	2009-02-20 13:53:22.790083725 +0100
@@ -18,81 +18,48 @@
 #ifndef __XFS_ACL_H__
 #define __XFS_ACL_H__
 
-/*
- * Access Control Lists
- */
-typedef __uint16_t	xfs_acl_perm_t;
-typedef __int32_t	xfs_acl_tag_t;
-typedef __int32_t	xfs_acl_id_t;
+struct inode;
+struct posix_acl;
+struct xfs_inode;
 
 #define XFS_ACL_MAX_ENTRIES 25
 #define XFS_ACL_NOT_PRESENT (-1)
 
-typedef struct xfs_acl_entry {
-	xfs_acl_tag_t	ae_tag;
-	xfs_acl_id_t	ae_id;
-	xfs_acl_perm_t	ae_perm;
-} xfs_acl_entry_t;
-
-typedef struct xfs_acl {
-	__int32_t	acl_cnt;
-	xfs_acl_entry_t	acl_entry[XFS_ACL_MAX_ENTRIES];
-} xfs_acl_t;
+/* On-disk XFS access control list structure */
+struct xfs_acl {
+	__be32		acl_cnt;
+	struct xfs_acl_entry {
+		__be32	ae_tag;
+		__be32	ae_id;
+		__be16	ae_perm;
+	} acl_entry[XFS_ACL_MAX_ENTRIES];
+};
 
 /* On-disk XFS extended attribute names */
-#define SGI_ACL_FILE	"SGI_ACL_FILE"
-#define SGI_ACL_DEFAULT	"SGI_ACL_DEFAULT"
+#define SGI_ACL_FILE		"SGI_ACL_FILE"
+#define SGI_ACL_DEFAULT		"SGI_ACL_DEFAULT"
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
-#define _ACL_TYPE_ACCESS	1
-#define _ACL_TYPE_DEFAULT	2
-
 #ifdef CONFIG_XFS_POSIX_ACL
+extern int xfs_check_acl(struct inode *inode, int mask);
+extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
+extern int xfs_inherit_acl(struct inode *inode, struct posix_acl *default_acl);
+extern int xfs_acl_chmod(struct inode *inode);
+extern void xfs_inode_init_acls(struct xfs_inode *ip);
+extern void xfs_inode_clear_acls(struct xfs_inode *ip);
+extern int posix_acl_access_exists(struct inode *inode);
+extern int posix_acl_default_exists(struct inode *inode);
 
-struct vattr;
-struct xfs_inode;
-
-extern struct kmem_zone *xfs_acl_zone;
-#define xfs_acl_zone_init(zone, name)	\
-		(zone) = kmem_zone_init(sizeof(xfs_acl_t), (name))
-#define xfs_acl_zone_destroy(zone)	kmem_zone_destroy(zone)
-
-extern int xfs_acl_inherit(struct inode *, mode_t mode, xfs_acl_t *);
-extern int xfs_acl_iaccess(struct xfs_inode *, mode_t, cred_t *);
-extern int xfs_acl_vtoacl(struct inode *, xfs_acl_t *, xfs_acl_t *);
-extern int xfs_acl_vhasacl_access(struct inode *);
-extern int xfs_acl_vhasacl_default(struct inode *);
-extern int xfs_acl_vset(struct inode *, void *, size_t, int);
-extern int xfs_acl_vget(struct inode *, void *, size_t, int);
-extern int xfs_acl_vremove(struct inode *, int);
-
-#define _ACL_PERM_INVALID(perm)	((perm) & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
-
-#define _ACL_INHERIT(c,m,d)	(xfs_acl_inherit(c,m,d))
-#define _ACL_GET_ACCESS(pv,pa)	(xfs_acl_vtoacl(pv,pa,NULL) == 0)
-#define _ACL_GET_DEFAULT(pv,pd)	(xfs_acl_vtoacl(pv,NULL,pd) == 0)
-#define _ACL_ACCESS_EXISTS	xfs_acl_vhasacl_access
-#define _ACL_DEFAULT_EXISTS	xfs_acl_vhasacl_default
-
-#define _ACL_ALLOC(a)		((a) = kmem_zone_alloc(xfs_acl_zone, KM_SLEEP))
-#define _ACL_FREE(a)		((a)? kmem_zone_free(xfs_acl_zone, (a)):(void)0)
-
+extern struct xattr_handler xfs_xattr_system_handler;
 #else
-#define xfs_acl_zone_init(zone,name)
-#define xfs_acl_zone_destroy(zone)
-#define xfs_acl_vset(v,p,sz,t)	(-EOPNOTSUPP)
-#define xfs_acl_vget(v,p,sz,t)	(-EOPNOTSUPP)
-#define xfs_acl_vremove(v,t)	(-EOPNOTSUPP)
-#define xfs_acl_vhasacl_access(v)	(0)
-#define xfs_acl_vhasacl_default(v)	(0)
-#define _ACL_ALLOC(a)		(1)	/* successfully allocate nothing */
-#define _ACL_FREE(a)		((void)0)
-#define _ACL_INHERIT(c,m,d)	(0)
-#define _ACL_GET_ACCESS(pv,pa)	(0)
-#define _ACL_GET_DEFAULT(pv,pd)	(0)
-#define _ACL_ACCESS_EXISTS	(NULL)
-#define _ACL_DEFAULT_EXISTS	(NULL)
-#endif
-
+# define xfs_check_acl					NULL
+# define xfs_get_acl(inode, type)			NULL
+# define xfs_inherit_acl(inode, default_acl)		0
+# define xfs_acl_chmod(inode)				0
+# define xfs_inode_init_acls(ip)
+# define xfs_inode_clear_acls(ip)
+# define posix_acl_access_exists(inode)			0
+# define posix_acl_default_exists(inode)		0
+#endif /* CONFIG_XFS_POSIX_ACL */
 #endif	/* __XFS_ACL_H__ */
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-02-20 13:20:38.065069837 +0100
+++ xfs/fs/xfs/xfs_iget.c	2009-02-20 13:37:17.696973203 +0100
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
+#include "xfs_acl.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
@@ -91,6 +92,7 @@ xfs_inode_alloc(
 	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 	ip->i_size = 0;
 	ip->i_new_size = 0;
+	xfs_inode_init_acls(ip);
 
 	/*
 	 * Initialize inode's trace buffers.
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2009-02-15 20:13:53.857944504 +0100
+++ xfs/fs/xfs/xfs_inode.c	2009-02-20 13:41:29.140946099 +0100
@@ -49,7 +49,6 @@
 #include "xfs_utils.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_quota.h"
-#include "xfs_acl.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
 
Index: xfs/fs/xfs/xfs_arch.h
===================================================================
--- xfs.orig/fs/xfs/xfs_arch.h	2009-02-20 14:00:55.735069250 +0100
+++ xfs/fs/xfs/xfs_arch.h	2009-02-20 14:04:16.569099732 +0100
@@ -73,28 +73,6 @@ static inline void be64_add_cpu(__be64 *
 
 #endif	/* __KERNEL__ */
 
-/* do we need conversion? */
-#define ARCH_NOCONVERT 1
-#ifdef XFS_NATIVE_HOST
-# define ARCH_CONVERT	ARCH_NOCONVERT
-#else
-# define ARCH_CONVERT	0
-#endif
-
-/* generic swapping macros */
-
-#ifndef HAVE_SWABMACROS
-#define INT_SWAP16(type,var) ((typeof(type))(__swab16((__u16)(var))))
-#define INT_SWAP32(type,var) ((typeof(type))(__swab32((__u32)(var))))
-#define INT_SWAP64(type,var) ((typeof(type))(__swab64((__u64)(var))))
-#endif
-
-#define INT_SWAP(type, var) \
-    ((sizeof(type) == 8) ? INT_SWAP64(type,var) : \
-    ((sizeof(type) == 4) ? INT_SWAP32(type,var) : \
-    ((sizeof(type) == 2) ? INT_SWAP16(type,var) : \
-    (var))))
-
 /*
  * get and set integers from potentially unaligned locations
  */
@@ -107,16 +85,6 @@ static inline void be64_add_cpu(__be64 *
 	((__u8*)(pointer))[1] = (((value)     ) & 0xff); \
     }
 
-/* does not return a value */
-#define INT_SET(reference,arch,valueref) \
-    (__builtin_constant_p(valueref) ? \
-	(void)( (reference) = ( ((arch) != ARCH_NOCONVERT) ? (INT_SWAP((reference),(valueref))) : (valueref)) ) : \
-	(void)( \
-	    ((reference) = (valueref)), \
-	    ( ((arch) != ARCH_NOCONVERT) ? (reference) = INT_SWAP((reference),(reference)) : 0 ) \
-	) \
-    )
-
 /*
  * In directories inode numbers are stored as unaligned arrays of unsigned
  * 8bit integers on disk.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
