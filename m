Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934286AbeGCRXW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 01A164078B91
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E18D81117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 22/25] xfs: use ->t_firstblock in reflink cow block cancel
Date: Tue,  3 Jul 2018 13:23:16 -0400
Message-Id: <20180703172319.24509-23-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cf6080d42273..d509bd7fa822 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -546,7 +546,6 @@ xfs_reflink_cancel_cow_blocks(
 	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec		got, del;
 	struct xfs_iext_cursor		icur;
-	xfs_fsblock_t			firstfsb;
 	struct xfs_defer_ops		dfops;
 	struct xfs_defer_ops		*odfops = (*tpp)->t_dfops;
 	int				error = 0;
@@ -575,7 +574,7 @@ xfs_reflink_cancel_cow_blocks(
 			if (error)
 				break;
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
-			xfs_defer_init(*tpp, &dfops, &firstfsb);
+			xfs_defer_init(*tpp, &dfops, &(*tpp)->t_firstblock);
 
 			/* Free the CoW orphan record. */
 			error = xfs_refcount_free_cow_extent(ip->i_mount,
-- 
2.17.1

