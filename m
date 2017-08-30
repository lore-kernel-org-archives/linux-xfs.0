Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33482 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751811AbdH3Ovd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:33 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 09/14] fsx: add support for -g filldata
Date: Wed, 30 Aug 2017 17:51:41 +0300
Message-Id: <1504104706-11965-10-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

-g X: write character X instead of random generated data

This is useful to compare holes between good and bad buffer.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 ltp/fsx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index dd6b637..a75bc55 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -132,6 +132,7 @@ unsigned long	simulatedopcount = 0;	/* -b flag */
 int	closeprob = 0;			/* -c flag */
 int	debug = 0;			/* -d flag */
 unsigned long	debugstart = 0;		/* -D flag */
+char	filldata = 0;			/* -g flag */
 int	logid = 0;			/* -j flag */
 int	flush = 0;			/* -f flag */
 int	do_fsync = 0;			/* -y flag */
@@ -817,6 +818,8 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
 		good_buf[offset] = testcalls % 256; 
 		if (offset % 2)
 			good_buf[offset] += original_buf[offset];
+		if (filldata)
+			good_buf[offset] = filldata;
 		offset++;
 	}
 }
@@ -1631,11 +1634,12 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
 	-f flush and invalidate cache after I/O\n\
+	-g X: write character X instead of random generated data\n\
 	-i logdev: do integrity testing, logdev is the dm log writes device\n\
 	-j logid: prefix logs with this id\n\
 	-l flen: the upper bound on file size (default 262144)\n\
@@ -1873,7 +1877,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfi:j:l:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
+				 "b:c:dfg:i:j:l:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -1900,6 +1904,9 @@ main(int argc, char **argv)
 		case 'f':
 			flush = 1;
 			break;
+		case 'g':
+			filldata = *optarg;
+			break;
 		case 'i':
 			integrity = 1;
 			logdev = strdup(optarg);
-- 
2.7.4

