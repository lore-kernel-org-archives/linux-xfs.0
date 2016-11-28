Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753137AbcK1TJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:09:44 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92A55A794
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 19:09:43 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uASJ9hPb025625
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:09:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/6] xfs: logically separate iomap range from allocation range
Date: Mon, 28 Nov 2016 14:09:38 -0500
Message-Id: <1480360181-20396-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
References: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_file_iomap_begin_delay() uses the got variable for the extent
returned by the in-core extent list lookup, the allocated extent
returned by xfs_bmapi_reserve_delalloc() and the extent mapped to the
iomap data structure for the caller.

This is fine for current usage, but doesn't work for COW fork
reservation. In that case, the extent returned by
xfs_bmapi_reserve_delalloc() is the COW reservation and not the extent
to be mapped to the iomap. Instead, the shared data fork extent should
be trimmed appropriately and mapped to the iomap.

To prepare *_begin_delay() to support COW fork reservation, add a new
imap variable to separately track the data fork extent (for iomap) from
the extent returned from the lookup. The latter extent may refer to
either the data or COW fork in the future.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0a4ef18..0dec431c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -536,6 +536,7 @@ xfs_iomap_search_extents(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		offset_fsb,
 	xfs_fileoff_t		end_fsb,
+	struct xfs_bmbt_irec	*imap,		/* for iomap mapping */
 	int			*eof,
 	int			*idx,
 	struct xfs_bmbt_irec	*got,
@@ -546,15 +547,21 @@ xfs_iomap_search_extents(
 
 	*found = false;
 
-	*eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, idx, got);
-	if (*eof || got->br_startoff > offset_fsb)
+	/*
+	 * Look up a preexisting extent directly into imap. Set got for the
+	 * bmapi delalloc call if nothing is found.
+	 */
+	*eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, idx, imap);
+	if (*eof || imap->br_startoff > offset_fsb) {
+		*got = *imap;
 		return 0;
+	}
 
 	if (xfs_is_reflink_inode(ip)) {
 		bool		shared;
 
-		xfs_trim_extent(got, offset_fsb, end_fsb - offset_fsb);
-		error = xfs_reflink_reserve_cow(ip, got, &shared);
+		xfs_trim_extent(imap, offset_fsb, end_fsb - offset_fsb);
+		error = xfs_reflink_reserve_cow(ip, imap, &shared);
 		if (error)
 			return error;
 	}
@@ -580,6 +587,7 @@ xfs_file_iomap_begin_delay(
 	xfs_fileoff_t		maxbytes_fsb =
 		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	int			error = 0, eof = 0;
+	struct xfs_bmbt_irec	imap;
 	struct xfs_bmbt_irec	got;
 	xfs_extnum_t		idx;
 	xfs_fsblock_t		prealloc_blocks = 0;
@@ -614,12 +622,12 @@ xfs_file_iomap_begin_delay(
 	 * Search for preexisting extents. If an existing data extent is shared,
 	 * this will perform COW fork reservation.
 	 */
-	error = xfs_iomap_search_extents(ip, offset_fsb, end_fsb, &eof, &idx,
-					 &got, &found);
+	error = xfs_iomap_search_extents(ip, offset_fsb, end_fsb, &imap, &eof,
+					 &idx, &got, &found);
 	if (error)
 		goto out_unlock;
 	if (found) {
-		trace_xfs_iomap_found(ip, offset, count, 0, &got);
+		trace_xfs_iomap_found(ip, offset, count, 0, &imap);
 		goto done;
 	}
 
@@ -680,17 +688,18 @@ xfs_file_iomap_begin_delay(
 	}
 
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
+	imap = got;
 done:
-	if (isnullstartblock(got.br_startblock))
-		got.br_startblock = DELAYSTARTBLOCK;
+	if (isnullstartblock(imap.br_startblock))
+		imap.br_startblock = DELAYSTARTBLOCK;
 
-	if (!got.br_startblock) {
-		error = xfs_alert_fsblock_zero(ip, &got);
+	if (!imap.br_startblock) {
+		error = xfs_alert_fsblock_zero(ip, &imap);
 		if (error)
 			goto out_unlock;
 	}
 
-	xfs_bmbt_to_iomap(ip, iomap, &got);
+	xfs_bmbt_to_iomap(ip, iomap, &imap);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-- 
2.7.4

