Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o241jDDx126511 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 19:45:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE3BD13F1809
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 17:46:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	jlfa8RIgKfHPoOfc for <xfs@oss.sgi.com>;
	Wed, 03 Mar 2010 17:46:38 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15676391-1927428
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 12:16:37 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1Nn095-0004aU-P7
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:46:35 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nn08y-000232-4w
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:46:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: truncate delalloc extents when IO fails in writeback
Date: Thu,  4 Mar 2010 12:46:24 +1100
Message-Id: <1267667185-7736-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1267667185-7736-1-git-send-email-david@fromorbit.com>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

We currently use block_invalidatepage() to clean up pages where I/O
fails in ->writepage(). Unfortunately, if the page has delalloc
regions on it, we fail to remove the delalloc regions when we
invalidate the page.  This can result in tripping a BUG() in
xfs_get_blocks() later on if a direct IO read is done on that same
region - the delalloc extent is returned when none is supposed to be
there.

Fix this by truncating away the delalloc regions on the page before
invalidating it. Because they are delalloc, we can do this without
needing a transaction. Indeed - if we get ENOSPC errors, we have to
be able to do this truncation without a transaction as there is
no space left for block reservation (typically why we see a ENOSPC
in writeback).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |  106 +++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_bmap.c           |    6 ++-
 2 files changed, 100 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index b493c63..65360b5 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -39,6 +39,7 @@
 #include "xfs_iomap.h"
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
+#include "xfs_bmap.h"
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
@@ -893,6 +894,100 @@ xfs_cluster_write(
 	}
 }
 
+STATIC void
+xfs_vm_invalidatepage(
+	struct page		*page,
+	unsigned long		offset)
+{
+	trace_xfs_invalidatepage(page->mapping->host, page, offset);
+	block_invalidatepage(page, offset);
+}
+
+/*
+ * If the page has delalloc buffers on it, we need to punch them out before we
+ * invalidate the page. If we don't, we leave a stale delalloc mapping on the
+ * inode that we can trip over later.
+ *
+ * This is not a performance critical path, so for now just do the punching a
+ * buffer head at a time.
+ */
+static void
+xfs_aops_discard_page(
+	struct page		*page)
+{
+	struct inode		*inode = page->mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct buffer_head	*bh, *head;
+	loff_t			offset = page_offset(page);
+	ssize_t			len = 1 << inode->i_blkbits;
+
+	if (!xfs_is_delayed_page(page, IOMAP_DELAY))
+		goto out_invalidate;
+
+	xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+		"page discard on page %p, inode 0x%llx, offset %llu.",
+			page, ip->i_ino, offset);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	bh = head = page_buffers(page);
+	do {
+		int		done;
+		xfs_fileoff_t	offset_fsb;
+		xfs_bmbt_irec_t	imap;
+		int		nimaps = 1;
+		int		error;
+
+		if (!buffer_delay(bh))
+			goto next_buffer;
+
+		offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+
+		/*
+		 * Map the range first and check that it is a delalloc extent
+		 * before trying to unmap the range. Otherwise we will be
+		 * trying to remove a real extent (which requires a
+		 * transaction) or a hole, which is probably a bad idea...
+		 */
+		error = xfs_bmapi(NULL, ip, offset_fsb, 1,
+				XFS_BMAPI_ENTIRE,  NULL, 0, &imap,
+				&nimaps, NULL, NULL);
+
+		if (error) {
+			/* something screwed, just bail */
+			xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+			"page discard failed delalloc mapping lookup.");
+			break;
+		}
+		if (!nimaps) {
+			/* nothing there */
+			goto next_buffer;
+		}
+		if (imap.br_startblock != DELAYSTARTBLOCK) {
+			/* been converted, ignore */
+			goto next_buffer;
+		}
+		WARN_ON(imap.br_blockcount == 0);
+
+		error = xfs_bunmapi(NULL, ip, offset_fsb, 1, 0, 1, NULL,
+					NULL, NULL, &done);
+
+		if (error) {
+			/* something screwed, just bail */
+			xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+			"page discard unable to remove delalloc mapping.");
+			break;
+		}
+next_buffer:
+		offset += len;
+
+	} while ((bh = bh->b_this_page) != head);
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out_invalidate:
+	xfs_vm_invalidatepage(page, 0);
+	return;
+}
+
 /*
  * Calling this without startio set means we are being asked to make a dirty
  * page ready for freeing it's buffers.  When called with startio set then
@@ -1144,7 +1239,7 @@ error:
 	 */
 	if (err != -EAGAIN) {
 		if (!unmapped)
-			block_invalidatepage(page, 0);
+			xfs_aops_discard_page(page);
 		ClearPageUptodate(page);
 	}
 	return err;
@@ -1554,15 +1649,6 @@ xfs_vm_readpages(
 	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
 }
 
-STATIC void
-xfs_vm_invalidatepage(
-	struct page		*page,
-	unsigned long		offset)
-{
-	trace_xfs_invalidatepage(page->mapping->host, page, offset);
-	block_invalidatepage(page, offset);
-}
-
 const struct address_space_operations xfs_address_space_operations = {
 	.readpage		= xfs_vm_readpage,
 	.readpages		= xfs_vm_readpages,
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 95a4813..7afd475 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5218,7 +5218,8 @@ xfs_bunmapi(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = *firstblock;
+		cur->bc_private.b.firstblock = firstblock ?
+						*firstblock : NULLFSBLOCK;
 		cur->bc_private.b.flist = flist;
 		cur->bc_private.b.flags = 0;
 	} else
@@ -5503,7 +5504,8 @@ error0:
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (cur) {
 		if (!error) {
-			*firstblock = cur->bc_private.b.firstblock;
+			if (firstblock)
+				*firstblock = cur->bc_private.b.firstblock;
 			cur->bc_private.b.allocated = 0;
 		}
 		xfs_btree_del_cursor(cur,
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
