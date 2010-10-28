Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9SLZqb8056498 for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 16:35:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8566C136E43F
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 14:52:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2Ip1jsA1csfEE8sa for
	<xfs@oss.sgi.com>; Thu, 28 Oct 2010 14:52:56 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PBa9m-0002aU-I3
	for xfs@oss.sgi.com; Thu, 28 Oct 2010 21:37:10 +0000
Date: Thu, 28 Oct 2010 17:37:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove experimental tag from the delaylog option
Message-ID: <20101028213710.GA9943@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

We promised to do this for 2.6.37, and the code looks stable enough to
keep that promise.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/Documentation/filesystems/xfs-delayed-logging-design.txt
===================================================================
--- xfs.orig/Documentation/filesystems/xfs-delayed-logging-design.txt	2010-10-28 23:28:51.978004035 +0200
+++ xfs/Documentation/filesystems/xfs-delayed-logging-design.txt	2010-10-28 23:28:53.457004943 +0200
@@ -794,17 +794,6 @@ designed.
 
 Roadmap:
 
-2.6.37 Remove experimental tag from mount option
-	=> should be roughly 6 months after initial merge
-	=> enough time to:
-		=> gain confidence and fix problems reported by early
-		   adopters (a.k.a. guinea pigs)
-		=> address worst performance regressions and undesired
-		   behaviours
-		=> start tuning/optimising code for parallelism
-		=> start tuning/optimising algorithms consuming
-		   excessive CPU time
-
 2.6.39 Switch default mount option to use delayed logging
 	=> should be roughly 12 months after initial merge
 	=> enough time to shake out remaining problems before next round of
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-10-28 23:29:45.733268178 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-10-28 23:29:56.915005996 +0200
@@ -353,9 +353,6 @@ xfs_parseargs(
 			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
 		} else if (!strcmp(this_char, MNTOPT_DELAYLOG)) {
 			mp->m_flags |= XFS_MOUNT_DELAYLOG;
-			cmn_err(CE_WARN,
-				"Enabling EXPERIMENTAL delayed logging feature "
-				"- use at your own risk.\n");
 		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
 			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
 		} else if (!strcmp(this_char, "ihashsize")) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
