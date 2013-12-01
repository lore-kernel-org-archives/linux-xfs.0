Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D23C67F5F
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 06:07:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2AD58F8049
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 04:07:12 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id i1HKd3NthsPxDBdv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Dec 2013 04:07:11 -0800 (PST)
Message-Id: <20131201120655.675669876@bombadil.infradead.org>
Date: Sun, 01 Dec 2013 03:59:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/18] jffs2: use generic posix ACL infrastructure
References: <20131201115903.910559036@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0011-jffs2-use-generic-posix-ACL-infrastructure.patch
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/jffs2/acl.c     |  134 +++++-----------------------------------------------
 fs/jffs2/acl.h     |    7 +--
 fs/jffs2/dir.c     |    1 +
 fs/jffs2/file.c    |    1 +
 fs/jffs2/fs.c      |    2 +-
 fs/jffs2/symlink.c |    1 +
 fs/jffs2/xattr.c   |    9 ++--
 7 files changed, 22 insertions(+), 133 deletions(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 4d6e31b..f5f66b1 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -232,7 +232,7 @@ static int __jffs2_set_acl(struct inode *inode, int xprefix, struct posix_acl *a
 	return rc;
 }
 
-static int jffs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+int jffs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int rc, xprefix;
 
@@ -277,30 +277,21 @@ static int jffs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 
 int jffs2_init_acl_pre(struct inode *dir_i, struct inode *inode, umode_t *i_mode)
 {
-	struct posix_acl *acl;
+	struct posix_acl *default_acl, *acl;
 	int rc;
 
 	cache_no_acl(inode);
 
-	if (S_ISLNK(*i_mode))
-		return 0;	/* Symlink always has no-ACL */
-
-	acl = jffs2_get_acl(dir_i, ACL_TYPE_DEFAULT);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-
-	if (!acl) {
-		*i_mode &= ~current_umask();
-	} else {
-		if (S_ISDIR(*i_mode))
-			set_cached_acl(inode, ACL_TYPE_DEFAULT, acl);
-
-		rc = __posix_acl_create(&acl, GFP_KERNEL, i_mode);
-		if (rc < 0)
-			return rc;
-		if (rc > 0)
-			set_cached_acl(inode, ACL_TYPE_ACCESS, acl);
+	rc = posix_acl_create(dir_i, i_mode, &default_acl, &acl);
+	if (rc)
+		return rc;
 
+	if (default_acl) {
+		set_cached_acl(inode, ACL_TYPE_DEFAULT, default_acl);
+		posix_acl_release(default_acl);
+	}
+	if (acl) {
+		set_cached_acl(inode, ACL_TYPE_ACCESS, acl);
 		posix_acl_release(acl);
 	}
 	return 0;
@@ -324,106 +315,3 @@ int jffs2_init_acl_post(struct inode *inode)
 
 	return 0;
 }
-
-int jffs2_acl_chmod(struct inode *inode)
-{
-	struct posix_acl *acl;
-	int rc;
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-	acl = jffs2_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl) || !acl)
-		return PTR_ERR(acl);
-	rc = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
-	if (rc)
-		return rc;
-	rc = jffs2_set_acl(inode, ACL_TYPE_ACCESS, acl);
-	posix_acl_release(acl);
-	return rc;
-}
-
-static size_t jffs2_acl_access_listxattr(struct dentry *dentry, char *list,
-		size_t list_size, const char *name, size_t name_len, int type)
-{
-	const int retlen = sizeof(POSIX_ACL_XATTR_ACCESS);
-
-	if (list && retlen <= list_size)
-		strcpy(list, POSIX_ACL_XATTR_ACCESS);
-	return retlen;
-}
-
-static size_t jffs2_acl_default_listxattr(struct dentry *dentry, char *list,
-		size_t list_size, const char *name, size_t name_len, int type)
-{
-	const int retlen = sizeof(POSIX_ACL_XATTR_DEFAULT);
-
-	if (list && retlen <= list_size)
-		strcpy(list, POSIX_ACL_XATTR_DEFAULT);
-	return retlen;
-}
-
-static int jffs2_acl_getxattr(struct dentry *dentry, const char *name,
-		void *buffer, size_t size, int type)
-{
-	struct posix_acl *acl;
-	int rc;
-
-	if (name[0] != '\0')
-		return -EINVAL;
-
-	acl = jffs2_get_acl(dentry->d_inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (!acl)
-		return -ENODATA;
-	rc = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-	posix_acl_release(acl);
-
-	return rc;
-}
-
-static int jffs2_acl_setxattr(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags, int type)
-{
-	struct posix_acl *acl;
-	int rc;
-
-	if (name[0] != '\0')
-		return -EINVAL;
-	if (!inode_owner_or_capable(dentry->d_inode))
-		return -EPERM;
-
-	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		if (acl) {
-			rc = posix_acl_valid(acl);
-			if (rc)
-				goto out;
-		}
-	} else {
-		acl = NULL;
-	}
-	rc = jffs2_set_acl(dentry->d_inode, type, acl);
- out:
-	posix_acl_release(acl);
-	return rc;
-}
-
-const struct xattr_handler jffs2_acl_access_xattr_handler = {
-	.prefix	= POSIX_ACL_XATTR_ACCESS,
-	.flags	= ACL_TYPE_DEFAULT,
-	.list	= jffs2_acl_access_listxattr,
-	.get	= jffs2_acl_getxattr,
-	.set	= jffs2_acl_setxattr,
-};
-
-const struct xattr_handler jffs2_acl_default_xattr_handler = {
-	.prefix	= POSIX_ACL_XATTR_DEFAULT,
-	.flags	= ACL_TYPE_DEFAULT,
-	.list	= jffs2_acl_default_listxattr,
-	.get	= jffs2_acl_getxattr,
-	.set	= jffs2_acl_setxattr,
-};
diff --git a/fs/jffs2/acl.h b/fs/jffs2/acl.h
index 9b47724..2e2b574 100644
--- a/fs/jffs2/acl.h
+++ b/fs/jffs2/acl.h
@@ -27,17 +27,14 @@ struct jffs2_acl_header {
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 
 struct posix_acl *jffs2_get_acl(struct inode *inode, int type);
-extern int jffs2_acl_chmod(struct inode *);
+int jffs2_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 extern int jffs2_init_acl_pre(struct inode *, struct inode *, umode_t *);
 extern int jffs2_init_acl_post(struct inode *);
 
-extern const struct xattr_handler jffs2_acl_access_xattr_handler;
-extern const struct xattr_handler jffs2_acl_default_xattr_handler;
-
 #else
 
 #define jffs2_get_acl				(NULL)
-#define jffs2_acl_chmod(inode)			(0)
+#define jffs2_set_acl				(NULL)
 #define jffs2_init_acl_pre(dir_i,inode,mode)	(0)
 #define jffs2_init_acl_post(inode)		(0)
 
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index e3aac22..9385560 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -59,6 +59,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.mknod =	jffs2_mknod,
 	.rename =	jffs2_rename,
 	.get_acl =	jffs2_get_acl,
+	.set_acl =	jffs2_set_acl,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 1506673..256cd19 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -66,6 +66,7 @@ const struct file_operations jffs2_file_operations =
 const struct inode_operations jffs2_file_inode_operations =
 {
 	.get_acl =	jffs2_get_acl,
+	.set_acl =	jffs2_set_acl,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 09b3ed4..586db76 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -198,7 +198,7 @@ int jffs2_setattr(struct dentry *dentry, struct iattr *iattr)
 
 	rc = jffs2_do_setattr(dentry->d_inode, iattr);
 	if (!rc && (iattr->ia_valid & ATTR_MODE))
-		rc = jffs2_acl_chmod(dentry->d_inode);
+		rc = posix_acl_chmod(dentry->d_inode);
 
 	return rc;
 }
diff --git a/fs/jffs2/symlink.c b/fs/jffs2/symlink.c
index 6e56333..c42df08 100644
--- a/fs/jffs2/symlink.c
+++ b/fs/jffs2/symlink.c
@@ -23,6 +23,7 @@ const struct inode_operations jffs2_symlink_inode_operations =
 	.readlink =	generic_readlink,
 	.follow_link =	jffs2_follow_link,
 	.get_acl =	jffs2_get_acl,
+	.set_acl =	jffs2_set_acl,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 3034e97..ad0f2e2 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -22,6 +22,7 @@
 #include <linux/crc32.h>
 #include <linux/jffs2.h>
 #include <linux/xattr.h>
+#include <linux/posix_acl_xattr.h>
 #include <linux/mtd/mtd.h>
 #include "nodelist.h"
 /* -------- xdatum related functions ----------------
@@ -921,8 +922,8 @@ const struct xattr_handler *jffs2_xattr_handlers[] = {
 	&jffs2_security_xattr_handler,
 #endif
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
-	&jffs2_acl_access_xattr_handler,
-	&jffs2_acl_default_xattr_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 #endif
 	&jffs2_trusted_xattr_handler,
 	NULL
@@ -942,10 +943,10 @@ static const struct xattr_handler *xprefix_to_handler(int xprefix) {
 #endif
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 	case JFFS2_XPREFIX_ACL_ACCESS:
-		ret = &jffs2_acl_access_xattr_handler;
+		ret = &posix_acl_access_xattr_handler;
 		break;
 	case JFFS2_XPREFIX_ACL_DEFAULT:
-		ret = &jffs2_acl_default_xattr_handler;
+		ret = &posix_acl_default_xattr_handler;
 		break;
 #endif
 	case JFFS2_XPREFIX_TRUSTED:
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
