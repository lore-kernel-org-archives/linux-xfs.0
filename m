Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53428 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbeJJHdQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 03:33:16 -0400
Subject: [PATCH 15/25] vfs: plumb RFR_* remap flags through the vfs clone
 functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Oct 2018 17:13:36 -0700
Message-ID: <153913041692.32295.9928643841686525236.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb a remap_flags argument through the {do,vfs}_clone_file_range
functions so that clone can take advantage of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ioctl.c             |    2 +-
 fs/nfsd/vfs.c          |    2 +-
 fs/overlayfs/copy_up.c |    2 +-
 fs/overlayfs/file.c    |    4 ++--
 fs/read_write.c        |   13 +++++++++----
 include/linux/fs.h     |    4 ++--
 6 files changed, 16 insertions(+), 11 deletions(-)


diff --git a/fs/ioctl.c b/fs/ioctl.c
index 72537b68c272..505275ec5596 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -232,7 +232,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 	if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
 		goto fdput;
 	cloned = vfs_clone_file_range(src_file.file, off, dst_file, destoff,
-				      olen);
+				      olen, 0);
 	if (cloned < 0)
 		ret = cloned;
 	else if (olen && cloned != olen)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ac6cb6101cbe..726fc5b2b27a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -543,7 +543,7 @@ __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
 {
 	loff_t cloned;
 
-	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count);
+	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count, 0);
 	if (count && cloned != count)
 		cloned = -EINVAL;
 	return nfserrno(cloned < 0 ? cloned : 0);
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c2b53509e7f1..bf60a3386c11 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -142,7 +142,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	}
 
 	/* Try to use clone_file_range to clone up within the same fs */
-	cloned = do_clone_file_range(old_file, 0, new_file, 0, len);
+	cloned = do_clone_file_range(old_file, 0, new_file, 0, len, 0);
 	if (cloned == len)
 		goto out;
 	/* Couldn't clone, so now we try to copy the data */
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index c8c890c22898..8b22035af4d7 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -462,7 +462,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 
 	case OVL_CLONE:
 		ret = vfs_clone_file_range(real_in.file, pos_in,
-					   real_out.file, pos_out, len);
+					   real_out.file, pos_out, len, flags);
 		break;
 
 	case OVL_DEDUPE:
@@ -509,7 +509,7 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
 	     !ovl_inode_upper(file_inode(file_out))))
 		return -EPERM;
 
-	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
+	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
 			    op);
 }
 
diff --git a/fs/read_write.c b/fs/read_write.c
index f43b0620afd4..cf81d1f68b69 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1821,12 +1821,15 @@ int generic_remap_file_range_touch(struct file *file, unsigned int remap_flags)
 EXPORT_SYMBOL(generic_remap_file_range_touch);
 
 loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
-			   struct file *file_out, loff_t pos_out, loff_t len)
+			   struct file *file_out, loff_t pos_out,
+			   loff_t len, unsigned int remap_flags)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	loff_t ret;
 
+	WARN_ON_ONCE(remap_flags);
+
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
@@ -1857,7 +1860,7 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 		return ret;
 
 	ret = file_in->f_op->remap_file_range(file_in, pos_in,
-			file_out, pos_out, len, 0);
+			file_out, pos_out, len, remap_flags);
 	if (ret < 0)
 		return ret;
 
@@ -1868,12 +1871,14 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 EXPORT_SYMBOL(do_clone_file_range);
 
 loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
-			    struct file *file_out, loff_t pos_out, loff_t len)
+			    struct file *file_out, loff_t pos_out,
+			    loff_t len, unsigned int remap_flags)
 {
 	loff_t ret;
 
 	file_start_write(file_out);
-	ret = do_clone_file_range(file_in, pos_in, file_out, pos_out, len);
+	ret = do_clone_file_range(file_in, pos_in, file_out, pos_out, len,
+				  remap_flags);
 	file_end_write(file_out);
 
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1ee09152ecd5..21f947b20f37 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1838,10 +1838,10 @@ extern int generic_remap_file_range_touch(struct file *file,
 					  unsigned int remap_flags);
 extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
-				  loff_t len);
+				  loff_t len, unsigned int remap_flags);
 extern loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 				   struct file *file_out, loff_t pos_out,
-				   loff_t len);
+				   loff_t len, unsigned int remap_flags);
 extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 struct inode *dest, loff_t destoff,
 					 loff_t len, bool *is_same);
