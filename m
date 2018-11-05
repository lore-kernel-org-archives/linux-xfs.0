Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387420AbeKFB4o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Nov 2018 20:56:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] mm: don't break integrity writeback on ->writepage() error
Date: Mon,  5 Nov 2018 11:36:13 -0500
Message-Id: <20181105163613.7542-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

write_cache_pages() currently breaks out of the writepage loop in
the event of a ->writepage() error. This causes problems for
integrity writeback on XFS in the event of a persistent error as XFS
expects to process every dirty+delalloc page such that it can
discard delalloc blocks when real block allocation fails.  Failure
to handle all delalloc pages leaves the filesystem in an
inconsistent state if the integrity writeback happens to be due to
an unmount, for example.

Update write_cache_pages() to continue processing pages for
integrity writeback regardless of ->writepage() errors. Save the
first encountered error and return it once complete. This
facilitates XFS or any other fs that expects integrity writeback to
process the entire set of dirty pages regardless of errors.
Background writeback continues to exit on the first error
encountered.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This was actually first posted[1] as a patch in XFS to not return errors
from ->writepage() when called via write_cache_pages(). After some
discussion with Dave, it was suggested that this is a
write_cache_pages() bug rather than one in XFS. I think that could go
either way, so I'm floating this patch as an alternative. FWIW, that
same thread also includes a supporting patch for an fstests test[2] that
demonstrates the original problem this patch attempts to resolve.

This applies on top of v4.19 and I've tested it against XFS and ext4
(defaults) and not seen any regressions. Note that it's not clear to me
if ext4 is affected by the same or similar problem and I skipped btrfs
since it seems to duplicate all of the associated writeback code.

Finally, I'm not totally sure about the ->for_sync bit in the error
handling logic. I included it out of caution to try and handle any sort
of potential (->sync_mode == WB_SYNC_NONE && ->for_sync == 1)
combination, but that doesn't appear to be used anywhere that I can see.
Instead, ->for_sync seems more like an exceptional case of ->sync_mode
== WB_SYNC ALL.

Thoughts?

Brian

[1] https://marc.info/?l=linux-xfs&m=154102085505264&w=2
[2] https://marc.info/?l=fstests&m=154031860022439&w=2

 mm/page-writeback.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 84ae9bf5858a..9dbbf9465ff9 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2156,6 +2156,7 @@ int write_cache_pages(struct address_space *mapping,
 {
 	int ret = 0;
 	int done = 0;
+	int error;
 	struct pagevec pvec;
 	int nr_pages;
 	pgoff_t uninitialized_var(writeback_index);
@@ -2236,25 +2237,29 @@ int write_cache_pages(struct address_space *mapping,
 				goto continue_unlock;
 
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
-			ret = (*writepage)(page, wbc, data);
-			if (unlikely(ret)) {
-				if (ret == AOP_WRITEPAGE_ACTIVATE) {
+			error = (*writepage)(page, wbc, data);
+			if (unlikely(error)) {
+				if (error == AOP_WRITEPAGE_ACTIVATE) {
 					unlock_page(page);
-					ret = 0;
-				} else {
+					error = 0;
+				} else if (wbc->sync_mode != WB_SYNC_ALL &&
+					   !wbc->for_sync) {
 					/*
-					 * done_index is set past this page,
-					 * so media errors will not choke
+					 * done_index is set past this page, so
+					 * media errors will not choke
 					 * background writeout for the entire
 					 * file. This has consequences for
 					 * range_cyclic semantics (ie. it may
 					 * not be suitable for data integrity
 					 * writeout).
 					 */
+					ret = error;
 					done_index = page->index + 1;
 					done = 1;
 					break;
 				}
+				if (!ret)
+					ret = error;
 			}
 
 			/*
-- 
2.17.2
