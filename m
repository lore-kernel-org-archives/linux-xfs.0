Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbeERQuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 12:50:14 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 33/34] xfs: do not set the page uptodate in xfs_writepage_map
Date: Fri, 18 May 2018 18:48:29 +0200
Message-Id: <20180518164830.1552-34-hch@lst.de>
In-Reply-To: <20180518164830.1552-1-hch@lst.de>
References: <20180518164830.1552-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

We already track the page uptodate status based on the buffer uptodate
status, which is updated whenever reading or zeroing blocks.

This code has been there since commit a ptool commit in 2002, which
claims to:

    "merge" the 2.4 fsx fix for block size < page size to 2.5.  This needed
    major changes to actually fit.

and isn't present in other writepage implementations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a4e53e0a57c2..492f4a4b1deb 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -796,7 +796,6 @@ xfs_writepage_map(
 	ssize_t			len = i_blocksize(inode);
 	int			error = 0;
 	int			count = 0;
-	bool			uptodate = true;
 	loff_t			file_offset;	/* file offset of page */
 	unsigned		poffset;	/* offset into page */
 
@@ -823,7 +822,6 @@ xfs_writepage_map(
 		if (!buffer_uptodate(bh)) {
 			if (PageUptodate(page))
 				ASSERT(buffer_mapped(bh));
-			uptodate = false;
 			continue;
 		}
 
@@ -857,9 +855,6 @@ xfs_writepage_map(
 		count++;
 	}
 
-	if (uptodate && poffset == PAGE_SIZE)
-		SetPageUptodate(page);
-
 	ASSERT(wpc->ioend || list_empty(&submit_list));
 
 out:
-- 
2.17.0

