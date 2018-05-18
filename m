Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbeERV5r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 May 2018 17:57:47 -0400
From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v2 2/2] vfs: dedupe should return EPERM if permission is not granted
Date: Fri, 18 May 2018 14:57:27 -0700
Message-Id: <20180518215727.26418-3-mfasheh@suse.de>
In-Reply-To: <20180518215727.26418-1-mfasheh@suse.de>
References: <20180518215727.26418-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Adam Borowski <kilobyte@angband.pl>, Mark Fasheh <mfasheh@suse.de>

Right now we return EINVAL if a process does not have permission to dedupe a
file. This was an oversight on my part. EPERM gives a true description of
the nature of our error, and EINVAL is already used for the case that the
filesystem does not support dedupe.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index cbea4ce58ad1..2238928ca819 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2050,7 +2050,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 		if (info->reserved) {
 			info->status = -EINVAL;
 		} else if (!allow_file_dedupe(dst_file)) {
-			info->status = -EINVAL;
+			info->status = -EPERM;
 		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
 			info->status = -EXDEV;
 		} else if (S_ISDIR(dst->i_mode)) {
-- 
2.15.1

