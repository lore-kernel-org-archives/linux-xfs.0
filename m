Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LLlJbq154673 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:47:19 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1188E143B008
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 14:49:56 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id H86G4FFrIPr3Hsgw for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2009 14:49:56 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3LLlBUK004392
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 17:47:11 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3LLlAnG006331
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 17:47:10 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3LLl9CI007362
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 17:47:10 -0400
Message-ID: <49EE3EDD.1090305@sandeen.net>
Date: Tue, 21 Apr 2009 16:47:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] make lazy-count=1 the default
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
To: xfs mailing list <xfs@oss.sgi.com>

If folks think it's been out there long enough, let's make
lazy-count=1 the mkfs default going forward?

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
