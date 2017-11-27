Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751843AbdK0UYg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 15:24:36 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5B1185545
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 20:24:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA0D060602
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 20:24:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] xfs: include inobt buffers in ifree tx log reservation
Date: Mon, 27 Nov 2017 15:24:32 -0500
Message-Id: <20171127202434.43125-3-bfoster@redhat.com>
In-Reply-To: <20171127202434.43125-1-bfoster@redhat.com>
References: <20171127202434.43125-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The tr_ifree transaction handles inode unlinks and inode chunk
frees. The current transaction calculation does not accurately
reflect worst case changes to the inode btree, however. The inobt
portion of the current transaction reservation only covers
modification of a single inobt buffer (for the particular inode
record). This is a historical artifact from the days before XFS
supported full inode chunk removal.

When support for inode chunk removal was added in commit
254f6311ed1b ("Implement deletion of inode clusters in XFS."), the
additional log reservation required for chunk removal was not added
correctly. The new reservation only considered the header overhead
of associated buffers rather than the full contents of the btrees
and AGF and AGFL buffers affected by the transaction. The
reservation for the free space btrees was subsequently fixed up in
commit 5fe6abb82f76 ("Add space for inode and allocation btrees to
ITRUNCATE log reservation"), but the res. for full inobt joins has
never been added.

Update xfs_calc_ifree_reservation() to include a full inobt join in
the reservation calculation. Refactor the undocumented +2 blocks for
the AGF and AGFL buffers into the appropriate place so they are
accounted as sectors (not FSBs) and update the associated comments.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 6bd916bd35e2..4cd7cd1e60da 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -490,10 +490,10 @@ xfs_calc_symlink_reservation(
 /*
  * In freeing an inode we can modify:
  *    the inode being freed: inode size
- *    the super block free inode counter: sector size
+ *    the super block free inode counter, AGF and AGFL: sector size
  *    the agi hash list and counters: sector size
- *    the inode btree entry: block size
  *    the on disk inode before ours in the agi hash list: inode cluster size
+ *    the inode chunk is marked stale (headers only)
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
  *    the finobt (record insertion, removal or modification)
@@ -504,12 +504,11 @@ xfs_calc_ifree_reservation(
 {
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_inode_res(mp, 1) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 		xfs_calc_iunlink_remove_reservation(mp) +
 		xfs_calc_buf_res(1, 0) +
-		xfs_calc_buf_res(2 + mp->m_ialloc_blks +
-				 mp->m_in_maxlevels, 0) +
+		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_finobt_res(mp, 0, 1);
-- 
2.13.6

