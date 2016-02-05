Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D4F17CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 22:47:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 718BF8F804B
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 20:47:36 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Ubvhinr1it9G5jcY for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 20:47:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRYIt-0000vf-NW
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 15:47:31 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRYIt-0000Rk-MZ
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 15:47:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] quota: report should not take arbitrary parameters
Date: Fri,  5 Feb 2016 15:47:31 +1100
Message-Id: <1454647651-1677-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The report command is not documented to take any parameters other
than what is needed to specify the behaviour. Ever since the initial
commit of the report command, usres have been able to specify extra
parameters to the report command, which it then tries to parse and
use as a path to report quotas on.

This is completely undocumented, either in the man pages, the help
text or the code, and is completely broken in many, many ways. Just
trying to work out how to make it work hurt my brain. e.g:

$ xfs_quota -x -c "report -p 1"

needs the extra parameter to be treated as a numeric project ID.

$ xfs_quota -x -c "report -p scratch"

needs the extra parameter to be treated as a project ID alias.

$ xfs_quota -x -c "report -p /mnt/scratch"

needs the extra parameter to be treated as a mount point.

$ xfs_quota -x -c "report -p /mnt/scratch/project-1"

needs the extra parameter to be treated as project path.

Then I started to get scared - what the hell is an incantation like
this supposed to do:

$ xfs_quota -x -c "report -ugp 1 foo /mnt/bar /mnt/scratch/project-1"

This will be accepted as valid and it will do /something/. Just what
is anyone's guess, so I'm thinking it's just dumb luck that an
xfs_quota user hasn't accidently summoned an Elder God With An
Unspeakable Name and caused the End Of The World As We Know It.

So to ensure that us poor XFS developers can retain some shred of
their remaining sanity, remove the extra command processing from the
report command and return an error message when this happens.. If we
need to report on a specific filesystem, then it's defined as part
of the main xfs_quota command line and so set up as the primary
fs_path that the report command will act on, such as:

$ xfs_quota -x -c "report -p" /mnt/scratch

If a user needs to get a report on a specific ID, then they can use
the upper and lower ID specification to define that.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 quota/report.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index e8e5d96..f660b41 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -30,8 +30,6 @@ static cmdinfo_t report_cmd;
 static void
 dump_help(void)
 {
-	dump_cmd.args = _("[-gpu] [-f file]");
-	dump_cmd.oneline = _("dump quota information for backup utilities");
 	printf(_(
 "\n"
 " create a backup file which contains quota limits information\n"
@@ -45,8 +43,6 @@ dump_help(void)
 static void
 report_help(void)
 {
-	report_cmd.args = _("[-bir] [-gpu] [-ahntlLNU] [-f file]");
-	report_cmd.oneline = _("report filesystem quota information");
 	printf(_(
 "\n"
 " report used space and inodes, and quota limits, for a filesystem\n"
@@ -695,6 +691,11 @@ report_f(
 		}
 	}
 
+	if (argc != optind) {
+		fprintf(stderr, "Error: Invalid arguments on command line!\n");
+		return command_usage(&report_cmd);
+	}
+
 	if (!form)
 		form = XFS_BLOCK_QUOTA;
 
@@ -707,17 +708,13 @@ report_f(
 	if ((fp = fopen_write_secure(fname)) == NULL)
 		return 0;
 
-	if (argc == optind) {
-		if (flags & ALL_MOUNTS_FLAG)
-			report_any_type(fp, form, type, NULL,
-					lower, upper, flags);
-		else if (fs_path && (fs_path->fs_flags & FS_MOUNT_POINT))
-			report_any_type(fp, form, type, fs_path->fs_dir,
-					lower, upper, flags);
-	} else while (argc > optind) {
-		report_any_type(fp, form, type, argv[optind++],
+
+	if (flags & ALL_MOUNTS_FLAG)
+		report_any_type(fp, form, type, NULL,
+				lower, upper, flags);
+	else if (fs_path && (fs_path->fs_flags & FS_MOUNT_POINT))
+		report_any_type(fp, form, type, fs_path->fs_dir,
 				lower, upper, flags);
-	}
 
 	if (fname)
 		fclose(fp);
@@ -741,7 +738,7 @@ report_init(void)
 	report_cmd.cfunc = report_f;
 	report_cmd.argmin = 0;
 	report_cmd.argmax = -1;
-	report_cmd.args = _("[-bir] [-gpu] [-ahnt] [-f file]");
+	report_cmd.args = _("[-bir] [-gpu] [-ahntlLNU] [-f file]");
 	report_cmd.oneline = _("report filesystem quota information");
 	report_cmd.help = report_help;
 	report_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
