Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9BY9pN151440 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 05:34:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCA581DAD4BB
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 03:35:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	KtRWGFDTtPC9Lw2Y for <xfs@oss.sgi.com>;
	Tue, 09 Nov 2010 03:35:34 -0800 (PST)
Date: Tue, 9 Nov 2010 22:35:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: fix failed write handling
Message-ID: <20101109113530.GK2715@dastard>
References: <20101109002559.GA30016@infradead.org>
	<20101109055142.GJ2715@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109055142.GJ2715@dastard>
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

On Tue, Nov 09, 2010 at 04:51:42PM +1100, Dave Chinner wrote:
> On Mon, Nov 08, 2010 at 07:26:00PM -0500, Christoph Hellwig wrote:
> > Since the move to the new truncate sequence we call xfs_setattr to
> > truncate down excessively instanciated blocks.  As shown by the testcase
> > in kernel.org BZ #22452 that doesn't work too well.  Due to the confusion
> > of the internal inode size, and the VFS inode i_size it zeroes data that
> > it shouldn't.
> > 
> > But full blown truncate seems like overkill here.  We only instanciate
> > delayed allocations in the write path, and given that we never released
> > the iolock we can't have converted them to real allocations yet either.
> > 
> > The only nasty case is pre-existing preallocation which we need to skip.
> > The patch below does that by borrowing code from xfs_aops_discard_page.
> > It does pass xfstests for 4k block filesystems and fixes the original
> > bug.  I'm not quite sure if we could hit a corner case with smaller
> > block sizes when parts of a page are preallocated and some not.
> 
> Seems likely - preallocated block past EOF are not unusual.
> 
> > That
> > could be handled by looping around bmapi as long as we find extents
> > for our range.  The path could probably also be refactored to share
> > code with xfs_aops_discard_page.  And we probably need the ilock
> > just as in that path, but I only got to that when almost through
> > xfstests, and the day is over for me today, so let's just get the
> > patch out for now.
> 
> Yes, definitely need the ilock - that's the only lock that provides
> protection for the extent tree.
> 
> It looks to me that we need a general "discard delalloc blocks from
> range" function - I'll write one (basically the guts of
> xfs_aops_discard_page) and convert xfs_aops_discard_page() and this
> code to use it....

The patch below does this. It's passed xfstests on a couple of
different VMs and the provided test case. xfstests is curently
running on 512 byte and 1k block size filesystems to exercise
sub-page block size failure cases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix failed write truncation handling.

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

Based on a fix originally from Christoph Hellwig.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   91 ++++++++++++++++++------------------------
 fs/xfs/xfs_bmap.c           |   79 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap.h           |    5 ++
 3 files changed, 123 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index c9af48f..60e8577 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -949,58 +949,12 @@ xfs_aops_discard_page(
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
+		error = xfs_bmap_punch_delalloc_range(ip, offset, offset + len);
 		if (error) {
 			/* something screwed, just bail */
 			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
@@ -1020,6 +974,7 @@ out_invalidate:
 	return;
 }
 
+
 /*
  * Write out a dirty page.
  *
@@ -1504,11 +1459,43 @@ xfs_vm_write_failed(
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
+		error = xfs_bmap_punch_delalloc_range(ip,
+					XFS_FSB_TO_B(ip->i_mount, start_fsb),
+					XFS_FSB_TO_B(ip->i_mount, end_fsb));
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
index 7764a4f..35acc48 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6075,3 +6075,82 @@ xfs_bmap_disk_count_leaves(
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
+	xfs_fileoff_t		start,
+	ssize_t			end)
+{
+	ssize_t			remaining = end - start;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	do {
+		int		done;
+		xfs_fileoff_t	start_fsb;
+		xfs_bmbt_irec_t	imap;
+		int		nimaps = 1;
+		xfs_fsblock_t	firstblock;
+		xfs_bmap_free_t flist;
+
+		start_fsb = XFS_B_TO_FSBT(ip->i_mount, start);
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
+			"Failed delalloc mapping lookup ino %lld offset %lld.",
+						ip->i_ino, start);
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
+		start += ip->i_mount->m_bsize;
+		remaining -= ip->i_mount->m_bsize;
+	} while(remaining > 0);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 71ec9b6..3ec586c 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -394,6 +394,11 @@ xfs_bmap_count_blocks(
 	int			whichfork,
 	int			*count);
 
+int
+xfs_bmap_punch_delalloc_range(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		start,
+	ssize_t			end);
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
