Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF5B08017
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 04:45:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD1C28F804C
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 02:45:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id kPPaBHZM5OvbONzY (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 02:45:46 -0800 (PST)
Message-Id: <20131211104529.142731540@bombadil.infradead.org>
Date: Wed, 11 Dec 2013 02:42:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/18] gfs2: use generic posix ACL infrastructure
References: <20131211104243.148113893@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0016-gfs2-use-generic-posix-ACL-infrastructure.patch
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

This contains some major refactoring for the create path so that
inodes are created with the right mode to start with instead of
fixing it up later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/acl.c   |  234 +++++++------------------------------------------------
 fs/gfs2/acl.h   |    4 +-
 fs/gfs2/inode.c |   33 ++++++--
 fs/gfs2/xattr.c |    4 +-
 4 files changed, 62 insertions(+), 213 deletions(-)

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index e82e4ac..ba94566 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -49,10 +49,6 @@ struct posix_acl *gfs2_get_acl(struct inode *inode, int type)
 	if (!ip->i_eattr)
 		return NULL;
 
-	acl = get_cached_acl(&ip->i_inode, type);
-	if (acl != ACL_NOT_CACHED)
-		return acl;
-
 	name = gfs2_acl_name(type);
 	if (name == NULL)
 		return ERR_PTR(-EINVAL);
@@ -80,7 +76,7 @@ static int gfs2_set_mode(struct inode *inode, umode_t mode)
 	return error;
 }
 
-static int gfs2_acl_set(struct inode *inode, int type, struct posix_acl *acl)
+int gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int error;
 	int len;
@@ -88,219 +84,49 @@ static int gfs2_acl_set(struct inode *inode, int type, struct posix_acl *acl)
 	const char *name = gfs2_acl_name(type);
 
 	BUG_ON(name == NULL);
-	len = posix_acl_to_xattr(&init_user_ns, acl, NULL, 0);
-	if (len == 0)
-		return 0;
-	data = kmalloc(len, GFP_NOFS);
-	if (data == NULL)
-		return -ENOMEM;
-	error = posix_acl_to_xattr(&init_user_ns, acl, data, len);
-	if (error < 0)
-		goto out;
-	error = __gfs2_xattr_set(inode, name, data, len, 0, GFS2_EATYPE_SYS);
-	if (!error)
-		set_cached_acl(inode, type, acl);
-out:
-	kfree(data);
-	return error;
-}
-
-int gfs2_acl_create(struct gfs2_inode *dip, struct inode *inode)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct posix_acl *acl;
-	umode_t mode = inode->i_mode;
-	int error = 0;
-
-	if (!sdp->sd_args.ar_posix_acl)
-		return 0;
-	if (S_ISLNK(inode->i_mode))
-		return 0;
-
-	acl = gfs2_get_acl(&dip->i_inode, ACL_TYPE_DEFAULT);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (!acl) {
-		mode &= ~current_umask();
-		return gfs2_set_mode(inode, mode);
-	}
-
-	if (S_ISDIR(inode->i_mode)) {
-		error = gfs2_acl_set(inode, ACL_TYPE_DEFAULT, acl);
-		if (error)
-			goto out;
-	}
-
-	error = __posix_acl_create(&acl, GFP_NOFS, &mode);
-	if (error < 0)
-		return error;
 
-	if (error == 0)
-		goto munge;
-
-	error = gfs2_acl_set(inode, ACL_TYPE_ACCESS, acl);
-	if (error)
-		goto out;
-munge:
-	error = gfs2_set_mode(inode, mode);
-out:
-	posix_acl_release(acl);
-	return error;
-}
-
-int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
-{
-	struct inode *inode = &ip->i_inode;
-	struct posix_acl *acl;
-	char *data;
-	unsigned int len;
-	int error;
-
-	acl = gfs2_get_acl(&ip->i_inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (!acl)
-		return gfs2_setattr_simple(inode, attr);
-
-	error = __posix_acl_chmod(&acl, GFP_NOFS, attr->ia_mode);
-	if (error)
-		return error;
-
-	len = posix_acl_to_xattr(&init_user_ns, acl, NULL, 0);
-	data = kmalloc(len, GFP_NOFS);
-	error = -ENOMEM;
-	if (data == NULL)
-		goto out;
-	posix_acl_to_xattr(&init_user_ns, acl, data, len);
-	error = gfs2_xattr_acl_chmod(ip, attr, data);
-	kfree(data);
-	set_cached_acl(&ip->i_inode, ACL_TYPE_ACCESS, acl);
-
-out:
-	posix_acl_release(acl);
-	return error;
-}
-
-static int gfs2_acl_type(const char *name)
-{
-	if (strcmp(name, GFS2_POSIX_ACL_ACCESS) == 0)
-		return ACL_TYPE_ACCESS;
-	if (strcmp(name, GFS2_POSIX_ACL_DEFAULT) == 0)
-		return ACL_TYPE_DEFAULT;
-	return -EINVAL;
-}
-
-static int gfs2_xattr_system_get(struct dentry *dentry, const char *name,
-				 void *buffer, size_t size, int xtype)
-{
-	struct inode *inode = dentry->d_inode;
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	struct posix_acl *acl;
-	int type;
-	int error;
-
-	if (!sdp->sd_args.ar_posix_acl)
-		return -EOPNOTSUPP;
-
-	type = gfs2_acl_type(name);
-	if (type < 0)
-		return type;
-
-	acl = gfs2_get_acl(inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl == NULL)
-		return -ENODATA;
-
-	error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-	posix_acl_release(acl);
-
-	return error;
-}
-
-static int gfs2_xattr_system_set(struct dentry *dentry, const char *name,
-				 const void *value, size_t size, int flags,
-				 int xtype)
-{
-	struct inode *inode = dentry->d_inode;
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	struct posix_acl *acl = NULL;
-	int error = 0, type;
-
-	if (!sdp->sd_args.ar_posix_acl)
-		return -EOPNOTSUPP;
-
-	type = gfs2_acl_type(name);
-	if (type < 0)
-		return type;
-	if (flags & XATTR_CREATE)
-		return -EINVAL;
-	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
-		return value ? -EACCES : 0;
-	if (!uid_eq(current_fsuid(), inode->i_uid) && !capable(CAP_FOWNER))
-		return -EPERM;
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	if (!value)
-		goto set_acl;
-
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
-	error = -EINVAL;
 	if (acl->a_count > GFS2_ACL_MAX_ENTRIES)
-		goto out_release;
+		return -EINVAL;
 
 	if (type == ACL_TYPE_ACCESS) {
 		umode_t mode = inode->i_mode;
+
 		error = posix_acl_equiv_mode(acl, &mode);
+		if (error < 0)
+			return error;
 
-		if (error <= 0) {
-			posix_acl_release(acl);
+		if (error == 0)
 			acl = NULL;
 
-			if (error < 0)
-				return error;
-		}
-
 		error = gfs2_set_mode(inode, mode);
 		if (error)
-			goto out_release;
+			return error;
 	}
 
-set_acl:
-	error = __gfs2_xattr_set(inode, name, value, size, 0, GFS2_EATYPE_SYS);
-	if (!error) {
-		if (acl)
-			set_cached_acl(inode, type, acl);
-		else
-			forget_cached_acl(inode, type);
+	if (acl) {
+		len = posix_acl_to_xattr(&init_user_ns, acl, NULL, 0);
+		if (len == 0)
+			return 0;
+		data = kmalloc(len, GFP_NOFS);
+		if (data == NULL)
+			return -ENOMEM;
+		error = posix_acl_to_xattr(&init_user_ns, acl, data, len);
+		if (error < 0)
+			goto out;
+	} else {
+		data = NULL;
+		len = 0;
 	}
-out_release:
-	posix_acl_release(acl);
+
+	error = __gfs2_xattr_set(inode, name, data, len, 0, GFS2_EATYPE_SYS);
+	if (error)
+		goto out;
+
+	if (acl)
+		set_cached_acl(inode, type, acl);
+	else
+		forget_cached_acl(inode, type);
 out:
+	kfree(data);
 	return error;
 }
-
-const struct xattr_handler gfs2_xattr_system_handler = {
-	.prefix = XATTR_SYSTEM_PREFIX,
-	.flags  = GFS2_EATYPE_SYS,
-	.get    = gfs2_xattr_system_get,
-	.set    = gfs2_xattr_system_set,
-};
-
diff --git a/fs/gfs2/acl.h b/fs/gfs2/acl.h
index 0da38dc..301260c 100644
--- a/fs/gfs2/acl.h
+++ b/fs/gfs2/acl.h
@@ -17,8 +17,6 @@
 #define GFS2_ACL_MAX_ENTRIES		25
 
 extern struct posix_acl *gfs2_get_acl(struct inode *inode, int type);
-extern int gfs2_acl_create(struct gfs2_inode *dip, struct inode *inode);
-extern int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr);
-extern const struct xattr_handler gfs2_xattr_system_handler;
+extern int gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 
 #endif /* __ACL_DOT_H__ */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 7119504..92b8959 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -552,6 +552,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 			     unsigned int size, int excl, int *opened)
 {
 	const struct qstr *name = &dentry->d_name;
+	struct posix_acl *default_acl, *acl;
 	struct gfs2_holder ghs[2];
 	struct inode *inode = NULL;
 	struct gfs2_inode *dip = GFS2_I(dir), *ip;
@@ -611,10 +612,14 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (!inode)
 		goto fail_gunlock;
 
+	error = posix_acl_create(dir, &mode, &default_acl, &acl);
+	if (error)
+		goto fail_free_vfs_inode;
+
 	ip = GFS2_I(inode);
 	error = gfs2_rs_alloc(ip);
 	if (error)
-		goto fail_free_inode;
+		goto fail_free_acls;
 
 	inode->i_mode = mode;
 	set_nlink(inode, S_ISDIR(mode) ? 2 : 1);
@@ -682,7 +687,16 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_set_iop(inode);
 	insert_inode_hash(inode);
 
-	error = gfs2_acl_create(dip, inode);
+	if (default_acl) {
+		error = gfs2_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+		posix_acl_release(default_acl);
+	}
+	if (acl) {
+		if (!error)
+			error = gfs2_set_acl(inode, acl, ACL_TYPE_ACCESS);
+		posix_acl_release(acl);
+	}
+
 	if (error)
 		goto fail_gunlock3;
 
@@ -716,6 +730,12 @@ fail_free_inode:
 	if (ip->i_gl)
 		gfs2_glock_put(ip->i_gl);
 	gfs2_rs_delete(ip, NULL);
+fail_free_acls:
+	if (default_acl)
+		posix_acl_release(default_acl);
+	if (acl)
+		posix_acl_release(acl);
+fail_free_vfs_inode:
 	free_inode_nonrcu(inode);
 	inode = NULL;
 fail_gunlock:
@@ -1678,10 +1698,11 @@ static int gfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		error = gfs2_setattr_size(inode, attr->ia_size);
 	else if (attr->ia_valid & (ATTR_UID | ATTR_GID))
 		error = setattr_chown(inode, attr);
-	else if ((attr->ia_valid & ATTR_MODE) && IS_POSIXACL(inode))
-		error = gfs2_acl_chmod(ip, attr);
-	else
+	else {
 		error = gfs2_setattr_simple(inode, attr);
+		if (!error && attr->ia_valid & ATTR_MODE)
+			error = posix_acl_chmod(inode, inode->i_mode);
+	}
 
 out:
 	if (!error)
@@ -1841,6 +1862,7 @@ const struct inode_operations gfs2_file_iops = {
 	.removexattr = gfs2_removexattr,
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
+	.set_acl = gfs2_set_acl,
 };
 
 const struct inode_operations gfs2_dir_iops = {
@@ -1862,6 +1884,7 @@ const struct inode_operations gfs2_dir_iops = {
 	.removexattr = gfs2_removexattr,
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
+	.set_acl = gfs2_set_acl,
 	.atomic_open = gfs2_atomic_open,
 };
 
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 8c6a6f6..0b81f78 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -13,6 +13,7 @@
 #include <linux/buffer_head.h>
 #include <linux/xattr.h>
 #include <linux/gfs2_ondisk.h>
+#include <linux/posix_acl_xattr.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
@@ -1500,7 +1501,8 @@ static const struct xattr_handler gfs2_xattr_security_handler = {
 const struct xattr_handler *gfs2_xattr_handlers[] = {
 	&gfs2_xattr_user_handler,
 	&gfs2_xattr_security_handler,
-	&gfs2_xattr_system_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 	NULL,
 };
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
