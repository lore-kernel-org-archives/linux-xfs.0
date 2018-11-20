Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48958 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbeKUI2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 03:28:39 -0500
Subject: [PATCH 06/10] fsx: add FIDEDUPERANGE support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Nov 2018 13:57:18 -0800
Message-ID: <154275103811.8611.6606584641150172917.stgit@magnolia>
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
 ltp/fsx.c |  141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 139 insertions(+), 2 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index a1a44b23..6f6263e2 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -105,6 +105,7 @@ enum {
 	OP_COLLAPSE_RANGE,
 	OP_INSERT_RANGE,
 	OP_CLONE_RANGE,
+	OP_DEDUPE_RANGE,
 	OP_MAX_FULL,
 
 	/* integrity operations */
@@ -167,6 +168,7 @@ int	insert_range_calls = 1;		/* -I flag disables */
 int	mapped_reads = 1;		/* -R flag disables it */
 int	check_file = 1;			/* -X flag disables */
 int	clone_range_calls = 1;		/* -J flag disables */
+int	dedupe_range_calls = 1;		/* -B flag disables */
 int	integrity = 0;			/* -i flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -261,6 +263,7 @@ static const char *op_names[] = {
 	[OP_COLLAPSE_RANGE] = "collapse_range",
 	[OP_INSERT_RANGE] = "insert_range",
 	[OP_CLONE_RANGE] = "clone_range",
+	[OP_DEDUPE_RANGE] = "dedupe_range",
 	[OP_FSYNC] = "fsync",
 };
 
@@ -460,6 +463,20 @@ logdump(void)
 			else if (overlap2)
 				prt("\t******JJJJ");
 			break;
+		case OP_DEDUPE_RANGE:
+			prt("DEDUPE 0x%x thru 0x%x\t(0x%x bytes) to 0x%x thru 0x%x",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1],
+			    lp->args[2], lp->args[2] + lp->args[1] - 1);
+			overlap2 = badoff >= lp->args[2] &&
+				  badoff < lp->args[2] + lp->args[1];
+			if (overlap && overlap2)
+				prt("\tBBBB**BBBB");
+			else if (overlap)
+				prt("\tBBBB******");
+			else if (overlap2)
+				prt("\t******BBBB");
+			break;
 		case OP_FSYNC:
 			prt("FSYNC");
 			break;
@@ -1368,6 +1385,82 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
 }
 #endif
 
+#ifdef FIDEDUPERANGE
+void
+do_dedupe_range(unsigned offset, unsigned length, unsigned dest)
+{
+	struct file_dedupe_range *fdr;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length dedupe range\n");
+		log5(OP_DEDUPE_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	if ((loff_t)offset >= file_size) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping dedupe range behind EOF\n");
+		log5(OP_DEDUPE_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	log5(OP_DEDUPE_RANGE, offset, length, dest, FL_NONE);
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		       dest <= monitorstart || dest + length <= monitorend))) {
+		prt("%lu dedupe\tfrom 0x%x to 0x%x, (0x%x bytes) at 0x%x\n",
+			testcalls, offset, offset+length, length, dest);
+	}
+
+	/* Alloc memory */
+	fdr = malloc(sizeof(struct file_dedupe_range_info) +
+		     sizeof(struct file_dedupe_range));
+	if (!fdr) {
+		prterr("do_dedupe_range: malloc");
+		report_failure(161);
+	}
+	memset(fdr, 0, (sizeof(struct file_dedupe_range_info) +
+			sizeof(struct file_dedupe_range)));
+
+	/* Dedupe data blocks */
+	fdr->src_offset = offset;
+	fdr->src_length = length;
+	fdr->dest_count = 1;
+	fdr->info[0].dest_fd = fd;
+	fdr->info[0].dest_offset = dest;
+
+	if (ioctl(fd, FIDEDUPERANGE, fdr) == -1) {
+		if (errno == EOPNOTSUPP || errno == ENOTTY) {
+			if (!quiet && testcalls > simulatedopcount)
+				prt("skipping unsupported dedupe range\n");
+			logptr--;
+			log5(OP_DEDUPE_RANGE, offset, length, dest, FL_SKIPPED);
+			free(fdr);
+			return;
+		}
+
+		prt("dedupe range: 0x%x to 0x%x at 0x%x\n", offset,
+				offset + length, dest);
+		prterr("do_dedupe_range: FIDEDUPERANGE");
+		report_failure(161);
+	}
+
+	free(fdr);
+}
+
+#else
+void
+do_dedupe_range(unsigned offset, unsigned length, unsigned dest)
+{
+	return;
+}
+#endif
+
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -1526,6 +1619,7 @@ op_args_count(int operation)
 {
 	switch (operation) {
 	case OP_CLONE_RANGE:
+	case OP_DEDUPE_RANGE:
 		return 4;
 	default:
 		return 3;
@@ -1682,6 +1776,25 @@ test(void)
 		} while (llabs(offset2 - offset) < size ||
 			 offset2 + size > maxfilelen);
 		break;
+	case OP_DEDUPE_RANGE:
+		{
+			int tries = 0;
+
+			TRIM_OFF_LEN(offset, size, file_size);
+			offset = offset & ~(block_size - 1);
+			size = size & ~(block_size - 1);
+			do {
+				if (tries++ >= 30) {
+					size = 0;
+					break;
+				}
+				offset2 = random();
+				TRIM_OFF(offset2, file_size);
+				offset2 = offset2 & ~(block_size - 1);
+			} while (llabs(offset2 - offset) < size ||
+				 offset2 + size > file_size);
+			break;
+		}
 	}
 
 have_op:
@@ -1731,6 +1844,12 @@ test(void)
 			goto out;
 		}
 		break;
+	case OP_DEDUPE_RANGE:
+		if (!dedupe_range_calls) {
+			log5(op, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+		break;
 	}
 
 	switch (op) {
@@ -1809,6 +1928,18 @@ test(void)
 
 		do_clone_range(offset, size, offset2);
 		break;
+	case OP_DEDUPE_RANGE:
+		if (size == 0) {
+			log5(OP_DEDUPE_RANGE, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+		if (offset2 + size > maxfilelen) {
+			log5(OP_DEDUPE_RANGE, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+
+		do_dedupe_range(offset, size, offset2);
+		break;
 	case OP_FSYNC:
 		dofsync();
 		break;
@@ -1834,7 +1965,7 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dknqxAFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dknqxABFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
@@ -1878,6 +2009,9 @@ usage(void)
 #ifdef FICLONERANGE
 "	-J: Do not use clone range calls\n"
 #endif
+#ifdef FIDEDUPERANGE
+"	-B: Do not use dedupe range calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -2081,7 +2215,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyAD:FJKHzCILN:OP:RS:WXZ",
+				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:FJKHzCILN:OP:RS:WXZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -2214,6 +2348,9 @@ main(int argc, char **argv)
 		case 'J':
 			clone_range_calls = 0;
 			break;
+		case 'B':
+			dedupe_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			o_flags &= ~(O_CREAT|O_TRUNC);
