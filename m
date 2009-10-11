Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9B2hbZs184669 for <xfs@oss.sgi.com>; Sat, 10 Oct 2009 21:43:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA7FC1D7AB3E
	for <xfs@oss.sgi.com>; Sat, 10 Oct 2009 19:45:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rFNQQnlZgqJwXYDH for
	<xfs@oss.sgi.com>; Sat, 10 Oct 2009 19:45:05 -0700 (PDT)
Date: Sat, 10 Oct 2009 22:45:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: simplify and unify source package generation
Message-ID: <20091011024504.GA16725@infradead.org>
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
To: xfs@oss.sgi.com, nathans@debian.org

Currently the build/ directory can create rpm, debian and source / binary
tar packages.  The RPM generation is not used as all distributions prefer
their own spec files, and the binary tarball not used at all as it's
a not very useful format.  Reimplement the generation of the source
tarballs to use the source-link method used for the debian packages and
get rid of the whole old package generation machinery.  Also fix a small
bug in the link-based source directory creation which was not including
the .pot file for gettext.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/build/rpm/Makefile
===================================================================
--- xfsprogs-dev.orig/build/rpm/Makefile	2009-10-10 22:29:58.874024074 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,62 +0,0 @@
-#
-# Copyright (c) 2000-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-
-TOPDIR = ../..
-TREEROOT = $(shell cd ${TOPDIR}; pwd)
-include $(TOPDIR)/include/builddefs
-
-SPECF = $(PKG_NAME).spec
-LDIRT = *.rpm $(SPECF) rpmmacros rpmfiles* rpm-*.rc
-
-LSRCFILES = macros.template $(SPECF).in rpm-2.rc.template
-
-default install install-dev install-lib:
-
-include $(BUILDRULES)
-
-# Generate a binary rpm file
-dist : default $(SPECF) rpm-$(RPM_VERSION).rc
-	$(RPMBUILD) -ba --rcfile ./rpm-$(RPM_VERSION).rc $(SPECF)
-
-# Because rpm prior to v.2.90 does not support macros and old style config
-# is not supported by rpm v.3, we have to resort to such ugly hacks
-ifneq ($(RPM_VERSION),2)
-rpm-$(RPM_VERSION).rc : rpmmacros
-	@$(SED) -e '/^macrofiles:/s|~/.rpmmacros|rpmmacros|' </usr/lib/rpm/rpmrc >$@
-
-rpmmacros : macros.template
-	@$(SED) -e 's|%topdir%|$(TREEROOT)|g' < $< > $@
-else
-rpm-2.rc: rpm-2.rc.template
-	@$(SED) -e 's|%topdir%|$(TOPDIR)|g' < $< > $@
-endif
-
-# Generate the rpm specfile format file list from the install-sh manifest
-rpmfiles rpmfiles-dev rpmfiles-lib:
-	$(SORT) -u $$DIST_MANIFEST | $(AWK) > $@ '\
-$$1 == "d" { printf ("%%%%dir %%%%attr(%s,%s,%s) %s\n", $$2, $$3, $$4, $$5); } \
-$$1 == "f" { if (match ($$6, "$(PKG_MAN_DIR)") || \
-                match ($$6, "$(PKG_DOC_DIR)")) \
-                printf ("%%%%doc "); \
-            if (match ($$6, "$(PKG_MAN_DIR)")) \
-                printf ("%%%%attr(%s,%s,%s) %s*\n", $$2, $$3, $$4, $$6); \
-            else \
-                printf ("%%%%attr(%s,%s,%s) %s\n", $$2, $$3, $$4, $$6); } \
-$$1 == "l" { if (match ($$3, "$(PKG_MAN_DIR)") || \
-                match ($$3, "$(PKG_DOC_DIR)")) \
-                printf ("%%%%doc "); \
-            if (match ($$3, "$(PKG_MAN_DIR)")) \
-                printf ("%%%%attr(0777,root,root) %s*\n", $$3); \
-            else \
-                printf ("%%%%attr(0777,root,root) %s\n", $$3); }'
-
-.PHONY: $(SPECF)
-${SPECF} : ${SPECF}.in
-	$(SED) -e's|@pkg_name@|$(PKG_NAME)|g' \
-	    -e's|@pkg_version@|$(PKG_VERSION)|g' \
-	    -e's|@pkg_release@|$(PKG_RELEASE)|g' \
-	    -e's|@pkg_distribution@|$(PKG_DISTRIBUTION)|g' \
-	    -e's|@build_root@|$(DIST_ROOT)|g' \
-	    -e'/^BuildRoot: *$$/d' \
-	    -e's|@make@|$(MAKE)|g' < $< > $@
Index: xfsprogs-dev/build/rpm/macros.template
===================================================================
--- xfsprogs-dev.orig/build/rpm/macros.template	2009-10-10 22:29:58.880016667 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,30 +0,0 @@
-#
-# rpmrc.template
-#
-# Template to fudge rpm directory structure inside IRIX-like build
-# environment
-
-# Force 386 build on all platforms
-%_target i386-pc-linux
-%_target_cpu i386
-%_target_os linux
-
-# topdir == $(WORKAREA)
-%_topdir %topdir%
-
-# Following directories are specific to the topdir
-# This is where build is done. In our case it's the same as $WORKAREA
-%_builddir %topdir%
-
-# This is where foo.1.99.tar.gz is living in the real world.
-# Be careful not to run full rpm build as it will override the sources 
-%_sourcedir %topdir%/build
-
-# This is where binary RPM and source RPM would end up
-%_rpmdir    %topdir%/build/rpm
-%_srcrpmdir %topdir%/build/rpm
-%_specdir   %topdir%/build/rpm
-
-# Leave RPM files in the same directory - we're not building for 
-# multiple architectures
-%_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm
Index: xfsprogs-dev/build/rpm/rpm-2.rc.template
===================================================================
--- xfsprogs-dev.orig/build/rpm/rpm-2.rc.template	2009-10-10 22:29:58.900004409 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,25 +0,0 @@
-#
-# rpmrc.template
-#
-# Template to fudge rpm directory structure inside IRIX-like build
-# environment
-
-# topdir == $(WORKAREA)
-topdir: %topdir%
-
-# Following directories are specific to the topdir
-# This is where build is done. In out case it's the same as $WORKAREA
-# Be careful not to run full rpm build as it will override the sources 
-builddir: %topdir%
-
-# This is where foo.1.99.tar.gz is living in the real world.
-sourcedir: %topdir%/build
-
-# This is where binary RPM and source RPM would end up
-rpmdir:    %topdir%/build/rpm
-srcrpmdir:  %topdir%/build/rpm
-specdir:   %topdir%/build/rpm
-
-# Leave RPM files in the same directory - we're not building for 
-# multiple architectures
-rpmfilename: %{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}.rpm
Index: xfsprogs-dev/build/rpm/xfsprogs.spec.in
===================================================================
--- xfsprogs-dev.orig/build/rpm/xfsprogs.spec.in	2009-10-10 22:29:58.909024832 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,78 +0,0 @@
-Summary: Utilities for managing the XFS filesystem.
-Name: @pkg_name@
-Version: @pkg_version@
-Release: @pkg_release@
-Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
-BuildRoot: @build_root@ 
-Prereq: /sbin/ldconfig
-Conflicts: xfsdump < 3.0.0
-Source: %name-%version.tar.gz
-License: GPL
-Vendor: Silicon Graphics, Inc.
-URL: http://oss.sgi.com/projects/xfs/
-Group: System Environment/Base
-
-%description
-A set of commands to use the XFS filesystem, including mkfs.xfs.
-
-XFS is a high performance journaling filesystem which originated
-on the SGI IRIX platform.  It is completely multi-threaded, can
-support large files and large filesystems, extended attributes,
-variable block sizes, is extent based, and makes extensive use of
-Btrees (directories, extents, free space) to aid both performance
-and scalability.
-
-Refer to the documentation at http://oss.sgi.com/projects/xfs/
-for complete details.  This implementation is on-disk compatible
-with the IRIX version of XFS.
-
-%package devel
-Summary: XFS filesystem-specific static libraries and headers.
-Group: Development/Libraries
-Requires: %name >= 3.0.0
-Conflicts: %name < 3.0.0
-
-%description devel
-xfsprogs-devel contains the libraries and header files needed to
-develop XFS filesystem-specific programs.
-
-You should install xfsprogs-devel if you want to develop XFS
-filesystem-specific programs,  If you install xfsprogs-devel, you'll
-also want to install xfsprogs.
-
-%prep
-if [ -f .census ] ; then
-   if [ ! -d ${RPM_PACKAGE_NAME}-${RPM_PACKAGE_VERSION} ] ; then
-      ln -s . ${RPM_PACKAGE_NAME}-${RPM_PACKAGE_VERSION}
-   fi
-else
-%setup
-INSTALL_USER=root
-INSTALL_GROUP=root
-export INSTALL_USER INSTALL_GROUP
-@make@ configure
-fi
-
-%build
-@make@
-
-%install
-DIST_ROOT="$RPM_BUILD_ROOT"
-DIST_INSTALL=`pwd`/install.manifest
-DIST_INSTALL_DEV=`pwd`/install-dev.manifest
-export DIST_ROOT DIST_INSTALL DIST_INSTALL_DEV
-@make@ install DIST_MANIFEST="$DIST_INSTALL"
-@make@ -C build/rpm rpmfiles DIST_MANIFEST="$DIST_INSTALL"
-@make@ install-dev DIST_MANIFEST="$DIST_INSTALL_DEV"
-@make@ -C build/rpm rpmfiles-dev DIST_MANIFEST="$DIST_INSTALL_DEV"
-
-%clean
-rm -rf $RPM_BUILD_ROOT
-
-%post -p /sbin/ldconfig
-
-%postun -p /sbin/ldconfig
-
-%files -f build/rpm/rpmfiles
-
-%files devel -f build/rpm/rpmfiles-dev
Index: xfsprogs-dev/build/Makefile
===================================================================
--- xfsprogs-dev.orig/build/Makefile	2009-10-10 22:29:58.914028612 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,50 +0,0 @@
-#
-# Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
-#
-
-TOPDIR = ..
-include $(TOPDIR)/include/builddefs
-
-MANIFEST=src-manifest
-SRCTAR=$(PKG_NAME)-$(PKG_VERSION).tar.gz
-
-LDIRT = *-manifest *.gz $(TOPDIR)/$(PKG_NAME)-*
-LDIRDIRT = deb
-
-# for clean and clobber
-SUBDIRS = tar rpm
-
-# nothing to build here (it's all packaging)
-default install install-dev install-lib:
-
-include $(BUILDRULES)
-
-# Symlink in the TOPDIR is used to pack files relative to
-# product-version directory.
-$(MANIFEST) : $(_FORCE)
-	@if [ ! -L $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION) ] ; then \
-	    $(LN_S) . $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION) ; \
-	fi
-	@CDIR=`pwd`; cd $(TOPDIR); \
-	$(MAKE) --no-print-directory source | \
-	    sed -e 's/^\./$(PKG_NAME)-$(PKG_VERSION)/' > $$CDIR/$@ ;\
-	if [ $$? -ne 0 ] ; then  \
-	    exit 1; \
-	else \
-	    unset TAPE; \
-	    $(TAR) -T $$CDIR/$@ -cf - | $(ZIP) --best > $$CDIR/$(SRCTAR); \
-	    echo Wrote: $$CDIR/$(SRCTAR); \
-	fi
-
-dist : default $(MANIFEST)
-	@DIST_MANIFEST=`pwd`/bin-manifest; DIST_ROOT=/tmp/$$$$; \
-	export DIST_MANIFEST DIST_ROOT; \
-	rm -f $$DIST_MANIFEST; \
-	echo === install === && $(MAKE) -C $(TOPDIR) install || exit $$?; \
-	if [ -x $(TAR) ]; then \
-	    ( echo "=== tar ===" && $(MAKEF) -C tar $@ || exit $$? ); \
-	fi; \
-	if [ -x $(RPMBUILD) ]; then \
-	    ( echo "=== rpm ===" && $(MAKEF) -C rpm $@ || exit $$? ); \
-	fi; \
-	test -z "$$KEEP_DIST_ROOT" || rm -rf $$DIST_ROOT; echo Done
Index: xfsprogs-dev/build/tar/Makefile
===================================================================
--- xfsprogs-dev.orig/build/tar/Makefile	2009-10-10 22:29:58.925022610 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,22 +0,0 @@
-#
-# Copyright (c) 2000-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-
-TOPDIR = ../..
-include $(TOPDIR)/include/builddefs
-
-BINTAR=$(PKG_NAME)-$(PKG_VERSION).bin.tar.gz
-LDIRT = *.gz
-
-default install install-dev install-lib:
-
-include $(BUILDRULES)
-
-dist : default
-	@HERE=`pwd`; cd $${DIST_ROOT:-/}; \
-	$(SORT) -u $$HERE/../bin-manifest | $(AWK) ' \
-		$$1 == "f" { printf (".%s\n", $$6); } \
-		$$1 == "d" { next; } \
-		$$1 == "l" { printf (".%s\n", $$3); }' \
-	| $(TAR) -T - -cf - | $(ZIP) --best > $$HERE/$(BINTAR)
-	@echo Wrote: `pwd`/$(BINTAR)
Index: xfsprogs-dev/Makefile
===================================================================
--- xfsprogs-dev.orig/Makefile	2009-10-10 22:29:58.930010187 -0400
+++ xfsprogs-dev/Makefile	2009-10-10 22:31:31.094273473 -0400
@@ -9,16 +9,24 @@ ifeq ($(HAVE_BUILDDEFS), yes)
 include $(TOPDIR)/include/builddefs
 endif
 
+SRCDIR = $(PKG_NAME)-$(PKG_VERSION)
+SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
+
 CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
-LSRCFILES = configure.in Makepkgs release.sh README VERSION $(CONFIGURE)
+LSRCFILES = configure.in release.sh README VERSION $(CONFIGURE)
 
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
-	Logs/* built .census install.* install-dev.* *.gz autom4te.cache/* \
-	libtool include/builddefs include/platform_defs.h
+	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
+	include/builddefs include/platform_defs.h
+
+ifeq ($(HAVE_BUILDDEFS), yes)
+LDIRDIRT = $(SRCDIR)
+LDIRT += $(SRCTAR)
+endif
 
 LIB_SUBDIRS = libxfs libxlog libxcmd libhandle $(LDISK)
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc po debian build
+		mdrestore repair rtcp m4 man doc po debian
 
 ifneq ($(ENABLE_BLKID), yes)
 LIB_SUBDIRS += libdisk
@@ -67,7 +75,6 @@ configure:
 
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS
-	touch .census
 
 include/platform_defs.h: include/builddefs
 ## Recover from the removal of $@
@@ -98,3 +105,32 @@ distclean: clean
 
 realclean: distclean
 	rm -f $(CONFIGURE)
+
+#
+# All this gunk is to allow for a make dist on an unconfigured tree
+#
+dist: include/builddefs include/platform_defs.h default
+ifeq ($(HAVE_BUILDDEFS), no)
+	$(MAKE) -C . $@
+else
+	$(MAKE) $(SRCTAR)
+endif
+
+deb: include/builddefs include/platform_defs.h
+ifeq ($(HAVE_BUILDDEFS), no)
+	$(MAKE) -C . $@
+else
+	$(MAKE) $(SRCDIR)
+	$(MAKE) -C po
+	$(MAKE) source-link
+	cd $(SRCDIR) && dpkg-buildpackage
+endif
+
+$(SRCDIR) : $(_FORCE)
+	rm -fr $@
+	mkdir -p $@
+
+$(SRCTAR) : default $(SRCDIR)
+	$(MAKE) source-link
+	unset TAPE; $(TAR) -cf - $(SRCDIR) | $(ZIP) --best > $@ && \
+	echo Wrote: $@
Index: xfsprogs-dev/release.sh
===================================================================
--- xfsprogs-dev.orig/release.sh	2009-10-10 22:29:58.935004049 -0400
+++ xfsprogs-dev/release.sh	2009-10-10 22:31:31.095273530 -0400
@@ -18,8 +18,8 @@ git-commit -a -m "${version} release"
 echo "Tagging git repository"
 git-tag v${version}
 
-echo "Creating source tarball in build/tar/"
-./Makepkgs
+echo "Creating source tarball"
+make dist
 
 echo "Done."
 echo "Please remember to push out tags using \"git push --tags\""
Index: xfsprogs-dev/Makepkgs
===================================================================
--- xfsprogs-dev.orig/Makepkgs	2009-10-10 22:29:58.939028096 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,109 +0,0 @@
-#! /bin/sh
-#
-#	Make whichever packages have been requested.
-#	Defaults to RPMs.
-#
-LOGDIR=Logs
-
-#
-# If we're on a Debian or Debian-derived system generate deb packages by
-# default, else rpm packages.
-#
-if [ -f /etc/debian_version ] ; then
-    type=debian
-else
-    type=rpm
-fi
-verbose=false
-
-MAKE=${MAKE:-make}
-test ! -z "$MAKE" && make=$MAKE
-
-for opt in $*
-do
-	case "$opt" in
-	clean)
-		;; # ignored, kept for backward compatibility
-	rpm)
-		type=rpm ;;
-	debian)
-		type=debian ;;
-	verbose)
-		verbose=true ;;
-	*)
-		echo "Usage: Makepkgs [verbose] [debian|rpm]"; exit 1 ;;
-	esac
-done
-
-# start with a clean manifest
-test -f files.rpm && rm -f files.rpm
-test -f filesdevel.rpm && rm -f filesdevel.rpm
-test -f fileslib.rpm && rm -f fileslib.rpm
-
-test ! -d $LOGDIR && mkdir $LOGDIR
-rm -rf $LOGDIR/* > /dev/null 2>&1
-
-if [ $type = debian ] ; then
-	SOURCE=`pwd`
-	PACKAGE=`basename $SOURCE`
-	LOGDEB=$SOURCE/$LOGDIR/$PACKAGE.log
-	if $verbose ; then
-		$MAKE include/builddefs 2>&1 | tee $LOGDIR/configure
-	else
-		$MAKE include/builddefs > $LOGDIR/configure 2>&1  || exit 1
-	fi
-
-	. ./VERSION
-	VERSION=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
-	export SRCLINK_ROOT="$SOURCE/build/deb/$PACKAGE-$VERSION"
-	rm -fr "$SRCLINK_ROOT"
-	mkdir -p "$SRCLINK_ROOT" || exit 1
-
-	$MAKE source-link || exit 1
-
-	cd "$SRCLINK_ROOT"
-	SUDO=${SUDO:-fakeroot}
-	test ! -z "$SUDO" && sudo=$SUDO
-	if $verbose ; then
-		dpkg-buildpackage -r$SUDO | tee $LOGDEB
-	else
-		dpkg-buildpackage -r$SUDO > $LOGDEB || exit 1
-	fi
-	exit 0
-fi
-
-echo "== clean, log is $LOGDIR/clean"
-if $verbose ; then
-	$MAKE clean 2>&1 | tee $LOGDIR/clean
-else
-	$MAKE clean > $LOGDIR/clean 2>&1  || exit 1
-fi
-
-echo
-echo "== configure, log is $LOGDIR/configure"
-rm -f .census	# force configure to run here
-if $verbose ; then
-	$MAKE configure 2>&1 | tee $LOGDIR/configure
-else
-	$MAKE configure > $LOGDIR/configure 2>&1 || exit 1
-fi
-
-echo
-echo "== default, log is $LOGDIR/default"
-if $verbose ; then
-	$MAKE default 2>&1 | tee $LOGDIR/default
-else
-	$MAKE default > $LOGDIR/default 2>&1 || exit 1
-fi
-
-echo
-echo "== dist, log is $LOGDIR/dist"
-[ ! -f .census ] && touch .census
-if $verbose ; then
-	$MAKE -C build dist 2>&1 | tee $LOGDIR/dist
-else
-	$MAKE -C build dist > $LOGDIR/dist 2>&1 || exit 1
-	grep '^Wrote:' $LOGDIR/dist | sed -e 's/\.\.\/\.\.\///'
-fi
-
-exit 0
Index: xfsprogs-dev/.gitignore
===================================================================
--- xfsprogs-dev.orig/.gitignore	2009-10-10 22:29:58.952023676 -0400
+++ xfsprogs-dev/.gitignore	2009-10-10 22:31:31.099274179 -0400
@@ -3,7 +3,6 @@
 
 # build system
 .census
-Logs/
 include/platform_defs.h
 include/builddefs
 install-sh
Index: xfsprogs-dev/debian/rules
===================================================================
--- xfsprogs-dev.orig/debian/rules	2009-10-10 22:29:58.962003579 -0400
+++ xfsprogs-dev/debian/rules	2009-10-10 22:31:31.099274179 -0400
@@ -67,7 +67,7 @@ binary-arch: checkroot built
 	$(pkgme)  $(MAKE) -C . install
 	$(pkgdev) $(MAKE) -C . install-dev
 	$(pkgdi)  $(MAKE) -C debian install-d-i
-	$(pkgme)  $(MAKE) -C build src-manifest
+	$(pkgme)  $(MAKE) dist
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
 	dh_installdocs
 	dh_installchangelogs
Index: xfsprogs-dev/README
===================================================================
--- xfsprogs-dev.orig/README	2009-10-10 22:29:58.967028520 -0400
+++ xfsprogs-dev/README	2009-10-10 22:31:31.102026207 -0400
@@ -10,6 +10,3 @@ and references to other XFS manual pages
 For more information and details on how to contribute to the
 XFS project see the web pages at:
 	http://oss.sgi.com/projects/xfs/
-
-For more information on the build process, please refer to
-the doc/PORTING document.
Index: xfsprogs-dev/doc/INSTALL
===================================================================
--- xfsprogs-dev.orig/doc/INSTALL	2009-10-10 22:29:58.973023698 -0400
+++ xfsprogs-dev/doc/INSTALL	2009-10-10 22:31:31.105012411 -0400
@@ -28,16 +28,7 @@ Linux Instructions
    (on an RPM based system) or the uuid-dev package (on a Debian system)
    as some of the commands make use of the UUID library provided by these.
 
-   If you just want to spin an RPM and/or tar file, use the Makepkgs
-   script in the top level directory. This will configure and build
-   the package and leave binary and src RPMs in the build/rpm
-   directory.  It will also leave a tar file in the build/tar
-   directory.
-
-	# ./Makepkgs verbose
-
-   If you want to build the package and install it manually, use the
-   following steps:
+   To build the package and install it manually, use the following steps:
 
 	# make
 	# su root
Index: xfsprogs-dev/doc/Makefile
===================================================================
--- xfsprogs-dev.orig/doc/Makefile	2009-10-10 22:29:58.984028102 -0400
+++ xfsprogs-dev/doc/Makefile	2009-10-10 22:31:31.108025714 -0400
@@ -5,7 +5,7 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-LSRCFILES = INSTALL PORTING CHANGES COPYING CREDITS sparse.txt
+LSRCFILES = INSTALL CHANGES COPYING CREDITS sparse.txt
 LDIRT = *.gz
 
 default: CHANGES.gz
@@ -17,7 +17,7 @@ CHANGES.gz:
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
-	$(INSTALL) -m 644 PORTING CHANGES.gz CREDITS $(PKG_DOC_DIR)
+	$(INSTALL) -m 644 CHANGES.gz CREDITS $(PKG_DOC_DIR)
 ifeq ($(PKG_DISTRIBUTION), debian)
 	$(INSTALL) -S CHANGES.gz $(PKG_DOC_DIR)/changelog.gz
 else
Index: xfsprogs-dev/doc/PORTING
===================================================================
--- xfsprogs-dev.orig/doc/PORTING	2009-10-10 22:29:58.989004085 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,86 +0,0 @@
-
-1. unpack the source tarball and cd to the resulting dir
-
-2. # autoconf  
-   this reads configure.in and generates the ./configure script
-
-3. # ./configure 
-   this probes your system and then, for each "file" named
-   in the AC_OUTPUT() macro near the end of configure.in,
-   read "file".in and generate "file". Variables named @somevariable@
-   will be substituted with literal values.
-
-4. step (3) produces several files. These files are generated by
-   configure from their respective .in file in the same directory.
-   You should have a read of these generated files and diff them
-   against their respective .in files to see what was substituted
-   by configure.
-
-   src/include/builddefs
-   	common definitions for the build environment. This is included
-	by all Makefiles, in conjunction with src/include/buildrules.
-	Note that most autoconf/configure build environments generate
-	Makefile (from Makefile.in) in every src dir. Instead, we
-	generate builddefs, and then include it in every Makefile.
-
-   src/include/platform_defs.h 
-   	header containing conditional macros defining the C run-time
-	environment discovered by the configure script.
-
-5. read some or all of the GNU tool chain documentation
-   GNU make :
-       http://www.delorie.com/gnu/docs/make/make_toc.html
-   autoconf :
-    	http://www.delorie.com/gnu/docs/autoconf/autoconf_toc.html
-   libtool :
-    	http://www.delorie.com/gnu/docs/libtool/libtool_toc.html
-   gcc/g++ :
-    	http://www.delorie.com/gnu/docs/gcc/gcc_toc.html
-
-6. Makefiles and build environment
-   First have a look at some Makefiles
-
-   	example using SUBDIRS :  xfsprogs/Makefile
-        example static library:  xfsprogs/libxfs/Makefile
-        example command       :  xfsprogs/bmap/Makefile
-
-   All Makefiles must define TOPDIR as the root of the project. This
-   allows other stuff to be found relative to $(TOPDIR).
-
-   All Makefiles should have the following structure, which is
-   much like commondefs and commonrules in the IRIX build environment, e.g.
-
-   # ----------------------------------------------------------------------
-   # TOPDIR must point to the root of the project
-   # The builddefs file defines lots of things. Read it.
-   TOPDIR = ..
-   include $(TOPDIR)/include/builddefs
-
-   # first rule should always be "default"
-   default : sometarget
-   	commands to build targets, if necessary
-
-   # $(BUILDRULES) is defined in builddefs and includes rules for
-   # descending subdirs, building targets and installation rules
-   include $(BUILDRULES)
-
-   install : default
-   	$(INSTALL) sometargets somewhere
-   # ----------------------------------------------------------------------
-
-7. packaging
-
-   # ./Makepkgs
-   this script generates all of the packages supported - each has a
-   subdirectory below xfsprogs/build where knowledge specific to
-   each package type is maintained.
-
-   The script produces logs of each stage of the build (this info is
-   also echoed to the screen when the "verbose" option is provided):
-
-	xfsprogs/Logs/configure	- `autoconf; ./configure' output
-	xfsprogs/Logs/default	- `make default' output
-	xfsprogs/Logs/dist	- `make build dist' output
-
-   On successful completion, the script echoes the names of packages
-   successfully generated.
Index: xfsprogs-dev/include/buildmacros
===================================================================
--- xfsprogs-dev.orig/include/buildmacros	2009-10-10 22:29:58.995003942 -0400
+++ xfsprogs-dev/include/buildmacros	2009-10-10 22:31:31.112006249 -0400
@@ -134,19 +134,3 @@ MAN_MAKERULE = \
 			$(ZIP) --best -c < $$f > $$f.gz; \
 		fi; \
 	done
-
-DIST_MAKERULE = \
-	$(MAKEF) -C build dist
-
-SOURCE_MAKERULE = \
-	@test -z "$$DIR" && DIR="."; \
-	for f in $(SRCFILES) $(POTHEAD) ""; do \
-	    test -z "$$f" && break; \
-	    test -L "$$f" || $(ECHO) $$DIR/$$f; \
-	done; \
-	for d in `echo $(SUBDIRS)` ""; do \
-	    test -z "$$d" && break; \
-	    if test -d "$$d"; then \
-		$(MAKEF) DIR=$$DIR/$$d -C $$d $@ || exit $$?; \
-	    fi; \
-	done
Index: xfsprogs-dev/include/buildrules
===================================================================
--- xfsprogs-dev.orig/include/buildrules	2009-10-10 22:29:59.001004148 -0400
+++ xfsprogs-dev/include/buildrules	2009-10-10 22:31:31.113005957 -0400
@@ -23,12 +23,12 @@ endif
 
 source-link: 
 	@test -z "$$DIR" && DIR="."; \
-	for f in `echo $(SRCFILES) $(SUBDIRS)`; do \
+	for f in `echo $(SRCFILES) $(SUBDIRS) $(POTHEAD)`; do \
 	    if test -d $$f ; then \
-		mkdir $$SRCLINK_ROOT/$$DIR/$$f || exit $$?; \
+		mkdir $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION)/$$DIR/$$f || exit $$?; \
 		$(MAKEF) DIR=$$DIR/$$f -C $$f $@ || exit $$?; \
 	    else \
-		ln $$f $$SRCLINK_ROOT/$$DIR/$$f || exit $$?; \
+		ln $$f $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION)/$$DIR/$$f || exit $$?; \
 	    fi; \
 	done
 
@@ -73,9 +73,6 @@ update-po: $(POTHEAD) $(wildcard $(TOPDI
 	$(MSGFMT) -c --statistics -o $@ $<
 endif
 
-source :
-	$(SOURCE_MAKERULE)
-
 endif # _BUILDRULES_INCLUDED_
 
 $(_FORCE):

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
