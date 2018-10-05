Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52562 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbeJEHl4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:56 -0400
Subject: [PATCH 08/15] vfs: change clone and dedupe range function pointers
 to return bytes completed
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:45:35 -0700
Message-ID: <153870033496.29072.3660384210745578982.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the clone_file_range and dedupe_file_range functions to return
the number of bytes they operated on.  This is the precursor to allowing
fs implementations to return short clone/dedupe results to the user,
which will enable us to obey resource limits in a graceful manner.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/ctree.h    |    4 ++--
 fs/btrfs/ioctl.c    |   13 +++++++++----
 fs/nfs/nfs4file.c   |    4 ++--
 fs/ocfs2/file.c     |   18 ++++++++++++------
 fs/overlayfs/file.c |   18 ++++++++++++------
 fs/read_write.c     |   31 ++++++++++++++++++-------------
 fs/xfs/xfs_file.c   |   18 ++++++++++++------
 include/linux/fs.h  |   12 +++++++-----
 8 files changed, 74 insertions(+), 44 deletions(-)


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2cddfe7806a4..864651257142 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3218,7 +3218,7 @@ void btrfs_get_block_group_info(struct list_head *groups_list,
 				struct btrfs_ioctl_space_info *space);
 void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 			       struct btrfs_ioctl_balance_args *bargs);
-int btrfs_dedupe_file_range(struct file *src_file, loff_t src_loff,
+s64 btrfs_dedupe_file_range(struct file *src_file, loff_t src_loff,
 			    struct file *dst_file, loff_t dst_loff,
 			    u64 olen);
 
@@ -3250,7 +3250,7 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      size_t num_pages, loff_t pos, size_t write_bytes,
 		      struct extent_state **cached);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
-int btrfs_clone_file_range(struct file *file_in, loff_t pos_in,
+s64 btrfs_clone_file_range(struct file *file_in, loff_t pos_in,
 			   struct file *file_out, loff_t pos_out, u64 len);
 
 /* tree-defrag.c */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d60b6caf09e8..35ba974f1333 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3627,13 +3627,14 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	return ret;
 }
 
-int btrfs_dedupe_file_range(struct file *src_file, loff_t src_loff,
+s64 btrfs_dedupe_file_range(struct file *src_file, loff_t src_loff,
 			    struct file *dst_file, loff_t dst_loff,
 			    u64 olen)
 {
 	struct inode *src = file_inode(src_file);
 	struct inode *dst = file_inode(dst_file);
 	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
+	int ret;
 
 	if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
 		/*
@@ -3644,7 +3645,8 @@ int btrfs_dedupe_file_range(struct file *src_file, loff_t src_loff,
 		return -EINVAL;
 	}
 
-	return btrfs_extent_same(src, src_loff, olen, dst, dst_loff);
+	ret = btrfs_extent_same(src, src_loff, olen, dst, dst_loff);
+	return ret < 0 ? ret : olen;
 }
 
 static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
@@ -4348,10 +4350,13 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	return ret;
 }
 
-int btrfs_clone_file_range(struct file *src_file, loff_t off,
+s64 btrfs_clone_file_range(struct file *src_file, loff_t off,
 		struct file *dst_file, loff_t destoff, u64 len)
 {
-	return btrfs_clone_files(dst_file, src_file, off, len, destoff);
+	int ret;
+
+	ret = btrfs_clone_files(dst_file, src_file, off, len, destoff);
+	return ret < 0 ? ret : len;
 }
 
 static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 4288a6ecaf75..f914861f844f 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -180,7 +180,7 @@ static long nfs42_fallocate(struct file *filep, int mode, loff_t offset, loff_t
 	return nfs42_proc_allocate(filep, offset, len);
 }
 
-static int nfs42_clone_file_range(struct file *src_file, loff_t src_off,
+static s64 nfs42_clone_file_range(struct file *src_file, loff_t src_off,
 		struct file *dst_file, loff_t dst_off, u64 count)
 {
 	struct inode *dst_inode = file_inode(dst_file);
@@ -240,7 +240,7 @@ static int nfs42_clone_file_range(struct file *src_file, loff_t src_off,
 		inode_unlock(src_inode);
 	}
 out:
-	return ret;
+	return ret < 0 ? ret : count;
 }
 #endif /* CONFIG_NFS_V4_2 */
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9fa35cb6f6e0..c4b78ee4a593 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2527,24 +2527,30 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
 	return offset;
 }
 
-static int ocfs2_file_clone_range(struct file *file_in,
+static s64 ocfs2_file_clone_range(struct file *file_in,
 				  loff_t pos_in,
 				  struct file *file_out,
 				  loff_t pos_out,
 				  u64 len)
 {
-	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					 len, false);
+	int ret;
+
+	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+					len, false);
+	return ret < 0 ? ret : len;
 }
 
-static int ocfs2_file_dedupe_range(struct file *file_in,
+static s64 ocfs2_file_dedupe_range(struct file *file_in,
 				   loff_t pos_in,
 				   struct file *file_out,
 				   loff_t pos_out,
 				   u64 len)
 {
-	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					  len, true);
+	int ret;
+
+	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+					len, true);
+	return ret < 0 ? ret : len;
 }
 
 const struct inode_operations ocfs2_file_iops = {
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index aeaefd2a551b..6d792d817538 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -487,16 +487,21 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
 			    OVL_COPY);
 }
 
-static int ovl_clone_file_range(struct file *file_in, loff_t pos_in,
+static s64 ovl_clone_file_range(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out, u64 len)
 {
-	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
-			    OVL_CLONE);
+	int ret;
+
+	ret = ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
+			   OVL_CLONE);
+	return ret < 0 ? ret : len;
 }
 
-static int ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
+static s64 ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
 				 struct file *file_out, loff_t pos_out, u64 len)
 {
+	int ret;
+
 	/*
 	 * Don't copy up because of a dedupe request, this wouldn't make sense
 	 * most of the time (data would be duplicated instead of deduplicated).
@@ -505,8 +510,9 @@ static int ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
 	    !ovl_inode_upper(file_inode(file_out)))
 		return -EPERM;
 
-	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
-			    OVL_DEDUPE);
+	ret = ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
+			   OVL_DEDUPE);
+	return ret < 0 ? ret : len;
 }
 
 const struct file_operations ovl_file_operations = {
diff --git a/fs/read_write.c b/fs/read_write.c
index 99b2f809180c..f51751281454 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1589,10 +1589,12 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	 * more efficient if both clone and copy are supported (e.g. NFS).
 	 */
 	if (file_in->f_op->clone_file_range) {
-		ret = file_in->f_op->clone_file_range(file_in, pos_in,
-				file_out, pos_out, len);
-		if (ret == 0) {
-			ret = len;
+		s64 cloned;
+
+		cloned = file_in->f_op->clone_file_range(file_in, pos_in,
+				file_out, pos_out, min(MAX_RW_COUNT, len));
+		if (cloned >= 0) {
+			ret = cloned;
 			goto done;
 		}
 	}
@@ -1799,6 +1801,7 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
+	s64 cloned;
 	int ret;
 
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
@@ -1830,14 +1833,16 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
-	ret = file_in->f_op->clone_file_range(file_in, pos_in,
+	cloned = file_in->f_op->clone_file_range(file_in, pos_in,
 			file_out, pos_out, len);
-	if (!ret) {
-		fsnotify_access(file_in);
-		fsnotify_modify(file_out);
-	}
+	if (cloned < 0)
+		return cloned;
+	else if (len && cloned != len)
+		return -EINVAL;
 
-	return ret;
+	fsnotify_access(file_in);
+	fsnotify_modify(file_out);
+	return 0;
 }
 EXPORT_SYMBOL(vfs_clone_file_range);
 
@@ -1937,7 +1942,7 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 }
 EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
-int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
+s64 vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 			      struct file *dst_file, loff_t dst_pos, u64 len)
 {
 	s64 ret;
@@ -1989,7 +1994,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	int i;
 	int ret;
 	u16 count = same->dest_count;
-	int deduped;
+	s64 deduped;
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EINVAL;
@@ -2046,7 +2051,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 		else if (deduped < 0)
 			info->status = deduped;
 		else
-			info->bytes_deduped = len;
+			info->bytes_deduped = deduped;
 
 next_fdput:
 		fdput(dst_fd);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 61a5ad2600e8..efa95e0d8cee 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -919,7 +919,7 @@ xfs_file_fallocate(
 	return error;
 }
 
-STATIC int
+STATIC s64
 xfs_file_clone_range(
 	struct file	*file_in,
 	loff_t		pos_in,
@@ -927,11 +927,14 @@ xfs_file_clone_range(
 	loff_t		pos_out,
 	u64		len)
 {
-	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-				     len, false);
+	int		ret;
+
+	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+			len, false);
+	return ret < 0 ? ret : len;
 }
 
-STATIC int
+STATIC s64
 xfs_file_dedupe_range(
 	struct file	*file_in,
 	loff_t		pos_in,
@@ -939,8 +942,11 @@ xfs_file_dedupe_range(
 	loff_t		pos_out,
 	u64		len)
 {
-	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-				     len, true);
+	int		ret;
+
+	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+			len, true);
+	return ret < 0 ? ret : len;
 }
 
 STATIC int
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2a4141d36ebf..e5755340e825 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1759,10 +1759,12 @@ struct file_operations {
 #endif
 	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
 			loff_t, size_t, unsigned int);
-	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
-			u64);
-	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t,
-			u64);
+	s64 (*clone_file_range)(struct file *file_in, loff_t pos_in,
+				struct file *file_out, loff_t pos_out,
+				u64 count);
+	s64 (*dedupe_file_range)(struct file *file_in, loff_t pos_in,
+				 struct file *file_out, loff_t pos_out,
+				 u64 count);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
 } __randomize_layout;
 
@@ -1835,7 +1837,7 @@ extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 loff_t len, bool *is_same);
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
-extern int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
+extern s64 vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 				     struct file *dst_file, loff_t dst_pos,
 				     u64 len);
 
