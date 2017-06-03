Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38837 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdFCNTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:19:52 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/25] xfs: Fix missed holes in SEEK_HOLE implementation
Date: Sat,  3 Jun 2017 15:18:35 +0200
Message-Id: <20170603131836.26661-25-hch@lst.de>
In-Reply-To: <20170603131836.26661-1-hch@lst.de>
References: <20170603131836.26661-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Jan Kara <jack@suse.cz>

commit 5375023ae1266553a7baa0845e82917d8803f48c upstream.

XFS SEEK_HOLE implementation could miss a hole in an unwritten extent as
can be seen by the following command:

xfs_io -c "falloc 0 256k" -c "pwrite 0 56k" -c "pwrite 128k 8k"
       -c "seek -h 0" file
wrote 57344/57344 bytes at offset 0
56 KiB, 14 ops; 0.0000 sec (49.312 MiB/sec and 12623.9856 ops/sec)
wrote 8192/8192 bytes at offset 131072
8 KiB, 2 ops; 0.0000 sec (70.383 MiB/sec and 18018.0180 ops/sec)
Whence	Result
HOLE	139264

Where we can see that hole at offset 56k was just ignored by SEEK_HOLE
implementation. The bug is in xfs_find_get_desired_pgoff() which does
not properly detect the case when pages are not contiguous.

Fix the problem by properly detecting when found page has larger offset
than expected.

Fixes: d126d43f631f996daeee5006714fed914be32368
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a4efc61fa775..9292a59efbfa 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1163,17 +1163,6 @@ xfs_find_get_desired_pgoff(
 			break;
 		}
 
-		/*
-		 * At lease we found one page.  If this is the first time we
-		 * step into the loop, and if the first page index offset is
-		 * greater than the given search offset, a hole was found.
-		 */
-		if (type == HOLE_OFF && lastoff == startoff &&
-		    lastoff < page_offset(pvec.pages[0])) {
-			found = true;
-			break;
-		}
-
 		for (i = 0; i < nr_pages; i++) {
 			struct page	*page = pvec.pages[i];
 			loff_t		b_offset;
@@ -1185,18 +1174,18 @@ xfs_find_get_desired_pgoff(
 			 * file mapping. However, page->index will not change
 			 * because we have a reference on the page.
 			 *
-			 * Searching done if the page index is out of range.
-			 * If the current offset is not reaches the end of
-			 * the specified search range, there should be a hole
-			 * between them.
+			 * If current page offset is beyond where we've ended,
+			 * we've found a hole.
 			 */
-			if (page->index > end) {
-				if (type == HOLE_OFF && lastoff < endoff) {
-					*offset = lastoff;
-					found = true;
-				}
+			if (type == HOLE_OFF && lastoff < endoff &&
+			    lastoff < page_offset(pvec.pages[i])) {
+				found = true;
+				*offset = lastoff;
 				goto out;
 			}
+			/* Searching done if the page index is out of range. */
+			if (page->index > end)
+				goto out;
 
 			lock_page(page);
 			/*
-- 
2.11.0

