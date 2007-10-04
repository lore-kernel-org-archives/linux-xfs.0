Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 00:02:33 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9472S0p030384
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 00:02:30 -0700
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l944h1m2010328
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 13:43:16 +0900 (JST)
Received: from mailgate4.nec.co.jp (mailgate53.nec.co.jp [10.7.69.184])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l944dvdE025122
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 13:39:57 +0900 (JST)
Received: (from root@localhost) by mailgate4.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l944duJ28955 for xfs@oss.sgi.com; Thu, 4 Oct 2007 13:39:56 +0900 (JST)
Received: from kaishu.jp.nec.com (kaishu.jp.nec.com [10.26.220.5]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l944duY15042 for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 13:39:56 +0900 (JST)
Message-Id: <200710040439.AA06067@TNESG9305.wm.jp.nec.com>
From: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Date: Thu, 04 Oct 2007 13:39:54 +0900
Subject: [PATCH] Fix errors in xfsprogs man page.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

This patch includes following fix in xfsprogs man page.
1. Fix 3 errors in mkfs.xfs.
2. Fix one error in xfs_freeze.
3. Fix one error in xfs_logprint.
4. Fix one error in xfs_repair.
5. Fix 3 errors in xfs_db. And add comma for readability.
6. Change description of obfuscation in xfs_metadump.
   Man page of xfs_metadump says about obfuscation of only directory  and
   extended attribute name. But xfs_metadump obfuscates regular file and
   symbolic link name too.

Utako

Signed-off-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>
---
diff -uprN xfsprogs-2.9.4.orig/man/man8/mkfs.xfs.8 xfsprogs-2.9.4/man/man8/mkfs.xfs.8
--- xfsprogs-2.9.4.orig/man/man8/mkfs.xfs.8	2007-09-11 11:01:19.000000000 +0900
+++ xfsprogs-2.9.4/man/man8/mkfs.xfs.8	2007-10-03 10:00:53.000000000 +0900
@@ -567,7 +567,7 @@ syntax on line 7. This syntax directs th
 command to terminate the branch of the filesystem it
 is currently on and then continue
 from the directory specified by
-the next line,in this case line 8
+the next line, in this case line 8.
 It must be the last character
 on a line.
 The colon
@@ -610,13 +610,13 @@ The third character of the mode string i
 used to specify the setgroupID mode, in which
 case it is
 .BR g .
-If setgroupID mode is not specified, the second character is
+If setgroupID mode is not specified, the third character is
 .BR \- .
 The remaining characters of the mode string are
 a three digit octal number. This octal number
 defines the owner, group, and other read, write,
 and execute permissions for the file, respectively.
-Form more information on file permissions, see the
+For more information on file permissions, see the
 .BR chmod (1)
 command.
 .IP
diff -uprN xfsprogs-2.9.4.orig/man/man8/xfs_db.8 xfsprogs-2.9.4/man/man8/xfs_db.8
--- xfsprogs-2.9.4.orig/man/man8/xfs_db.8	2007-09-11 11:01:19.000000000 +0900
+++ xfsprogs-2.9.4/man/man8/xfs_db.8	2007-10-03 10:53:56.000000000 +0900
@@ -153,30 +153,30 @@ See the
 command.
 .TP
 .BI ablock " filoff"
-Set current address to the offset .
-I filoff
+Set current address to the offset
+.I filoff
 (a filesystem block number) in the attribute area of the current inode.
 .TP
 .BI "addr [" field-expression ]
 Set current address to the value of the
 .IR field-expression .
 This is used to "follow" a reference in one structure to the object
-being referred to. If no argument is given the current address is printed.
+being referred to. If no argument is given, the current address is printed.
 .TP
 .BI "agf [" agno ]
 Set current address to the AGF block for allocation group
 .IR agno .
-If no argument is given use the current allocation group.
+If no argument is given, use the current allocation group.
 .TP
 .BI "agfl [" agno ]
 Set current address to the AGFL block for allocation group
 .IR agno .
-If no argument is given use the current allocation group.
+If no argument is given, use the current allocation group.
 .TP
 .BI "agi [" agno ]
 Set current address to the AGI block for allocation group
 .IR agno .
-If no argument is given use the current allocation group.
+If no argument is given, use the current allocation group.
 .TP
 .B b
 See the
@@ -413,8 +413,8 @@ Set current address to the daddr (512 by
 .IR d .
 If no value for
 .I d
-is given the current address is printed, expressed as a daddr.
-The type is set to .
+is given, the current address is printed, expressed as a daddr.
+The type is set to
 .B data
 (uninterpreted).
 .TP
@@ -641,7 +641,7 @@ Set current address to SB header in allo
 .IR agno .
 If no
 .I agno
-is given use the current allocation group number.
+is given, use the current allocation group number.
 .TP
 .BI "source " source-file
 Process commands from
@@ -789,7 +789,7 @@ number of blocks held in the AGF Btrees.
 .PD
 .RE
 .TP
-.B agf
+.B agfl
 The AGFL block contains block numbers for use of the block allocator;
 it is in the fourth 512-byte block of each allocation group.
 Each entry in the active list is a block number within the allocation group
diff -uprN xfsprogs-2.9.4.orig/man/man8/xfs_freeze.8 xfsprogs-2.9.4/man/man8/xfs_freeze.8
--- xfsprogs-2.9.4.orig/man/man8/xfs_freeze.8	2007-09-11 11:01:19.000000000 +0900
+++ xfsprogs-2.9.4/man/man8/xfs_freeze.8	2007-10-02 17:15:42.000000000 +0900
@@ -43,7 +43,7 @@ or a clean mount of the snapshot is comp
 .PP
 The
 .B \-u
-flagq is used to un-freeze the filesystem and allow
+flag is used to un-freeze the filesystem and allow
 operations to continue.
 Any filesystem modifications that were blocked by the freeze are
 unblocked and allowed to complete.
diff -uprN xfsprogs-2.9.4.orig/man/man8/xfs_logprint.8 xfsprogs-2.9.4/man/man8/xfs_logprint.8
--- xfsprogs-2.9.4.orig/man/man8/xfs_logprint.8	2007-09-11 11:01:19.000000000 +0900
+++ xfsprogs-2.9.4/man/man8/xfs_logprint.8	2007-10-02 16:36:45.000000000 +0900
@@ -76,7 +76,7 @@ This might happen if an image copy of a 
 an ordinary file with
 .BR xfs_copy (8).
 .TP
-.B \-l
+.BI \-l " logdev"
 External log device. Only for those filesystems which use an external log.
 .TP
 .B \-i
diff -uprN xfsprogs-2.9.4.orig/man/man8/xfs_metadump.8 xfsprogs-2.9.4/man/man8/xfs_metadump.8
--- xfsprogs-2.9.4.orig/man/man8/xfs_metadump.8	2007-09-11 11:01:19.000000000 +0900
+++ xfsprogs-2.9.4/man/man8/xfs_metadump.8	2007-10-04 11:16:44.000000000 +0900
@@ -39,11 +39,12 @@ filesystem's metadata and indexes to whe
 .PP
 By default,
 .B xfs_metadump
-obfuscates most directory names and extended attribute names to allow the dumps
-to be sent without revealing confidential information. Extended attribute
-values are zeroed and no data is copied. The only exceptions are directory
-or attribute names that are 4 or less characters in length. Also directory
-names that span extents (this can only occur with the
+obfuscates most file (regular file, directory and symbolic link) names
+and extended attribute names to allow the dumps to be sent without
+revealing confidential information. Extended attribute values are zeroed
+and no data is copied. The only exceptions are file or attribute names
+that are 4 or less characters in length. Also file names that span extents
+(this can only occur with the
 .BR mkfs.xfs (8)
 options where
 .B \-n
@@ -128,4 +129,4 @@ command.
 .BR xfs (5)
 .SH BUGS
 Email bug reports to
-.BR xfs@oss.sgi.com .
\ No newline at end of file
+.BR xfs@oss.sgi.com .
diff -uprN xfsprogs-2.9.4.orig/man/man8/xfs_repair.8 xfsprogs-2.9.4/man/man8/xfs_repair.8
--- xfsprogs-2.9.4.orig/man/man8/xfs_repair.8	2007-09-11 11:01:19.000000000 +0900
+++ xfsprogs-2.9.4/man/man8/xfs_repair.8	2007-10-02 17:24:56.000000000 +0900
@@ -110,8 +110,7 @@ is 1024 (for a total of 8192 entries).
 overrides the default buffer cache hash size. The total number of
 buffer cache entries are limited to 8 times this amount. The default
 size is set to use up the remainder of 75% of the system's physical
-RAM.
-size
+RAM size.
 .TP
 .BI ag_stride= ags_per_concat_unit
 This creates additional processing threads to parallel process
