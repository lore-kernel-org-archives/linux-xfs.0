Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45277 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbeBUHW2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Feb 2018 02:22:28 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BC47FAE7A
        for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2018 07:22:26 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] xfs: Remove dead code from inode recover function
Date: Wed, 21 Feb 2018 09:22:24 +0200
Message-Id: <1519197744-8339-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>

The memcpy is guarded by a check which is performed a right before we
call xfs_log_dinode_to_disk. At this point we are sure this check will
always be false otherwise we would have errored out. So let's remove
this dead weight.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_log_recover.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 00240c9ee72e..cb20f2e83412 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3173,13 +3173,6 @@ xlog_recover_inode_pass2(
 	/* recover the log dinode inode into the on disk inode */
 	xfs_log_dinode_to_disk(ldip, dip);
 
-	/* the rest is in on-disk format */
-	if (item->ri_buf[1].i_len > isize) {
-		memcpy((char *)dip + isize,
-			item->ri_buf[1].i_addr + isize,
-			item->ri_buf[1].i_len - isize);
-	}
-
 	fields = in_f->ilf_fields;
 	if (fields & XFS_ILOG_DEV)
 		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
-- 
2.7.4

