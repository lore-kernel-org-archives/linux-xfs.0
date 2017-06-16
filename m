Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754445AbdFPOvp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:51:45 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 7/7] xfs: Switch to iomap for seeking in quota files
Date: Fri, 16 Jun 2017 16:51:20 +0200
Message-Id: <1497624680-16685-8-git-send-email-agruenba@redhat.com>
In-Reply-To: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
References: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Bob Peterson <rpeterso@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com

(This patch is largely untested.)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_dquot.c |   5 +-
 fs/xfs/xfs_file.c  | 320 -----------------------------------------------------
 fs/xfs/xfs_inode.h |   2 -
 3 files changed, 3 insertions(+), 324 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9d06cc3..a10bd921 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -39,6 +39,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_iomap.h"
 
 /*
  * Lock order:
@@ -726,8 +727,8 @@ xfs_dq_get_next_id(
 	quotip = xfs_quota_inode(mp, type);
 	lock = xfs_ilock_data_map_shared(quotip);
 
-	offset = __xfs_seek_hole_data(VFS_I(quotip), XFS_FSB_TO_B(mp, start),
-				      eof, SEEK_DATA);
+	offset = __iomap_seek_hole_data(VFS_I(quotip), XFS_FSB_TO_B(mp, start), eof,
+					SEEK_DATA, &xfs_iomap_ops);
 	if (offset < 0)
 		error = offset;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b36dcd7..3acbbaf 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -953,326 +953,6 @@ xfs_file_readdir(
 	return xfs_readdir(ip, ctx, bufsize);
 }
 
-/*
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
- * caller must lock inode with xfs_ilock_data_map_shared,
- * can we craft an appropriate ASSERT?
- *
- * end is because the VFS-level lseek interface is defined such that any
- * offset past i_size shall return -ENXIO, but we use this for quota code
- * which does not maintain i_size, and we want to SEEK_DATA past i_size.
- */
-loff_t
-__xfs_seek_hole_data(
-	struct inode		*inode,
-	loff_t			start,
-	loff_t			end,
-	int			whence)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	loff_t			uninitialized_var(offset);
-	xfs_fileoff_t		fsbno;
-	xfs_filblks_t		lastbno;
-	int			error;
-
-	if (start >= end) {
-		error = -ENXIO;
-		goto out_error;
-	}
-
-	/*
-	 * Try to read extents from the first block indicated
-	 * by fsbno to the end block of the file.
-	 */
-	fsbno = XFS_B_TO_FSBT(mp, start);
-	lastbno = XFS_B_TO_FSB(mp, end);
-
-	for (;;) {
-		struct xfs_bmbt_irec	map[2];
-		int			nmap = 2;
-		unsigned int		i;
-
-		error = xfs_bmapi_read(ip, fsbno, lastbno - fsbno, map, &nmap,
-				       XFS_BMAPI_ENTIRE);
-		if (error)
-			goto out_error;
-
-		/* No extents at given offset, must be beyond EOF */
-		if (nmap == 0) {
-			error = -ENXIO;
-			goto out_error;
-		}
-
-		for (i = 0; i < nmap; i++) {
-			offset = max_t(loff_t, start,
-				       XFS_FSB_TO_B(mp, map[i].br_startoff));
-
-			/* Landed in the hole we wanted? */
-			if (whence == SEEK_HOLE &&
-			    map[i].br_startblock == HOLESTARTBLOCK)
-				goto out;
-
-			/* Landed in the data extent we wanted? */
-			if (whence == SEEK_DATA &&
-			    (map[i].br_startblock == DELAYSTARTBLOCK ||
-			     (map[i].br_state == XFS_EXT_NORM &&
-			      !isnullstartblock(map[i].br_startblock))))
-				goto out;
-
-			/*
-			 * Landed in an unwritten extent, try to search
-			 * for hole or data from page cache.
-			 */
-			if (map[i].br_state == XFS_EXT_UNWRITTEN) {
-				if (xfs_find_get_desired_pgoff(inode, &map[i],
-				      whence == SEEK_HOLE ? HOLE_OFF : DATA_OFF,
-							&offset))
-					goto out;
-			}
-		}
-
-		/*
-		 * We only received one extent out of the two requested. This
-		 * means we've hit EOF and didn't find what we are looking for.
-		 */
-		if (nmap == 1) {
-			/*
-			 * If we were looking for a hole, set offset to
-			 * the end of the file (i.e., there is an implicit
-			 * hole at the end of any file).
-		 	 */
-			if (whence == SEEK_HOLE) {
-				offset = end;
-				break;
-			}
-			/*
-			 * If we were looking for data, it's nowhere to be found
-			 */
-			ASSERT(whence == SEEK_DATA);
-			error = -ENXIO;
-			goto out_error;
-		}
-
-		ASSERT(i > 1);
-
-		/*
-		 * Nothing was found, proceed to the next round of search
-		 * if the next reading offset is not at or beyond EOF.
-		 */
-		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
-		start = XFS_FSB_TO_B(mp, fsbno);
-		if (start >= end) {
-			if (whence == SEEK_HOLE) {
-				offset = end;
-				break;
-			}
-			ASSERT(whence == SEEK_DATA);
-			error = -ENXIO;
-			goto out_error;
-		}
-	}
-
-out:
-	/*
-	 * If at this point we have found the hole we wanted, the returned
-	 * offset may be bigger than the file size as it may be aligned to
-	 * page boundary for unwritten extents.  We need to deal with this
-	 * situation in particular.
-	 */
-	if (whence == SEEK_HOLE)
-		offset = min_t(loff_t, offset, end);
-
-	return offset;
-
-out_error:
-	return error;
-}
-
 STATIC loff_t
 xfs_seek_hole_data(
 	struct file		*file,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 10e89fc..17c441a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -445,8 +445,6 @@ int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
 		     xfs_fsize_t isize, bool *did_zeroing);
 int	xfs_zero_range(struct xfs_inode *ip, xfs_off_t pos, xfs_off_t count,
 		bool *did_zero);
-loff_t	__xfs_seek_hole_data(struct inode *inode, loff_t start,
-			     loff_t eof, int whence);
 
 
 /* from xfs_iops.c */
-- 
2.7.5

