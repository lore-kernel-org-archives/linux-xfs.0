Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 571E38012
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 04:45:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4544C30406B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 02:45:40 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QZaO2uA1Gs2HnCAH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 02:45:39 -0800 (PST)
Message-Id: <20131211104528.172529459@bombadil.infradead.org>
Date: Wed, 11 Dec 2013 02:42:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/18] hfsplus: use generic posix ACL infrastructure
References: <20131211104243.148113893@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0010-hfsplus-use-generic-posix-ACL-infrastructure.patch
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
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Vyacheslav Dubeyko <slava@dubeyko.com>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 fs/hfsplus/acl.h       |    9 +--
 fs/hfsplus/dir.c       |    1 +
 fs/hfsplus/inode.c     |    3 +-
 fs/hfsplus/posix_acl.c |  168 +++++-------------------------------------------
 fs/hfsplus/xattr.c     |    5 +-
 fs/hfsplus/xattr.h     |    2 -
 6 files changed, 26 insertions(+), 162 deletions(-)

diff --git a/fs/hfsplus/acl.h b/fs/hfsplus/acl.h
index 07c0d49..95c8ed9 100644
--- a/fs/hfsplus/acl.h
+++ b/fs/hfsplus/acl.h
@@ -12,16 +12,13 @@
 
 /* posix_acl.c */
 struct posix_acl *hfsplus_get_posix_acl(struct inode *inode, int type);
-extern int hfsplus_posix_acl_chmod(struct inode *);
+int hfsplus_set_posix_acl(struct inode *inode, struct posix_acl *acl,
+		int type);
 extern int hfsplus_init_posix_acl(struct inode *, struct inode *);
 
 #else  /* CONFIG_HFSPLUS_FS_POSIX_ACL */
 #define hfsplus_get_posix_acl NULL
-
-static inline int hfsplus_posix_acl_chmod(struct inode *inode)
-{
-	return 0;
-}
+#define hfsplus_set_posix_acl NULL
 
 static inline int hfsplus_init_posix_acl(struct inode *inode, struct inode *dir)
 {
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 4a4fea0..9ee6298 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -532,6 +532,7 @@ const struct inode_operations hfsplus_dir_inode_operations = {
 	.removexattr		= hfsplus_removexattr,
 #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
 	.get_acl		= hfsplus_get_posix_acl,
+	.set_acl		= hfsplus_set_posix_acl,
 #endif
 };
 
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 37213d0..2e10993 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -319,7 +319,7 @@ static int hfsplus_setattr(struct dentry *dentry, struct iattr *attr)
 	mark_inode_dirty(inode);
 
 	if (attr->ia_valid & ATTR_MODE) {
-		error = hfsplus_posix_acl_chmod(inode);
+		error = posix_acl_chmod(inode, inode->i_mode);
 		if (unlikely(error))
 			return error;
 	}
@@ -393,6 +393,7 @@ static const struct inode_operations hfsplus_file_inode_operations = {
 	.removexattr	= hfsplus_removexattr,
 #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
 	.get_acl	= hfsplus_get_posix_acl,
+	.set_acl	= hfsplus_set_posix_acl,
 #endif
 };
 
diff --git a/fs/hfsplus/posix_acl.c b/fs/hfsplus/posix_acl.c
index 277942f..df0c9af 100644
--- a/fs/hfsplus/posix_acl.c
+++ b/fs/hfsplus/posix_acl.c
@@ -17,9 +17,7 @@ struct posix_acl *hfsplus_get_posix_acl(struct inode *inode, int type)
 	char *value = NULL;
 	ssize_t size;
 
-	acl = get_cached_acl(inode, type);
-	if (acl != ACL_NOT_CACHED)
-		return acl;
+	hfs_dbg(ACL_MOD, "[%s]: ino %lu\n", __func__, inode->i_ino);
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -56,17 +54,15 @@ struct posix_acl *hfsplus_get_posix_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int hfsplus_set_posix_acl(struct inode *inode,
-					int type,
-					struct posix_acl *acl)
+int hfsplus_set_posix_acl(struct inode *inode, struct posix_acl *acl,
+		int type)
 {
 	int err;
 	char *xattr_name;
 	size_t size = 0;
 	char *value = NULL;
 
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
+	hfs_dbg(ACL_MOD, "[%s]: ino %lu\n", __func__, inode->i_ino);
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -115,7 +111,7 @@ end_set_acl:
 int hfsplus_init_posix_acl(struct inode *inode, struct inode *dir)
 {
 	int err = 0;
-	struct posix_acl *acl = NULL;
+	struct posix_acl *default_acl, *acl;
 
 	hfs_dbg(ACL_MOD,
 		"[%s]: ino %lu, dir->ino %lu\n",
@@ -124,151 +120,21 @@ int hfsplus_init_posix_acl(struct inode *inode, struct inode *dir)
 	if (S_ISLNK(inode->i_mode))
 		return 0;
 
-	acl = hfsplus_get_posix_acl(dir, ACL_TYPE_DEFAULT);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-
-	if (acl) {
-		if (S_ISDIR(inode->i_mode)) {
-			err = hfsplus_set_posix_acl(inode,
-							ACL_TYPE_DEFAULT,
-							acl);
-			if (unlikely(err))
-				goto init_acl_cleanup;
-		}
-
-		err = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
-		if (unlikely(err < 0))
-			return err;
-
-		if (err > 0)
-			err = hfsplus_set_posix_acl(inode,
-							ACL_TYPE_ACCESS,
-							acl);
-	} else
-		inode->i_mode &= ~current_umask();
-
-init_acl_cleanup:
-	posix_acl_release(acl);
-	return err;
-}
-
-int hfsplus_posix_acl_chmod(struct inode *inode)
-{
-	int err;
-	struct posix_acl *acl;
-
-	hfs_dbg(ACL_MOD, "[%s]: ino %lu\n", __func__, inode->i_ino);
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	acl = hfsplus_get_posix_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl) || !acl)
-		return PTR_ERR(acl);
-
-	err = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
-	if (unlikely(err))
+	err = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+	if (err)
 		return err;
 
-	err = hfsplus_set_posix_acl(inode, ACL_TYPE_ACCESS, acl);
-	posix_acl_release(acl);
-	return err;
-}
-
-static int hfsplus_xattr_get_posix_acl(struct dentry *dentry,
-					const char *name,
-					void *buffer,
-					size_t size,
-					int type)
-{
-	int err = 0;
-	struct posix_acl *acl;
-
-	hfs_dbg(ACL_MOD,
-		"[%s]: ino %lu, buffer %p, size %zu, type %#x\n",
-		__func__, dentry->d_inode->i_ino, buffer, size, type);
-
-	if (strcmp(name, "") != 0)
-		return -EINVAL;
-
-	acl = hfsplus_get_posix_acl(dentry->d_inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl == NULL)
-		return -ENODATA;
-
-	err = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-	posix_acl_release(acl);
-
-	return err;
-}
-
-static int hfsplus_xattr_set_posix_acl(struct dentry *dentry,
-					const char *name,
-					const void *value,
-					size_t size,
-					int flags,
-					int type)
-{
-	int err = 0;
-	struct inode *inode = dentry->d_inode;
-	struct posix_acl *acl = NULL;
-
-	hfs_dbg(ACL_MOD,
-		"[%s]: ino %lu, value %p, size %zu, flags %#x, type %#x\n",
-		__func__, inode->i_ino, value, size, flags, type);
-
-	if (strcmp(name, "") != 0)
-		return -EINVAL;
-
-	if (!inode_owner_or_capable(inode))
-		return -EPERM;
-
-	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		else if (acl) {
-			err = posix_acl_valid(acl);
-			if (err)
-				goto end_xattr_set_acl;
-		}
+	if (default_acl) {
+		err = hfsplus_set_posix_acl(inode, default_acl,
+					    ACL_TYPE_DEFAULT);
+		posix_acl_release(default_acl);
 	}
 
-	err = hfsplus_set_posix_acl(inode, type, acl);
-
-end_xattr_set_acl:
-	posix_acl_release(acl);
+	if (acl) {
+		if (!err)
+			err = hfsplus_set_posix_acl(inode, acl,
+						    ACL_TYPE_ACCESS);
+		posix_acl_release(acl);
+	}
 	return err;
 }
-
-static size_t hfsplus_xattr_list_posix_acl(struct dentry *dentry,
-						char *list,
-						size_t list_size,
-						const char *name,
-						size_t name_len,
-						int type)
-{
-	/*
-	 * This method is not used.
-	 * It is used hfsplus_listxattr() instead of generic_listxattr().
-	 */
-	return -EOPNOTSUPP;
-}
-
-const struct xattr_handler hfsplus_xattr_acl_access_handler = {
-	.prefix	= POSIX_ACL_XATTR_ACCESS,
-	.flags	= ACL_TYPE_ACCESS,
-	.list	= hfsplus_xattr_list_posix_acl,
-	.get	= hfsplus_xattr_get_posix_acl,
-	.set	= hfsplus_xattr_set_posix_acl,
-};
-
-const struct xattr_handler hfsplus_xattr_acl_default_handler = {
-	.prefix	= POSIX_ACL_XATTR_DEFAULT,
-	.flags	= ACL_TYPE_DEFAULT,
-	.list	= hfsplus_xattr_list_posix_acl,
-	.get	= hfsplus_xattr_get_posix_acl,
-	.set	= hfsplus_xattr_set_posix_acl,
-};
diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index 3c6136f..bf88baa 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -7,6 +7,7 @@
  */
 
 #include "hfsplus_fs.h"
+#include <linux/posix_acl_xattr.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -15,8 +16,8 @@ const struct xattr_handler *hfsplus_xattr_handlers[] = {
 	&hfsplus_xattr_user_handler,
 	&hfsplus_xattr_trusted_handler,
 #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
-	&hfsplus_xattr_acl_access_handler,
-	&hfsplus_xattr_acl_default_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 #endif
 	&hfsplus_xattr_security_handler,
 	NULL
diff --git a/fs/hfsplus/xattr.h b/fs/hfsplus/xattr.h
index 841b569..9e21449 100644
--- a/fs/hfsplus/xattr.h
+++ b/fs/hfsplus/xattr.h
@@ -14,8 +14,6 @@
 extern const struct xattr_handler hfsplus_xattr_osx_handler;
 extern const struct xattr_handler hfsplus_xattr_user_handler;
 extern const struct xattr_handler hfsplus_xattr_trusted_handler;
-extern const struct xattr_handler hfsplus_xattr_acl_access_handler;
-extern const struct xattr_handler hfsplus_xattr_acl_default_handler;
 extern const struct xattr_handler hfsplus_xattr_security_handler;
 
 extern const struct xattr_handler *hfsplus_xattr_handlers[];
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
