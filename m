Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35051 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdH3Ovb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:31 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 07/14] fsx: add optional logid prefix to log messages
Date: Wed, 30 Aug 2017 17:51:39 +0300
Message-Id: <1504104706-11965-8-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

When writing the intermixed output of several fsx processes
to a single log file, it is usefull to prefix logs with a log id.
Use fsx -j <logid> to define the log messages prefix.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 ltp/fsx.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index d206a3a..a6420f6 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -132,6 +132,7 @@ unsigned long	simulatedopcount = 0;	/* -b flag */
 int	closeprob = 0;			/* -c flag */
 int	debug = 0;			/* -d flag */
 unsigned long	debugstart = 0;		/* -D flag */
+int	logid = 0;			/* -j flag */
 int	flush = 0;			/* -f flag */
 int	do_fsync = 0;			/* -y flag */
 unsigned long	maxfilelen = 256 * 1024;	/* -l flag */
@@ -195,13 +196,16 @@ static void *round_ptr_up(void *ptr, unsigned long align, unsigned long offset)
 }
 
 void
-vwarnc(int code, const char *fmt, va_list ap) {
-  fprintf(stderr, "fsx: ");
-  if (fmt != NULL) {
-	vfprintf(stderr, fmt, ap);
-	fprintf(stderr, ": ");
-  }
-  fprintf(stderr, "%s\n", strerror(code));
+vwarnc(int code, const char *fmt, va_list ap)
+{
+	if (logid)
+		fprintf(stderr, "%d: ", logid);
+	fprintf(stderr, "fsx: ");
+	if (fmt != NULL) {
+		vfprintf(stderr, fmt, ap);
+		fprintf(stderr, ": ");
+	}
+	fprintf(stderr, "%s\n", strerror(code));
 }
 
 void
@@ -223,6 +227,8 @@ prt(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buffer, BUF_SIZE, fmt, args);
 	va_end(args);
+	if (logid)
+		fprintf(stdout, "%d: ", logid);
 	fputs(buffer, stdout);
 	if (fsxlogf)
 		fputs(buffer, fsxlogf);
@@ -1624,12 +1630,13 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-i logdev] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
 	-f flush and invalidate cache after I/O\n\
 	-i logdev: do integrity testing, logdev is the dm log writes device\n\
+	-j logid: prefix logs with this id\n\
 	-l flen: the upper bound on file size (default 262144)\n\
 	-m startop:endop: monitor (print debug output) specified byte range (default 0:infinity)\n\
 	-n: no verifications of file size\n\
@@ -1862,7 +1869,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfi:l:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
+				 "b:c:dfi:j:l:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -1897,6 +1904,9 @@ main(int argc, char **argv)
 				exit(101);
 			}
 			break;
+		case 'j':
+			logid = getnum(optarg, &endp);
+			break;
 		case 'l':
 			maxfilelen = getnum(optarg, &endp);
 			if (maxfilelen <= 0)
-- 
2.7.4

