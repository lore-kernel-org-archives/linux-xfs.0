Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754216AbcK1TJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:09:44 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D6AB804FC
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 19:09:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uASJ9hCD006331
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:09:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6/6] xfs: implement basic COW fork speculative preallocation
Date: Mon, 28 Nov 2016 14:09:41 -0500
Message-Id: <1480360181-20396-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
References: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

COW fork preallocation is currently limited to the value specified by
the COW extent size hint. This is typically much less aggressive than
traditional data fork speculative preallocation performed when
sufficiently large files are extended.

A file extension based algorithm is not relevant for COW reservation
since, by design, COW reservation never involves extending the size of a
file. That said, we can be more aggressive with COW fork preallocation
given that we support cowblocks inode tagging and reclaim
infrastructure. This provides the ability to reclaim COW fork
preallocation in the background or on demand.

Add a simple COW fork speculative preallocation algorithm. Extend COW
fork reservations due to file writes out to the next data fork extent,
unshared boundary or the next preexisting extent in the COW fork,
whichever limit we hit first. This provides a prealloc algorithm that is
based on the size of preexisting extents, similar to the existing
post-eof speculative preallocation algorithm.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 139 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9072bdb..b4aa603 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -395,57 +395,84 @@ xfs_iomap_prealloc_size(
 	struct xfs_inode	*ip,
 	loff_t			offset,
 	loff_t			count,
+	int			fork,
 	xfs_extnum_t		idx)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	struct xfs_bmbt_irec	prev;
+	struct xfs_bmbt_irec	base;
 	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
 	int			qshift = 0;
 	xfs_fsblock_t		alloc_blocks = 0;
+	int			error = 0;
 
-	if (offset + count <= XFS_ISIZE(ip))
-		return 0;
-
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
-	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_writeio_blocks)))
+	if (fork == XFS_DATA_FORK && offset + count <= XFS_ISIZE(ip))
 		return 0;
 
-	/*
-	 * If an explicit allocsize is set, the file is small, or we
-	 * are writing behind a hole, then use the minimum prealloc:
-	 */
-	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
-	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
-	    !xfs_iext_get_extent(ifp, idx - 1, &prev) ||
-	    prev.br_startoff + prev.br_blockcount < offset_fsb)
+	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
 		return mp->m_writeio_blocks;
 
 	/*
-	 * Determine the initial size of the preallocation. We are beyond the
-	 * current EOF here, but we need to take into account whether this is
-	 * a sparse write or an extending write when determining the
-	 * preallocation size.  Hence we need to look up the extent that ends
-	 * at the current write offset and use the result to determine the
-	 * preallocation size.
-	 *
-	 * If the extent is a hole, then preallocation is essentially disabled.
-	 * Otherwise we take the size of the preceding data extent as the basis
-	 * for the preallocation size. If the size of the extent is greater than
-	 * half the maximum extent length, then use the current offset as the
-	 * basis. This ensures that for large files the preallocation size
-	 * always extends to MAXEXTLEN rather than falling short due to things
-	 * like stripe unit/width alignment of real extents.
+	 * Determine the initial size of the preallocation depending on which
+	 * fork we are in.
 	 */
-	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
-		alloc_blocks = prev.br_blockcount << 1;
-	else
-		alloc_blocks = XFS_B_TO_FSB(mp, offset);
-	if (!alloc_blocks)
-		goto check_writeio;
+	if (fork == XFS_DATA_FORK) {
+		if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_writeio_blocks))
+			return 0;
+
+		/*
+		 * Use the minimum prealloc if the file is small or we're
+		 * writing behind a hole.
+		 */
+		if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
+		    !xfs_iext_get_extent(ifp, idx - 1, &base) ||
+		    base.br_startoff + base.br_blockcount < offset_fsb)
+			return mp->m_writeio_blocks;
+
+		/*
+		 * Use the size of the preceding data extent as the basis for
+		 * the preallocation size. If the size of the extent is greater
+		 * than half the maximum extent length, then use the current
+		 * offset as the basis. This ensures that for large files the
+		 * preallocation size always extends to MAXEXTLEN rather than
+		 * falling short due to things like stripe unit/width alignment
+		 * of real extents.
+		 */
+		if (base.br_blockcount <= (MAXEXTLEN >> 1))
+			alloc_blocks = base.br_blockcount << 1;
+		else
+			alloc_blocks = XFS_B_TO_FSB(mp, offset);
+		if (!alloc_blocks)
+			goto check_writeio;
+	} else {
+		xfs_extlen_t		len;
+		int			didx;
+		bool			shared, trimmed;
+
+		/* use the data fork extent as the basis for preallocation */
+		shared = xfs_iext_lookup_extent(ip, ifp, offset_fsb, &didx,
+						&base);
+		ASSERT(shared && offset_fsb >= base.br_startoff);
+
+		/*
+		 * Truncate the data fork extent to the next unshared boundary.
+		 * This defines the maximum COW fork preallocation as we do not
+		 * copy-on-write unshared blocks.
+		 */
+		len = base.br_blockcount - (offset_fsb - base.br_startoff);
+		xfs_trim_extent(&base, offset_fsb, len);
+		error = xfs_reflink_trim_around_shared(ip, &base, &shared,
+						       &trimmed);
+		ASSERT(!error && shared);
+		if (!error)
+			alloc_blocks = base.br_startoff + base.br_blockcount -
+					XFS_B_TO_FSB(mp, offset + count);
+		if (!alloc_blocks)
+			return 0;
+	}
 	qblocks = alloc_blocks;
 
 	/*
@@ -501,7 +528,7 @@ xfs_iomap_prealloc_size(
 	 * rounddown_pow_of_two() returns an undefined result if we pass in
 	 * alloc_blocks = 0.
 	 */
-	if (alloc_blocks)
+	if (alloc_blocks && fork == XFS_DATA_FORK)
 		alloc_blocks = rounddown_pow_of_two(alloc_blocks);
 	if (alloc_blocks > MAXEXTLEN)
 		alloc_blocks = MAXEXTLEN;
@@ -540,13 +567,13 @@ xfs_iomap_search_extents(
 	int			*idx,
 	struct xfs_bmbt_irec	*got,
 	bool			*shared,
+	bool			*trimmed,
 	bool			*found)		/* found usable extent */
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	int			error = 0;
-	bool			trimmed;
 
-	*shared = *found = false;
+	*shared = *trimmed = *found = false;
 
 	/*
 	 * Look up a preexisting extent directly into imap. Set got for the
@@ -583,7 +610,7 @@ xfs_iomap_search_extents(
 	 * is required to map the data extent. Trim the mapping to the next
 	 * (un)shared boundary at the same time.
 	 */
-	error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
+	error = xfs_reflink_trim_around_shared(ip, imap, shared, trimmed);
 	if (error)
 		return error;
 	if (!*shared)
@@ -614,7 +641,7 @@ xfs_file_iomap_begin_delay(
 	xfs_extnum_t		idx;
 	xfs_fsblock_t		prealloc_blocks = 0;
 	bool			found;
-	bool			shared;
+	bool			shared, trimmed;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 	ASSERT(!xfs_get_extsz_hint(ip));
@@ -646,7 +673,7 @@ xfs_file_iomap_begin_delay(
 	 * switch to the COW fork for COW reservation.
 	 */
 	error = xfs_iomap_search_extents(ip, offset_fsb, end_fsb, &imap, &eof,
-					 &idx, &got, &shared, &found);
+					 &idx, &got, &shared, &trimmed, &found);
 	if (error)
 		goto out_unlock;
 	if (found) {
@@ -675,25 +702,25 @@ xfs_file_iomap_begin_delay(
 	end_fsb = min(end_fsb, XFS_B_TO_FSB(mp, offset + count));
 	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 
-	if (eof && fork == XFS_DATA_FORK) {
-		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count, idx);
-		if (prealloc_blocks) {
-			xfs_extlen_t	align;
-			xfs_off_t	end_offset;
-			xfs_fileoff_t	p_end_fsb;
+	if ((fork == XFS_DATA_FORK && eof) ||
+	    (fork == XFS_COW_FORK && !trimmed))
+		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count,
+							  fork, idx);
+	if (prealloc_blocks) {
+		xfs_extlen_t	align;
+		xfs_off_t	end_offset;
+		xfs_fileoff_t	p_end_fsb;
 
-			end_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
-			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
-					prealloc_blocks;
+		end_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
+		p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) + prealloc_blocks;
 
-			align = xfs_eof_alignment(ip, 0);
-			if (align)
-				p_end_fsb = roundup_64(p_end_fsb, align);
+		align = xfs_eof_alignment(ip, 0);
+		if (align)
+			p_end_fsb = roundup_64(p_end_fsb, align);
 
-			p_end_fsb = min(p_end_fsb, maxbytes_fsb);
-			ASSERT(p_end_fsb > offset_fsb);
-			prealloc_blocks = p_end_fsb - end_fsb;
-		}
+		p_end_fsb = min(p_end_fsb, maxbytes_fsb);
+		ASSERT(p_end_fsb > offset_fsb);
+		prealloc_blocks = p_end_fsb - end_fsb;
 	}
 
 retry:
-- 
2.7.4

