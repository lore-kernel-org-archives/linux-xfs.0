Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbeJEHmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:42:09 -0400
Subject: [PATCH 11/15] vfs: allow short clone and dedupe operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:45:54 -0700
Message-ID: <153870035471.29072.15690301164025555492.stgit@magnolia>
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

Allow the clone and dedupe prep function to shorten the request if the
caller can handle it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c    |    8 ++------
 include/linux/fs.h |    2 +-
 mm/filemap.c       |   19 +++++++++++++++----
 3 files changed, 18 insertions(+), 11 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 4eaea52f70a8..292d68c2f47c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1726,7 +1726,6 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
-	uint64_t nlen;
 	loff_t isize;
 	bool same_inode = (inode_in == inode_out);
 	bool is_dedupe = (flags & CLONERANGE_DEDUPE);
@@ -1758,13 +1757,10 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 	}
 
 	/* Check that we don't violate system file offset limits. */
-	nlen = *len;
-	ret = generic_clone_checks(file_in, pos_in, file_out, pos_out, &nlen,
-			is_dedupe);
+	ret = generic_clone_checks(file_in, pos_in, file_out, pos_out, len,
+			flags);
 	if (ret)
 		return ret;
-	if (nlen != *len)
-		return -EINVAL;
 
 	/* Wait for the completion of any pending IOs on both files */
 	inode_dio_wait(inode_in);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ae5685c31270..eb35363478e5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2988,7 +2988,7 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
 extern int generic_clone_checks(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
-				uint64_t *count, bool is_dedupe);
+				uint64_t *count, unsigned int flags);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
diff --git a/mm/filemap.c b/mm/filemap.c
index f74391721234..013451b8017f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2983,7 +2983,7 @@ EXPORT_SYMBOL(generic_write_checks);
  */
 int generic_clone_checks(struct file *file_in, loff_t pos_in,
 			 struct file *file_out, loff_t pos_out,
-			 uint64_t *req_count, bool is_dedupe)
+			 uint64_t *req_count, unsigned int flags)
 {
 	struct inode *inode_in = file_in->f_mapping->host;
 	struct inode *inode_out = file_out->f_mapping->host;
@@ -3005,7 +3005,7 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
 	size_out = i_size_read(inode_out);
 
 	/* Dedupe requires both ranges to be within EOF. */
-	if (is_dedupe &&
+	if ((flags & CLONERANGE_DEDUPE) &&
 	    (pos_in >= size_in || pos_in + count > size_in ||
 	     pos_out >= size_out || pos_out + count > size_out))
 		return -EINVAL;
@@ -3056,8 +3056,12 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
 	if (pos_in + count == size_in) {
 		bcount = ALIGN(size_in, bs) - pos_in;
 	} else {
-		if (!IS_ALIGNED(count, bs))
-			return -EINVAL;
+		if (!IS_ALIGNED(count, bs)) {
+			if (flags & CLONERANGE_SHORT)
+				count = ALIGN_DOWN(count, bs);
+			else
+				return -EINVAL;
+		}
 
 		bcount = count;
 	}
@@ -3068,6 +3072,13 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
 	    pos_out < pos_in + bcount)
 		return -EINVAL;
 
+	/*
+	 * We shortened the request but the caller can't deal with that, so
+	 * bounce the request back to userspace.
+	 */
+	if (*req_count != count && !(flags & CLONERANGE_SHORT))
+		return -EINVAL;
+
 	*req_count = count;
 	return 0;
 }
