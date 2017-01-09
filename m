Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56392 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756377AbdAIPjQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:16 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/32] xfs: don't skip cow forks w/ delalloc blocks in cowblocks scan
Date: Mon,  9 Jan 2017 16:38:34 +0100
Message-Id: <1483976343-661-4-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Brian Foster <bfoster@redhat.com>

commit 399372349a7f9b2d7e56e4fa4467c69822d07024 upstream.

The cowblocks background scanner currently clears the cowblocks tag
for inodes without any real allocations in the cow fork. This
excludes inodes with only delalloc blocks in the cow fork. While we
might never expect to clear delalloc blocks from the cow fork in the
background scanner, it is not necessarily correct to clear the
cowblocks tag from such inodes.

For example, if the background scanner happens to process an inode
between a buffered write and writeback, the scanner catches the
inode in a state after delalloc blocks have been allocated to the
cow fork but before the delalloc blocks have been converted to real
blocks by writeback. The background scanner then incorrectly clears
the cowblocks tag, even if part of the aforementioned delalloc
reservation will not be remapped to the data fork (i.e., extra
blocks due to the cowextsize hint). This means that any such
additional blocks in the cow fork might never be reclaimed by the
background scanner and could persist until the inode itself is
reclaimed.

To address this problem, only skip and clear inodes without any cow
fork allocations whatsoever from the background scanner. While we
generally do not want to cancel delalloc reservations from the
background scanner, the pagecache dirty check following the
cowblocks check should prevent that situation. If we do end up with
delalloc cow fork blocks without a dirty address space mapping, this
is probably an indication that something has gone wrong and the
blocks should be reclaimed, as they may never be converted to a real
allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_icache.c  |  7 ++++++-
 fs/xfs/xfs_reflink.c | 34 ----------------------------------
 fs/xfs/xfs_reflink.h |  2 --
 3 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f295049..1b4861f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1580,10 +1580,15 @@ xfs_inode_free_cowblocks(
 	struct xfs_eofblocks *eofb = args;
 	bool need_iolock = true;
 	int match;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 
 	ASSERT(!eofb || (eofb && eofb->eof_scan_owner != 0));
 
-	if (!xfs_reflink_has_real_cow_blocks(ip)) {
+	/*
+	 * Just clear the tag if we have an empty cow fork or none at all. It's
+	 * possible the inode was fully unshared since it was originally tagged.
+	 */
+	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
 		trace_xfs_inode_free_cowblocks_invalid(ip);
 		xfs_inode_clear_cowblocks_tag(ip);
 		return 0;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a279b4e..c069048 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1697,37 +1697,3 @@ xfs_reflink_unshare(
 	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
 	return error;
 }
-
-/*
- * Does this inode have any real CoW reservations?
- */
-bool
-xfs_reflink_has_real_cow_blocks(
-	struct xfs_inode		*ip)
-{
-	struct xfs_bmbt_irec		irec;
-	struct xfs_ifork		*ifp;
-	struct xfs_bmbt_rec_host	*gotp;
-	xfs_extnum_t			idx;
-
-	if (!xfs_is_reflink_inode(ip))
-		return false;
-
-	/* Go find the old extent in the CoW fork. */
-	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	gotp = xfs_iext_bno_to_ext(ifp, 0, &idx);
-	while (gotp) {
-		xfs_bmbt_get_all(gotp, &irec);
-
-		if (!isnullstartblock(irec.br_startblock))
-			return true;
-
-		/* Roll on... */
-		idx++;
-		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
-			break;
-		gotp = xfs_iext_get_ext(ifp, idx);
-	}
-
-	return false;
-}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index fad1160..97ea9b4 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -50,6 +50,4 @@ extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
 extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len);
 
-extern bool xfs_reflink_has_real_cow_blocks(struct xfs_inode *ip);
-
 #endif /* __XFS_REFLINK_H */
-- 
2.1.4

