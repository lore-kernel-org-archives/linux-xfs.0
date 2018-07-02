Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeGBO6T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/22] xfs: don't clear imap_valid for a non-uptodate buffers
Date: Mon,  2 Jul 2018 08:57:56 -0600
Message-Id: <20180702145813.22496-6-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Finding a buffer that isn't uptodate doesn't invalidate the mapping for
any given block.  The last_sector check will already take care of starting
another ioend as soon as we find any non-update buffer, and if the current
mapping doesn't include the next uptodate buffer the xfs_imap_valid check
will take care of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index df80a383ccd8..1d1cb917cc6e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -863,10 +863,8 @@ xfs_writepage_map(
 		 * meaningless for holes (!mapped && uptodate), so skip
 		 * buffers covering holes here.
 		 */
-		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
-			wpc->imap_valid = false;
+		if (!buffer_mapped(bh) && buffer_uptodate(bh))
 			continue;
-		}
 
 		if (buffer_unwritten(bh))
 			new_type = XFS_IO_UNWRITTEN;
@@ -879,11 +877,8 @@ xfs_writepage_map(
 				ASSERT(buffer_mapped(bh));
 			/*
 			 * This buffer is not uptodate and will not be
-			 * written to disk.  Ensure that we will put any
-			 * subsequent writeable buffers into a new
-			 * ioend.
+			 * written to disk.
 			 */
-			wpc->imap_valid = false;
 			continue;
 		}
 
-- 
2.18.0

