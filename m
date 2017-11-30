Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751082AbdK3S6h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 13:58:37 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 968F45F73B
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2017 18:58:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AD0960C89
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2017 18:58:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 4/7] xfs: truncate transaction does not modify the inobt
Date: Thu, 30 Nov 2017 13:58:33 -0500
Message-Id: <20171130185836.18481-5-bfoster@redhat.com>
In-Reply-To: <20171130185836.18481-1-bfoster@redhat.com>
References: <20171130185836.18481-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The truncate transaction does not ever modify the inode btree, but
includes an associated log reservation. Update
xfs_calc_itruncate_reservation() to remove the reservation
associated with inobt updates.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 173b1bc13ffe..037a1295d289 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -232,8 +232,6 @@ xfs_calc_write_reservation(
  *    the super block to reflect the freed blocks: sector size
  *    worst case split in allocation btrees per extent assuming 4 extents:
  *		4 exts * 2 trees * (2 * max depth - 1) * block size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
 xfs_calc_itruncate_reservation(
@@ -245,12 +243,7 @@ xfs_calc_itruncate_reservation(
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
 		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
-				      XFS_FSB_TO_B(mp, 1)) +
-		    xfs_calc_buf_res(5, 0) +
-		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				     XFS_FSB_TO_B(mp, 1)) +
-		    xfs_calc_buf_res(2 + mp->m_ialloc_blks +
-				     mp->m_in_maxlevels, 0)));
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
-- 
2.13.6

