Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751372AbeCORpZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 13:45:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2F804079F2C
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 17:45:24 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/2] xfs_repair: add flag -e to detect corrected errors
Date: Thu, 15 Mar 2018 18:45:20 +0100
Message-Id: <20180315174521.33897-1-jtulak@redhat.com>
In-Reply-To: <20180305150546.32191-1-jtulak@redhat.com>
References: <20180305150546.32191-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

xfs_repair ends with a return code 0 if it finished ok, no matter if
there were some errors in the fs, or not. The new flag -e means that we
can avoid screenscraping and parsing text output to detect if an error
was found (and corrected).

If something could not be corrected or in any other case than the "found
something but fixed it all," the behaviour with this flag is unchanged.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 man/man8/xfs_repair.8 | 14 ++++++++++----
 repair/xfs_repair.c   | 17 +++++++++++++++--
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 85e4dc97..1b197571 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -4,7 +4,7 @@ xfs_repair \- repair an XFS filesystem
 .SH SYNOPSIS
 .B xfs_repair
 [
-.B \-dfLnPv
+.B \-defLnPv
 ] [
 .B \-m
 .I maxmem
@@ -168,6 +168,9 @@ Repair dangerously. Allow
 to repair an XFS filesystem mounted read only. This is typically done
 on a root filesystem from single user mode, immediately followed by a reboot.
 .TP
+.B \-e
+If any error was found and repaired, the exit code is 3 instead of the usual 0.
+.TP
 .B \-V
 Prints the version number and exits.
 .SS Checks Performed
@@ -512,14 +515,17 @@ will return a status of 1 if filesystem corruption was detected and
 0 if no filesystem corruption was detected.
 .B xfs_repair
 run without the \-n option will always return a status code of 0 if
-it completes without problems.  If a runtime error is encountered
-during operation, it will return a status of 1.  In this case,
+it completes without problems, unless the flag
+.B -e
+is used. If it is used, then status code 3 is reported when any issue with the
+filesystem was found, but could be fixed. If a runtime error is encountered during
+operation, it will return a status of 1. In this case,
 .B xfs_repair
 should be restarted.  If
 .B xfs_repair is unable
 to proceed due to a dirty log, it will return a status of 2.  See below.
 .SH DIRTY LOGS
-Due to the design of the XFS log, a dirty log can only be replayed 
+Due to the design of the XFS log, a dirty log can only be replayed
 by the kernel, on a machine having the same CPU architecture as the
 machine which was writing to the log.
 .B xfs_repair
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 312a0d08..94015da6 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -77,6 +77,7 @@ static char *c_opts[] = {
 static int	bhash_option_used;
 static long	max_mem_specified;	/* in megabytes */
 static int	phase2_threads = 32;
+static int report_corrected = 0;
 
 static void
 usage(void)
@@ -97,6 +98,7 @@ usage(void)
 "  -o subopts   Override default behaviour, refer to man page.\n"
 "  -t interval  Reporting interval in seconds.\n"
 "  -d           Repair dangerously.\n"
+"  -e           Exit with a non-zero code even when all errors were repaired.\n"
 "  -V           Reports version and exits.\n"), progname);
 	exit(1);
 }
@@ -214,12 +216,13 @@ process_args(int argc, char **argv)
 	ag_stride = 0;
 	thread_count = 1;
 	report_interval = PROG_RPT_DEFAULT;
+	report_corrected = 0;
 
 	/*
 	 * XXX have to add suboption processing here
 	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
 	 */
-	while ((c = getopt(argc, argv, "c:o:fl:m:r:LnDvVdPt:")) != EOF)  {
+	while ((c = getopt(argc, argv, "c:o:fl:m:r:LnDvVdPet:")) != EOF)  {
 		switch (c) {
 		case 'D':
 			dumpcore = 1;
@@ -329,6 +332,9 @@ process_args(int argc, char **argv)
 		case 't':
 			report_interval = (int)strtol(optarg, NULL, 0);
 			break;
+		case 'e':
+			report_corrected = 1;
+			break;
 		case '?':
 			usage();
 		}
@@ -1096,5 +1102,12 @@ _("Repair of readonly mount complete.  Immediate reboot encouraged.\n"));
 
 	free(msgbuf);
 
-	return (0);
+	if (report_corrected) {
+		if (fs_is_dirty)
+			return (3);
+		else
+			return (0);
+	} else {
+		return (0);
+	}
 }
-- 
2.15.0

