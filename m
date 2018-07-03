Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934278AbeGCRXW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BAF5681A4EAD
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4AC41117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 20/25] xfs: use ->t_firstblock in dq alloc
Date: Tue,  3 Jul 2018 13:23:14 -0400
Message-Id: <20180703172319.24509-21-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 84359eeb20f4..3b61b4d266b4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -540,14 +540,13 @@ xfs_qm_dqread_alloc(
 	struct xfs_trans	*tp;
 	struct xfs_defer_ops	dfops;
 	struct xfs_buf		*bp;
-	xfs_fsblock_t		firstblock;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
 			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
 	if (error)
 		goto err;
-	xfs_defer_init(tp, &dfops, &firstblock);
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 
 	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
 	if (error)
-- 
2.17.1

