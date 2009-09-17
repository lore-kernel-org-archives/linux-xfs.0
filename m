Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8HN7g36251707 for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 18:07:42 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B50D6462F0B
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 16:08:55 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id 3ktUnwF7W7TZ0iSk for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2009 16:08:55 -0700 (PDT)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam & Virus Firewall) with ESMTP id
	C58987374BB
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2009 09:08:53 +1000 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id uCLfRxZnR8eiPtf6 for
	<xfs@oss.sgi.com>; Fri, 18 Sep 2009 09:08:53 +1000 (EST)
Received: from gatekeeper.aconex.com (gatekeeper.yarra.acx [192.168.102.10])
	by postoffice.aconex.com (Postfix) with ESMTP id A6BD9A500A6
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2009 09:07:44 +1000 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gatekeeper.aconex.com (Postfix) with ESMTP id B3E264FD88
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2009 09:08:53 +1000 (EST)
Received: from gatekeeper.aconex.com ([127.0.0.1])
	by localhost (gatekeeper.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 9QLfI-xxxN1y for <xfs@oss.sgi.com>;
	Fri, 18 Sep 2009 09:08:50 +1000 (EST)
Received: from mail-au.aconex.com (mail-au.aconex.com [192.168.102.12])
	by gatekeeper.aconex.com (Postfix) with ESMTP id F0BB04FD82
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2009 09:08:49 +1000 (EST)
Date: Fri, 18 Sep 2009 09:08:49 +1000 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1527800797.273701253228929936.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <777659823.265181253164106522.JavaMail.root@mail-au.aconex.com>
Subject: [patch] xfsprogs build tweaks for Debian
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_19981_1748027851.1253228929935"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

------=_Part_19981_1748027851.1253228929935
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi all,

This patch allows deb packages to be generated more cleanly by Makepkgs
than it currently allows.  In particular, it handles the issue of having
.git files in the generated tarball, and also puts the debs in build/deb
when they're built, which is a bit more convenient and consistent.

Another handy side-effect of doing the build this new way (pcp packages
are also built this way, FWIW), is that it verifies the SRCFILES macros
as part of the build, which ensures the source tarball that we generate
will actually build.

cheers.

-- 
Nathan

------=_Part_19981_1748027851.1253228929935
Content-Type: text/x-patch; name=patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=patch

diff --git a/Makefile b/Makefile
index db718d2..8a7ef4d 100644
--- a/Makefile
+++ b/Makefile
@@ -9,9 +9,7 @@ ifeq ($(HAVE_BUILDDEFS), yes)
 include $(TOPDIR)/include/builddefs
 endif
 
-CONFIGURE = aclocal.m4 configure config.guess config.sub configure install-sh \
-	    ltmain.sh m4/libtool.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
-	    m4/ltversion.m4 m4/lt~obsolete.m4
+CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
 LSRCFILES = configure.in Makepkgs release.sh README VERSION $(CONFIGURE)
 
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
diff --git a/Makepkgs b/Makepkgs
index d5583b4..1f3c8c0 100755
--- a/Makepkgs
+++ b/Makepkgs
@@ -6,6 +6,7 @@
 LOGDIR=Logs
 
 type=rpm
+[ -f /etc/debian_version ] && type=debian
 verbose=false
 
 MAKE=${MAKE:-make}
@@ -35,13 +36,27 @@ test -f fileslib.rpm && rm -f fileslib.rpm
 test ! -d $LOGDIR && mkdir $LOGDIR
 rm -rf $LOGDIR/* > /dev/null 2>&1
 
-# build Debian packages, cleans itself before starting
-SUDO=${SUDO:-sudo}
-test ! -z "$SUDO" && sudo=$SUDO
 if [ $type = debian ] ; then
-	LOGDEB=`pwd`
-	LOGDEB=../`basename $LOGDEB`.log
-	echo "== Debian build, log is $LOGDEB"; echo
+	SOURCE=`pwd`
+	PACKAGE=`basename $SOURCE`
+	LOGDEB=$SOURCE/$LOGDIR/$PACKAGE.log
+	if $verbose ; then
+		$MAKE include/builddefs 2>&1 | tee $LOGDIR/configure
+	else
+		$MAKE include/builddefs > $LOGDIR/configure 2>&1  || exit 1
+	fi
+
+	. ./VERSION
+	VERSION=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
+	export SRCLINK_ROOT="$SOURCE/build/deb/$PACKAGE-$VERSION"
+	rm -fr "$SRCLINK_ROOT"
+	mkdir -p "$SRCLINK_ROOT" || exit 1
+
+	$MAKE source-link || exit 1
+
+	cd "$SRCLINK_ROOT"
+	SUDO=${SUDO:-fakeroot}
+	test ! -z "$SUDO" && sudo=$SUDO
 	if $verbose ; then
 		dpkg-buildpackage -r$SUDO | tee $LOGDEB
 	else
@@ -50,7 +65,6 @@ if [ $type = debian ] ; then
 	exit 0
 fi
 
-# build RPM packages - manual clean before starting
 echo "== clean, log is $LOGDIR/clean"
 if $verbose ; then
 	$MAKE clean 2>&1 | tee $LOGDIR/clean
diff --git a/VERSION b/VERSION
index b3a880e..6018818 100644
--- a/VERSION
+++ b/VERSION
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=0
-PKG_REVISION=3
+PKG_REVISION=4
 PKG_BUILD=1
diff --git a/build/Makefile b/build/Makefile
index 200c249..cec6115 100644
--- a/build/Makefile
+++ b/build/Makefile
@@ -9,6 +9,7 @@ MANIFEST=src-manifest
 SRCTAR=$(PKG_NAME)-$(PKG_VERSION).tar.gz
 
 LDIRT = *-manifest *.gz $(TOPDIR)/$(PKG_NAME)-*
+LDIRDIRT = deb
 
 # for clean and clobber
 SUBDIRS = tar rpm
diff --git a/debian/changelog b/debian/changelog
index ebf9819..84ba8a8 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,10 @@
+xfsprogs (3.0.4) unstable; urgency=low
+
+  * New bugfix release
+  * Update readline dependency to allow libreadline6.
+
+ -- Nathan Scott <nathans@debian.org>  Thu, 17 Sep 2009 14:32:48 +1000
+
 xfsprogs (3.0.2) unstable; urgency=low
 
   * New bugfix release
diff --git a/debian/control b/debian/control
index 7c5cb93..3939605 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: Nathan Scott <nathans@debian.org>
 Uploaders: Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev
+Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev | libreadline-dev
 Standards-Version: 3.8.1
 Homepage: http://oss.sgi.com/projects/xfs/
 
diff --git a/doc/CHANGES b/doc/CHANGES
index c7da0bd..1590106 100644
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,7 @@
+xfsprogs-3.0.4 (17 September 2009)
+	- Debian packaging updates, esp. readline6 dependency.
+	- Rework Makepkgs and Makefiles to improve deb generation.
+
 xfsprogs-3.0.3 (30 August 2009)
 	- Fix unaligned accesses in libxfs.
 	- Various small fixes to xfs_db, xfs_repair and xfs_io.
diff --git a/include/Makefile b/include/Makefile
index 1ca5071..d89480e 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -19,7 +19,7 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 QAHFILES = libxfs.h libxlog.h \
-	bitops.h cache.h kmem.h list.h parent.h swab.h xqm.h \
+	bitops.h cache.h kmem.h list.h parent.h swab.h \
 	xfs_ag.h xfs_alloc.h xfs_alloc_btree.h xfs_arch.h xfs_attr_leaf.h \
 	xfs_attr_sf.h xfs_bit.h xfs_bmap.h xfs_bmap_btree.h xfs_btree.h \
 	xfs_btree_trace.h xfs_buf_item.h xfs_da_btree.h xfs_dinode.h \
diff --git a/include/buildmacros b/include/buildmacros
index ec22fb6..b825e10 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -22,6 +22,8 @@ MANDIRT = *.[1-9].gz
 PODIRT = *.tmpo *.mo
 CDIRT = $(OBJECTS) $(LTOBJECTS) $(LTCOMMAND) $(LTLIBRARY)
 DIRT = $(LDIRT) $(DEPDIRT) $(MANDIRT) $(PODIRT) $(CDIRT)
+LIBDIRT = .libs
+DIRDIRT = $(LDIRDIRT) $(LIBDIRT)
 
 OBJECTS = $(ASFILES:.s=.o) \
 	  $(CFILES:.c=.o) \
@@ -138,7 +140,7 @@ DIST_MAKERULE = \
 
 SOURCE_MAKERULE = \
 	@test -z "$$DIR" && DIR="."; \
-	for f in $(SRCFILES) ""; do \
+	for f in $(SRCFILES) $(POTHEAD) ""; do \
 	    test -z "$$f" && break; \
 	    test -L "$$f" || $(ECHO) $$DIR/$$f; \
 	done; \
diff --git a/include/buildrules b/include/buildrules
index f2a3372..62d9a37 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	rm -f $(DIRT)
-	@rm -fr .libs
+	rm -fr $(DIRDIRT)
 %-clean:
 	$(MAKE) -C $* clean
 
@@ -21,6 +21,17 @@ $(SUBDIRS):
 	$(MAKE) -C $@
 endif
 
+source-link: 
+	@test -z "$$DIR" && DIR="."; \
+	for f in `echo $(SRCFILES) $(SUBDIRS)`; do \
+	    if test -d $$f ; then \
+		mkdir $$SRCLINK_ROOT/$$DIR/$$f || exit $$?; \
+		$(MAKEF) DIR=$$DIR/$$f -C $$f $@ || exit $$?; \
+	    else \
+		ln $$f $$SRCLINK_ROOT/$$DIR/$$f || exit $$?; \
+	    fi; \
+	done
+
 #
 # Standard targets
 #
diff --git a/m4/Makefile b/m4/Makefile
index ab0ed48..825ba71 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -5,6 +5,13 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
+CONFIGURE = \
+	libtool.m4 \
+	ltoptions.m4 \
+	ltsugar.m4 \
+	ltversion.m4 \
+	lt~obsolete.m4
+
 LSRCFILES = \
 	manual_format.m4 \
 	package_aiodev.m4 \
@@ -14,10 +21,14 @@ LSRCFILES = \
 	package_types.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
-	multilib.m4
+	multilib.m4 \
+	$(CONFIGURE)
 
 default:
 
 include $(BUILDRULES)
 
 install install-dev install-lib: default
+
+realclean: distclean
+	rm -f $(CONFIGURE)
diff --git a/po/Makefile b/po/Makefile
index ac7d43f..4db7d1e 100644
--- a/po/Makefile
+++ b/po/Makefile
@@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
 
 POTHEAD = $(PKG_NAME).pot
 LINGUAS = pl
-LSRCFILES = $(LINGUAS:%=%.po) $(POTHEAD)
+LSRCFILES = $(LINGUAS:%=%.po)
 LDIRT = $(POTHEAD)
 
 XGETTEXTFILES =	$(LOCALIZED_FILES)

------=_Part_19981_1748027851.1253228929935
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_19981_1748027851.1253228929935--
