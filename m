Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58980 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030206AbcIYDWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2016 23:22:36 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] xfs: allow delayed allocations for COW files
Date: Sat, 24 Sep 2016 20:22:34 -0700
Message-Id: <1474773755-26796-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

After we reserved blocks in the COW path we should continue down the normal
iomap_begin path and not exlude the delalloc case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index dc8895c..5afbfa5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1022,7 +1022,9 @@ xfs_file_iomap_begin(
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			return error;
-	} else if ((flags & IOMAP_WRITE) && !IS_DAX(inode) &&
+	}
+
+	if ((flags & IOMAP_WRITE) && !IS_DAX(inode) &&
 		   !xfs_get_extsz_hint(ip)) {
 		/* Reserve delalloc blocks for regular writeback. */
 		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
-- 
2.1.4

