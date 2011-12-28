Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBSDaEcj181394 for <xfs@oss.sgi.com>; Wed, 28 Dec 2011 07:36:14 -0600
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id ejL49aMWn45xgSUo for
	<xfs@oss.sgi.com>; Wed, 28 Dec 2011 05:36:11 -0800 (PST)
Message-ID: <4EFB1B23.7050008@oracle.com>
Date: Wed, 28 Dec 2011 21:35:31 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V4
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
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>

Hello,

Sorry for the delay! Now the V4 patch for adding SEEK_DATA/SEEK_HOLE support to XFS is coming.

Changes to V3:
==============
1. The name and interface of probing page cache for unwritten extents was changed:
V3:
loff_t
xfs_probe_unwritten_buffer(
       struct inode            *inode,
       struct xfs_bmbt_irec    *map,
       int                     *found)

V4:
bool
xfs_has_unwritten_buffer(
        struct inode            *inode,
        struct xfs_bmbt_irec    *map,
        bool                    get_offset,
        loff_t                  *offset)

The benefit is, we can avoid to evaluate the data buffer offset for SEEK_HOLE requirement, and just
check if there is data buffer in page cache or not for a given extent in unwritten state. Maybe the routine
name still looks a bit ugly, but I had really racked my brain to think this stupid name out. :(

2. Examine the BH_Uptodate state too, since the buffer head state might be changed to it if the buffer
writeback procedure was fired.

3. The signature for both xfs_seek_data() and xfs_seek_hole() have been changed too.
I have removed the 'type' argument, it is definitely redundancy as we have already isolated SEEK_DATA/SEEK_HOLE to the
separate functions.

4. In both xfs_seek_data() and xfs_seek_hole() functions, check the count of nmap returns form xfs_bmapi_read().
We do not need to check the next extent status again if only 1 extent searched out. It means we have gone through
the total file.

TESTS:
======
Improve Josef's tests and integrated to xfstests, with a few test coverage enhancements:
1. Add a new test to verify a file with only DIRTY pages.
2. Add a new test to verify a file with only WRITEBACK pages, it was implemented through sync_file_range(2), thanks Christoph's advise. :-P.
3. Add a new test to verify a file with both DIRTY and WRITEBACK pages.

Also, I am working on another test now, it is intended to enlarge the current test coverage by creating larger files with a couple of extents
or even thousands. The test file can be created in preallocation mode or just a normal sparse file. It also support to sync a range of pages to
WRITEBACK mode, and then do copy tests to verify there is no data loss.
I'll send it out too but it was not integrated to xfstests now, I'd like to see more comments for this test.

Any feedback are appreciated!

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |  432 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 431 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 753ed9b..d8329f9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -38,6 +38,7 @@
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
+#include <linux/pagevec.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1141,8 +1142,437 @@ xfs_vm_page_mkwrite(
 	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
 }
 
+/*
+ * Try to lookup the data buffer in page cache for unwritten extents.
+ * Firstly, try to find out the DIRTY pages which are mapped in current
+ * extent range, and iterate each page to lookup all theirs data buffers.
+ * If a buffer head in unwritten or in uptodate state, return its offset
+ * if required. If there is no DIRTY pages meet our requirements, we need
+ * to probe the WRITEBACK pages again and perform the same operations
+ * again to avoid data loss.
+ *
+ * Return the data buffer offset for SEEK_DATA operation.
+ * For SEEK_HOLE, just let the caller know if there is data buffer or not.
+ */
+STATIC bool
+xfs_has_unwritten_buffer(
+	struct inode		*inode,
+	struct xfs_bmbt_irec	*map,
+	bool			get_offset,
+	loff_t			*offset)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct pagevec		pvec;
+	pgoff_t			index;
+	pgoff_t			end;
+	bool			found = false;
+	int			tag = PAGECACHE_TAG_DIRTY;
+
+	pagevec_init(&pvec, 0);
+
+again:
+	index = XFS_FSB_TO_B(mp, map->br_startoff) >> PAGE_CACHE_SHIFT;
+	end = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount)
+			   >> PAGE_CACHE_SHIFT;
+
+	do {
+		unsigned int	i;
+		unsigned	nr_pages;
+		int		want = min_t(pgoff_t, end - index,
+					     (pgoff_t)PAGEVEC_SIZE - 1) + 1;
+		nr_pages = pagevec_lookup_tag(&pvec, inode->i_mapping,
+					      &index, tag, want);
+		if (nr_pages == 0) {
+			/*
+			 * Try to lookup pages in writeback mode from the
+			 * beginning if no more dirty page can be probed.
+			 */
+probe_done:
+			if (tag == PAGECACHE_TAG_DIRTY) {
+				tag = PAGECACHE_TAG_WRITEBACK;
+				goto again;
+			}
+			break;
+		}
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page		*page = pvec.pages[i];
+			struct buffer_head	*bh;
+			struct buffer_head	*head;
+			xfs_fileoff_t		last;
+
+			if (!page_has_buffers(page))
+				continue;
+
+			/*
+			 * There is no need to check the following pages
+			 * if the current page offset is out of range.
+			 */
+			if (page->index > end)
+				goto probe_done;
+
+			last = XFS_B_TO_FSBT(mp,
+					     page->index << PAGE_CACHE_SHIFT);
+
+			bh = head = page_buffers(page);
+			do {
+				/*
+				 * An extent in XFS_EXT_UNWRITTEN have disk
+				 * blocks already mapped to it, but no data
+				 * has been committed to them yet. If it has
+				 * dirty data in the page cache it can be
+				 * identified by having BH_Unwritten set in
+				 * each buffer. Also, the buffer head state
+				 * might be in BH_Uptodate if the buffer
+				 * writeback procedure was fired, we need to
+				 * examine it too.
+				 */
+				if (buffer_unwritten(bh) ||
+				    buffer_uptodate(bh)) {
+					found = true;
+					if (get_offset)
+						*offset = XFS_FSB_TO_B(
+								mp, last);
+					goto out;
+				}
+				last++;
+			} while ((bh = bh->b_this_page) != head);
+		}
+
+		/*
+		 * If the number of probed pages less than our desired,
+		 * there should no more pages mapped. Try to lookup the
+		 * writeback pages if possible.
+		 */
+		if (nr_pages < want)
+			goto probe_done;
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
+STATIC loff_t
+xfs_seek_data(
+	struct file		*file,
+	loff_t			start)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fsize_t		isize = i_size_read(inode);
+	loff_t			offset = 0;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		len;
+	int			lock;
+	int			error;
+
+	lock = xfs_ilock_map_shared(ip);
+
+	if (start >= isize) {
+		error = ENXIO;
+		goto out_lock;
+	}
+
+	fsbno = XFS_B_TO_FSBT(mp, start);
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	len = XFS_B_TO_FSB(mp, isize);
+
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+		loff_t			seekoff;
+
+		error = xfs_bmapi_read(ip, fsbno, len - fsbno, map, &nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			goto out_lock;
+
+		/* No extents at given offset, must be beyond EOF */
+		if (!nmap) {
+			error = ENXIO;
+			goto out_lock;
+		}
+
+		seekoff = XFS_FSB_TO_B(mp, fsbno);
+
+		/*
+		 * Landed in a hole, skip to check the next extent.
+		 * If the next extent landed in an in-memory data extent,
+		 * or it is a normal extent, its fine to return.
+		 * If the next extent landed in a hole extent, calculate
+		 * the start file system block number for the next scan.
+		 * If the next extent landed in an unwritten extent, we
+		 * need to lookup the page cache to examine the data
+		 * buffer offset, if nothing found, treat it as a hole
+		 * extent too.
+		 */
+		if (map[0].br_startblock == HOLESTARTBLOCK) {
+			/*
+			 * Return ENXIO if no data extent behind
+			 * the given offset. In this case, the seek
+			 * offset should be landed in a hole.
+			 */
+			if (nmap == 1) {
+				error = ENXIO;
+				break;
+			}
+
+			if (map[1].br_state == XFS_EXT_NORM ||
+			    map[1].br_startblock == DELAYSTARTBLOCK) {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
+				if (xfs_has_unwritten_buffer(inode, &map[1],
+							     1, &offset)) {
+					offset = max_t(loff_t, seekoff, offset);
+					break;
+				}
+			}
+
+			fsbno = map[1].br_startoff + map[1].br_blockcount;
+		}
+
+		/*
+		 * Landed in an unwritten extent, try to find out the data
+		 * buffer offset from page cache firstly. If nothing was
+		 * found, treat it as a hole, and skip to check the next
+		 * extent, something just like above.
+		 */
+		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
+			if (xfs_has_unwritten_buffer(inode, &map[0], 1,
+						     &offset)) {
+				offset = max_t(loff_t, seekoff, offset);
+				break;
+			}
+
+			/* No data extent at the given offset */
+			if (nmap == 1) {
+				error = ENXIO;
+				break;
+			}
+
+			if (map[1].br_state == XFS_EXT_NORM ||
+			    map[1].br_startblock == DELAYSTARTBLOCK) {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
+				if (xfs_has_unwritten_buffer(inode, &map[1], 1,
+							     &offset)) {
+					offset = max_t(loff_t, seekoff, offset);
+					break;
+				}
+			}
+
+			fsbno = map[1].br_startoff + map[1].br_blockcount;
+		}
+
+		/* Landed in a delay allocated extent or a real data extent */
+		if (map[0].br_startblock == DELAYSTARTBLOCK ||
+		    map[0].br_state == XFS_EXT_NORM) {
+			offset = max_t(loff_t, seekoff,
+				       XFS_FSB_TO_B(mp, map[0].br_startoff));
+			break;
+		}
+
+		/* Return ENXIO if beyond eof */
+		if (XFS_FSB_TO_B(mp, fsbno) > isize) {
+			error = ENXIO;
+			goto out_lock;
+		}
+	}
+
+	if (offset < start)
+		offset = start;
+
+	if (offset != file->f_pos)
+		file->f_pos = offset;
+
+out_lock:
+	xfs_iunlock_map_shared(ip, lock);
+
+	if (error)
+		return -error;
+
+	return offset;
+}
+
+STATIC loff_t
+xfs_seek_hole(
+	struct file		*file,
+	loff_t			start)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fsize_t		isize = i_size_read(inode);
+	loff_t			offset = 0;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		len;
+	int			lock;
+	int			error;
+
+	lock = xfs_ilock_map_shared(ip);
+
+	if (start >= isize) {
+		error = ENXIO;
+		goto out_lock;
+	}
+
+	fsbno = XFS_B_TO_FSBT(mp, start);
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	len = XFS_B_TO_FSB(mp, isize);
+
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+		loff_t			seekoff;
+
+		error = xfs_bmapi_read(ip, fsbno, len - fsbno, map, &nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			goto out_lock;
+
+		/* No extents at given offset, must be beyond EOF */
+		if (!nmap) {
+			error = ENXIO;
+			goto out_lock;
+		}
+
+		seekoff = XFS_FSB_TO_B(mp, fsbno);
+
+		/*
+		 * Landed in an unwritten extent, try to lookup the page cache
+		 * firstly. It should be treated as a hole if no data buffer
+		 * found. Otherwise, go through the next extent to fetch holes.
+		 */
+		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
+			if (!xfs_has_unwritten_buffer(inode, &map[0],
+						      0, NULL)) {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[0].br_startoff));
+				break;
+			}
+
+			/*
+			 * No more extent at the given offst, return the total
+			 * file size.
+			 */
+			if (nmap == 1) {
+				offset = isize;
+				break;
+			}
+
+			if (map[1].br_startblock == HOLESTARTBLOCK) {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
+				if (!xfs_has_unwritten_buffer(inode, &map[1],
+							      0, NULL)) {
+					offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+					break;
+				}
+			}
+
+			fsbno = map[1].br_startoff + map[1].br_blockcount;
+		}
+
+		/*
+		 * Landed in a delay allocated extent or a real data extent,
+		 * continue to check the next extent if it is there. if the
+		 * next extent is landed in a hole or in an unwritten extent
+		 * but without data committed in the page cache, return its
+		 * offset.
+		 */
+		if (map[0].br_startblock == DELAYSTARTBLOCK ||
+		    map[0].br_state == XFS_EXT_NORM) {
+			/*
+			 * No more extent at the give offset, return the
+			 * total file size.
+			 */
+			if (nmap == 1) {
+				offset = isize;
+				break;
+			}
+
+			if (map[1].br_startblock == HOLESTARTBLOCK) {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
+				if (!xfs_has_unwritten_buffer(inode, &map[1],
+							      0, NULL)) {
+					offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+					break;
+				}
+			}
+
+			fsbno = map[1].br_startoff + map[1].br_blockcount;
+		}
+
+		/* Landed in a hole, its fine to return */
+		if (map[0].br_startblock == HOLESTARTBLOCK) {
+			offset = max_t(loff_t, seekoff,
+				       XFS_FSB_TO_B(mp, map[0].br_startoff));
+			break;
+		}
+
+		/* Return ENXIO if beyond eof */
+		if (XFS_FSB_TO_B(mp, fsbno) > isize) {
+			error = ENXIO;
+			goto out_lock;
+		}
+	}
+
+	if (offset < start)
+		offset = start;
+
+	if (offset != file->f_pos)
+		file->f_pos = offset;
+
+out_lock:
+	xfs_iunlock_map_shared(ip, lock);
+
+	if (error)
+		return -error;
+
+	return offset;
+}
+
+STATIC loff_t
+xfs_file_llseek(
+	struct file	*file,
+	loff_t		offset,
+	int		origin)
+{
+	switch (origin) {
+	case SEEK_END:
+	case SEEK_CUR:
+	case SEEK_SET:
+		return generic_file_llseek(file, offset, origin);
+	case SEEK_DATA:
+		return xfs_seek_data(file, offset);
+	case SEEK_HOLE:
+		return xfs_seek_hole(file, offset);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 const struct file_operations xfs_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= xfs_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= xfs_file_aio_read,
-- 
1.7.4.1

	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
