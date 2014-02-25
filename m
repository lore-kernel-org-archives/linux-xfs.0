Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FFD97F56
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:11:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB802AC003
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:11:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b8Ib9uvgeOLKDk2r for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:11:41 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/6] xfstests: Add fallocate zero range operation to fsx
Date: Tue, 25 Feb 2014 20:15:26 +0100
Message-Id: <1393355728-12056-4-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
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

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsx.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 107 insertions(+), 3 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 2f1e3e8..b3c30db 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -72,6 +72,7 @@ int			logcount = 0;	/* total ops */
  * TRUNCATE:	-	4
  * FALLOCATE:	-	5
  * PUNCH HOLE:	-	6
+ * ZERO RANGE:	-	7
  *
  * When mapped read/writes are disabled, they are simply converted to normal
  * reads and writes. When fallocate/fpunch calls are disabled, they are
@@ -95,7 +96,8 @@ int			logcount = 0;	/* total ops */
 #define OP_TRUNCATE	4
 #define OP_FALLOCATE	5
 #define OP_PUNCH_HOLE	6
-#define OP_MAX_FULL	7
+#define OP_ZERO_RANGE	7
+#define OP_MAX_FULL	8
 
 /* operation modifiers */
 #define OP_CLOSEOPEN	100
@@ -142,6 +144,7 @@ int	seed = 1;			/* -S flag */
 int     mapped_writes = 1;              /* -W flag disables */
 int     fallocate_calls = 1;            /* -F flag disables */
 int     punch_hole_calls = 1;           /* -H flag disables */
+int     zero_range_calls = 1;           /* -E flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -320,6 +323,14 @@ logdump(void)
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
@@ -882,6 +893,64 @@ do_punch_hole(unsigned offset, unsigned length)
 }
 #endif
 
+#ifdef FALLOC_FL_ZERO_RANGE
+void
+do_zero_range(unsigned offset, unsigned length)
+{
+	unsigned end_offset;
+	int max_offset = 0;
+	int max_len = 0;
+	int mode = FALLOC_FL_ZERO_RANGE;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length zero range\n");
+			log4(OP_SKIPPED, OP_ZERO_RANGE, offset, length);
+		return;
+	}
+
+	if (file_size <= (loff_t)offset) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero range off the end of the file\n");
+			log4(OP_SKIPPED, OP_ZERO_RANGE, offset, length);
+		return;
+	}
+
+	end_offset = offset + length;
+
+	log4(OP_ZERO_RANGE, offset, length, 0);
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
+
+	max_offset = offset < file_size ? offset : file_size;
+	max_len = max_offset + length <= file_size ? length :
+			file_size - max_offset;
+	memset(good_buf + max_offset, '\0', max_len);
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
+
 #ifdef FALLOCATE
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -1050,6 +1119,12 @@ test(void)
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
@@ -1088,6 +1163,10 @@ test(void)
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
@@ -1143,7 +1222,10 @@ usage(void)
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
@@ -1330,6 +1412,24 @@ test_punch_hole()
 #endif
 }
 
+void
+test_zero_range()
+{
+#ifdef FALLOC_FL_ZERO_RANGE
+	if (!lite && zero_range_calls) {
+		if (fallocate(fd, FALLOC_FL_ZERO_RANGE,
+				0, 1) && errno == EOPNOTSUPP) {
+			if(!quiet)
+				warn("main: filesystem does not support fallocate zero range, disabling");
+			zero_range_calls = 0;
+		} else
+			ftruncate(fd, 0);
+	}
+#else /* ! ZERO RANGE */
+	zero_range_calls = 0;
+#endif
+}
+
 int
 main(int argc, char **argv)
 {
@@ -1348,7 +1448,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHELN:OP:RS:WZ"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1448,6 +1548,9 @@ main(int argc, char **argv)
 		case 'H':
 			punch_hole_calls = 0;
 			break;
+		case 'E':
+			zero_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			break;
@@ -1595,6 +1698,7 @@ main(int argc, char **argv)
 
 	test_fallocate();
 	test_punch_hole();
+	test_zero_range();
 
 	while (numops == -1 || numops--)
 		test();
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
