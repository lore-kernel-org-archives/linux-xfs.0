Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CGgbBD040347 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 10:42:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 890E51C478A7
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 08:43:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BiESJAMHqOGJb91y for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 08:43:33 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NUjq8-00062b-RX
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 16:43:32 +0000
Date: Tue, 12 Jan 2010 11:43:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3] xfsprogs: bump version and update changelog
Message-ID: <20100112164332.GA22988@infradead.org>
References: <20091223135718.GA29975@infradead.org>
	<20100108122639.GA17229@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100108122639.GA17229@infradead.org>
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
--- xfsprogs-dev.orig/VERSION	2010-01-02 12:11:42.871003354 +0100
+++ xfsprogs-dev/VERSION	2010-01-06 18:49:38.221274008 +0100
@@ -2,6 +2,6 @@
 # This file is used by configure to get version information
 #
 PKG_MAJOR=3
-PKG_MINOR=0
-PKG_REVISION=4
+PKG_MINOR=1
+PKG_REVISION=0
 PKG_BUILD=1
Index: xfsprogs-dev/doc/CHANGES
===================================================================
--- xfsprogs-dev.orig/doc/CHANGES	2010-01-02 12:11:42.873010034 +0100
+++ xfsprogs-dev/doc/CHANGES	2010-01-08 13:24:09.150268999 +0100
@@ -1,3 +1,23 @@
+xfsprogs-3.1.0
+	- Reduce memory usage in xfs_repair by using better data structures.
+	- Add additional checks in xfs_repair to detect freespace btree
+	  corruption instead of only rebuilding the btrees.  Useful for the
+	  no-modify mode.
+	- Fix libhandle to use the right path to issue by-handle ioctls for
+	  symbolic links and special files.
+	- Use lazy superblock counters by default.  At least kernel 2.6.22 is
+	  needed for this feature.
+	- Add a German translation, thanks to Chris Leick.
+	- Enable the madvise and mincor commands in xfs_io.
+	- Fix unsafe temporary file creation in xfs_fsr.
+	- Add support for discarding unused space on SSDs or thing provionen
+	  arrays in mkfs.xfs.
+	- Allow linking against libblkid for topology information.
+	- Add symbol versioning for libhandle.
+	- Remove the included RPM and binary tarball built infrastructure.
+	- Various build system improvements.
+	- Small fixes to xfs_db and xfs_io.
+
 xfsprogs-3.0.4 (17 September 2009)
 	- Fix a memory leak in xfsprogs.
 	- Increase hash chain length in xfsprogs when running out of memory.
Index: xfsprogs-dev/debian/changelog
===================================================================
--- xfsprogs-dev.orig/debian/changelog	2010-01-02 12:11:42.872012141 +0100
+++ xfsprogs-dev/debian/changelog	2010-01-06 18:49:38.224273412 +0100
@@ -1,6 +1,6 @@
 xfsprogs (3.1.0) unstable; urgency=low
 
-  * New bugfix release
+  * New upstream release
   * Merged German translation (closes: #521389)
   * Merged German translation update (closes: #557100)
   * Uptodate po file is provided now (closes: #538962)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
