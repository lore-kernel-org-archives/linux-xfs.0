Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 151F37F5A
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 10:11:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A919AC009
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:11:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4DHy1UUhm70LeWx0 for
	<xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:11:20 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 7/8] xfstests: Add fallocate zero range operation to fsx
Date: Fri, 28 Feb 2014 17:11:04 +0100
Message-Id: <1393603865-26198-7-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

This commit adds fallocate FALLOC_FL_ZERO_RANGE support for fsx.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsx.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 98 insertions(+), 30 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index c36a038..5d6d198 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -69,6 +69,7 @@ int			logcount = 0;	/* total ops */
  * TRUNCATE:	-	4
  * FALLOCATE:	-	5
  * PUNCH HOLE:	-	6
+ * ZERO RANGE:	-	7
  *
  * When mapped read/writes are disabled, they are simply converted to normal
  * reads and writes. When fallocate/fpunch calls are disabled, they are
@@ -92,7 +93,8 @@ int			logcount = 0;	/* total ops */
 #define OP_TRUNCATE	4
 #define OP_FALLOCATE	5
 #define OP_PUNCH_HOLE	6
-#define OP_MAX_FULL	7
+#define OP_ZERO_RANGE	7
+#define OP_MAX_FULL	8
 
 /* operation modifiers */
 #define OP_CLOSEOPEN	100
@@ -139,6 +141,7 @@ int	seed = 1;			/* -S flag */
 int     mapped_writes = 1;              /* -W flag disables */
 int     fallocate_calls = 1;            /* -F flag disables */
 int     punch_hole_calls = 1;           /* -H flag disables */
+int     zero_range_calls = 1;           /* -z flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -317,6 +320,14 @@ logdump(void)
 						     lp->args[0] + lp->args[1])
 				prt("\t******PPPP");
 			break;
+		case OP_ZERO_RANGE:
+			prt("ZERO    0x%x thru 0x%x\t(0x%x bytes)",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1]);
+			if (badoff >= lp->args[0] && badoff <
+						     lp->args[0] + lp->args[1])
+				prt("\t******ZZZZ");
+			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
 			break;
@@ -879,6 +890,65 @@ do_punch_hole(unsigned offset, unsigned length)
 }
 #endif
 
+#ifdef FALLOC_FL_ZERO_RANGE
+void
+do_zero_range(unsigned offset, unsigned length)
+{
+	unsigned end_offset;
+	int mode = FALLOC_FL_ZERO_RANGE;
+	int keep_size;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length zero range\n");
+			log4(OP_SKIPPED, OP_ZERO_RANGE, offset, length);
+		return;
+	}
+
+	keep_size = random() % 2;
+
+	end_offset = keep_size ? 0 : offset + length;
+
+	if (end_offset > biggest) {
+		biggest = end_offset;
+		if (!quiet && testcalls > simulatedopcount)
+			prt("zero_range to largest ever: 0x%x\n", end_offset);
+	}
+
+	/*
+	 * last arg matches fallocate string array index in logdump:
+	 * 	0: allocate past EOF
+	 * 	1: extending prealloc
+	 * 	2: interior prealloc
+	 */
+	log4(OP_ZERO_RANGE, offset, length, (end_offset > file_size) ? (keep_size ? 0 : 1) : 2);
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		      end_offset <= monitorend))) {
+		prt("%lu zero\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+			offset, offset+length, length);
+	}
+	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
+		prt("%pzero range: %x to %x\n", offset, length);
+		prterr("do_zero_range: fallocate");
+		report_failure(161);
+	}
+
+	memset(good_buf + offset, '\0', length);
+}
+
+#else
+void
+do_zero_range(unsigned offset, unsigned length)
+{
+	return;
+}
+#endif
+
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -1047,6 +1117,12 @@ test(void)
 			goto out;
 		}
 		break;
+	case OP_ZERO_RANGE:
+		if (!zero_range_calls) {
+			log4(OP_SKIPPED, OP_ZERO_RANGE, offset, size);
+			goto out;
+		}
+		break;
 	}
 
 	switch (op) {
@@ -1085,6 +1161,10 @@ test(void)
 		TRIM_OFF_LEN(offset, size, file_size);
 		do_punch_hole(offset, size);
 		break;
+	case OP_ZERO_RANGE:
+		TRIM_OFF_LEN(offset, size, file_size);
+		do_zero_range(offset, size);
+		break;
 	default:
 		prterr("test: unknown operation");
 		report_failure(42);
@@ -1140,7 +1220,10 @@ usage(void)
 "	-F: Do not use fallocate (preallocation) calls\n"
 #endif
 #ifdef FALLOC_FL_PUNCH_HOLE
-"       -H: Do not use punch hole calls\n"
+"	-H: Do not use punch hole calls\n"
+#endif
+#ifdef FALLOC_FL_ZERO_RANGE
+"	-E: Do not use zero range calls\n"
 #endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
@@ -1290,40 +1373,21 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 
 #endif
 
-void
-test_fallocate()
+int
+test_fallocate(int mode)
 {
 #ifdef HAVE_LINUX_FALLOC_H
+	int ret = 0;
 	if (!lite && fallocate_calls) {
-		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
+		if (fallocate(fd, mode, 0, 1) && errno == EOPNOTSUPP) {
 			if(!quiet)
 				warn("main: filesystem does not support fallocate, disabling\n");
-			fallocate_calls = 0;
 		} else {
+			ret = 1;
 			ftruncate(fd, 0);
 		}
 	}
-#else /* ! HAVE_LINUX_FALLOC_H */
-	fallocate_calls = 0;
-#endif
-
-}
-
-void
-test_punch_hole()
-{
-#ifdef FALLOC_FL_PUNCH_HOLE
-	if (!lite && punch_hole_calls) {
-		if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-				0, 1) && errno == EOPNOTSUPP) {
-			if(!quiet)
-				warn("main: filesystem does not support fallocate punch hole, disabling");
-			punch_hole_calls = 0;
-		} else
-			ftruncate(fd, 0);
-	}
-#else /* ! PUNCH HOLE */
-	punch_hole_calls = 0;
+	return ret;
 #endif
 }
 
@@ -1345,7 +1409,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzLN:OP:RS:WZ"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1445,6 +1509,9 @@ main(int argc, char **argv)
 		case 'H':
 			punch_hole_calls = 0;
 			break;
+		case 'z':
+			zero_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			break;
@@ -1590,8 +1657,9 @@ main(int argc, char **argv)
 	} else 
 		check_trunc_hack();
 
-	test_fallocate();
-	test_punch_hole();
+	fallocate_calls = test_fallocate(0);
+	punch_hole_calls = test_fallocate(FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE);
+	zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
 
 	while (numops == -1 || numops--)
 		test();
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
