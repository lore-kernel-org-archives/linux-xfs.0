Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38308 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406520AbeKWEkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 23:40:03 -0500
Subject: [PATCH 10/12] fsx: add copy_file_range support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Nov 2018 09:59:31 -0800
Message-ID: <154290957142.1218.8388379045411939584.stgit@magnolia>
In-Reply-To: <154290950237.1218.9937108728673485814.stgit@magnolia>
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add support for the copy_file_range system call to fsx.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[dchinner: copy_file_range() needs to obey read/write constraints
otherwise is blows up when direct IO is used]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 ltp/fsx.c |  150 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 148 insertions(+), 2 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 577c7309..92e4c30f 100644
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
 int	check_file = 0;			/* -X flag enables */
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
@@ -1539,6 +1557,99 @@ do_dedupe_range(unsigned offset, unsigned length, unsigned dest)
 }
 #endif
 
+#ifdef HAVE_COPY_FILE_RANGE
+int
+test_copy_range(void)
+{
+	loff_t o1 = 0, o2 = 0;
+
+	if (copy_file_range(fd, &o1, fd, &o2, 0, 0) == -1 &&
+	    (errno == EOPNOTSUPP || errno == ENOTTY)) {
+		if (!quiet)
+			fprintf(stderr,
+				"main: filesystem does not support "
+				"copy range, disabling!\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+void
+do_copy_range(unsigned offset, unsigned length, unsigned dest)
+{
+	loff_t o1, o2;
+	ssize_t nr;
+
+	offset -= offset % readbdy;
+	dest -= dest % writebdy;
+	if (o_direct)
+		length -= length % readbdy;
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
+	if (dest + length > biggest) {
+		biggest = dest + length;
+		if (!quiet && testcalls > simulatedopcount)
+			prt("copying to largest ever: 0x%x\n", dest + length);
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
+int
+test_copy_range(void)
+{
+	return 0;
+}
+
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
@@ -1698,6 +1809,7 @@ op_args_count(int operation)
 	switch (operation) {
 	case OP_CLONE_RANGE:
 	case OP_DEDUPE_RANGE:
+	case OP_COPY_RANGE:
 		return 4;
 	default:
 		return 3;
@@ -1872,6 +1984,14 @@ test(void)
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
@@ -1927,6 +2047,12 @@ test(void)
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
@@ -2017,6 +2143,18 @@ test(void)
 
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
@@ -2042,7 +2180,7 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dknqxABFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dknqxABEFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
@@ -2089,6 +2227,9 @@ usage(void)
 #ifdef FIDEDUPERANGE
 "	-B: Do not use dedupe range calls\n"
 #endif
+#ifdef HAVE_COPY_FILE_RANGE
+"	-E: Do not use copy range calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -2292,7 +2433,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:FJKHzCILN:OP:RS:WXZ",
+				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:WXZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -2428,6 +2569,9 @@ main(int argc, char **argv)
 		case 'B':
 			dedupe_range_calls = 0;
 			break;
+		case 'E':
+			copy_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			o_flags &= ~(O_CREAT|O_TRUNC);
@@ -2650,6 +2794,8 @@ main(int argc, char **argv)
 		clone_range_calls = test_clone_range();
 	if (dedupe_range_calls)
 		dedupe_range_calls = test_dedupe_range();
+	if (copy_range_calls)
+		copy_range_calls = test_copy_range();
 
 	while (numops == -1 || numops--)
 		if (!test())
