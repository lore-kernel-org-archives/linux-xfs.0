Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BDC28397
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:42:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B939304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:42:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id trq7ruS5xDWqU5t8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:42:54 -0700 (PDT)
Subject: [PATCH 115/145] xfs_io: bmap should support querying CoW fork,
	shared blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:42:50 -0700
Message-ID: <146612777093.16048.15058864646971176390.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Teach the bmap command to report shared and delayed allocation
extents, and to be able to query the CoW fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/bmap.c           |   43 ++++++++++++++++++++++++++++++++++---------
 man/man8/xfs_bmap.8 |   14 ++++++++++++++
 man/man8/xfs_io.8   |    2 +-
 3 files changed, 49 insertions(+), 10 deletions(-)


diff --git a/io/bmap.c b/io/bmap.c
index 04d04c7..0834cdd 100644
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
@@ -271,13 +281,14 @@ bmap_f(
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
@@ -348,6 +359,10 @@ bmap_f(
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
@@ -380,6 +395,14 @@ bmap_f(
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
@@ -411,6 +434,8 @@ bmap_f(
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
index b0300bb..6c45c37 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
