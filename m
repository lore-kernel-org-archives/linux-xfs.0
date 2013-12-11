Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4CCA5801C
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 04:45:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3880C8F8049
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 02:45:42 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 09t9AwhtbFMnz7eI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 02:45:41 -0800 (PST)
Message-Id: <20131211104528.029931306@bombadil.infradead.org>
Date: Wed, 11 Dec 2013 02:42:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/18] f2fs: use generic posix ACL infrastructure
References: <20131211104243.148113893@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0009-f2fs-use-generic-posix-ACL-infrastructure.patch
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
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

f2fs has some weird mode bit handling, so still using the old
chmod code for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/acl.c   |  174 ++++++-------------------------------------------------
 fs/f2fs/acl.h   |    7 +--
 fs/f2fs/f2fs.h  |    4 ++
 fs/f2fs/file.c  |    3 +-
 fs/f2fs/namei.c |    2 +
 fs/f2fs/xattr.c |    9 +--
 fs/f2fs/xattr.h |    2 -
 7 files changed, 31 insertions(+), 170 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 45e8430..fa8da4c 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -17,9 +17,6 @@
 #include "xattr.h"
 #include "acl.h"
 
-#define get_inode_mode(i)	((is_inode_flag_set(F2FS_I(i), FI_ACL_MODE)) ? \
-					(F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
-
 static inline size_t f2fs_acl_size(int count)
 {
 	if (count <= 4) {
@@ -167,19 +164,11 @@ fail:
 
 struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	int name_index = F2FS_XATTR_INDEX_POSIX_ACL_DEFAULT;
 	void *value = NULL;
 	struct posix_acl *acl;
 	int retval;
 
-	if (!test_opt(sbi, POSIX_ACL))
-		return NULL;
-
-	acl = get_cached_acl(inode, type);
-	if (acl != ACL_NOT_CACHED)
-		return acl;
-
 	if (type == ACL_TYPE_ACCESS)
 		name_index = F2FS_XATTR_INDEX_POSIX_ACL_ACCESS;
 
@@ -205,21 +194,15 @@ struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int f2fs_set_acl(struct inode *inode, int type,
+static int __f2fs_set_acl(struct inode *inode, int type,
 			struct posix_acl *acl, struct page *ipage)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	int name_index;
 	void *value = NULL;
 	size_t size = 0;
 	int error;
 
-	if (!test_opt(sbi, POSIX_ACL))
-		return 0;
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name_index = F2FS_XATTR_INDEX_POSIX_ACL_ACCESS;
@@ -261,154 +244,31 @@ static int f2fs_set_acl(struct inode *inode, int type,
 	return error;
 }
 
-int f2fs_init_acl(struct inode *inode, struct inode *dir, struct page *ipage)
+int f2fs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
-	struct posix_acl *acl = NULL;
-	int error = 0;
-
-	if (!S_ISLNK(inode->i_mode)) {
-		if (test_opt(sbi, POSIX_ACL)) {
-			acl = f2fs_get_acl(dir, ACL_TYPE_DEFAULT);
-			if (IS_ERR(acl))
-				return PTR_ERR(acl);
-		}
-		if (!acl)
-			inode->i_mode &= ~current_umask();
-	}
-
-	if (!test_opt(sbi, POSIX_ACL) || !acl)
-		goto cleanup;
-
-	if (S_ISDIR(inode->i_mode)) {
-		error = f2fs_set_acl(inode, ACL_TYPE_DEFAULT, acl, ipage);
-		if (error)
-			goto cleanup;
-	}
-	error = __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
-	if (error < 0)
-		return error;
-	if (error > 0)
-		error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl, ipage);
-cleanup:
-	posix_acl_release(acl);
-	return error;
+	return __f2fs_set_acl(inode, type, acl, NULL);
 }
 
-int f2fs_acl_chmod(struct inode *inode)
+int f2fs_init_acl(struct inode *inode, struct inode *dir, struct page *ipage)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct posix_acl *acl;
-	int error;
-	umode_t mode = get_inode_mode(inode);
-
-	if (!test_opt(sbi, POSIX_ACL))
-		return 0;
-	if (S_ISLNK(mode))
-		return -EOPNOTSUPP;
-
-	acl = f2fs_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl) || !acl)
-		return PTR_ERR(acl);
+	struct posix_acl *default_acl, *acl;
+	int error = 0;
 
-	error = __posix_acl_chmod(&acl, GFP_KERNEL, mode);
+	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
 	if (error)
 		return error;
 
-	error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl, NULL);
-	posix_acl_release(acl);
-	return error;
-}
-
-static size_t f2fs_xattr_list_acl(struct dentry *dentry, char *list,
-		size_t list_size, const char *name, size_t name_len, int type)
-{
-	struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
-	const char *xname = POSIX_ACL_XATTR_DEFAULT;
-	size_t size;
-
-	if (!test_opt(sbi, POSIX_ACL))
-		return 0;
-
-	if (type == ACL_TYPE_ACCESS)
-		xname = POSIX_ACL_XATTR_ACCESS;
-
-	size = strlen(xname) + 1;
-	if (list && size <= list_size)
-		memcpy(list, xname, size);
-	return size;
-}
-
-static int f2fs_xattr_get_acl(struct dentry *dentry, const char *name,
-		void *buffer, size_t size, int type)
-{
-	struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
-	struct posix_acl *acl;
-	int error;
-
-	if (strcmp(name, "") != 0)
-		return -EINVAL;
-	if (!test_opt(sbi, POSIX_ACL))
-		return -EOPNOTSUPP;
-
-	acl = f2fs_get_acl(dentry->d_inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (!acl)
-		return -ENODATA;
-	error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-	posix_acl_release(acl);
-
-	return error;
-}
-
-static int f2fs_xattr_set_acl(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags, int type)
-{
-	struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
-	struct inode *inode = dentry->d_inode;
-	struct posix_acl *acl = NULL;
-	int error;
-
-	if (strcmp(name, "") != 0)
-		return -EINVAL;
-	if (!test_opt(sbi, POSIX_ACL))
-		return -EOPNOTSUPP;
-	if (!inode_owner_or_capable(inode))
-		return -EPERM;
-
-	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		if (acl) {
-			error = posix_acl_valid(acl);
-			if (error)
-				goto release_and_out;
-		}
-	} else {
-		acl = NULL;
+	if (default_acl) {
+		error = __f2fs_set_acl(inode, ACL_TYPE_DEFAULT, default_acl,
+				       ipage);
+		posix_acl_release(default_acl);
+	}
+	if (acl) {
+		if (error)
+			error = __f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl,
+					       ipage);
+		posix_acl_release(acl);
 	}
 
-	error = f2fs_set_acl(inode, type, acl, NULL);
-
-release_and_out:
-	posix_acl_release(acl);
 	return error;
 }
-
-const struct xattr_handler f2fs_xattr_acl_default_handler = {
-	.prefix = POSIX_ACL_XATTR_DEFAULT,
-	.flags = ACL_TYPE_DEFAULT,
-	.list = f2fs_xattr_list_acl,
-	.get = f2fs_xattr_get_acl,
-	.set = f2fs_xattr_set_acl,
-};
-
-const struct xattr_handler f2fs_xattr_acl_access_handler = {
-	.prefix = POSIX_ACL_XATTR_ACCESS,
-	.flags = ACL_TYPE_ACCESS,
-	.list = f2fs_xattr_list_acl,
-	.get = f2fs_xattr_get_acl,
-	.set = f2fs_xattr_set_acl,
-};
diff --git a/fs/f2fs/acl.h b/fs/f2fs/acl.h
index 4963313..e086465 100644
--- a/fs/f2fs/acl.h
+++ b/fs/f2fs/acl.h
@@ -37,18 +37,13 @@ struct f2fs_acl_header {
 #ifdef CONFIG_F2FS_FS_POSIX_ACL
 
 extern struct posix_acl *f2fs_get_acl(struct inode *, int);
-extern int f2fs_acl_chmod(struct inode *);
+extern int f2fs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 extern int f2fs_init_acl(struct inode *, struct inode *, struct page *);
 #else
 #define f2fs_check_acl	NULL
 #define f2fs_get_acl	NULL
 #define f2fs_set_acl	NULL
 
-static inline int f2fs_acl_chmod(struct inode *inode)
-{
-	return 0;
-}
-
 static inline int f2fs_init_acl(struct inode *inode, struct inode *dir,
 							struct page *page)
 {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 89dc750..934b59c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -953,6 +953,10 @@ static inline int f2fs_readonly(struct super_block *sb)
 	return sb->s_flags & MS_RDONLY;
 }
 
+#define get_inode_mode(i) \
+	((is_inode_flag_set(F2FS_I(i), FI_ACL_MODE)) ? \
+	 (F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
+
 /*
  * file.c
  */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7d714f4..cf835e0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -390,7 +390,7 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	__setattr_copy(inode, attr);
 
 	if (attr->ia_valid & ATTR_MODE) {
-		err = f2fs_acl_chmod(inode);
+		err = posix_acl_chmod(inode, get_inode_mode(inode));
 		if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
 			inode->i_mode = fi->i_acl_mode;
 			clear_inode_flag(fi, FI_ACL_MODE);
@@ -405,6 +405,7 @@ const struct inode_operations f2fs_file_inode_operations = {
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 	.get_acl	= f2fs_get_acl,
+	.set_acl	= f2fs_set_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 575adac..5846eeb 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -496,6 +496,7 @@ const struct inode_operations f2fs_dir_inode_operations = {
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 	.get_acl	= f2fs_get_acl,
+	.set_acl	= f2fs_set_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
@@ -522,6 +523,7 @@ const struct inode_operations f2fs_special_inode_operations = {
 	.getattr	= f2fs_getattr,
 	.setattr        = f2fs_setattr,
 	.get_acl	= f2fs_get_acl,
+	.set_acl	= f2fs_set_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
 	.setxattr       = generic_setxattr,
 	.getxattr       = generic_getxattr,
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index aa7a3f1..e2b9299 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -21,6 +21,7 @@
 #include <linux/rwsem.h>
 #include <linux/f2fs_fs.h>
 #include <linux/security.h>
+#include <linux/posix_acl_xattr.h>
 #include "f2fs.h"
 #include "xattr.h"
 
@@ -216,8 +217,8 @@ const struct xattr_handler f2fs_xattr_security_handler = {
 static const struct xattr_handler *f2fs_xattr_handler_map[] = {
 	[F2FS_XATTR_INDEX_USER] = &f2fs_xattr_user_handler,
 #ifdef CONFIG_F2FS_FS_POSIX_ACL
-	[F2FS_XATTR_INDEX_POSIX_ACL_ACCESS] = &f2fs_xattr_acl_access_handler,
-	[F2FS_XATTR_INDEX_POSIX_ACL_DEFAULT] = &f2fs_xattr_acl_default_handler,
+	[F2FS_XATTR_INDEX_POSIX_ACL_ACCESS] = &posix_acl_access_xattr_handler,
+	[F2FS_XATTR_INDEX_POSIX_ACL_DEFAULT] = &posix_acl_default_xattr_handler,
 #endif
 	[F2FS_XATTR_INDEX_TRUSTED] = &f2fs_xattr_trusted_handler,
 #ifdef CONFIG_F2FS_FS_SECURITY
@@ -229,8 +230,8 @@ static const struct xattr_handler *f2fs_xattr_handler_map[] = {
 const struct xattr_handler *f2fs_xattr_handlers[] = {
 	&f2fs_xattr_user_handler,
 #ifdef CONFIG_F2FS_FS_POSIX_ACL
-	&f2fs_xattr_acl_access_handler,
-	&f2fs_xattr_acl_default_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 #endif
 	&f2fs_xattr_trusted_handler,
 #ifdef CONFIG_F2FS_FS_SECURITY
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index 02a08fb..b21d9eb 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -108,8 +108,6 @@ struct f2fs_xattr_entry {
 #ifdef CONFIG_F2FS_FS_XATTR
 extern const struct xattr_handler f2fs_xattr_user_handler;
 extern const struct xattr_handler f2fs_xattr_trusted_handler;
-extern const struct xattr_handler f2fs_xattr_acl_access_handler;
-extern const struct xattr_handler f2fs_xattr_acl_default_handler;
 extern const struct xattr_handler f2fs_xattr_advise_handler;
 extern const struct xattr_handler f2fs_xattr_security_handler;
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
