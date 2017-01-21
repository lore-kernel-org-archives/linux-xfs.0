Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20534 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbdAUIJI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:09:08 -0500
Subject: [PATCH 08/17] xfs_spaceman: add group summary mode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:08:57 -0800
Message-ID: <148498613711.16675.15774860273433058318.stgit@birch.djwong.org>
In-Reply-To: <148498608472.16675.14848042961636871812.stgit@birch.djwong.org>
References: <148498608472.16675.14848042961636871812.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Add a -g switch to show only a per-group summary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_spaceman.8 |    8 +++++++-
 spaceman/freesp.c       |   27 ++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 4 deletions(-)


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
index ffe2fdb..3073e24 100644
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
@@ -221,6 +226,15 @@ scan_ag(
 
 		fsmap->fmh_keys[0] = *p;
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
@@ -245,7 +259,7 @@ init(
 	aglist = NULL;
 	hist = NULL;
 	rtflag = false;
-	while ((c = getopt(argc, argv, "a:bde:h:m:rs")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bde:gh:m:rs")) != EOF) {
 		switch (c) {
 		case 'a':
 			aglistadd(optarg);
@@ -265,6 +279,10 @@ init(
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
@@ -307,13 +325,15 @@ freesp_f(
 
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
@@ -335,10 +355,11 @@ freesp_help(void)
 "\n"
 "Examine filesystem free space\n"
 "\n"
-"Options: [-bcds] [-a agno] [-e bsize] [-h h1]... [-m bmult]\n"
+"Options: [-bcdgs] [-a agno] [-e bsize] [-h h1]... [-m bmult]\n"
 "\n"
 " -b -- binary histogram bin size\n"
 " -d -- debug output\n"
+" -g -- print per-AG summary\n"
 " -r -- display realtime device free space information\n"
 " -s -- emit freespace summary information\n"
 " -a agno -- scan only the given AG agno\n"

