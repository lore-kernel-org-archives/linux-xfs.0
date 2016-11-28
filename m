Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754136AbcK1TJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:09:44 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1772C0567B5
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 19:09:43 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uASJ9hOW006320
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:09:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/6] xfs: reuse iomap delalloc code for COW fork reservation
Date: Mon, 28 Nov 2016 14:09:39 -0500
Message-Id: <1480360181-20396-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
References: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

COW fork reservation (delayed allocation) is implemented in
xfs_reflink_reserve_cow() and is generally based on the traditional data
fork delalloc logic in xfs_file_iomap_begin_delay(). In preparation for
further changes to implement more aggressive COW fork preallocation,
refactor the COW reservation code to reuse xfs_file_iomap_begin_delay()
for data fork allocation as well as COW fork reservation. This patch
does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 74 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0dec431c..9072bdb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -527,9 +527,8 @@ xfs_iomap_prealloc_size(
  * inode data and COW forks. If an existing data extent is shared, determine
  * whether COW fork reservation is necessary.
  *
- * The 'found' parameter indicates whether a writable mapping was found. If the
- * mapping is shared, a COW reservation is performed for the corresponding
- * range.
+ * The 'found' parameter indicates whether a writable mapping was found. If a
+ * shared mapping exists, found is set only if COW reservation exists as well.
  */
 static int
 xfs_iomap_search_extents(
@@ -540,12 +539,14 @@ xfs_iomap_search_extents(
 	int			*eof,
 	int			*idx,
 	struct xfs_bmbt_irec	*got,
+	bool			*shared,
 	bool			*found)		/* found usable extent */
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	int			error = 0;
+	bool			trimmed;
 
-	*found = false;
+	*shared = *found = false;
 
 	/*
 	 * Look up a preexisting extent directly into imap. Set got for the
@@ -556,17 +557,37 @@ xfs_iomap_search_extents(
 		*got = *imap;
 		return 0;
 	}
+	if (!xfs_is_reflink_inode(ip)) {
+		*found = true;
+		return 0;
+	}
 
-	if (xfs_is_reflink_inode(ip)) {
-		bool		shared;
-
-		xfs_trim_extent(imap, offset_fsb, end_fsb - offset_fsb);
-		error = xfs_reflink_reserve_cow(ip, imap, &shared);
-		if (error)
-			return error;
+	/*
+	 * Found a data extent but we don't know if it is shared. If an extent
+	 * exists in the cow fork, assume that it is. Use got for this lookup as
+	 * imap must retain the data mapping.
+	 */
+	xfs_trim_extent(imap, offset_fsb, end_fsb - offset_fsb);
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	*eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, idx, got);
+	if (!*eof && got->br_startoff <= imap->br_startoff) {
+		trace_xfs_reflink_cow_found(ip, got);
+		xfs_trim_extent(imap, got->br_startoff, got->br_blockcount);
+		*found = true;
+		return 0;
 	}
 
-	*found = true;
+	/*
+	 * There is no existing cow fork extent. We have to explicitly check if
+	 * the data extent is shared to determine whether COW fork reservation
+	 * is required to map the data extent. Trim the mapping to the next
+	 * (un)shared boundary at the same time.
+	 */
+	error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
+	if (error)
+		return error;
+	if (!*shared)
+		*found = true;
 
 	return error;
 }
@@ -587,11 +608,13 @@ xfs_file_iomap_begin_delay(
 	xfs_fileoff_t		maxbytes_fsb =
 		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	int			error = 0, eof = 0;
+	int			fork = XFS_DATA_FORK;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_bmbt_irec	got;
 	xfs_extnum_t		idx;
 	xfs_fsblock_t		prealloc_blocks = 0;
 	bool			found;
+	bool			shared;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 	ASSERT(!xfs_get_extsz_hint(ip));
@@ -620,16 +643,20 @@ xfs_file_iomap_begin_delay(
 
 	/*
 	 * Search for preexisting extents. If an existing data extent is shared,
-	 * this will perform COW fork reservation.
+	 * switch to the COW fork for COW reservation.
 	 */
 	error = xfs_iomap_search_extents(ip, offset_fsb, end_fsb, &imap, &eof,
-					 &idx, &got, &found);
+					 &idx, &got, &shared, &found);
 	if (error)
 		goto out_unlock;
 	if (found) {
 		trace_xfs_iomap_found(ip, offset, count, 0, &imap);
 		goto done;
 	}
+	if (shared) {
+		end_fsb = imap.br_startoff + imap.br_blockcount;
+		fork = XFS_COW_FORK;
+	}
 
 	error = xfs_qm_dqattach_locked(ip, 0);
 	if (error)
@@ -645,9 +672,10 @@ xfs_file_iomap_begin_delay(
 	 * the lower level functions are updated.
 	 */
 	count = min_t(loff_t, count, 1024 * PAGE_SIZE);
-	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
+	end_fsb = min(end_fsb, XFS_B_TO_FSB(mp, offset + count));
+	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 
-	if (eof) {
+	if (eof && fork == XFS_DATA_FORK) {
 		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count, idx);
 		if (prealloc_blocks) {
 			xfs_extlen_t	align;
@@ -669,7 +697,7 @@ xfs_file_iomap_begin_delay(
 	}
 
 retry:
-	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
+	error = xfs_bmapi_reserve_delalloc(ip, fork, offset_fsb,
 			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
 	switch (error) {
 	case 0:
@@ -687,8 +715,16 @@ xfs_file_iomap_begin_delay(
 		goto out_unlock;
 	}
 
-	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
-	imap = got;
+	/*
+	 * For the data fork, the iomap mapping is simply the extent that was
+	 * returned from the delalloc request. Otherwise, use imap as it refers
+	 * to the data fork but is trimmed according to the shared state.
+	 */
+	if (fork == XFS_DATA_FORK) {
+		trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
+		imap = got;
+	} else
+		trace_xfs_reflink_cow_alloc(ip, &got);
 done:
 	if (isnullstartblock(imap.br_startblock))
 		imap.br_startblock = DELAYSTARTBLOCK;
-- 
2.7.4

