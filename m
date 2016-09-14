Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 041677CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 10:20:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C88BE8F8040
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 08:20:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QVzHBAz626aYyP4T (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Sep 2016 08:20:13 -0700 (PDT)
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 2/3] xfs_quota: print and path output formatting: maintain
	reverse compatibility
Date: Wed, 14 Sep 2016 10:19:40 -0500
Message-Id: <1473866381-28975-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1473866381-28975-1-git-send-email-billodo@redhat.com>
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

This patch adjusts the formatting of the xfs_quota print and
path outputs, in order to maintain reverse compatability:
when -f flag isn't used, need to keep the output same as in
previous version.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 quota/path.c | 67 +++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/quota/path.c b/quota/path.c
index aa3d33e..ed9c044 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -36,39 +36,50 @@ printpath(
 	int		c;
 
 	if (index == 0) {
-		printf(_("%sFilesystem          Pathname\n"),
-			number ? _("      ") : "");
+		if (foreign_allowed)
+			printf(_("%s    Filesystem          Pathname\n"),
+			       number ? _("      ") : "");
+		else
+			printf(_("%sFilesystem          Pathname\n"),
+			       number ? _("      ") : "");
 	}
 	if (number) {
 		printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
 	}
-	printf("%s ", (path->fs_flags & FS_FOREIGN) ? "(F)" : "   ");
-	printf(_("%-19s %s"), path->fs_dir, path->fs_name);
-	if (path->fs_flags & FS_PROJECT_PATH) {
-		prj = getprprid(path->fs_prid);
-		printf(_(" (project %u"), path->fs_prid);
-		if (prj)
-			printf(_(", %s"), prj->pr_name);
-		printf(")");
-	} else if (xfsquotactl(XFS_GETQSTAT, path->fs_name, 0, 0,
-				(void *)&qstat) == 0 && qstat.qs_flags) {
-		c = 0;
-		printf(" (");
-		if (qstat.qs_flags & XFS_QUOTA_UDQ_ENFD)
-			c = printf("uquota");
-		else if (qstat.qs_flags & XFS_QUOTA_UDQ_ACCT)
-			c = printf("uqnoenforce");
-		if (qstat.qs_flags & XFS_QUOTA_GDQ_ENFD)
-			c = printf("%sgquota", c ? ", " : "");
-		else if (qstat.qs_flags & XFS_QUOTA_GDQ_ACCT)
-			c = printf("%sgqnoenforce", c ? ", " : "");
-		if (qstat.qs_flags & XFS_QUOTA_PDQ_ENFD)
-			printf("%spquota", c ? ", " : "");
-		else if (qstat.qs_flags & XFS_QUOTA_PDQ_ACCT)
-			printf("%spqnoenforce", c ? ", " : "");
-		printf(")");
+	if (!((path->fs_flags & FS_FOREIGN) && !foreign_allowed)) {
+		printf("%s", (path->fs_flags & FS_FOREIGN) ? "(F) " : "");
+		if (path->fs_flags & FS_FOREIGN)
+			printf(_("%-19s %s"), path->fs_dir, path->fs_name);
+		else if (foreign_allowed)
+			printf(_("    %-19s %s"), path->fs_dir, path->fs_name);
+		else
+			printf(_("%-19s %s"), path->fs_dir, path->fs_name);
+		if (path->fs_flags & FS_PROJECT_PATH) {
+			prj = getprprid(path->fs_prid);
+			printf(_(" (project %u"), path->fs_prid);
+			if (prj)
+				printf(_(", %s"), prj->pr_name);
+			printf(")");
+		} else if (xfsquotactl(XFS_GETQSTAT, path->fs_name, 0, 0,
+				       (void *)&qstat) == 0 && qstat.qs_flags) {
+			c = 0;
+			printf(" (");
+			if (qstat.qs_flags & XFS_QUOTA_UDQ_ENFD)
+				c = printf("uquota");
+			else if (qstat.qs_flags & XFS_QUOTA_UDQ_ACCT)
+				c = printf("uqnoenforce");
+			if (qstat.qs_flags & XFS_QUOTA_GDQ_ENFD)
+				c = printf("%sgquota", c ? ", " : "");
+			else if (qstat.qs_flags & XFS_QUOTA_GDQ_ACCT)
+				c = printf("%sgqnoenforce", c ? ", " : "");
+			if (qstat.qs_flags & XFS_QUOTA_PDQ_ENFD)
+				printf("%spquota", c ? ", " : "");
+			else if (qstat.qs_flags & XFS_QUOTA_PDQ_ACCT)
+				printf("%spqnoenforce", c ? ", " : "");
+			printf(")");
+		}
+		printf("\n");
 	}
-	printf("\n");
 }
 
 static int
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
