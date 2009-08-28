Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SMCUil179470 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 17:12:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7DD51B23258
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 15:13:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vkU18dYpZUtOCVJd for
	<xfs@oss.sgi.com>; Fri, 28 Aug 2009 15:13:04 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Mh9gu-0005ps-CR
	for xfs@oss.sgi.com; Fri, 28 Aug 2009 22:13:04 +0000
Date: Fri, 28 Aug 2009 18:13:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: update CHANGES
Message-ID: <20090828221304.GA17666@infradead.org>
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

Index: xfsprogs-dev/doc/CHANGES
===================================================================
--- xfsprogs-dev.orig/doc/CHANGES	2009-08-28 18:55:43.439981605 -0300
+++ xfsprogs-dev/doc/CHANGES	2009-08-28 19:11:00.795912101 -0300
@@ -1,5 +1,11 @@
-	- Fix xfs_io and xfs_quota when readline config enabled.
+xfsprogs-3.0.3
+	- Fix unaligned accesses in libxfs.
+	- Various small fixes to xfs_db, xfs_repair and xfs_io.
 	- Add fallocate command to xfs_io.
+	- Enable readline support in xfs_io and xfs_quota.
+	- Allow log sizes up to 2GiB (minus 1 byte) in xfs_mkfs.
+	- Open the block device in xfs_repair exclusively, thanks to
+	  Nathaniel W. Turner.
 
 xfsprogs-3.0.2 (6 May 2009)
 	- Updates to Debian build process after recent autoconf tweaks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
