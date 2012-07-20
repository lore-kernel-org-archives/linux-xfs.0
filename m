Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6K8T2DW098072 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 03:29:02 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id OAE5Sycd5edcNGbs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Jul 2012 01:29:01 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q6K8Sw9D013965
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 08:28:59 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q6K8SwkB006976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 08:28:58 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q6K8Sv8D026844 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 03:28:57 -0500
Message-ID: <50091696.4000903@oracle.com>
Date: Fri, 20 Jul 2012 16:28:06 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4] xfs: probe data buffer from page cache for unwritten
	extents
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi All,

According to Mark and Christoph's comments for v3, except optimizing xfs_seek_data() with unwritten extents
probing, the xfs_seek_hole() is also refined to that in this version.

Hi Mark,
I have one code change in xfs_has_unwritten_buffer() need to update for you.
Originally, we did BH state examination combine with "*offset <= XFS_FSB_TO_B(mp, last)", this caused a few
corner cases run failed per my tests.
For instance, assuming we have a tiny pre-allocated file only has 8 bytes and call SEEK_DATA with offset = 1 against it.
In this case, '*offset' is 1 but XFS_FSB_TO_B(mp, last) is calculated to *ZERO*, xfs_has_unwritten_buffea r() will return
false with a data extent missing.
I have removed this check logic from there, it does not affect the test results that I have verified through your seekv8 test program.
Hence, we still got optimized as transfer '*offset' ranther than 'map[x].br_startoff' to xfs_has_unwritten_buffer(). :)


v3->v4:
xfs_seek_hole() refinement, suggested by Mark and Christoph.
* refine xfs_seek_hole() with unwritten extents search, treat it as a hole if no data buffer was found from page cache.
* s/goto out/break/g, break out of the extent maps reading loop rather than 'go to', I must have got my head up in the clouds when writing v3. :(
* xfs_has_unwritten_buffer(), remove 'offset <= XFS_FSB_TO_B(mp, last))' from BH state checking branch.
  The page index offset might less than '*start', so we will miss a data extent if so.
* xfs_has_unwritten_buffer(), don't reset '*offset' to *ZERO* if no data buffer was found because of xfs_seek_hole() will
  call this function to examine an unwritten extent has data or not.  If not, it will use the returned '*offset' as a hole offset.
  So set '*offset' to zero in xfs_has_unwritten_buffer() will lead to wrong result.
* avoid re-starting the next round search in both xfs_seek_data() and xfs_seek_hole() if the end offset of the 2nd extent map is hit the EOF.
  So for SEEK_DATA, it means there is no data extent beyond the current offset and return ENXIO, for SEEK_HOLE, return the file
  size to indicate hitting EOF.  The comments were also changed(s/reading offset not beyond/reading offset not beyond or hit EOF/)accordingly.

v2->v3:
Tested by Mark, hit BUG() for continuous unwritten extents without data wrote.
* xfs_seek_data(), remove BUG() and having extents map search in loop.

v1->v2:
suggested by Mark.
* xfs_has_unwritten_buffer(), use the input offset instead of bmap->br_startoff to
 calculate page index for data buffer probing.

Thanks,
-Jeff


Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_file.c |  283 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 254 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9f7ec15..5934de9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
+#include <linux/pagevec.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -966,6 +967,106 @@ xfs_vm_page_mkwrite(
 	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
 }
 
+/*
+ * Probe the data buffer offset in page cache for unwritten extents.
+ * Iterate each page to find out if a buffer head state has BH_Unwritten
+ * or BH_Uptodate set.
+ */
+STATIC bool
+xfs_has_unwritten_buffer(
+	struct inode		*inode,
+	struct xfs_bmbt_irec	*map,
+	loff_t			*offset)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct pagevec		pvec;
+	pgoff_t			index;
+	pgoff_t			end;
+	bool			found = false;
+
+	pagevec_init(&pvec, 0);
+
+	index = XFS_FSB_TO_B(mp, XFS_B_TO_FSBT(mp, *offset))
+			     >> PAGE_CACHE_SHIFT;
+	end = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount)
+			   >> PAGE_CACHE_SHIFT;
+	pr_info("page search: index=%lu, end=%lu\n", index, end);
+	do {
+		unsigned int	i;
+		unsigned	nr_pages;
+		int		want = min_t(pgoff_t, end - index,
+					     (pgoff_t)PAGEVEC_SIZE - 1) + 1;
+		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
+					  want);
+		if (nr_pages == 0)
+			break;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page		*page = pvec.pages[i];
+			struct buffer_head	*bh;
+			struct buffer_head	*head;
+			xfs_fileoff_t		last;
+
+			/*
+			 * There is no need to check the following pages
+			 * if the current page offset is out of range.
+			 */
+			if (page->index > end)
+				goto out;
+
+			if (!trylock_page(page))
+				goto out;
+
+			if (!page_has_buffers(page)) {
+				unlock_page(page);
+				continue;
+			}
+
+			last = XFS_B_TO_FSBT(mp,
+					     page->index << PAGE_CACHE_SHIFT);
+			bh = head = page_buffers(page);
+			do {
+				/*
+				 * An extent in XFS_EXT_UNWRITTEN has disk
+				 * blocks already mapped to it, but no data
+				 * has been committed to them yet.  If it has
+				 * dirty data in the page cache it can be
+				 * identified by having BH_Unwritten set in
+				 * each buffers.  Also, the buffer head state
+				 * might be in BH_Uptodate too if the buffer
+				 * writeback procedure was fired, we need to
+				 * examine it as well.
+				 */
+				if (buffer_unwritten(bh) ||
+				    buffer_uptodate(bh)) {
+					found = true;
+					*offset = max_t(loff_t, *offset,
+							XFS_FSB_TO_B(mp, last));
+					unlock_page(page);
+					goto out;
+				}
+				last++;
+			} while ((bh = bh->b_this_page) != head);
+			unlock_page(page);
+		}
+
+		/*
+		 * If the number of probed pages less than our desired,
+		 * there should no more pages mapped, search done.
+		 */
+		if (nr_pages < want)
+			break;
+
+		index = pvec.pages[i - 1]->index + 1;
+		pagevec_release(&pvec);
+	} while (index < end);
+
+out:
+	pagevec_release(&pvec);
+	return found;
+}
+
 STATIC loff_t
 xfs_seek_data(
 	struct file		*file,
@@ -975,8 +1076,6 @@ xfs_seek_data(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	map[2];
-	int			nmap = 2;
 	loff_t			uninitialized_var(offset);
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
@@ -987,39 +1086,97 @@ xfs_seek_data(
 	lock = xfs_ilock_map_shared(ip);
 
 	isize = i_size_read(inode);
+
 	if (start >= isize) {
 		error = ENXIO;
 		goto out_unlock;
 	}
 
-	fsbno = XFS_B_TO_FSBT(mp, start);
-
 	/*
 	 * Try to read extents from the first block indicated
 	 * by fsbno to the end block of the file.
 	 */
+	fsbno = XFS_B_TO_FSBT(mp, start);
 	end = XFS_B_TO_FSB(mp, isize);
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
 
-	error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
-			       XFS_BMAPI_ENTIRE);
-	if (error)
-		goto out_unlock;
+		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			goto out_unlock;
 
-	/*
-	 * Treat unwritten extent as data extent since it might
-	 * contains dirty data in page cache.
-	 */
-	if (map[0].br_startblock != HOLESTARTBLOCK) {
-		offset = max_t(loff_t, start,
-			       XFS_FSB_TO_B(mp, map[0].br_startoff));
-	} else {
-		if (nmap == 1) {
+		/* No extents at given offset, must be beyond EOF */
+		if (nmap == 0) {
 			error = ENXIO;
 			goto out_unlock;
 		}
 
 		offset = max_t(loff_t, start,
-			       XFS_FSB_TO_B(mp, map[1].br_startoff));
+			       XFS_FSB_TO_B(mp, map[0].br_startoff));
+		if (map[0].br_state == XFS_EXT_NORM &&
+		    !isnullstartblock(map[0].br_startblock))
+			break;
+		else {
+			/*
+			 * Landed in an unwritten extent, try to search
+			 * data buffer from page cache firstly.  Treat
+			 * it as a hole if nothing was found, and skip
+			 * to check the next extent.
+			 */
+			if (map[0].br_startblock == DELAYSTARTBLOCK ||
+			    map[0].br_state == XFS_EXT_UNWRITTEN) {
+				/* Probing page cache start from offset */
+				if (xfs_has_unwritten_buffer(inode, &map[0],
+							     &offset))
+					break;
+			}
+
+			/*
+			 * Found a hole in map[0] and nothing in map[1].
+			 * Probably means that we are reading after EOF.
+			 */
+			if (nmap == 1) {
+				error = ENXIO;
+				goto out_unlock;
+			}
+
+			/*
+			 * We have two mappings, and need to check map[1] to
+			 * see if there is data or not.
+			 */
+			offset = max_t(loff_t, start,
+				       XFS_FSB_TO_B(mp, map[1].br_startoff));
+			if (map[1].br_state == XFS_EXT_NORM &&
+			    !isnullstartblock(map[1].br_startblock))
+				break;
+			else {
+				/*
+				 * So map[1] is an unwritten extent as well,
+				 * try to search for data buffer in page cache.
+				 * We might find nothing if it is an allocated
+				 * and resvered extent.
+				 */
+				if (map[1].br_startblock == DELAYSTARTBLOCK ||
+				    map[1].br_state == XFS_EXT_UNWRITTEN) {
+					if (xfs_has_unwritten_buffer(inode,
+							&map[1], &offset))
+						break;
+				}
+			}
+		}
+
+		/*
+		 * Nothing was found, proceed to the next round of search if
+		 * reading offset not beyond or hit EOF.
+		 */
+		fsbno = map[1].br_startoff + map[1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start >= isize) {
+			error = ENXIO;
+			goto out_unlock;
+		}
 	}
 
 	if (offset != file->f_pos)
@@ -1043,9 +1200,9 @@ xfs_seek_hole(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	loff_t			uninitialized_var(offset);
-	loff_t			holeoff;
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		end;
 	uint			lock;
 	int			error;
 
@@ -1061,19 +1218,87 @@ xfs_seek_hole(
 	}
 
 	fsbno = XFS_B_TO_FSBT(mp, start);
-	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
-	if (error)
-		goto out_unlock;
+	end = XFS_B_TO_FSB(mp, isize);
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+
+		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			goto out_unlock;
+
+		/* No extents at given offset, must be beyond EOF */
+		if (nmap == 0) {
+			error = ENXIO;
+			goto out_unlock;
+		}
+
+		offset = max_t(loff_t, start,
+			       XFS_FSB_TO_B(mp, map[0].br_startoff));
+		if (map[0].br_startblock == HOLESTARTBLOCK)
+			break;
+		else {
+			/*
+			 * Landed in an unwritten extent, try to search
+			 * data buffer from page cache firstly.  Treat
+			 * it as a hole and return the offset if nothing
+			 * was found.
+			 */
+			if (map[0].br_state == XFS_EXT_UNWRITTEN ||
+			    isnullstartblock(map[0].br_startblock)) {
+				/* Probing page cache start from offset */
+				if (!xfs_has_unwritten_buffer(inode, &map[0],
+							      &offset))
+					break;
+			}
+
+			/*
+			 * map[0] is unwritten and there is no hole past
+			 * offset, probably means that we are reading after
+			 * EOF.  Then the file offset is adjusted to the
+			 * end of the file(i.e., there is an implicit hole
+			 * at the end of any file).
+			 */
+			if (nmap == 1) {
+				offset = isize;
+				break;
+			}
+
+			/*
+			 * We have two mappings, and need to check map[1] to
+			 * see if it is a hole or not.
+			 */
+			offset = max_t(loff_t, start,
+				       XFS_FSB_TO_B(mp, map[1].br_startoff));
+			if (map[1].br_startblock == HOLESTARTBLOCK)
+				break;
+			else {
+				/*
+				 * So map[1] is an unwritten extent as well.
+				 * Try to search for data buffer in page cache.
+				 * Treat it as a hole and return the offset if
+				 * nothing was found.
+				 */
+				if (map[1].br_state == XFS_EXT_UNWRITTEN ||
+				    isnullstartblock(map[1].br_startblock)) {
+					if (!xfs_has_unwritten_buffer(inode,
+							&map[1], &offset))
+						break;
+				}
+			}
+		}
 
-	holeoff = XFS_FSB_TO_B(mp, fsbno);
-	if (holeoff <= start)
-		offset = start;
-	else {
 		/*
-		 * xfs_bmap_first_unused() could return a value bigger than
-		 * isize if there are no more holes past the supplied offset.
+		 * Both mappings are have data, proceed to the next round of
+		 * search if reading offset not beyond or hit EOF.
 		 */
-		offset = min_t(loff_t, holeoff, isize);
+		fsbno = map[1].br_startoff + map[1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start >= isize) {
+			offset = isize;
+			break;
+		}
 	}
 
 	if (offset != file->f_pos)
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
