Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935622AbeF1Qgm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6403BD1447
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F95C111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 23/24] xfs: use ->t_dfops in reflink cow recover path
Date: Thu, 28 Jun 2018 12:36:35 -0400
Message-Id: <20180628163636.52564-24-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use ->t_dfops of the leftover COW reservation cleanup transaction.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 8e330a196060..df67821fb5f4 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1692,18 +1692,19 @@ xfs_refcount_recover_cow_leftovers(
 
 		/* Free the orphan record */
 		xfs_defer_init(&dfops, &fsb);
+		tp->t_dfops = &dfops;
 		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
 		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
-		error = xfs_refcount_free_cow_extent(mp, &dfops, fsb,
+		error = xfs_refcount_free_cow_extent(mp, tp->t_dfops, fsb,
 				rr->rr_rrec.rc_blockcount);
 		if (error)
 			goto out_defer;
 
 		/* Free the block. */
-		xfs_bmap_add_free(mp, &dfops, fsb,
+		xfs_bmap_add_free(mp, tp->t_dfops, fsb,
 				rr->rr_rrec.rc_blockcount, NULL);
 
-		error = xfs_defer_finish(&tp, &dfops);
+		error = xfs_defer_finish(&tp, tp->t_dfops);
 		if (error)
 			goto out_defer;
 
@@ -1717,7 +1718,7 @@ xfs_refcount_recover_cow_leftovers(
 
 	return error;
 out_defer:
-	xfs_defer_cancel(&dfops);
+	xfs_defer_cancel(tp->t_dfops);
 out_trans:
 	xfs_trans_cancel(tp);
 out_free:
-- 
2.17.1

