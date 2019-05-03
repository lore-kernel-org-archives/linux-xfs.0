Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfECDxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 May 2019 23:53:35 -0400
Date: Thu, 2 May 2019 20:53:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] mkfs: validate start and end of aligned logs
Message-ID: <20190503035312.GP5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate that the start and end of the log stay within a single AG if
we adjust either end to align to stripe units.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3ca8c9dc..0862621a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3070,11 +3070,20 @@ align_internal_log(
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
+	if (!xfs_verify_fsbno(mp, cfg->logstart + cfg->logblocks - 1)) {
 		fprintf(stderr,
 _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
   "Must fit within an allocation group.\n"),
