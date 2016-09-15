Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbcIOP35 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Sep 2016 11:29:57 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v2 2/3] xfs_quota: print and path output formatting: maintain reverse compatibility
Date: Thu, 15 Sep 2016 10:29:45 -0500
Message-Id: <1473953386-10242-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1473953386-10242-1-git-send-email-billodo@redhat.com>
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
 <1473953386-10242-1-git-send-email-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

This patch adjusts the formatting of the xfs_quota print and
path outputs, in order to maintain reverse compatability:
when -f flag isn't used, need to keep the output same as in
previous version.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 quota/path.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/quota/path.c b/quota/path.c
index 01ccab4..57d14f0 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -36,13 +36,14 @@ printpath(
 	int		c;
 
 	if (index == 0) {
-		printf(_("%sFilesystem          Pathname\n"),
-			number ? _("      ") : "");
+		printf(_("%s%sFilesystem          Pathname\n"),
+		       number ? _("      ") : "",
+		       foreign_allowed ? _("    ") : "");
 	}
-	if (number) {
+	if (number)
 		printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
-	}
-	printf("%s ", (path->fs_flags & FS_FOREIGN) ? "(F)" : "   ");
+	if (foreign_allowed)
+		printf("%s", (path->fs_flags & FS_FOREIGN) ? "(F) " : "    ");
 	printf(_("%-19s %s"), path->fs_dir, path->fs_name);
 	if (path->fs_flags & FS_PROJECT_PATH) {
 		prj = getprprid(path->fs_prid);
@@ -51,7 +52,7 @@ printpath(
 			printf(_(", %s"), prj->pr_name);
 		printf(")");
 	} else if (xfsquotactl(XFS_GETQSTAT, path->fs_name, 0, 0,
-				(void *)&qstat) == 0 && qstat.qs_flags) {
+			       (void *)&qstat) == 0 && qstat.qs_flags) {
 		c = 0;
 		printf(" (");
 		if (qstat.qs_flags & XFS_QUOTA_UDQ_ENFD)
-- 
2.7.4

