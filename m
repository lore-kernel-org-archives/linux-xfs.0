Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753913AbdFWATj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 20:19:39 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 3/3] xfs: Switch to page_cache_seek_hole_data
Date: Fri, 23 Jun 2017 02:19:33 +0200
Message-Id: <1498177173-30798-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1498177173-30798-1-git-send-email-agruenba@redhat.com>
References: <1498177173-30798-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

Fix SEEK_HOLE / SEEK_DATA when a page fits more than two filesystem
blocks (see the commit that introduces page_cache_seek_hole_data).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_file.c | 197 +++---------------------------------------------------
 1 file changed, 9 insertions(+), 188 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5fb5a09..fff9aba 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -954,191 +954,6 @@ xfs_file_readdir(
 }
 
 /*
- * This type is designed to indicate the type of offset we would like
- * to search from page cache for xfs_seek_hole_data().
- */
-enum {
-	HOLE_OFF = 0,
-	DATA_OFF,
-};
-
-/*
- * Lookup the desired type of offset from the given page.
- *
- * On success, return true and the offset argument will point to the
- * start of the region that was found.  Otherwise this function will
- * return false and keep the offset argument unchanged.
- */
-STATIC bool
-xfs_lookup_buffer_offset(
-	struct page		*page,
-	loff_t			*offset,
-	unsigned int		type)
-{
-	loff_t			lastoff = page_offset(page);
-	bool			found = false;
-	struct buffer_head	*bh, *head;
-
-	bh = head = page_buffers(page);
-	do {
-		/*
-		 * Unwritten extents that have data in the page
-		 * cache covering them can be identified by the
-		 * BH_Unwritten state flag.  Pages with multiple
-		 * buffers might have a mix of holes, data and
-		 * unwritten extents - any buffer with valid
-		 * data in it should have BH_Uptodate flag set
-		 * on it.
-		 */
-		if (buffer_unwritten(bh) ||
-		    buffer_uptodate(bh)) {
-			if (type == DATA_OFF)
-				found = true;
-		} else {
-			if (type == HOLE_OFF)
-				found = true;
-		}
-
-		if (found) {
-			*offset = lastoff;
-			break;
-		}
-		lastoff += bh->b_size;
-	} while ((bh = bh->b_this_page) != head);
-
-	return found;
-}
-
-/*
- * This routine is called to find out and return a data or hole offset
- * from the page cache for unwritten extents according to the desired
- * type for xfs_seek_hole_data().
- *
- * The argument offset is used to tell where we start to search from the
- * page cache.  Map is used to figure out the end points of the range to
- * lookup pages.
- *
- * Return true if the desired type of offset was found, and the argument
- * offset is filled with that address.  Otherwise, return false and keep
- * offset unchanged.
- */
-STATIC bool
-xfs_find_get_desired_pgoff(
-	struct inode		*inode,
-	struct xfs_bmbt_irec	*map,
-	unsigned int		type,
-	loff_t			*offset)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	struct pagevec		pvec;
-	pgoff_t			index;
-	pgoff_t			end;
-	loff_t			endoff;
-	loff_t			startoff = *offset;
-	loff_t			lastoff = startoff;
-	bool			found = false;
-
-	pagevec_init(&pvec, 0);
-
-	index = startoff >> PAGE_SHIFT;
-	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
-	end = (endoff - 1) >> PAGE_SHIFT;
-	do {
-		int		want;
-		unsigned	nr_pages;
-		unsigned int	i;
-
-		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
-					  want);
-		if (nr_pages == 0)
-			break;
-
-		for (i = 0; i < nr_pages; i++) {
-			struct page	*page = pvec.pages[i];
-			loff_t		b_offset;
-
-			/*
-			 * At this point, the page may be truncated or
-			 * invalidated (changing page->mapping to NULL),
-			 * or even swizzled back from swapper_space to tmpfs
-			 * file mapping. However, page->index will not change
-			 * because we have a reference on the page.
-			 *
-			 * If current page offset is beyond where we've ended,
-			 * we've found a hole.
-			 */
-			if (type == HOLE_OFF && lastoff < endoff &&
-			    lastoff < page_offset(pvec.pages[i])) {
-				found = true;
-				*offset = lastoff;
-				goto out;
-			}
-			/* Searching done if the page index is out of range. */
-			if (page->index > end)
-				goto out;
-
-			lock_page(page);
-			/*
-			 * Page truncated or invalidated(page->mapping == NULL).
-			 * We can freely skip it and proceed to check the next
-			 * page.
-			 */
-			if (unlikely(page->mapping != inode->i_mapping)) {
-				unlock_page(page);
-				continue;
-			}
-
-			if (!page_has_buffers(page)) {
-				unlock_page(page);
-				continue;
-			}
-
-			found = xfs_lookup_buffer_offset(page, &b_offset, type);
-			if (found) {
-				/*
-				 * The found offset may be less than the start
-				 * point to search if this is the first time to
-				 * come here.
-				 */
-				*offset = max_t(loff_t, startoff, b_offset);
-				unlock_page(page);
-				goto out;
-			}
-
-			/*
-			 * We either searching data but nothing was found, or
-			 * searching hole but found a data buffer.  In either
-			 * case, probably the next page contains the desired
-			 * things, update the last offset to it so.
-			 */
-			lastoff = page_offset(page) + PAGE_SIZE;
-			unlock_page(page);
-		}
-
-		/*
-		 * The number of returned pages less than our desired, search
-		 * done.
-		 */
-		if (nr_pages < want)
-			break;
-
-		index = pvec.pages[i - 1]->index + 1;
-		pagevec_release(&pvec);
-	} while (index <= end);
-
-	/* No page at lastoff and we are not done - we found a hole. */
-	if (type == HOLE_OFF && lastoff < endoff) {
-		*offset = lastoff;
-		found = true;
-	}
-out:
-	pagevec_release(&pvec);
-	return found;
-}
-
-/*
  * caller must lock inode with xfs_ilock_data_map_shared,
  * can we craft an appropriate ASSERT?
  *
@@ -1209,10 +1024,16 @@ __xfs_seek_hole_data(
 			 * for hole or data from page cache.
 			 */
 			if (map[i].br_state == XFS_EXT_UNWRITTEN) {
-				if (xfs_find_get_desired_pgoff(inode, &map[i],
-				      whence == SEEK_HOLE ? HOLE_OFF : DATA_OFF,
-							&offset))
+				xfs_fileoff_t endoff = map[i].br_startoff +
+						       map[i].br_blockcount;
+				loff_t length = XFS_FSB_TO_B(mp, endoff) - offset;
+				loff_t ret;
+
+				ret = page_cache_seek_hole_data(inode, offset, length, whence);
+				if (ret >= 0) {
+					offset = ret;
 					goto out;
+				}
 			}
 		}
 
-- 
2.7.5

