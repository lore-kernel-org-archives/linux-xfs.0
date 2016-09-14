Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32779 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761915AbcINMoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 08:44:00 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 4/4] ovl: use vfs_copy_file_range() to copy up file data
Date: Wed, 14 Sep 2016 15:43:14 +0300
Message-Id: <1473856994-27463-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

Use vfs_copy_file_range() helper instead of calling do_splice_direct()
when copying up file data.
When copying up within the same fs, which supports copy_file_range(),
fs implementation can be more efficient then do_splice_direct().
vfs_copy_file_range() helper falls back to do_splice_direct() if
it cannot use the file system's copy_file_range() implementation.

A previous change added a vfs_clone_file_range() call before
the data copy loop, so this change is only effective for filesystems
that support copy_file_range() and *do not* support clone_file_range().
At the moment, there are no such filesystems in the kernel that
can be used as overlayfs upper, so I tested this change by disabling
the vfs_clone_file_range() call.

Tested correct behavior when lower and upper are on:
1. same ext4 (copy)
2. same xfs + reflink patches + mkfs.xfs (copy)
3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (reflink)
4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)

For comparison, on my laptop, xfstest overlay/001 (copy up of large
sparse files) takes less than 1 second in the xfs reflink setup vs.
25 seconds on the rest of the setups.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 10 +++++-----
 fs/read_write.c        |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ba039f8..a6d6bac 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -146,7 +146,6 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	/* Can't clone, so now we try to copy the data */
 	error = 0;
 
-	/* FIXME: copy up sparse files efficiently */
 	while (len) {
 		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
 		long bytes;
@@ -159,15 +158,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 			break;
 		}
 
-		bytes = do_splice_direct(old_file, &old_pos,
-					 new_file, &new_pos,
-					 this_len, SPLICE_F_MOVE);
+		bytes = vfs_copy_file_range(old_file, old_pos,
+					    new_file, new_pos,
+					    this_len, 0);
 		if (bytes <= 0) {
 			error = bytes;
 			break;
 		}
-		WARN_ON(old_pos != new_pos);
 
+		old_pos += bytes;
+		new_pos += bytes;
 		len -= bytes;
 	}
 out:
diff --git a/fs/read_write.c b/fs/read_write.c
index 6975fe8..dfc083a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1515,6 +1515,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	    file_out->f_op->copy_file_range)
 		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
 						      pos_out, len, flags);
+	/* FIXME: copy sparse file range efficiently */
 	if (ret == -EOPNOTSUPP)
 		ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
 				len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
-- 
2.7.4

