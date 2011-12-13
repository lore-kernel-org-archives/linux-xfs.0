Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDF3Sm6159139 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 09:03:29 -0600
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F8589FBAAC
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 07:03:27 -0800 (PST)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id KQ37XFzxfVGWdtdN for
	<xfs@oss.sgi.com>; Tue, 13 Dec 2011 07:03:27 -0800 (PST)
Message-ID: <4EE7691D.6040807@oracle.com>
Date: Tue, 13 Dec 2011 23:02:53 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] Introduce SEEK_DATA/SEEK_HOLE  to XFS V3
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

Now the V3 was coming out.

Major changes:
==============
1. Isolate SEEK_DATA/SEEK_HOLE to individual functions, call them directly from
xfs_llseek().
2. Probing page cache for unwritten extents.

Tests:
======
1. General tests I have mentioned before.
2. Cover look up DIRTY pages through fallocate(2).

The issue is I have not yet successfully worked out a test case can cover look up WRITEBACK pages easily,
I'll continue to try out some other methods in this case.
In the meantime, I'd like to post the revised patch for your guys review, to make sure that there is no
obvious mistake in my current implementation, especially for the page cache look up approach.

Also, I took care of the function parameters and variables in TAB-align code style this time, for variables
defined at conditions code blocks(i.e, "{}"), I also adhere to this rule, but not sure if it is properly, since I
found some code snippets in xfs_file.c does not defined in this way.

Thank you!
-Jeff

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |  308 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 307 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 753ed9b..1e9d6be 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -38,6 +38,7 @@
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
+#include <linux/pagevec.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1141,8 +1142,313 @@ xfs_vm_page_mkwrite(
 	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
 }
 
+/*
+ * Try to find out the data buffer offset in page cache for unwritten
+ * extents. Firstly, try to probe the DIRTY pages in current extent range,
+ * and iterate each page to lookup all theirs data buffers, if a buffer
+ * head status is unwritten, return its offset. If there is no DIRTY pages
+ * found or lookup done, we need to lookup the WRITEBACK pages again and
+ * perform the same operation as previously to avoid data loss.
+ */
+STATIC loff_t
+xfs_probe_unwritten_buffer(
+	struct inode		*inode,
+	struct xfs_bmbt_irec	*map,
+	int			*found)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct pagevec		pvec;
+	pgoff_t			index;
+	pgoff_t			end;
+	loff_t			offset = 0;
+	int			tag = PAGECACHE_TAG_DIRTY;
+
+	pagevec_init(&pvec, 0);
+
+probe_writeback_pages:
+	index = XFS_FSB_TO_B(mp, map->br_startoff) >> PAGE_CACHE_SHIFT;
+	end = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount)
+			   >> PAGE_CACHE_SHIFT;
+
+	do {
+		unsigned	nr_pages;
+		unsigned int	i;
+		int		want = min_t(pgoff_t, end - index,
+					     PAGEVEC_SIZE - 1) + 1;
+		nr_pages = pagevec_lookup_tag(&pvec, inode->i_mapping,
+					      &index, tag, want);
+		if (nr_pages == 0) {
+			/*
+			 * No dirty pages returns for this extent, try
+			 * to lookup the writeback pages again.
+			 * FIXME: If this is the first time for probing
+			 * DIRTY pages but nothing returned, we need to
+			 * search the WRITEBACK pages from the extent
+			 * beginning offset, but if we have found out
+			 * some DIRTY pages before, maybe we should
+			 * continue to probe the WRITEBACK pages from
+			 * the current page index rather than beginning?
+			 */
+			if (tag == PAGECACHE_TAG_DIRTY) {
+				tag = PAGECACHE_TAG_WRITEBACK;
+				goto probe_writeback_pages;
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
+				goto out;
+
+			last = XFS_B_TO_FSBT(mp,
+					     page->index << PAGE_CACHE_SHIFT);
+			bh = head = page_buffers(page);
+			do {
+				/*
+				 * In XFS, if an extent in XFS_EXT_UNWRITTEN
+				 * state, that means the disk blocks were
+				 * already mapped for it, but the data is
+				 * still lived at page caches. For buffers
+				 * resides at DIRTY pages, their BH state
+				 * should be in (dirty && mapped && unwritten
+				 * && uptodate) status. For buffers resides
+				 * at WRITEBACK pages, their BH state should
+				 * be in (mapped && unwritten && uptodate)
+				 * status. So we only need to check unwritten
+				 * buffer status here.
+				 */
+				if (buffer_unwritten(bh)) {
+					offset = XFS_FSB_TO_B(mp, last);
+					*found = 1;
+					goto out;
+				}
+				last++;
+			} while ((bh = bh->b_this_page) != head);
+		}
+
+		index = pvec.pages[i]->index + 1;
+		pagevec_release(&pvec);
+	} while (index < end);
+
+out:
+	pagevec_release(&pvec);
+	return offset;
+}
+
+STATIC loff_t
+xfs_seek_data(
+	struct file		*file,
+	loff_t			start,
+	u32			type)
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
+	if (start >= isize)
+		return -ENXIO;
+
+	lock = xfs_ilock_map_shared(ip);
+
+	fsbno = XFS_B_TO_FSBT(mp, start);
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	len = XFS_B_TO_FSB(mp, isize);
+
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+		int			found = 0;
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
+		/*
+		 * Landed in a hole, skip to check the next extent.
+		 * If the next extent landed in an in-memory data extent,
+		 * or it is a normal extent, its fine to return.
+		 * If the next extent landed in a hole extent, calculate
+		 * the start file system block number for next bmapi read.
+		 * If the next extent landed in an unwritten extent, we
+		 * need to probe the page cache to find out the data buffer
+		 * offset, if nothing found, treat it as a hole extent too.
+		 */
+		if (map[0].br_startblock == HOLESTARTBLOCK) {
+			if (map[1].br_startblock == HOLESTARTBLOCK) {
+				fsbno = map[1].br_startoff +
+					map[1].br_blockcount;
+			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
+				offset = xfs_probe_unwritten_buffer(inode,
+								    &map[1],
+								    &found);
+				if (found) {
+					offset = max_t(loff_t, seekoff, offset);
+					break;
+				}
+				/*
+				 * No data buffer found in pagecache, treate it
+				 * as a hole.
+				 */
+				fsbno = map[1].br_startoff +
+					map[1].br_blockcount;
+			} else {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			}
+		}
+
+		/*
+		 * Landed in an unwritten extent, try to find out the data
+		 * buffer offset from page cache firstly. if nothing was
+		 * found, treat it as a hole, and skip to check the next
+		 * extent, something just like above.
+		 */
+		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
+			offset = xfs_probe_unwritten_buffer(inode, &map[0],
+							    &found);
+			if (found) {
+				offset = max_t(loff_t, seekoff, offset);
+				break;
+			}
+			if (map[1].br_startblock == HOLESTARTBLOCK) {
+				fsbno = map[1].br_startoff +
+					map[1].br_blockcount;
+			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
+				offset = xfs_probe_unwritten_buffer(inode,
+								    &map[1],
+								    &found);
+				if (found) {
+					offset = max_t(loff_t, seekoff,
+						       offset);
+					break;
+				}
+				fsbno = map[1].br_startoff +
+					map[1].br_blockcount;
+			} else {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			}
+		}
+
+		/* Landed in a delay allocated extent or a read data extent */
+		if (map[0].br_startblock == DELAYSTARTBLOCK ||
+		    map[0].br_state == XFS_EXT_NORM) {
+			offset = max_t(loff_t, seekoff,
+				       XFS_FSB_TO_B(mp, map[0].br_startoff));
+			break;
+		}
+
+		/* return ENXIO if beyond eof */
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
+	loff_t			start,
+	u32			type)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fsize_t		isize = i_size_read(inode);
+	xfs_fileoff_t		fsbno;
+	loff_t			holeoff;
+	loff_t			offset = 0;
+	int			lock;
+	int			error;
+
+	if (start >= isize)
+		return -ENXIO;
+
+	lock = xfs_ilock_map_shared(ip);
+
+	fsbno = XFS_B_TO_FSBT(mp, start);
+	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
+	if (error)
+		goto out_lock;
+
+	holeoff = XFS_FSB_TO_B(mp, fsbno);
+	if (holeoff <= start)
+		offset = start;
+	else
+		offset = min_t(loff_t, holeoff, isize);
+
+	if (offset != file->f_pos)
+		file->f_pos = offset;
+
+out_lock:
+	xfs_iunlock_map_shared(ip, lock);
+
+	if (error)
+		return -error;
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
+		return xfs_seek_data(file, offset, origin);
+	case SEEK_HOLE:
+		return xfs_seek_hole(file, offset, origin);
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
