Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60112 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeGaFeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 01:34:06 -0400
Subject: [PATCH 2/4] libxfs: add more bounds checking to sb sanity checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 30 Jul 2018 20:55:50 -0700
Message-ID: <153300935012.5164.595072325880690471.stgit@magnolia>
In-Reply-To: <153300933773.5164.7520087911614107147.stgit@magnolia>
References: <153300933773.5164.7520087911614107147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Bill O'Donnell <billodo@redhat.com>

From: Bill O'Donnell <billodo@redhat.com>

Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
Add sanity checks for these parameters.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
[darrick: port to refactored sb validation predicates]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f3835e923893..3d29f4a5242f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -150,6 +150,18 @@ xfs_validate_sb_write(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	/*
+	 * Carry out additional sb summary counter sanity checks when we write
+	 * the superblock.  We skip this in the read validator because there
+	 * could be newer superblocks in the log and if the values are garbage
+	 * we'll recalculate them at the end of log mount.
+	 */
+	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
+	    sbp->sb_ifree > sbp->sb_icount) {
+		xfs_warn(mp, "SB summary counter sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
 	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
 		return 0;
 

