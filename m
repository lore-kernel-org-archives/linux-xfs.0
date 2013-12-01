Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E6FEE7F56
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 06:07:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C320F304059
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 04:07:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id O0uNEG20iICHIDZg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Dec 2013 04:07:12 -0800 (PST)
Message-Id: <20131201120655.852590677@bombadil.infradead.org>
Date: Sun, 01 Dec 2013 03:59:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/18] ocfs2: use generic posix ACL infrastructure
References: <20131201115903.910559036@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0012-ocfs2-use-generic-posix-ACL-infrastructure.patch
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

This contains some major refactoring for the create path so that
inodes are created with the right mode to start with instead of
fixing it up later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/acl.c          |  234 ++---------------------------------------------
 fs/ocfs2/acl.h          |   13 ++-
 fs/ocfs2/file.c         |    4 +-
 fs/ocfs2/namei.c        |   25 ++++-
 fs/ocfs2/refcounttree.c |   19 +++-
 fs/ocfs2/xattr.c        |   21 +++--
 fs/ocfs2/xattr.h        |    6 +-
 7 files changed, 72 insertions(+), 250 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index c0f9d2f..555f4cd 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -160,36 +160,6 @@ static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
 	return acl;
 }
 
-
-/*
- * Get posix acl.
- */
-static struct posix_acl *ocfs2_get_acl(struct inode *inode, int type)
-{
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct buffer_head *di_bh = NULL;
-	struct posix_acl *acl;
-	int ret;
-
-	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
-		return NULL;
-
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
-	if (ret < 0) {
-		mlog_errno(ret);
-		acl = ERR_PTR(ret);
-		return acl;
-	}
-
-	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
-
-	ocfs2_inode_unlock(inode, 0);
-
-	brelse(di_bh);
-
-	return acl;
-}
-
 /*
  * Helper function to set i_mode in memory and disk. Some call paths
  * will not have di_bh or a journal handle to pass, in which case it
@@ -250,7 +220,7 @@ out:
 /*
  * Set the access or default ACL of an inode.
  */
-static int ocfs2_set_acl(handle_t *handle,
+int ocfs2_set_acl(handle_t *handle,
 			 struct inode *inode,
 			 struct buffer_head *di_bh,
 			 int type,
@@ -313,6 +283,11 @@ static int ocfs2_set_acl(handle_t *handle,
 	return ret;
 }
 
+int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
+{
+	return ocfs2_set_acl(NULL, inode, NULL, type, acl, NULL, NULL);
+}
+
 struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
 {
 	struct ocfs2_super *osb;
@@ -334,200 +309,3 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
 
 	return acl;
 }
-
-int ocfs2_acl_chmod(struct inode *inode)
-{
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct posix_acl *acl;
-	int ret;
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
-		return 0;
-
-	acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl) || !acl)
-		return PTR_ERR(acl);
-	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
-	if (ret)
-		return ret;
-	ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,
-			    acl, NULL, NULL);
-	posix_acl_release(acl);
-	return ret;
-}
-
-/*
- * Initialize the ACLs of a new inode. If parent directory has default ACL,
- * then clone to new inode. Called from ocfs2_mknod.
- */
-int ocfs2_init_acl(handle_t *handle,
-		   struct inode *inode,
-		   struct inode *dir,
-		   struct buffer_head *di_bh,
-		   struct buffer_head *dir_bh,
-		   struct ocfs2_alloc_context *meta_ac,
-		   struct ocfs2_alloc_context *data_ac)
-{
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct posix_acl *acl = NULL;
-	int ret = 0, ret2;
-	umode_t mode;
-
-	if (!S_ISLNK(inode->i_mode)) {
-		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
-			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
-						   dir_bh);
-			if (IS_ERR(acl))
-				return PTR_ERR(acl);
-		}
-		if (!acl) {
-			mode = inode->i_mode & ~current_umask();
-			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
-			if (ret) {
-				mlog_errno(ret);
-				goto cleanup;
-			}
-		}
-	}
-	if ((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) && acl) {
-		if (S_ISDIR(inode->i_mode)) {
-			ret = ocfs2_set_acl(handle, inode, di_bh,
-					    ACL_TYPE_DEFAULT, acl,
-					    meta_ac, data_ac);
-			if (ret)
-				goto cleanup;
-		}
-		mode = inode->i_mode;
-		ret = __posix_acl_create(&acl, GFP_NOFS, &mode);
-		if (ret < 0)
-			return ret;
-
-		ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
-		if (ret2) {
-			mlog_errno(ret2);
-			ret = ret2;
-			goto cleanup;
-		}
-		if (ret > 0) {
-			ret = ocfs2_set_acl(handle, inode,
-					    di_bh, ACL_TYPE_ACCESS,
-					    acl, meta_ac, data_ac);
-		}
-	}
-cleanup:
-	posix_acl_release(acl);
-	return ret;
-}
-
-static size_t ocfs2_xattr_list_acl_access(struct dentry *dentry,
-					  char *list,
-					  size_t list_len,
-					  const char *name,
-					  size_t name_len,
-					  int type)
-{
-	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
-	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
-
-	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
-		return 0;
-
-	if (list && size <= list_len)
-		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
-	return size;
-}
-
-static size_t ocfs2_xattr_list_acl_default(struct dentry *dentry,
-					   char *list,
-					   size_t list_len,
-					   const char *name,
-					   size_t name_len,
-					   int type)
-{
-	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
-	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
-
-	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
-		return 0;
-
-	if (list && size <= list_len)
-		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
-	return size;
-}
-
-static int ocfs2_xattr_get_acl(struct dentry *dentry, const char *name,
-		void *buffer, size_t size, int type)
-{
-	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
-	struct posix_acl *acl;
-	int ret;
-
-	if (strcmp(name, "") != 0)
-		return -EINVAL;
-	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
-		return -EOPNOTSUPP;
-
-	acl = ocfs2_get_acl(dentry->d_inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl == NULL)
-		return -ENODATA;
-	ret = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-	posix_acl_release(acl);
-
-	return ret;
-}
-
-static int ocfs2_xattr_set_acl(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags, int type)
-{
-	struct inode *inode = dentry->d_inode;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct posix_acl *acl;
-	int ret = 0;
-
-	if (strcmp(name, "") != 0)
-		return -EINVAL;
-	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
-		return -EOPNOTSUPP;
-
-	if (!inode_owner_or_capable(inode))
-		return -EPERM;
-
-	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		else if (acl) {
-			ret = posix_acl_valid(acl);
-			if (ret)
-				goto cleanup;
-		}
-	} else
-		acl = NULL;
-
-	ret = ocfs2_set_acl(NULL, inode, NULL, type, acl, NULL, NULL);
-
-cleanup:
-	posix_acl_release(acl);
-	return ret;
-}
-
-const struct xattr_handler ocfs2_xattr_acl_access_handler = {
-	.prefix	= POSIX_ACL_XATTR_ACCESS,
-	.flags	= ACL_TYPE_ACCESS,
-	.list	= ocfs2_xattr_list_acl_access,
-	.get	= ocfs2_xattr_get_acl,
-	.set	= ocfs2_xattr_set_acl,
-};
-
-const struct xattr_handler ocfs2_xattr_acl_default_handler = {
-	.prefix	= POSIX_ACL_XATTR_DEFAULT,
-	.flags	= ACL_TYPE_DEFAULT,
-	.list	= ocfs2_xattr_list_acl_default,
-	.get	= ocfs2_xattr_get_acl,
-	.set	= ocfs2_xattr_set_acl,
-};
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index 071fbd38..3fce68d 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -27,10 +27,13 @@ struct ocfs2_acl_entry {
 };
 
 struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type);
-extern int ocfs2_acl_chmod(struct inode *);
-extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
-			  struct buffer_head *, struct buffer_head *,
-			  struct ocfs2_alloc_context *,
-			  struct ocfs2_alloc_context *);
+int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type);
+int ocfs2_set_acl(handle_t *handle,
+			 struct inode *inode,
+			 struct buffer_head *di_bh,
+			 int type,
+			 struct posix_acl *acl,
+			 struct ocfs2_alloc_context *meta_ac,
+			 struct ocfs2_alloc_context *data_ac);
 
 #endif /* OCFS2_ACL_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6fff128..ac371ad 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1236,7 +1236,7 @@ bail:
 		dqput(transfer_to[qtype]);
 
 	if (!status && attr->ia_valid & ATTR_MODE) {
-		status = ocfs2_acl_chmod(inode);
+		status = posix_acl_chmod(inode);
 		if (status < 0)
 			mlog_errno(status);
 	}
@@ -2661,6 +2661,7 @@ const struct inode_operations ocfs2_file_iops = {
 	.removexattr	= generic_removexattr,
 	.fiemap		= ocfs2_fiemap,
 	.get_acl	= ocfs2_iop_get_acl,
+	.set_acl	= ocfs2_iop_set_acl,
 };
 
 const struct inode_operations ocfs2_special_file_iops = {
@@ -2668,6 +2669,7 @@ const struct inode_operations ocfs2_special_file_iops = {
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
 	.get_acl	= ocfs2_iop_get_acl,
+	.set_acl	= ocfs2_iop_set_acl,
 };
 
 /*
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 4f791f6..c975eed 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -230,6 +230,7 @@ static int ocfs2_mknod(struct inode *dir,
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 	int did_block_signals = 0;
+	struct posix_acl *default_acl = NULL, *acl = NULL;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -331,6 +332,12 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
+	status = posix_acl_create(dir, &mode, &default_acl, &acl);
+	if (status) {
+		mlog_errno(status);
+		goto leave;
+	}
+
 	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
 							    S_ISDIR(mode),
 							    xattr_credits));
@@ -379,8 +386,17 @@ static int ocfs2_mknod(struct inode *dir,
 		inc_nlink(dir);
 	}
 
-	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
-				meta_ac, data_ac);
+	if (default_acl) {
+		status = ocfs2_set_acl(handle, inode, new_fe_bh,
+				       ACL_TYPE_DEFAULT, default_acl,
+				       meta_ac, data_ac);
+	}
+	if (!status && acl) {
+		status = ocfs2_set_acl(handle, inode, new_fe_bh,
+				       ACL_TYPE_ACCESS, acl,
+				       meta_ac, data_ac);
+	}
+
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -419,6 +435,10 @@ static int ocfs2_mknod(struct inode *dir,
 	d_instantiate(dentry, inode);
 	status = 0;
 leave:
+	if (default_acl)
+		posix_acl_release(default_acl);
+	if (acl)
+		posix_acl_release(acl);
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
 	if (handle)
@@ -2504,4 +2524,5 @@ const struct inode_operations ocfs2_dir_iops = {
 	.removexattr	= generic_removexattr,
 	.fiemap         = ocfs2_fiemap,
 	.get_acl	= ocfs2_iop_get_acl,
+	.set_acl	= ocfs2_iop_set_acl,
 };
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 55767e1..6ba4bcb 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -46,6 +46,7 @@
 #include <linux/quotaops.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/posix_acl.h>
 
 struct ocfs2_cow_context {
 	struct inode *inode;
@@ -4268,11 +4269,20 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 	struct inode *inode = old_dentry->d_inode;
 	struct buffer_head *old_bh = NULL;
 	struct inode *new_orphan_inode = NULL;
+	struct posix_acl *default_acl, *acl;
+	umode_t mode;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)))
 		return -EOPNOTSUPP;
 
-	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
+	mode = inode->i_mode;
+	error = posix_acl_create(dir, &mode, &default_acl, &acl);
+	if (error) {
+		mlog_errno(error);
+		goto out;
+	}
+
+	error = ocfs2_create_inode_in_orphan(dir, mode,
 					     &new_orphan_inode);
 	if (error) {
 		mlog_errno(error);
@@ -4303,11 +4313,16 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 	/* If the security isn't preserved, we need to re-initialize them. */
 	if (!preserve) {
 		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
-						    &new_dentry->d_name);
+						    &new_dentry->d_name,
+						    default_acl, acl);
 		if (error)
 			mlog_errno(error);
 	}
 out:
+	if (default_acl)
+		posix_acl_release(default_acl);
+	if (acl)
+		posix_acl_release(acl);
 	if (!error) {
 		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
 						       new_dentry);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f0a1326..185fa3b7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -99,8 +99,8 @@ static struct ocfs2_xattr_def_value_root def_xv = {
 
 const struct xattr_handler *ocfs2_xattr_handlers[] = {
 	&ocfs2_xattr_user_handler,
-	&ocfs2_xattr_acl_access_handler,
-	&ocfs2_xattr_acl_default_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 	&ocfs2_xattr_trusted_handler,
 	&ocfs2_xattr_security_handler,
 	NULL
@@ -109,9 +109,9 @@ const struct xattr_handler *ocfs2_xattr_handlers[] = {
 static const struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_XATTR_MAX] = {
 	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
 	[OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS]
-					= &ocfs2_xattr_acl_access_handler,
+					= &posix_acl_access_xattr_handler,
 	[OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT]
-					= &ocfs2_xattr_acl_default_handler,
+					= &posix_acl_default_xattr_handler,
 	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
 	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
 };
@@ -7190,10 +7190,12 @@ out:
  */
 int ocfs2_init_security_and_acl(struct inode *dir,
 				struct inode *inode,
-				const struct qstr *qstr)
+				const struct qstr *qstr,
+				struct posix_acl *default_acl,
+				struct posix_acl *acl)
 {
-	int ret = 0;
 	struct buffer_head *dir_bh = NULL;
+	int ret = 0;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (ret) {
@@ -7207,9 +7209,10 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 		goto leave;
 	}
 
-	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
-	if (ret)
-		mlog_errno(ret);
+	if (!ret && default_acl)
+		ret = ocfs2_iop_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+	if (!ret && acl)
+		ret = ocfs2_iop_set_acl(inode, acl, ACL_TYPE_ACCESS);
 
 	ocfs2_inode_unlock(dir, 0);
 	brelse(dir_bh);
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 19f134e..f10d5b9 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -40,8 +40,6 @@ struct ocfs2_security_xattr_info {
 extern const struct xattr_handler ocfs2_xattr_user_handler;
 extern const struct xattr_handler ocfs2_xattr_trusted_handler;
 extern const struct xattr_handler ocfs2_xattr_security_handler;
-extern const struct xattr_handler ocfs2_xattr_acl_access_handler;
-extern const struct xattr_handler ocfs2_xattr_acl_default_handler;
 extern const struct xattr_handler *ocfs2_xattr_handlers[];
 
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
@@ -96,5 +94,7 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
 			 bool preserve_security);
 int ocfs2_init_security_and_acl(struct inode *dir,
 				struct inode *inode,
-				const struct qstr *qstr);
+				const struct qstr *qstr,
+				struct posix_acl *default_acl,
+				struct posix_acl *acl);
 #endif /* OCFS2_XATTR_H */
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
