Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7L9CpEM060215 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 04:12:51 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id waoAfBB71tCnyEeY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Aug 2012 02:12:50 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q7L9Cmmp026158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 09:12:49 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q7L9ClS6004853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 09:12:48 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q7L9ClXZ006509 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 04:12:47 -0500
Message-ID: <503350DD.6030503@oracle.com>
Date: Tue, 21 Aug 2012 17:11:57 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v8 2/4] xfs: Introduce a helper routine to probe data or hole
	offset from page cache
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

Introduce helpers to probe data or hole offset from page cache.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |  219 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 219 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 92ba18f..d78a746 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
+#include <linux/pagevec.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -959,6 +960,224 @@ xfs_vm_page_mkwrite(
 	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
 }
 
+/*
+ * This type is designed to indicate the type of offset we would like
+ * to search from page cache for either xfs_seek_data() or xfs_seek_hole().
+ */
+enum {
+	HOLE_OFF = 0,
+	DATA_OFF,
+};
+
+/*
+ * Lookup the desired type of offset from the given page.
+ *
+ * On success, return true and the offset argument will point to the
+ * start of the region that was found.  Otherwise this function will
+ * return false and keep the offset argument unchanged.
+ */
+STATIC bool
+xfs_lookup_buffer_offset(
+	struct page		*page,
+	loff_t			*offset,
+	unsigned int		type)
+{
+	loff_t			lastoff = page_offset(page);
+	bool			found = false;
+	struct buffer_head	*bh, *head;
+
+	bh = head = page_buffers(page);
+	do {
+		/*
+		 * Unwritten extents that have data in the page
+		 * cache covering them can be identified by the
+		 * BH_Unwritten state flag.  Pages with multiple
+		 * buffers might have a mix of holes, data and
+		 * unwritten extents - any buffer with valid
+		 * data in it should have BH_Uptodate flag set
+		 * on it.
+		 */
+		if (buffer_unwritten(bh) ||
+		    buffer_uptodate(bh)) {
+			if (type == DATA_OFF)
+				found = true;
+		} else {
+			if (type == HOLE_OFF)
+				found = true;
+		}
+
+		if (found) {
+			*offset = lastoff;
+			break;
+		}
+		lastoff += bh->b_size;
+	} while ((bh = bh->b_this_page) != head);
+
+	return found;
+}
+
+/*
+ * This routine is called to find out and return a data or hole offset
+ * from the page cache for unwritten extents according to the desired
+ * type for xfs_seek_data() or xfs_seek_hole().
+ *
+ * The argument offset is used to tell where we start to search from the
+ * page cache.  Map is used to figure out the end points of the range to
+ * lookup pages.
+ *
+ * Return true if the desired type of offset was found, and the argument
+ * offset is filled with that address.  Otherwise, return false and keep
+ * offset unchanged.
+ */
+STATIC bool
+xfs_find_get_desired_pgoff(
+	struct inode		*inode,
+	struct xfs_bmbt_irec	*map,
+	unsigned int		type,
+	loff_t			*offset)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct pagevec		pvec;
+	pgoff_t			index;
+	pgoff_t			end;
+	loff_t			endoff;
+	loff_t			startoff = *offset;
+	loff_t			lastoff = startoff;
+	bool			found = false;
+
+	pagevec_init(&pvec, 0);
+
+	index = startoff >> PAGE_CACHE_SHIFT;
+	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
+	end = endoff >> PAGE_CACHE_SHIFT;
+	do {
+		int		want;
+		unsigned	nr_pages;
+		unsigned int	i;
+
+		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
+					  want);
+		/*
+		 * No page mapped into given range.  If we are searching holes
+		 * and if this is the first time we got into the loop, it means
+		 * that the given offset is landed in a hole, return it.
+		 *
+		 * If we have already stepped through some block buffers to find
+		 * holes but they all contains data.  In this case, the last
+		 * offset is already updated and pointed to the end of the last
+		 * mapped page, if it does not reach the endpoint to search,
+		 * that means there should be a hole between them.
+		 */
+		if (nr_pages == 0) {
+			/* Data search found nothing */
+			if (type == DATA_OFF)
+				break;
+
+			ASSERT(type == HOLE_OFF);
+			if (lastoff == startoff || lastoff < endoff) {
+				found = true;
+				*offset = lastoff;
+			}
+			break;
+		}
+
+		/*
+		 * At lease we found one page.  If this is the first time we
+		 * step into the loop, and if the first page index offset is
+		 * greater than the given search offset, a hole was found.
+		 */
+		if (type == HOLE_OFF && lastoff == startoff &&
+		    lastoff < page_offset(pvec.pages[0])) {
+			found = true;
+			break;
+		}
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page	*page = pvec.pages[i];
+			loff_t		b_offset;
+
+			/*
+			 * At this point, the page may be truncated or
+			 * invalidated (changing page->mapping to NULL),
+			 * or even swizzled back from swapper_space to tmpfs
+			 * file mapping. However, page->index will not change
+			 * because we have a reference on the page.
+			 *
+			 * Searching done if the page index is out of range.
+			 * If the current offset is not reaches the end of
+			 * the specified search range, there should be a hole
+			 * between them.
+			 */
+			if (page->index > end) {
+				if (type == HOLE_OFF && lastoff < endoff) {
+					*offset = lastoff;
+					found = true;
+				}
+				goto out;
+			}
+
+			lock_page(page);
+			/*
+			 * Page truncated or invalidated(page->mapping == NULL).
+			 * We can freely skip it and proceed to check the next
+			 * page.
+			 */
+			if (unlikely(page->mapping != inode->i_mapping)) {
+				unlock_page(page);
+				continue;
+			}
+
+			if (!page_has_buffers(page)) {
+				unlock_page(page);
+				continue;
+			}
+
+			found = xfs_lookup_buffer_offset(page, &b_offset, type);
+			if (found) {
+				/*
+				 * The found offset may be less than the start
+				 * point to search if this is the first time to
+				 * come here.
+				 */
+				*offset = max_t(loff_t, startoff, b_offset);
+				unlock_page(page);
+				goto out;
+			}
+
+			/*
+			 * We either searching data but nothing was found, or
+			 * searching hole but found a data buffer.  In either
+			 * case, probably the next page contains the desired
+			 * things, update the last offset to it so.
+			 */
+			lastoff = page_offset(page) + PAGE_SIZE;
+			unlock_page(page);
+		}
+
+		/*
+		 * The number of returned pages less than our desired, search
+		 * done.  In this case, nothing was found for searching data,
+		 * but we found a hole behind the last offset.
+		 */
+		if (nr_pages < want) {
+			if (type == HOLE_OFF) {
+				*offset = lastoff;
+				found = true;
+			}
+			break;
+		}
+
+		index = pvec.pages[i - 1]->index + 1;
+		pagevec_release(&pvec);
+	} while (index <= end);
+
+out:
+	pagevec_release(&pvec);
+	return found;
+}
+
 STATIC loff_t
 xfs_seek_data(
 	struct file		*file,
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
