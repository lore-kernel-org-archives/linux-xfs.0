Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TAQ0W2062869 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 05:26:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA6EF8ECC47
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:28:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 35AU9a7TecV3VeEl for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:28:05 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O7QyT-0001Iy-8l
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:28:05 +0000
Date: Thu, 29 Apr 2010 06:28:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: bump version and update changelog
Message-ID: <20100429102805.GA4895@infradead.org>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/VERSION
===================================================================
--- xfsprogs-dev.orig/VERSION	2010-04-29 12:21:54.074004868 +0200
+++ xfsprogs-dev/VERSION	2010-04-29 12:21:59.188004170 +0200
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=1
+PKG_REVISION=2
 PKG_BUILD=1
Index: xfsprogs-dev/doc/CHANGES
===================================================================
--- xfsprogs-dev.orig/doc/CHANGES	2010-04-29 12:21:54.084013459 +0200
+++ xfsprogs-dev/doc/CHANGES	2010-04-29 12:22:37.625255672 +0200
@@ -1,3 +1,15 @@
+xfsprogs-3.1.2
+	- Fix missing thread synchronization in xfs_repair duplicate
+	  extent tracking.
+	- Fix handling of dynamic attribute fork roots in xfs_fsr.
+	- Fix sb_bad_features2 manipulations when tweaking the lazy count
+	  flag.
+	- Add support for building on Debian GNU/kFreeBSD, thanks
+	  to Petr Salinger.
+	- Improvements to the mkfs.xfs manpage, thanks to Wengang Wang.
+	- Various small blkid integreation fixes in mkfs.xfs.
+	- Fix build against stricter system headers.
+
 xfsprogs-3.1.1 (29 January 2010)
 	- Fix various blkid topology support problems in mkfs.xfs.
 	- Fix various build warnings.
Index: xfsprogs-dev/debian/changelog
===================================================================
--- xfsprogs-dev.orig/debian/changelog	2010-01-30 20:39:41.872254549 +0100
+++ xfsprogs-dev/debian/changelog	2010-04-29 12:23:53.931253925 +0200
@@ -1,3 +1,10 @@
+xfsprogs (3.1.2) unstable; urgency=low
+
+  * New upstream release
+  * Allow for building on GNU/kFreeBSD (closes: #485796)
+
+ -- Nathan Scott <nathans@debian.org>  Thu, 29 Apr 2010 14:25:43 +1100
+
 xfsprogs (3.1.1) unstable; urgency=low
 
   * New upstream release

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
