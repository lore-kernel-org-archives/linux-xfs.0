Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC4B529E07
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 09:55:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 916ED8F804C
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 07:55:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wAWOklr2Dif2PtXN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 07:55:37 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v19 02/23] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
	permission flags
Date: Mon, 14 Mar 2016 15:55:01 +0100
Message-Id: <1457967322-14886-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1457967322-14886-1-git-send-email-agruenba@redhat.com>
References: <1457967322-14886-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

Richacls distinguish between creating non-directories and directories. To
support that, add an isdir parameter to may_create(). When checking
inode_permission() for create permission, pass in an additional
MAY_CREATE_FILE or MAY_CREATE_DIR mask flag.

Add may_replace() to allow checking for delete and create access when
replacing an existing file in vfs_rename().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/namei.c         | 49 +++++++++++++++++++++++++++++++++----------------
 include/linux/fs.h |  2 ++
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 68e1056..2092742 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -453,7 +453,9 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
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
@@ -2616,7 +2618,8 @@ EXPORT_SYMBOL(__check_sticky);
  * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
  */
-static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
+static int may_delete_or_replace(struct inode *dir, struct dentry *victim,
+				 bool isdir, int mask)
 {
 	struct inode *inode = d_backing_inode(victim);
 	int error;
@@ -2628,7 +2631,7 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
 
-	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	error = inode_permission(dir, mask);
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
@@ -2651,6 +2654,18 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 	return 0;
 }
 
+static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
+{
+	return may_delete_or_replace(dir, victim, isdir, MAY_WRITE | MAY_EXEC);
+}
+
+static int may_replace(struct inode *dir, struct dentry *victim, bool isdir)
+{
+	int mask = isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
+
+	return may_delete_or_replace(dir, victim, isdir, mask | MAY_WRITE | MAY_EXEC);
+}
+
 /*	Check whether we can create an object with dentry child in directory
  *  dir.
  *  1. We can't do it if child already exists (open has special treatment for
@@ -2659,14 +2674,16 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
  *  3. We should have write and exec permissions on dir
  *  4. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct inode *dir, struct dentry *child)
+static inline int may_create(struct inode *dir, struct dentry *child, bool isdir)
 {
+	int mask = isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
+
 	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
 	if (child->d_inode)
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
-	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	return inode_permission(dir, MAY_WRITE | MAY_EXEC | mask);
 }
 
 /*
@@ -2716,7 +2733,7 @@ EXPORT_SYMBOL(unlock_rename);
 int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		bool want_excl)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, false);
 	if (error)
 		return error;
 
@@ -3561,7 +3578,7 @@ EXPORT_SYMBOL(user_path_create);
 
 int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, false);
 
 	if (error)
 		return error;
@@ -3653,7 +3670,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, d
 
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, true);
 	unsigned max_links = dir->i_sb->s_max_links;
 
 	if (error)
@@ -3734,7 +3751,7 @@ EXPORT_SYMBOL(dentry_unhash);
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	int error = may_delete(dir, dentry, 1);
+	int error = may_delete(dir, dentry, true);
 
 	if (error)
 		return error;
@@ -3856,7 +3873,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 int vfs_unlink(struct inode *dir, struct dentry *dentry, struct inode **delegated_inode)
 {
 	struct inode *target = dentry->d_inode;
-	int error = may_delete(dir, dentry, 0);
+	int error = may_delete(dir, dentry, false);
 
 	if (error)
 		return error;
@@ -3990,7 +4007,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, pathname)
 
 int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, false);
 
 	if (error)
 		return error;
@@ -4073,7 +4090,7 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(dir, new_dentry);
+	error = may_create(dir, new_dentry, false);
 	if (error)
 		return error;
 
@@ -4266,14 +4283,14 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return error;
 
 	if (!target) {
-		error = may_create(new_dir, new_dentry);
+		error = may_create(new_dir, new_dentry, is_dir);
 	} else {
 		new_is_dir = d_is_dir(new_dentry);
 
 		if (!(flags & RENAME_EXCHANGE))
-			error = may_delete(new_dir, new_dentry, is_dir);
+			error = may_replace(new_dir, new_dentry, is_dir);
 		else
-			error = may_delete(new_dir, new_dentry, new_is_dir);
+			error = may_replace(new_dir, new_dentry, new_is_dir);
 	}
 	if (error)
 		return error;
@@ -4536,7 +4553,7 @@ SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newna
 
 int vfs_whiteout(struct inode *dir, struct dentry *dentry)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, false);
 	if (error)
 		return error;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d2b59..02e99d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -83,6 +83,8 @@ typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
 #define MAY_CHDIR		0x00000040
 /* called from RCU mode, don't block */
 #define MAY_NOT_BLOCK		0x00000080
+#define MAY_CREATE_FILE		0x00000100
+#define MAY_CREATE_DIR		0x00000200
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
