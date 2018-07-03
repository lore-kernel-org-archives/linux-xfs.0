Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934295AbeGCRXW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39DC181A6D23
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 248231117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 24/25] xfs: use ->t_firstblock in inode inactivate
Date: Tue,  3 Jul 2018 13:23:18 -0400
Message-Id: <20180703172319.24509-25-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5e1eaa26435c..48d22134b06f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1772,7 +1772,6 @@ xfs_inactive_ifree(
 	struct xfs_inode *ip)
 {
 	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t		first_block;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	int			error;
@@ -1809,7 +1808,7 @@ xfs_inactive_ifree(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_defer_init(tp, &dfops, &first_block);
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 	error = xfs_ifree(tp, ip);
 	if (error) {
 		/*
-- 
2.17.1

