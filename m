Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:28:50 -0400
Subject: [PATCH 4/6] mkfs: validate start and end of aligned logs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Jun 2019 12:28:40 -0700
Message-ID: <155993572084.2343365.4641516689067243354.stgit@magnolia>
In-Reply-To: <155993569512.2343365.15510991248022865602.stgit@magnolia>
References: <155993569512.2343365.15510991248022865602.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate that the start and end of the log stay within a single AG if
we adjust either end to align to stripe units.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ddb25ecc..468b8fde 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3033,15 +3033,28 @@ align_internal_log(
 	struct xfs_mount	*mp,
 	int			sunit)
 {
+	uint64_t		logend;
+
 	/* round up log start if necessary */
 	if ((cfg->logstart % sunit) != 0)
 		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
 
+	/* If our log start overlaps the next AG's metadata, fail. */
+	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
+			fprintf(stderr,
+_("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
+  "within an allocation group.\n"),
+			(long long) cfg->logstart);
+		usage();
+	}
+
 	/* round up/down the log size now */
 	align_log_size(cfg, sunit);
 
 	/* check the aligned log still fits in an AG. */
-	if (cfg->logblocks > cfg->agsize - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {
+	logend = cfg->logstart + cfg->logblocks - 1;
+	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend) ||
+	    !xfs_verify_fsbno(mp, logend)) {
 		fprintf(stderr,
 _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
   "Must fit within an allocation group.\n"),
