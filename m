Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933359AbeEWOpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 10:45:25 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 27/34] xfs: don't clear imap_valid for a non-uptodate buffers
Date: Wed, 23 May 2018 16:43:50 +0200
Message-Id: <20180523144357.18985-28-hch@lst.de>
In-Reply-To: <20180523144357.18985-1-hch@lst.de>
References: <20180523144357.18985-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

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
index b1dee2171194..82fd08c29f7f 100644
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

