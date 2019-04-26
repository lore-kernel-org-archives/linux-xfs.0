Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f180.google.com ([209.85.215.180]:33338 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfDZXAd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Apr 2019 19:00:33 -0400
Received: by mail-pg1-f180.google.com with SMTP id k19so2289275pgh.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2019 16:00:33 -0700 (PDT)
From: Jorge Guerra <jorge.guerra@gmail.com>
Subject: [PATCH] xfs_db: Scan entire file system when using 'frag'
Date: Fri, 26 Apr 2019 15:59:20 -0700
Message-Id: <20190426225920.34359-1-jorgeguerra@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: osandov@osandov.com, Jorge Guerra <jorgeguerra@fb.com>

From: Jorge Guerra <jorgeguerra@fb.com>

While running the 'frag' command of 'xfs_db' we noticed that the
tool is not scanning all the files in the file system.  We noticed
this when we modified the tool to print the inodes of all the files
scanned.  For example:

 $ find /mnt/xfsdisk -type f | wc -l
 1782674
 $ xfs_db -r -c frag /dev/sdXX  | grep MB | awk '{print $5}' | paste -s -d+ | bc
 656818

Upon inspecting the code we noticed that the scanfunc_ino function
stops processing a given inode block once it encounters a free leaf.
However, in practice we see that inodes are necessarily always layed
out contiguously on the leaf node.  This resulted in the 'frag'
command skipping some valid inodes.

In this change we modify the scanfunc_ino function to skip freed
inodes.  With the change in place we ran the same experiment again
and noticed a more accurate file count:

 $ find /mnt/d0 -type f | wc -l
 1810442
 $ xfs_db -r -c frag /dev/sdXX  | grep MB | awk '{print $5}' | paste -s -d+ | bc
 1810442

Signed-off-by: Jorge Guerra <jorgeguerra@fb.com>
---
 db/frag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/frag.c b/db/frag.c
index 5f33cb73..91395234 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -507,7 +507,7 @@ scanfunc_ino(
 
 				for (j = 0; j < inodes_per_buf; j++) {
 					if (XFS_INOBT_IS_FREE_DISK(&rp[i], ioff + j))
-						goto next_buf;
+						continue;
 					dip = (xfs_dinode_t *)((char *)iocur_top->data +
 						((off + j) << mp->m_sb.sb_inodelog));
 					process_inode(agf, agino + ioff + j, dip);
-- 
2.13.5
