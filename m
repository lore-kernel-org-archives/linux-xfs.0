Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37596 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfETXR7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:17:59 -0400
Subject: [PATCH 11/12] mkfs: validate start and end of aligned logs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 16:17:54 -0700
Message-ID: <155839427473.68606.3900005341580158051.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
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
index 5b66074d..8f84536e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3044,15 +3044,28 @@ align_internal_log(
 	struct xfs_mount	*mp,
 	int			sunit)
 {
+	uint64_t		logend;
+
 	/* round up log start if necessary */
 	if ((cfg->logstart % sunit) != 0)
 		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
 
+	/* if our log start rounds into the next AG we're done */
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
