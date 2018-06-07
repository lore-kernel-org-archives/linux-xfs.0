Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44511 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933255AbeFGRjN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 13:39:13 -0400
From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v3 1/2] vfs: allow dedupe of user owned read-only files
Date: Thu,  7 Jun 2018 10:38:53 -0700
Message-Id: <20180607173854.15747-2-mfasheh@suse.de>
In-Reply-To: <20180607173854.15747-1-mfasheh@suse.de>
References: <20180607173854.15747-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>

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
index e83bd9744b5d..71e9077f8bc1 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1964,6 +1964,20 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 }
 EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
+/* Check whether we are allowed to dedupe the destination file */
+static bool allow_file_dedupe(struct file *file)
+{
+	if (capable(CAP_SYS_ADMIN))
+		return true;
+	if (file->f_mode & FMODE_WRITE)
+		return true;
+	if (uid_eq(current_fsuid(), file_inode(file)->i_uid))
+		return true;
+	if (!inode_permission(file_inode(file), MAY_WRITE))
+		return true;
+	return false;
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

