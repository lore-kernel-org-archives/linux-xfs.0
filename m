Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37100 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbeKNJkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 04:40:32 -0500
Subject: [PATCH 2/6] fsx: add FIDEDUPERANGE support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 13 Nov 2018 15:39:49 -0800
Message-ID: <154215238968.21151.11312208246254421488.stgit@magnolia>
In-Reply-To: <154215237717.21151.11976488103599724788.stgit@magnolia>
References: <154215237717.21151.11976488103599724788.stgit@magnolia>
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
 ltp/fsx.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 2b0a2b28..6f2b3364 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -104,6 +104,7 @@ enum {
 	OP_COLLAPSE_RANGE,
 	OP_INSERT_RANGE,
 	OP_CLONE_RANGE,
+	OP_DEDUPE_RANGE,
 	OP_MAX_FULL,
 
 	/* integrity operations */
@@ -259,6 +260,7 @@ static const char *op_names[] = {
 	[OP_COLLAPSE_RANGE] = "collapse_range",
 	[OP_INSERT_RANGE] = "insert_range",
 	[OP_CLONE_RANGE] = "clone_range",
+	[OP_DEDUPE_RANGE] = "dedupe_range",
 	[OP_FSYNC] = "fsync",
 };
 
@@ -448,6 +450,13 @@ logdump(void)
 			if (overlap)
 				prt("\t******IIII");
 			break;
+		case OP_DEDUPE_RANGE:
+			prt("DEDUPE 0x%x thru 0x%x\t(0x%x bytes) to 0x%x",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1], lp->args[2]);
+			if (overlap)
+				prt("\t******IIII");
+			break;
 		case OP_FSYNC:
 			prt("FSYNC");
 			break;
@@ -1315,6 +1324,82 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
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
@@ -1615,6 +1700,25 @@ test(void)
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
@@ -1659,6 +1763,7 @@ test(void)
 		}
 		break;
 	case OP_CLONE_RANGE:
+	case OP_DEDUPE_RANGE:
 		if (!remap_calls) {
 			log5(op, offset, size, offset2, FL_SKIPPED);
 			goto out;
@@ -1742,6 +1847,18 @@ test(void)
 
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
