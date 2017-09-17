Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdIQVHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:13 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/47] xfs: Move handling of missing page into one place in xfs_find_get_desired_pgoff()
Date: Sun, 17 Sep 2017 14:06:26 -0700
Message-Id: <20170917210712.10804-2-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Jan Kara <jack@suse.cz>

commit a54fba8f5a0dc36161cacdf2aa90f007f702ec1a upstream.

Currently several places in xfs_find_get_desired_pgoff() handle the case
of a missing page. Make them all handled in one place after the loop has
terminated.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 38 ++++++++------------------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index df206cfc21f7..2e04b1cdb0d2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1139,29 +1139,8 @@ xfs_find_get_desired_pgoff(
 		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
 		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
 					  want);
-		/*
-		 * No page mapped into given range.  If we are searching holes
-		 * and if this is the first time we got into the loop, it means
-		 * that the given offset is landed in a hole, return it.
-		 *
-		 * If we have already stepped through some block buffers to find
-		 * holes but they all contains data.  In this case, the last
-		 * offset is already updated and pointed to the end of the last
-		 * mapped page, if it does not reach the endpoint to search,
-		 * that means there should be a hole between them.
-		 */
-		if (nr_pages == 0) {
-			/* Data search found nothing */
-			if (type == DATA_OFF)
-				break;
-
-			ASSERT(type == HOLE_OFF);
-			if (lastoff == startoff || lastoff < endoff) {
-				found = true;
-				*offset = lastoff;
-			}
+		if (nr_pages == 0)
 			break;
-		}
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page	*page = pvec.pages[i];
@@ -1227,21 +1206,20 @@ xfs_find_get_desired_pgoff(
 
 		/*
 		 * The number of returned pages less than our desired, search
-		 * done.  In this case, nothing was found for searching data,
-		 * but we found a hole behind the last offset.
+		 * done.
 		 */
-		if (nr_pages < want) {
-			if (type == HOLE_OFF) {
-				*offset = lastoff;
-				found = true;
-			}
+		if (nr_pages < want)
 			break;
-		}
 
 		index = pvec.pages[i - 1]->index + 1;
 		pagevec_release(&pvec);
 	} while (index <= end);
 
+	/* No page at lastoff and we are not done - we found a hole. */
+	if (type == HOLE_OFF && lastoff < endoff) {
+		*offset = lastoff;
+		found = true;
+	}
 out:
 	pagevec_release(&pvec);
 	return found;
-- 
2.14.1

