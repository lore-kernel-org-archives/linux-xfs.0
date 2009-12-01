Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1JYBu0161366 for <xfs@oss.sgi.com>; Tue, 1 Dec 2009 13:34:12 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB7A614EDE1E
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 11:34:41 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id CBnIkzxn8eY7G4hN for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2009 11:34:41 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id E5607A4E360
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 13:34:40 -0600 (CST)
Message-ID: <4B156FC3.8010402@sandeen.net>
Date: Tue, 01 Dec 2009 13:34:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] (resend) xfsprogs: make lazy-count=1 the default.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

With the xfstests fixed up, we should be able to do this now.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfsprogs-2.10.2/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-2.10.2.orig/mkfs/xfs_mkfs.c
+++ xfsprogs-2.10.2/mkfs/xfs_mkfs.c
@@ -733,7 +733,7 @@ main(
 	nodsflag = norsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
-	lazy_sb_counters = 0;
+	lazy_sb_counters = 1;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
Index: xfsprogs-2.10.2/man/man8/mkfs.xfs.8
===================================================================
--- xfsprogs-2.10.2.orig/man/man8/mkfs.xfs.8
+++ xfsprogs-2.10.2/man/man8/mkfs.xfs.8
@@ -455,9 +455,10 @@ counter values without needed to keep th
 This gives significant improvements in performance on some configurations.
 The default
 .I value
-is 0 (off) so you must specify
-.B lazy-count=1
-if you want to make use of this feature.
+is 1 (on) so you must specify
+.B lazy-count=0
+if you want to disable this feature for older kernels which don't support
+it.
 .RE
 .TP
 .BI \-n " naming_options"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
