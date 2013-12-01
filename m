Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA6BE7F69
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 06:07:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5922DAC001
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 04:07:14 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id KPa7JoExzBZRQZlO (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Dec 2013 04:07:12 -0800 (PST)
Message-Id: <20131201120656.194735588@bombadil.infradead.org>
Date: Sun, 01 Dec 2013 03:59:17 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/18] xfs: use generic posix ACL infrastructure
References: <20131201115903.910559036@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0014-xfs-use-generic-posix-ACL-infrastructure.patch
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

Also create inodes with the proper mode instead of fixing it up later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_acl.c   |  138 +++-------------------------------------------------
 fs/xfs/xfs_acl.h   |    9 +---
 fs/xfs/xfs_iops.c  |   39 ++++++++-------
 fs/xfs/xfs_iops.h  |    2 +-
 fs/xfs/xfs_xattr.c |    4 +-
 5 files changed, 33 insertions(+), 159 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 057ae2d..28d897f 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -183,7 +183,7 @@ out:
 }
 
 STATIC int
-xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+__xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 {
 	struct xfs_inode *ip = XFS_I(inode);
 	unsigned char *ea_name;
@@ -282,131 +282,23 @@ posix_acl_default_exists(struct inode *inode)
 	return xfs_acl_exists(inode, SGI_ACL_DEFAULT);
 }
 
-/*
- * No need for i_mutex because the inode is not yet exposed to the VFS.
- */
-int
-xfs_inherit_acl(struct inode *inode, struct posix_acl *acl)
-{
-	umode_t mode = inode->i_mode;
-	int error = 0, inherit = 0;
-
-	if (S_ISDIR(inode->i_mode)) {
-		error = xfs_set_acl(inode, ACL_TYPE_DEFAULT, acl);
-		if (error)
-			goto out;
-	}
-
-	error = __posix_acl_create(&acl, GFP_KERNEL, &mode);
-	if (error < 0)
-		return error;
-
-	/*
-	 * If __posix_acl_create returns a positive value we need to
-	 * inherit a permission that can't be represented using the Unix
-	 * mode bits and we actually need to set an ACL.
-	 */
-	if (error > 0)
-		inherit = 1;
-
-	error = xfs_set_mode(inode, mode);
-	if (error)
-		goto out;
-
-	if (inherit)
-		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, acl);
-
-out:
-	posix_acl_release(acl);
-	return error;
-}
-
 int
-xfs_acl_chmod(struct inode *inode)
+xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
-	struct posix_acl *acl;
-	int error;
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl) || !acl)
-		return PTR_ERR(acl);
-
-	error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
-	if (error)
-		return error;
-
-	error = xfs_set_acl(inode, ACL_TYPE_ACCESS, acl);
-	posix_acl_release(acl);
-	return error;
-}
-
-static int
-xfs_xattr_acl_get(struct dentry *dentry, const char *name,
-		void *value, size_t size, int type)
-{
-	struct posix_acl *acl;
-	int error;
-
-	acl = xfs_get_acl(dentry->d_inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl == NULL)
-		return -ENODATA;
-
-	error = posix_acl_to_xattr(&init_user_ns, acl, value, size);
-	posix_acl_release(acl);
-
-	return error;
-}
-
-static int
-xfs_xattr_acl_set(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags, int type)
-{
-	struct inode *inode = dentry->d_inode;
-	struct posix_acl *acl = NULL;
 	int error = 0;
 
-	if (flags & XATTR_CREATE)
-		return -EINVAL;
-	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
-		return value ? -EACCES : 0;
-	if (!inode_owner_or_capable(inode))
-		return -EPERM;
-
-	if (!value)
+	if (!acl)
 		goto set_acl;
 
-	acl = posix_acl_from_xattr(&init_user_ns, value, size);
-	if (!acl) {
-		/*
-		 * acl_set_file(3) may request that we set default ACLs with
-		 * zero length -- defend (gracefully) against that here.
-		 */
-		goto out;
-	}
-	if (IS_ERR(acl)) {
-		error = PTR_ERR(acl);
-		goto out;
-	}
-
-	error = posix_acl_valid(acl);
-	if (error)
-		goto out_release;
-
 	error = -EINVAL;
 	if (acl->a_count > XFS_ACL_MAX_ENTRIES(XFS_M(inode->i_sb)))
-		goto out_release;
+		return error;
 
 	if (type == ACL_TYPE_ACCESS) {
 		umode_t mode = inode->i_mode;
 		error = posix_acl_equiv_mode(acl, &mode);
 
 		if (error <= 0) {
-			posix_acl_release(acl);
 			acl = NULL;
 
 			if (error < 0)
@@ -415,27 +307,9 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
 
 		error = xfs_set_mode(inode, mode);
 		if (error)
-			goto out_release;
+			return error;
 	}
 
  set_acl:
-	error = xfs_set_acl(inode, type, acl);
- out_release:
-	posix_acl_release(acl);
- out:
-	return error;
+	return __xfs_set_acl(inode, type, acl);
 }
-
-const struct xattr_handler xfs_xattr_acl_access_handler = {
-	.prefix	= POSIX_ACL_XATTR_ACCESS,
-	.flags	= ACL_TYPE_ACCESS,
-	.get	= xfs_xattr_acl_get,
-	.set	= xfs_xattr_acl_set,
-};
-
-const struct xattr_handler xfs_xattr_acl_default_handler = {
-	.prefix	= POSIX_ACL_XATTR_DEFAULT,
-	.flags	= ACL_TYPE_DEFAULT,
-	.get	= xfs_xattr_acl_get,
-	.set	= xfs_xattr_acl_set,
-};
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 4016a56..5dc1637 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -60,20 +60,15 @@ struct xfs_acl {
 
 #ifdef CONFIG_XFS_POSIX_ACL
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
-extern int xfs_inherit_acl(struct inode *inode, struct posix_acl *default_acl);
-extern int xfs_acl_chmod(struct inode *inode);
+extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 extern int posix_acl_access_exists(struct inode *inode);
 extern int posix_acl_default_exists(struct inode *inode);
-
-extern const struct xattr_handler xfs_xattr_acl_access_handler;
-extern const struct xattr_handler xfs_xattr_acl_default_handler;
 #else
 static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
 {
 	return NULL;
 }
-# define xfs_inherit_acl(inode, default_acl)		0
-# define xfs_acl_chmod(inode)				0
+# define xfs_set_acl					NULL
 # define posix_acl_access_exists(inode)			0
 # define posix_acl_default_exists(inode)		0
 #endif /* CONFIG_XFS_POSIX_ACL */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 27e0e54..a8c7c78 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -123,7 +123,7 @@ xfs_vn_mknod(
 {
 	struct inode	*inode;
 	struct xfs_inode *ip = NULL;
-	struct posix_acl *default_acl = NULL;
+	struct posix_acl *default_acl, *acl;
 	struct xfs_name	name;
 	int		error;
 
@@ -139,14 +139,9 @@ xfs_vn_mknod(
 		rdev = 0;
 	}
 
-	if (IS_POSIXACL(dir)) {
-		default_acl = xfs_get_acl(dir, ACL_TYPE_DEFAULT);
-		if (IS_ERR(default_acl))
-			return PTR_ERR(default_acl);
-
-		if (!default_acl)
-			mode &= ~current_umask();
-	}
+	error = posix_acl_create(dir, &mode, &default_acl, &acl);
+	if (error)
+		return error;
 
 	xfs_dentry_to_name(&name, dentry, mode);
 	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
@@ -160,21 +155,27 @@ xfs_vn_mknod(
 		goto out_cleanup_inode;
 
 	if (default_acl) {
-		error = -xfs_inherit_acl(inode, default_acl);
-		default_acl = NULL;
-		if (unlikely(error))
+		error = xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+		if (error)
+			goto out_cleanup_inode;
+	}
+	if (acl) {
+		error = xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
+		if (error)
 			goto out_cleanup_inode;
 	}
-
 
 	d_instantiate(dentry, inode);
+ out_free_acl:
+ 	if (default_acl)
+		posix_acl_release(default_acl);
+	if (acl)
+		posix_acl_release(acl);
 	return -error;
 
  out_cleanup_inode:
 	xfs_cleanup_inode(dir, inode, dentry);
- out_free_acl:
-	posix_acl_release(default_acl);
-	return -error;
+	goto out_free_acl;
 }
 
 STATIC int
@@ -683,7 +684,7 @@ xfs_setattr_nonsize(
 	 * 	     Posix ACL code seems to care about this issue either.
 	 */
 	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
-		error = -xfs_acl_chmod(inode);
+		error = -posix_acl_chmod(inode);
 		if (error)
 			return XFS_ERROR(error);
 	}
@@ -1052,6 +1053,7 @@ xfs_vn_fiemap(
 
 static const struct inode_operations xfs_inode_operations = {
 	.get_acl		= xfs_get_acl,
+	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -1079,6 +1081,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
 	.get_acl		= xfs_get_acl,
+	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -1105,6 +1108,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
 	.get_acl		= xfs_get_acl,
+	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -1119,6 +1123,7 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.follow_link		= xfs_vn_follow_link,
 	.put_link		= xfs_vn_put_link,
 	.get_acl		= xfs_get_acl,
+	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index d2c5057..1c34e43 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -30,7 +30,7 @@ extern void xfs_setup_inode(struct xfs_inode *);
 /*
  * Internal setattr interfaces.
  */
-#define XFS_ATTR_NOACL		0x01	/* Don't call xfs_acl_chmod */
+#define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
 
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 9d47907..78ed92a 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -102,8 +102,8 @@ const struct xattr_handler *xfs_xattr_handlers[] = {
 	&xfs_xattr_trusted_handler,
 	&xfs_xattr_security_handler,
 #ifdef CONFIG_XFS_POSIX_ACL
-	&xfs_xattr_acl_access_handler,
-	&xfs_xattr_acl_default_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 #endif
 	NULL
 };
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
