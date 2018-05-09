Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52904 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933806AbeEIHuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 03:50:02 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/33] xfs: don't clear imap_valid for a non-uptodate buffers
Date: Wed,  9 May 2018 09:48:19 +0200
Message-Id: <20180509074830.16196-23-hch@lst.de>
In-Reply-To: <20180509074830.16196-1-hch@lst.de>
References: <20180509074830.16196-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

Finding a buffer that isn't uptodate doesn't invalidate the mapping for
any given block.  The last_sector check will already take care of starting
another ioend as soon as we find any non-update buffer, and if the current
mapping doesn't include the next uptodate buffer the xfs_imap_valid check
will take care of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 07d5255a0f9f..5da2e99b0559 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -859,15 +859,12 @@ xfs_writepage_map(
 			break;
 
 		/*
-		 * Block does not contain valid data, skip it, mark the current
-		 * map as invalid because we have a discontiguity. This ensures
-		 * we put subsequent writeable buffers into a new ioend.
+		 * Block does not contain valid data, skip it.
 		 */
 		if (!buffer_uptodate(bh)) {
 			if (PageUptodate(page))
 				ASSERT(buffer_mapped(bh));
 			uptodate = false;
-			wpc->imap_valid = false;
 			continue;
 		}
 
-- 
2.17.0

