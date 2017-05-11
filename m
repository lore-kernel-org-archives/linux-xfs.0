Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34511 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756542AbdEKQud (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 12:50:33 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] xfs: Move handling of missing page into one place in xfs_find_get_desired_pgoff()
Date: Thu, 11 May 2017 18:50:23 +0200
Message-Id: <20170511165023.29887-2-jack@suse.cz>
In-Reply-To: <20170511165023.29887-1-jack@suse.cz>
References: <20170511165023.29887-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

Currently several places in xfs_find_get_desired_pgoff() handle the case
of a missing page. Make them all handled in one place after the loop has
terminated.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index df51c025adfe..719923b99ba1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1069,10 +1069,6 @@ xfs_find_get_desired_pgoff(
 				break;
 
 			ASSERT(type == HOLE_OFF);
-			if (lastoff == startoff || lastoff < endoff) {
-				found = true;
-				*offset = lastoff;
-			}
 			break;
 		}
 
@@ -1080,11 +1076,8 @@ xfs_find_get_desired_pgoff(
 		 * At least we found one page. If the current offset is smaller
 		 * than the first page offset, a hole was found.
 		 */
-		if (type == HOLE_OFF && lastoff < page_offset(pvec.pages[0])) {
-			found = true;
-			*offset = lastoff;
+		if (type == HOLE_OFF && lastoff < page_offset(pvec.pages[0]))
 			break;
-		}
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page	*page = pvec.pages[i];
@@ -1150,21 +1143,20 @@ xfs_find_get_desired_pgoff(
 
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
2.12.0

