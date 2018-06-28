Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935617AbeF1Qgj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 489BA401DEB3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33AB9111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 22/24] xfs: use ->t_dfops in cancel cow blocks operation
Date: Thu, 28 Jun 2018 12:36:34 -0400
Message-Id: <20180628163636.52564-23-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use ->t_dfops of the transaction from the caller. Reset it before we
return to avoid leaks of local stack memory.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7cfe74d1514e..75a99bb020e4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -553,6 +553,7 @@ xfs_reflink_cancel_cow_blocks(
 	struct xfs_iext_cursor		icur;
 	xfs_fsblock_t			firstfsb;
 	struct xfs_defer_ops		dfops;
+	struct xfs_defer_ops		*odfops = (*tpp)->t_dfops;
 	int				error = 0;
 
 	if (!xfs_is_reflink_inode(ip))
@@ -580,23 +581,24 @@ xfs_reflink_cancel_cow_blocks(
 				break;
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
 			xfs_defer_init(&dfops, &firstfsb);
+			(*tpp)->t_dfops = &dfops;
 
 			/* Free the CoW orphan record. */
 			error = xfs_refcount_free_cow_extent(ip->i_mount,
-					&dfops, del.br_startblock,
+					(*tpp)->t_dfops, del.br_startblock,
 					del.br_blockcount);
 			if (error)
 				break;
 
-			xfs_bmap_add_free(ip->i_mount, &dfops,
+			xfs_bmap_add_free(ip->i_mount, (*tpp)->t_dfops,
 					del.br_startblock, del.br_blockcount,
 					NULL);
 
 			/* Roll the transaction */
-			xfs_defer_ijoin(&dfops, ip);
-			error = xfs_defer_finish(tpp, &dfops);
+			xfs_defer_ijoin((*tpp)->t_dfops, ip);
+			error = xfs_defer_finish(tpp, (*tpp)->t_dfops);
 			if (error) {
-				xfs_defer_cancel(&dfops);
+				xfs_defer_cancel((*tpp)->t_dfops);
 				break;
 			}
 
@@ -621,7 +623,7 @@ xfs_reflink_cancel_cow_blocks(
 	/* clear tag if cow fork is emptied */
 	if (!ifp->if_bytes)
 		xfs_inode_clear_cowblocks_tag(ip);
-
+	(*tpp)->t_dfops = odfops;
 	return error;
 }
 
-- 
2.17.1

