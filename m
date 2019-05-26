Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40298 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbfEZGLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 02:11:16 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/8] vfs: introduce generic_copy_file_range()
Date: Sun, 26 May 2019 09:10:52 +0300
Message-Id: <20190526061100.21761-2-amir73il@gmail.com>
In-Reply-To: <20190526061100.21761-1-amir73il@gmail.com>
References: <20190526061100.21761-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

Right now if vfs_copy_file_range() does not use any offload
mechanism, it falls back to calling do_splice_direct(). This fails
to do basic sanity checks on the files being copied. Before we
start adding this necessarily functionality to the fallback path,
separate it out into generic_copy_file_range().

generic_copy_file_range() has the same prototype as
->copy_file_range() so that filesystems can use it in their custom
->copy_file_range() method if they so choose.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c    | 35 ++++++++++++++++++++++++++++++++---
 include/linux/fs.h |  3 +++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index c543d965e288..676b02fae589 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1565,6 +1565,36 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 }
 #endif
 
+/**
+ * generic_copy_file_range - copy data between two files
+ * @file_in:	file structure to read from
+ * @pos_in:	file offset to read from
+ * @file_out:	file structure to write data to
+ * @pos_out:	file offset to write data to
+ * @len:	amount of data to copy
+ * @flags:	copy flags
+ *
+ * This is a generic filesystem helper to copy data from one file to another.
+ * It has no constraints on the source or destination file owners - the files
+ * can belong to different superblocks and different filesystem types. Short
+ * copies are allowed.
+ *
+ * This should be called from the @file_out filesystem, as per the
+ * ->copy_file_range() method.
+ *
+ * Returns the number of bytes copied or a negative error indicating the
+ * failure.
+ */
+
+ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
+				struct file *file_out, loff_t pos_out,
+				size_t len, unsigned int flags)
+{
+	return do_splice_direct(file_in, &pos_in, file_out, &pos_out,
+				len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
+}
+EXPORT_SYMBOL(generic_copy_file_range);
+
 /*
  * copy_file_range() differs from regular file read and write in that it
  * specifically allows return partial success.  When it does so is up to
@@ -1632,9 +1662,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 			goto done;
 	}
 
-	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
-			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
-
+	ret = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
+				      flags);
 done:
 	if (ret > 0) {
 		fsnotify_access(file_in);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7fdfe93e25d..ea17858310ff 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1889,6 +1889,9 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
+extern ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
+				       struct file *file_out, loff_t pos_out,
+				       size_t len, unsigned int flags);
 extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 					 struct file *file_out, loff_t pos_out,
 					 loff_t *count,
-- 
2.17.1
