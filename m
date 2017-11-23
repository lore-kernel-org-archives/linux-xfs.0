Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbdKWIGT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 03:06:19 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] xfs: Don't trim extents for fiemap
Date: Thu, 23 Nov 2017 10:06:09 +0200
Message-Id: <1511424369-28740-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

For file extents xfs currently always calls xfs_bmapi_read with not flags,
meaning extents are going to be truncated to the requested range. This is
differs than what other filesystems do (ext4/btrfs don't trim extents). So
harmonize the behavior across the filesystem by explicitly not trimming
extents when we are called from fiemap code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_iomap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f179bdf1644d..129550fbf898 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1008,7 +1008,8 @@ xfs_file_iomap_begin(
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
-			       &nimaps, 0);
+			       &nimaps,
+			       flags & IOMAP_REPORT ? XFS_BMAPI_ENTIRE : 0);
 	if (error)
 		goto out_unlock;
 
-- 
2.7.4

