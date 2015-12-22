Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBE337F5A
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 07:51:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C40B78F8037
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PSbaPSTV53TsX2Bw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:29 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 8258296F9
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 13:51:28 +0000 (UTC)
Received: from schleppi.home.com (vpn1-6-147.ams2.redhat.com [10.36.6.147])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tBMDpH2M030386
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 08:51:27 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5/6] fsx: Improve operation logging
Date: Tue, 22 Dec 2015 14:51:11 +0100
Message-Id: <1450792272-7402-6-git-send-email-agruenba@redhat.com>
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

Add FL_SKIPPED, FL_CLOSE_OPEN, and FL_KEEP_SIZE flags to the log
entries.  Use FL_SKIPPED to indicate that an operation was skipped.  Use
FL_CLOSE_OPEN to encode when an operation is followed by a close/open
cycle.  Use FL_KEEP_SIZE to indicate when the OP_ZERO_RANGE and
OP_FALLOCATE operations should keep the file size unchanged and put the
current file size into args[2] so that we can tell which operation was
actually called from the log.

After that, arg2 of log4 is always either unused or the current file size, so
remove it and unconditionally remember the current file size.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 ltp/fsx.c | 122 +++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 66 insertions(+), 56 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 5385ed3..50ca885 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -40,6 +40,10 @@
 
 #define NUMPRINTCOLUMNS 32	/* # columns of data to print on each line */
 
+/* Operation flags */
+
+enum opflags { FL_NONE = 0, FL_SKIPPED = 1, FL_CLOSE_OPEN = 2, FL_KEEP_SIZE = 4 };
+
 /*
  *	A log entry is an operation and a bunch of arguments.
  */
@@ -47,6 +51,7 @@
 struct log_entry {
 	int	operation;
 	int	args[3];
+	enum opflags flags;
 };
 
 #define	LOGSIZE	10000
@@ -73,9 +78,7 @@ int			logcount = 0;	/* total ops */
  *
  * When mapped read/writes are disabled, they are simply converted to normal
  * reads and writes. When fallocate/fpunch calls are disabled, they are
- * converted to OP_SKIPPED. Hence OP_SKIPPED needs to have a number higher than
- * the operation selction matrix, as does the OP_CLOSEOPEN which is an
- * operation modifier rather than an operation in itself.
+ * skipped.
  *
  * Because of the "lite" version, we also need to have different "maximum
  * operation" defines to allow the ops to be selected correctly based on the
@@ -98,10 +101,6 @@ int			logcount = 0;	/* total ops */
 #define OP_INSERT_RANGE	9
 #define OP_MAX_FULL		10
 
-/* operation modifiers */
-#define OP_CLOSEOPEN	100
-#define OP_SKIPPED	101
-
 #undef PAGE_SIZE
 #define PAGE_SIZE       getpagesize()
 #undef PAGE_MASK
@@ -222,17 +221,18 @@ prterr(char *prefix)
 
 
 void
-log4(int operation, int arg0, int arg1, int arg2)
+log4(int operation, int arg0, int arg1, enum opflags flags)
 {
 	struct log_entry *le;
 
 	le = &oplog[logptr];
 	le->operation = operation;
 	if (closeopen)
-		le->operation = ~ le->operation;
+		flags |= FL_CLOSE_OPEN;
 	le->args[0] = arg0;
 	le->args[1] = arg1;
-	le->args[2] = arg2;
+	le->args[2] = file_size;
+	le->flags = flags;
 	logptr++;
 	logcount++;
 	if (logptr >= LOGSIZE)
@@ -245,7 +245,6 @@ logdump(void)
 {
 	int	i, count, down;
 	struct log_entry	*lp;
-	char *falloc_type[3] = {"PAST_EOF", "EXTENDING", "INTERIOR"};
 
 	prt("LOG DUMP (%d total operations):\n", logcount);
 	if (logcount < LOGSIZE) {
@@ -261,9 +260,12 @@ logdump(void)
 		opnum = i+1 + (logcount/LOGSIZE)*LOGSIZE;
 		prt("%d(%3d mod 256): ", opnum, opnum%256);
 		lp = &oplog[i];
-		if ((closeopen = lp->operation < 0))
-			lp->operation = ~ lp->operation;
-			
+
+		if (lp->flags & FL_SKIPPED) {
+			prt("SKIPPED (no operation)");
+			goto skipped;
+		}
+
 		switch (lp->operation) {
 		case OP_MAPREAD:
 			prt("MAPREAD  0x%x thru 0x%x\t(0x%x bytes)",
@@ -302,18 +304,24 @@ logdump(void)
 				prt("\t***WWWW");
 			break;
 		case OP_TRUNCATE:
-			down = lp->args[0] < lp->args[1];
+			down = lp->args[1] < lp->args[2];
 			prt("TRUNCATE %s\tfrom 0x%x to 0x%x",
-			    down ? "DOWN" : "UP", lp->args[1], lp->args[0]);
-			if (badoff >= lp->args[!down] &&
-			    badoff < lp->args[!!down])
+			    down ? "DOWN" : "UP", lp->args[2], lp->args[1]);
+			if (badoff >= lp->args[1 + !down] &&
+			    badoff < lp->args[1 + !!down])
 				prt("\t******WWWW");
 			break;
 		case OP_FALLOCATE:
 			/* 0: offset 1: length 2: where alloced */
-			prt("FALLOC   0x%x thru 0x%x\t(0x%x bytes) %s",
+			prt("FALLOC   0x%x thru 0x%x\t(0x%x bytes) ",
 				lp->args[0], lp->args[0] + lp->args[1],
-				lp->args[1], falloc_type[lp->args[2]]);
+				lp->args[1]);
+			if (lp->args[0] + lp->args[1] <= lp->args[2])
+				prt("INTERIOR");
+			else if (lp->flags & FL_KEEP_SIZE)
+				prt("PAST_EOF");
+			else
+				prt("EXTENDING");
 			if (badoff >= lp->args[0] &&
 			    badoff < lp->args[0] + lp->args[1])
 				prt("\t******FFFF");
@@ -350,14 +358,12 @@ logdump(void)
 						     lp->args[0] + lp->args[1])
 				prt("\t******IIII");
 			break;
-		case OP_SKIPPED:
-			prt("SKIPPED (no operation)");
-			break;
 		default:
 			prt("BOGUS LOG ENTRY (operation code = %d)!",
 			    lp->operation);
 		}
-		if (closeopen)
+	    skipped:
+		if (lp->flags & FL_CLOSE_OPEN)
 			prt("\n\t\tCLOSE/OPEN");
 		prt("\n");
 		i++;
@@ -549,17 +555,17 @@ doread(unsigned offset, unsigned size)
 	if (size == 0) {
 		if (!quiet && testcalls > simulatedopcount && !o_direct)
 			prt("skipping zero size read\n");
-		log4(OP_SKIPPED, OP_READ, offset, size);
+		log4(OP_READ, offset, size, FL_SKIPPED);
 		return;
 	}
 	if (size + offset > file_size) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping seek/read past end of file\n");
-		log4(OP_SKIPPED, OP_READ, offset, size);
+		log4(OP_READ, offset, size, FL_SKIPPED);
 		return;
 	}
 
-	log4(OP_READ, offset, size, 0);
+	log4(OP_READ, offset, size, FL_NONE);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -628,17 +634,17 @@ domapread(unsigned offset, unsigned size)
 	if (size == 0) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping zero size read\n");
-		log4(OP_SKIPPED, OP_MAPREAD, offset, size);
+		log4(OP_MAPREAD, offset, size, FL_SKIPPED);
 		return;
 	}
 	if (size + offset > file_size) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping seek/read past end of file\n");
-		log4(OP_SKIPPED, OP_MAPREAD, offset, size);
+		log4(OP_MAPREAD, offset, size, FL_SKIPPED);
 		return;
 	}
 
-	log4(OP_MAPREAD, offset, size, 0);
+	log4(OP_MAPREAD, offset, size, FL_NONE);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -697,11 +703,11 @@ dowrite(unsigned offset, unsigned size)
 	if (size == 0) {
 		if (!quiet && testcalls > simulatedopcount && !o_direct)
 			prt("skipping zero size write\n");
-		log4(OP_SKIPPED, OP_WRITE, offset, size);
+		log4(OP_WRITE, offset, size, FL_SKIPPED);
 		return;
 	}
 
-	log4(OP_WRITE, offset, size, file_size);
+	log4(OP_WRITE, offset, size, FL_NONE);
 
 	gendata(original_buf, good_buf, offset, size);
 	if (file_size < offset + size) {
@@ -763,12 +769,12 @@ domapwrite(unsigned offset, unsigned size)
 	if (size == 0) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping zero size write\n");
-		log4(OP_SKIPPED, OP_MAPWRITE, offset, size);
+		log4(OP_MAPWRITE, offset, size, FL_SKIPPED);
 		return;
 	}
 	cur_filesize = file_size;
 
-	log4(OP_MAPWRITE, offset, size, 0);
+	log4(OP_MAPWRITE, offset, size, FL_NONE);
 
 	gendata(original_buf, good_buf, offset, size);
 	if (file_size < offset + size) {
@@ -835,7 +841,7 @@ dotruncate(unsigned size)
 			prt("truncating to largest ever: 0x%x\n", size);
 	}
 
-	log4(OP_TRUNCATE, size, (unsigned)file_size, 0);
+	log4(OP_TRUNCATE, 0, size, FL_NONE);
 
 	if (size > file_size)
 		memset(good_buf + file_size, '\0', size - file_size);
@@ -867,20 +873,20 @@ do_punch_hole(unsigned offset, unsigned length)
 	if (length == 0) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping zero length punch hole\n");
-			log4(OP_SKIPPED, OP_PUNCH_HOLE, offset, length);
+			log4(OP_PUNCH_HOLE, offset, length, FL_SKIPPED);
 		return;
 	}
 
 	if (file_size <= (loff_t)offset) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping hole punch off the end of the file\n");
-			log4(OP_SKIPPED, OP_PUNCH_HOLE, offset, length);
+			log4(OP_PUNCH_HOLE, offset, length, FL_SKIPPED);
 		return;
 	}
 
 	end_offset = offset + length;
 
-	log4(OP_PUNCH_HOLE, offset, length, 0);
+	log4(OP_PUNCH_HOLE, offset, length, FL_NONE);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -922,7 +928,8 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
 	if (length == 0) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping zero length zero range\n");
-			log4(OP_SKIPPED, OP_ZERO_RANGE, offset, length);
+			log4(OP_ZERO_RANGE, offset, length, FL_SKIPPED |
+			     (keep_size ? FL_KEEP_SIZE : FL_NONE));
 		return;
 	}
 
@@ -940,7 +947,8 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
 	 * 	1: extending prealloc
 	 * 	2: interior prealloc
 	 */
-	log4(OP_ZERO_RANGE, offset, length, (end_offset > file_size) ? (keep_size ? 0 : 1) : 2);
+	log4(OP_ZERO_RANGE, offset, length,
+	     keep_size ? FL_KEEP_SIZE : FL_NONE);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -978,7 +986,7 @@ do_collapse_range(unsigned offset, unsigned length)
 	if (length == 0) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping zero length collapse range\n");
-		log4(OP_SKIPPED, OP_COLLAPSE_RANGE, offset, length);
+		log4(OP_COLLAPSE_RANGE, offset, length, FL_SKIPPED);
 		return;
 	}
 
@@ -986,11 +994,11 @@ do_collapse_range(unsigned offset, unsigned length)
 	if ((loff_t)end_offset >= file_size) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping collapse range behind EOF\n");
-		log4(OP_SKIPPED, OP_COLLAPSE_RANGE, offset, length);
+		log4(OP_COLLAPSE_RANGE, offset, length, FL_SKIPPED);
 		return;
 	}
 
-	log4(OP_COLLAPSE_RANGE, offset, length, 0);
+	log4(OP_COLLAPSE_RANGE, offset, length, FL_NONE);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -1030,18 +1038,18 @@ do_insert_range(unsigned offset, unsigned length)
 	if (length == 0) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping zero length insert range\n");
-		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
+		log4(OP_INSERT_RANGE, offset, length, FL_SKIPPED);
 		return;
 	}
 
 	if ((loff_t)offset >= file_size) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping insert range behind EOF\n");
-		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
+		log4(OP_INSERT_RANGE, offset, length, FL_SKIPPED);
 		return;
 	}
 
-	log4(OP_INSERT_RANGE, offset, length, 0);
+	log4(OP_INSERT_RANGE, offset, length, FL_NONE);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -1083,7 +1091,8 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
         if (length == 0) {
                 if (!quiet && testcalls > simulatedopcount)
                         prt("skipping zero length fallocate\n");
-                log4(OP_SKIPPED, OP_FALLOCATE, offset, length);
+                log4(OP_FALLOCATE, offset, length, FL_SKIPPED |
+		     (keep_size ? FL_KEEP_SIZE : FL_NONE));
                 return;
         }
 
@@ -1101,7 +1110,8 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
 	 * 	1: extending prealloc
 	 * 	2: interior prealloc
 	 */
-	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? (keep_size ? 0 : 1) : 2);
+	log4(OP_FALLOCATE, offset, length,
+	     keep_size ? FL_KEEP_SIZE : FL_NONE);
 
 	if (end_offset > file_size) {
 		memset(good_buf + file_size, '\0', end_offset - file_size);
@@ -1251,31 +1261,31 @@ test(void)
 		break;
 	case OP_FALLOCATE:
 		if (!fallocate_calls) {
-			log4(OP_SKIPPED, OP_FALLOCATE, offset, size);
+			log4(OP_FALLOCATE, offset, size, FL_SKIPPED);
 			goto out;
 		}
 		break;
 	case OP_PUNCH_HOLE:
 		if (!punch_hole_calls) {
-			log4(OP_SKIPPED, OP_PUNCH_HOLE, offset, size);
+			log4(OP_PUNCH_HOLE, offset, size, FL_SKIPPED);
 			goto out;
 		}
 		break;
 	case OP_ZERO_RANGE:
 		if (!zero_range_calls) {
-			log4(OP_SKIPPED, OP_ZERO_RANGE, offset, size);
+			log4(OP_ZERO_RANGE, offset, size, FL_SKIPPED);
 			goto out;
 		}
 		break;
 	case OP_COLLAPSE_RANGE:
 		if (!collapse_range_calls) {
-			log4(OP_SKIPPED, OP_COLLAPSE_RANGE, offset, size);
+			log4(OP_COLLAPSE_RANGE, offset, size, FL_SKIPPED);
 			goto out;
 		}
 		break;
 	case OP_INSERT_RANGE:
 		if (!insert_range_calls) {
-			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			log4(OP_INSERT_RANGE, offset, size, FL_SKIPPED);
 			goto out;
 		}
 		break;
@@ -1326,7 +1336,7 @@ test(void)
 		offset = offset & ~(block_size - 1);
 		size = size & ~(block_size - 1);
 		if (size == 0) {
-			log4(OP_SKIPPED, OP_COLLAPSE_RANGE, offset, size);
+			log4(OP_COLLAPSE_RANGE, offset, size, FL_SKIPPED);
 			goto out;
 		}
 		do_collapse_range(offset, size);
@@ -1337,11 +1347,11 @@ test(void)
 		offset = offset & ~(block_size - 1);
 		size = size & ~(block_size - 1);
 		if (size == 0) {
-			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			log4(OP_INSERT_RANGE, offset, size, FL_SKIPPED);
 			goto out;
 		}
 		if (file_size + size > maxfilelen) {
-			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			log4(OP_INSERT_RANGE, offset, size, FL_SKIPPED);
 			goto out;
 		}
 
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
