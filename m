Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52382 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161105AbeCATN0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 14:13:26 -0500
Subject: [PATCH 04/16] xfs_scrub: don't ask user to run xfs_repair for only
 warnings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Mar 2018 11:13:20 -0800
Message-ID: <151993160036.22223.2742740914776483127.stgit@magnolia>
In-Reply-To: <151993157539.22223.6269629008244777191.stgit@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

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

