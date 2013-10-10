Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C6907F7E
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:39:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 415E9304039
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 06:39:16 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id pn3MDvFzCwR0jfgs (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Oct 2013 06:39:15 -0700 (PDT)
Subject: Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.725971.B.138141229820688@bugs.debian.org>
Date: Thu, 10 Oct 2013 14:38:11 +0100
From: Colin Watson <cjwatson@ubuntu.com>
Message-ID: <20131010133811.GK32337@riva.ucam.org>
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: Colin Watson <cjwatson@ubuntu.com>, 725971@bugs.debian.org
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: submit@bugs.debian.org

Package: xfsprogs
Version: 3.1.9
Severity: important
Tags: patch
User: debian-arm@lists.debian.org
Usertags: arm64

xfsprogs' config.guess/config.sub are out of date for the forthcoming
arm64 port.  The attached patch sets things up so that you don't have to
be bothered by this type of bug for future ports.

  * Use the autotools-dev dh addon to update config.guess/config.sub for
    arm64.

diff -Nru xfsprogs-3.1.9/debian/control xfsprogs-3.1.9ubuntu1/debian/control
--- xfsprogs-3.1.9/debian/control	2012-12-12 23:21:22.000000000 +0000
+++ xfsprogs-3.1.9ubuntu1/debian/control	2013-10-10 14:25:31.000000000 +0100
@@ -3,7 +3,7 @@
 Priority: optional
 Maintainer: XFS Development Team <xfs@oss.sgi.com>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev
+Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, autotools-dev
 Standards-Version: 3.9.1
 Homepage: http://oss.sgi.com/projects/xfs/
 
diff -Nru xfsprogs-3.1.9/debian/rules xfsprogs-3.1.9ubuntu1/debian/rules
--- xfsprogs-3.1.9/debian/rules	2010-08-18 04:53:43.000000000 +0100
+++ xfsprogs-3.1.9ubuntu1/debian/rules	2013-10-10 14:26:47.000000000 +0100
@@ -35,6 +35,7 @@
 .census:
 	@echo "== dpkg-buildpackage: configure" 1>&2
 	$(checkdir)
+	dh_autotools-dev_updateconfig
 	$(options) $(MAKE) include/platform_defs.h
 	touch .census
 
@@ -57,6 +58,8 @@
 	$(MAKE) distclean
 	-rm -rf $(dirme) $(dirdev) $(dirdi)
 	-rm -f debian/*substvars debian/files* debian/*.debhelper
+	dh_autotools-dev_restoreconfig
+	dh_clean
 
 binary-indep:
 

Thanks,

-- 
Colin Watson                                       [cjwatson@ubuntu.com]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
