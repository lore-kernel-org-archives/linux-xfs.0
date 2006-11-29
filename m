Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Nov 2006 17:26:20 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAT1QBaG021590
	for <xfs@oss.sgi.com>; Tue, 28 Nov 2006 17:26:13 -0800
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAT0S06T026813
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:28:00 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.197])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAT0RmEt016920
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:27:48 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kAT0RmN12385 for xfs@oss.sgi.com; Wed, 29 Nov 2006 09:27:48 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kAT0Rla24782 for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:27:47 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061129.093309.14002448 for <xfs@oss.sgi.com>
	; Wed, 29 Nov 2006 09:33:09 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 44A8EAE4B0
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 09:27:17 +0900 (JST)
Message-Id: <200611290027.AA04740@TNESG9305.tnes.nec.co.jp>
Date: Wed, 29 Nov 2006 09:27:42 +0900
Subject: [PATCH 2/2]xfs_io man page
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

This patch adds offset and length parameter to the man page for 
pread, pwrite, mread and mwrite command in xfs_io(8).
I guess this is useful for testers.
What do you think of it?

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.15-orgn/man/man8/xfs_io.8	2006-07-04 20:57:05.000000000 +0900
+++ xfsprogs-2.8.15/man/man8/xfs_io.8	2006-11-16 15:55:34.566928372 +0900
@@ -99,7 +99,7 @@ Closes the current open file, marking th
 \f3c\f1
 See the \f3close\f1 command.
 .TP
-\f3pread\f1 [ \f2\-b bsize\f1 ] [ \f2\-v\f1 ]
+\f3pread\f1 [ \f2\-b bsize\f1 ] [ \f2\-v\f1 ] \f2offset\f1 \f2length\f1
 Reads a range of bytes in a specified blocksize from the given offset.
 .br
 The \f3\-b\f1 option can be used to set the blocksize into which the
@@ -112,7 +112,7 @@ by default only the count of bytes actua
 \f3r\f1
 See the \f3pread\f1 command.
 .TP
-\f3pwrite\f1 [ \f2\-i file\f1 ] [ \f2\-d\f1 ] [ \f2\-s skip\f1 ] [ \f2\-b size\f1 ] [ \f2\-S seed\f1 ]
+\f3pwrite\f1 [ \f2\-i file\f1 ] [ \f2\-d\f1 ] [ \f2\-s skip\f1 ] [ \f2\-b size\f1 ] [ \f2\-S seed\f1 ] \f2offset
\f1 \f2length\f1
 Writes a range of bytes in a specified blocksize from the given offset.
 The bytes written can be either a set pattern or read in from another
 file before writing.
@@ -211,7 +211,7 @@ Unmaps the current memory mapping.
 \f3mu\f1
 See the \f3munmap\f1 command.
 .TP
-\f3mread\f1 [ \-\f2frv\f1 ]
+\f3mread\f1 [ \-\f2frv\f1 ] [ \f2offset\f1 \f2length\f1 ]
 Accesses a segment of the current memory mapping, optionally dumping it to
 the standard output stream (with \f2-v\f1 or \f2-f\f1 option) for inspection.
 The accesses are performed sequentially from the start offset by default,
@@ -224,7 +224,7 @@ offsets relative to the start of the map
 \f3mr\f1
 See the \f3mread\f1 command.
 .TP
-\f3mwrite\f1 [ \f2-r\f1 ] [ \f2-S seed\f1 ]
+\f3mwrite\f1 [ \f2-r\f1 ] [ \f2-S seed\f1 ] [ \f2offset\f1 \f2length\f1 ]
 Stores a byte into memory for a range within a mapping.
 The default stored value is 'X', repeated to fill the range specified,
 but this can be changed using the \f2-S\f1 option.
