Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 May 2007 22:59:29 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l495xOfB008438
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 22:59:26 -0700
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l495xLcV009966
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 14:59:21 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l495xL321403 for xfs@oss.sgi.com; Wed, 9 May 2007 14:59:21 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l495xLO26246 for <xfs@oss.sgi.com>; Wed, 9 May 2007 14:59:21 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070509.145924.21802300 for <xfs@oss.sgi.com>
	; Wed, 9 May 2007 14:59:24 +0900
Message-Id: <200705090559.AA05331@TNESG9305.tnes.nec.co.jp>
Date: Wed, 09 May 2007 14:59:11 +0900
Subject: [PATCH] Fix xfs_quota path command.
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

In path command in xfs_quota, the range value in the message becomes
from 0 to -1 incorrectly when the list number is specified though the path list
is empty. I think that the message is unnecessary the same as not specifying
the list number in this case.

Example:
# ./xfs_quota -x
xfs_quota> path
xfs_quota> path 0
value 0 is out of range (0--1)

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---
 
--- xfsprogs-2.8.20/quota/path.orig	2007-04-26 14:14:00.000000000 +0900
+++ xfsprogs-2.8.20/quota/path.c	2007-04-27 11:27:56.000000000 +0900
@@ -102,6 +102,9 @@ path_f(
 	if (argc <= 1)
 		return pathlist_f();
 
+	if (!fs_count)
+		return 0;
+
 	i = atoi(argv[1]);
 	if (i < 0 || i >= fs_count) {
 		printf(_("value %d is out of range (0-%d)\n"),
