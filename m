Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Nov 2006 17:31:22 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAT1VEaG023528
	for <xfs@oss.sgi.com>; Tue, 28 Nov 2006 17:31:15 -0800
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAT0S06X026813
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:28:01 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAT0Qiba015707
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:26:44 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kAT0Qi909738 for xfs@oss.sgi.com; Wed, 29 Nov 2006 09:26:44 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id kAT0Qhg19040 for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:26:44 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061129.093205.29602448 for <xfs@oss.sgi.com>
	; Wed, 29 Nov 2006 09:32:05 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id DE91CAE4B0
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:26:13 +0900 (JST)
Message-Id: <200611290026.AA04738@TNESG9305.tnes.nec.co.jp>
Date: Wed, 29 Nov 2006 09:26:38 +0900
Subject: [PATCH 1/2]segmentation fault in xfs_io mread/mwrite command
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I found the following issues in xfs_io.
 mread command:
  a) Causes a segmentation fault.
     Because "length"+1 bytes data is copied to buffer in read_mapping(),
     but buffer size is "length".
  b) Reads from wrong offset.
  c) The first byte of dump data is incorrect when length > page size.
 mwrite command:
  d) Data placement is incorrect when -r option is specified
     because of wrong for-loop counter.

This patch fixes them.

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.11-orgn/io/mmap.c	2006-06-26 14:01:15.000000000 +0900
+++ xfsprogs-2.8.11/io/mmap.c	2006-11-14 16:46:18.651458839 +0900
@@ -323,26 +323,6 @@ msync_f(
 	return 0;
 }
 
-static int
-read_mapping(
-	char		*dest,
-	off64_t		offset,
-	int		dump,
-	off64_t		dumpoffset,
-	size_t		dumplength)
-{
-	*dest = *(((char *)mapping->addr) + offset);
-
-	if (offset % pagesize == 0) {
-		if (dump == 2)
-			dumpoffset += mapping->offset;
-		if (dump)
-			dump_buffer(dumpoffset, dumplength);
-		return 1;
-	}
-	return 0;
-}
-
 static void
 mread_help(void)
 {
@@ -373,9 +353,9 @@ mread_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, tmp;
+	off64_t		offset, tmp, dumpoffset, printoffset;
 	ssize_t		length;
-	size_t		dumplen;
+	size_t		dumplen, cnt = 0;
 	char		*bp;
 	void		*start;
 	int		dump = 0, rflag = 0, c;
@@ -422,6 +402,11 @@ mread_f(
 	start = check_mapping_range(mapping, offset, length, 0);
 	if (!start)
 		return 0;
+	dumpoffset = offset - mapping->offset;
+	if (dump == 2)
+		printoffset = offset;
+	else
+		printoffset = dumpoffset;
 
 	if (alloc_buffer(pagesize, 0, 0) < 0)
 		return 0;
@@ -432,28 +417,35 @@ mread_f(
 		dumplen = pagesize;
 
 	if (rflag) {
-		for (tmp = length, c = 0; tmp > 0; tmp--, bp++, c = 1)
-			if (read_mapping(bp, tmp, c? dump:0, offset, dumplen)) {
+		for (tmp = length - 1, c = 0; tmp >= 0; tmp--, c = 1) {
+			*bp = *(((char *)mapping->addr) + dumpoffset + tmp);
+			cnt++;
+			if (c && cnt == dumplen) {
+				if (dump) {
+					dump_buffer(printoffset, dumplen);
+					printoffset += dumplen;
+				}
 				bp = (char *)buffer;
 				dumplen = pagesize;
+				cnt = 0;
+			} else {
+				bp++;
 			}
+		}
 	} else {
-		for (tmp = 0, c = 0; tmp < length; tmp++, bp++, c = 1)
-			if (read_mapping(bp, tmp, c? dump:0, offset, dumplen)) {
+		for (tmp = 0, c = 0; tmp < length; tmp++, c = 1) {
+			*bp = *(((char *)mapping->addr) + dumpoffset + tmp);
+			cnt++;
+			if (c && cnt == dumplen) {
+				if (dump)
+					dump_buffer(printoffset + tmp -
+						(dumplen - 1), dumplen);
 				bp = (char *)buffer;
 				dumplen = pagesize;
+				cnt = 0;
+			} else {
+				bp++;
 			}
-	}
-	/* dump the remaining (partial page) part of the read buffer */
-	if (dump) {
-		if (rflag)
-			dumplen = length % pagesize;
-		else
-			dumplen = tmp % pagesize;
-		if (dumplen) {
-			if (dump == 2)
-				tmp += mapping->offset;
-			dump_buffer(tmp, dumplen);
 		}
 	}
 	return 0;
@@ -571,7 +563,7 @@ mwrite_f(
 		return 0;
 
 	if (rflag) {
-		for (tmp = offset + length; tmp > offset; tmp--)
+		for (tmp = offset + length -1; tmp >= offset; tmp--)
 			((char *)mapping->addr)[tmp] = seed;
 	} else {
 		for (tmp = offset; tmp < offset + length; tmp++)
