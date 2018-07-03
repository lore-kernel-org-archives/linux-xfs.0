Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933666AbeGCRXW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D1CA9BB7D
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08F471117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 23/25] xfs: use ->t_firstblock in extent swap
Date: Tue,  3 Jul 2018 13:23:17 -0400
Message-Id: <20180703172319.24509-24-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6d2baf51fec9..96810bea07fd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1569,7 +1569,6 @@ xfs_swap_extent_rmap(
 	xfs_fileoff_t			offset_fsb;
 	xfs_fileoff_t			end_fsb;
 	xfs_filblks_t			count_fsb;
-	xfs_fsblock_t			firstfsb;
 	int				error;
 	xfs_filblks_t			ilen;
 	xfs_filblks_t			rlen;
@@ -1605,7 +1604,7 @@ xfs_swap_extent_rmap(
 
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
-			xfs_defer_init(tp, tp->t_dfops, &firstfsb);
+			xfs_defer_init(tp, tp->t_dfops, &tp->t_firstblock);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
 			/* Read extent from the source file */
@@ -1847,7 +1846,6 @@ xfs_swap_extents(
 	struct xfs_ifork	*cowfp;
 	uint64_t		f;
 	int			resblks = 0;
-	xfs_fsblock_t		firstfsb;
 
 	/*
 	 * Lock the inodes against other IO, page faults and truncate to
@@ -1910,7 +1908,7 @@ xfs_swap_extents(
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
 		goto out_unlock;
-	xfs_defer_init(tp, &dfops, &firstfsb);
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 
 	/*
 	 * Lock and join the inodes to the tansaction so that transaction commit
-- 
2.17.1

