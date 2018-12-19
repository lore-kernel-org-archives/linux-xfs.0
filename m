Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48234 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbeLSTaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 14:30:11 -0500
Subject: [PATCH 5/8] xfs_scrub: use data/rtdev parallelization estimates for
 the read-verify pool
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 19 Dec 2018 11:30:05 -0800
Message-ID: <154524780496.28646.2648041743792188824.stgit@magnolia>
In-Reply-To: <154524776457.28646.3004453037075812416.stgit@magnolia>
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we use the same read-verify pool object to dispatch file data read
requests for both the data device and the realtime device, we should
create enough IO threads to handle the estimated parallelization of both
devices, not just the data device.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index ead48d77..cbda9b53 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -435,6 +435,22 @@ xfs_check_rmap(
 	return true;
 }
 
+/*
+ * Estimate the amount of parallelization possible for scanning file data on
+ * the data and realtime devices.
+ */
+static unsigned int
+phase6_threads(
+	struct scrub_ctx	*ctx)
+{
+	unsigned int		nr = disk_heads(ctx->datadev);
+
+	if (ctx->rtdev)
+		nr += disk_heads(ctx->rtdev);
+
+	return nr > nproc ? nproc : nr;
+}
+
 /*
  * Read verify all the file data blocks in a filesystem.  Since XFS doesn't
  * do data checksums, we trust that the underlying storage will pass back
@@ -469,7 +485,7 @@ xfs_scan_blocks(
 	}
 
 	ve.readverify = read_verify_pool_init(ctx, ctx->geo.blocksize,
-			xfs_check_rmap_ioerr, disk_heads(ctx->datadev));
+			xfs_check_rmap_ioerr, phase6_threads(ctx));
 	if (!ve.readverify) {
 		moveon = false;
 		str_info(ctx, ctx->mntpoint,
@@ -525,7 +541,7 @@ xfs_estimate_verify_work(
 		return moveon;
 
 	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->blocklog;
-	*nr_threads = disk_heads(ctx->datadev);
+	*nr_threads = phase6_threads(ctx);
 	*rshift = 20;
 	return moveon;
 }
