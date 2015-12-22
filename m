Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C48E7F4E
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 07:51:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D04530404E
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PSj9TZGgny5Rq9Fm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:30 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 5CA058E740
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 13:51:30 +0000 (UTC)
Received: from schleppi.home.com (vpn1-6-147.ams2.redhat.com [10.36.6.147])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tBMDpH2N030386
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 08:51:29 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6/6] fsx: Add mechanism to replay failed operations
Date: Tue, 22 Dec 2015 14:51:12 +0100
Message-Id: <1450792272-7402-7-git-send-email-agruenba@redhat.com>
In-Reply-To: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
References: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
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

Create a $name.fsxops file next to $test.fsxlog.  When a test fails,
dump the operations in the log into that file in a simple, parseable
format like:

  fallocate 0x2e0f2 0xf04a 0x0 keep_size
  truncate 0x0 0x11e00 0x0 *
  write 0x73400 0x6c00 0x11e00
  skip punch_hole 0x71539913 0xdf76 0x7a000 close_open
  mapread 0x56000 0x16d08 0x7a000

Here, each operation is on a separate line. When the first word is
"skip", the operation will be skipped.  The next parameters are offset,
length, and the current file size, followed by optional flags like
keep_size and clode_open.  A trailing asterisk indicates that the
operation overlaps with the operation that has failed.

Add a --replay-ops option that allows to replay the operations recorded
in such a $name.fsxops file.  (The log can be modified to easily narrow
down which operations are causing the failure.)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 ltp/fsx.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 213 insertions(+), 33 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 50ca885..28f109c 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -166,7 +166,10 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
 #define fsxwrite(a,b,c,d)	write(a,b,c)
 #endif
 
+const char *replayops = NULL;
 FILE *	fsxlogf = NULL;
+FILE *	replayopsf = NULL;
+char opsfile[1024];
 int badoff = -1;
 int closeopen = 0;
 
@@ -200,7 +203,7 @@ warn(const char * fmt, ...)  {
 #define BUF_SIZE 1024
 
 void
-prt(char *fmt, ...)
+prt(const char *fmt, ...)
 {
 	va_list args;
 	char buffer[BUF_SIZE];
@@ -214,12 +217,43 @@ prt(char *fmt, ...)
 }
 
 void
-prterr(char *prefix)
+prterr(const char *prefix)
 {
 	prt("%s%s%s\n", prefix, prefix ? ": " : "", strerror(errno));
 }
 
 
+static const char *op_names[] = {
+	[OP_READ] = "read",
+	[OP_WRITE] = "write",
+	[OP_MAPREAD] = "mapread",
+	[OP_MAPWRITE] = "mapwrite",
+	[OP_TRUNCATE] = "truncate",
+	[OP_FALLOCATE] = "fallocate",
+	[OP_PUNCH_HOLE] = "punch_hole",
+	[OP_ZERO_RANGE] = "zero_range",
+	[OP_COLLAPSE_RANGE] = "collapse_range",
+	[OP_INSERT_RANGE] = "insert_range",
+};
+
+static const char *op_name(int operation)
+{
+	if (operation >= 0 &&
+	    operation < sizeof(op_names) / sizeof(op_names[0]))
+		return op_names[operation];
+	return NULL;
+}
+
+static int op_code(const char *name)
+{
+	int i;
+
+	for (i = 0; i < sizeof(op_names) / sizeof(op_names[0]); i++)
+		if (op_names[i] && strcmp(name, op_names[i]) == 0)
+			return i;
+	return -1;
+}
+
 void
 log4(int operation, int arg0, int arg1, enum opflags flags)
 {
@@ -243,10 +277,16 @@ log4(int operation, int arg0, int arg1, enum opflags flags)
 void
 logdump(void)
 {
+	FILE	*logopsf;
 	int	i, count, down;
 	struct log_entry	*lp;
 
 	prt("LOG DUMP (%d total operations):\n", logcount);
+
+	logopsf = fopen(opsfile, "w");
+	if (!logopsf)
+		prterr(opsfile);
+
 	if (logcount < LOGSIZE) {
 		i = 0;
 		count = logcount;
@@ -255,12 +295,16 @@ logdump(void)
 		count = LOGSIZE;
 	}
 	for ( ; count > 0; count--) {
+		bool overlap;
 		int opnum;
 
 		opnum = i+1 + (logcount/LOGSIZE)*LOGSIZE;
 		prt("%d(%3d mod 256): ", opnum, opnum%256);
 		lp = &oplog[i];
 
+		overlap = badoff >= lp->args[0] &&
+			  badoff < lp->args[0] + lp->args[1];
+
 		if (lp->flags & FL_SKIPPED) {
 			prt("SKIPPED (no operation)");
 			goto skipped;
@@ -271,24 +315,21 @@ logdump(void)
 			prt("MAPREAD  0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] && badoff <
-						     lp->args[0] + lp->args[1])
+			if (overlap)
 				prt("\t***RRRR***");
 			break;
 		case OP_MAPWRITE:
 			prt("MAPWRITE 0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] && badoff <
-						     lp->args[0] + lp->args[1])
+			if (overlap)
 				prt("\t******WWWW");
 			break;
 		case OP_READ:
 			prt("READ     0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] &&
-			    badoff < lp->args[0] + lp->args[1])
+			if (overlap)
 				prt("\t***RRRR***");
 			break;
 		case OP_WRITE:
@@ -299,16 +340,19 @@ logdump(void)
 				prt(" HOLE");
 			else if (lp->args[0] + lp->args[1] > lp->args[2])
 				prt(" EXTEND");
-			if ((badoff >= lp->args[0] || badoff >=lp->args[2]) &&
-			    badoff < lp->args[0] + lp->args[1])
+			overlap = (badoff >= lp->args[0] ||
+				   badoff >=lp->args[2]) &&
+				  badoff < lp->args[0] + lp->args[1];
+			if (overlap)
 				prt("\t***WWWW");
 			break;
 		case OP_TRUNCATE:
 			down = lp->args[1] < lp->args[2];
 			prt("TRUNCATE %s\tfrom 0x%x to 0x%x",
 			    down ? "DOWN" : "UP", lp->args[2], lp->args[1]);
-			if (badoff >= lp->args[1 + !down] &&
-			    badoff < lp->args[1 + !!down])
+			overlap = badoff >= lp->args[1 + !down] &&
+				  badoff < lp->args[1 + !!down];
+			if (overlap)
 				prt("\t******WWWW");
 			break;
 		case OP_FALLOCATE:
@@ -322,46 +366,43 @@ logdump(void)
 				prt("PAST_EOF");
 			else
 				prt("EXTENDING");
-			if (badoff >= lp->args[0] &&
-			    badoff < lp->args[0] + lp->args[1])
+			if (overlap)
 				prt("\t******FFFF");
 			break;
 		case OP_PUNCH_HOLE:
 			prt("PUNCH    0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] && badoff <
-						     lp->args[0] + lp->args[1])
+			if (overlap)
 				prt("\t******PPPP");
 			break;
 		case OP_ZERO_RANGE:
 			prt("ZERO     0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] && badoff <
-						     lp->args[0] + lp->args[1])
+			if (overlap)
 				prt("\t******ZZZZ");
 			break;
 		case OP_COLLAPSE_RANGE:
 			prt("COLLAPSE 0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] && badoff <
-						     lp->args[0] + lp->args[1])
+			if (overlap)
 				prt("\t******CCCC");
 			break;
 		case OP_INSERT_RANGE:
 			prt("INSERT 0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
-			if (badoff >= lp->args[0] && badoff <
-						     lp->args[0] + lp->args[1])
+			if (overlap)
 				prt("\t******IIII");
 			break;
 		default:
 			prt("BOGUS LOG ENTRY (operation code = %d)!",
 			    lp->operation);
+			continue;
 		}
+
 	    skipped:
 		if (lp->flags & FL_CLOSE_OPEN)
 			prt("\n\t\tCLOSE/OPEN");
@@ -369,6 +410,30 @@ logdump(void)
 		i++;
 		if (i == LOGSIZE)
 			i = 0;
+
+		if (logopsf) {
+			if (lp->flags & FL_SKIPPED)
+				fprintf(logopsf, "skip ");
+			fprintf(logopsf, "%s 0x%x 0x%x 0x%x",
+				op_name(lp->operation),
+				lp->args[0], lp->args[1], lp->args[2]);
+			if (lp->flags & FL_KEEP_SIZE)
+				fprintf(logopsf, " keep_size");
+			if (lp->flags & FL_CLOSE_OPEN)
+				fprintf(logopsf, " close_open");
+			if (overlap)
+				fprintf(logopsf, " *");
+			fprintf(logopsf, "\n");
+		}
+	}
+
+	if (logopsf) {
+		if (fclose(logopsf) != 0)
+			prterr(opsfile);
+		else
+			prt("Log of operations saved to \"%s\"; "
+			    "replay with --replay-ops\n",
+			    opsfile);
 	}
 }
 
@@ -1206,12 +1271,78 @@ do {						\
 	TRIM_LEN(off, len, size);		\
 } while (0)
 
-void
+void cleanup();
+
+static int
+read_op(struct log_entry *log_entry)
+{
+	char line[256];
+
+	memset(log_entry, 0, sizeof(*log_entry));
+	log_entry->operation = -1;
+
+	while (log_entry->operation == -1) {
+		char *str;
+		int i;
+
+		do {
+			if (!fgets(line, sizeof(line), replayopsf)) {
+				if (feof(replayopsf)) {
+					replayopsf = NULL;
+					return 0;
+				}
+				goto fail;
+			}
+			str = strtok(line, " \t\n");
+		} while (!str);
+
+		if (strcmp(str, "skip") == 0) {
+			log_entry->flags |= FL_SKIPPED;
+			str = strtok(NULL, " \t\n");
+			if (!str)
+				goto fail;
+		}
+		log_entry->operation = op_code(str);
+		if (log_entry->operation == -1)
+			goto fail;
+		for (i = 0; i < 3; i++) {
+			char *end;
+
+			str = strtok(NULL, " \t\n");
+			if (!str)
+				goto fail;
+			log_entry->args[i] = strtoul(str, &end, 0);
+			if (*end)
+				goto fail;
+		}
+		while ((str = strtok(NULL, " \t\n"))) {
+			if (strcmp(str, "keep_size") == 0)
+				log_entry->flags |= FL_KEEP_SIZE;
+			else if (strcmp(str, "close_open") == 0)
+				log_entry->flags |= FL_CLOSE_OPEN;
+			else if (strcmp(str, "*") == 0)
+				;  /* overlap marker; ignore */
+			else
+				goto fail;
+		}
+	}
+	return 1;
+
+fail:
+	fprintf(stderr, "%s: parse error\n", replayops);
+	fclose(replayopsf);
+	replayopsf = NULL;
+	cleanup(100);  /* doesn't return */
+	return 0;
+}
+
+
+int
 test(void)
 {
 	unsigned long	offset;
-	unsigned long	size = maxoplen;
-	unsigned long	rv = random();
+	unsigned long	size;
+	unsigned long	rv;
 	unsigned long	op;
 	int		keep_size = 0;
 
@@ -1220,16 +1351,39 @@ test(void)
 
 	testcalls++;
 
-	if (closeprob)
-		closeopen = (rv >> 3) < (1 << 28) / closeprob;
-
 	if (debugstart > 0 && testcalls >= debugstart)
 		debug = 1;
 
 	if (!quiet && testcalls < simulatedopcount && testcalls % 100000 == 0)
 		prt("%lu...\n", testcalls);
 
+	if (replayopsf) {
+		struct log_entry log_entry;
+
+		while (read_op(&log_entry)) {
+			if (log_entry.flags & FL_SKIPPED) {
+				log4(log_entry.operation,
+				     log_entry.args[0], log_entry.args[1],
+				     log_entry.flags);
+				continue;
+			}
+
+			op = log_entry.operation;
+			offset = log_entry.args[0];
+			size = log_entry.args[1];
+			closeopen = !!(log_entry.flags & FL_CLOSE_OPEN);
+			keep_size = !!(log_entry.flags & FL_KEEP_SIZE);
+			goto have_op;
+		}
+		return 0;
+	}
+
+	rv = random();
+	if (closeprob)
+		closeopen = (rv >> 3) < (1 << 28) / closeprob;
+
 	offset = random();
+	size = maxoplen;
 	if (randomoplen)
 		size = random() % (maxoplen + 1);
 
@@ -1240,6 +1394,10 @@ test(void)
 		op = rv % OP_MAX_FULL;
 
 	switch(op) {
+	case OP_TRUNCATE:
+		if (!style)
+			size = random() % maxfilelen;
+		break;
 	case OP_FALLOCATE:
 		if (fallocate_calls && size && keep_size_calls)
 			keep_size = random() % 2;
@@ -1250,6 +1408,8 @@ test(void)
 		break;
 	}
 
+have_op:
+
 	switch (op) {
 	case OP_MAPREAD:
 		if (!mapped_reads)
@@ -1313,8 +1473,6 @@ test(void)
 		break;
 
 	case OP_TRUNCATE:
-		if (!style)
-			size = random() % maxfilelen;
 		dotruncate(size);
 		break;
 
@@ -1368,6 +1526,7 @@ out:
 		check_size();
 	if (closeopen)
 		docloseopen();
+	return 1;
 }
 
 
@@ -1594,6 +1753,11 @@ __test_fallocate(int mode, const char *mode_str)
 #endif
 }
 
+static struct option longopts[] = {
+	{"replay-ops", required_argument, 0, 256},
+	{ }
+};
+
 int
 main(int argc, char **argv)
 {
@@ -1613,8 +1777,9 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ"))
-	       != EOF)
+	while ((ch = getopt_long(argc, argv,
+				 "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
+				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
 			simulatedopcount = getnum(optarg, &endp);
@@ -1762,6 +1927,9 @@ main(int argc, char **argv)
 		case 'Z':
 			o_direct = O_DIRECT;
 			break;
+		case 256:  /* --replay-ops */
+			replayops = optarg;
+			break;
 		default:
 			usage();
 			/* NOTREACHED */
@@ -1827,6 +1995,17 @@ main(int argc, char **argv)
 		prterr(logfile);
 		exit(93);
 	}
+	strncat(opsfile, fname, 256);
+	strcat(opsfile, ".fsxops");
+	unlink(opsfile);
+
+	if (replayops) {
+		replayopsf = fopen(replayops, "r");
+		if (!replayopsf) {
+			prterr(replayops);
+			exit(93);
+		}
+	}
 
 #ifdef AIO
 	if (aio) 
@@ -1889,7 +2068,8 @@ main(int argc, char **argv)
 		insert_range_calls = test_fallocate(FALLOC_FL_INSERT_RANGE);
 
 	while (numops == -1 || numops--)
-		test();
+		if (!test())
+			break;
 
 	if (close(fd)) {
 		prterr("close");
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
