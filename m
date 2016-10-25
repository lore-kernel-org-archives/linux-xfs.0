Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46511 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755775AbcJYXFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:05:15 -0400
Subject: [PATCH 15/39] xfs_io: bmap should support querying CoW fork,
 shared blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:05:10 -0700
Message-ID: <147743671083.11035.8607583600483038357.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Teach the bmap command to report shared and delayed allocation
extents, and to be able to query the CoW fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/bmap.c           |   43 ++++++++++++++++++++++++++++++++++---------
 man/man8/xfs_bmap.8 |   14 ++++++++++++++
 man/man8/xfs_io.8   |    2 +-
 3 files changed, 49 insertions(+), 10 deletions(-)


diff --git a/io/bmap.c b/io/bmap.c
index b2e48da..2333244 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -41,7 +41,9 @@ bmap_help(void)
 " Holes are marked by replacing the startblock..endblock with 'hole'.\n"
 " All the file offsets and disk blocks are in units of 512-byte blocks.\n"
 " -a -- prints the attribute fork map instead of the data fork.\n"
+" -c -- prints the copy-on-write fork map instead of the data fork.\n"
 " -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
+" -e -- print delayed allocation extents.\n"
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
 " -n -- query n extents.\n"
 " -p -- obtain all unwritten extents as well (w/ -v show which are unwritten.)\n"
@@ -75,6 +77,7 @@ bmap_f(
 	int			loop = 0;
 	int			flg = 0;
 	int			aflag = 0;
+	int			cflag = 0;
 	int			lflag = 0;
 	int			nflag = 0;
 	int			pflag = 0;
@@ -85,12 +88,19 @@ bmap_f(
 	int			c;
 	int			egcnt;
 
-	while ((c = getopt(argc, argv, "adln:pv")) != EOF) {
+	while ((c = getopt(argc, argv, "acdeln:pv")) != EOF) {
 		switch (c) {
 		case 'a':	/* Attribute fork. */
 			bmv_iflags |= BMV_IF_ATTRFORK;
 			aflag = 1;
 			break;
+		case 'c':	/* CoW fork. */
+			bmv_iflags |= BMV_IF_COWFORK | BMV_IF_DELALLOC;
+			cflag = 1;
+			break;
+		case 'e':
+			bmv_iflags |= BMV_IF_DELALLOC;
+			break;
 		case 'l':	/* list number of blocks with each extent */
 			lflag = 1;
 			break;
@@ -113,7 +123,7 @@ bmap_f(
 			return command_usage(&bmap_cmd);
 		}
 	}
-	if (aflag)
+	if (aflag || cflag)
 		bmv_iflags &= ~(BMV_IF_PREALLOC|BMV_IF_NO_DMAPI_READ);
 
 	if (vflag) {
@@ -273,13 +283,14 @@ bmap_f(
 #define MINRANGE_WIDTH	16
 #define MINAG_WIDTH	2
 #define MINTOT_WIDTH	5
-#define NFLG		5	/* count of flags */
-#define	FLG_NULL	000000	/* Null flag */
-#define	FLG_PRE		010000	/* Unwritten extent */
-#define	FLG_BSU		001000	/* Not on begin of stripe unit  */
-#define	FLG_ESU		000100	/* Not on end   of stripe unit  */
-#define	FLG_BSW		000010	/* Not on begin of stripe width */
-#define	FLG_ESW		000001	/* Not on end   of stripe width */
+#define NFLG		6	/* count of flags */
+#define	FLG_NULL	0000000	/* Null flag */
+#define	FLG_SHARED	0100000	/* shared extent */
+#define	FLG_PRE		0010000	/* Unwritten extent */
+#define	FLG_BSU		0001000	/* Not on begin of stripe unit  */
+#define	FLG_ESU		0000100	/* Not on end   of stripe unit  */
+#define	FLG_BSW		0000010	/* Not on begin of stripe width */
+#define	FLG_ESW		0000001	/* Not on end   of stripe width */
 		int	agno;
 		off64_t agoff, bbperag;
 		int	foff_w, boff_w, aoff_w, tot_w, agno_w;
@@ -350,6 +361,10 @@ bmap_f(
 			if (map[i + 1].bmv_oflags & BMV_OF_PREALLOC) {
 				flg |= FLG_PRE;
 			}
+			if (map[i + 1].bmv_oflags & BMV_OF_SHARED)
+				flg |= FLG_SHARED;
+			if (map[i + 1].bmv_oflags & BMV_OF_DELALLOC)
+				map[i + 1].bmv_block = -2;
 			/*
 			 * If striping enabled, determine if extent starts/ends
 			 * on a stripe unit boundary.
@@ -382,6 +397,14 @@ bmap_f(
 					agno_w, "",
 					aoff_w, "",
 					tot_w, (long long)map[i+1].bmv_length);
+			} else if (map[i + 1].bmv_block == -2) {
+				printf("%4d: %-*s %-*s %*s %-*s %*lld\n",
+					i,
+					foff_w, rbuf,
+					boff_w, _("delalloc"),
+					agno_w, "",
+					aoff_w, "",
+					tot_w, (long long)map[i+1].bmv_length);
 			} else {
 				snprintf(bbuf, sizeof(bbuf), "%lld..%lld",
 					(long long) map[i + 1].bmv_block,
@@ -413,6 +436,8 @@ bmap_f(
 		}
 		if ((flg || pflag) && vflag > 1) {
 			printf(_(" FLAG Values:\n"));
+			printf(_("    %*.*o Shared extent\n"),
+				NFLG+1, NFLG+1, FLG_SHARED);
 			printf(_("    %*.*o Unwritten preallocated extent\n"),
 				NFLG+1, NFLG+1, FLG_PRE);
 			printf(_("    %*.*o Doesn't begin on stripe unit\n"),
diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
index e196559..098cfae 100644
--- a/man/man8/xfs_bmap.8
+++ b/man/man8/xfs_bmap.8
@@ -36,6 +36,10 @@ no matter what the filesystem's block size is.
 If this option is specified, information about the file's
 attribute fork is printed instead of the default data fork.
 .TP
+.B \-c
+If this option is specified, information about the file's
+copy on write fork is printed instead of the default data fork.
+.TP
 .B \-d
 If portions of the file have been migrated offline by
 a DMAPI application, a DMAPI read event will be generated to
@@ -45,6 +49,16 @@ printed.  However if the
 option is used, no DMAPI read event will be generated for a
 DMAPI file and offline portions will be reported as holes.
 .TP
+.B \-e
+If this option is used,
+.B xfs_bmap
+obtains all delayed allocation extents, and does not flush dirty pages
+to disk before querying extent data. With the
+.B \-v
+option, the
+.I flags
+column will show which extents have not yet been allocated.
+.TP
 .B \-l
 If this option is used, then
 .IP
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 2c56f09..d089524 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -256,7 +256,7 @@ See the
 .B pwrite
 command.
 .TP
-.BI "bmap [ \-adlpv ] [ \-n " nx " ]"
+.BI "bmap [ \-acdelpv ] [ \-n " nx " ]"
 Prints the block mapping for the current open file. Refer to the
 .BR xfs_bmap (8)
 manual page for complete documentation.

