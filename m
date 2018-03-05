Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30672 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752341AbeCEELW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Mar 2018 23:11:22 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eshT6-00065q-9t
        for linux-xfs@vger.kernel.org; Mon, 05 Mar 2018 15:11:20 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1eshT6-00016p-6W
        for linux-xfs@vger.kernel.org; Mon, 05 Mar 2018 15:11:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix transaction allocation deadlock in IO path
Date: Mon,  5 Mar 2018 15:11:20 +1100
Message-Id: <20180305041120.4224-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_trans_alloc() does GFP_KERNEL allocation, and we can call it
while holding pages locked for writeback in the ->writepages path.
The memory allocation is allowed to wait on pages under writeback,
and so can wait on pages that are held locked in writeback by the
caller.

This affects both pre-IO submission and post-IO submission paths.
Hence xfs_setsize_trans_alloc(), xfs_reflink_end_cow(),
xfs_iomap_write_unwritten() and xfs_reflink_cancel_cow_range().
xfs_iomap_write_unwritten() already does the right thing, but the
others don't. Fix them.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c    | 3 ++-
 fs/xfs/xfs_reflink.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9c6a830da0ee..a0afb6411417 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -209,7 +209,8 @@ xfs_setfilesize_trans_alloc(
 	struct xfs_trans	*tp;
 	int			error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0,
+				XFS_TRANS_NOFS, &tp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 270246943a06..8c16177b33d4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -668,7 +668,7 @@ xfs_reflink_cancel_cow_range(
 
 	/* Start a rolling transaction to remove the mappings */
 	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
-			0, 0, 0, &tp);
+			0, 0, XFS_TRANS_NOFS, &tp);
 	if (error)
 		goto out;
 
@@ -741,7 +741,7 @@ xfs_reflink_end_cow(
 			(unsigned int)(end_fsb - offset_fsb),
 			XFS_DATA_FORK);
 	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
-			resblks, 0, XFS_TRANS_RESERVE, &tp);
+			resblks, 0, XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
 	if (error)
 		goto out;
 
-- 
2.16.1

