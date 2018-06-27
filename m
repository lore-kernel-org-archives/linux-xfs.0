Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58392 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbeF0Csg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 22:48:36 -0400
Subject: [PATCH 05/10] xfs_scrub: allow developers to force repairs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 Jun 2018 19:48:17 -0700
Message-ID: <153006769719.20121.5967943300879363502.stgit@magnolia>
In-Reply-To: <153006766483.20121.9285982017465570544.stgit@magnolia>
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we have an error injection knob in the kernel to simulate
corruptions, enable it in xfs_scrub so that developers can test all
the repair capabilities.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/scrub.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index af665c83..c893f2c9 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -612,14 +612,18 @@ __xfs_scrub_test(
 	bool				repair)
 {
 	struct xfs_scrub_metadata	meta = {0};
+	struct xfs_error_injection	inject;
 	static bool			injected;
 	int				error;
 
 	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
 		return false;
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
-		str_info(ctx, "XFS_SCRUB_FORCE_REPAIR", "Not supported.");
-		return false;
+		inject.fd = ctx->mnt_fd;
+		inject.errtag = XFS_ERRTAG_FORCE_SCRUB_REPAIR;
+		error = ioctl(ctx->mnt_fd, XFS_IOC_ERROR_INJECTION, &inject);
+		if (error == 0)
+			injected = true;
 	}
 
 	meta.sm_type = type;

