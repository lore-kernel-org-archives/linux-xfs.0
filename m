Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56687 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751009AbeERV5p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 May 2018 17:57:45 -0400
From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v2 1/2] vfs: allow dedupe of user owned read-only files
Date: Fri, 18 May 2018 14:57:26 -0700
Message-Id: <20180518215727.26418-2-mfasheh@suse.de>
In-Reply-To: <20180518215727.26418-1-mfasheh@suse.de>
References: <20180518215727.26418-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Adam Borowski <kilobyte@angband.pl>, Mark Fasheh <mfasheh@suse.de>

The permission check in vfs_dedupe_file_range() is too coarse - We
only allow dedupe of the destination file if the user is root, or
they have the file open for write.

This effectively limits a non-root user from deduping their own read-only
files. In addition, the write file descriptor that the user is forced to
hold open can prevent execution of files. As file data during a dedupe
does not change, the behavior is unexpected and this has caused a number of
issue reports. For an example, see:

https://github.com/markfasheh/duperemove/issues/129

So change the check so we allow dedupe on the target if:

- the root or admin is asking for it
- the process has write access
- the owner of the file is asking for the dedupe
- the process could get write access

That way users can open read-only and still get dedupe.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/read_write.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index c4eabbfc90df..cbea4ce58ad1 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1964,6 +1964,20 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 }
 EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
+/* Check whether we are allowed to dedupe the destination file */
+static int allow_file_dedupe(struct file *file)
+{
+	if (capable(CAP_SYS_ADMIN))
+		return 1;
+	if (file->f_mode & FMODE_WRITE)
+		return 1;
+	if (uid_eq(current_fsuid(), file_inode(file)->i_uid))
+		return 1;
+	if (!inode_permission(file_inode(file), MAY_WRITE))
+		return 1;
+	return 0;
+}
+
 int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 {
 	struct file_dedupe_range_info *info;
@@ -1972,7 +1986,6 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	u64 len;
 	int i;
 	int ret;
-	bool is_admin = capable(CAP_SYS_ADMIN);
 	u16 count = same->dest_count;
 	struct file *dst_file;
 	loff_t dst_off;
@@ -2036,7 +2049,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 
 		if (info->reserved) {
 			info->status = -EINVAL;
-		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
+		} else if (!allow_file_dedupe(dst_file)) {
 			info->status = -EINVAL;
 		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
 			info->status = -EXDEV;
-- 
2.15.1

