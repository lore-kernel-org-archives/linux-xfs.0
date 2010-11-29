Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT0J6hd069770 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 18:19:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 165241AF6E8
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:20:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	0mbpXAQHApswOaLY for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:20:46 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48198113-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 10:50:45 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMrU3-0000VW-N7
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:20:43 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMrTo-00049d-HH
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:20:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: fix failed write truncation handling.
Date: Mon, 29 Nov 2010 11:20:20 +1100
Message-Id: <1290990024-15898-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1290990024-15898-1-git-send-email-david@fromorbit.com>
References: <1290990024-15898-1-git-send-email-david@fromorbit.com>
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

Since the move to the new truncate sequence we call xfs_setattr to
truncate down excessively instanciated blocks.  As shown by the testcase
in kernel.org BZ #22452 that doesn't work too well.  Due to the confusion
of the internal inode size, and the VFS inode i_size it zeroes data that
it shouldn't.

But full blown truncate seems like overkill here.  We only instanciate
delayed allocations in the write path, and given that we never released
the iolock we can't have converted them to real allocations yet either.

The only nasty case is pre-existing preallocation which we need to skip.
We already do this for page discard during writeback, so make the delayed
allocation block punching a generic function and call it from the failed
write path as well as xfs_aops_discard_page. The callers are
responsible for ensuring that partial blocks are not truncated away,
and that they hold the ilock.

Based on a fix originally from Christoph Hellwig. This version used
filesystem blocks as the range unit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_aops.c |   94 ++++++++++++++++++------------------------
 fs/xfs/xfs_bmap.c           |   76 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap.h           |    5 ++
 3 files changed, 121 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 7d287af..691f612 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -934,7 +934,6 @@ xfs_aops_discard_page(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct buffer_head	*bh, *head;
 	loff_t			offset = page_offset(page);
-	ssize_t			len = 1 << inode->i_blkbits;
 
 	if (!xfs_is_delayed_page(page, IO_DELAY))
 		goto out_invalidate;
@@ -949,58 +948,14 @@ xfs_aops_discard_page(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	bh = head = page_buffers(page);
 	do {
-		int		done;
-		xfs_fileoff_t	offset_fsb;
-		xfs_bmbt_irec_t	imap;
-		int		nimaps = 1;
 		int		error;
-		xfs_fsblock_t	firstblock;
-		xfs_bmap_free_t flist;
+		xfs_fileoff_t	start_fsb;
 
 		if (!buffer_delay(bh))
 			goto next_buffer;
 
-		offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
-
-		/*
-		 * Map the range first and check that it is a delalloc extent
-		 * before trying to unmap the range. Otherwise we will be
-		 * trying to remove a real extent (which requires a
-		 * transaction) or a hole, which is probably a bad idea...
-		 */
-		error = xfs_bmapi(NULL, ip, offset_fsb, 1,
-				XFS_BMAPI_ENTIRE,  NULL, 0, &imap,
-				&nimaps, NULL);
-
-		if (error) {
-			/* something screwed, just bail */
-			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
-				"page discard failed delalloc mapping lookup.");
-			}
-			break;
-		}
-		if (!nimaps) {
-			/* nothing there */
-			goto next_buffer;
-		}
-		if (imap.br_startblock != DELAYSTARTBLOCK) {
-			/* been converted, ignore */
-			goto next_buffer;
-		}
-		WARN_ON(imap.br_blockcount == 0);
-
-		/*
-		 * Note: while we initialise the firstblock/flist pair, they
-		 * should never be used because blocks should never be
-		 * allocated or freed for a delalloc extent and hence we need
-		 * don't cancel or finish them after the xfs_bunmapi() call.
-		 */
-		xfs_bmap_init(&flist, &firstblock);
-		error = xfs_bunmapi(NULL, ip, offset_fsb, 1, 0, 1, &firstblock,
-					&flist, &done);
-
-		ASSERT(!flist.xbf_count && !flist.xbf_first);
+		start_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+		error = xfs_bmap_punch_delalloc_range(ip, start_fsb, 1);
 		if (error) {
 			/* something screwed, just bail */
 			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
@@ -1010,7 +965,7 @@ xfs_aops_discard_page(
 			break;
 		}
 next_buffer:
-		offset += len;
+		offset += 1 << inode->i_blkbits;
 
 	} while ((bh = bh->b_this_page) != head);
 
@@ -1505,11 +1460,42 @@ xfs_vm_write_failed(
 	struct inode		*inode = mapping->host;
 
 	if (to > inode->i_size) {
-		struct iattr	ia = {
-			.ia_valid	= ATTR_SIZE | ATTR_FORCE,
-			.ia_size	= inode->i_size,
-		};
-		xfs_setattr(XFS_I(inode), &ia, XFS_ATTR_NOLOCK);
+		/*
+		 * punch out the delalloc blocks we have already allocated. We
+		 * don't call xfs_setattr() to do this as we may be in the
+		 * middle of a multi-iovec write and so the vfs inode->i_size
+		 * will not match the xfs ip->i_size and so it will zero too
+		 * much. Hence we jus truncate the page cache to zero what is
+		 * necessary and punch the delalloc blocks directly.
+		 */
+		struct xfs_inode	*ip = XFS_I(inode);
+		xfs_fileoff_t		start_fsb;
+		xfs_fileoff_t		end_fsb;
+		int			error;
+
+		truncate_pagecache(inode, to, inode->i_size);
+
+		/*
+		 * Check if there are any blocks that are outside of i_size
+		 * that need to be trimmed back.
+		 */
+		start_fsb = XFS_B_TO_FSB(ip->i_mount, inode->i_size) + 1;
+		end_fsb = XFS_B_TO_FSB(ip->i_mount, to);
+		if (end_fsb <= start_fsb)
+			return;
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+							end_fsb - start_fsb);
+		if (error) {
+			/* something screwed, just bail */
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+			"xfs_vm_write_failed: unable to clean up ino %lld",
+						ip->i_ino);
+			}
+		}
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 }
 
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 8abd12e..08b179f 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6070,3 +6070,79 @@ xfs_bmap_disk_count_leaves(
 		*count += xfs_bmbt_disk_get_blockcount(frp);
 	}
 }
+
+/*
+ * dead simple method of punching delalyed allocation blocks from a range in
+ * the inode. Walks a block at a time so will be slow, but is only executed in
+ * rare error cases so the overhead is not critical. This will alays punch out
+ * both the start and end blocks, even if the ranges only partially overlap
+ * them, so it is up to the caller to ensure that partial blocks are not
+ * passed in.
+ */
+int
+xfs_bmap_punch_delalloc_range(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		length)
+{
+	xfs_fileoff_t		remaining = length;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	do {
+		int		done;
+		xfs_bmbt_irec_t	imap;
+		int		nimaps = 1;
+		xfs_fsblock_t	firstblock;
+		xfs_bmap_free_t flist;
+
+		/*
+		 * Map the range first and check that it is a delalloc extent
+		 * before trying to unmap the range. Otherwise we will be
+		 * trying to remove a real extent (which requires a
+		 * transaction) or a hole, which is probably a bad idea...
+		 */
+		error = xfs_bmapi(NULL, ip, start_fsb, 1,
+				XFS_BMAPI_ENTIRE,  NULL, 0, &imap,
+				&nimaps, NULL);
+
+		if (error) {
+			/* something screwed, just bail */
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+			"Failed delalloc mapping lookup ino %lld fsb %lld.",
+						ip->i_ino, start_fsb);
+			}
+			break;
+		}
+		if (!nimaps) {
+			/* nothing there */
+			goto next_block;
+		}
+		if (imap.br_startblock != DELAYSTARTBLOCK) {
+			/* been converted, ignore */
+			goto next_block;
+		}
+		WARN_ON(imap.br_blockcount == 0);
+
+		/*
+		 * Note: while we initialise the firstblock/flist pair, they
+		 * should never be used because blocks should never be
+		 * allocated or freed for a delalloc extent and hence we need
+		 * don't cancel or finish them after the xfs_bunmapi() call.
+		 */
+		xfs_bmap_init(&flist, &firstblock);
+		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
+					&flist, &done);
+		if (error)
+			break;
+
+		ASSERT(!flist.xbf_count && !flist.xbf_first);
+next_block:
+		start_fsb++;
+		remaining--;
+	} while(remaining > 0);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 71ec9b6..3651191 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -394,6 +394,11 @@ xfs_bmap_count_blocks(
 	int			whichfork,
 	int			*count);
 
+int
+xfs_bmap_punch_delalloc_range(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		length);
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_H__ */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
