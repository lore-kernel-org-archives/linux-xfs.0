Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55086 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbeJEHl5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:57 -0400
Subject: [PATCH 09/15] vfs: pass operation flags to {clone,
 dedupe}_file_range implementations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:45:41 -0700
Message-ID: <153870034158.29072.8943691140742142494.stgit@magnolia>
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

Pass operational flags to the per-filesystem clone and dedupe
implementations.  This enables the vfs to signal when it can deal with
short clone and short dedupe operations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/ctree.h        |    3 ++-
 fs/btrfs/ioctl.c        |    3 ++-
 fs/nfs/nfs4file.c       |    3 ++-
 fs/ocfs2/file.c         |    3 ++-
 fs/ocfs2/refcounttree.c |    2 +-
 fs/overlayfs/file.c     |    3 ++-
 fs/read_write.c         |    9 ++++++---
 fs/xfs/xfs_file.c       |    3 ++-
 fs/xfs/xfs_reflink.c    |    2 +-
 include/linux/fs.h      |   10 ++++++++--
 10 files changed, 28 insertions(+), 13 deletions(-)


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 864651257142..e8c9b871709d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3251,7 +3251,8 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      struct extent_state **cached);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
 s64 btrfs_clone_file_range(struct file *file_in, loff_t pos_in,
-			   struct file *file_out, loff_t pos_out, u64 len);
+			   struct file *file_out, loff_t pos_out, u64 len,
+			   unsigned int flags);
 
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 35ba974f1333..b41a65622b93 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4351,7 +4351,8 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 }
 
 s64 btrfs_clone_file_range(struct file *src_file, loff_t off,
-		struct file *dst_file, loff_t destoff, u64 len)
+		struct file *dst_file, loff_t destoff, u64 len,
+		unsigned int flags)
 {
 	int ret;
 
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index f914861f844f..f8ff06fc1c73 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -181,7 +181,8 @@ static long nfs42_fallocate(struct file *filep, int mode, loff_t offset, loff_t
 }
 
 static s64 nfs42_clone_file_range(struct file *src_file, loff_t src_off,
-		struct file *dst_file, loff_t dst_off, u64 count)
+		struct file *dst_file, loff_t dst_off, u64 count,
+		unsigned int flags)
 {
 	struct inode *dst_inode = file_inode(dst_file);
 	struct nfs_server *server = NFS_SERVER(dst_inode);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c4b78ee4a593..1ee6d3ecdac6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2531,7 +2531,8 @@ static s64 ocfs2_file_clone_range(struct file *file_in,
 				  loff_t pos_in,
 				  struct file *file_out,
 				  loff_t pos_out,
-				  u64 len)
+				  u64 len,
+				  unsigned int flags)
 {
 	int ret;
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 11e4aad7b783..3758954f2377 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4843,7 +4843,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 		goto out_unlock;
 
 	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
-			&len, is_dedupe);
+			&len, is_dedupe ? CLONERANGE_DEDUPE : 0);
 	if (ret <= 0)
 		goto out_unlock;
 
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 6d792d817538..440cb7a82834 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -488,7 +488,8 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
 }
 
 static s64 ovl_clone_file_range(struct file *file_in, loff_t pos_in,
-				struct file *file_out, loff_t pos_out, u64 len)
+				struct file *file_out, loff_t pos_out, u64 len,
+				unsigned int flags)
 {
 	int ret;
 
diff --git a/fs/read_write.c b/fs/read_write.c
index f51751281454..7cfff497263b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1592,7 +1592,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 		s64 cloned;
 
 		cloned = file_in->f_op->clone_file_range(file_in, pos_in,
-				file_out, pos_out, min(MAX_RW_COUNT, len));
+				file_out, pos_out, min(MAX_RW_COUNT, len),
+				CLONERANGE_SHORT);
 		if (cloned >= 0) {
 			ret = cloned;
 			goto done;
@@ -1721,13 +1722,14 @@ static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
  */
 int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 			struct file *file_out, loff_t pos_out,
-			u64 *len, bool is_dedupe)
+			u64 *len, unsigned int flags)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	uint64_t nlen;
 	loff_t isize;
 	bool same_inode = (inode_in == inode_out);
+	bool is_dedupe = (flags & CLONERANGE_DEDUPE);
 	int ret;
 
 	/* Don't touch certain kinds of inodes */
@@ -1802,6 +1804,7 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	s64 cloned;
+	unsigned int flags = 0;
 	int ret;
 
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
@@ -1834,7 +1837,7 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		return ret;
 
 	cloned = file_in->f_op->clone_file_range(file_in, pos_in,
-			file_out, pos_out, len);
+			file_out, pos_out, len, flags);
 	if (cloned < 0)
 		return cloned;
 	else if (len && cloned != len)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index efa95e0d8cee..d5d6681ca714 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -925,7 +925,8 @@ xfs_file_clone_range(
 	loff_t		pos_in,
 	struct file	*file_out,
 	loff_t		pos_out,
-	u64		len)
+	u64		len,
+	unsigned int	flags)
 {
 	int		ret;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1955e093e9ea..40684dd011ee 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1278,7 +1278,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
-			&len, is_dedupe);
+			&len, is_dedupe ? CLONERANGE_DEDUPE : 0);
 	if (ret <= 0)
 		goto out_unlock;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e5755340e825..ae5685c31270 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1761,7 +1761,7 @@ struct file_operations {
 			loff_t, size_t, unsigned int);
 	s64 (*clone_file_range)(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
-				u64 count);
+				u64 count, unsigned int flags);
 	s64 (*dedupe_file_range)(struct file *file_in, loff_t pos_in,
 				 struct file *file_out, loff_t pos_out,
 				 u64 count);
@@ -1827,9 +1827,15 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
+/* Caller can handle a shortened operation. */
+#define CLONERANGE_SHORT	(1 << 0)
+/* End operation at the source file's EOF. */
+#define CLONERANGE_EOF		(1 << 1)
+/* Operation is actually dedupe, not clone. */
+#define CLONERANGE_DEDUPE	(1 << 2)
 extern int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 			       struct file *file_out, loff_t pos_out,
-			       u64 *count, bool is_dedupe);
+			       u64 *count, unsigned int flags);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
