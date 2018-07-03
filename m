Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934169AbeGCRXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 931524078B8F
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E1871117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 10/25] xfs: use ->t_firstblock in insert/collapse range
Date: Tue,  3 Jul 2018 13:23:04 -0400
Message-Id: <20180703172319.24509-11-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b49364779966..b690def4962b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1310,7 +1310,6 @@ xfs_collapse_file_space(
 	struct xfs_trans	*tp;
 	int			error;
 	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t		first_block;
 	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
 	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
@@ -1343,9 +1342,9 @@ xfs_collapse_file_space(
 			goto out_trans_cancel;
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		xfs_defer_init(tp, &dfops, &first_block);
+		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
-				&done, &first_block);
+				&done, &tp->t_firstblock);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1386,7 +1385,6 @@ xfs_insert_file_space(
 	struct xfs_trans	*tp;
 	int			error;
 	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t		first_block;
 	xfs_fileoff_t		stop_fsb = XFS_B_TO_FSB(mp, offset);
 	xfs_fileoff_t		next_fsb = NULLFSBLOCK;
 	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
@@ -1422,9 +1420,9 @@ xfs_insert_file_space(
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_defer_init(tp, &dfops, &first_block);
+		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
-				&done, stop_fsb, &first_block);
+				&done, stop_fsb, &tp->t_firstblock);
 		if (error)
 			goto out_bmap_cancel;
 
-- 
2.17.1

