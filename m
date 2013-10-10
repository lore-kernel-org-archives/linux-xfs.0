Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 57B367F4E
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 18:24:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6A9FAC001
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 16:24:33 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id P07WjphHl41zUeQ6 for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 16:24:32 -0700 (PDT)
Received: from zmail20.collab.prod.int.phx2.redhat.com
	(zmail20.collab.prod.int.phx2.redhat.com [10.5.83.23])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r9ANOVrn022293
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 19:24:31 -0400
Date: Thu, 10 Oct 2013 19:24:31 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <408976477.5626180.1381447471755.JavaMail.root@redhat.com>
In-Reply-To: <20131010133811.GK32337@riva.ucam.org>
References: <20131010133811.GK32337@riva.ucam.org>
Subject: Fwd: Bug#725971: xfsprogs: config.guess/config.sub out of date for
	arm64
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
To: XFS <xfs@oss.sgi.com>

Hi all,

Have tested this out here & works just fine - please merge.

Signed-off-by: Nathan Scott <nathans@debian.org>

and tested-by, reviewed-by, etc ... whatever floats your boat.

thanks!

----- Forwarded Message -----
From: "Colin Watson" <cjwatson@ubuntu.com>
To: submit@bugs.debian.org
Sent: Friday, October 11, 2013 12:38:11 AM
Subject: Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
