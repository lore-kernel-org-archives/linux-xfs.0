Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60170 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbeJJHdn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 03:33:43 -0400
Subject: [PATCH 18/25] vfs: enable remap callers that can handle short
 operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Oct 2018 17:14:04 -0700
Message-ID: <153913044431.32295.9717425324455762449.stgit@magnolia>
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

Plumb in a remap flag that enables the filesystem remap handler to
shorten remapping requests for callers that can handle it.  Now
copy_file_range can report partial success (in case we run up against
alignment problems, resource limits, etc.).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c    |    3 ++-
 include/linux/fs.h |    2 ++
 mm/filemap.c       |   16 ++++++++++++----
 3 files changed, 16 insertions(+), 5 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index a628fd9a47cf..8ed0aed81649 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1593,7 +1593,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 
 		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
-				min_t(loff_t, MAX_RW_COUNT, len), 0);
+				min_t(loff_t, MAX_RW_COUNT, len),
+				RFR_CAN_SHORTEN);
 		if (cloned >= 0) {
 			ret = cloned;
 			goto done;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9f90dcd4df3b..e0494d719ebc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1726,9 +1726,11 @@ struct block_device_operations;
  *
  * RFR_IDENTICAL_DATA: only remap if contents identical (i.e. deduplicate)
  * RFR_TO_SRC_EOF: remap to the end of the source file
+ * RFR_CAN_SHORTEN: caller can handle a shortened request
  */
 #define RFR_IDENTICAL_DATA	(1 << 0)
 #define RFR_TO_SRC_EOF		(1 << 1)
+#define RFR_CAN_SHORTEN		(1 << 2)
 
 struct iov_iter;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 2522737483de..2179d0204ee6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3064,8 +3064,12 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	if (pos_in + count == size_in) {
 		bcount = ALIGN(size_in, bs) - pos_in;
 	} else {
-		if (!IS_ALIGNED(count, bs))
-			return -EINVAL;
+		if (!IS_ALIGNED(count, bs)) {
+			if (remap_flags & RFR_CAN_SHORTEN)
+				count = ALIGN_DOWN(count, bs);
+			else
+				return -EINVAL;
+		}
 
 		bcount = count;
 	}
@@ -3076,10 +3080,14 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	    pos_out < pos_in + bcount)
 		return -EINVAL;
 
-	/* For now we don't support changing the length. */
-	if (*req_count != count)
+	/*
+	 * We shortened the request but the caller can't deal with that, so
+	 * bounce the request back to userspace.
+	 */
+	if (*req_count != count && !(remap_flags & RFR_CAN_SHORTEN))
 		return -EINVAL;
 
+	*req_count = count;
 	return 0;
 }
 
