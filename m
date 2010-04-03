Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o33AVXAS039360 for <xfs@oss.sgi.com>; Sat, 3 Apr 2010 05:31:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0D4112368FD
	for <xfs@oss.sgi.com>; Sat,  3 Apr 2010 03:33:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id X8WOC5O4UXu0294L for
	<xfs@oss.sgi.com>; Sat, 03 Apr 2010 03:33:21 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ny0fJ-0007FS-IV
	for xfs@oss.sgi.com; Sat, 03 Apr 2010 10:33:21 +0000
Date: Sat, 3 Apr 2010 06:33:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: add a platform_discard_blocks stub to gnufreebsd
Message-ID: <20100403103321.GA20739@infradead.org>
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

Index: xfsprogs-dev/include/gnukfreebsd.h
===================================================================
--- xfsprogs-dev.orig/include/gnukfreebsd.h	2010-04-03 12:29:57.048004157 +0200
+++ xfsprogs-dev/include/gnukfreebsd.h	2010-04-03 12:30:12.913005989 +0200
@@ -119,4 +119,10 @@ static __inline__ void platform_uuid_cop
 	uuid_copy(*dst, *src);
 }
 
+static __inline__ int
+platform_discard_blocks(int fd, uint64_t start, uint64_t len)
+{
+	return 0;
+}
+
 #endif	/* __XFS_KFREEBSD_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
