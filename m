Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47690 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbeBEXXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 18:23:06 -0500
Subject: [PATCH 6/7] xfs_scrub: always init phase information
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Feb 2018 15:23:02 -0800
Message-ID: <151787298265.3743.11278867933485186707.stgit@magnolia>
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

Make sure we initialize the overall phase state before we start
executing any code that can end up in the report-status-and-exit paths.
Otherwise if debugging is turned on we get garbage io/cpu stat reports.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 6efcf77..89b7fa0 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -618,6 +618,11 @@ main(
 	if (getenv("SERVICE_MODE"))
 		is_service = true;
 
+	/* Initialize overall phase stats. */
+	moveon = phase_start(&all_pi, 0, NULL);
+	if (!moveon)
+		return SCRUB_RET_OPERROR;
+
 	/* Find the mount record for the passed-in argument. */
 	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
 		fprintf(stderr,
@@ -641,11 +646,6 @@ main(
 			mtab = _PATH_MOUNTED;
 	}
 
-	/* Initialize overall phase stats. */
-	moveon = phase_start(&all_pi, 0, NULL);
-	if (!moveon)
-		goto out;
-
 	ismnt = find_mountpoint(mtab, &ctx);
 	if (!ismnt) {
 		fprintf(stderr,

