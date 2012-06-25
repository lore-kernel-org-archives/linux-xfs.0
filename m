Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5PCfxjG239561 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 07:41:59 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id KNAGnGg186HOGAch (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Jun 2012 05:41:57 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q5PCfu0f029365
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 12:41:57 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q5PCftOi013663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 12:41:56 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q5PCftvN017605 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 07:41:55 -0500
Message-ID: <4FE85C7B.3010909@oracle.com>
Date: Mon, 25 Jun 2012 20:41:31 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfs: probe data buffer from page cache for unwritten
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

Hello,

Using the start offset rather than map->br_startoff to calculate the starting page index could
get more accurate data offset in page cache probe routine.
With this refinement, the old max_t() could be able to remove too. 

Thanks Mark for pointing this out!

-Jeff


Cc: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 150 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9f7ec15..113190b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
+#include <linux/pagevec.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -966,6 +967,108 @@ xfs_vm_page_mkwrite(
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
+				if ((buffer_unwritten(bh) ||
+				     buffer_uptodate(bh)) &&
+				     *offset <= XFS_FSB_TO_B(mp, last)) {
+					found = true;
+					*offset = XFS_FSB_TO_B(mp, last);
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
+	if (!found)
+		*offset = 0;
+
+	return found;
+}
+
 STATIC loff_t
 xfs_seek_data(
 	struct file		*file,
@@ -1009,19 +1112,61 @@ xfs_seek_data(
 	 * Treat unwritten extent as data extent since it might
 	 * contains dirty data in page cache.
 	 */
-	if (map[0].br_startblock != HOLESTARTBLOCK) {
-		offset = max_t(loff_t, start,
-			       XFS_FSB_TO_B(mp, map[0].br_startoff));
+	if (map[0].br_state == XFS_EXT_NORM &&
+	    !isnullstartblock(map[0].br_startblock)) {
+		offset = start;
 	} else {
+		/*
+		 * Landed in an unwritten extent, try to find out
+		 * the data buffer offset from page cache firstly.
+		 * Treat it as a hole if nothing was found, and
+		 * skip to check the next extent.
+		 */
+		if (map[0].br_startblock == DELAYSTARTBLOCK ||
+		    map[0].br_state == XFS_EXT_UNWRITTEN) {
+			/* Probing page cache start from offset */
+			offset = start;
+			if (xfs_has_unwritten_buffer(inode, &map[0],
+						     &offset))
+				goto out;
+		}
+
+		/*
+		 * Found a hole in map[0] and nothing in map[1].
+		 * Probably means that we are reading after EOF.
+		 */
 		if (nmap == 1) {
 			error = ENXIO;
 			goto out_unlock;
 		}
 
-		offset = max_t(loff_t, start,
-			       XFS_FSB_TO_B(mp, map[1].br_startoff));
+		/*
+		 * We have two mappings, and need to check map[1] to
+		 * see if there is data or not.
+		 */
+		if (map[1].br_state == XFS_EXT_NORM &&
+		    !isnullstartblock(map[1].br_startblock)) {
+			offset = XFS_FSB_TO_B(mp, map[1].br_startoff);
+		} else {
+			if (map[1].br_startblock == DELAYSTARTBLOCK ||
+			    map[1].br_state == XFS_EXT_UNWRITTEN) {
+				/* Probing page cache start from offset */
+				offset = start;
+				if (xfs_has_unwritten_buffer(inode, &map[1],
+							     &offset))
+					goto out;
+			}
+			/*
+			 * xfs_bmapi_read() can handle repeated hole regions,
+			 * hence it should not return two extents both are
+			 * holes.  If the 2nd extent is unwritten, there must
+			 * have data buffer resides in page cache.
+			 */
+			BUG();
+		}
 	}
 
+out:
 	if (offset != file->f_pos)
 		file->f_pos = offset;
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
