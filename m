Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933889AbeEIHu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 03:50:26 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 28/33] xfs: refactor the tail of xfs_writepage_map
Date: Wed,  9 May 2018 09:48:25 +0200
Message-Id: <20180509074830.16196-29-hch@lst.de>
In-Reply-To: <20180509074830.16196-1-hch@lst.de>
References: <20180509074830.16196-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

Rejuggle how we deal with the different error vs non-error and have
ioends vs not have ioend cases to keep the fast path streamlined, and
the duplicate code at a minimum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 65 +++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6b39792270aa..dc82d4e71a64 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -906,7 +906,14 @@ xfs_writepage_map(
 	 * submission of outstanding ioends on the writepage context so they are
 	 * treated correctly on error.
 	 */
-	if (count) {
+	if (unlikely(error)) {
+		if (!count) {
+			xfs_aops_discard_page(page);
+			ClearPageUptodate(page);
+			unlock_page(page);
+			goto done;
+		}
+
 		/*
 		 * If the page was not fully cleaned, we need to ensure that the
 		 * higher layers come back to it correctly.  That means we need
@@ -915,43 +922,35 @@ xfs_writepage_map(
 		 * so another attempt to write this page in this writeback sweep
 		 * will be made.
 		 */
-		if (error) {
-			set_page_writeback_keepwrite(page);
-		} else {
-			clear_page_dirty_for_io(page);
-			set_page_writeback(page);
-		}
-		unlock_page(page);
-
-		/*
-		 * Preserve the original error if there was one, otherwise catch
-		 * submission errors here and propagate into subsequent ioend
-		 * submissions.
-		 */
-		list_for_each_entry_safe(ioend, next, &submit_list, io_list) {
-			int error2;
-
-			list_del_init(&ioend->io_list);
-			error2 = xfs_submit_ioend(wbc, ioend, error);
-			if (error2 && !error)
-				error = error2;
-		}
-	} else if (error) {
-		xfs_aops_discard_page(page);
-		ClearPageUptodate(page);
-		unlock_page(page);
+		set_page_writeback_keepwrite(page);
 	} else {
-		/*
-		 * We can end up here with no error and nothing to write if we
-		 * race with a partial page truncate on a sub-page block sized
-		 * filesystem. In that case we need to mark the page clean.
-		 */
 		clear_page_dirty_for_io(page);
 		set_page_writeback(page);
-		unlock_page(page);
-		end_page_writeback(page);
 	}
 
+	unlock_page(page);
+
+	/*
+	 * Preserve the original error if there was one, otherwise catch
+	 * submission errors here and propagate into subsequent ioend
+	 * submissions.
+	 */
+	list_for_each_entry_safe(ioend, next, &submit_list, io_list) {
+		int error2;
+
+		list_del_init(&ioend->io_list);
+		error2 = xfs_submit_ioend(wbc, ioend, error);
+		if (error2 && !error)
+			error = error2;
+	}
+
+	/*
+	 * We can end up here with no error and nothing to write if we race with
+	 * a partial page truncate on a sub-page block sized filesystem.
+	 */
+	if (!count)
+		end_page_writeback(page);
+done:
 	mapping_set_error(page->mapping, error);
 	return error;
 }
-- 
2.17.0

