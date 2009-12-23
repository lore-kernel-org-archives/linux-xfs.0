Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNDuZCD239764 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 07:56:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5852C1C10792
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 05:57:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id r9nfnHL3MFIDqUgS for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2009 05:57:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NNRiI-0007o3-JB
	for xfs@oss.sgi.com; Wed, 23 Dec 2009 13:57:18 +0000
Date: Wed, 23 Dec 2009 08:57:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: xfsprogs: bump version and update changelog
Message-ID: <20091223135718.GA29975@infradead.org>
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

(Does not include my pending repair changes and Bill's libhandle update
 yet, which should still go into 3.1.0, just posting for review)

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/VERSION
===================================================================
--- xfsprogs-dev.orig/VERSION	2009-12-23 14:15:21.113170043 +0100
+++ xfsprogs-dev/VERSION	2009-12-23 14:15:25.133170044 +0100
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
--- xfsprogs-dev.orig/doc/CHANGES	2009-12-23 14:15:30.342170057 +0100
+++ xfsprogs-dev/doc/CHANGES	2009-12-23 14:24:06.350170049 +0100
@@ -1,3 +1,18 @@
+xfsprogs-3.0.1
+	- Reduce memory usage in xfs_repair by using better data structures.
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
--- xfsprogs-dev.orig/debian/changelog	2009-12-23 14:27:00.284170043 +0100
+++ xfsprogs-dev/debian/changelog	2009-12-23 14:27:29.545170043 +0100
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
