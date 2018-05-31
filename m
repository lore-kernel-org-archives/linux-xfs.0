Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932775AbeEaSJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:09:03 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/21] xfs: remove xfs_start_page_writeback
Date: Thu, 31 May 2018 20:07:57 +0200
Message-Id: <20180531180759.21631-20-hch@lst.de>
In-Reply-To: <20180531180759.21631-1-hch@lst.de>
References: <20180531180759.21631-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

This helper only has two callers, one of them with a constant error
argument.  Remove it to make pending changes to the code a little easier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 47 +++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8328f55b7ea7..e017e7ea3a51 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -499,30 +499,6 @@ xfs_map_blocks(
 	return 0;
 }
 
-STATIC void
-xfs_start_page_writeback(
-	struct page		*page,
-	int			clear_dirty)
-{
-	ASSERT(PageLocked(page));
-	ASSERT(!PageWriteback(page));
-
-	/*
-	 * if the page was not fully cleaned, we need to ensure that the higher
-	 * layers come back to it correctly. That means we need to keep the page
-	 * dirty, and for WB_SYNC_ALL writeback we need to ensure the
-	 * PAGECACHE_TAG_TOWRITE index mark is not removed so another attempt to
-	 * write this page in this writeback sweep will be made.
-	 */
-	if (clear_dirty) {
-		clear_page_dirty_for_io(page);
-		set_page_writeback(page);
-	} else
-		set_page_writeback_keepwrite(page);
-
-	unlock_page(page);
-}
-
 /*
  * Submit the bio for an ioend. We are passed an ioend with a bio attached to
  * it, and we submit that bio. The ioend may be used for multiple bio
@@ -856,6 +832,9 @@ xfs_writepage_map(
 	ASSERT(wpc->ioend || list_empty(&submit_list));
 
 out:
+	ASSERT(PageLocked(page));
+	ASSERT(!PageWriteback(page));
+
 	/*
 	 * On error, we have to fail the ioend here because we have locked
 	 * buffers in the ioend. If we don't do this, we'll deadlock
@@ -874,7 +853,21 @@ xfs_writepage_map(
 	 * treated correctly on error.
 	 */
 	if (count) {
-		xfs_start_page_writeback(page, !error);
+		/*
+		 * If the page was not fully cleaned, we need to ensure that the
+		 * higher layers come back to it correctly.  That means we need
+		 * to keep the page dirty, and for WB_SYNC_ALL writeback we need
+		 * to ensure the PAGECACHE_TAG_TOWRITE index mark is not removed
+		 * so another attempt to write this page in this writeback sweep
+		 * will be made.
+		 */
+		if (error) {
+			set_page_writeback_keepwrite(page);
+		} else {
+			clear_page_dirty_for_io(page);
+			set_page_writeback(page);
+		}
+		unlock_page(page);
 
 		/*
 		 * Preserve the original error if there was one, otherwise catch
@@ -899,7 +892,9 @@ xfs_writepage_map(
 		 * race with a partial page truncate on a sub-page block sized
 		 * filesystem. In that case we need to mark the page clean.
 		 */
-		xfs_start_page_writeback(page, 1);
+		clear_page_dirty_for_io(page);
+		set_page_writeback(page);
+		unlock_page(page);
 		end_page_writeback(page);
 	}
 
-- 
2.17.0

