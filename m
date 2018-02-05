Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752787AbeBERqD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:46:03 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5E41285543
        for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2018 17:46:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F4135D6A2
        for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2018 17:46:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] xfs: account format bouncing into rmapbt swapext tx reservation
Date: Mon,  5 Feb 2018 12:45:59 -0500
Message-Id: <20180205174601.51574-3-bfoster@redhat.com>
In-Reply-To: <20180205174601.51574-1-bfoster@redhat.com>
References: <20180205174601.51574-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The extent swap mechanism requires a unique implementation for
rmapbt enabled filesystems. Because the rmapbt tracks extent owner
information, extent swap must individually unmap and remap each
extent between the two inodes.

The rmapbt extent swap transaction block reservation currently
accounts for the worst case bmapbt block and rmapbt block
consumption based on the extent count of each inode. There is a
corner case that exists due to the extent swap implementation that
is not covered by this reservation, however.

If one of the associated inodes is just over the max extent count
used for extent format inodes (i.e., the inode is in btree format by
a single extent), the unmap/remap cycle of the extent swap can
bounce the inode between extent and btree format multiple times,
almost as many times as there are extents in the inode (if the
opposing inode happens to have one less, for example). Each back and
forth cycle involves a block free and allocation, which isn't a
problem except for that the initial transaction reservation must
account for the total number of block allocations performed by the
chain of deferred operations. If not, a block reservation overrun
occurs and the filesystem shuts down.

Update the rmapbt extent swap block reservation to check for this
situation and add some block reservation slop to ensure the entire
operation succeeds. We'd never likely require reservation for both
inodes as fsr wouldn't defrag the file in that case, but the
additional reservation is constrained by the data fork size so be
cautious and check for both.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c83f549dc17b..e0a442f504e5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1899,17 +1899,28 @@ xfs_swap_extents(
 	 * performed with log redo items!
 	 */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		int		w	= XFS_DATA_FORK;
+		uint32_t	ipnext	= XFS_IFORK_NEXTENTS(ip, w);
+		uint32_t	tipnext	= XFS_IFORK_NEXTENTS(tip, w);
+
+		/*
+		 * Conceptually this shouldn't affect the shape of either bmbt,
+		 * but since we atomically move extents one by one, we reserve
+		 * enough space to rebuild both trees.
+		 */
+		resblks = XFS_SWAP_RMAP_SPACE_RES(mp, ipnext, w);
+		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
+
 		/*
-		 * Conceptually this shouldn't affect the shape of either
-		 * bmbt, but since we atomically move extents one by one,
-		 * we reserve enough space to rebuild both trees.
+		 * Handle the corner case where either inode might straddle the
+		 * btree format boundary. If so, the inode could bounce between
+		 * btree <-> extent format on unmap -> remap cycles, freeing and
+		 * allocating a bmapbt block each time.
 		 */
-		resblks = XFS_SWAP_RMAP_SPACE_RES(mp,
-				XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK),
-				XFS_DATA_FORK) +
-			  XFS_SWAP_RMAP_SPACE_RES(mp,
-				XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK),
-				XFS_DATA_FORK);
+		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
+			resblks += XFS_IFORK_MAXEXT(ip, w);
+		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
+			resblks += XFS_IFORK_MAXEXT(tip, w);
 	}
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
-- 
2.13.6

