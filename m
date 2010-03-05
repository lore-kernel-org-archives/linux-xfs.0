Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o251xJ0J213621 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 19:59:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C8AE1D1665C
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 18:00:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	tyYMRBNFmFHKTAUq for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 18:00:45 -0800 (PST)
Date: Fri, 5 Mar 2010 13:00:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: truncate delalloc extents when IO fails in writeback
Message-ID: <20100305020042.GM14317@discord.disaster>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-3-git-send-email-david@fromorbit.com>
	<20100304142851.GA19157@infradead.org>
	<20100304220309.GI14317@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100304220309.GI14317@discord.disaster>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


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
 fs/xfs/linux-2.6/xfs_aops.c |  124 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index b493c63..e0eb7f1 100644
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
@@ -893,6 +894,118 @@ xfs_cluster_write(
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
+ * inode that can trip a BUG() in xfs_get_blocks() later on if a direct IO read
+ * is done on that same region - the delalloc extent is returned when none is
+ * supposed to be there.
+ *
+ * We prevent this by truncating away the delalloc regions on the page before
+ * invalidating it. Because they are delalloc, we can do this without needing a
+ * transaction. Indeed - if we get ENOSPC errors, we have to be able to do this
+ * truncation without a transaction as there is no space left for block
+ * reservation (typically why we see a ENOSPC in writeback).
+ *
+ * This is not a performance critical path, so for now just do the punching a
+ * buffer head at a time.
+ */
+STATIC void
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
+		xfs_fsblock_t	firstblock;
+		xfs_bmap_free_t flist;
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
+		/*
+		 * Note: while we initialise the firstblock/flist pair, they
+		 * should never be used because blocks shoul dnever be
+		 * allocated or freed for a delalloc extent and hence we need
+		 * don't cancel or finish them after the xfs_bunmapi() call.
+		 */
+		xfs_bmap_init(&flist, &firstblock);
+		error = xfs_bunmapi(NULL, ip, offset_fsb, 1, 0, 1, &firstblock,
+					&flist, NULL, &done);
+
+		ASSERT(!flist.xbf_count && !flist.xbf_first);
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
@@ -1144,7 +1257,7 @@ error:
 	 */
 	if (err != -EAGAIN) {
 		if (!unmapped)
-			block_invalidatepage(page, 0);
+			xfs_aops_discard_page(page);
 		ClearPageUptodate(page);
 	}
 	return err;
@@ -1554,15 +1667,6 @@ xfs_vm_readpages(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
