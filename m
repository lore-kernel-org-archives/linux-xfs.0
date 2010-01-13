Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DLZOTv191312 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 15:35:25 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 599C3163A30
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 13:36:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id smDGMZsZqyZQGkGA for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 13:36:21 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NVAt2-0005Sp-Pp
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 21:36:20 +0000
Date: Wed, 13 Jan 2010 16:36:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: add package_blkid.m4 to the distributed files
Message-ID: <20100113213620.GA20812@infradead.org>
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

We need to include all the m4 files in the source tarball in case people
want to regenerate the configure script.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/m4/Makefile
===================================================================
--- xfsprogs-dev.orig/m4/Makefile	2010-01-13 22:27:54.121253788 +0100
+++ xfsprogs-dev/m4/Makefile	2010-01-13 22:28:08.553256439 +0100
@@ -15,6 +15,7 @@ CONFIGURE = \
 LSRCFILES = \
 	manual_format.m4 \
 	package_aiodev.m4 \
+	package_blkid.m4 \
 	package_globals.m4 \
 	package_libcdev.m4 \
 	package_pthread.m4 \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
