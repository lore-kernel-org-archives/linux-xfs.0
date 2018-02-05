Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbeBEXXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 18:23:12 -0500
Subject: [PATCH 7/7] xfs_scrub: refactor outcome display into a separate
 helper
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Feb 2018 15:23:08 -0800
Message-ID: <151787298870.3743.17315196925370109109.stgit@magnolia>
In-Reply-To: <151787293446.3743.11110014829952400444.stgit@magnolia>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move all the printing of the scrub outcome into a separate helper to
declutter the main function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub.c |   48 ++++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 18 deletions(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 89b7fa0..fdd35df 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -493,6 +493,34 @@ _("Scrub aborted after phase %d."),
 	return moveon;
 }
 
+static void
+report_outcome(
+	struct scrub_ctx	*ctx)
+{
+	unsigned long long	total_errors;
+
+	total_errors = ctx->errors_found + ctx->runtime_errors;
+
+	if (total_errors == 0 && ctx->warnings_found == 0)
+		return;
+
+	if (total_errors == 0)
+		fprintf(stderr, _("%s: warnings found: %llu."), ctx->mntpoint,
+				ctx->warnings_found);
+	else if (ctx->warnings_found == 0)
+		fprintf(stderr, _("%s: errors found: %llu."), ctx->mntpoint,
+				total_errors);
+	else
+		fprintf(stderr, _("%s: errors found: %llu; warnings found: %llu."),
+				ctx->mntpoint, total_errors,
+				ctx->warnings_found);
+
+	if (ctx->need_repair)
+		fprintf(stderr, "  %s\n", _("Unmount and run xfs_repair."));
+	else
+		fprintf(stderr, "\n");
+}
+
 int
 main(
 	int			argc,
@@ -501,9 +529,7 @@ main(
 	struct scrub_ctx	ctx = {0};
 	struct phase_rusage	all_pi;
 	char			*mtab = NULL;
-	char			*repairstr = "";
 	FILE			*progress_fp = NULL;
-	unsigned long long	total_errors;
 	bool			moveon = true;
 	bool			ismnt;
 	int			c;
@@ -692,22 +718,8 @@ _("%s: Not a XFS mount point or block device.\n"),
 		ctx.runtime_errors++;
 
 out:
-	total_errors = ctx.errors_found + ctx.runtime_errors;
-	if (ctx.need_repair)
-		repairstr = _("  Unmount and run xfs_repair.");
-	if (total_errors && ctx.warnings_found)
-		fprintf(stderr,
-_("%s: %llu errors and %llu warnings found.%s\n"),
-			ctx.mntpoint, total_errors, ctx.warnings_found,
-			repairstr);
-	else if (total_errors && ctx.warnings_found == 0)
-		fprintf(stderr,
-_("%s: %llu errors found.%s\n"),
-			ctx.mntpoint, total_errors, repairstr);
-	else if (total_errors == 0 && ctx.warnings_found)
-		fprintf(stderr,
-_("%s: %llu warnings found.\n"),
-			ctx.mntpoint, ctx.warnings_found);
+	report_outcome(&ctx);
+
 	if (ctx.errors_found) {
 		if (ctx.error_action == ERRORS_SHUTDOWN)
 			xfs_shutdown_fs(&ctx);

