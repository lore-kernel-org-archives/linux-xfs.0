Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58576 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbeJJHc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 03:32:59 -0400
Subject: [PATCH 13/25] vfs: pass remap flags to generic_remap_checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Oct 2018 17:13:21 -0700
Message-ID: <153913040183.32295.16281682485157170773.stgit@magnolia>
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

Pass the same remap flags to generic_remap_checks for consistency.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c    |    2 +-
 include/linux/fs.h |    2 +-
 mm/filemap.c       |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 47174785a94f..917934770b08 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1755,7 +1755,7 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 	/* Check that we don't violate system file offset limits. */
 	ret = generic_remap_checks(file_in, pos_in, file_out, pos_out, len,
-			is_dedupe);
+			remap_flags);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0d9bdef0b4ea..56167b10cbad 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2976,7 +2976,7 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
 extern int generic_remap_checks(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
-				uint64_t *count, bool is_dedupe);
+				uint64_t *count, unsigned int remap_flags);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
diff --git a/mm/filemap.c b/mm/filemap.c
index 59056bd9c58a..e099c8880863 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3004,7 +3004,7 @@ generic_remap_check_limits(struct file *file, loff_t pos, uint64_t *count)
  */
 int generic_remap_checks(struct file *file_in, loff_t pos_in,
 			 struct file *file_out, loff_t pos_out,
-			 uint64_t *req_count, bool is_dedupe)
+			 uint64_t *req_count, unsigned int remap_flags)
 {
 	struct inode *inode_in = file_in->f_mapping->host;
 	struct inode *inode_out = file_out->f_mapping->host;
@@ -3027,7 +3027,7 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	size_out = i_size_read(inode_out);
 
 	/* Dedupe requires both ranges to be within EOF. */
-	if (is_dedupe &&
+	if ((remap_flags & RFR_IDENTICAL_DATA) &&
 	    (pos_in >= size_in || pos_in + count > size_in ||
 	     pos_out >= size_out || pos_out + count > size_out))
 		return -EINVAL;
