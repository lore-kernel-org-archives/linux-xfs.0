Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Feb 2007 23:43:12 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1F7h5m7027218
	for <xfs@oss.sgi.com>; Wed, 14 Feb 2007 23:43:06 -0800
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1F7h0fl005149
	for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 16:43:03 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1F7dhlk027418
	for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 16:39:43 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l1F7dhO17226 for xfs@oss.sgi.com; Thu, 15 Feb 2007 16:39:43 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l1F7dhg16853 for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 16:39:43 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070215.163942.76502412 for <xfs@oss.sgi.com>
	; Thu, 15 Feb 2007 16:39:42 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 93F82AE4B0
	for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 16:39:38 +0900 (JST)
Received: from TNESG9305.tnes.nec.co.jp (TNESG9305.bsd.tnes.nec.co.jp [10.1.104.199])
	by rifu.bsd.tnes.nec.co.jp (8.12.11/3.7W/BSD-TNES-MX01) with SMTP id l1F7dg5l029192
	for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 16:39:42 +0900
Message-Id: <200702150739.AA04964@TNESG9305.tnes.nec.co.jp>
Date: Thu, 15 Feb 2007 16:39:52 +0900
Subject: [PATCH] fix the grace time in xfs_quota
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

When a quota limit is reached at a soft limit, xfs_quota(8) shows the 
incorrect grace time.
Because, the subtraction with '__uint32_t' and 'time_t' are done in 
time_to_string(), and the result does not become a negative value, but
a huge value. This patch fixes it.

Example:
xfs_quota> report
User quota on /home/utako/mpnt (/dev/sda6)
                               Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root          3145728       1000       2000     00 [--none--]
utako            1000       1000       2000     00 [00:00:4294967286]  <--

Group quota on /home/utako/mpnt (/dev/sda6)
                               Blocks
Group ID         Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root          3145728          0          0     00 [--------]
users            1000          0          0     00 [--------]


Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.18-orgn/quota/quota.h	2006-12-13 13:57:23.000000000 +0900
+++ xfsprogs-2.8.18/quota/quota.h	2007-02-15 11:51:20.000000000 +0900
@@ -49,7 +49,7 @@ enum {
  */
 extern char *type_to_string(uint __type);
 extern char *form_to_string(uint __form);
-extern char *time_to_string(__uint32_t __time, uint __flags);
+extern char *time_to_string(time_t __time, uint __flags);
 extern char *bbs_to_string(__uint64_t __v, char *__c, uint __size);
 extern char *num_to_string(__uint64_t __v, char *__c, uint __size);
 extern char *pct_to_string(__uint64_t __v, __uint64_t __t, char *__c, uint __s);


--- xfsprogs-2.8.18-orgn/quota/util.c	2006-12-13 13:57:23.000000000 +0900
+++ xfsprogs-2.8.18/quota/util.c	2007-02-15 11:51:51.000000000 +0900
@@ -29,7 +29,7 @@
 
 char *
 time_to_string(
-	__uint32_t	origin,
+	time_t		origin,
 	uint		flags)
 {
 	static char	timestamp[32];
