Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37949 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdH3Ova (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:30 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 06/14] fsx: add support for integrity check with dm-log-writes target
Date: Wed, 30 Aug 2017 17:51:38 +0300
Message-Id: <1504104706-11965-7-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Cherry-picked the relevant fsx bits from commit 70d41e17164b
in Josef Bacik's fstests tree (https://github.com/josefbacik/fstests).
Quoting from Josef's commit message:

  I've rigged up fsx to have an integrity check mode.  Basically it works
  like it normally works, but when it fsync()'s it marks the log with a
  unique mark and dumps it's buffer to a file with the mark in the filename.
  I did this with a system() call simply because it was the fastest.  I can
  link the device-mapper libraries and do it programatically if that would
  be preferred, but this works pretty well.

  Signed-off-by: Josef Bacik <jbacik@fb.com>

[Amir:]
- Fix some exit codes
- Require -P dirpath for -i logdev

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 ltp/fsx.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 123 insertions(+), 24 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index e789aad..d206a3a 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -67,15 +67,17 @@ int			logcount = 0;	/* total ops */
  * be careful in how we select the different operations. The active operations
  * are mapped to numbers as follows:
  *
- *		lite	!lite
- * READ:	0	0
- * WRITE:	1	1
- * MAPREAD:	2	2
- * MAPWRITE:	3	3
- * TRUNCATE:	-	4
- * FALLOCATE:	-	5
- * PUNCH HOLE:	-	6
- * ZERO RANGE:	-	7
+ *			lite	!lite	integrity
+ * READ:		0	0	0
+ * WRITE:		1	1	1
+ * MAPREAD:		2	2	2
+ * MAPWRITE:		3	3	3
+ * TRUNCATE:		-	4	4
+ * FALLOCATE:		-	5	5
+ * PUNCH HOLE:		-	6	6
+ * ZERO RANGE:		-	7	7
+ * COLLAPSE RANGE:	-	8	8
+ * FSYNC:		-	-	9
  *
  * When mapped read/writes are disabled, they are simply converted to normal
  * reads and writes. When fallocate/fpunch calls are disabled, they are
@@ -102,6 +104,10 @@ int			logcount = 0;	/* total ops */
 #define OP_INSERT_RANGE	9
 #define OP_MAX_FULL		10
 
+/* integrity operations */
+#define OP_FSYNC		10
+#define OP_MAX_INTEGRITY	11
+
 #undef PAGE_SIZE
 #define PAGE_SIZE       getpagesize()
 #undef PAGE_MASK
@@ -111,6 +117,10 @@ char	*original_buf;			/* a pointer to the original data */
 char	*good_buf;			/* a pointer to the correct data */
 char	*temp_buf;			/* a pointer to the current data */
 char	*fname;				/* name of our test file */
+char	*bname;				/* basename of our test file */
+char	*logdev;			/* -i flag */
+char	dname[1024];			/* -P flag */
+int	dirpath = 0;			/* -P flag */
 int	fd;				/* fd for our test file */
 
 blksize_t	block_size = 0;
@@ -148,9 +158,11 @@ int     zero_range_calls = 1;           /* -z flag disables */
 int	collapse_range_calls = 1;	/* -C flag disables */
 int	insert_range_calls = 1;		/* -I flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
+int	integrity = 0;			/* -i flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
 int	aio = 0;
+int	mark_nr = 0;
 
 int page_size;
 int page_mask;
@@ -234,6 +246,7 @@ static const char *op_names[] = {
 	[OP_ZERO_RANGE] = "zero_range",
 	[OP_COLLAPSE_RANGE] = "collapse_range",
 	[OP_INSERT_RANGE] = "insert_range",
+	[OP_FSYNC] = "fsync",
 };
 
 static const char *op_name(int operation)
@@ -397,6 +410,9 @@ logdump(void)
 			if (overlap)
 				prt("\t******IIII");
 			break;
+		case OP_FSYNC:
+			prt("FSYNC");
+			break;
 		default:
 			prt("BOGUS LOG ENTRY (operation code = %d)!",
 			    lp->operation);
@@ -500,6 +516,43 @@ report_failure(int status)
 				        *(((unsigned char *)(cp)) + 1)))
 
 void
+mark_log(void)
+{
+	char command[256];
+	int ret;
+
+	snprintf(command, 256, "dmsetup message %s 0 mark %s.mark%d", logdev,
+		 bname, mark_nr);
+	ret = system(command);
+	if (ret) {
+		prterr("dmsetup mark failed");
+		exit(211);
+	}
+}
+
+void
+dump_fsync_buffer(void)
+{
+	char fname_buffer[1024];
+	int good_fd;
+
+	if (!good_buf)
+		return;
+
+	snprintf(fname_buffer, 1024, "%s%s.mark%d", dname,
+		 bname, mark_nr);
+	good_fd = open(fname_buffer, O_WRONLY|O_CREAT|O_TRUNC, 0666);
+	if (good_fd < 0) {
+		prterr(fname_buffer);
+		exit(212);
+	}
+
+	save_buffer(good_buf, file_size, good_fd);
+	close(good_fd);
+	prt("Dumped fsync buffer to %s\n", fname_buffer + dirpath);
+}
+
+void
 check_buffers(unsigned offset, unsigned size)
 {
 	unsigned char c, t;
@@ -1256,6 +1309,25 @@ docloseopen(void)
 	}
 }
 
+void
+dofsync(void)
+{
+	int ret;
+
+	if (testcalls <= simulatedopcount)
+		return;
+	if (debug)
+		prt("%lu fsync\n", testcalls);
+	log4(OP_FSYNC, 0, 0, 0);
+	ret = fsync(fd);
+	if (ret < 0) {
+		prterr("dofsync");
+		report_failure(210);
+	}
+	mark_log();
+	dump_fsync_buffer();
+	mark_nr++;
+}
 
 #define TRIM_OFF(off, size)			\
 do {						\
@@ -1403,8 +1475,10 @@ test(void)
 	/* calculate appropriate op to run */
 	if (lite)
 		op = rv % OP_MAX_LITE;
-	else
+	else if (!integrity)
 		op = rv % OP_MAX_FULL;
+	else
+		op = rv % OP_MAX_INTEGRITY;
 
 	switch(op) {
 	case OP_TRUNCATE:
@@ -1528,6 +1602,9 @@ have_op:
 
 		do_insert_range(offset, size);
 		break;
+	case OP_FSYNC:
+		dofsync();
+		break;
 	default:
 		prterr("test: unknown operation");
 		report_failure(42);
@@ -1547,11 +1624,12 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-i logdev] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
 	-f flush and invalidate cache after I/O\n\
+	-i logdev: do integrity testing, logdev is the dm log writes device\n\
 	-l flen: the upper bound on file size (default 262144)\n\
 	-m startop:endop: monitor (print debug output) specified byte range (default 0:infinity)\n\
 	-n: no verifications of file size\n\
@@ -1767,14 +1845,14 @@ int
 main(int argc, char **argv)
 {
 	int	i, style, ch;
-	char	*endp;
+	char	*endp, *tmp;
 	char goodfile[1024];
 	char logfile[1024];
-	int dirpath = 0;
 	struct stat statbuf;
 
 	goodfile[0] = 0;
 	logfile[0] = 0;
+	dname[0] = 0;
 
 	page_size = getpagesize();
 	page_mask = page_size - 1;
@@ -1784,7 +1862,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
+				 "b:c:dfi:l:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -1811,6 +1889,14 @@ main(int argc, char **argv)
 		case 'f':
 			flush = 1;
 			break;
+		case 'i':
+			integrity = 1;
+			logdev = strdup(optarg);
+			if (!logdev) {
+				prterr("strdup");
+				exit(101);
+			}
+			break;
 		case 'l':
 			maxfilelen = getnum(optarg, &endp);
 			if (maxfilelen <= 0)
@@ -1908,13 +1994,13 @@ main(int argc, char **argv)
 			randomoplen = 0;
 			break;
 		case 'P':
-			strncpy(goodfile, optarg, sizeof(goodfile));
-			strcat(goodfile, "/");
-			strncpy(logfile, optarg, sizeof(logfile));
-			strcat(logfile, "/");
-			strncpy(opsfile, optarg, sizeof(logfile));
-			strcat(opsfile, "/");
-			dirpath = 1;
+			strncpy(dname, optarg, sizeof(dname));
+			strcat(dname, "/");
+			dirpath = strlen(dname);
+
+			strncpy(goodfile, dname, sizeof(goodfile));
+			strncpy(logfile, dname, sizeof(logfile));
+			strncpy(opsfile, dname, sizeof(logfile));
 			break;
                 case 'R':
                         mapped_reads = 0;
@@ -1949,7 +2035,19 @@ main(int argc, char **argv)
 	argv += optind;
 	if (argc != 1)
 		usage();
+
+	if (integrity && !dirpath) {
+		fprintf(stderr, "option -i <logdev> requires -P <dirpath>\n");
+		usage();
+	}
+
 	fname = argv[0];
+	tmp = strdup(fname);
+	if (!tmp) {
+		prterr("strdup");
+		exit(101);
+	}
+	bname = basename(tmp);
 
 	signal(SIGHUP,	cleanup);
 	signal(SIGINT,	cleanup);
@@ -1991,21 +2089,21 @@ main(int argc, char **argv)
 		}
 	}
 #endif
-	strncat(goodfile, dirpath ? basename(fname) : fname, 256);
+	strncat(goodfile, dirpath ? bname : fname, 256);
 	strcat (goodfile, ".fsxgood");
 	fsxgoodfd = open(goodfile, O_RDWR|O_CREAT|O_TRUNC, 0666);
 	if (fsxgoodfd < 0) {
 		prterr(goodfile);
 		exit(92);
 	}
-	strncat(logfile, dirpath ? basename(fname) : fname, 256);
+	strncat(logfile, dirpath ? bname : fname, 256);
 	strcat (logfile, ".fsxlog");
 	fsxlogf = fopen(logfile, "w");
 	if (fsxlogf == NULL) {
 		prterr(logfile);
 		exit(93);
 	}
-	strncat(opsfile, dirpath ? basename(fname) : fname, 256);
+	strncat(opsfile, dirpath ? bname : fname, 256);
 	strcat(opsfile, ".fsxops");
 	unlink(opsfile);
 
@@ -2081,6 +2179,7 @@ main(int argc, char **argv)
 		if (!test())
 			break;
 
+	free(tmp);
 	if (close(fd)) {
 		prterr("close");
 		report_failure(99);
-- 
2.7.4

