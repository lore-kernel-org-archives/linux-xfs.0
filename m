Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GJvVc2088393 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 14:57:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B96C71429700
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 12:59:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9W0Macjkz4NHMfPT for
	<xfs@oss.sgi.com>; Thu, 16 Apr 2009 12:59:31 -0700 (PDT)
Date: Thu, 16 Apr 2009 15:57:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: keep autoconf-generated files over make distclean
Message-ID: <20090416195713.GB22431@infradead.org>
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

We do want to ship the autoconf-generated files over make distclean and
pick them up in Makepkgs so that a user compiling the program doesn't
require autoconf.

For that split up make distclean from make realclean and exclude the
files we want to keep form the former.

To make this easier to maintain adher to stricter rules of use for
CONFIGURE and LDIRT.  CONFIGURE now includes all generated files from
autoconf (or for it like our copied install-sh) and gets only removed
on make realclean, but added to LSRCFILES so that Makepkgs can pick it
up.  Everything else than needs to be removed on a realclean gets
assigned to LDIRT.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/Makefile
===================================================================
--- xfsprogs-dev.orig/Makefile	2009-04-16 21:33:57.186074648 +0200
+++ xfsprogs-dev/Makefile	2009-04-16 21:37:48.950076935 +0200
@@ -10,13 +10,14 @@ include $(TOPDIR)/include/builddefs
 endif
 
 CONFIGURE = aclocal.m4 configure config.guess config.sub \
+	    libtool configure install-sh \
+	    include/builddefs include/platform_defs.h \
 	    ltmain.sh m4/libtool.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
-	    m4/ltversion.m4 m4/lt~obsolete.m4 \
-	    include/builddefs include/platform_defs.h
-LSRCFILES = configure.in Makepkgs install-sh README VERSION $(CONFIGURE)
+	    m4/ltversion.m4 m4/lt~obsolete.m4
+LSRCFILES = configure.in Makepkgs README VERSION $(CONFIGURE)
 
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
-	Logs/* built .census install.* install-dev.* *.gz
+	Logs/* built .census install.* install-dev.* *.gz autom4te.cache/*
 
 LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
@@ -96,7 +97,8 @@ install-qa: install $(addsuffix -install
 %-install-qa:
 	$(MAKE) -C $* install-qa
 
-realclean distclean: clean
-	rm -f $(LDIRT) $(CONFIGURE)
-	rm -f include/builddefs include/config.h install-sh libtool
-	rm -rf autom4te.cache Logs
+distclean: clean
+	rm -f $(LDIRT)
+
+realclean: distclean
+	rm -f $(CONFIGURE)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
