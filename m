Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7KM1To6177469 for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 17:01:29 -0500
Received: from hall.aurel32.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E286E1DA0132
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 15:01:26 -0700 (PDT)
Received: from hall.aurel32.net (hall.aurel32.net [88.191.126.93]) by
	cuda.sgi.com with ESMTP id yPFk6aoaFwhZfGdQ for
	<xfs@oss.sgi.com>; Sat, 20 Aug 2011 15:01:26 -0700 (PDT)
Date: Sun, 21 Aug 2011 00:01:23 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
Subject: Bug#553875: replacing libreadline5-dev build dependency with
	libreadline-dev
Message-ID: <20110820220123.GA27252@volta.aurel32.net>
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
To: XFS Development Team <xfs@oss.sgi.com>
Cc: 553875@bugs.debian.org

Hi,

I have just done an NMU of xfsprogs to fix this longstanding issue. You
will find below the diff of the NMU.

Regards,
Aurelien


diff -Nru xfsprogs-3.1.5/debian/changelog xfsprogs-3.1.5+nmu1/debian/changelog
--- xfsprogs-3.1.5/debian/changelog	2011-03-31 06:37:28.000000000 +0200
+++ xfsprogs-3.1.5+nmu1/debian/changelog	2011-08-20 23:27:40.000000000 +0200
@@ -1,3 +1,12 @@
+xfsprogs (3.1.5+nmu1) unstable; urgency=low
+
+  * Non-maintainer upload, breaking the assumption: "the upstream
+    release is also the Debian release" (see bug#144876).
+  * Build-depends on libreadline-gplv2-dev instead of libreadline5-dev
+    as the code is not compatible with GPL v3 (closes: #553875).
+
+ -- Aurelien Jarno <aurel32@debian.org>  Sat, 20 Aug 2011 23:14:01 +0200
+
 xfsprogs (3.1.5) unstable; urgency=low
 
   * New upstream release
diff -Nru xfsprogs-3.1.5/debian/control xfsprogs-3.1.5+nmu1/debian/control
--- xfsprogs-3.1.5/debian/control	2010-11-09 12:40:44.000000000 +0100
+++ xfsprogs-3.1.5+nmu1/debian/control	2011-08-20 23:10:53.000000000 +0200
@@ -3,7 +3,7 @@
 Priority: optional
 Maintainer: XFS Development Team <xfs@oss.sgi.com>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev, libblkid-dev (>= 2.17)
+Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev, libblkid-dev (>= 2.17)
 Standards-Version: 3.9.1
 Homepage: http://oss.sgi.com/projects/xfs/

-- 
Aurelien Jarno                          GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
