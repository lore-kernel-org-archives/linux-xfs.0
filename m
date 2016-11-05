Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51724 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbcKEAK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:10:56 -0400
Subject: [PATCH 09/10] xfs: check return value of _trans_reserve_quota_nblks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:10:51 -0700
Message-ID: <147830465179.27129.2945083749679541980.stgit@birch.djwong.org>
In-Reply-To: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
References: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Check the return value of xfs_trans_reserve_quota_nblks for errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c6eb219..71dd6d7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4902,8 +4902,11 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	xfs_trans_reserve_quota_nblks(NULL, ip, -((long)del->br_blockcount), 0,
+	error = xfs_trans_reserve_quota_nblks(NULL, ip,
+			-((long)del->br_blockcount), 0,
 			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		return error;
 	ip->i_delayed_blks -= del->br_blockcount;
 
 	if (whichfork == XFS_COW_FORK)

