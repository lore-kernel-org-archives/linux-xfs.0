Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 19:48:05 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3R2m2fB024454
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 19:48:03 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3R2m1ic023792
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 11:48:01 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3R2f3XZ015422
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 11:41:03 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l3R2f2e09027 for xfs@oss.sgi.com; Fri, 27 Apr 2007 11:41:02 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l3R2f2L10152 for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 11:41:02 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070427.114102.87502660 for <xfs@oss.sgi.com>
	; Fri, 27 Apr 2007 11:41:03 +0900
Message-Id: <200704270240.AA05279@TNESG9305.tnes.nec.co.jp>
Date: Fri, 27 Apr 2007 11:40:51 +0900
Subject: [PATCH] Fix segmentation fault when using xfs_quota state command.
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

state command in xfs_quota causes segmentation fault when the path list is empty.
This patch fixes it.

Example:
# ./xfs_quota -x
xfs_quota_orig> path
xfs_quota_orig> state
Segmentation fault

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.20/quota/state.orig	2007-04-19 13:07:38.000000000 +0900
+++ xfsprogs-2.8.20/quota/state.c	2007-04-27 11:23:30.000000000 +0900
@@ -226,6 +226,9 @@ state_f(
 	if (argc != optind)
 		return command_usage(&state_cmd);
 
+	if (!fs_count)
+		return 0;
+
 	if ((fp = fopen_write_secure(fname)) == NULL)
 		return 0;

 
 
