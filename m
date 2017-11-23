Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49847 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751799AbdKWLkH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 06:40:07 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] xfs: Don't trim file extents during iomap
Date: Thu, 23 Nov 2017 13:40:03 +0200
Message-Id: <1511437203-4329-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, hch@infradead.org
Cc: sandeen@redhat.com, darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

For file extents xfs currently calls xfs_bmapi_read with flag set to 0,
meaning extents are going to be truncated to the requested range. Since the
same codepath is used for fiemap this means xfs is special in that regard, since
other filesystems (ext4/btrfs) do not trim extents for fiemap. Make the behavior
consistent by always passing XFS_BMAPI_ENTIRE. A full xfstest run validated that
this doesn't regress on ordinary read/write IO.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f179bdf1644d..8942324a4d3d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1008,7 +1008,7 @@ xfs_file_iomap_begin(
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
-			       &nimaps, 0);
+			       &nimaps, XFS_BMAPI_ENTIRE);
 	if (error)
 		goto out_unlock;
 
-- 
2.7.4

