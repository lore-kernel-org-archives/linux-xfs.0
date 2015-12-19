Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E3EE7F59
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 004718F8068
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:02 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id qOuhaakrtNBq0o2R (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:55:57 -0800 (PST)
Subject: [PATCH 6/9] vfs: pull btrfs clone API to vfs layer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:55:45 -0800
Message-ID: <20151219085545.12478.44385.stgit@birch.djwong.org>
In-Reply-To: <20151219085505.12478.71157.stgit@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

>From : Christoph Hellwig <hch@lst.de>

The btrfs clone ioctls are now adopted by other file systems, with NFS
and CIFS already having support for them, and XFS being under active
development.  To avoid growth of various slightly incompatible
implementations, add one to the VFS.  Note that clones are different from
file copies in several ways:

 - they are atomic vs other writers
 - they support whole file clones
 - they support 64-bit legth clones
 - they do not allow partial success (aka short writes)
 - clones are expected to be a fast metadata operation

Because of that it would be rather cumbersome to try to piggyback them on
top of the recent clone_file_range infrastructure.  The converse isn't
true and the clone_file_range system call could try clone file range as
a first attempt to copy, something that further patches will enable.

Based on earlier work from Peng Tao.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/ctree.h        |    3 +
 fs/btrfs/file.c         |    1 
 fs/btrfs/ioctl.c        |   49 +-----------------
 fs/cifs/cifsfs.c        |   63 ++++++++++++++++++++++++
 fs/cifs/cifsfs.h        |    1 
 fs/cifs/ioctl.c         |  126 ++++++++++++++++++++++-------------------------
 fs/ioctl.c              |   29 +++++++++++
 fs/nfs/nfs4file.c       |   87 ++++----------------------------
 fs/read_write.c         |   72 +++++++++++++++++++++++++++
 include/linux/fs.h      |    7 ++-
 include/uapi/linux/fs.h |    9 +++
 11 files changed, 254 insertions(+), 193 deletions(-)


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ede7277..dd4733f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4025,7 +4025,6 @@ void btrfs_get_block_group_info(struct list_head *groups_list,
 void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
 			       struct btrfs_ioctl_balance_args *bargs);
 
-
 /* file.c */
 int btrfs_auto_defrag_init(void);
 void btrfs_auto_defrag_exit(void);
@@ -4058,6 +4057,8 @@ int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
 ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
 			      struct file *file_out, loff_t pos_out,
 			      size_t len, unsigned int flags);
+int btrfs_clone_file_range(struct file *file_in, loff_t pos_in,
+			   struct file *file_out, loff_t pos_out, u64 len);
 
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e67fe6a..232e300 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2925,6 +2925,7 @@ const struct file_operations btrfs_file_operations = {
 	.compat_ioctl	= btrfs_ioctl,
 #endif
 	.copy_file_range = btrfs_copy_file_range,
+	.clone_file_range = btrfs_clone_file_range,
 };
 
 void btrfs_auto_defrag_exit(void)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0f92735..85b1cae 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3906,49 +3906,10 @@ ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	return ret;
 }
 
-static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
-				       u64 off, u64 olen, u64 destoff)
+int btrfs_clone_file_range(struct file *src_file, loff_t off,
+		struct file *dst_file, loff_t destoff, u64 len)
 {
-	struct fd src_file;
-	int ret;
-
-	/* the destination must be opened for writing */
-	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND))
-		return -EINVAL;
-
-	ret = mnt_want_write_file(file);
-	if (ret)
-		return ret;
-
-	src_file = fdget(srcfd);
-	if (!src_file.file) {
-		ret = -EBADF;
-		goto out_drop_write;
-	}
-
-	/* the src must be open for reading */
-	if (!(src_file.file->f_mode & FMODE_READ)) {
-		ret = -EINVAL;
-		goto out_fput;
-	}
-
-	ret = btrfs_clone_files(file, src_file.file, off, olen, destoff);
-
-out_fput:
-	fdput(src_file);
-out_drop_write:
-	mnt_drop_write_file(file);
-	return ret;
-}
-
-static long btrfs_ioctl_clone_range(struct file *file, void __user *argp)
-{
-	struct btrfs_ioctl_clone_range_args args;
-
-	if (copy_from_user(&args, argp, sizeof(args)))
-		return -EFAULT;
-	return btrfs_ioctl_clone(file, args.src_fd, args.src_offset,
-				 args.src_length, args.dest_offset);
+	return btrfs_clone_files(dst_file, src_file, off, len, destoff);
 }
 
 /*
@@ -5498,10 +5459,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_ioctl_balance(file, NULL);
-	case BTRFS_IOC_CLONE:
-		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
-	case BTRFS_IOC_CLONE_RANGE:
-		return btrfs_ioctl_clone_range(file, argp);
 	case BTRFS_IOC_TRANS_START:
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index cbc0f4b..e9b978f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -914,6 +914,61 @@ const struct inode_operations cifs_symlink_inode_ops = {
 #endif
 };
 
+static int cifs_clone_file_range(struct file *src_file, loff_t off,
+		struct file *dst_file, loff_t destoff, u64 len)
+{
+	struct inode *src_inode = file_inode(src_file);
+	struct inode *target_inode = file_inode(dst_file);
+	struct cifsFileInfo *smb_file_src = src_file->private_data;
+	struct cifsFileInfo *smb_file_target = dst_file->private_data;
+	struct cifs_tcon *src_tcon = tlink_tcon(smb_file_src->tlink);
+	struct cifs_tcon *target_tcon = tlink_tcon(smb_file_target->tlink);
+	unsigned int xid;
+	int rc;
+
+	cifs_dbg(FYI, "clone range\n");
+
+	xid = get_xid();
+
+	if (!src_file->private_data || !dst_file->private_data) {
+		rc = -EBADF;
+		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
+		goto out;
+	}
+
+	/*
+	 * Note: cifs case is easier than btrfs since server responsible for
+	 * checks for proper open modes and file type and if it wants
+	 * server could even support copy of range where source = target
+	 */
+	lock_two_nondirectories(target_inode, src_inode);
+
+	if (len == 0)
+		len = src_inode->i_size - off;
+
+	cifs_dbg(FYI, "about to flush pages\n");
+	/* should we flush first and last page first */
+	truncate_inode_pages_range(&target_inode->i_data, destoff,
+				   PAGE_CACHE_ALIGN(destoff + len)-1);
+
+	if (target_tcon->ses->server->ops->duplicate_extents)
+		rc = target_tcon->ses->server->ops->duplicate_extents(xid,
+			smb_file_src, smb_file_target, off, len, destoff);
+	else
+		rc = -EOPNOTSUPP;
+
+	/* force revalidate of size and timestamps of target file now
+	   that target is updated on the server */
+	CIFS_I(target_inode)->time = 0;
+out_unlock:
+	/* although unlocking in the reverse order from locking is not
+	   strictly necessary here it is a little cleaner to be consistent */
+	unlock_two_nondirectories(src_inode, target_inode);
+out:
+	free_xid(xid);
+	return rc;
+}
+
 const struct file_operations cifs_file_ops = {
 	.read_iter = cifs_loose_read_iter,
 	.write_iter = cifs_file_write_iter,
@@ -926,6 +981,7 @@ const struct file_operations cifs_file_ops = {
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 	.unlocked_ioctl	= cifs_ioctl,
+	.clone_file_range = cifs_clone_file_range,
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
 };
@@ -942,6 +998,8 @@ const struct file_operations cifs_file_strict_ops = {
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 	.unlocked_ioctl	= cifs_ioctl,
+	.clone_file_range = cifs_clone_file_range,
+	.clone_file_range = cifs_clone_file_range,
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
 };
@@ -958,6 +1016,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
 	.unlocked_ioctl  = cifs_ioctl,
+	.clone_file_range = cifs_clone_file_range,
 	.llseek = cifs_llseek,
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
@@ -974,6 +1033,7 @@ const struct file_operations cifs_file_nobrl_ops = {
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 	.unlocked_ioctl	= cifs_ioctl,
+	.clone_file_range = cifs_clone_file_range,
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
 };
@@ -989,6 +1049,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 	.unlocked_ioctl	= cifs_ioctl,
+	.clone_file_range = cifs_clone_file_range,
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
 };
@@ -1004,6 +1065,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
 	.unlocked_ioctl  = cifs_ioctl,
+	.clone_file_range = cifs_clone_file_range,
 	.llseek = cifs_llseek,
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
@@ -1014,6 +1076,7 @@ const struct file_operations cifs_dir_ops = {
 	.release = cifs_closedir,
 	.read    = generic_read_dir,
 	.unlocked_ioctl  = cifs_ioctl,
+	.clone_file_range = cifs_clone_file_range,
 	.llseek = generic_file_llseek,
 };
 
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index c3cc160..c399513 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -131,7 +131,6 @@ extern int	cifs_setxattr(struct dentry *, const char *, const void *,
 extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
-
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 extern const struct export_operations cifs_export_ops;
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 35cf990..7a3b84e 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -34,73 +34,36 @@
 #include "cifs_ioctl.h"
 #include <linux/btrfs.h>
 
-static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
-			unsigned long srcfd, u64 off, u64 len, u64 destoff,
-			bool dup_extents)
+static int cifs_file_clone_range(unsigned int xid, struct file *src_file,
+			  struct file *dst_file)
 {
-	int rc;
-	struct cifsFileInfo *smb_file_target = dst_file->private_data;
+	struct inode *src_inode = file_inode(src_file);
 	struct inode *target_inode = file_inode(dst_file);
-	struct cifs_tcon *target_tcon;
-	struct fd src_file;
 	struct cifsFileInfo *smb_file_src;
-	struct inode *src_inode;
+	struct cifsFileInfo *smb_file_target;
 	struct cifs_tcon *src_tcon;
+	struct cifs_tcon *target_tcon;
+	int rc;
 
 	cifs_dbg(FYI, "ioctl clone range\n");
-	/* the destination must be opened for writing */
-	if (!(dst_file->f_mode & FMODE_WRITE)) {
-		cifs_dbg(FYI, "file target not open for write\n");
-		return -EINVAL;
-	}
 
-	/* check if target volume is readonly and take reference */
-	rc = mnt_want_write_file(dst_file);
-	if (rc) {
-		cifs_dbg(FYI, "mnt_want_write failed with rc %d\n", rc);
-		return rc;
-	}
-
-	src_file = fdget(srcfd);
-	if (!src_file.file) {
-		rc = -EBADF;
-		goto out_drop_write;
-	}
-
-	if (src_file.file->f_op->unlocked_ioctl != cifs_ioctl) {
-		rc = -EBADF;
-		cifs_dbg(VFS, "src file seems to be from a different filesystem type\n");
-		goto out_fput;
-	}
-
-	if ((!src_file.file->private_data) || (!dst_file->private_data)) {
+	if (!src_file->private_data || !dst_file->private_data) {
 		rc = -EBADF;
 		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
-		goto out_fput;
+		goto out;
 	}
 
 	rc = -EXDEV;
 	smb_file_target = dst_file->private_data;
-	smb_file_src = src_file.file->private_data;
+	smb_file_src = src_file->private_data;
 	src_tcon = tlink_tcon(smb_file_src->tlink);
 	target_tcon = tlink_tcon(smb_file_target->tlink);
 
-	/* check source and target on same server (or volume if dup_extents) */
-	if (dup_extents && (src_tcon != target_tcon)) {
-		cifs_dbg(VFS, "source and target of copy not on same share\n");
-		goto out_fput;
-	}
-
-	if (!dup_extents && (src_tcon->ses != target_tcon->ses)) {
+	if (src_tcon->ses != target_tcon->ses) {
 		cifs_dbg(VFS, "source and target of copy not on same server\n");
-		goto out_fput;
+		goto out;
 	}
 
-	src_inode = file_inode(src_file.file);
-	rc = -EINVAL;
-	if (S_ISDIR(src_inode->i_mode))
-		goto out_fput;
-
 	/*
 	 * Note: cifs case is easier than btrfs since server responsible for
 	 * checks for proper open modes and file type and if it wants
@@ -108,34 +71,66 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
 
-	/* determine range to clone */
-	rc = -EINVAL;
-	if (off + len > src_inode->i_size || off + len < off)
-		goto out_unlock;
-	if (len == 0)
-		len = src_inode->i_size - off;
-
 	cifs_dbg(FYI, "about to flush pages\n");
 	/* should we flush first and last page first */
-	truncate_inode_pages_range(&target_inode->i_data, destoff,
-				   PAGE_CACHE_ALIGN(destoff + len)-1);
+	truncate_inode_pages(&target_inode->i_data, 0);
 
-	if (dup_extents && target_tcon->ses->server->ops->duplicate_extents)
-		rc = target_tcon->ses->server->ops->duplicate_extents(xid,
-			smb_file_src, smb_file_target, off, len, destoff);
-	else if (!dup_extents && target_tcon->ses->server->ops->clone_range)
+	if (target_tcon->ses->server->ops->clone_range)
 		rc = target_tcon->ses->server->ops->clone_range(xid,
-			smb_file_src, smb_file_target, off, len, destoff);
+			smb_file_src, smb_file_target, 0, src_inode->i_size, 0);
 	else
 		rc = -EOPNOTSUPP;
 
 	/* force revalidate of size and timestamps of target file now
 	   that target is updated on the server */
 	CIFS_I(target_inode)->time = 0;
-out_unlock:
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
 	unlock_two_nondirectories(src_inode, target_inode);
+out:
+	return rc;
+}
+
+static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
+			unsigned long srcfd)
+{
+	int rc;
+	struct fd src_file;
+	struct inode *src_inode;
+
+	cifs_dbg(FYI, "ioctl clone range\n");
+	/* the destination must be opened for writing */
+	if (!(dst_file->f_mode & FMODE_WRITE)) {
+		cifs_dbg(FYI, "file target not open for write\n");
+		return -EINVAL;
+	}
+
+	/* check if target volume is readonly and take reference */
+	rc = mnt_want_write_file(dst_file);
+	if (rc) {
+		cifs_dbg(FYI, "mnt_want_write failed with rc %d\n", rc);
+		return rc;
+	}
+
+	src_file = fdget(srcfd);
+	if (!src_file.file) {
+		rc = -EBADF;
+		goto out_drop_write;
+	}
+
+	if (src_file.file->f_op->unlocked_ioctl != cifs_ioctl) {
+		rc = -EBADF;
+		cifs_dbg(VFS, "src file seems to be from a different filesystem type\n");
+		goto out_fput;
+	}
+
+	src_inode = file_inode(src_file.file);
+	rc = -EINVAL;
+	if (S_ISDIR(src_inode->i_mode))
+		goto out_fput;
+
+	rc = cifs_file_clone_range(xid, src_file.file, dst_file);
+
 out_fput:
 	fdput(src_file);
 out_drop_write:
@@ -256,10 +251,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			}
 			break;
 		case CIFS_IOC_COPYCHUNK_FILE:
-			rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, false);
-			break;
-		case BTRFS_IOC_CLONE:
-			rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, true);
+			rc = cifs_ioctl_clone(xid, filep, arg);
 			break;
 		case CIFS_IOC_SET_INTEGRITY:
 			if (pSMBFile == NULL)
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 5d01d26..84c6e79 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -215,6 +215,29 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 	return error;
 }
 
+static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
+			     u64 off, u64 olen, u64 destoff)
+{
+	struct fd src_file = fdget(srcfd);
+	int ret;
+
+	if (!src_file.file)
+		return -EBADF;
+	ret = vfs_clone_file_range(src_file.file, off, dst_file, destoff, olen);
+	fdput(src_file);
+	return ret;
+}
+
+static long ioctl_file_clone_range(struct file *file, void __user *argp)
+{
+	struct file_clone_range args;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+	return ioctl_file_clone(file, args.src_fd, args.src_offset,
+				args.src_length, args.dest_offset);
+}
+
 #ifdef CONFIG_BLOCK
 
 static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
@@ -600,6 +623,12 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FICLONE:
+		return ioctl_file_clone(filp, arg, 0, 0, 0);
+
+	case FICLONERANGE:
+		return ioctl_file_clone_range(filp, argp);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index db9b5fe..26f9a23 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -195,65 +195,27 @@ static long nfs42_fallocate(struct file *filep, int mode, loff_t offset, loff_t
 	return nfs42_proc_allocate(filep, offset, len);
 }
 
-static noinline long
-nfs42_ioctl_clone(struct file *dst_file, unsigned long srcfd,
-		  u64 src_off, u64 dst_off, u64 count)
+static int nfs42_clone_file_range(struct file *src_file, loff_t src_off,
+		struct file *dst_file, loff_t dst_off, u64 count)
 {
 	struct inode *dst_inode = file_inode(dst_file);
 	struct nfs_server *server = NFS_SERVER(dst_inode);
-	struct fd src_file;
-	struct inode *src_inode;
+	struct inode *src_inode = file_inode(src_file);
 	unsigned int bs = server->clone_blksize;
 	bool same_inode = false;
 	int ret;
 
-	/* dst file must be opened for writing */
-	if (!(dst_file->f_mode & FMODE_WRITE))
-		return -EINVAL;
-
-	ret = mnt_want_write_file(dst_file);
-	if (ret)
-		return ret;
-
-	src_file = fdget(srcfd);
-	if (!src_file.file) {
-		ret = -EBADF;
-		goto out_drop_write;
-	}
-
-	src_inode = file_inode(src_file.file);
-
-	if (src_inode == dst_inode)
-		same_inode = true;
-
-	/* src file must be opened for reading */
-	if (!(src_file.file->f_mode & FMODE_READ))
-		goto out_fput;
-
-	/* src and dst must be regular files */
-	ret = -EISDIR;
-	if (!S_ISREG(src_inode->i_mode) || !S_ISREG(dst_inode->i_mode))
-		goto out_fput;
-
-	ret = -EXDEV;
-	if (src_file.file->f_path.mnt != dst_file->f_path.mnt ||
-	    src_inode->i_sb != dst_inode->i_sb)
-		goto out_fput;
-
 	/* check alignment w.r.t. clone_blksize */
 	ret = -EINVAL;
 	if (bs) {
 		if (!IS_ALIGNED(src_off, bs) || !IS_ALIGNED(dst_off, bs))
-			goto out_fput;
+			goto out;
 		if (!IS_ALIGNED(count, bs) && i_size_read(src_inode) != (src_off + count))
-			goto out_fput;
+			goto out;
 	}
 
-	/* verify if ranges are overlapped within the same file */
-	if (same_inode) {
-		if (dst_off + count > src_off && dst_off < src_off + count)
-			goto out_fput;
-	}
+	if (src_inode == dst_inode)
+		same_inode = true;
 
 	/* XXX: do we lock at all? what if server needs CB_RECALL_LAYOUT? */
 	if (same_inode) {
@@ -275,7 +237,7 @@ nfs42_ioctl_clone(struct file *dst_file, unsigned long srcfd,
 	if (ret)
 		goto out_unlock;
 
-	ret = nfs42_proc_clone(src_file.file, dst_file, src_off, dst_off, count);
+	ret = nfs42_proc_clone(src_file, dst_file, src_off, dst_off, count);
 
 	/* truncate inode page cache of the dst range so that future reads can fetch
 	 * new data from server */
@@ -292,37 +254,9 @@ out_unlock:
 		mutex_unlock(&dst_inode->i_mutex);
 		mutex_unlock(&src_inode->i_mutex);
 	}
-out_fput:
-	fdput(src_file);
-out_drop_write:
-	mnt_drop_write_file(dst_file);
+out:
 	return ret;
 }
-
-static long nfs42_ioctl_clone_range(struct file *dst_file, void __user *argp)
-{
-	struct btrfs_ioctl_clone_range_args args;
-
-	if (copy_from_user(&args, argp, sizeof(args)))
-		return -EFAULT;
-
-	return nfs42_ioctl_clone(dst_file, args.src_fd, args.src_offset,
-				 args.dest_offset, args.src_length);
-}
-
-long nfs4_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-
-	switch (cmd) {
-	case BTRFS_IOC_CLONE:
-		return nfs42_ioctl_clone(file, arg, 0, 0, 0);
-	case BTRFS_IOC_CLONE_RANGE:
-		return nfs42_ioctl_clone_range(file, argp);
-	}
-
-	return -ENOTTY;
-}
 #endif /* CONFIG_NFS_V4_2 */
 
 const struct file_operations nfs4_file_operations = {
@@ -342,8 +276,7 @@ const struct file_operations nfs4_file_operations = {
 #ifdef CONFIG_NFS_V4_2
 	.llseek		= nfs4_file_llseek,
 	.fallocate	= nfs42_fallocate,
-	.unlocked_ioctl = nfs4_ioctl,
-	.compat_ioctl	= nfs4_ioctl,
+	.clone_file_range = nfs42_clone_file_range,
 #else
 	.llseek		= nfs_file_llseek,
 #endif
diff --git a/fs/read_write.c b/fs/read_write.c
index e4c09dc..6395c733 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1451,3 +1451,75 @@ out1:
 out2:
 	return ret;
 }
+
+static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
+{
+	struct inode *inode = file_inode(file);
+
+	if (unlikely(pos < 0))
+		return -EINVAL;
+
+	 if (unlikely((loff_t) (pos + len) < 0))
+		return -EINVAL;
+
+	if (unlikely(inode->i_flctx && mandatory_lock(inode))) {
+		loff_t end = len ? pos + len - 1 : OFFSET_MAX;
+		int retval;
+
+		retval = locks_mandatory_area(file, pos, end,
+				write ? F_WRLCK : F_RDLCK);
+		if (retval < 0)
+			return retval;
+	}
+
+	return security_file_permission(file, write ? MAY_WRITE : MAY_READ);
+}
+
+int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
+		struct file *file_out, loff_t pos_out, u64 len)
+{
+	struct inode *inode_in = file_inode(file_in);
+	struct inode *inode_out = file_inode(file_out);
+	int ret;
+
+	if (inode_in->i_sb != inode_out->i_sb ||
+	    file_in->f_path.mnt != file_out->f_path.mnt)
+		return -EXDEV;
+
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		return -EISDIR;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		return -EOPNOTSUPP;
+
+	if (!(file_in->f_mode & FMODE_READ) ||
+	    !(file_out->f_mode & FMODE_WRITE) ||
+	    (file_out->f_flags & O_APPEND) ||
+	    !file_in->f_op->clone_file_range)
+		return -EBADF;
+
+	ret = clone_verify_area(file_in, pos_in, len, false);
+	if (ret)
+		return ret;
+
+	ret = clone_verify_area(file_out, pos_out, len, true);
+	if (ret)
+		return ret;
+
+	if (pos_in + len > i_size_read(inode_in))
+		return -EINVAL;
+
+	ret = mnt_want_write_file(file_out);
+	if (ret)
+		return ret;
+
+	ret = file_in->f_op->clone_file_range(file_in, pos_in,
+			file_out, pos_out, len);
+	if (!ret) {
+		fsnotify_access(file_in);
+		fsnotify_modify(file_out);
+	}
+
+	mnt_drop_write_file(file_out);
+	return ret;
+}
+EXPORT_SYMBOL(vfs_clone_file_range);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73874cd..26b7607 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1629,7 +1629,10 @@ struct file_operations {
 #ifndef CONFIG_MMU
 	unsigned (*mmap_capabilities)(struct file *);
 #endif
-	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
+	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
+			loff_t, size_t, unsigned int);
+	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
+			u64);
 };
 
 struct inode_operations {
@@ -1683,6 +1686,8 @@ extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
+extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
+		struct file *file_out, loff_t pos_out, u64 len);
 
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 6decbac..ad60359 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -39,6 +39,13 @@
 #define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
 #define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
 
+struct file_clone_range {
+	__s64 src_fd;
+	__u64 src_offset;
+	__u64 src_length;
+	__u64 dest_offset;
+};
+
 struct fstrim_range {
 	__u64 start;
 	__u64 len;
@@ -168,6 +175,8 @@ struct blkzeroout2 {
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#define FICLONE		_IOW(0x94, 9, int)
+#define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
