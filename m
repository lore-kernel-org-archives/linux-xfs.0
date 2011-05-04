Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p444lMHZ055984 for <xfs@oss.sgi.com>; Tue, 3 May 2011 23:47:24 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E87842BDAF
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 21:50:59 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id QdaoM1qTqP6MRiSl for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 21:50:59 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p444P0Lb021849
	for <xfs@oss.sgi.com>; Wed, 4 May 2011 00:25:00 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p444ox6a091886 for <xfs@oss.sgi.com>; Wed, 4 May 2011 00:50:59 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p444oxxE005856 for <xfs@oss.sgi.com>; Wed, 4 May 2011 01:50:59 -0300
Message-ID: <4DC0DB30.6060601@linux.vnet.ibm.com>
Date: Tue, 03 May 2011 21:50:56 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [XFS Tests Punch Hole 1/1 v2]   Add Punch Hole Testing to FSX
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

This patch adds punch hole tests to the fsx
stress test. The test is performed through
the fallocate call by randomly choosing to
use the punch hole flag when running the
fallocate test. Regions that have
been punched out should contain zeros, so
the expected file contents buffer is updated
to contain zeros when a hole is punched out.

v0 -> v1:
Corrections to the Makefile have been backed out.
This patch needs to be applied on top of
the "xfstests: clean up fallocate configuration tests"
patch

The punch hole tests can be disabled with the
-H flag, and will also be disabled if it is
detected that the filesystem does not support
punch hole

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 fe072d3... 8978ef1... M	ltp/fsx.c
  ltp/fsx.c |  111 
++++++++++++++++++++++++++++++++++++++++++++++++++++--------
  1 files changed, 96 insertions(+), 15 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index fe072d3..8978ef1 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -110,6 +110,7 @@ int	randomoplen = 1;		/* -O flag disables it */
  int	seed = 1;			/* -S flag */
  int     mapped_writes = 1;              /* -W flag disables */
  int     fallocate_calls = 1;            /* -F flag disables */
+int     punch_hole_calls = 1;           /* -H flag disables */
  int 	mapped_reads = 1;		/* -R flag disables it */
  int	fsxgoodfd = 0;
  int	o_direct;			/* -Z */
@@ -207,7 +208,8 @@ logdump(void)
  {
  	int	i, count, down;
  	struct log_entry	*lp;
-	char *falloc_type[3] = {"PAST_EOF", "EXTENDING", "INTERIOR"};
+	char *falloc_type[4] = {"PAST_EOF", "EXTENDING", "INTERIOR",
+				"PUNCH_HOLE"};

  	prt("LOG DUMP (%d total operations):\n", logcount);
  	if (logcount < LOGSIZE) {
@@ -791,6 +793,11 @@ dofallocate(unsigned offset, unsigned length)
  {
  	unsigned end_offset;
  	int keep_size;
+	int max_offset = 0;
+	int max_len = 0;
+	int mode = 0;
+	char *op_name;
+	int punch_hole = 0;

          if (length == 0) {
                  if (!quiet && testcalls > simulatedopcount)
@@ -799,11 +806,37 @@ dofallocate(unsigned offset, unsigned length)
                  return;
          }

+#ifdef FALLOC_FL_PUNCH_HOLE
+	if (fallocate_calls && !punch_hole_calls)
+		punch_hole = 0;
+	else if (!fallocate_calls && punch_hole_calls)
+		punch_hole = 1;
+	else
+		punch_hole = random() % 2;
+
+	/* Keep size must be set for punch hole */
+	if (punch_hole) {
+		keep_size = 1;
+		mode = FALLOC_FL_PUNCH_HOLE;
+	} else
+		keep_size = random() % 2;
+#else
  	keep_size = random() % 2;
+#endif
+
+	if (keep_size)
+		mode |= FALLOC_FL_KEEP_SIZE;
+
+	if (punch_hole && file_size <= (loff_t)offset) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping hole punch off the end of the file\n");
+		log4(OP_SKIPPED, OP_FALLOCATE, offset, length);
+		return;
+	}

  	end_offset = keep_size ? 0 : offset + length;

-	if (end_offset > biggest) {
+	if ((end_offset > biggest) && !punch_hole) {
  		biggest = end_offset;
  		if (!quiet && testcalls > simulatedopcount)
  			prt("fallocating to largest ever: 0x%x\n", end_offset);
@@ -811,13 +844,15 @@ dofallocate(unsigned offset, unsigned length)

  	/*
  	 * last arg:
-	 * 	1: allocate past EOF
-	 * 	2: extending prealloc
-	 * 	3: interior prealloc
+	 *      0: allocate past EOF
+	 *      1: extending prealloc
+	 *      2: interior prealloc
+	 *      3: punch hole
  	 */
-	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? 
(keep_size ? 1 : 2) : 3);
+	log4(OP_FALLOCATE, offset, length, punch_hole ? 3 :
+			(end_offset > file_size) ? (keep_size ? 0 : 1) : 2);

-	if (end_offset > file_size) {
+	if (((loff_t)end_offset > file_size) && !punch_hole) {
  		memset(good_buf + file_size, '\0', end_offset - file_size);
  		file_size = end_offset;
  	}
@@ -827,13 +862,35 @@ dofallocate(unsigned offset, unsigned length)
  	
  	if ((progressinterval && testcalls % progressinterval == 0) ||
  	    (debug && (monitorstart == -1 || monitorend == -1 ||
-		      end_offset <= monitorend)))
-		prt("%lu falloc\tfrom 0x%x to 0x%x\n", testcalls, offset, length);
-	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, 
(loff_t)length) == -1) {
-	        prt("fallocate: %x to %x\n", offset, length);
+		      end_offset <= monitorend))) {
+#ifdef FALLOC_FL_PUNCH_HOLE
+		op_name = (mode & FALLOC_FL_PUNCH_HOLE) ?
+			"punch hole" : "falloc";
+#else
+		op_name = "falloc";
+#endif
+		prt("%lu %s\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+			op_name, offset, offset+length, length);
+	}
+	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
+#ifdef FALLOC_FL_PUNCH_HOLE
+		op_name = (mode & FALLOC_FL_PUNCH_HOLE) ?
+			"punch hole" : "fallocate";
+#else
+		op_name = "fallocate";
+#endif
+
+		prt("%s: %x to %x\n", op_name, offset, length);
  		prterr("dofallocate: fallocate");
  		report_failure(161);
  	}
+
+	if (punch_hole) {
+		max_offset = offset < file_size ? offset : file_size;
+		max_len = max_offset + length <= file_size ? length :
+				file_size - max_offset;
+		memset(good_buf + max_offset, '\0', max_len);
+	}
  }
  #else
  void
@@ -895,8 +952,8 @@ test(void)
  	unsigned long	offset;
  	unsigned long	size = maxoplen;
  	unsigned long	rv = random();
-	unsigned long	op = rv % (3 + !lite + mapped_writes + fallocate_calls);
-
+	unsigned long	op = rv % (3 + !lite + mapped_writes +
+		(fallocate_calls || punch_hole_calls));
          /* turn off the map read if necessary */

          if (op == 2 && !mapped_reads)
@@ -1013,6 +1070,9 @@ usage(void)
  #ifdef FALLOCATE
  "	-F: Do not use fallocate (preallocation) calls\n"
  #endif
+#ifdef FALLOC_FL_PUNCH_HOLE
+"       -H: Do not use punch hole calls\n"
+#endif
  "	-L: fsxLite - no file creations & no file size changes\n\
  	-N numops: total # operations to do (default infinity)\n\
  	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -1179,7 +1239,7 @@ main(int argc, char **argv)

  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */

-	while ((ch = getopt(argc, argv, 
"b:c:dfl:m:no:p:qr:s:t:w:xyAD:FLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, 
"b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHLN:OP:RS:WZ"))
  	       != EOF)
  		switch (ch) {
  		case 'b':
@@ -1276,6 +1336,9 @@ main(int argc, char **argv)
  		case 'F':
  			fallocate_calls = 0;
  			break;
+		case 'H':
+			punch_hole_calls = 0;
+			break;
  		case 'L':
  		        lite = 1;
  			break;
@@ -1426,8 +1489,26 @@ main(int argc, char **argv)
  		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
  			warn("main: filesystem does not support fallocate, disabling");
  			fallocate_calls = 0;
-		} else
+			/*
+			 * punch hole depends on fallocate,
+			 * so turn punch hole off too
+			 */
+			punch_hole_calls = 0;
+		} else {
+#ifdef FALLOC_FL_PUNCH_HOLE
+			if (fallocate(fd,
+				FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+				0, 1) && errno == EOPNOTSUPP) {
+				warn("main: filesystem does not support"
+					" fallocate punch hole, disabling");
+				punch_hole_calls = 0;
+			}
+#else
+			punch_hole_calls = 0;
+#endif
+
  			ftruncate(fd, 0);
+		}
  	}
  #else /* ! FALLOCATE */
  	fallocate_calls = 0;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
