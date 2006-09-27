Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Sep 2006 22:51:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8R5pDaG031105
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 22:51:14 -0700
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9C5245F711
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 21:45:41 -0700 (PDT)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.160] (may be forged))
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id k8R4j4L8011718
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 13:45:04 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id k8R4j4B20423 for xfs@oss.sgi.com; Wed, 27 Sep 2006 13:45:04 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id k8R4j3Q18713 for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 13:45:03 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20060927.134856.01502552 for <xfs@oss.sgi.com>
	; Wed, 27 Sep 2006 13:48:56 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 4A96AAE4B3
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 13:45:03 +0900 (JST)
Received: from TNESG9305.tnes.nec.co.jp (TNESG9305.bsd.tnes.nec.co.jp [10.1.104.199])
	by rifu.bsd.tnes.nec.co.jp (8.12.11/3.7W/BSD-TNES-MX01) with SMTP id k8R4j3MQ001527
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 13:45:03 +0900
Message-Id: <200609270444.AA04551@TNESG9305.tnes.nec.co.jp>
Date: Wed, 27 Sep 2006 13:44:58 +0900
Subject: [PATCH] xfs_db ring command
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This patch fixes the issue that
xfs_db ring [index] command don't move to specified index.

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.11-orgn/db/io.c	2006-06-26 14:01:14.000000000 +0900
+++ xfsprogs-2.8.11/db/io.c	2006-09-26 16:59:40.000000000 +0900
@@ -352,7 +352,7 @@ ring_f(
 		return 0;
 	}
 
-	index = (int)strtoul(argv[0], NULL, 0);
+	index = (int)strtoul(argv[1], NULL, 0);
 	if (index < 0 || index >= RING_ENTRIES)
 		dbprintf("invalid entry: %d\n", index); 
