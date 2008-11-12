Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 03:48:16 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACBm9o9007649
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:48:09 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 955E0154B45F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:48:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id vFjgMfXGH4CsP6oG for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:48:09 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1L0ECA-00057V-Rq
	for xfs@oss.sgi.com; Wed, 12 Nov 2008 11:47:38 +0000
Date: Wed, 12 Nov 2008 06:47:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] fix spurious gcc warnings
Message-ID: <20081112114738.GC15216@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Some recent gcc warnings don't like passing string variables to
printf-like functions without using at least a "%s" format string.
Chaneg the two occurances of that in xfs to please gcc.


Signed-off-by: Christoph Hellwig <hch@lst.de>

fs/xfs/linux-2.6/xfs_stats.c: In function "xfs_read_xfssta":
fs/xfs/linux-2.6/xfs_stats.c:64: warning: format not a string literal and no format arguments
fs/xfs/linux-2.6/xfs_super.c: In function "init_xfs_fs":
fs/xfs/linux-2.6/xfs_super.c:1833: warning: format not a string literal and no format arguments

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.c	2008-11-12 11:12:49.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.c	2008-11-12 11:13:05.000000000 +0100
@@ -61,7 +61,7 @@ xfs_read_xfsstats(
 
 	/* Loop over all stats groups */
 	for (i=j=len = 0; i < ARRAY_SIZE(xstats); i++) {
-		len += sprintf(buffer + len, xstats[i].desc);
+		len += sprintf(buffer + len, "%s", xstats[i].desc);
 		/* inner loop does each group */
 		while (j < xstats[i].endpoint) {
 			val = 0;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-11-12 11:13:11.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-11-12 11:13:43.000000000 +0100
@@ -1827,10 +1827,9 @@ STATIC int __init
 init_xfs_fs(void)
 {
 	int			error;
-	static char		message[] __initdata = KERN_INFO \
-		XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled\n";
 
-	printk(message);
+	printk(KERN_INFO XFS_VERSION_STRING " with "
+			 XFS_BUILD_OPTIONS " enabled\n");
 
 	ktrace_init(64);
 	vn_init();
