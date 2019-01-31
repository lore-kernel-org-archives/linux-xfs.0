Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfAaHzj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 02:55:39 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/11] xfs: don't try to map blocks beyond i_size in writeback
Date: Thu, 31 Jan 2019 08:55:17 +0100
Message-Id: <20190131075524.4769-5-hch@lst.de>
In-Reply-To: <20190131075524.4769-1-hch@lst.de>
References: <20190131075524.4769-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

We already shortcut xfs_map_blocks for COW mappings, but there is just
as little reason to start writeback beyond i_size in the data fork.

Note that this has to be just an optimization as hole punches can unmaps
block just like truncate, and we need to handle that case further down
in the low-level code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8bfb62d8776f..9c2a1947d5dd 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -348,6 +348,20 @@ xfs_map_blocks(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	/*
+	 * If the offset is beyond the inode size, we know that we raced with
+	 * truncate.  No point in doing calling any lower level code, just
+	 * return a hole so that the writeback code skips writeback for the
+	 * rest of the file.
+	 */
+	if (offset > i_size_read(inode)) {
+		wpc->imap.br_startoff = offset_fsb;
+		wpc->imap.br_blockcount = end_fsb - offset_fsb;
+		wpc->imap.br_startblock = HOLESTARTBLOCK;
+		wpc->imap.br_state = XFS_EXT_NORM;
+		return 0;
+	}
+
 	/*
 	 * COW fork blocks can overlap data fork blocks even if the blocks
 	 * aren't shared.  COW I/O always takes precedent, so we must always
@@ -388,26 +402,6 @@ xfs_map_blocks(
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
