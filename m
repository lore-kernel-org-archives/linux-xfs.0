Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbeG3HDl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 03:03:41 -0400
Subject: [PATCH 2/3] libxfs: add more bounds checking to sb sanity checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Jul 2018 22:30:21 -0700
Message-ID: <153292862122.19274.13281750487162777731.stgit@magnolia>
In-Reply-To: <153292860880.19274.14533449137039985963.stgit@magnolia>
References: <153292860880.19274.14533449137039985963.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Bill O'Donnell <billodo@redhat.com>

From: Bill O'Donnell <billodo@redhat.com>

Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
Add sanity checks for these parameters.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
[darrick: port to refactored sb validation predicates]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 516bef7b0f50..64bc471d57e6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -153,6 +153,18 @@ xfs_validate_sb_write(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	/*
+	 * Carry out additional sb sanity checks exclusively for writes.
+	 * We don't do these checks for reads, since faulty parameters could
+	 * be fixed in the log, and we shouldn't prohibit mounting for those
+	 * cases.
+	 */
+	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
+	    sbp->sb_ifree > sbp->sb_icount) {
+		xfs_warn(mp, "SB summary counter sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
 	if (!xfs_sb_version_hascrc(sbp))
 		return 0;
 

