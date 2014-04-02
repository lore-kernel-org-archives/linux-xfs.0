Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 187D729DF7
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 10:33:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85FEFAC006
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 08:33:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fzgSP6h8uIPKos0l for
	<xfs@oss.sgi.com>; Wed, 02 Apr 2014 08:33:27 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] fsx: Add fallocate collapse range operation
Date: Wed,  2 Apr 2014 17:33:19 +0200
Message-Id: <1396452800-25775-1-git-send-email-lczerner@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

This commit adds fallocate FALLOC_FL_COLLAPSE_RANGE support for fsx.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsx.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 100 insertions(+), 7 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index bd1ed76..47d3ee8 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -90,11 +90,12 @@ int			logcount = 0;	/* total ops */
 #define OP_MAX_LITE	4
 
 /* !lite operations */
-#define OP_TRUNCATE	4
-#define OP_FALLOCATE	5
-#define OP_PUNCH_HOLE	6
-#define OP_ZERO_RANGE	7
-#define OP_MAX_FULL	8
+#define OP_TRUNCATE		4
+#define OP_FALLOCATE		5
+#define OP_PUNCH_HOLE		6
+#define OP_ZERO_RANGE		7
+#define OP_COLLAPSE_RANGE	8
+#define OP_MAX_FULL		9
 
 /* operation modifiers */
 #define OP_CLOSEOPEN	100
@@ -111,6 +112,7 @@ char	*temp_buf;			/* a pointer to the current data */
 char	*fname;				/* name of our test file */
 int	fd;				/* fd for our test file */
 
+blksize_t	block_size = 0;
 off_t		file_size = 0;
 off_t		biggest = 0;
 char		state[256];
@@ -142,6 +144,7 @@ int     mapped_writes = 1;              /* -W flag disables */
 int     fallocate_calls = 1;            /* -F flag disables */
 int     punch_hole_calls = 1;           /* -H flag disables */
 int     zero_range_calls = 1;           /* -z flag disables */
+int	collapse_range_calls = 1;	/* -C flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -321,13 +324,21 @@ logdump(void)
 				prt("\t******PPPP");
 			break;
 		case OP_ZERO_RANGE:
-			prt("ZERO    0x%x thru 0x%x\t(0x%x bytes)",
+			prt("ZERO     0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
 			if (badoff >= lp->args[0] && badoff <
 						     lp->args[0] + lp->args[1])
 				prt("\t******ZZZZ");
 			break;
+		case OP_COLLAPSE_RANGE:
+			prt("COLLAPSE 0x%x thru 0x%x\t(0x%x bytes)",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1]);
+			if (badoff >= lp->args[0] && badoff <
+						     lp->args[0] + lp->args[1])
+				prt("\t******CCCC");
+			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
 			break;
@@ -949,6 +960,58 @@ do_zero_range(unsigned offset, unsigned length)
 }
 #endif
 
+#ifdef FALLOC_FL_COLLAPSE_RANGE
+void
+do_collapse_range(unsigned offset, unsigned length)
+{
+	unsigned end_offset;
+	int mode = FALLOC_FL_COLLAPSE_RANGE;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length collapse range\n");
+		log4(OP_SKIPPED, OP_COLLAPSE_RANGE, offset, length);
+		return;
+	}
+
+	end_offset = offset + length;
+	if ((loff_t)end_offset >= file_size) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping collapse range behind EOF\n");
+		log4(OP_SKIPPED, OP_COLLAPSE_RANGE, offset, length);
+		return;
+	}
+
+	log4(OP_COLLAPSE_RANGE, offset, length, 0);
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		      end_offset <= monitorend))) {
+		prt("%lu collapse\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+			offset, offset+length, length);
+	}
+	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
+		prt("collapse range: %x to %x\n", offset, length);
+		prterr("do_collapse_range: fallocate");
+		report_failure(161);
+	}
+
+	memmove(good_buf + offset, good_buf + end_offset,
+		file_size - end_offset);
+	file_size -= length;
+}
+
+#else
+void
+do_collapse_range(unsigned offset, unsigned length)
+{
+	return;
+}
+#endif
+
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -1123,6 +1186,12 @@ test(void)
 			goto out;
 		}
 		break;
+	case OP_COLLAPSE_RANGE:
+		if (!collapse_range_calls) {
+			log4(OP_SKIPPED, OP_COLLAPSE_RANGE, offset, size);
+			goto out;
+		}
+		break;
 	}
 
 	switch (op) {
@@ -1165,6 +1234,16 @@ test(void)
 		TRIM_OFF_LEN(offset, size, file_size);
 		do_zero_range(offset, size);
 		break;
+	case OP_COLLAPSE_RANGE:
+		TRIM_OFF_LEN(offset, size, file_size - 1);
+		offset = offset & ~(block_size - 1);
+		size = size & ~(block_size - 1);
+		if (size == 0) {
+			log4(OP_SKIPPED, OP_COLLAPSE_RANGE, offset, size);
+			goto out;
+		}
+		do_collapse_range(offset, size);
+		break;
 	default:
 		prterr("test: unknown operation");
 		report_failure(42);
@@ -1225,6 +1304,9 @@ usage(void)
 #ifdef FALLOC_FL_ZERO_RANGE
 "	-z: Do not use zero range calls\n"
 #endif
+#ifdef FALLOC_FL_COLLAPSE_RANGE
+"	-C: Do not use collapse range calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -1399,6 +1481,7 @@ main(int argc, char **argv)
 	char	*endp;
 	char goodfile[1024];
 	char logfile[1024];
+	struct stat statbuf;
 
 	goodfile[0] = 0;
 	logfile[0] = 0;
@@ -1410,7 +1493,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCLN:OP:RS:WZ"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1513,6 +1596,9 @@ main(int argc, char **argv)
 		case 'z':
 			zero_range_calls = 0;
 			break;
+		case 'C':
+			collapse_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			break;
@@ -1579,6 +1665,11 @@ main(int argc, char **argv)
 		prterr(fname);
 		exit(91);
 	}
+	if (fstat(fd, &statbuf)) {
+		prterr("check_size: fstat");
+		exit(91);
+	}
+	block_size = statbuf.st_blksize;
 #ifdef XFS
 	if (prealloc) {
 		xfs_flock64_t	resv = { 0 };
@@ -1665,6 +1756,8 @@ main(int argc, char **argv)
 						  FALLOC_FL_KEEP_SIZE);
 	if (zero_range_calls)
 		zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
+	if (collapse_range_calls)
+		collapse_range_calls = test_fallocate(FALLOC_FL_COLLAPSE_RANGE);
 
 	while (numops == -1 || numops--)
 		test();
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
