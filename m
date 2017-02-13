Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752981AbdBMPcv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Feb 2017 10:32:51 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v28 02/21] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR permission flags
Date: Mon, 13 Feb 2017 16:32:18 +0100
Message-Id: <1486999957-2381-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
References: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>, "J . Bruce Fields" <bfields@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Steve French <steve.french@primarydata.com>, Jeff Layton <jlayton@redhat.com>

Richacls distinguish between creating non-directories and directories.
To support that, add an isdir parameter to may_create(). When checking
inode_permission() for create permission, pass in MAY_CREATE_FILE or
MAY_CREATE_DIR as an additional mask flag.

Add may_replace() to allow checking for delete as well as create access
when replacing an existing file in vfs_rename().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Steve French <steve.french@primarydata.com>
Cc: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c         | 69 +++++++++++++++++++++++++++++++++++++-----------------
 include/linux/fs.h |  2 ++
 2 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 81ae757..4cc7064 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -463,7 +463,9 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
  * this, letting us set arbitrary permissions for filesystem access without
  * changing the "normal" UIDs which are used for other things.
  *
- * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
+ * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FILE, or
+ * MAY_CREATE_DIR are set.  That way, file systems that don't support these
+ * permissions will check for MAY_WRITE instead.
  */
 int inode_permission(struct inode *inode, int mask)
 {
@@ -2732,7 +2734,8 @@ EXPORT_SYMBOL(__check_sticky);
  * 11. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
  */
-static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
+static int may_delete_or_replace(struct inode *dir, struct dentry *victim,
+				 bool isdir, int mask)
 {
 	struct inode *inode = d_backing_inode(victim);
 	int error;
@@ -2744,7 +2747,7 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
 
-	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	error = inode_permission(dir, mask);
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
@@ -2767,6 +2770,20 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 	return 0;
 }
 
+static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
+{
+	return may_delete_or_replace(dir, victim, isdir, MAY_WRITE | MAY_EXEC);
+}
+
+static int may_replace(struct inode *dir, struct dentry *victim,
+		       bool isdir, bool new_isdir)
+{
+	int mask = new_isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
+
+	return may_delete_or_replace(dir, victim, isdir,
+				     mask | MAY_WRITE | MAY_EXEC);
+}
+
 /*	Check whether we can create an object with dentry child in directory
  *  dir.
  *  1. We can't do it if child already exists (open has special treatment for
@@ -2776,9 +2793,11 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
  *  4. We should have write and exec permissions on dir
  *  5. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct inode *dir, struct dentry *child)
+static inline int may_create(struct inode *dir, struct dentry *child, bool isdir)
 {
+	int mask = isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
 	struct user_namespace *s_user_ns;
+
 	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
 	if (child->d_inode)
 		return -EEXIST;
@@ -2788,7 +2807,7 @@ static inline int may_create(struct inode *dir, struct dentry *child)
 	if (!kuid_has_mapping(s_user_ns, current_fsuid()) ||
 	    !kgid_has_mapping(s_user_ns, current_fsgid()))
 		return -EOVERFLOW;
-	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	return inode_permission(dir, MAY_WRITE | MAY_EXEC | mask);
 }
 
 /*
@@ -2838,7 +2857,7 @@ EXPORT_SYMBOL(unlock_rename);
 int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		bool want_excl)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, false);
 	if (error)
 		return error;
 
@@ -3624,7 +3643,7 @@ EXPORT_SYMBOL(user_path_create);
 
 int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, false);
 
 	if (error)
 		return error;
@@ -3718,7 +3737,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, d
 
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, true);
 	unsigned max_links = dir->i_sb->s_max_links;
 
 	if (error)
@@ -3774,7 +3793,7 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	int error = may_delete(dir, dentry, 1);
+	int error = may_delete(dir, dentry, true);
 
 	if (error)
 		return error;
@@ -3896,7 +3915,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 int vfs_unlink(struct inode *dir, struct dentry *dentry, struct inode **delegated_inode)
 {
 	struct inode *target = dentry->d_inode;
-	int error = may_delete(dir, dentry, 0);
+	int error = may_delete(dir, dentry, false);
 
 	if (error)
 		return error;
@@ -4030,7 +4049,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, pathname)
 
 int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, false);
 
 	if (error)
 		return error;
@@ -4113,7 +4132,7 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(dir, new_dentry);
+	error = may_create(dir, new_dentry, false);
 	if (error)
 		return error;
 
@@ -4308,19 +4327,25 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (source == target)
 		return 0;
 
-	error = may_delete(old_dir, old_dentry, is_dir);
-	if (error)
-		return error;
-
 	if (!target) {
-		error = may_create(new_dir, new_dentry);
+		error = may_delete(old_dir, old_dentry, is_dir);
+		if (error)
+			return error;
+		error = may_create(new_dir, new_dentry, is_dir);
 	} else {
 		new_is_dir = d_is_dir(new_dentry);
 
-		if (!(flags & RENAME_EXCHANGE))
-			error = may_delete(new_dir, new_dentry, is_dir);
-		else
-			error = may_delete(new_dir, new_dentry, new_is_dir);
+		if (!(flags & RENAME_EXCHANGE)) {
+			error = may_delete(old_dir, old_dentry, is_dir);
+			if (error)
+				return error;
+			error = may_replace(new_dir, new_dentry, is_dir, is_dir);
+		} else {
+			error = may_replace(old_dir, old_dentry, is_dir, new_is_dir);
+			if (error)
+				return error;
+			error = may_replace(new_dir, new_dentry, new_is_dir, is_dir);
+		}
 	}
 	if (error)
 		return error;
@@ -4574,7 +4599,7 @@ SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newna
 
 int vfs_whiteout(struct inode *dir, struct dentry *dentry)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, false);
 	if (error)
 		return error;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 41042ce..7141760 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -84,6 +84,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define MAY_CHDIR		0x00000040
 /* called from RCU mode, don't block */
 #define MAY_NOT_BLOCK		0x00000080
+#define MAY_CREATE_FILE		0x00000100
+#define MAY_CREATE_DIR		0x00000200
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.7.4

