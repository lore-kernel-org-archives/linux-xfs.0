Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96F9bf2073145 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 10:09:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 900C64A6999
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 08:11:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uvdqxJXIdj1G91x9 for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 08:11:03 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MvBgs-0000DM-SS
	for xfs@oss.sgi.com; Tue, 06 Oct 2009 15:11:02 +0000
Date: Tue, 6 Oct 2009 11:11:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: add missing CHANGES entry
Message-ID: <20091006151102.GA30964@infradead.org>
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

The 3.0.4 release for debian actually had a few more changes than documented.
Add the missing entries so that they appear in the right spot for future
releases.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/doc/CHANGES
===================================================================
--- xfsprogs-dev.orig/doc/CHANGES	2009-10-06 10:51:31.609004058 -0300
+++ xfsprogs-dev/doc/CHANGES	2009-10-06 10:54:13.695006442 -0300
@@ -1,4 +1,10 @@
 xfsprogs-3.0.4 (17 September 2009)
+	- Fix a memory leak in xfsprogs.
+	- Increase hash chain length in xfsprogs when running out of memory.
+	- Fix dmsetup invocation in libdisk to avoid warnings during mkfs
+	  on multipath devices.
+	- Fix the -V option to various installed tools.
+	- Small internal fixes to please the clang semantical analysis tool.
 	- Debian packaging updates.
 	- Rework Makepkgs and Makefiles to improve deb generation.
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
