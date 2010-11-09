Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA90OXK9126409 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 18:24:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C8651C25E67
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 16:26:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id U3hQVcuubJyH1E1S for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 16:26:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PFc2C-0007oB-4t
	for xfs@oss.sgi.com; Tue, 09 Nov 2010 00:26:00 +0000
Date: Mon, 8 Nov 2010 19:26:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfs: fix failed write handling
Message-ID: <20101109002559.GA30016@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

Since the move to the new truncate sequence we call xfs_setattr to
truncate down excessively instanciated blocks.  As shown by the testcase
in kernel.org BZ #22452 that doesn't work too well.  Due to the confusion
of the internal inode size, and the VFS inode i_size it zeroes data that
it shouldn't.

But full blown truncate seems like overkill here.  We only instanciate
delayed allocations in the write path, and given that we never released
the iolock we can't have converted them to real allocations yet either.

The only nasty case is pre-existing preallocation which we need to skip.
The patch below does that by borrowing code from xfs_aops_discard_page.
It does pass xfstests for 4k block filesystems and fixes the original
bug.  I'm not quite sure if we could hit a corner case with smaller
block sizes when parts of a page are preallocated and some not.  That
could be handled by looping around bmapi as long as we find extents
for our range.  The path could probably also be refactored to share
code with xfs_aops_discard_page.  And we probably need the ilock
just as in that path, but I only got to that when almost through
xfstests, and the day is over for me today, so let's just get the
patch out for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-11-08 20:04:07.558196347 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-11-08 23:32:34.798196347 +0100
@@ -1505,11 +1505,74 @@ xfs_vm_write_failed(
 	struct inode		*inode = mapping->host;
 
 	if (to > inode->i_size) {
-		struct iattr	ia = {
-			.ia_valid	= ATTR_SIZE | ATTR_FORCE,
-			.ia_size	= inode->i_size,
-		};
-		xfs_setattr(XFS_I(inode), &ia, XFS_ATTR_NOLOCK);
+		struct xfs_inode	*ip = XFS_I(inode);
+		int			done;
+		xfs_bmbt_irec_t		imap;
+		int			nimaps = 1;
+		xfs_fileoff_t		start_fsb;
+		xfs_fileoff_t		end_fsb;
+		int			error;
+		xfs_fsblock_t		firstblock;
+		xfs_bmap_free_t 	flist;
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
+		/*
+		 * Map the range first and check that it is a delalloc extent
+		 * before trying to unmap the range. Otherwise we will be
+		 * trying to remove a real extent (which requires a
+		 * transaction) or a hole, which is probably a bad idea...
+		 */
+		error = xfs_bmapi(NULL, ip, start_fsb, end_fsb - start_fsb,
+				XFS_BMAPI_ENTIRE,  NULL, 0, &imap,
+				&nimaps, NULL);
+
+		if (error) {
+			/* something screwed, just bail */
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+				"page discard failed delalloc mapping lookup.");
+			}
+			return;
+		}
+		if (!nimaps)
+			return;
+
+		if (imap.br_startblock != DELAYSTARTBLOCK)
+			return;
+		WARN_ON(imap.br_blockcount == 0);
+
+
+		/*
+		 * Note: while we initialise the firstblock/flist pair, they
+		 * should never be used because blocks should never be
+		 * allocated or freed for a delalloc extent and hence we need
+		 * don't cancel or finish them after the xfs_bunmapi() call.
+		 */
+		xfs_bmap_init(&flist, &firstblock);
+		error = xfs_bunmapi(NULL, ip, start_fsb, end_fsb - start_fsb,
+				    0, 1, &firstblock, &flist, &done);
+
+		ASSERT(!flist.xbf_count && !flist.xbf_first);
+		if (error) {
+			/* something screwed, just bail */
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+			"page discard unable to remove delalloc mapping.");
+			}
+		} else if (!done) {
+			xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+			"page discard not done.");
+		}
 	}
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
