Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751943AbeEKT1I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 15:27:08 -0400
From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 2/2] vfs: dedupe should return EPERM if permission is not granted
Date: Fri, 11 May 2018 12:26:51 -0700
Message-Id: <20180511192651.21324-3-mfasheh@suse.de>
In-Reply-To: <20180511192651.21324-1-mfasheh@suse.de>
References: <20180511192651.21324-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>

Right now we return EINVAL if a process does not have permission to dedupe a
file. This was an oversight on my part. EPERM gives a true description of
the nature of our error, and EINVAL is already used for the case that the
filesystem does not support dedupe.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 77986a2e2a3b..8edef43a182c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2038,7 +2038,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 			info->status = -EINVAL;
 		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
 			     uid_eq(current_fsuid(), dst->i_uid))) {
-			info->status = -EINVAL;
+			info->status = -EPERM;
 		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
 			info->status = -EXDEV;
 		} else if (S_ISDIR(dst->i_mode)) {
-- 
2.15.1

