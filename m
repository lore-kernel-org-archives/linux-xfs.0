Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53172 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbfAQQhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 11:37:01 -0500
Received: from 089144213167.atnat0022.highway.a1.net ([89.144.213.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gkAf6-00047o-CL
        for linux-xfs@vger.kernel.org; Thu, 17 Jan 2019 16:37:00 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/11] xfs: merge COW handling into xfs_file_iomap_begin_delay
Date: Thu, 17 Jan 2019 17:36:33 +0100
Message-Id: <20190117163636.23171-9-hch@lst.de>
In-Reply-To: <20190117163636.23171-1-hch@lst.de>
References: <20190117163636.23171-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Besides simplifying the code a bit this allows to actually implement
the behavior of using COW preallocation for non-COW data mentioned
in the current comments.

Note that this breaks the current version of xfs/420, but that is
because the test is broken.  A separate fix will be sent for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c   | 133 ++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_reflink.c |  67 ----------------------
 fs/xfs/xfs_reflink.h |   2 -
 fs/xfs/xfs_trace.h   |   3 -
 4 files changed, 94 insertions(+), 111 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d851abac16a9..4dc3c766cc28 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -534,15 +534,16 @@ xfs_file_iomap_begin_delay(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		maxbytes_fsb =
 		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	xfs_fileoff_t		end_fsb;
-	int			error = 0, eof = 0;
-	struct xfs_bmbt_irec	got;
-	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	imap, cmap;
+	struct xfs_iext_cursor	icur, ccur;
 	xfs_fsblock_t		prealloc_blocks = 0;
+	bool			eof = false, cow_eof = false, shared;
+	int			whichfork = XFS_DATA_FORK;
+	int			error = 0;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 	ASSERT(!xfs_get_extsz_hint(ip));
@@ -560,7 +561,7 @@ xfs_file_iomap_begin_delay(
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
 		if (error)
 			goto out_unlock;
@@ -568,51 +569,92 @@ xfs_file_iomap_begin_delay(
 
 	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
 
-	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
+	/*
+	 * Search the data fork fork first to look up our source mapping.  We
+	 * always need the data fork map, as we have to return it to the
+	 * iomap code so that the higher level write code can read data in to
+	 * perform read-modify-write cycles for unaligned writes.
+	 */
+	eof = !xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap);
 	if (eof)
-		got.br_startoff = end_fsb; /* fake hole until the end */
+		imap.br_startoff = end_fsb; /* fake hole until the end */
 
-	if (got.br_startoff <= offset_fsb) {
+	/* We never need to allocate blocks for zeroing a hole. */
+	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
+		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
+		goto out_unlock;
+	}
+
+	/*
+	 * Search the COW fork extent list even if we did not find a data fork
+	 * extent.  This serves two purposes: first this implements the
+	 * speculative preallocation using cowextsize, so that we also unshare
+	 * block adjacent to shared blocks instead of just the shared blocks
+	 * themselves.  Second the lookup in the extent list is generally faster
+	 * than going out to the shared extent tree.
+	 */
+	if (xfs_is_reflink_inode(ip)) {
+		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
+				&ccur, &cmap);
+		if (!cow_eof && cmap.br_startoff <= offset_fsb) {
+			trace_xfs_reflink_cow_found(ip, &cmap);
+			whichfork = XFS_COW_FORK;
+			goto done;
+		}
+	}
+
+	if (imap.br_startoff <= offset_fsb) {
 		/*
 		 * For reflink files we may need a delalloc reservation when
 		 * overwriting shared extents.   This includes zeroing of
 		 * existing extents that contain data.
 		 */
-		if (xfs_is_reflink_inode(ip) &&
-		    ((flags & IOMAP_WRITE) ||
-		     got.br_state != XFS_EXT_UNWRITTEN)) {
-			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
-			error = xfs_reflink_reserve_cow(ip, &got);
-			if (error)
-				goto out_unlock;
+		if (!xfs_is_reflink_inode(ip) ||
+		    ((flags & IOMAP_ZERO) && imap.br_state != XFS_EXT_NORM)) {
+			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
+					&imap);
+			goto done;
 		}
 
-		trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK, &got);
-		goto done;
-	}
+		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 
-	if (flags & IOMAP_ZERO) {
-		xfs_hole_to_iomap(ip, iomap, offset_fsb, got.br_startoff);
-		goto out_unlock;
+		/* Trim the mapping to the nearest shared extent boundary. */
+		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
+		if (error)
+			goto out_unlock;
+
+		/* Not shared?  Just report the (potentially capped) extent. */
+		if (!shared) {
+			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
+					&imap);
+			goto done;
+		}
+
+		/*
+		 * Fork all the shared blocks from our write offset until the
+		 * end of the extent.
+		 */
+		whichfork = XFS_COW_FORK;
+		end_fsb = imap.br_startoff + imap.br_blockcount;
+	} else {
+		/*
+		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
+		 * pages to keep the chunks of work done where somewhat
+		 * symmetric with the work writeback does.  This is a completely
+		 * arbitrary number pulled out of thin air.
+		 *
+		 * Note that the values needs to be less than 32-bits wide until
+		 * the lower level functions are updated.
+		 */
+		count = min_t(loff_t, count, 1024 * PAGE_SIZE);
+		end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
 	}
 
 	error = xfs_qm_dqattach_locked(ip, false);
 	if (error)
 		goto out_unlock;
 
-	/*
-	 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES pages
-	 * to keep the chunks of work done where somewhat symmetric with the
-	 * work writeback does. This is a completely arbitrary number pulled
-	 * out of thin air as a best guess for initial testing.
-	 *
-	 * Note that the values needs to be less than 32-bits wide until
-	 * the lower level functions are updated.
-	 */
-	count = min_t(loff_t, count, 1024 * PAGE_SIZE);
-	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
-
-	if (eof) {
+	if (eof && whichfork == XFS_DATA_FORK) {
 		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count,
 				&icur);
 		if (prealloc_blocks) {
@@ -635,9 +677,11 @@ xfs_file_iomap_begin_delay(
 	}
 
 retry:
-	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks, &got, &icur,
-			eof);
+	error = xfs_bmapi_reserve_delalloc(ip, whichfork, offset_fsb,
+			end_fsb - offset_fsb, prealloc_blocks,
+			whichfork == XFS_DATA_FORK ? &imap : &cmap,
+			whichfork == XFS_DATA_FORK ? &icur : &ccur,
+			whichfork == XFS_DATA_FORK ? eof : cow_eof);
 	switch (error) {
 	case 0:
 		break;
@@ -659,9 +703,20 @@ xfs_file_iomap_begin_delay(
 	 * them out if the write happens to fail.
 	 */
 	iomap->flags |= IOMAP_F_NEW;
-	trace_xfs_iomap_alloc(ip, offset, count, XFS_DATA_FORK, &got);
+	trace_xfs_iomap_alloc(ip, offset, count, whichfork,
+			whichfork == XFS_DATA_FORK ? &imap : &cmap);
 done:
-	error = xfs_bmbt_to_iomap(ip, iomap, &got, false);
+	if (whichfork == XFS_COW_FORK) {
+		if (imap.br_startoff > offset_fsb) {
+			xfs_trim_extent(&cmap, offset_fsb,
+					imap.br_startoff - offset_fsb);
+			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, false);
+			goto out_unlock;
+		}
+		/* ensure we only report blocks we have a reservation for */
+		xfs_trim_extent(&imap, cmap.br_startoff, cmap.br_blockcount);
+	}
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, false);
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 8a5353daf9ab..9ef1f79cb3ae 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -234,73 +234,6 @@ xfs_reflink_trim_around_shared(
 	}
 }
 
-/*
- * Trim the passed in imap to the next shared/unshared extent boundary, and
- * if imap->br_startoff points to a shared extent reserve space for it in the
- * COW fork.
- *
- * Note that imap will always contain the block numbers for the existing blocks
- * in the data fork, as the upper layers need them for read-modify-write
- * operations.
- */
-int
-xfs_reflink_reserve_cow(
-	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*imap)
-{
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	struct xfs_bmbt_irec	got;
-	int			error = 0;
-	bool			eof = false;
-	struct xfs_iext_cursor	icur;
-	bool			shared;
-
-	/*
-	 * Search the COW fork extent list first.  This serves two purposes:
-	 * first this implement the speculative preallocation using cowextisze,
-	 * so that we also unshared block adjacent to shared blocks instead
-	 * of just the shared blocks themselves.  Second the lookup in the
-	 * extent list is generally faster than going out to the shared extent
-	 * tree.
-	 */
-
-	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &icur, &got))
-		eof = true;
-	if (!eof && got.br_startoff <= imap->br_startoff) {
-		trace_xfs_reflink_cow_found(ip, imap);
-		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
-		return 0;
-	}
-
-	/* Trim the mapping to the nearest shared extent boundary. */
-	error = xfs_reflink_trim_around_shared(ip, imap, &shared);
-	if (error)
-		return error;
-
-	/* Not shared?  Just report the (potentially capped) extent. */
-	if (!shared)
-		return 0;
-
-	/*
-	 * Fork all the shared blocks from our write offset until the end of
-	 * the extent.
-	 */
-	error = xfs_qm_dqattach_locked(ip, false);
-	if (error)
-		return error;
-
-	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
-			imap->br_blockcount, 0, &got, &icur, eof);
-	if (error == -ENOSPC || error == -EDQUOT)
-		trace_xfs_reflink_cow_enospc(ip, imap);
-	if (error)
-		return error;
-
-	xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
-	trace_xfs_reflink_cow_alloc(ip, &got);
-	return 0;
-}
-
 /* Convert part of an unwritten CoW extent to a real one. */
 STATIC int
 xfs_reflink_convert_cow_extent(
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 70d68a1a9b49..4a9e3cd4768a 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -12,8 +12,6 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 
-extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap);
 extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
 		unsigned iomap_flags);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f75c6d380543..a8c32206e147 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3196,13 +3196,10 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
 
 /* copy on write */
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
-DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_alloc);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 
-DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
-
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_bounce_dio_write);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
-- 
2.20.1
