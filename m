Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31502 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdFBTwZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 15:52:25 -0400
Subject: [PATCH 10/10] xfs_spaceman: add group summary mode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 12:52:17 -0700
Message-ID: <149643313776.15899.17808639449781969033.stgit@birch.djwong.org>
In-Reply-To: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a -g switch to show only a per-group summary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_spaceman.8 |    8 +++++++-
 spaceman/freesp.c       |   29 +++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 5 deletions(-)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index c1d19c0..a57a0c3 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -25,7 +25,7 @@ then the program exits.
 
 .SH COMMANDS
 .TP
-.BI "freesp [ \-sr ] [ \-b | \-e bsize | \-h h1 [ \-m bmult ]] [-a agno]"
+.BI "freesp [ \-srg ] [ \-b | \-e bsize | \-h h1 [ \-m bmult ]] [-a agno]"
 With no arguments,
 .B freesp
 shows a histogram of all free space extents in the filesystem.
@@ -49,6 +49,12 @@ option may be specified multiple times.
 A summary of free space information will be printed if the
 .B -s
 option is given.
+The
+.B -g
+option prints a brief per-AG summary of the free space found in that AG.
+If
+.B -r
+is specified it will also report on free space in the realtime device.
 .TP
 .BR "help [ " command " ]"
 Display a brief description of one or all commands.
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 2290a5e..351f0ce 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -42,6 +42,7 @@ static int		histcount;
 static int		multsize;
 static int		seen1;
 static int		summaryflag;
+static int		gflag;
 static bool		rtflag;
 static long long	totblocks;
 static long long	totexts;
@@ -159,6 +160,8 @@ scan_ag(
 	off64_t			bperag;
 	off64_t			aglen;
 	xfs_agblock_t		agbno;
+	unsigned long long	freeblks = 0;
+	unsigned long long	freeexts = 0;
 	int			ret;
 	int			i;
 
@@ -211,6 +214,8 @@ scan_ag(
 			agbno = (extent->fmr_physical - (bperag * agno)) /
 								blocksize;
 			aglen = extent->fmr_length / blocksize;
+			freeblks += aglen;
+			freeexts++;
 
 			addtohist(agno, agbno, aglen);
 		}
@@ -220,6 +225,15 @@ scan_ag(
 			break;
 		fsmap_advance(fsmap);
 	}
+
+	if (gflag) {
+		if (agno == NULLAGNUMBER)
+			printf(_("     rtdev %10llu %10llu\n"), freeexts,
+					freeblks);
+		else
+			printf(_("%10u %10llu %10llu\n"), agno, freeexts,
+					freeblks);
+	}
 }
 static void
 aglistadd(
@@ -244,7 +258,7 @@ init(
 	aglist = NULL;
 	hist = NULL;
 	rtflag = false;
-	while ((c = getopt(argc, argv, "a:bde:h:m:rs")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bde:gh:m:rs")) != EOF) {
 		switch (c) {
 		case 'a':
 			aglistadd(optarg);
@@ -264,6 +278,10 @@ init(
 			equalsize = atoi(optarg);
 			speced = 1;
 			break;
+		case 'g':
+			histcount = 0;
+			gflag++;
+			break;
 		case 'h':
 			if (speced && !histcount)
 				return 0;
@@ -306,13 +324,15 @@ freesp_f(
 
 	if (!init(argc, argv))
 		return 0;
+	if (gflag)
+		printf(_("        AG    extents     blocks\n"));
 	if (rtflag)
 		scan_ag(NULLAGNUMBER);
 	for (agno = 0; !rtflag && agno < file->geom.agcount; agno++)  {
 		if (inaglist(agno))
 			scan_ag(agno);
 	}
-	if (histcount)
+	if (histcount && !gflag)
 		printhist();
 	if (summaryflag) {
 		printf(_("total free extents %lld\n"), totexts);
@@ -334,12 +354,13 @@ freesp_help(void)
 "\n"
 "Examine filesystem free space\n"
 "\n"
-"Options: [-bdsr] [-a agno] [-e bsize] [-h h1]... [-m bmult]\n"
+"Options: [-bdgsr] [-a agno] [-e bsize] [-h h1]... [-m bmult]\n"
 "\n"
 " -a agno  -- Scan only the given AG agno.\n"
 " -b       -- binary histogram bin size\n"
 " -d       -- debug output\n"
 " -e bsize -- Use fixed histogram bin size of bsize\n"
+" -g       -- Print only a per-AG summary.\n"
 " -h hbsz  -- Use custom histogram bin size of h1.\n"
 "             Multiple specifications are allowed.\n"
 " -m bmult -- Use histogram bin size multiplier of bmult.\n"
@@ -357,7 +378,7 @@ freesp_init(void)
 	freesp_cmd.cfunc = freesp_f;
 	freesp_cmd.argmin = 0;
 	freesp_cmd.argmax = -1;
-	freesp_cmd.args = "[-bdsr] [-a agno] [-e bsize] [-h h1]... [-m bmult]";
+	freesp_cmd.args = "[-bdgsr] [-a agno] [-e bsize] [-h h1]... [-m bmult]";
 	freesp_cmd.flags = CMD_FLAG_ONESHOT;
 	freesp_cmd.oneline = _("Examine filesystem free space");
 	freesp_cmd.help = freesp_help;

