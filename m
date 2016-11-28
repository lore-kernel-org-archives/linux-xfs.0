Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754093AbcK1TJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:09:44 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C02E31B326
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 19:09:43 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uASJ9huA006317
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:09:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/6] xfs: refactor iomap delalloc existing extent search into helper
Date: Mon, 28 Nov 2016 14:09:37 -0500
Message-Id: <1480360181-20396-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
References: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

In preparation for reuse of the existing delayed allocation code for COW
reservation, factor out the part of xfs_file_iomap_begin_delay()
responsible for existing extent lookup into a new helper. This patch
does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 72 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 57 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4f46f49..0a4ef18 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -522,6 +522,48 @@ xfs_iomap_prealloc_size(
 	return alloc_blocks;
 }
 
+/*
+ * Prepare to handle delayed allocation based on whether extents exist in the
+ * inode data and COW forks. If an existing data extent is shared, determine
+ * whether COW fork reservation is necessary.
+ *
+ * The 'found' parameter indicates whether a writable mapping was found. If the
+ * mapping is shared, a COW reservation is performed for the corresponding
+ * range.
+ */
+static int
+xfs_iomap_search_extents(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		end_fsb,
+	int			*eof,
+	int			*idx,
+	struct xfs_bmbt_irec	*got,
+	bool			*found)		/* found usable extent */
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	int			error = 0;
+
+	*found = false;
+
+	*eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, idx, got);
+	if (*eof || got->br_startoff > offset_fsb)
+		return 0;
+
+	if (xfs_is_reflink_inode(ip)) {
+		bool		shared;
+
+		xfs_trim_extent(got, offset_fsb, end_fsb - offset_fsb);
+		error = xfs_reflink_reserve_cow(ip, got, &shared);
+		if (error)
+			return error;
+	}
+
+	*found = true;
+
+	return error;
+}
+
 static int
 xfs_file_iomap_begin_delay(
 	struct inode		*inode,
@@ -533,18 +575,22 @@ xfs_file_iomap_begin_delay(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		offset_fsb;
+	xfs_fileoff_t		end_fsb;
 	xfs_fileoff_t		maxbytes_fsb =
 		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	xfs_fileoff_t		end_fsb;
 	int			error = 0, eof = 0;
 	struct xfs_bmbt_irec	got;
 	xfs_extnum_t		idx;
 	xfs_fsblock_t		prealloc_blocks = 0;
+	bool			found;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 	ASSERT(!xfs_get_extsz_hint(ip));
 
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	if (unlikely(XFS_TEST_ERROR(
@@ -564,19 +610,15 @@ xfs_file_iomap_begin_delay(
 			goto out_unlock;
 	}
 
-	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
-	if (!eof && got.br_startoff <= offset_fsb) {
-		if (xfs_is_reflink_inode(ip)) {
-			bool		shared;
-
-			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
-					maxbytes_fsb);
-			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
-			error = xfs_reflink_reserve_cow(ip, &got, &shared);
-			if (error)
-				goto out_unlock;
-		}
-
+	/*
+	 * Search for preexisting extents. If an existing data extent is shared,
+	 * this will perform COW fork reservation.
+	 */
+	error = xfs_iomap_search_extents(ip, offset_fsb, end_fsb, &eof, &idx,
+					 &got, &found);
+	if (error)
+		goto out_unlock;
+	if (found) {
 		trace_xfs_iomap_found(ip, offset, count, 0, &got);
 		goto done;
 	}
-- 
2.7.4

