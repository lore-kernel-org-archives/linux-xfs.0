Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29352 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751354AbeFEGYc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 02:24:32 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-00022a-TB
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-0001JN-S1
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: verify root inode more thoroughly
Date: Tue,  5 Jun 2018 16:24:22 +1000
Message-Id: <20180605062423.4877-6-david@fromorbit.com>
In-Reply-To: <20180605062423.4877-1-david@fromorbit.com>
References: <20180605062423.4877-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When looking up the root inode at mount time, we don't actually do
any verification to check that the inode is allocated and accounted
for correctly in the INOBT. Make the checks on the root inode more
robust by making it an untrusted lookup. This forces the inode
lookup to use the inode btree to verify the inode is allocated
and mapped correctly to disk. This will also have the effect of
catching a significant number of AGI/INOBT related corruptions in
AG 0 at mount time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 189fa7b615d3..a3378252baa1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -862,9 +862,12 @@ xfs_mountfs(
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
 	 */
-	error = xfs_iget(mp, NULL, sbp->sb_rootino, 0, XFS_ILOCK_EXCL, &rip);
+	error = xfs_iget(mp, NULL, sbp->sb_rootino, XFS_IGET_UNTRUSTED,
+			 XFS_ILOCK_EXCL, &rip);
 	if (error) {
-		xfs_warn(mp, "failed to read root inode");
+		xfs_warn(mp,
+			"Failed to read root inode 0x%llx, error %d",
+			sbp->sb_rootino, -error);
 		goto out_log_dealloc;
 	}
 
-- 
2.17.0

