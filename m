Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGhuFq006411 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:43:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EA881775785
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id maR1tmdVp43MxlCZ for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:54 -0800 (PST)
Message-Id: <20081222164354.124617000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/20] update Debian packaging
Content-Disposition: inline; filename=xfsprogs-bump-deb-version
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


From: Nathan Scott <nscott@aconex.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsprogs/debian/changelog
===================================================================
--- xfs-cmds.orig/xfsprogs/debian/changelog	2008-12-01 22:06:20.000000000 +0100
+++ xfs-cmds/xfsprogs/debian/changelog	2008-12-22 10:10:30.652247718 +0100
@@ -1,3 +1,13 @@
+xfsprogs (2.10.2-1) unstable; urgency=low
+
+  * New upstream release
+  * No longer ignore -i maxpct option in mkfs.xfs (closes: #500593)
+  * Correct features2 superblock field handling (closes: #473135)
+  * 32 bit emulation on 64 bit kernels works (closes: #485020)
+  * Fix up large sector handling in mkfs (closes: #489421)
+
+ -- Nathan Scott <nathans@debian.org>  Sat, 20 Dec 2008 10:14:27 +1100
+
 xfsprogs (2.9.10-1) unstable; urgency=low
 
   * New upstream release

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
