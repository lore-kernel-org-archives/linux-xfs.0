Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbeE3KCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 06:02:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] fs: remove the buffer_unwritten check in page_seek_hole_data
Date: Wed, 30 May 2018 12:02:07 +0200
Message-Id: <20180530100208.31490-3-hch@lst.de>
In-Reply-To: <20180530100208.31490-1-hch@lst.de>
References: <20180530100208.31490-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

We only call into this function through the iomap iterators, so we already
know the buffer is unwritten.  In addition to that we always require the
uptodate flag that is ORed with the result anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index c2d4fd551fed..e75153f52748 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -816,14 +816,9 @@ page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
 			continue;
 
 		/*
-		 * Unwritten extents that have data in the page cache covering
-		 * them can be identified by the BH_Unwritten state flag.
-		 * Pages with multiple buffers might have a mix of holes, data
-		 * and unwritten extents - any buffer with valid data in it
-		 * should have BH_Uptodate flag set on it.
+		 * Any buffer with valid data in it should have BH_Uptodate set.
 		 */
-
-		if ((buffer_unwritten(bh) || buffer_uptodate(bh)) == seek_data)
+		if (buffer_uptodate(bh) == seek_data)
 			return lastoff;
 
 		lastoff = offset;
@@ -835,8 +830,8 @@ page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
  * Seek for SEEK_DATA / SEEK_HOLE in the page cache.
  *
  * Within unwritten extents, the page cache determines which parts are holes
- * and which are data: unwritten and uptodate buffer heads count as data;
- * everything else counts as a hole.
+ * and which are data: uptodate buffer heads count as data; everything else
+ * counts as a hole.
  *
  * Returns the resulting offset on successs, and -ENOENT otherwise.
  */
-- 
2.17.0

