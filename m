Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 01:38:06 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3J8c2fB023026
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 01:38:04 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3J8c0nB006255
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 17:38:00 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.193])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3J8bK1d011041
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 17:37:20 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l3J8bKn00848 for xfs@oss.sgi.com; Thu, 19 Apr 2007 17:37:20 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l3J8bJL27926 for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 17:37:19 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070419.173719.50002280 for <xfs@oss.sgi.com>
	; Thu, 19 Apr 2007 17:37:19 +0900
Message-Id: <200704190837.AA05238@TNESG9305.tnes.nec.co.jp>
Date: Thu, 19 Apr 2007 17:37:11 +0900
Subject: [PATCH] Fix "quota -n" command in xfs_quota.
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

"quota -n" command in xfs_quota don't work when specifying the project id.
This patch fixes it.

Example:
# ./xfs_quota -x -c 'quota -p -n 42' ~utako/mpnt
Disk quotas for Project logfiles (42)
Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted on
/dev/sda6                   52          0          0   00 [--------] /home/utako/mpnt


Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.20/quota/quota.orig	2007-04-18 10:36:38.000000000 +0900
+++ xfsprogs-2.8.20/quota/quota.c	2007-04-18 11:09:10.000000000 +0900
@@ -312,7 +312,7 @@ getprojectname(
 	static char	buffer[32];
 	fs_project_t	*p;
 
-	if ((p = getprprid(prid)))
+	if (!numeric && (p = getprprid(prid)))
 		return p->pr_name;
 	snprintf(buffer, sizeof(buffer), "#%u", (unsigned int)prid);
 	return &buffer[0];
