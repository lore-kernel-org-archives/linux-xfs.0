Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55314 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbeKNJku (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 04:40:50 -0500
Subject: [PATCH 4/6] fsx: add copy_file_range support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 13 Nov 2018 15:40:05 -0800
Message-ID: <154215240539.21151.10456496832542456055.stgit@magnolia>
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
 ltp/fsx.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 6f2b3364..3161ba12 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -34,6 +34,7 @@
 #ifdef AIO
 #include <libaio.h>
 #endif
+#include <sys/syscall.h>
 
 #ifndef MAP_FILE
 # define MAP_FILE 0
@@ -105,6 +106,7 @@ enum {
 	OP_INSERT_RANGE,
 	OP_CLONE_RANGE,
 	OP_DEDUPE_RANGE,
+	OP_COPY_RANGE,
 	OP_MAX_FULL,
 
 	/* integrity operations */
@@ -261,6 +263,7 @@ static const char *op_names[] = {
 	[OP_INSERT_RANGE] = "insert_range",
 	[OP_CLONE_RANGE] = "clone_range",
 	[OP_DEDUPE_RANGE] = "dedupe_range",
+	[OP_COPY_RANGE] = "copy_range",
 	[OP_FSYNC] = "fsync",
 };
 
@@ -457,6 +460,13 @@ logdump(void)
 			if (overlap)
 				prt("\t******IIII");
 			break;
+		case OP_COPY_RANGE:
+			prt("COPY 0x%x thru 0x%x\t(0x%x bytes) to 0x%x",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1], lp->args[2]);
+			if (overlap)
+				prt("\t******IIII");
+			break;
 		case OP_FSYNC:
 			prt("FSYNC");
 			break;
@@ -1400,6 +1410,73 @@ do_dedupe_range(unsigned offset, unsigned length, unsigned dest)
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
@@ -1719,6 +1796,14 @@ test(void)
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
@@ -1764,6 +1849,7 @@ test(void)
 		break;
 	case OP_CLONE_RANGE:
 	case OP_DEDUPE_RANGE:
+	case OP_COPY_RANGE:
 		if (!remap_calls) {
 			log5(op, offset, size, offset2, FL_SKIPPED);
 			goto out;
@@ -1859,6 +1945,18 @@ test(void)
 
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
