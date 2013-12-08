Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47F2D7F87
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 03:15:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F3F53304039
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 01:15:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id J0tCLBnF928KCAGr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 01:15:02 -0800 (PST)
Date: Sun, 8 Dec 2013 01:14:43 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/18] f2fs: use generic posix ACL infrastructure
Message-ID: <20131208091443.GA13760@infradead.org>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120655.205206019@bombadil.infradead.org>
	<1386293854.2101.8.camel@kjgkr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386293854.2101.8.camel@kjgkr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: cluster-devel@redhat.com, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Fri, Dec 06, 2013 at 10:37:34AM +0900, Jaegeuk Kim wrote:
> f2fs caches a new mode bit for a while to make the consistency between
> xattr's acl mode and the inode mode.

Can you explain what exactly you're trying to do there?  I've been
trying to unwrap what's going on and can't really see the point:

 - i_acl_mode and FI_ACL_MODE get set in __setattr_copy, but right
   after that call, still under i_mutex and before marking the inode
   dirty f2fs_acl_chmod makes use of it, and it gets cleared right
   after. Is there any race that could happen with a locked inode
   not marked dirty yet on f2fs?  We could pass a mode argument
   to posix_acl_create, but I'd prefer to avoid that if we can.
 - on the set_acl side it gets set in __f2fs_set_acl, and then
   i_mode is update in __f2fs_setxattr which could easily done with
   a stack variable.

RFC patch below:


diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 4f52fe0f..6647545 100644
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
@@ -209,11 +206,11 @@ static int __f2fs_set_acl(struct inode *inode, int type,
 			struct posix_acl *acl, struct page *ipage)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct f2fs_inode_info *fi = F2FS_I(inode);
 	int name_index;
 	void *value = NULL;
 	size_t size = 0;
 	int error;
+	umode_t mode = 0;
 
 	if (!test_opt(sbi, POSIX_ACL))
 		return 0;
@@ -224,10 +221,10 @@ static int __f2fs_set_acl(struct inode *inode, int type,
 	case ACL_TYPE_ACCESS:
 		name_index = F2FS_XATTR_INDEX_POSIX_ACL_ACCESS;
 		if (acl) {
-			error = posix_acl_equiv_mode(acl, &inode->i_mode);
+			mode = inode->i_mode;
+			error = posix_acl_equiv_mode(acl, &mode);
 			if (error < 0)
 				return error;
-			set_acl_inode(fi, inode->i_mode);
 			if (error == 0)
 				acl = NULL;
 		}
@@ -245,19 +242,15 @@ static int __f2fs_set_acl(struct inode *inode, int type,
 
 	if (acl) {
 		value = f2fs_acl_to_disk(acl, &size);
-		if (IS_ERR(value)) {
-			cond_clear_inode_flag(fi, FI_ACL_MODE);
+		if (IS_ERR(value))
 			return (int)PTR_ERR(value);
-		}
 	}
 
-	error = f2fs_setxattr(inode, name_index, "", value, size, ipage);
+	error = f2fs_setxattr(inode, name_index, "", value, size, ipage, mode);
 
 	kfree(value);
 	if (!error)
 		set_cached_acl(inode, type, acl);
-
-	cond_clear_inode_flag(fi, FI_ACL_MODE);
 	return error;
 }
 
@@ -289,28 +282,3 @@ int f2fs_init_acl(struct inode *inode, struct inode *dir, struct page *ipage)
 
 	return error;
 }
-
-int f2fs_acl_chmod(struct inode *inode)
-{
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
-
-	error = __posix_acl_chmod(&acl, GFP_KERNEL, mode);
-	if (error)
-		return error;
-
-	error = __f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl, NULL);
-	posix_acl_release(acl);
-	return error;
-}
diff --git a/fs/f2fs/acl.h b/fs/f2fs/acl.h
index 2af31fe..e086465 100644
--- a/fs/f2fs/acl.h
+++ b/fs/f2fs/acl.h
@@ -38,18 +38,12 @@ struct f2fs_acl_header {
 
 extern struct posix_acl *f2fs_get_acl(struct inode *, int);
 extern int f2fs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-extern int f2fs_acl_chmod(struct inode *);
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
index 89dc750..1e774e6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -181,7 +181,6 @@ struct f2fs_inode_info {
 	unsigned char i_advise;		/* use to give file attribute hints */
 	unsigned int i_current_depth;	/* use only in directory structure */
 	unsigned int i_pino;		/* parent inode number */
-	umode_t i_acl_mode;		/* keep file acl mode temporarily */
 
 	/* Use below internally in f2fs*/
 	unsigned long flags;		/* use to pass per-file flags */
@@ -872,7 +871,6 @@ enum {
 	FI_NEW_INODE,		/* indicate newly allocated inode */
 	FI_DIRTY_INODE,		/* indicate inode is dirty or not */
 	FI_INC_LINK,		/* need to increment i_nlink */
-	FI_ACL_MODE,		/* indicate acl mode */
 	FI_NO_ALLOC,		/* should not allocate any blocks */
 	FI_UPDATE_DIR,		/* should update inode block for consistency */
 	FI_DELAY_IPUT,		/* used for the recovery */
@@ -894,21 +892,6 @@ static inline void clear_inode_flag(struct f2fs_inode_info *fi, int flag)
 	clear_bit(flag, &fi->flags);
 }
 
-static inline void set_acl_inode(struct f2fs_inode_info *fi, umode_t mode)
-{
-	fi->i_acl_mode = mode;
-	set_inode_flag(fi, FI_ACL_MODE);
-}
-
-static inline int cond_clear_inode_flag(struct f2fs_inode_info *fi, int flag)
-{
-	if (is_inode_flag_set(fi, FI_ACL_MODE)) {
-		clear_inode_flag(fi, FI_ACL_MODE);
-		return 1;
-	}
-	return 0;
-}
-
 static inline void get_inline_info(struct f2fs_inode_info *fi,
 					struct f2fs_inode *ri)
 {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 13eff60..80ef669 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -339,41 +339,9 @@ int f2fs_getattr(struct vfsmount *mnt,
 	return 0;
 }
 
-#ifdef CONFIG_F2FS_FS_POSIX_ACL
-static void __setattr_copy(struct inode *inode, const struct iattr *attr)
-{
-	struct f2fs_inode_info *fi = F2FS_I(inode);
-	unsigned int ia_valid = attr->ia_valid;
-
-	if (ia_valid & ATTR_UID)
-		inode->i_uid = attr->ia_uid;
-	if (ia_valid & ATTR_GID)
-		inode->i_gid = attr->ia_gid;
-	if (ia_valid & ATTR_ATIME)
-		inode->i_atime = timespec_trunc(attr->ia_atime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_MTIME)
-		inode->i_mtime = timespec_trunc(attr->ia_mtime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_CTIME)
-		inode->i_ctime = timespec_trunc(attr->ia_ctime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_MODE) {
-		umode_t mode = attr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-		set_acl_inode(fi, mode);
-	}
-}
-#else
-#define __setattr_copy setattr_copy
-#endif
-
 int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
-	struct f2fs_inode_info *fi = F2FS_I(inode);
 	int err;
 
 	err = inode_change_ok(inode, attr);
@@ -387,15 +355,9 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 		f2fs_balance_fs(F2FS_SB(inode->i_sb));
 	}
 
-	__setattr_copy(inode, attr);
-
-	if (attr->ia_valid & ATTR_MODE) {
-		err = f2fs_acl_chmod(inode);
-		if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
-			inode->i_mode = fi->i_acl_mode;
-			clear_inode_flag(fi, FI_ACL_MODE);
-		}
-	}
+	setattr_copy(inode, attr);
+	if (attr->ia_valid & ATTR_MODE)
+		err = posix_acl_chmod(inode);
 
 	mark_inode_dirty(inode);
 	return err;
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index e2b9299..8820857 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -108,7 +108,7 @@ static int f2fs_xattr_generic_set(struct dentry *dentry, const char *name,
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 
-	return f2fs_setxattr(dentry->d_inode, type, name, value, size, NULL);
+	return f2fs_setxattr(dentry->d_inode, type, name, value, size, NULL, 0);
 }
 
 static size_t f2fs_xattr_advise_list(struct dentry *dentry, char *list,
@@ -157,7 +157,7 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
 #ifdef CONFIG_F2FS_FS_SECURITY
 static int __f2fs_setxattr(struct inode *inode, int name_index,
 			const char *name, const void *value, size_t value_len,
-			struct page *ipage);
+			struct page *ipage, umode_t mode);
 static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		void *page)
 {
@@ -167,7 +167,7 @@ static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		err = __f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY,
 				xattr->name, xattr->value,
-				xattr->value_len, (struct page *)page);
+				xattr->value_len, (struct page *)page, 0);
 		if (err < 0)
 			break;
 	}
@@ -475,9 +475,8 @@ cleanup:
 
 static int __f2fs_setxattr(struct inode *inode, int name_index,
 			const char *name, const void *value, size_t value_len,
-			struct page *ipage)
+			struct page *ipage, umode_t mode)
 {
-	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_xattr_entry *here, *last;
 	void *base_addr;
 	int found, newsize;
@@ -566,10 +565,9 @@ static int __f2fs_setxattr(struct inode *inode, int name_index,
 	if (error)
 		goto exit;
 
-	if (is_inode_flag_set(fi, FI_ACL_MODE)) {
-		inode->i_mode = fi->i_acl_mode;
+	if (mode) {
+		inode->i_mode = mode;
 		inode->i_ctime = CURRENT_TIME;
-		clear_inode_flag(fi, FI_ACL_MODE);
 	}
 
 	if (ipage)
@@ -582,7 +580,8 @@ exit:
 }
 
 int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
-			const void *value, size_t value_len, struct page *ipage)
+			const void *value, size_t value_len, struct page *ipage,
+			umode_t mode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	int err;
@@ -590,7 +589,8 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 	f2fs_balance_fs(sbi);
 
 	f2fs_lock_op(sbi);
-	err = __f2fs_setxattr(inode, name_index, name, value, value_len, ipage);
+	err = __f2fs_setxattr(inode, name_index, name, value, value_len, ipage,
+			      mode);
 	f2fs_unlock_op(sbi);
 
 	return err;
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index b21d9eb..c73588a 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -114,14 +114,15 @@ extern const struct xattr_handler f2fs_xattr_security_handler;
 extern const struct xattr_handler *f2fs_xattr_handlers[];
 
 extern int f2fs_setxattr(struct inode *, int, const char *,
-				const void *, size_t, struct page *);
+				const void *, size_t, struct page *, umode_t);
 extern int f2fs_getxattr(struct inode *, int, const char *, void *, size_t);
 extern ssize_t f2fs_listxattr(struct dentry *, char *, size_t);
 #else
 
 #define f2fs_xattr_handlers	NULL
 static inline int f2fs_setxattr(struct inode *inode, int name_index,
-		const char *name, const void *value, size_t value_len)
+		const char *name, const void *value, size_t value_len,
+		umode_t mode)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
