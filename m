Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q637GQBG066811 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 02:16:26 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id 5gNtKxOAoI79GHMI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 00:16:25 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q637GMmB021307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 07:16:23 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q637GMEq003083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 07:16:22 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q637GLbB025239 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 02:16:21 -0500
Message-ID: <4FF29C2C.2000407@oracle.com>
Date: Tue, 03 Jul 2012 15:15:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3] xfs: probe data buffer from page cache for unwritten
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

This is v3 of the patch.

We can trigger BUG() in xfs_seek_data() if met two unwritten without data or hole extents at last version.
So making the extents map reading in loop could solve it.

Sorry, Am not yet try the repeated holes scenario according to Dave's comments as lack of X64 test env, still
waiting for it ready.  But this patch is already too long delayed, I have worked it out one weeks ago.
So I'd like to post it because of it could handle repeated hole/unwritten extents well in a loop, and I also improved
xfstests:286 with those cases for the verification, will post it soon.

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

---
 fs/xfs/xfs_file.c |  197 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 178 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9f7ec15..a8821c1 100644
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
@@ -975,8 +1078,6 @@ xfs_seek_data(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	map[2];
-	int			nmap = 2;
 	loff_t			uninitialized_var(offset);
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
@@ -992,36 +1093,94 @@ xfs_seek_data(
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
 
-		offset = max_t(loff_t, start,
-			       XFS_FSB_TO_B(mp, map[1].br_startoff));
+		offset = start;
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
+					goto out;
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
+
+			if (map[1].br_state == XFS_EXT_NORM &&
+			    !isnullstartblock(map[1].br_startblock))
+				goto out;
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
+						goto out;
+				}
+			}
+		}
+
+		/*
+		 * Nothing was found, proceed to the next round of search if
+		 * reading offset not beyond EOF.
+		 */
+		fsbno = map[1].br_startoff + map[1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start > isize) {
+			error = ENXIO;
+			goto out_unlock;
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
