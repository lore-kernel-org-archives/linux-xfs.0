Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:32942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731760AbeGSOcg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:32:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B2104002592
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7743A1C5B0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 09/14] xfs: use internal dfops in cow blocks cancel
Date: Thu, 19 Jul 2018 09:49:14 -0400
Message-Id: <20180719134919.29939-10-bfoster@redhat.com>
In-Reply-To: <20180719134919.29939-1-bfoster@redhat.com>
References: <20180719134919.29939-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All callers either explicitly initialize a dfops or pass a
transaction with an internal dfops. Drop the hacky old dfops
replacement logic and use the one associated with the transaction.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3143889097f1..276deb8ca531 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -483,8 +483,6 @@ xfs_reflink_cancel_cow_blocks(
 	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec		got, del;
 	struct xfs_iext_cursor		icur;
-	struct xfs_defer_ops		dfops;
-	struct xfs_defer_ops		*odfops = (*tpp)->t_dfops;
 	int				error = 0;
 
 	if (!xfs_is_reflink_inode(ip))
@@ -511,7 +509,8 @@ xfs_reflink_cancel_cow_blocks(
 			if (error)
 				break;
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
-			xfs_defer_init(*tpp, &dfops);
+			ASSERT((*tpp)->t_dfops &&
+			       (*tpp)->t_firstblock == NULLFSBLOCK);
 
 			/* Free the CoW orphan record. */
 			error = xfs_refcount_free_cow_extent(ip->i_mount,
@@ -553,7 +552,6 @@ xfs_reflink_cancel_cow_blocks(
 	/* clear tag if cow fork is emptied */
 	if (!ifp->if_bytes)
 		xfs_inode_clear_cowblocks_tag(ip);
-	(*tpp)->t_dfops = odfops;
 	return error;
 }
 
-- 
2.17.1

