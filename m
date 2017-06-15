Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33384 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdFOUhI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 16:37:08 -0400
Subject: [PATCH 12/12] xfs_spaceman: add group summary mode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Jun 2017 13:37:03 -0700
Message-ID: <149755902328.3625.10845087403849596095.stgit@birch.djwong.org>
In-Reply-To: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
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
 man/man8/xfs_spaceman.8 |    6 +++++-
 spaceman/freesp.c       |   27 ++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 4 deletions(-)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index f064360..0302196 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -25,7 +25,7 @@ then the program exits.
 
 .SH COMMANDS
 .TP
-.BI "freesp [ \-drs ] [-a agno] [ \-b | \-e bsize | \-h bsize | \-m factor ]"
+.BI "freesp [ \-dgrs ] [-a agno] [ \-b | \-e bsize | \-h bsize | \-m factor ]"
 With no arguments,
 .B freesp
 shows a histogram of all free space extents in the filesystem.
@@ -49,6 +49,10 @@ This is the default, and is mutually exclusive with the
 Print debugging information such as the raw free space extent information.
 
 .TP
+.B \-g
+Print the free space block and extent counts for each AG.
+
+.TP
 .B \-e bsize
 Set all histogram bin sizes to a specific value.
 This option is mutually exclusive with the
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 99e50cf..79eea44 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -43,6 +43,7 @@ static long long	multsize;
 static int		histcount;
 static int		seen1;
 static int		summaryflag;
+static int		gflag;
 static bool		rtflag;
 static long long	totblocks;
 static long long	totexts;
@@ -164,6 +165,8 @@ scan_ag(
 	off64_t			bperag;
 	off64_t			aglen;
 	xfs_agblock_t		agbno;
+	unsigned long long	freeblks = 0;
+	unsigned long long	freeexts = 0;
 	int			ret;
 	int			i;
 
@@ -216,6 +219,8 @@ scan_ag(
 			agbno = (extent->fmr_physical - (bperag * agno)) /
 								blocksize;
 			aglen = extent->fmr_length / blocksize;
+			freeblks += aglen;
+			freeexts++;
 
 			addtohist(agno, agbno, aglen);
 		}
@@ -225,6 +230,15 @@ scan_ag(
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
@@ -258,7 +272,7 @@ init(
 	hist = NULL;
 	rtflag = false;
 
-	while ((c = getopt(argc, argv, "a:bde:h:m:rs")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bde:gh:m:rs")) != EOF) {
 		switch (c) {
 		case 'a':
 			aglistadd(optarg);
@@ -280,6 +294,10 @@ init(
 				return command_usage(&freesp_cmd);
 			speced = 1;
 			break;
+		case 'g':
+			histcount = 0;
+			gflag++;
+			break;
 		case 'h':
 			if (speced && !histcount)
 				goto many_spec;
@@ -331,13 +349,15 @@ freesp_f(
 
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
@@ -363,6 +383,7 @@ freesp_help(void)
 " -b       -- binary histogram bin size\n"
 " -d       -- debug output\n"
 " -e bsize -- Use fixed histogram bin size of bsize\n"
+" -g       -- Print only a per-AG summary.\n"
 " -h hbsz  -- Use custom histogram bin size of h1.\n"
 "             Multiple specifications are allowed.\n"
 " -m bmult -- Use histogram bin size multiplier of bmult.\n"
@@ -382,7 +403,7 @@ freesp_init(void)
 	freesp_cmd.cfunc = freesp_f;
 	freesp_cmd.argmin = 0;
 	freesp_cmd.argmax = -1;
-	freesp_cmd.args = "[-drs] [-a agno]... [ -b | -e bsize | -h h1... | -m bmult ]";
+	freesp_cmd.args = "[-dgrs] [-a agno]... [ -b | -e bsize | -h h1... | -m bmult ]";
 	freesp_cmd.flags = CMD_FLAG_ONESHOT;
 	freesp_cmd.oneline = _("Examine filesystem free space");
 	freesp_cmd.help = freesp_help;

