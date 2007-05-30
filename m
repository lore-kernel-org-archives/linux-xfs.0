Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 May 2007 22:24:32 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4U5OJWt003248
	for <xfs@oss.sgi.com>; Tue, 29 May 2007 22:24:22 -0700
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.161])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4U5OHVv016951
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 14:24:17 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l4U5OH304147 for xfs@oss.sgi.com; Wed, 30 May 2007 14:24:17 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l4U5OHg04216 for <xfs@oss.sgi.com>; Wed, 30 May 2007 14:24:17 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070530.142417.26603304 for <xfs@oss.sgi.com>
	; Wed, 30 May 2007 14:24:17 +0900
Message-Id: <200705300524.AA05467@TNESG9305.tnes.nec.co.jp>
From: Utako Kusaka <utako@tnes.nec.co.jp>
Date: Wed, 30 May 2007 14:24:17 +0900
Subject: [PATCH] Fix xfs_quota man page.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

This patch includes following fix in xfs_quota man page.
1. Add description of print command in USER COMMANDS.
2. Move description of path command to ADMINISTRATOR COMMANDS.
3. Fix errors in option of project command and the use of the xfs_quota project command. 
4. Remove 's' (abbreviation of seconds) which is not supported in timer command.
5. Precede `'' (quotation mark) with escape sequence (\&) in description of
   timer command. Because a part of it is not displayed in the output.

--
Utako Kusaka


Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
Signed-off-by: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>
---
 
--- xfsprogs-2.8.20/man/man8/xfs_quota.8.orig	2007-04-18 11:43:12.000000000 +0900
+++ xfsprogs-2.8.20/man/man8/xfs_quota.8	2007-05-25 16:09:35.000000000 +0900
@@ -119,11 +119,8 @@ Then after rectifying the quota situatio
 filesystem it belongs on.
 .SH USER COMMANDS
 .TP
-\f3path\f1 [ \f2N\f1 ]
-Lists all paths with devices/project identifiers or set the current
-path to the \f2N\f1th list entry (the current path is used by many
-of the commands described here, it identifies the filesystem toward
-which a command is directed).
+\f3print\f1
+Lists all paths with devices/project identifiers.
 The path list can come from several places \- the command line,
 the mount table, and the \f2/etc/projects\f1 file.
 .TP
@@ -227,6 +224,14 @@ filesystems available space; or simply t
 amount of space used, or number of inodes, within the tree).
 .SH ADMINISTRATOR COMMANDS
 .TP
+\f3path\f1 [ \f2N\f1 ]
+Lists all paths with devices/project identifiers or set the current
+path to the \f2N\f1th list entry (the current path is used by many
+of the commands described here, it identifies the filesystem toward
+which a command is directed).
+The path list can come from several places \- the command line,
+the mount table, and the \f2/etc/projects\f1 file.
+.TP
 \f3report\f1 [ \f2\-gpu\f1 ] [ \f2\-bir\f1 ] [ \f2\-ahnNt\f1 ]
 Report filesystem quota information.
 This reports all quota usage for a filesystem, for the specified
@@ -257,9 +262,9 @@ Allows the quota enforcement timeout (i.
 to pass before the soft limits are enforced as the hard limits) to
 be modified.
 The current timeout setting can be displayed using the \f3state\f1 command.
-The value argument is a number of seconds, but units of 'seconds',
-'minutes', 'hours', 'days', and 'weeks' are also understood
-(as are their abbreviations, 's', 'm', 'h', 'd', and 'w').
+The value argument is a number of seconds, but units of 'minutes', 'hours',
+\&'days', and 'weeks' are also understood
+(as are their abbreviations, 'm', 'h', 'd', and 'w').
 .TP
 \f3warn\f1 [ \f2\-gpu\f1 ] [ \f2\-bir\f1 ] value \-d|id|name
 Allows the quota warnings limit (i.e. the number of times a warning
@@ -310,7 +315,7 @@ an entire filesystem and report usage in
 This command can be used even when filesystem quota are not enabled,
 as it is a full-filesystem scan (it may also take a long time...).
 .TP
-\f3project\f1 [ \f2\-cds\f1 id|name ]
+\f3project\f1 [ \f2\-cCs\f1 id|name ]
 Without arguments, this command lists known project names and identifiers
 (based on entries in the
 .I /etc/projects
@@ -408,7 +413,7 @@ log file directories to only using 1 gig
 .nf
 .sp .8v
 .in +5
-# mount \-o prjquota /dev/xvm/var /var
+# mount \-o prjquota /dev/xvm/var /home
 # echo 42:/var/log >> /etc/projects
 # echo logfiles:42 >> /etc/projid
 # xfs_quota \-x \-c 'project \-s logfiles' /home
