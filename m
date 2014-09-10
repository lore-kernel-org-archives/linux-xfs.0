Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D2757F3F
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:24:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B24C304059
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 07:24:13 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id lI26uLfCSW10cjcD (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 07:24:08 -0700 (PDT)
Subject: Bug#757455: please run dh_autoreconf or manually update m4/libtool.m4
	for ppc64el
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.757455.B757455.141035895430667@bugs.debian.org>
Date: Wed, 10 Sep 2014 16:22:26 +0200
From: Andreas Barth <aba@ayous.org>
Message-ID: <20140910142226.GA32059@mails.so.argh.org>
References: <53E4C0A5.8060704@debian.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53E4C0A5.8060704@debian.org>
Reply-To: Andreas Barth <aba@ayous.org>, 757455@bugs.debian.org
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
To: Matthias Klose <doko@debian.org>, 757455@bugs.debian.org

* Matthias Klose (doko@debian.org) [140910 14:19]:
> trying to use dh_autoreconf:

It works with the following patch:
diff -ur xfsprogs-3.2.1~/debian/control xfsprogs-3.2.1/debian/control
--- xfsprogs-3.2.1~/debian/control      2014-05-02 00:09:15.000000000 +0000
+++ xfsprogs-3.2.1/debian/control       2014-09-10 14:14:34.026319172 +0000
@@ -3,7 +3,7 @@
 Priority: optional
 Maintainer: XFS Development Team <xfs@oss.sgi.com>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, autotools-dev
+Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev
 Standards-Version: 3.9.1
 Homepage: http://oss.sgi.com/projects/xfs/
 
diff -ur xfsprogs-3.2.1~/debian/rules xfsprogs-3.2.1/debian/rules
--- xfsprogs-3.2.1~/debian/rules        2014-05-02 00:09:15.000000000 +0000
+++ xfsprogs-3.2.1/debian/rules 2014-09-10 14:13:18.182294515 +0000
@@ -35,7 +35,7 @@
 .census:
        @echo "== dpkg-buildpackage: configure" 1>&2
        $(checkdir)
-       dh_autotools-dev_updateconfig
+       AUTOHEADER=/bin/true dh_autoreconf
        $(options) $(MAKE) include/platform_defs.h
        touch .census
 
@@ -58,7 +58,7 @@
        $(MAKE) distclean
        -rm -rf $(dirme) $(dirdev) $(dirdi)
        -rm -f debian/*substvars debian/files* debian/*.debhelper
-       dh_autotools-dev_restoreconfig
+       dh_autoreconf_clean
        dh_clean
 
 binary-indep:

As this package is required to build ceph, libvirt and redhat-cluster
I'd be willing to help fixing it, if required also by an NMU. Unless
there is a reason why not, I intend to upload the fix within the next
days.


Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
