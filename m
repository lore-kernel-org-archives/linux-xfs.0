Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97MP87X215563 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 17:25:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10B2EFA6F10
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 15:26:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rC17xYVjDD7nD5sW for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 15:26:34 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Mvexu-0002zx-PB
	for xfs@oss.sgi.com; Wed, 07 Oct 2009 22:26:34 +0000
Date: Wed, 7 Oct 2009 18:26:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] mkfs: add discard support
Message-ID: <20091007222634.GA8425@infradead.org>
References: <20091006184758.GA4780@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091006184758.GA4780@infradead.org>
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

Call the BLKDISCARD ioctl to mark the whole disk as unused before creating
a new filesystem.  This will allow SSDs, Arrays with thin provisioning support
and virtual machines to make smarter allocation decisions.

Add a new -K option to prevent mkfs from discarding blocks to aid
trouble-shooting or specialized requirements.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2009-10-07 21:47:31.000000000 +0000
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2009-10-07 22:25:29.000000000 +0000
@@ -605,6 +605,20 @@ done:
 	free(buf);
 }
 
+static void
+discard_blocks(dev_t dev, __uint64_t nsectors)
+{
+	int fd;
+
+	/*
+	 * We intentionally ignore errors from the discard ioctl.  It is
+	 * not necessary for the mkfs functionality but just an optimization.
+	 */
+	fd = libxfs_device_to_fd(dev);
+	if (fd > 0)
+		platform_discard_blocks(fd, 0, nsectors << 9);
+}
+
 int
 main(
 	int			argc,
@@ -681,6 +695,7 @@ main(
 	int			nvflag;
 	int			nci;
 	int			Nflag;
+	int			discard;
 	char			*p;
 	char			*protofile;
 	char			*protostring;
@@ -741,7 +756,7 @@ main(
 	xi.isdirect = LIBXFS_DIRECT;
 	xi.isreadonly = LIBXFS_EXCLUSIVELY;
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:n:Np:qr:s:CfV")) != EOF) {
+	while ((c = getopt(argc, argv, "b:d:i:l:L:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
 		case 'C':
 		case 'f':
@@ -1257,6 +1272,9 @@ main(
 		case 'N':
 			Nflag = 1;
 			break;
+		case 'K':
+			discard = 0;
+			break;
 		case 'p':
 			if (protofile)
 				respec('p', NULL, 0);
@@ -1645,6 +1663,14 @@ main(
 		}
 	}
 
+	if (discard) {
+		discard_blocks(xi.ddev, xi.dsize);
+		if (xi.rtdev)
+			discard_blocks(xi.rtdev, xi.rtsize);
+		if (xi.logdev && xi.logdev != xi.ddev)
+			discard_blocks(xi.logdev, xi.logBBsize);
+	}
+
 	if (!liflag && !ldflag)
 		loginternal = xi.logdev == 0;
 	if (xi.logname)
Index: xfsprogs-dev/include/linux.h
===================================================================
--- xfsprogs-dev.orig/include/linux.h	2009-10-07 21:47:31.000000000 +0000
+++ xfsprogs-dev/include/linux.h	2009-10-07 22:15:32.000000000 +0000
@@ -93,6 +93,20 @@ static __inline__ void platform_uuid_cop
 	uuid_copy(*dst, *src);
 }
 
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+static __inline__ int
+platform_discard_blocks(int fd, off64_t start, off64_t end)
+{
+	__uint64_t range[2] = { start, end };
+
+	if (ioctl(fd, BLKDISCARD, &range) < 0)
+		return errno;
+	return 0;
+}
+
 #if (__GLIBC__ < 2) || ((__GLIBC__ == 2) && (__GLIBC_MINOR__ <= 1))
 # define constpp	const char * const *
 #else
Index: xfsprogs-dev/include/darwin.h
===================================================================
--- xfsprogs-dev.orig/include/darwin.h	2009-10-07 21:47:31.000000000 +0000
+++ xfsprogs-dev/include/darwin.h	2009-10-07 22:15:32.000000000 +0000
@@ -154,4 +154,10 @@ typedef unsigned char	uchar_t;
 
 #define HAVE_FID	1
 
+static __inline__ int
+platform_discard_blocks(int fd, off64_t start, off64_t end)
+{
+	return 0;
+}
+
 #endif	/* __XFS_DARWIN_H__ */
Index: xfsprogs-dev/include/freebsd.h
===================================================================
--- xfsprogs-dev.orig/include/freebsd.h	2009-10-07 21:47:31.000000000 +0000
+++ xfsprogs-dev/include/freebsd.h	2009-10-07 22:15:32.000000000 +0000
@@ -139,4 +139,10 @@ static __inline__ void platform_uuid_cop
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+static __inline__ int
+platform_discard_blocks(int fd, off64_t start, off64_t end)
+{
+	return 0;
+}
+
 #endif	/* __XFS_FREEBSD_H__ */
Index: xfsprogs-dev/include/irix.h
===================================================================
--- xfsprogs-dev.orig/include/irix.h	2009-10-07 21:47:31.000000000 +0000
+++ xfsprogs-dev/include/irix.h	2009-10-07 22:15:32.000000000 +0000
@@ -337,6 +337,12 @@ static __inline__ void platform_uuid_cop
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+static __inline__ int
+platform_discard_blocks(int fd, off64_t start, off64_t end)
+{
+	return 0;
+}
+
 static __inline__ char * strsep(char **s, const char *ct)
 {
 	char *sbegin = *s, *end;
Index: xfsprogs-dev/man/man8/mkfs.xfs.8
===================================================================
--- xfsprogs-dev.orig/man/man8/mkfs.xfs.8	2009-10-07 22:19:23.000000000 +0000
+++ xfsprogs-dev/man/man8/mkfs.xfs.8	2009-10-07 22:22:26.000000000 +0000
@@ -36,6 +36,8 @@ mkfs.xfs \- construct an XFS filesystem
 .I label
 ] [
 .B \-N
+] [
+.B \-K
 ]
 .I device
 .SH DESCRIPTION
@@ -714,6 +716,9 @@ manual entries for additional informatio
 .B \-N
 Causes the file system parameters to be printed out without really
 creating the file system.
+.TP
+.B \-K
+Do not attempt to discard blocks at mkfs time.
 .SH SEE ALSO
 .BR xfs (5),
 .BR mkfs (8),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
