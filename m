Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1C337F3F
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 10:05:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A746B8F804B
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 08:05:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KqQDL8LSvPKfQnD2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 08:05:21 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 3/5] xfs: SGI ACLs: Fix caching and mode setting
Date: Fri, 30 Oct 2015 16:05:06 +0100
Message-Id: <1446217508-22157-4-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

POSIX ACLs on XFS are exposed as system.posix_acl_* as well as
trusted.SGI_ACL_* and via the XFS_IOC_ATTRMULTI_BY_HANDLE ioctl.
Setting the system attributes updates inode->i_mode, inode->i_acl, and
inode->i_default_acl as it should, but setting the trusted attributes
or using the ioctl does not.  Fix that by adding xattr handlers for the
two trusted.SGI_ACL_* attributes, and by rerouting the ioctl for these
attributes through the xattr code.

In xfs_xattr_handlers, the new handlers must be installed before the
trusted.* xattr to take effect.

Other than before, the values for those attributes are now verified on
all paths through which they can be set; invalid values are rejected.

Access to the trusted.SGI_ACL_* attributes and to the ioctl is still
limited to users capable of CAP_SYS_ADMIN, while the system.posix_acl_*
attributes can be read by anyone and set by the file owner.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.c   | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_acl.h   |  13 +++++++
 fs/xfs/xfs_ioctl.c |  56 +++++++++++++++++++++++++++-
 fs/xfs/xfs_xattr.c |  20 +++++++++-
 4 files changed, 186 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 763e365..c094165 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -178,7 +178,7 @@ out:
 }
 
 STATIC int
-__xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+___xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl, int xflags)
 {
 	struct xfs_inode *ip = XFS_I(inode);
 	unsigned char *ea_name;
@@ -212,14 +212,14 @@ __xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 
 		error = xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
-				len, ATTR_ROOT);
+				     len, xflags);
 
 		kmem_free(xfs_acl);
 	} else {
 		/*
 		 * A NULL ACL argument means we want to remove the ACL.
 		 */
-		error = xfs_attr_remove(ip, ea_name, ATTR_ROOT);
+		error = xfs_attr_remove(ip, ea_name, xflags);
 
 		/*
 		 * If the attribute didn't exist to start with that's fine.
@@ -274,8 +274,9 @@ posix_acl_default_exists(struct inode *inode)
 	return xfs_acl_exists(inode, SGI_ACL_DEFAULT);
 }
 
-int
-xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
+STATIC int
+__xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type,
+	      int xflags)
 {
 	int error = 0;
 
@@ -303,5 +304,97 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	}
 
  set_acl:
-	return __xfs_set_acl(inode, type, acl);
+	return ___xfs_set_acl(inode, type, acl, xflags);
+}
+
+int
+xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
+{
+	return __xfs_set_acl(inode, acl, type, ATTR_ROOT);
+}
+
+int
+__xfs_xattr_acl_get(struct inode *inode, int type, void *value, size_t size)
+{
+	struct posix_acl *acl;
+	int error;
+
+	if (!IS_POSIXACL(inode))
+		return -EOPNOTSUPP;
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	acl = get_acl(inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+
+	error = XFS_ACL_SIZE(acl->a_count);
+	if (value) {
+		if (error > size)
+			error = -ERANGE;
+		else
+			xfs_acl_to_disk(value, acl);
+	}
+
+	posix_acl_release(acl);
+	return error;
+}
+
+int
+xfs_xattr_acl_get(struct dentry *dentry, const char *name,
+		  void *value, size_t size, int type)
+{
+	struct inode *inode = d_inode(dentry);
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	return __xfs_xattr_acl_get(inode, type, value, size);
+}
+
+int
+__xfs_xattr_acl_set(struct inode *inode, int type, const void *value,
+		    size_t size, int xflags)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct posix_acl *acl = NULL;
+	int error;
+
+	if (!IS_POSIXACL(inode))
+		return -EOPNOTSUPP;
+
+	if (value) {
+		acl = xfs_acl_from_disk(value, size, XFS_ACL_MAX_ENTRIES(ip->i_mount));
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+
+		if (acl) {
+			error = posix_acl_valid(acl);
+			if (error)
+				goto out;
+		}
+	}
+
+	error = __xfs_set_acl(inode, acl, type, xflags);
+out:
+	posix_acl_release(acl);
+	return error;
+}
+
+int
+xfs_xattr_acl_set(struct dentry *dentry, const char *name,
+		  const void *value, size_t size, int flags, int type)
+{
+	struct inode *inode = d_inode(dentry);
+	int xflags = ATTR_ROOT;
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	if (flags & XATTR_CREATE)
+		xflags |= ATTR_CREATE;
+	if (flags & XATTR_REPLACE)
+		xflags |= ATTR_REPLACE;
+
+	return __xfs_xattr_acl_set(inode, type, value, size, xflags);
 }
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 3841b07..22986b6 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -19,6 +19,7 @@
 #define __XFS_ACL_H__
 
 struct inode;
+struct dentry;
 struct posix_acl;
 struct xfs_inode;
 
@@ -27,6 +28,18 @@ extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
 extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 extern int posix_acl_access_exists(struct inode *inode);
 extern int posix_acl_default_exists(struct inode *inode);
+
+extern int __xfs_xattr_acl_get(struct inode *inode, int type, void *value,
+			       size_t size);
+extern int __xfs_xattr_acl_set(struct inode *inode, int type, const void *value,
+			       size_t size, int xflags);
+
+extern int xfs_xattr_acl_get(struct dentry *dentry, const char *name,
+			     void *value, size_t size, int type);
+extern int xfs_xattr_acl_set(struct dentry *dentry, const char *name,
+			     const void *value, size_t size, int flags,
+			     int type);
+
 #else
 static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
 {
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e939c20..c819dfd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,6 +40,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans.h"
 #include "xfs_pnfs.h"
+#include "xfs_acl.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -48,6 +49,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/exportfs.h>
+#include <linux/posix_acl.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -453,15 +455,39 @@ xfs_attrmulti_attr_get(
 	__uint32_t		flags)
 {
 	unsigned char		*kbuf;
-	int			error = -EFAULT;
+	int			error;
 
 	if (*len > XATTR_SIZE_MAX)
 		return -EINVAL;
+
 	kbuf = kmem_zalloc_large(*len, KM_SLEEP);
 	if (!kbuf)
 		return -ENOMEM;
 
+#ifdef CONFIG_XFS_POSIX_ACL
+	if (flags & ATTR_ROOT) {
+		if (strcmp(name, SGI_ACL_FILE) == 0) {
+			error = __xfs_xattr_acl_get(inode, ACL_TYPE_ACCESS,
+						    kbuf, *len);
+			if (error > 0) {
+				*len = error;
+				error = 0;
+			}
+			goto done;
+		} else if (strcmp(name, SGI_ACL_DEFAULT) == 0) {
+			error = __xfs_xattr_acl_get(inode, ACL_TYPE_DEFAULT,
+						    kbuf, *len);
+			if (error > 0) {
+				*len = error;
+				error = 0;
+			}
+			goto done;
+		}
+	}
+#endif
+
 	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
+done:
 	if (error)
 		goto out_kfree;
 
@@ -493,7 +519,22 @@ xfs_attrmulti_attr_set(
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
+#ifdef CONFIG_XFS_POSIX_ACL
+	if (flags & ATTR_ROOT) {
+		if (strcmp(name, SGI_ACL_FILE) == 0) {
+			error = __xfs_xattr_acl_set(inode, ACL_TYPE_ACCESS,
+						    kbuf, len, flags);
+			goto out;
+		} else if (strcmp(name, SGI_ACL_DEFAULT) == 0) {
+			error = __xfs_xattr_acl_set(inode, ACL_TYPE_DEFAULT,
+						    kbuf, len, flags);
+			goto out;
+		}
+	}
+#endif
+
 	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
+out:
 	kfree(kbuf);
 	return error;
 }
@@ -506,6 +547,19 @@ xfs_attrmulti_attr_remove(
 {
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
+
+#ifdef CONFIG_XFS_POSIX_ACL
+	if (flags & ATTR_ROOT) {
+		if (strcmp(name, SGI_ACL_FILE) == 0) {
+			return __xfs_xattr_acl_set(inode, ACL_TYPE_ACCESS,
+						   NULL, 0, flags);
+		} else if (strcmp(name, SGI_ACL_DEFAULT) == 0) {
+			return __xfs_xattr_acl_set(inode, ACL_TYPE_DEFAULT,
+						   NULL, 0, flags);
+		}
+	}
+#endif
+
 	return xfs_attr_remove(XFS_I(inode), name, flags);
 }
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c0368151..d8ee7a1 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -95,14 +95,32 @@ static const struct xattr_handler xfs_xattr_security_handler = {
 	.set	= xfs_xattr_set,
 };
 
+#ifdef CONFIG_XFS_POSIX_ACL
+const struct xattr_handler xfs_xattr_sgi_acl_file = {
+	.prefix = XATTR_TRUSTED_PREFIX SGI_ACL_FILE,
+	.flags	= ACL_TYPE_ACCESS,
+	.get	= xfs_xattr_acl_get,
+	.set	= xfs_xattr_acl_set,
+};
+
+const struct xattr_handler xfs_xattr_sgi_acl_default = {
+	.prefix = XATTR_TRUSTED_PREFIX SGI_ACL_DEFAULT,
+	.flags	= ACL_TYPE_DEFAULT,
+	.get	= xfs_xattr_acl_get,
+	.set	= xfs_xattr_acl_set,
+};
+#endif
+
 const struct xattr_handler *xfs_xattr_handlers[] = {
 	&xfs_xattr_user_handler,
-	&xfs_xattr_trusted_handler,
 	&xfs_xattr_security_handler,
 #ifdef CONFIG_XFS_POSIX_ACL
 	&posix_acl_access_xattr_handler,
 	&posix_acl_default_xattr_handler,
+	&xfs_xattr_sgi_acl_file,
+	&xfs_xattr_sgi_acl_default,
 #endif
+	&xfs_xattr_trusted_handler,
 	NULL
 };
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
