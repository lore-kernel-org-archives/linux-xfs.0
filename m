Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2C4708017
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 04:45:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 19EDD8F804C
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 02:45:40 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LT9BHysGGhFlKsvJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 02:45:38 -0800 (PST)
Message-Id: <20131211104527.626509181@bombadil.infradead.org>
Date: Wed, 11 Dec 2013 02:42:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/18] btrfs: use generic posix ACL infrastructure
References: <20131211104243.148113893@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0007-btrfs-use-generic-posix-ACL-infrastructure.patch
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

Also don't bother to set up a .get_acl method for symlinks as we do not
support access control (ACLs or even mode bits) for symlinks in Linux.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/acl.c   |  142 +++++++-----------------------------------------------
 fs/btrfs/ctree.h |    7 +--
 fs/btrfs/inode.c |    7 ++-
 fs/btrfs/xattr.c |    5 +-
 fs/btrfs/xattr.h |    2 -
 5 files changed, 28 insertions(+), 135 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index b56519d..ff9b399 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -35,13 +35,6 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	char *value = NULL;
 	struct posix_acl *acl;
 
-	if (!IS_POSIXACL(inode))
-		return NULL;
-
-	acl = get_cached_acl(inode, type);
-	if (acl != ACL_NOT_CACHED)
-		return acl;
-
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name = POSIX_ACL_XATTR_ACCESS;
@@ -76,31 +69,10 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int btrfs_xattr_acl_get(struct dentry *dentry, const char *name,
-		void *value, size_t size, int type)
-{
-	struct posix_acl *acl;
-	int ret = 0;
-
-	if (!IS_POSIXACL(dentry->d_inode))
-		return -EOPNOTSUPP;
-
-	acl = btrfs_get_acl(dentry->d_inode, type);
-
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl == NULL)
-		return -ENODATA;
-	ret = posix_acl_to_xattr(&init_user_ns, acl, value, size);
-	posix_acl_release(acl);
-
-	return ret;
-}
-
 /*
  * Needs to be called with fs_mutex held
  */
-static int btrfs_set_acl(struct btrfs_trans_handle *trans,
+static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 			 struct inode *inode, struct posix_acl *acl, int type)
 {
 	int ret, size = 0;
@@ -158,35 +130,9 @@ out:
 	return ret;
 }
 
-static int btrfs_xattr_acl_set(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags, int type)
+int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
-	int ret;
-	struct posix_acl *acl = NULL;
-
-	if (!inode_owner_or_capable(dentry->d_inode))
-		return -EPERM;
-
-	if (!IS_POSIXACL(dentry->d_inode))
-		return -EOPNOTSUPP;
-
-	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-
-		if (acl) {
-			ret = posix_acl_valid(acl);
-			if (ret)
-				goto out;
-		}
-	}
-
-	ret = btrfs_set_acl(NULL, dentry->d_inode, acl, type);
-out:
-	posix_acl_release(acl);
-
-	return ret;
+	return __btrfs_set_acl(NULL, inode, acl, type);
 }
 
 /*
@@ -197,83 +143,31 @@ out:
 int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		   struct inode *inode, struct inode *dir)
 {
-	struct posix_acl *acl = NULL;
+	struct posix_acl *default_acl, *acl;
 	int ret = 0;
 
 	/* this happens with subvols */
 	if (!dir)
 		return 0;
 
-	if (!S_ISLNK(inode->i_mode)) {
-		if (IS_POSIXACL(dir)) {
-			acl = btrfs_get_acl(dir, ACL_TYPE_DEFAULT);
-			if (IS_ERR(acl))
-				return PTR_ERR(acl);
-		}
+	ret = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+	if (ret)
+		return ret;
 
-		if (!acl)
-			inode->i_mode &= ~current_umask();
+	if (default_acl) {
+		ret = __btrfs_set_acl(trans, inode, default_acl,
+				      ACL_TYPE_DEFAULT);
+		posix_acl_release(default_acl);
 	}
 
-	if (IS_POSIXACL(dir) && acl) {
-		if (S_ISDIR(inode->i_mode)) {
-			ret = btrfs_set_acl(trans, inode, acl,
-					    ACL_TYPE_DEFAULT);
-			if (ret)
-				goto failed;
-		}
-		ret = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
-		if (ret < 0)
-			return ret;
-
-		if (ret > 0) {
-			/* we need an acl */
-			ret = btrfs_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
-		} else if (ret < 0) {
-			cache_no_acl(inode);
-		}
-	} else {
-		cache_no_acl(inode);
+	if (acl) {
+		if (!ret)
+			ret = __btrfs_set_acl(trans, inode, acl,
+					      ACL_TYPE_ACCESS);
+		posix_acl_release(acl);
 	}
-failed:
-	posix_acl_release(acl);
-
-	return ret;
-}
 
-int btrfs_acl_chmod(struct inode *inode)
-{
-	struct posix_acl *acl;
-	int ret = 0;
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	if (!IS_POSIXACL(inode))
-		return 0;
-
-	acl = btrfs_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR_OR_NULL(acl))
-		return PTR_ERR(acl);
-
-	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
-	if (ret)
-		return ret;
-	ret = btrfs_set_acl(NULL, inode, acl, ACL_TYPE_ACCESS);
-	posix_acl_release(acl);
+	if (!default_acl && !acl)
+		cache_no_acl(inode);
 	return ret;
 }
-
-const struct xattr_handler btrfs_xattr_acl_default_handler = {
-	.prefix = POSIX_ACL_XATTR_DEFAULT,
-	.flags	= ACL_TYPE_DEFAULT,
-	.get	= btrfs_xattr_acl_get,
-	.set	= btrfs_xattr_acl_set,
-};
-
-const struct xattr_handler btrfs_xattr_acl_access_handler = {
-	.prefix = POSIX_ACL_XATTR_ACCESS,
-	.flags	= ACL_TYPE_ACCESS,
-	.get	= btrfs_xattr_acl_get,
-	.set	= btrfs_xattr_acl_set,
-};
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 54ab861..7506825 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3899,20 +3899,17 @@ do {									\
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type);
+int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		   struct inode *inode, struct inode *dir);
-int btrfs_acl_chmod(struct inode *inode);
 #else
 #define btrfs_get_acl NULL
+#define btrfs_set_acl NULL
 static inline int btrfs_init_acl(struct btrfs_trans_handle *trans,
 				 struct inode *inode, struct inode *dir)
 {
 	return 0;
 }
-static inline int btrfs_acl_chmod(struct inode *inode)
-{
-	return 0;
-}
 #endif
 
 /* relocation.c */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1a7744..b131430 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4464,7 +4464,7 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 		err = btrfs_dirty_inode(inode);
 
 		if (!err && attr->ia_valid & ATTR_MODE)
-			err = btrfs_acl_chmod(inode);
+			err = posix_acl_chmod(inode, inode->i_mode);
 	}
 
 	return err;
@@ -8649,12 +8649,14 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
+	.set_acl	= btrfs_set_acl,
 	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.lookup		= btrfs_lookup,
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
+	.set_acl	= btrfs_set_acl,
 	.update_time	= btrfs_update_time,
 };
 
@@ -8724,6 +8726,7 @@ static const struct inode_operations btrfs_file_inode_operations = {
 	.permission	= btrfs_permission,
 	.fiemap		= btrfs_fiemap,
 	.get_acl	= btrfs_get_acl,
+	.set_acl	= btrfs_set_acl,
 	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_special_inode_operations = {
@@ -8735,6 +8738,7 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 	.get_acl	= btrfs_get_acl,
+	.set_acl	= btrfs_set_acl,
 	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_symlink_inode_operations = {
@@ -8748,7 +8752,6 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.getxattr	= btrfs_getxattr,
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
-	.get_acl	= btrfs_get_acl,
 	.update_time	= btrfs_update_time,
 };
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 05740b9..3d1c301 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -22,6 +22,7 @@
 #include <linux/rwsem.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
+#include <linux/posix_acl_xattr.h>
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
@@ -313,8 +314,8 @@ err:
  */
 const struct xattr_handler *btrfs_xattr_handlers[] = {
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
-	&btrfs_xattr_acl_access_handler,
-	&btrfs_xattr_acl_default_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 #endif
 	NULL,
 };
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index b3cc803..5049608 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -21,8 +21,6 @@
 
 #include <linux/xattr.h>
 
-extern const struct xattr_handler btrfs_xattr_acl_access_handler;
-extern const struct xattr_handler btrfs_xattr_acl_default_handler;
 extern const struct xattr_handler *btrfs_xattr_handlers[];
 
 extern ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
