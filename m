Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfBKMyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 07:54:54 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/10] xfs: move xfs_iomap_write_allocate to xfs_aops.c
Date: Mon, 11 Feb 2019 13:54:25 +0100
Message-Id: <20190211125427.16577-9-hch@lst.de>
In-Reply-To: <20190211125427.16577-1-hch@lst.de>
References: <20190211125427.16577-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

This function is a small wrapper only used by the writeback code, so
move it together with the writeback code and simplify it down to the
glorified do { } while loop that is now is.

A few bits intentionally got lost here: no need to call xfs_qm_dqattach
because quotas are always attached when we create the delalloc
reservation, and no need for the imap->br_startblock == 0 check given
that xfs_bmapi_convert_delalloc already has a WARN_ON_ONCE for exactly
that condition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 47 ++++++++++++++++++++++++---
 fs/xfs/xfs_iomap.c | 81 ----------------------------------------------
 fs/xfs/xfs_iomap.h |  2 --
 3 files changed, 42 insertions(+), 88 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8bfb62d8776f..403df647c0e4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -329,6 +329,44 @@ xfs_imap_valid(
 	return true;
 }
 
+/*
+ * Pass in a dellalloc extent and convert it to real extents, return the real
+ * extent that maps offset_fsb in wpc->imap.
+ *
+ * Given that ilock was dropped since got was populated it might no longer be
+ * valid, and we only use it to trim the return extent to this range to maintain
+ * consistency with what the caller expects.
+ *
+ * The current page is held locked so nothing could have removed the block
+ * backing offset_fsb.
+ */
+static int
+xfs_convert_blocks(
+	struct xfs_writepage_ctx *wpc,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	struct xfs_bmbt_irec	*got)
+{
+	int			error;
+
+	/*
+	 * Attempt to allocate whatever delalloc extent currently backs
+	 * offset_fsb and put the result into wpc->imap.  Allocate in a loop
+	 * because it may take several attempts to allocate real blocks for a
+	 * contiguous delalloc extent if free space is sufficiently fragmented.
+	 */
+	do {
+		error = xfs_bmapi_convert_delalloc(ip, wpc->fork, offset_fsb,
+				&wpc->imap, wpc->fork == XFS_COW_FORK ?
+					&wpc->cow_seq : &wpc->data_seq);
+		if (error)
+			return error;
+	} while (wpc->imap.br_startoff + wpc->imap.br_blockcount <= offset_fsb);
+
+	xfs_trim_extent(&wpc->imap, got->br_startoff, got->br_blockcount);
+	return 0;
+}
+
 STATIC int
 xfs_map_blocks(
 	struct xfs_writepage_ctx *wpc,
@@ -458,14 +496,13 @@ xfs_map_blocks(
 	trace_xfs_map_blocks_found(ip, offset, count, wpc->fork, &imap);
 	return 0;
 allocate_blocks:
-	error = xfs_iomap_write_allocate(ip, wpc->fork, offset, &imap,
-			wpc->fork == XFS_COW_FORK ?
-					 &wpc->cow_seq : &wpc->data_seq);
+	error = xfs_convert_blocks(wpc, ip, offset_fsb, &imap);
 	if (error)
 		return error;
+	ASSERT(wpc->imap.br_startoff <= offset_fsb);
+	ASSERT(wpc->imap.br_startoff + wpc->imap.br_blockcount >= offset_fsb);
 	ASSERT(wpc->fork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
-	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
-	wpc->imap = imap;
+	       wpc->imap.br_startoff + wpc->imap.br_blockcount <= cow_fsb);
 	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->fork, &imap);
 	return 0;
 }
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 15da53b5fb53..361dfe7af783 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -665,87 +665,6 @@ xfs_file_iomap_begin_delay(
 	return error;
 }
 
-/*
- * Pass in a delayed allocate extent, convert it to real extents;
- * return to the caller the extent we create which maps on top of
- * the originating callers request.
- *
- * Called without a lock on the inode.
- *
- * We no longer bother to look at the incoming map - all we have to
- * guarantee is that whatever we allocate fills the required range.
- */
-int
-xfs_iomap_write_allocate(
-	struct xfs_inode	*ip,
-	int			whichfork,
-	xfs_off_t		offset,
-	struct xfs_bmbt_irec	*imap,
-	unsigned int		*seq)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		offset_fsb;
-	xfs_fileoff_t		map_start_fsb;
-	xfs_extlen_t		map_count_fsb;
-	int			error = 0;
-
-	/*
-	 * Make sure that the dquots are there.
-	 */
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		return error;
-
-	/*
-	 * Store the file range the caller is interested in because it encodes
-	 * state such as potential overlap with COW fork blocks. We must trim
-	 * the allocated extent down to this range to maintain consistency with
-	 * what the caller expects. Revalidation of the range itself is the
-	 * responsibility of the caller.
-	 */
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	map_start_fsb = imap->br_startoff;
-	map_count_fsb = imap->br_blockcount;
-
-	while (true) {
-		/*
-		 * Allocate in a loop because it may take several attempts to
-		 * allocate real blocks for a contiguous delalloc extent if free
-		 * space is sufficiently fragmented.
-		 */
-
-		/*
-		 * ilock was dropped since imap was populated which means it
-		 * might no longer be valid. The current page is held locked so
-		 * nothing could have removed the block backing offset_fsb.
-		 * Attempt to allocate whatever delalloc extent currently backs
-		 * offset_fsb and put the result in the imap pointer from the
-		 * caller. We'll trim it down to the caller's most recently
-		 * validated range before we return.
-		 */
-		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset_fsb,
-				imap, seq);
-		if (error)
-			return error;
-
-		/*
-		 * See if we were able to allocate an extent that covers at
-		 * least part of the callers request.
-		 */
-		if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
-			return xfs_alert_fsblock_zero(ip, imap);
-
-		if ((offset_fsb >= imap->br_startoff) &&
-		    (offset_fsb < (imap->br_startoff +
-				   imap->br_blockcount))) {
-			xfs_trim_extent(imap, map_start_fsb, map_count_fsb);
-			ASSERT(offset_fsb >= imap->br_startoff &&
-			       offset_fsb < imap->br_startoff + imap->br_blockcount);
-			return 0;
-		}
-	}
-}
-
 int
 xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index c6170548831b..6b16243db0b7 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -13,8 +13,6 @@ struct xfs_bmbt_irec;
 
 int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *, int);
-int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
-			struct xfs_bmbt_irec *, unsigned int *);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 
 void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
-- 
2.20.1
