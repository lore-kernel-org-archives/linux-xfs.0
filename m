Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBK0SYpA018200 for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 18:28:34 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9B791B9B469
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 16:28:31 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id UuRJsdGuPbdVQbw7 for
	<xfs@oss.sgi.com>; Fri, 19 Dec 2008 16:28:31 -0800 (PST)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam Firewall) with ESMTP id 1654F535B7C
	for <xfs@oss.sgi.com>; Sat, 20 Dec 2008 11:28:29 +1100 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id FQMWZGcdPxLBmEFU for
	<xfs@oss.sgi.com>; Sat, 20 Dec 2008 11:28:29 +1100 (EST)
Received: from [192.168.0.100] (c220-239-214-222.fernt2.vic.optusnet.com.au
	[220.239.214.222])
	by postoffice.aconex.com (Postfix) with ESMTP id 0160692C2FB
	for <xfs@oss.sgi.com>; Sat, 20 Dec 2008 11:28:28 +1100 (EST)
Subject: Debian userspace updates
From: Nathan Scott <nscott@aconex.com>
Content-Type: multipart/mixed; boundary="=-i7d+WoccmTZcRHvqQ9La"
Date: Sat, 20 Dec 2008 11:25:49 +1100
Message-Id: <1229732749.4496.28.camel@verge.scott.net.au>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--=-i7d+WoccmTZcRHvqQ9La
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Here's a couple of trivial patches from updating the Debian
userspace packages.  Please merge - thanks!

--
Nathan

--=-i7d+WoccmTZcRHvqQ9La
Content-Disposition: attachment; filename=bump-deb-version
Content-Type: text/x-patch; name=bump-deb-version; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: xfsprogs-2.10.2/debian/changelog
===================================================================
--- xfsprogs-2.10.2.orig/debian/changelog	2008-12-20 11:18:09.875260474 +1100
+++ xfsprogs-2.10.2/debian/changelog	2008-12-20 11:18:13.473172568 +1100
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
 xfsprogs (2.9.8-1) unstable; urgency=low
 
   * New upstream release

--=-i7d+WoccmTZcRHvqQ9La
Content-Disposition: attachment; filename=fix-dir2-warn
Content-Type: text/x-patch; name=fix-dir2-warn; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: xfsprogs-2.10.2/libxfs/xfs_dir2.c
===================================================================
--- xfsprogs-2.10.2.orig/libxfs/xfs_dir2.c	2008-12-20 11:21:21.985184849 +1100
+++ xfsprogs-2.10.2/libxfs/xfs_dir2.c	2008-12-20 11:21:33.795013403 +1100
@@ -21,6 +21,7 @@
  * Top-level and utility routines.
  */
 
+#include <ctype.h>
 #include <xfs.h>
 
 extern const struct xfs_nameops xfs_default_nameops;

--=-i7d+WoccmTZcRHvqQ9La
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-i7d+WoccmTZcRHvqQ9La--
