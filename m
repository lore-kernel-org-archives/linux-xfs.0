Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96IkX39084762 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 13:46:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 789D14A7B94
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 11:47:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wO6gi9GD51f4fpy0 for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 11:47:58 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MvF4o-0001jd-Km
	for xfs@oss.sgi.com; Tue, 06 Oct 2009 18:47:58 +0000
Date: Tue, 6 Oct 2009 14:47:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] mkfs: add discard support
Message-ID: <20091006184758.GA4780@infradead.org>
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

Call the BLKDISCARD ioctl to mark the whole disk as unused before creating
a new filesystem.  This will allow SSDs, Arrays with thin provisioning support
and virtual machines to make smarter allocation decisions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2009-10-06 18:02:34.000000000 +0000
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2009-10-06 18:03:55.000000000 +0000
@@ -605,6 +605,29 @@ done:
 	free(buf);
 }
 
+#ifdef __linux__
+
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+static void
+discard_blocks(dev_t dev, __uint64_t nsectors)
+{
+	int fd = libxfs_device_to_fd(dev);
+	__uint64_t range[2] = { 0, nsectors << 9 };
+
+	/*
+	 * We intentionally ignore errors from the discard ioctl.  It is
+	 * not nessecary for the mkfs functionality but just an optimization.
+	 */
+	if (fd > 0)
+		ioctl(fd, BLKDISCARD, &range);
+}
+#else
+#define discard_blocks(dev, nsectors)
+#endif
+
 int
 main(
 	int			argc,
@@ -1645,6 +1668,12 @@ main(
 		}
 	}
 
+	discard_blocks(xi.ddev, xi.dsize);
+	if (xi.rtdev)
+		discard_blocks(xi.rtdev, xi.rtsize);
+	if (xi.logdev && xi.logdev != xi.ddev)
+		discard_blocks(xi.logdev, xi.logBBsize);
+
 	if (!liflag && !ldflag)
 		loginternal = xi.logdev == 0;
 	if (xi.logname)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
