Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57521 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751942AbeEKT1G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 15:27:06 -0400
From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/2] vfs: allow dedupe of user owned read-only files
Date: Fri, 11 May 2018 12:26:50 -0700
Message-Id: <20180511192651.21324-2-mfasheh@suse.de>
In-Reply-To: <20180511192651.21324-1-mfasheh@suse.de>
References: <20180511192651.21324-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>

The permission check in vfs_dedupe_file_range() is too coarse - We
only allow dedupe of the destination file if the user is root, or
they have the file open for write.

This effectively limits a non-root user from deduping their own
read-only files. As file data during a dedupe does not change,
this is unexpected behavior and this has caused a number of issue
reports. For an example, see:

https://github.com/markfasheh/duperemove/issues/129

So change the check so we allow dedupe on the target if:

- the root or admin is asking for it
- the owner of the file is asking for the dedupe
- the process has write access

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/read_write.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index c4eabbfc90df..77986a2e2a3b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2036,7 +2036,8 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 
 		if (info->reserved) {
 			info->status = -EINVAL;
-		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
+		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
+			     uid_eq(current_fsuid(), dst->i_uid))) {
 			info->status = -EINVAL;
 		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
 			info->status = -EXDEV;
-- 
2.15.1

