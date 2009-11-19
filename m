Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAJNDuIq078111 for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 17:13:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD1DCD6E0AB
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 15:14:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id X9FCk9XFAzZeYywD for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2009 15:14:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NBGCg-0001t6-G3
	for xfs@oss.sgi.com; Thu, 19 Nov 2009 23:14:18 +0000
Date: Thu, 19 Nov 2009 18:14:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: stop using off64_t in platform headers
Message-ID: <20091119231418.GA7161@infradead.org>
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

Using off64_t may require special headers or compiler flags that aren't
always available, e.g. in the configure check in xfstests.  Rever to a plain
uint64_t to make apps compile as before.

While we're at it also rename the second argument of platform_discard_blocks
from end to len as that's what the BLKDISCARD ioctl excepts - we currently
always discard the whole device so it doesn't matter in practice.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/include/darwin.h
===================================================================
--- xfsprogs-dev.orig/include/darwin.h	2009-11-19 23:12:05.000000000 +0000
+++ xfsprogs-dev/include/darwin.h	2009-11-19 23:12:30.000000000 +0000
@@ -155,7 +155,7 @@ typedef unsigned char	uchar_t;
 #define HAVE_FID	1
 
 static __inline__ int
-platform_discard_blocks(int fd, off64_t start, off64_t end)
+platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 {
 	return 0;
 }
Index: xfsprogs-dev/include/freebsd.h
===================================================================
--- xfsprogs-dev.orig/include/freebsd.h	2009-11-19 23:12:05.000000000 +0000
+++ xfsprogs-dev/include/freebsd.h	2009-11-19 23:12:30.000000000 +0000
@@ -140,7 +140,7 @@ static __inline__ void platform_uuid_cop
 }
 
 static __inline__ int
-platform_discard_blocks(int fd, off64_t start, off64_t end)
+platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 {
 	return 0;
 }
Index: xfsprogs-dev/include/irix.h
===================================================================
--- xfsprogs-dev.orig/include/irix.h	2009-11-19 23:12:05.000000000 +0000
+++ xfsprogs-dev/include/irix.h	2009-11-19 23:12:30.000000000 +0000
@@ -338,7 +338,7 @@ static __inline__ void platform_uuid_cop
 }
 
 static __inline__ int
-platform_discard_blocks(int fd, off64_t start, off64_t end)
+platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 {
 	return 0;
 }
Index: xfsprogs-dev/include/linux.h
===================================================================
--- xfsprogs-dev.orig/include/linux.h	2009-11-19 23:12:04.000000000 +0000
+++ xfsprogs-dev/include/linux.h	2009-11-19 23:12:40.000000000 +0000
@@ -98,9 +98,9 @@ static __inline__ void platform_uuid_cop
 #endif
 
 static __inline__ int
-platform_discard_blocks(int fd, off64_t start, off64_t end)
+platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 {
-	__uint64_t range[2] = { start, end };
+	__uint64_t range[2] = { start, len };
 
 	if (ioctl(fd, BLKDISCARD, &range) < 0)
 		return errno;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
