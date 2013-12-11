Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6C2929E29
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 04:45:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D329AC00B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 02:45:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7oNyNhJCLuxRh6KI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 02:45:46 -0800 (PST)
Message-Id: <20131211104529.533351849@bombadil.infradead.org>
Date: Wed, 11 Dec 2013 02:43:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 18/18] fs: remove generic_acl
References: <20131211104243.148113893@bombadil.infradead.org>
Content-Disposition: inline; filename=0018-fs-remove-generic_acl.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: viro@zeniv.linux.org.uk
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

And instead convert tmpfs to use the new generic ACL code, with two stub
methods provided for in-memory filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/Kconfig                  |    6 +-
 fs/Makefile                 |    1 -
 fs/generic_acl.c            |  184 -------------------------------------------
 fs/posix_acl.c              |   36 +++++++++
 include/linux/generic_acl.h |   14 ----
 include/linux/posix_acl.h   |    9 +++
 mm/shmem.c                  |   57 ++++++--------
 7 files changed, 69 insertions(+), 238 deletions(-)
 delete mode 100644 fs/generic_acl.c
 delete mode 100644 include/linux/generic_acl.h

diff --git a/fs/Kconfig b/fs/Kconfig
index c229f82..7385e54 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -68,10 +68,6 @@ source "fs/quota/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 
-config GENERIC_ACL
-	bool
-	select FS_POSIX_ACL
-
 menu "Caches"
 
 source "fs/fscache/Kconfig"
@@ -119,7 +115,7 @@ config TMPFS_POSIX_ACL
 	bool "Tmpfs POSIX Access Control Lists"
 	depends on TMPFS
 	select TMPFS_XATTR
-	select GENERIC_ACL
+	select FS_POSIX_ACL
 	help
 	  POSIX Access Control Lists (ACLs) support additional access rights
 	  for users and groups beyond the standard owner/group/world scheme,
diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..30dc16d 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -44,7 +44,6 @@ obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
 obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
-obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 obj-$(CONFIG_COREDUMP)		+= coredump.o
 obj-$(CONFIG_SYSCTL)		+= drop_caches.o
 
diff --git a/fs/generic_acl.c b/fs/generic_acl.c
deleted file mode 100644
index 4357f39..0000000
--- a/fs/generic_acl.c
+++ /dev/null
@@ -1,184 +0,0 @@
-/*
- * (C) 2005 Andreas Gruenbacher <agruen@suse.de>
- *
- * This file is released under the GPL.
- *
- * Generic ACL support for in-memory filesystems.
- */
-
-#include <linux/sched.h>
-#include <linux/gfp.h>
-#include <linux/fs.h>
-#include <linux/generic_acl.h>
-#include <linux/posix_acl.h>
-#include <linux/posix_acl_xattr.h>
-
-
-static size_t
-generic_acl_list(struct dentry *dentry, char *list, size_t list_size,
-		const char *name, size_t name_len, int type)
-{
-	struct posix_acl *acl;
-	const char *xname;
-	size_t size;
-
-	acl = get_cached_acl(dentry->d_inode, type);
-	if (!acl)
-		return 0;
-	posix_acl_release(acl);
-
-	switch (type) {
-	case ACL_TYPE_ACCESS:
-		xname = POSIX_ACL_XATTR_ACCESS;
-		break;
-	case ACL_TYPE_DEFAULT:
-		xname = POSIX_ACL_XATTR_DEFAULT;
-		break;
-	default:
-		return 0;
-	}
-	size = strlen(xname) + 1;
-	if (list && size <= list_size)
-		memcpy(list, xname, size);
-	return size;
-}
-
-static int
-generic_acl_get(struct dentry *dentry, const char *name, void *buffer,
-		     size_t size, int type)
-{
-	struct posix_acl *acl;
-	int error;
-
-	if (strcmp(name, "") != 0)
-		return -EINVAL;
-
-	acl = get_cached_acl(dentry->d_inode, type);
-	if (!acl)
-		return -ENODATA;
-	error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-	posix_acl_release(acl);
-
-	return error;
-}
-
-static int
-generic_acl_set(struct dentry *dentry, const char *name, const void *value,
-		     size_t size, int flags, int type)
-{
-	struct inode *inode = dentry->d_inode;
-	struct posix_acl *acl = NULL;
-	int error;
-
-	if (strcmp(name, "") != 0)
-		return -EINVAL;
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-	if (!inode_owner_or_capable(inode))
-		return -EPERM;
-	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-	}
-	if (acl) {
-		error = posix_acl_valid(acl);
-		if (error)
-			goto failed;
-		switch (type) {
-		case ACL_TYPE_ACCESS:
-			error = posix_acl_equiv_mode(acl, &inode->i_mode);
-			if (error < 0)
-				goto failed;
-			inode->i_ctime = CURRENT_TIME;
-			if (error == 0) {
-				posix_acl_release(acl);
-				acl = NULL;
-			}
-			break;
-		case ACL_TYPE_DEFAULT:
-			if (!S_ISDIR(inode->i_mode)) {
-				error = -EINVAL;
-				goto failed;
-			}
-			break;
-		}
-	}
-	set_cached_acl(inode, type, acl);
-	error = 0;
-failed:
-	posix_acl_release(acl);
-	return error;
-}
-
-/**
- * generic_acl_init  -  Take care of acl inheritance at @inode create time
- *
- * Files created inside a directory with a default ACL inherit the
- * directory's default ACL.
- */
-int
-generic_acl_init(struct inode *inode, struct inode *dir)
-{
-	struct posix_acl *acl = NULL;
-	int error;
-
-	if (!S_ISLNK(inode->i_mode))
-		acl = get_cached_acl(dir, ACL_TYPE_DEFAULT);
-	if (acl) {
-		if (S_ISDIR(inode->i_mode))
-			set_cached_acl(inode, ACL_TYPE_DEFAULT, acl);
-		error = __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
-		if (error < 0)
-			return error;
-		if (error > 0)
-			set_cached_acl(inode, ACL_TYPE_ACCESS, acl);
-	} else {
-		inode->i_mode &= ~current_umask();
-	}
-	error = 0;
-
-	posix_acl_release(acl);
-	return error;
-}
-
-/**
- * generic_acl_chmod  -  change the access acl of @inode upon chmod()
- *
- * A chmod also changes the permissions of the owner, group/mask, and
- * other ACL entries.
- */
-int
-generic_acl_chmod(struct inode *inode)
-{
-	struct posix_acl *acl;
-	int error = 0;
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-	acl = get_cached_acl(inode, ACL_TYPE_ACCESS);
-	if (acl) {
-		error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
-		if (error)
-			return error;
-		set_cached_acl(inode, ACL_TYPE_ACCESS, acl);
-		posix_acl_release(acl);
-	}
-	return error;
-}
-
-const struct xattr_handler generic_acl_access_handler = {
-	.prefix = POSIX_ACL_XATTR_ACCESS,
-	.flags	= ACL_TYPE_ACCESS,
-	.list	= generic_acl_list,
-	.get	= generic_acl_get,
-	.set	= generic_acl_set,
-};
-
-const struct xattr_handler generic_acl_default_handler = {
-	.prefix = POSIX_ACL_XATTR_DEFAULT,
-	.flags	= ACL_TYPE_DEFAULT,
-	.list	= generic_acl_list,
-	.get	= generic_acl_get,
-	.set	= generic_acl_set,
-};
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 5d6149d..32a8e00 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -517,3 +517,39 @@ struct posix_acl *get_acl(struct inode *inode, int type)
 	}
 	return inode->i_op->get_acl(inode, type);
 }
+
+int simple_set_acl(struct inode *inode, struct posix_acl *acl, int type)
+{
+	int error;
+
+	if (type == ACL_TYPE_ACCESS) {
+		error = posix_acl_equiv_mode(acl, &inode->i_mode);
+		if (error < 0)
+			return 0;
+		if (error == 0)
+			acl = NULL;
+	}
+
+	inode->i_ctime = CURRENT_TIME;
+	set_cached_acl(inode, type, acl);
+	return 0;
+}
+
+int simple_acl_create(struct inode *dir, struct inode *inode)
+{
+	struct posix_acl *default_acl, *acl;
+	int error;
+
+	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+	if (error)
+		return error;
+
+	set_cached_acl(inode, ACL_TYPE_DEFAULT, default_acl);
+	set_cached_acl(inode, ACL_TYPE_ACCESS, acl);
+
+	if (default_acl)
+		posix_acl_release(default_acl);
+	if (acl)
+		posix_acl_release(acl);
+	return 0;
+}
diff --git a/include/linux/generic_acl.h b/include/linux/generic_acl.h
deleted file mode 100644
index b6d6575..0000000
--- a/include/linux/generic_acl.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef LINUX_GENERIC_ACL_H
-#define LINUX_GENERIC_ACL_H
-
-#include <linux/xattr.h>
-
-struct inode;
-
-extern const struct xattr_handler generic_acl_access_handler;
-extern const struct xattr_handler generic_acl_default_handler;
-
-int generic_acl_init(struct inode *, struct inode *);
-int generic_acl_chmod(struct inode *);
-
-#endif /* LINUX_GENERIC_ACL_H */
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 2e40aae..aa568d0 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -99,6 +99,9 @@ extern int posix_acl_chmod(struct inode *, umode_t);
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
 		struct posix_acl **);
 
+extern int simple_set_acl(struct inode *, struct posix_acl *, int);
+extern int simple_acl_create(struct inode *, struct inode *);
+
 static inline struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
 	switch (type) {
@@ -181,6 +184,12 @@ static inline int posix_acl_chmod(struct inode *inode, umode_t mode)
 	return 0;
 }
 
+#define simple_set_acl		NULL
+
+static inline int simple_acl_create(struct inode *dir, struct inode *inode)
+{
+	return 0;
+}
 static inline void cache_no_acl(struct inode *inode)
 {
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 8297623..67e74ae3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -45,7 +45,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/xattr.h>
 #include <linux/exportfs.h>
 #include <linux/posix_acl.h>
-#include <linux/generic_acl.h>
+#include <linux/posix_acl_xattr.h>
 #include <linux/mman.h>
 #include <linux/string.h>
 #include <linux/slab.h>
@@ -620,10 +620,8 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	setattr_copy(inode, attr);
-#ifdef CONFIG_TMPFS_POSIX_ACL
 	if (attr->ia_valid & ATTR_MODE)
-		error = generic_acl_chmod(inode);
-#endif
+		error = posix_acl_chmod(inode, inode->i_mode);
 	return error;
 }
 
@@ -1937,22 +1935,14 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 
 	inode = shmem_get_inode(dir->i_sb, dir, mode, dev, VM_NORESERVE);
 	if (inode) {
-#ifdef CONFIG_TMPFS_POSIX_ACL
-		error = generic_acl_init(inode, dir);
-		if (error) {
-			iput(inode);
-			return error;
-		}
-#endif
+		error = simple_acl_create(dir, inode);
+		if (error)
+			goto out_iput;
 		error = security_inode_init_security(inode, dir,
 						     &dentry->d_name,
 						     shmem_initxattrs, NULL);
-		if (error) {
-			if (error != -EOPNOTSUPP) {
-				iput(inode);
-				return error;
-			}
-		}
+		if (error && error != -EOPNOTSUPP)
+			goto out_iput;
 
 		error = 0;
 		dir->i_size += BOGO_DIRENT_SIZE;
@@ -1961,6 +1951,9 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 		dget(dentry); /* Extra count - pin the dentry in core */
 	}
 	return error;
+out_iput:
+	iput(inode);
+	return error;
 }
 
 static int
@@ -1974,24 +1967,17 @@ shmem_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 		error = security_inode_init_security(inode, dir,
 						     NULL,
 						     shmem_initxattrs, NULL);
-		if (error) {
-			if (error != -EOPNOTSUPP) {
-				iput(inode);
-				return error;
-			}
-		}
-#ifdef CONFIG_TMPFS_POSIX_ACL
-		error = generic_acl_init(inode, dir);
-		if (error) {
-			iput(inode);
-			return error;
-		}
-#else
-		error = 0;
-#endif
+		if (error && error != -EOPNOTSUPP)
+			goto out_iput;
+		error = simple_acl_create(dir, inode);
+		if (error)
+			goto out_iput;
 		d_tmpfile(dentry, inode);
 	}
 	return error;
+out_iput:
+	iput(inode);
+	return error;
 }
 
 static int shmem_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
@@ -2223,8 +2209,8 @@ static int shmem_initxattrs(struct inode *inode,
 
 static const struct xattr_handler *shmem_xattr_handlers[] = {
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	&generic_acl_access_handler,
-	&generic_acl_default_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 #endif
 	NULL
 };
@@ -2740,6 +2726,7 @@ static const struct inode_operations shmem_inode_operations = {
 	.getxattr	= shmem_getxattr,
 	.listxattr	= shmem_listxattr,
 	.removexattr	= shmem_removexattr,
+	.set_acl	= simple_set_acl,
 #endif
 };
 
@@ -2764,6 +2751,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_setattr,
+	.set_acl	= simple_set_acl,
 #endif
 };
 
@@ -2776,6 +2764,7 @@ static const struct inode_operations shmem_special_inode_operations = {
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_setattr,
+	.set_acl	= simple_set_acl,
 #endif
 };
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
