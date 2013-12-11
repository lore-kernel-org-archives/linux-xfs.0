Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FEAA29E06
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 04:45:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94535AC00B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 02:45:45 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id owYn1DCPaHKHkxWh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 02:45:44 -0800 (PST)
Message-Id: <20131211104528.300317604@bombadil.infradead.org>
Date: Wed, 11 Dec 2013 02:42:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/18] jffs2: use generic posix ACL infrastructure
References: <20131211104243.148113893@bombadil.infradead.org>
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
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Also don't bother to set up a .get_acl method for symlinks as we do not
support access control (ACLs or even mode bits) for symlinks in Linux.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/jffs2/acl.c     |  141 ++++------------------------------------------------
 fs/jffs2/acl.h     |    7 +--
 fs/jffs2/dir.c     |    1 +
 fs/jffs2/file.c    |    1 +
 fs/jffs2/fs.c      |    7 +--
 fs/jffs2/symlink.c |    1 -
 fs/jffs2/xattr.c   |    9 ++--
 7 files changed, 24 insertions(+), 143 deletions(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 4d6e31b..009ec0b 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -178,10 +178,6 @@ struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
 	char *value = NULL;
 	int rc, xprefix;
 
-	acl = get_cached_acl(inode, type);
-	if (acl != ACL_NOT_CACHED)
-		return acl;
-
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		xprefix = JFFS2_XPREFIX_ACL_ACCESS;
@@ -232,13 +228,10 @@ static int __jffs2_set_acl(struct inode *inode, int xprefix, struct posix_acl *a
 	return rc;
 }
 
-static int jffs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+int jffs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int rc, xprefix;
 
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		xprefix = JFFS2_XPREFIX_ACL_ACCESS;
@@ -277,30 +270,21 @@ static int jffs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 
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
@@ -324,106 +308,3 @@ int jffs2_init_acl_post(struct inode *inode)
 
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
index 09b3ed4..a69e426 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -190,15 +190,16 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 
 int jffs2_setattr(struct dentry *dentry, struct iattr *iattr)
 {
+	struct inode *inode = dentry->d_inode;
 	int rc;
 
-	rc = inode_change_ok(dentry->d_inode, iattr);
+	rc = inode_change_ok(inode, iattr);
 	if (rc)
 		return rc;
 
-	rc = jffs2_do_setattr(dentry->d_inode, iattr);
+	rc = jffs2_do_setattr(inode, iattr);
 	if (!rc && (iattr->ia_valid & ATTR_MODE))
-		rc = jffs2_acl_chmod(dentry->d_inode);
+		rc = posix_acl_chmod(inode, inode->i_mode);
 
 	return rc;
 }
diff --git a/fs/jffs2/symlink.c b/fs/jffs2/symlink.c
index 6e56333..c7c77b0 100644
--- a/fs/jffs2/symlink.c
+++ b/fs/jffs2/symlink.c
@@ -22,7 +22,6 @@ const struct inode_operations jffs2_symlink_inode_operations =
 {
 	.readlink =	generic_readlink,
 	.follow_link =	jffs2_follow_link,
-	.get_acl =	jffs2_get_acl,
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
