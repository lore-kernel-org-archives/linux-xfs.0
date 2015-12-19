Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D9B3A7F50
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:55:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F096AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:55:40 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id VqVFTceHv91EmeHO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:55:38 -0800 (PST)
Subject: [PATCH 3/9] btrfs: add .copy_file_range file operation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:55:25 -0800
Message-ID: <20151219085525.12478.98763.stgit@birch.djwong.org>
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
Cc: Zach Brown <zab@redhat.com>, Josef Bacik <jbacik@fb.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, David Sterba <dsterba@suse.com>, Anna Schumaker <Anna.Schumaker@Netapp.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

>From : Anna Schumaker <Anna.Schumaker@Netapp.com>
>From : Zach Brown <zab@redhat.com>

This rearranges the existing COPY_RANGE ioctl implementation so that the
.copy_file_range file operation can call the core loop that copies file
data extent items.

The extent copying loop is lifted up into its own function.  It retains
the core btrfs error checks that should be shared.

Signed-off-by: Zach Brown <zab@redhat.com>
[Anna Schumaker: Make flags an unsigned int,
                 Check for COPY_FR_REFLINK]
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/ctree.h |    3 ++
 fs/btrfs/file.c  |    1 +
 fs/btrfs/ioctl.c |   91 +++++++++++++++++++++++++++++++-----------------------
 3 files changed, 56 insertions(+), 39 deletions(-)


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 35489e7..ede7277 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4055,6 +4055,9 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 		      loff_t pos, size_t write_bytes,
 		      struct extent_state **cached);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
+ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
+			      struct file *file_out, loff_t pos_out,
+			      size_t len, unsigned int flags);
 
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 72e7346..e67fe6a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2924,6 +2924,7 @@ const struct file_operations btrfs_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= btrfs_ioctl,
 #endif
+	.copy_file_range = btrfs_copy_file_range,
 };
 
 void btrfs_auto_defrag_exit(void)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index da94138..0f92735 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3779,17 +3779,16 @@ out:
 	return ret;
 }
 
-static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
-				       u64 off, u64 olen, u64 destoff)
+static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
+					u64 off, u64 olen, u64 destoff)
 {
 	struct inode *inode = file_inode(file);
+	struct inode *src = file_inode(file_src);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct fd src_file;
-	struct inode *src;
 	int ret;
 	u64 len = olen;
 	u64 bs = root->fs_info->sb->s_blocksize;
-	int same_inode = 0;
+	int same_inode = src == inode;
 
 	/*
 	 * TODO:
@@ -3802,49 +3801,20 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	 *   be either compressed or non-compressed.
 	 */
 
-	/* the destination must be opened for writing */
-	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND))
-		return -EINVAL;
-
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
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
-	ret = -EXDEV;
-	if (src_file.file->f_path.mnt != file->f_path.mnt)
-		goto out_fput;
-
-	src = file_inode(src_file.file);
-
-	ret = -EINVAL;
-	if (src == inode)
-		same_inode = 1;
-
-	/* the src must be open for reading */
-	if (!(src_file.file->f_mode & FMODE_READ))
-		goto out_fput;
+	if (file_src->f_path.mnt != file->f_path.mnt ||
+	    src->i_sb != inode->i_sb)
+		return -EXDEV;
 
 	/* don't make the dst file partly checksummed */
 	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
 	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
-		goto out_fput;
+		return -EINVAL;
 
-	ret = -EISDIR;
 	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
-		goto out_fput;
-
-	ret = -EXDEV;
-	if (src->i_sb != inode->i_sb)
-		goto out_fput;
+		return -EISDIR;
 
 	if (!same_inode) {
 		btrfs_double_inode_lock(src, inode);
@@ -3921,6 +3891,49 @@ out_unlock:
 		btrfs_double_inode_unlock(src, inode);
 	else
 		mutex_unlock(&src->i_mutex);
+	return ret;
+}
+
+ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
+			      struct file *file_out, loff_t pos_out,
+			      size_t len, unsigned int flags)
+{
+	ssize_t ret;
+
+	ret = btrfs_clone_files(file_out, file_in, pos_in, len, pos_out);
+	if (ret == 0)
+		ret = len;
+	return ret;
+}
+
+static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
+				       u64 off, u64 olen, u64 destoff)
+{
+	struct fd src_file;
+	int ret;
+
+	/* the destination must be opened for writing */
+	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND))
+		return -EINVAL;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	src_file = fdget(srcfd);
+	if (!src_file.file) {
+		ret = -EBADF;
+		goto out_drop_write;
+	}
+
+	/* the src must be open for reading */
+	if (!(src_file.file->f_mode & FMODE_READ)) {
+		ret = -EINVAL;
+		goto out_fput;
+	}
+
+	ret = btrfs_clone_files(file, src_file.file, off, olen, destoff);
+
 out_fput:
 	fdput(src_file);
 out_drop_write:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
