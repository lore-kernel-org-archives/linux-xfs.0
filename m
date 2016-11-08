Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753336AbcKHU1h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Nov 2016 15:27:37 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7ED89C05AA4C
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2016 20:27:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uA8KRbkP014914
        for <linux-xfs@vger.kernel.org>; Tue, 8 Nov 2016 15:27:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 3/4] xfs: reuse xfs_file_iomap_begin_delay() for cow fork delalloc
Date: Tue,  8 Nov 2016 15:27:35 -0500
Message-Id: <1478636856-7590-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

COW fork reservation (delayed allocation) is implemented in
xfs_reflink_reserve_cow() and is generally based on the traditional data
fork delalloc logic in xfs_file_iomap_begin_delay(). In preparation for
further changes to implement more aggressive COW fork preallocation,
refactor the COW reservation code to reuse xfs_file_iomap_begin_delay()
for data fork allocation or COW fork reservation. This patch does not
change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 79 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7446531..40bf66c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -532,7 +532,7 @@ xfs_file_iomap_begin_delay(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		offset_fsb;
 	xfs_fileoff_t		maxbytes_fsb =
 		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	xfs_fileoff_t		end_fsb, orig_end_fsb;
@@ -541,10 +541,14 @@ xfs_file_iomap_begin_delay(
 	struct xfs_bmbt_irec	prev;
 	struct xfs_bmbt_irec	imap;	/* for iomap */
 	xfs_extnum_t		idx;
+	int			fork = XFS_DATA_FORK;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 	ASSERT(!xfs_get_extsz_hint(ip));
 
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	if (unlikely(XFS_TEST_ERROR(
@@ -564,23 +568,50 @@ xfs_file_iomap_begin_delay(
 			goto out_unlock;
 	}
 
+	/*
+	 * Search for a preexisting extent. COW fork allocation may still be
+	 * required for reflink inodes if the data extent is shared.
+	 */
 	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
 			&got, &prev);
 	imap = got;
 	if (!eof && got.br_startoff <= offset_fsb) {
 		if (xfs_is_reflink_inode(ip)) {
-			bool		shared;
+			bool		shared, trimmed;
 
-			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
-					maxbytes_fsb);
-			xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
-			error = xfs_reflink_reserve_cow(ip, &imap, &shared);
+			/*
+			 * Assume the data extent is shared if an extent exists
+			 * in the cow fork.
+			 */
+			xfs_trim_extent(&imap, offset_fsb,
+					end_fsb - offset_fsb);
+			xfs_bmap_search_extents(ip, imap.br_startoff,
+					XFS_COW_FORK, &eof, &idx, &got, &prev);
+			if (!eof && got.br_startoff <= imap.br_startoff) {
+				trace_xfs_reflink_cow_found(ip, &got);
+				xfs_trim_extent(&imap, got.br_startoff,
+						got.br_blockcount);
+				goto done;
+			}
+
+			/*
+			 * No existing cow fork extent. Now we have to actually
+			 * check if the data extent is shared and trim the
+			 * mapping to the next (un)shared boundary.
+			 */
+			error = xfs_reflink_trim_around_shared(ip, &imap,
+						       &shared, &trimmed);
 			if (error)
 				goto out_unlock;
+			if (!shared)
+				goto done;
+
+			end_fsb = imap.br_startoff + imap.br_blockcount;
+			fork = XFS_COW_FORK;
+		} else {
+			trace_xfs_iomap_found(ip, offset, count, 0, &imap);
+			goto done;
 		}
-
-		trace_xfs_iomap_found(ip, offset, count, 0, &imap);
-		goto done;
 	}
 
 	error = xfs_qm_dqattach_locked(ip, 0);
@@ -597,10 +628,10 @@ xfs_file_iomap_begin_delay(
 	 * the lower level functions are updated.
 	 */
 	count = min_t(loff_t, count, 1024 * PAGE_SIZE);
-	end_fsb = orig_end_fsb =
-		min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
+	end_fsb = orig_end_fsb = min(XFS_B_TO_FSB(mp, offset + count), end_fsb);
+	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 
-	if (eof) {
+	if (eof && fork == XFS_DATA_FORK) {
 		xfs_fsblock_t	prealloc_blocks;
 
 		prealloc_blocks =
@@ -623,9 +654,8 @@ xfs_file_iomap_begin_delay(
 	}
 
 retry:
-	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, &got,
-			&prev, &idx, eof);
+	error = xfs_bmapi_reserve_delalloc(ip, fork, offset_fsb,
+			end_fsb - offset_fsb, &got, &prev, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
@@ -643,14 +673,21 @@ xfs_file_iomap_begin_delay(
 	}
 
 	/*
-	 * Tag the inode as speculatively preallocated so we can reclaim this
-	 * space on demand, if necessary.
+	 * Tag the inode if we've added post-eof or cow fork preallocation so we
+	 * can reclaim this space on demand.
 	 */
-	if (end_fsb != orig_end_fsb)
-		xfs_inode_set_eofblocks_tag(ip);
+	if (fork == XFS_DATA_FORK) {
+		trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
+		if (end_fsb != orig_end_fsb)
+			xfs_inode_set_eofblocks_tag(ip);
+		imap = got;
+	} else {
+		trace_xfs_reflink_cow_alloc(ip, &got);
+		if (got.br_startblock != offset_fsb ||
+		    got.br_blockcount != end_fsb - offset_fsb)
+			xfs_inode_set_cowblocks_tag(ip);
+	}
 
-	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
-	imap = got;
 done:
 	if (isnullstartblock(imap.br_startblock))
 		imap.br_startblock = DELAYSTARTBLOCK;
-- 
2.7.4

