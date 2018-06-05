Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25035 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751398AbeFEC5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 22:57:07 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQ29g-0001nB-BM
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 12:57:04 +1000
Date: Tue, 5 Jun 2018 12:57:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/3] xfs: verify root inode more thoroughly
Message-ID: <20180605025704.GZ10363@dastard>
References: <20180605024313.18737-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605024313.18737-1-david@fromorbit.com>
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
 
