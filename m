Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33644 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbeKUI3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 03:29:01 -0500
Subject: [PATCH 08/10] fsx: add copy_file_range support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Nov 2018 13:57:38 -0800
Message-ID: <154275105839.8611.5707428732705773914.stgit@magnolia>
In-Reply-To: <154275100143.8611.10235098565750994724.stgit@magnolia>
References: <154275100143.8611.10235098565750994724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsx.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 2 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 6f6263e2..ec3defad 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -34,6 +34,7 @@
 #ifdef AIO
 #include <libaio.h>
 #endif
+#include <sys/syscall.h>
 
 #ifndef MAP_FILE
 # define MAP_FILE 0
@@ -106,6 +107,7 @@ enum {
 	OP_INSERT_RANGE,
 	OP_CLONE_RANGE,
 	OP_DEDUPE_RANGE,
+	OP_COPY_RANGE,
 	OP_MAX_FULL,
 
 	/* integrity operations */
@@ -169,6 +171,7 @@ int	mapped_reads = 1;		/* -R flag disables it */
 int	check_file = 1;			/* -X flag disables */
 int	clone_range_calls = 1;		/* -J flag disables */
 int	dedupe_range_calls = 1;		/* -B flag disables */
+int	copy_range_calls = 1;		/* -E flag disables */
 int	integrity = 0;			/* -i flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -264,6 +267,7 @@ static const char *op_names[] = {
 	[OP_INSERT_RANGE] = "insert_range",
 	[OP_CLONE_RANGE] = "clone_range",
 	[OP_DEDUPE_RANGE] = "dedupe_range",
+	[OP_COPY_RANGE] = "copy_range",
 	[OP_FSYNC] = "fsync",
 };
 
@@ -477,6 +481,20 @@ logdump(void)
 			else if (overlap2)
 				prt("\t******BBBB");
 			break;
+		case OP_COPY_RANGE:
+			prt("COPY 0x%x thru 0x%x\t(0x%x bytes) to 0x%x thru 0x%x",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1],
+			    lp->args[2], lp->args[2] + lp->args[1] - 1);
+			overlap2 = badoff >= lp->args[2] &&
+				  badoff < lp->args[2] + lp->args[1];
+			if (overlap && overlap2)
+				prt("\tEEEE**EEEE");
+			else if (overlap)
+				prt("\tEEEE******");
+			else if (overlap2)
+				prt("\t******EEEE");
+			break;
 		case OP_FSYNC:
 			prt("FSYNC");
 			break;
@@ -1461,6 +1479,73 @@ do_dedupe_range(unsigned offset, unsigned length, unsigned dest)
 }
 #endif
 
+#ifdef HAVE_COPY_FILE_RANGE
+void
+do_copy_range(unsigned offset, unsigned length, unsigned dest)
+{
+	loff_t o1, o2;
+	ssize_t nr;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length copy range\n");
+		log5(OP_COPY_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	if ((loff_t)offset >= file_size) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping copy range behind EOF\n");
+		log5(OP_COPY_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		       dest <= monitorstart || dest + length <= monitorend))) {
+		prt("%lu copy\tfrom 0x%x to 0x%x, (0x%x bytes) at 0x%x\n",
+			testcalls, offset, offset+length, length, dest);
+	}
+
+	o1 = offset;
+	o2 = dest;
+
+	nr = copy_file_range(fd, &o1, fd, &o2, length, 0);
+	if (nr == -1) {
+		if (errno == EOPNOTSUPP || errno == ENOTTY) {
+			if (!quiet && testcalls > simulatedopcount)
+				prt("skipping unsupported copy range\n");
+			logptr--;
+			log5(OP_COPY_RANGE, offset, length, dest, FL_SKIPPED);
+			return;
+		}
+
+		prt("copy range: 0x%x to 0x%x at 0x%x\n", offset,
+				offset + length, dest);
+		prterr("do_copy_range:");
+		report_failure(161);
+	}
+
+	memcpy(good_buf + dest, good_buf + offset, nr);
+	if (dest > file_size)
+		memset(good_buf + file_size, '\0', dest - file_size);
+	if (dest + nr > file_size)
+		file_size = dest + nr;
+}
+
+#else
+void
+do_copy_range(unsigned offset, unsigned length, unsigned dest)
+{
+	return;
+}
+#endif
+
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -1620,6 +1705,7 @@ op_args_count(int operation)
 	switch (operation) {
 	case OP_CLONE_RANGE:
 	case OP_DEDUPE_RANGE:
+	case OP_COPY_RANGE:
 		return 4;
 	default:
 		return 3;
@@ -1795,6 +1881,14 @@ test(void)
 				 offset2 + size > file_size);
 			break;
 		}
+	case OP_COPY_RANGE:
+		TRIM_OFF_LEN(offset, size, file_size);
+		do {
+			offset2 = random();
+			TRIM_OFF(offset2, maxfilelen);
+		} while (llabs(offset2 - offset) < size ||
+			 offset2 + size > maxfilelen);
+		break;
 	}
 
 have_op:
@@ -1850,6 +1944,12 @@ test(void)
 			goto out;
 		}
 		break;
+	case OP_COPY_RANGE:
+		if (!copy_range_calls) {
+			log5(op, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+		break;
 	}
 
 	switch (op) {
@@ -1940,6 +2040,18 @@ test(void)
 
 		do_dedupe_range(offset, size, offset2);
 		break;
+	case OP_COPY_RANGE:
+		if (size == 0) {
+			log5(OP_COPY_RANGE, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+		if (offset2 + size > maxfilelen) {
+			log5(OP_COPY_RANGE, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+
+		do_copy_range(offset, size, offset2);
+		break;
 	case OP_FSYNC:
 		dofsync();
 		break;
@@ -1965,7 +2077,7 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dknqxABFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dknqxABEFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
@@ -2012,6 +2124,9 @@ usage(void)
 #ifdef FIDEDUPERANGE
 "	-B: Do not use dedupe range calls\n"
 #endif
+#ifdef HAVE_COPY_FILE_RANGE
+"	-E: Do not use copy range calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -2215,7 +2330,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:FJKHzCILN:OP:RS:WXZ",
+				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:WXZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -2351,6 +2466,9 @@ main(int argc, char **argv)
 		case 'B':
 			dedupe_range_calls = 0;
 			break;
+		case 'E':
+			copy_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			o_flags &= ~(O_CREAT|O_TRUNC);
