Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46269 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbeBTNxI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Feb 2018 08:53:08 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB002ADE6
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2018 13:53:06 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] xfs: Remove duplicated check
Date: Tue, 20 Feb 2018 15:53:02 +0200
Message-Id: <1519134782-10062-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>

The check performed before the memcpy responsible for copying the rest
of the inode is already performed before we call xfs_log_dinode_to_disk.
So let's remove the 2nd instance of the check. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reported-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/xfs/xfs_log_recover.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 00240c9ee72e..88dccfb1de96 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3174,11 +3174,8 @@ xlog_recover_inode_pass2(
 	xfs_log_dinode_to_disk(ldip, dip);
 
 	/* the rest is in on-disk format */
-	if (item->ri_buf[1].i_len > isize) {
-		memcpy((char *)dip + isize,
-			item->ri_buf[1].i_addr + isize,
+	memcpy((char *)dip + isize, item->ri_buf[1].i_addr + isize,
 			item->ri_buf[1].i_len - isize);
-	}
 
 	fields = in_f->ilf_fields;
 	if (fields & XFS_ILOG_DEV)
-- 
2.7.4

