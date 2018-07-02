Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33016 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbeGBO6U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:20 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/22] xfs: remove xfs_reflink_trim_irec_to_next_cow
Date: Mon,  2 Jul 2018 08:57:58 -0600
Message-Id: <20180702145813.22496-8-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

We already have to check for overlapping COW extents everytime we
come back to a page in xfs_writepage_map / xfs_map_cow, so this
additional trim is not required.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |  7 -------
 fs/xfs/xfs_reflink.c | 33 ---------------------------------
 fs/xfs/xfs_reflink.h |  2 --
 fs/xfs/xfs_trace.h   |  1 -
 4 files changed, 43 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6b6150683343..08605432c497 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -404,13 +404,6 @@ xfs_map_blocks(
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 				imap, &nimaps, XFS_BMAPI_ENTIRE);
-	/*
-	 * Truncate an overwrite extent if there's a pending CoW
-	 * reservation before the end of this extent.  This forces us
-	 * to come back to writepage to take care of the CoW.
-	 */
-	if (nimaps && type == XFS_IO_OVERWRITE)
-		xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb, imap);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (error)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 592fb2071a03..22c11b98ab26 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -500,39 +500,6 @@ xfs_reflink_find_cow_mapping(
 	return true;
 }
 
-/*
- * Trim an extent to end at the next CoW reservation past offset_fsb.
- */
-void
-xfs_reflink_trim_irec_to_next_cow(
-	struct xfs_inode		*ip,
-	xfs_fileoff_t			offset_fsb,
-	struct xfs_bmbt_irec		*imap)
-{
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	struct xfs_bmbt_irec		got;
-	struct xfs_iext_cursor		icur;
-
-	if (!xfs_is_reflink_inode(ip))
-		return;
-
-	/* Find the extent in the CoW fork. */
-	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got))
-		return;
-
-	/* This is the extent before; try sliding up one. */
-	if (got.br_startoff < offset_fsb) {
-		if (!xfs_iext_next_extent(ifp, &icur, &got))
-			return;
-	}
-
-	if (got.br_startoff >= imap->br_startoff + imap->br_blockcount)
-		return;
-
-	imap->br_blockcount = got.br_startoff - imap->br_startoff;
-	trace_xfs_reflink_trim_irec(ip, imap);
-}
-
 /*
  * Cancel CoW reservations for some block range of an inode.
  *
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 1532827ba911..6f9f98894abc 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,8 +20,6 @@ extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
 		struct xfs_bmbt_irec *imap);
-extern void xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
-		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
 
 extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
 		struct xfs_trans **tpp, xfs_fileoff_t offset_fsb,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 972d45d28097..a5b01529ecf6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3216,7 +3216,6 @@ DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_bounce_dio_write);
 DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
-DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
-- 
2.18.0

