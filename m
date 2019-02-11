Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35822 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfBKMy5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 07:54:57 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/10] xfs: remove the truncate short cut in xfs_map_blocks
Date: Mon, 11 Feb 2019 13:54:26 +0100
Message-Id: <20190211125427.16577-10-hch@lst.de>
In-Reply-To: <20190211125427.16577-1-hch@lst.de>
References: <20190211125427.16577-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Now that we properly handle the race with truncate in the delalloc
allocator there is no need to short cut this exceptional case earlier
on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 403df647c0e4..6a8937a833ad 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -426,26 +426,6 @@ xfs_map_blocks(
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 		wpc->fork = XFS_COW_FORK;
-
-		/*
-		 * Truncate can race with writeback since writeback doesn't
-		 * take the iolock and truncate decreases the file size before
-		 * it starts truncating the pages between new_size and old_size.
-		 * Therefore, we can end up in the situation where writeback
-		 * gets a CoW fork mapping but the truncate makes the mapping
-		 * invalid and we end up in here trying to get a new mapping.
-		 * bail out here so that we simply never get a valid mapping
-		 * and so we drop the write altogether.  The page truncation
-		 * will kill the contents anyway.
-		 */
-		if (offset > i_size_read(inode)) {
-			wpc->imap.br_blockcount = end_fsb - offset_fsb;
-			wpc->imap.br_startoff = offset_fsb;
-			wpc->imap.br_startblock = HOLESTARTBLOCK;
-			wpc->imap.br_state = XFS_EXT_NORM;
-			return 0;
-		}
-
 		goto allocate_blocks;
 	}
 
-- 
2.20.1
