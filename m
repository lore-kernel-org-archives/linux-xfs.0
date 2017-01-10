Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939746AbdAJNwf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 08:52:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 187/206] xfs: use new extent lookup helpers xfs_file_iomap_begin_delay
Date: Tue, 10 Jan 2017 14:37:50 +0100
Message-Id: <20170110131511.571184471@linuxfoundation.org>
In-Reply-To: <20170110131502.767555407@linuxfoundation.org>
References: <20170110131502.767555407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-xfs@vger.kernel.org, Dave Chinner" <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>Dave Chinner <david@fromorbit.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


commit 656152e552e5cbe0c11ad261b524376217c2fb13 upstream.

And only lookup the previous extent inside xfs_iomap_prealloc_size
if we actually need it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -395,11 +395,12 @@ xfs_iomap_prealloc_size(
 	struct xfs_inode	*ip,
 	loff_t			offset,
 	loff_t			count,
-	xfs_extnum_t		idx,
-	struct xfs_bmbt_irec	*prev)
+	xfs_extnum_t		idx)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	struct xfs_bmbt_irec	prev;
 	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
@@ -419,8 +420,8 @@ xfs_iomap_prealloc_size(
 	 */
 	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
 	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
-	    idx == 0 ||
-	    prev->br_startoff + prev->br_blockcount < offset_fsb)
+	    !xfs_iext_get_extent(ifp, idx - 1, &prev) ||
+	    prev.br_startoff + prev.br_blockcount < offset_fsb)
 		return mp->m_writeio_blocks;
 
 	/*
@@ -439,8 +440,8 @@ xfs_iomap_prealloc_size(
 	 * always extends to MAXEXTLEN rather than falling short due to things
 	 * like stripe unit/width alignment of real extents.
 	 */
-	if (prev->br_blockcount <= (MAXEXTLEN >> 1))
-		alloc_blocks = prev->br_blockcount << 1;
+	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
+		alloc_blocks = prev.br_blockcount << 1;
 	else
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	if (!alloc_blocks)
@@ -538,7 +539,6 @@ xfs_file_iomap_begin_delay(
 	xfs_fileoff_t		end_fsb, orig_end_fsb;
 	int			error = 0, eof = 0;
 	struct xfs_bmbt_irec	got;
-	struct xfs_bmbt_irec	prev;
 	xfs_extnum_t		idx;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
@@ -563,8 +563,7 @@ xfs_file_iomap_begin_delay(
 			goto out_unlock;
 	}
 
-	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
-			&got, &prev);
+	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
 	if (!eof && got.br_startoff <= offset_fsb) {
 		if (xfs_is_reflink_inode(ip)) {
 			bool		shared;
@@ -601,8 +600,7 @@ xfs_file_iomap_begin_delay(
 	if (eof) {
 		xfs_fsblock_t	prealloc_blocks;
 
-		prealloc_blocks =
-			xfs_iomap_prealloc_size(ip, offset, count, idx, &prev);
+		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count, idx);
 		if (prealloc_blocks) {
 			xfs_extlen_t	align;
 			xfs_off_t	end_offset;


