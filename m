Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A72129E2C
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:20:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37CC38F8033
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:20:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WHlYGfiwgBp3Dy4Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:20:30 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v13 25/51] xfs: Add richacl support
Date: Tue,  3 Nov 2015 16:17:01 +0100
Message-Id: <1446563847-14005-26-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>

The richacl feature flag (mkfs.xfs -m richacl=1) determines whether an xfs
filesystem supports posix acls or richacls.  Richacls are stored in
"system.richacl" xattrs.

On the grounds that richacls add relatively little overhead compared to the
size of xfs itself, to keep the testing matrix small, and because xfs users
are highly likely to enable richacls anyway, richacl support cannot be
compiled out in xfs.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/Kconfig             |   1 +
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_format.h |  11 ++++-
 fs/xfs/xfs_iops.c          |  44 +++++++++++++++----
 fs/xfs/xfs_richacl.c       | 103 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_richacl.h       |  23 ++++++++++
 fs/xfs/xfs_super.c         |   6 ++-
 fs/xfs/xfs_super.h         |   4 ++
 fs/xfs/xfs_xattr.c         |  43 ++++++++++++++++---
 9 files changed, 218 insertions(+), 18 deletions(-)
 create mode 100644 fs/xfs/xfs_richacl.c
 create mode 100644 fs/xfs/xfs_richacl.h

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 5d47b4d..3fd00f8 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -4,6 +4,7 @@ config XFS_FS
 	depends on (64BIT || LBDAF)
 	select EXPORTFS
 	select LIBCRC32C
+	select FS_RICHACL
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a096841..1e6b984 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -84,6 +84,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
+				   xfs_richacl.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
 				   xfs_sysfs.o \
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9590a06..923247c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -461,10 +461,13 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
+#define XFS_SB_FEAT_INCOMPAT_RICHACL	(1 << 3)	/* richacls */
+
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
-		 XFS_SB_FEAT_INCOMPAT_META_UUID)
+		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
+		 XFS_SB_FEAT_INCOMPAT_RICHACL)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -530,6 +533,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
 }
 
+static inline bool xfs_sb_version_hasrichacl(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RICHACL);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8294132..9e4103b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -27,6 +27,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_acl.h"
+#include "xfs_richacl.h"
 #include "xfs_quota.h"
 #include "xfs_error.h"
 #include "xfs_attr.h"
@@ -42,6 +43,7 @@
 #include <linux/capability.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/richacl.h>
 #include <linux/security.h>
 #include <linux/fiemap.h>
 #include <linux/slab.h>
@@ -133,7 +135,8 @@ xfs_generic_create(
 {
 	struct inode	*inode;
 	struct xfs_inode *ip = NULL;
-	struct posix_acl *default_acl, *acl;
+	struct posix_acl *default_acl = NULL, *acl = NULL;
+	struct richacl *richacl = NULL;
 	struct xfs_name	name;
 	int		error;
 
@@ -149,9 +152,15 @@ xfs_generic_create(
 		rdev = 0;
 	}
 
-	error = posix_acl_create(dir, &mode, &default_acl, &acl);
-	if (error)
-		return error;
+	if (IS_RICHACL(dir)) {
+		richacl = richacl_create(&mode, dir);
+		if (IS_ERR(richacl))
+			return PTR_ERR(richacl);
+	} else {
+		error = posix_acl_create(dir, &mode, &default_acl, &acl);
+		if (error)
+			return error;
+	}
 
 	if (!tmpfile) {
 		xfs_dentry_to_name(&name, dentry, mode);
@@ -180,6 +189,11 @@ xfs_generic_create(
 			goto out_cleanup_inode;
 	}
 #endif
+	if (richacl) {
+		error = xfs_set_richacl(inode, richacl);
+		if (error)
+			goto out_cleanup_inode;
+	}
 
 	if (tmpfile)
 		d_tmpfile(dentry, inode);
@@ -189,10 +203,9 @@ xfs_generic_create(
 	xfs_finish_inode_setup(ip);
 
  out_free_acl:
-	if (default_acl)
-		posix_acl_release(default_acl);
-	if (acl)
-		posix_acl_release(acl);
+	posix_acl_release(default_acl);
+	posix_acl_release(acl);
+	richacl_put(richacl);
 	return error;
 
  out_cleanup_inode:
@@ -534,6 +547,13 @@ xfs_setattr_time(
 	}
 }
 
+static inline int
+xfs_acl_chmod(struct inode *inode, umode_t mode)
+{
+	if (IS_RICHACL(inode))
+		return richacl_chmod(inode, inode->i_mode);
+	return posix_acl_chmod(inode, inode->i_mode);
+}
 int
 xfs_setattr_nonsize(
 	struct xfs_inode	*ip,
@@ -722,7 +742,7 @@ xfs_setattr_nonsize(
 	 * 	     Posix ACL code seems to care about this issue either.
 	 */
 	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
-		error = posix_acl_chmod(inode, inode->i_mode);
+		error = xfs_acl_chmod(inode, inode->i_mode);
 		if (error)
 			return error;
 	}
@@ -1104,6 +1124,8 @@ xfs_vn_tmpfile(
 static const struct inode_operations xfs_inode_operations = {
 	.get_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
+	.get_richacl		= xfs_get_richacl,
+	.set_richacl		= xfs_set_richacl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -1132,6 +1154,8 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.rename2		= xfs_vn_rename,
 	.get_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
+	.get_richacl		= xfs_get_richacl,
+	.set_richacl		= xfs_set_richacl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -1160,6 +1184,8 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.rename2		= xfs_vn_rename,
 	.get_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
+	.get_richacl		= xfs_get_richacl,
+	.set_richacl		= xfs_set_richacl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
diff --git a/fs/xfs/xfs_richacl.c b/fs/xfs/xfs_richacl.c
new file mode 100644
index 0000000..92a036e
--- /dev/null
+++ b/fs/xfs/xfs_richacl.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Author: Andreas Gruenbacher <agruenba@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include "xfs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_inode.h"
+#include "xfs_attr.h"
+
+#include <linux/xattr.h>
+#include <linux/richacl_xattr.h>
+
+struct richacl *
+xfs_get_richacl(struct inode *inode)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct richacl *acl = NULL;
+	int size = XATTR_SIZE_MAX;
+	void *value;
+	int error;
+
+	value = kmem_zalloc_large(size, KM_SLEEP);
+	if (!value)
+		return ERR_PTR(-ENOMEM);
+
+	error = xfs_attr_get(ip, XATTR_RICHACL, value, &size, ATTR_ROOT);
+	if (error) {
+		/*
+		 * If the attribute doesn't exist make sure we have a negative
+		 * cache entry, for any other error assume it is transient and
+		 * leave the cache entry as ACL_NOT_CACHED.
+		 */
+		if (error != -ENOATTR)
+			acl = ERR_PTR(error);
+	} else
+		acl = richacl_from_xattr(&init_user_ns, value, size);
+
+	if (!IS_ERR(acl))
+		set_cached_richacl(inode, acl);
+	kfree(value);
+
+	return acl;
+}
+
+static int
+xfs_remove_richacl(struct inode *inode)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	int error;
+
+	error = xfs_attr_remove(ip, XATTR_RICHACL, ATTR_ROOT);
+	if (error == -ENOATTR)
+		error = 0;
+	if (!error)
+		set_cached_richacl(inode, NULL);
+	return error;
+}
+
+int
+xfs_set_richacl(struct inode *inode, struct richacl *acl)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	umode_t mode = inode->i_mode;
+	int error, size;
+	void *value;
+
+	if (!acl)
+		return xfs_remove_richacl(inode);
+
+	if (richacl_equiv_mode(acl, &mode) == 0) {
+		xfs_set_mode(inode, mode);
+		return xfs_remove_richacl(inode);
+	}
+
+	size = richacl_xattr_size(acl);
+	value = kmem_zalloc_large(size, KM_SLEEP);
+	if (!value)
+		return -ENOMEM;
+	richacl_to_xattr(&init_user_ns, acl, value, size);
+	error = xfs_attr_set(ip, XATTR_RICHACL, value, size,
+			     ATTR_ROOT);
+	kfree(value);
+	if (error)
+		return error;
+
+	mode &= ~S_IRWXUGO;
+	mode |= richacl_masks_to_mode(acl);
+	xfs_set_mode(inode, mode);
+	set_cached_richacl(inode, acl);
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_richacl.h b/fs/xfs/xfs_richacl.h
new file mode 100644
index 0000000..431aa25
--- /dev/null
+++ b/fs/xfs/xfs_richacl.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C)  2015 Red Hat, Inc.
+ * Author: Andreas Gruenbacher <agruenba@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#ifndef __FS_XFS_RICHACL_H
+#define __FS_XFS_RICHACL_H
+
+struct richacl;
+
+extern struct richacl *xfs_get_richacl(struct inode *);
+extern int xfs_set_richacl(struct inode *, struct richacl *);
+
+#endif  /* __FS_XFS_RICHACL_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 904f637..f82ce1a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1500,7 +1500,11 @@ xfs_fs_fill_super(
 	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
-	set_posix_acl_flag(sb);
+
+	if (xfs_sb_version_hasrichacl(&mp->m_sb))
+		set_richacl_flag(sb);
+	else
+		set_posix_acl_flag(sb);
 
 	/* version 5 superblocks support inode version counters. */
 	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 499058f..7ae21d9 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -36,6 +36,9 @@ extern void xfs_qm_exit(void);
 # define set_posix_acl_flag(sb)	do { } while (0)
 #endif
 
+# define XFS_RICHACL_STRING	"Richacls, "
+# define set_richacl_flag(sb)	((sb)->s_flags |= MS_RICHACL)
+
 #define XFS_SECURITY_STRING	"security attributes, "
 
 #ifdef CONFIG_XFS_RT
@@ -52,6 +55,7 @@ extern void xfs_qm_exit(void);
 
 #define XFS_VERSION_STRING	"SGI XFS"
 #define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
+				XFS_RICHACL_STRING \
 				XFS_SECURITY_STRING \
 				XFS_REALTIME_STRING \
 				XFS_DBG_STRING /* DBG must be last */
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 8428aed..64aac05 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -28,6 +28,7 @@
 #include "xfs_acl.h"
 
 #include <linux/posix_acl_xattr.h>
+#include <linux/richacl_xattr.h>
 #include <linux/xattr.h>
 
 
@@ -74,6 +75,24 @@ xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 				(void *)value, size, xflags);
 }
 
+static int
+xfs_xattr_get_trusted(struct dentry *dentry, const char *name,
+		      void *value, size_t size, int xflags)
+{
+	if (strcmp(name, XATTR_RICHACL) == 0)
+		return -EOPNOTSUPP;
+	return xfs_xattr_get(dentry, name, value, size, xflags);
+}
+
+static int
+xfs_xattr_set_trusted(struct dentry *dentry, const char *name,
+		      const void *value, size_t size, int flags, int xflags)
+{
+	if (strcmp(name, XATTR_RICHACL) == 0)
+		return -EOPNOTSUPP;
+	return xfs_xattr_set(dentry, name, value, size, flags, xflags);
+}
+
 static const struct xattr_handler xfs_xattr_user_handler = {
 	.prefix	= XATTR_USER_PREFIX,
 	.flags	= 0, /* no flags implies user namespace */
@@ -84,8 +103,8 @@ static const struct xattr_handler xfs_xattr_user_handler = {
 static const struct xattr_handler xfs_xattr_trusted_handler = {
 	.prefix	= XATTR_TRUSTED_PREFIX,
 	.flags	= ATTR_ROOT,
-	.get	= xfs_xattr_get,
-	.set	= xfs_xattr_set,
+	.get	= xfs_xattr_get_trusted,
+	.set	= xfs_xattr_set_trusted,
 };
 
 static const struct xattr_handler xfs_xattr_security_handler = {
@@ -103,6 +122,7 @@ const struct xattr_handler *xfs_xattr_handlers[] = {
 	&posix_acl_access_xattr_handler,
 	&posix_acl_default_xattr_handler,
 #endif
+	&richacl_xattr_handler,
 	NULL
 };
 
@@ -152,10 +172,10 @@ xfs_xattr_put_listent(
 	ASSERT(context->count >= 0);
 
 	if (flags & XFS_ATTR_ROOT) {
-#ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&
 		    strncmp(name, SGI_ACL_FILE,
-			    SGI_ACL_FILE_SIZE) == 0) {
+			    SGI_ACL_FILE_SIZE) == 0 &&
+		    IS_POSIXACL(&context->dp->i_vnode)) {
 			int ret = __xfs_xattr_put_listent(
 					context, XATTR_SYSTEM_PREFIX,
 					XATTR_SYSTEM_PREFIX_LEN,
@@ -164,8 +184,9 @@ xfs_xattr_put_listent(
 			if (ret)
 				return ret;
 		} else if (namelen == SGI_ACL_DEFAULT_SIZE &&
-			 strncmp(name, SGI_ACL_DEFAULT,
-				 SGI_ACL_DEFAULT_SIZE) == 0) {
+			   strncmp(name, SGI_ACL_DEFAULT,
+				   SGI_ACL_DEFAULT_SIZE) == 0 &&
+			   IS_POSIXACL(&context->dp->i_vnode)) {
 			int ret = __xfs_xattr_put_listent(
 					context, XATTR_SYSTEM_PREFIX,
 					XATTR_SYSTEM_PREFIX_LEN,
@@ -173,8 +194,16 @@ xfs_xattr_put_listent(
 					strlen(XATTR_POSIX_ACL_DEFAULT));
 			if (ret)
 				return ret;
+		} else if (namelen == strlen(XATTR_RICHACL) &&
+			   strncmp(name, XATTR_RICHACL,
+				   strlen(XATTR_RICHACL)) == 0 &&
+			   IS_RICHACL(&context->dp->i_vnode)) {
+			return __xfs_xattr_put_listent(
+					context, XATTR_SYSTEM_PREFIX,
+					XATTR_SYSTEM_PREFIX_LEN,
+					XATTR_RICHACL,
+					strlen(XATTR_RICHACL));
 		}
-#endif
 
 		/*
 		 * Only show root namespace entries if we are actually allowed to
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
