Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E858D7F60
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 06:07:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA6E1304053
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 04:07:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 61CcVlioDvHJbcDL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Dec 2013 04:07:12 -0800 (PST)
Message-Id: <20131201120656.391407780@bombadil.infradead.org>
Date: Sun, 01 Dec 2013 03:59:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 15/18] jfs: use generic posix ACL infrastructure
References: <20131201115903.910559036@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0015-jfs-use-generic-posix-ACL-infrastructure.patch
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
Cc: xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Copy the scheme I introduced to btrfs many years ago to only use the
xattr handler for ACLs, but pass plain attrs straight through.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/jfs/acl.c       |  105 ++++++++++++++++++++------------------------------
 fs/jfs/file.c      |    4 +-
 fs/jfs/jfs_acl.h   |    7 +---
 fs/jfs/jfs_xattr.h |    2 +
 fs/jfs/namei.c     |    1 +
 fs/jfs/super.c     |    2 +
 fs/jfs/xattr.c     |  108 ++++++++++++++++++----------------------------------
 7 files changed, 89 insertions(+), 140 deletions(-)

diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 28d529a..e973b85 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -72,7 +72,7 @@ struct posix_acl *jfs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int jfs_set_acl(tid_t tid, struct inode *inode, int type,
+static int __jfs_set_acl(tid_t tid, struct inode *inode, int type,
 		       struct posix_acl *acl)
 {
 	char *ea_name;
@@ -80,21 +80,22 @@ static int jfs_set_acl(tid_t tid, struct inode *inode, int type,
 	int size = 0;
 	char *value = NULL;
 
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	switch(type) {
-		case ACL_TYPE_ACCESS:
-			ea_name = POSIX_ACL_XATTR_ACCESS;
-			break;
-		case ACL_TYPE_DEFAULT:
-			ea_name = POSIX_ACL_XATTR_DEFAULT;
-			if (!S_ISDIR(inode->i_mode))
-				return acl ? -EACCES : 0;
-			break;
-		default:
-			return -EINVAL;
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		ea_name = POSIX_ACL_XATTR_ACCESS;
+		rc = posix_acl_equiv_mode(acl, &inode->i_mode);
+		if (rc < 0)
+			return rc;
+		if (rc == 0)
+			acl = NULL;
+		break;
+	case ACL_TYPE_DEFAULT:
+		ea_name = POSIX_ACL_XATTR_DEFAULT;
+		break;
+	default:
+		return -EINVAL;
 	}
+
 	if (acl) {
 		size = posix_acl_xattr_size(acl->a_count);
 		value = kmalloc(size, GFP_KERNEL);
@@ -114,65 +115,43 @@ out:
 	return rc;
 }
 
+int jfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
+{
+	int rc;
+	tid_t tid;
+
+	tid = txBegin(inode->i_sb, 0);
+	mutex_lock(&JFS_IP(inode)->commit_mutex);
+	rc = __jfs_set_acl(tid, inode, type, acl);
+	if (!rc)
+		rc = txCommit(tid, 1, &inode, 0);
+	txEnd(tid);
+	mutex_unlock(&JFS_IP(inode)->commit_mutex);
+	return rc;
+}
+
 int jfs_init_acl(tid_t tid, struct inode *inode, struct inode *dir)
 {
-	struct posix_acl *acl = NULL;
+	struct posix_acl *default_acl, *acl;
 	int rc = 0;
 
-	if (S_ISLNK(inode->i_mode))
-		return 0;
+	rc = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+	if (rc)
+		return rc;
 
-	acl = jfs_get_acl(dir, ACL_TYPE_DEFAULT);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
+	if (default_acl) {
+		rc = __jfs_set_acl(tid, inode, ACL_TYPE_DEFAULT, default_acl);
+		posix_acl_release(default_acl);
+	}
 
 	if (acl) {
-		if (S_ISDIR(inode->i_mode)) {
-			rc = jfs_set_acl(tid, inode, ACL_TYPE_DEFAULT, acl);
-			if (rc)
-				goto cleanup;
-		}
-		rc = __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
-		if (rc < 0)
-			goto cleanup; /* posix_acl_release(NULL) is no-op */
-		if (rc > 0)
-			rc = jfs_set_acl(tid, inode, ACL_TYPE_ACCESS, acl);
-cleanup:
+		if (!rc)
+			rc = __jfs_set_acl(tid, inode, ACL_TYPE_ACCESS, acl);
 		posix_acl_release(acl);
-	} else
-		inode->i_mode &= ~current_umask();
+	}
 
 	JFS_IP(inode)->mode2 = (JFS_IP(inode)->mode2 & 0xffff0000) |
 			       inode->i_mode;
 
 	return rc;
 }
-
-int jfs_acl_chmod(struct inode *inode)
-{
-	struct posix_acl *acl;
-	int rc;
-	tid_t tid;
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	acl = jfs_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl) || !acl)
-		return PTR_ERR(acl);
-
-	rc = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
-	if (rc)
-		return rc;
-
-	tid = txBegin(inode->i_sb, 0);
-	mutex_lock(&JFS_IP(inode)->commit_mutex);
-	rc = jfs_set_acl(tid, inode, ACL_TYPE_ACCESS, acl);
-	if (!rc)
-		rc = txCommit(tid, 1, &inode, 0);
-	txEnd(tid);
-	mutex_unlock(&JFS_IP(inode)->commit_mutex);
-
-	posix_acl_release(acl);
-	return rc;
-}
diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index dd7442c..145a17e 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -19,6 +19,7 @@
 
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/posix_acl.h>
 #include <linux/quotaops.h>
 #include "jfs_incore.h"
 #include "jfs_inode.h"
@@ -131,7 +132,7 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	mark_inode_dirty(inode);
 
 	if (iattr->ia_valid & ATTR_MODE)
-		rc = jfs_acl_chmod(inode);
+		rc = posix_acl_chmod(inode);
 	return rc;
 }
 
@@ -143,6 +144,7 @@ const struct inode_operations jfs_file_inode_operations = {
 	.setattr	= jfs_setattr,
 #ifdef CONFIG_JFS_POSIX_ACL
 	.get_acl	= jfs_get_acl,
+	.set_acl	= jfs_set_acl,
 #endif
 };
 
diff --git a/fs/jfs/jfs_acl.h b/fs/jfs/jfs_acl.h
index ad84fe5..489f993 100644
--- a/fs/jfs/jfs_acl.h
+++ b/fs/jfs/jfs_acl.h
@@ -21,8 +21,8 @@
 #ifdef CONFIG_JFS_POSIX_ACL
 
 struct posix_acl *jfs_get_acl(struct inode *inode, int type);
+int jfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 int jfs_init_acl(tid_t, struct inode *, struct inode *);
-int jfs_acl_chmod(struct inode *inode);
 
 #else
 
@@ -32,10 +32,5 @@ static inline int jfs_init_acl(tid_t tid, struct inode *inode,
 	return 0;
 }
 
-static inline int jfs_acl_chmod(struct inode *inode)
-{
-	return 0;
-}
-
 #endif
 #endif		/* _H_JFS_ACL */
diff --git a/fs/jfs/jfs_xattr.h b/fs/jfs/jfs_xattr.h
index e9e100f..e8d717d 100644
--- a/fs/jfs/jfs_xattr.h
+++ b/fs/jfs/jfs_xattr.h
@@ -61,6 +61,8 @@ extern ssize_t jfs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t jfs_listxattr(struct dentry *, char *, size_t);
 extern int jfs_removexattr(struct dentry *, const char *);
 
+extern const struct xattr_handler *jfs_xattr_handlers[];
+
 #ifdef CONFIG_JFS_SECURITY
 extern int jfs_init_security(tid_t, struct inode *, struct inode *,
 			     const struct qstr *);
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index aa8a337..d59c7de 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1524,6 +1524,7 @@ const struct inode_operations jfs_dir_inode_operations = {
 	.setattr	= jfs_setattr,
 #ifdef CONFIG_JFS_POSIX_ACL
 	.get_acl	= jfs_get_acl,
+	.set_acl	= jfs_set_acl,
 #endif
 };
 
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 6669aa2..e2b7483 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -44,6 +44,7 @@
 #include "jfs_imap.h"
 #include "jfs_acl.h"
 #include "jfs_debug.h"
+#include "jfs_xattr.h"
 
 MODULE_DESCRIPTION("The Journaled Filesystem (JFS)");
 MODULE_AUTHOR("Steve Best/Dave Kleikamp/Barry Arndt, IBM");
@@ -522,6 +523,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	sb->s_op = &jfs_super_operations;
 	sb->s_export_op = &jfs_export_operations;
+	sb->s_xattr = jfs_xattr_handlers;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &dquot_operations;
 	sb->s_qcop = &dquot_quotactl_ops;
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index d3472f4..5324e4e 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -666,81 +666,12 @@ static int ea_put(tid_t tid, struct inode *inode, struct ea_buffer *ea_buf,
 }
 
 /*
- * can_set_system_xattr
- *
- * This code is specific to the system.* namespace.  It contains policy
- * which doesn't belong in the main xattr codepath.
- */
-static int can_set_system_xattr(struct inode *inode, const char *name,
-				const void *value, size_t value_len)
-{
-#ifdef CONFIG_JFS_POSIX_ACL
-	struct posix_acl *acl;
-	int rc;
-
-	if (!inode_owner_or_capable(inode))
-		return -EPERM;
-
-	/*
-	 * POSIX_ACL_XATTR_ACCESS is tied to i_mode
-	 */
-	if (strcmp(name, POSIX_ACL_XATTR_ACCESS) == 0) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, value_len);
-		if (IS_ERR(acl)) {
-			rc = PTR_ERR(acl);
-			printk(KERN_ERR "posix_acl_from_xattr returned %d\n",
-			       rc);
-			return rc;
-		}
-		if (acl) {
-			rc = posix_acl_equiv_mode(acl, &inode->i_mode);
-			posix_acl_release(acl);
-			if (rc < 0) {
-				printk(KERN_ERR
-				       "posix_acl_equiv_mode returned %d\n",
-				       rc);
-				return rc;
-			}
-			mark_inode_dirty(inode);
-		}
-		/*
-		 * We're changing the ACL.  Get rid of the cached one
-		 */
-		forget_cached_acl(inode, ACL_TYPE_ACCESS);
-
-		return 0;
-	} else if (strcmp(name, POSIX_ACL_XATTR_DEFAULT) == 0) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, value_len);
-		if (IS_ERR(acl)) {
-			rc = PTR_ERR(acl);
-			printk(KERN_ERR "posix_acl_from_xattr returned %d\n",
-			       rc);
-			return rc;
-		}
-		posix_acl_release(acl);
-
-		/*
-		 * We're changing the default ACL.  Get rid of the cached one
-		 */
-		forget_cached_acl(inode, ACL_TYPE_DEFAULT);
-
-		return 0;
-	}
-#endif			/* CONFIG_JFS_POSIX_ACL */
-	return -EOPNOTSUPP;
-}
-
-/*
  * Most of the permission checking is done by xattr_permission in the vfs.
- * The local file system is responsible for handling the system.* namespace.
  * We also need to verify that this is a namespace that we recognize.
  */
 static int can_set_xattr(struct inode *inode, const char *name,
 			 const void *value, size_t value_len)
 {
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return can_set_system_xattr(inode, name, value, value_len);
-
 	if (!strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)) {
 		/*
 		 * This makes sure that we aren't trying to set an
@@ -748,7 +679,7 @@ static int can_set_xattr(struct inode *inode, const char *name,
 		 * with "os2."
 		 */
 		if (is_known_namespace(name + XATTR_OS2_PREFIX_LEN))
-				return -EOPNOTSUPP;
+			return -EOPNOTSUPP;
 		return 0;
 	}
 
@@ -913,6 +844,14 @@ int jfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	if ((rc = can_set_xattr(inode, name, value, value_len)))
 		return rc;
 
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_setxattr(dentry, name, value, value_len, flags);
+
 	if (value == NULL) {	/* empty EA, do not remove */
 		value = "";
 		value_len = 0;
@@ -986,6 +925,14 @@ ssize_t jfs_getxattr(struct dentry *dentry, const char *name, void *data,
 {
 	int err;
 
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_getxattr(dentry, name, data, buf_size);
+
 	if (strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
 		/*
 		 * skip past "os2." prefix
@@ -1077,6 +1024,14 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
 	if ((rc = can_set_xattr(inode, name, NULL, 0)))
 		return rc;
 
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_removexattr(dentry, name);
+
 	tid = txBegin(inode->i_sb, 0);
 	mutex_lock(&ji->commit_mutex);
 	rc = __jfs_setxattr(tid, dentry->d_inode, name, NULL, 0, XATTR_REPLACE);
@@ -1088,6 +1043,19 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
 	return rc;
 }
 
+/*
+ * List of handlers for synthetic system.* attributes.  All real ondisk
+ * attributes are handled directly.
+ */
+const struct xattr_handler *jfs_xattr_handlers[] = {
+#ifdef JFS_POSIX_ACL
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
+#endif
+	NULL,
+};
+
+
 #ifdef CONFIG_JFS_SECURITY
 static int jfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 			  void *fs_info)
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
