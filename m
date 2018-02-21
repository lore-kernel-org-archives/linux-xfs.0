Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49102 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbeBUDg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Feb 2018 22:36:59 -0500
Date: Tue, 20 Feb 2018 19:36:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_scrub: don't ask user to run xfs_repair for only warnings
Message-ID: <20180221033654.GI27629@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't advise the user to run xfs_repair on a filesystem that triggers
warnings but no errors; there's no corruption for it to fix.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index ab26e63..53a105a 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -514,7 +514,7 @@ report_outcome(
 		fprintf(stderr, _("%s: errors found: %llu; warnings found: %llu\n"),
 				ctx->mntpoint, total_errors,
 				ctx->warnings_found);
-	if (ctx->need_repair)
+	if (ctx->need_repair && total_errors > 0)
 		fprintf(stderr, _("%s: Unmount and run xfs_repair.\n"),
 				ctx->mntpoint);
 }
