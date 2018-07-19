Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731764AbeGSOcg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:32:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A60D881663C8
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 925D81C5B0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 10/14] xfs: use internal dfops in attr code
Date: Thu, 19 Jul 2018 09:49:15 -0400
Message-Id: <20180719134919.29939-11-bfoster@redhat.com>
In-Reply-To: <20180719134919.29939-1-bfoster@redhat.com>
References: <20180719134919.29939-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Remove the unnecessary on-stack dfops structure and use the internal
transaction dfops instead. The lower level xattr code already
appropriately accesses ->t_dfops throughout.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 927d4c968f9a..66a22c80a0db 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -202,7 +202,6 @@ xfs_attr_set(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_buf		*leaf_bp = NULL;
 	struct xfs_da_args	args;
-	struct xfs_defer_ops	dfops;
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
 	int			error, err2, local;
@@ -251,7 +250,6 @@ xfs_attr_set(
 			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
 	if (error)
 		return error;
-	xfs_defer_init(args.trans, &dfops);
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
@@ -315,18 +313,18 @@ xfs_attr_set(
 		 */
 		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
 		if (error)
-			goto out_defer_cancel;
+			goto out;
 		/*
 		 * Prevent the leaf buffer from being unlocked so that a
 		 * concurrent AIL push cannot grab the half-baked leaf
 		 * buffer and run into problems with the write verifier.
 		 */
 		xfs_trans_bhold(args.trans, leaf_bp);
-		xfs_defer_bjoin(&dfops, leaf_bp);
-		xfs_defer_ijoin(&dfops, dp);
-		error = xfs_defer_finish(&args.trans, &dfops);
+		xfs_defer_bjoin(args.trans->t_dfops, leaf_bp);
+		xfs_defer_ijoin(args.trans->t_dfops, dp);
+		error = xfs_defer_finish(&args.trans, args.trans->t_dfops);
 		if (error)
-			goto out_defer_cancel;
+			goto out;
 
 		/*
 		 * Commit the leaf transformation.  We'll need another (linked)
@@ -366,8 +364,6 @@ xfs_attr_set(
 
 	return error;
 
-out_defer_cancel:
-	xfs_defer_cancel(&dfops);
 out:
 	if (leaf_bp)
 		xfs_trans_brelse(args.trans, leaf_bp);
@@ -389,7 +385,6 @@ xfs_attr_remove(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
-	struct xfs_defer_ops	dfops;
 	int			error;
 
 	XFS_STATS_INC(mp, xs_attr_remove);
@@ -422,7 +417,6 @@ xfs_attr_remove(
 			&args.trans);
 	if (error)
 		return error;
-	xfs_defer_init(args.trans, &dfops);
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	/*
-- 
2.17.1

