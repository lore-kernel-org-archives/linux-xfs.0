Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbeIKERz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Sep 2018 00:17:55 -0400
From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/2] vfs: allow dedupe of user owned read-only files
Date: Mon, 10 Sep 2018 16:21:17 -0700
Message-Id: <20180910232118.14424-2-mfasheh@suse.de>
In-Reply-To: <20180910232118.14424-1-mfasheh@suse.de>
References: <20180910232118.14424-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>

The permission check in vfs_dedupe_file_range_one() is too coarse - We only
allow dedupe of the destination file if the user is root, or they have the
file open for write.

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
 fs/read_write.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 39b4a21dd933..be0e8723a049 100644
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
 int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 			      struct file *dst_file, loff_t dst_pos, u64 len)
 {
@@ -1978,7 +1992,7 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 		goto out_drop_write;
 
 	ret = -EINVAL;
-	if (!(capable(CAP_SYS_ADMIN) || (dst_file->f_mode & FMODE_WRITE)))
+	if (!allow_file_dedupe(dst_file))
 		goto out_drop_write;
 
 	ret = -EXDEV;
-- 
2.15.1
