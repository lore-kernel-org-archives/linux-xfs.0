Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406388AbeKWEjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 23:39:47 -0500
Subject: [PATCH 07/12] fsx: add FICLONERANGE support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Nov 2018 09:59:12 -0800
Message-ID: <154290955225.1218.10970759549765550744.stgit@magnolia>
In-Reply-To: <154290950237.1218.9937108728673485814.stgit@magnolia>
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add support for the clone range (i.e. reflink) ioctl to fsx.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsx.c |  157 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 152 insertions(+), 5 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index c525ba13..f51d38cf 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -104,6 +104,7 @@ enum {
 	OP_ZERO_RANGE,
 	OP_COLLAPSE_RANGE,
 	OP_INSERT_RANGE,
+	OP_CLONE_RANGE,
 	OP_MAX_FULL,
 
 	/* integrity operations */
@@ -165,6 +166,7 @@ int	collapse_range_calls = 1;	/* -C flag disables */
 int	insert_range_calls = 1;		/* -I flag disables */
 int	mapped_reads = 1;		/* -R flag disables it */
 int	check_file = 0;			/* -X flag enables */
+int	clone_range_calls = 1;		/* -J flag disables */
 int	integrity = 0;			/* -i flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -258,6 +260,7 @@ static const char *op_names[] = {
 	[OP_ZERO_RANGE] = "zero_range",
 	[OP_COLLAPSE_RANGE] = "collapse_range",
 	[OP_INSERT_RANGE] = "insert_range",
+	[OP_CLONE_RANGE] = "clone_range",
 	[OP_FSYNC] = "fsync",
 };
 
@@ -320,7 +323,6 @@ log4(int operation, int arg0, int arg1, enum opflags flags)
 		logptr = 0;
 }
 
-
 void
 logdump(void)
 {
@@ -342,7 +344,7 @@ logdump(void)
 		count = LOGSIZE;
 	}
 	for ( ; count > 0; count--) {
-		bool overlap;
+		bool overlap, overlap2;
 		int opnum;
 
 		opnum = i+1 + (logcount/LOGSIZE)*LOGSIZE;
@@ -444,6 +446,20 @@ logdump(void)
 			if (overlap)
 				prt("\t******IIII");
 			break;
+		case OP_CLONE_RANGE:
+			prt("CLONE 0x%x thru 0x%x\t(0x%x bytes) to 0x%x thru 0x%x",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1],
+			    lp->args[2], lp->args[2] + lp->args[1] - 1);
+			overlap2 = badoff >= lp->args[2] &&
+				  badoff < lp->args[2] + lp->args[1];
+			if (overlap && overlap2)
+				prt("\tJJJJ**JJJJ");
+			else if (overlap)
+				prt("\tJJJJ******");
+			else if (overlap2)
+				prt("\t******JJJJ");
+			break;
 		case OP_FSYNC:
 			prt("FSYNC");
 			break;
@@ -1285,6 +1301,96 @@ do_insert_range(unsigned offset, unsigned length)
 }
 #endif
 
+#ifdef FICLONERANGE
+int
+test_clone_range(void)
+{
+	struct file_clone_range	fcr = {
+		.src_fd = fd,
+	};
+
+	if (ioctl(fd, FICLONERANGE, &fcr) &&
+	    (errno = EOPNOTSUPP || errno == ENOTTY)) {
+		if (!quiet)
+			fprintf(stderr,
+				"main: filesystem does not support "
+				"clone range, disabling!\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+void
+do_clone_range(unsigned offset, unsigned length, unsigned dest)
+{
+	struct file_clone_range	fcr = {
+		.src_fd = fd,
+		.src_offset = offset,
+		.src_length = length,
+		.dest_offset = dest,
+	};
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length clone range\n");
+		log5(OP_CLONE_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	if ((loff_t)offset >= file_size) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping clone range behind EOF\n");
+		log5(OP_CLONE_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	if (dest + length > biggest) {
+		biggest = dest + length;
+		if (!quiet && testcalls > simulatedopcount)
+			prt("cloning to largest ever: 0x%x\n", dest + length);
+	}
+
+	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		       dest <= monitorstart || dest + length <= monitorend))) {
+		prt("%lu clone\tfrom 0x%x to 0x%x, (0x%x bytes) at 0x%x\n",
+			testcalls, offset, offset+length, length, dest);
+	}
+
+	if (ioctl(fd, FICLONERANGE, &fcr) == -1) {
+		prt("clone range: 0x%x to 0x%x at 0x%x\n", offset,
+				offset + length, dest);
+		prterr("do_clone_range: FICLONERANGE");
+		report_failure(161);
+	}
+
+	memcpy(good_buf + dest, good_buf + offset, length);
+	if (dest > file_size)
+		memset(good_buf + file_size, '\0', dest - file_size);
+	if (dest + length > file_size)
+		file_size = dest + length;
+}
+
+#else
+int
+test_clone_range(void)
+{
+	return 0;
+}
+
+void
+do_clone_range(unsigned offset, unsigned length, unsigned dest)
+{
+	return;
+}
+#endif
+
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -1442,6 +1548,8 @@ static int
 op_args_count(int operation)
 {
 	switch (operation) {
+	case OP_CLONE_RANGE:
+		return 4;
 	default:
 		return 3;
 	}
@@ -1515,7 +1623,7 @@ read_op(struct log_entry *log_entry)
 int
 test(void)
 {
-	unsigned long	offset;
+	unsigned long	offset, offset2;
 	unsigned long	size;
 	unsigned long	rv;
 	unsigned long	op;
@@ -1546,6 +1654,7 @@ test(void)
 			op = log_entry.operation;
 			offset = log_entry.args[0];
 			size = log_entry.args[1];
+			offset2 = log_entry.args[2];
 			closeopen = !!(log_entry.flags & FL_CLOSE_OPEN);
 			keep_size = !!(log_entry.flags & FL_KEEP_SIZE);
 			goto have_op;
@@ -1558,6 +1667,7 @@ test(void)
 		closeopen = (rv >> 3) < (1 << 28) / closeprob;
 
 	offset = random();
+	offset2 = 0;
 	size = maxoplen;
 	if (randomoplen)
 		size = random() % (maxoplen + 1);
@@ -1583,6 +1693,17 @@ test(void)
 		if (zero_range_calls && size && keep_size_calls)
 			keep_size = random() % 2;
 		break;
+	case OP_CLONE_RANGE:
+		TRIM_OFF_LEN(offset, size, file_size);
+		offset = offset & ~(block_size - 1);
+		size = size & ~(block_size - 1);
+		do {
+			offset2 = random();
+			TRIM_OFF(offset2, maxfilelen);
+			offset2 = offset2 & ~(block_size - 1);
+		} while (llabs(offset2 - offset) < size ||
+			 offset2 + size > maxfilelen);
+		break;
 	}
 
 have_op:
@@ -1626,6 +1747,12 @@ test(void)
 			goto out;
 		}
 		break;
+	case OP_CLONE_RANGE:
+		if (!clone_range_calls) {
+			log5(op, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+		break;
 	}
 
 	switch (op) {
@@ -1692,6 +1819,18 @@ test(void)
 
 		do_insert_range(offset, size);
 		break;
+	case OP_CLONE_RANGE:
+		if (size == 0) {
+			log5(OP_CLONE_RANGE, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+		if (offset2 + size > maxfilelen) {
+			log5(OP_CLONE_RANGE, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+
+		do_clone_range(offset, size, offset2);
+		break;
 	case OP_FSYNC:
 		dofsync();
 		break;
@@ -1717,7 +1856,7 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dknqxAFLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dknqxAFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
@@ -1758,6 +1897,9 @@ usage(void)
 #ifdef FALLOC_FL_INSERT_RANGE
 "	-I: Do not use insert range calls\n"
 #endif
+#ifdef FICLONERANGE
+"	-J: Do not use clone range calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -1961,7 +2103,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WXZ",
+				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyAD:FJKHzCILN:OP:RS:WXZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -2091,6 +2233,9 @@ main(int argc, char **argv)
 		case 'I':
 			insert_range_calls = 0;
 			break;
+		case 'J':
+			clone_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			o_flags &= ~(O_CREAT|O_TRUNC);
@@ -2309,6 +2454,8 @@ main(int argc, char **argv)
 		collapse_range_calls = test_fallocate(FALLOC_FL_COLLAPSE_RANGE);
 	if (insert_range_calls)
 		insert_range_calls = test_fallocate(FALLOC_FL_INSERT_RANGE);
+	if (clone_range_calls)
+		clone_range_calls = test_clone_range();
 
 	while (numops == -1 || numops--)
 		if (!test())
