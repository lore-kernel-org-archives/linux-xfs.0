Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB4GAGha230994 for <xfs@oss.sgi.com>; Fri, 4 Dec 2009 10:10:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F143BCF3D9
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2009 08:10:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CSzEUQd1kBOEq8lg for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2009 08:10:48 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NGak3-0003y1-N7
	for xfs@oss.sgi.com; Fri, 04 Dec 2009 16:10:47 +0000
Date: Fri, 4 Dec 2009 11:10:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsdump: update configure defaults
Message-ID: <20091204161047.GA13274@infradead.org>
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

Currenly xfsdump has two different sets of defauls for it's installation
layout.  One is in set in the configure.in file and used when running
./configure directly, and the second one is passed by make to ./configure
when configuring through make.

The defaults in the makefile are a lot better, as they install xfsprogs
into the / vs /usr split used by most distributions and enable multi-libs
when detected.

This patch changes the build system to also use the same defaults when
running ./configure.  To do this we get rid of some of the hacky
autoconf abuse we had in the past in xfsprogs and just use the normal
default sbindir and libdir variables for /usr/sbin an /usr/lib respecticly
and define new root_sbindir and root_libdir variables for those few
binaries installed into /.  The installation to / is disabled if the
user chooses a non-default exec prefix.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsdump-dev/Makefile
===================================================================
--- xfsdump-dev.orig/Makefile	2009-11-19 23:54:13.191025966 +0100
+++ xfsdump-dev/Makefile	2009-11-20 00:00:51.375317816 +0100
@@ -52,18 +52,7 @@ configure:
 	autoconf
 
 include/builddefs: configure
-	./configure \
-		--prefix=/ \
-		--exec-prefix=/ \
-		--sbindir=/sbin \
-		--bindir=/usr/sbin \
-		--libdir=/lib \
-		--libexecdir=/usr/lib \
-		--enable-lib64=yes \
-		--includedir=/usr/include \
-		--mandir=/usr/share/man \
-		--datadir=/usr/share \
-		$$LOCAL_CONFIGURE_OPTIONS
+	./configure $$LOCAL_CONFIGURE_OPTIONS
 	touch .census
 
 include/config.h: include/builddefs
Index: xfsdump-dev/configure.in
===================================================================
--- xfsdump-dev.orig/configure.in	2009-11-20 00:00:54.817003939 +0100
+++ xfsdump-dev/configure.in	2009-11-20 00:01:55.363285550 +0100
@@ -17,10 +17,36 @@ AC_ARG_ENABLE(gettext,
 AC_SUBST(enable_gettext)
 
 AC_ARG_ENABLE(lib64,
-[ --enable-lib64=[yes/no] Enable lib64 support [default=no]],,
-	enable_lib64=no)
+[ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
+	enable_lib64=yes)
 AC_SUBST(enable_lib64)
 
+#
+# If the user specified a libdir ending in lib64 do not append another
+# 64 to the library names.
+#
+base_libdir=`basename "$libdir"`
+case $base_libdir in
+lib64)
+  enable_lib64=no
+esac
+
+#
+# Some important tools should be installed into the root partitions.
+#
+# Check whether exec_prefix=/usr: and install them to /sbin in that
+# case.  If the user choses a different prefix assume he just wants
+# a local install for testing and not a system install.
+#
+case $exec_prefix:$prefix in
+NONE:NONE | NONE:/usr | /usr:*)
+  root_sbindir='/sbin'
+  AC_SUBST([root_sbindir])
+
+  root_libdir="/${base_libdir}"
+  AC_SUBST([root_libdir])
+esac
+
 AC_PACKAGE_GLOBALS(xfsdump)
 AC_PACKAGE_UTILITIES(xfsdump)
 AC_MULTILIB($enable_lib64)
Index: xfsdump-dev/dump/Makefile
===================================================================
--- xfsdump-dev.orig/dump/Makefile	2009-11-19 23:56:06.456254116 +0100
+++ xfsdump-dev/dump/Makefile	2009-11-19 23:57:52.678006330 +0100
@@ -95,10 +95,11 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(INSTALL) -S $(PKG_SBIN_DIR)/$(LTCOMMAND) $(PKG_BIN_DIR)/$(LTCOMMAND)
+	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) \
+		      $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
 $(COMMINCL) $(COMMON):
Index: xfsdump-dev/include/builddefs.in
===================================================================
--- xfsdump-dev.orig/include/builddefs.in	2009-11-19 23:58:17.818273979 +0100
+++ xfsdump-dev/include/builddefs.in	2009-11-19 23:59:51.330006179 +0100
@@ -19,11 +19,6 @@ LIBUUID = @libuuid@
 LIBCURSES = @libcurses@
 LIBHANDLE = @libhdl@
 
-prefix = @prefix@
-exec_prefix = @exec_prefix@
-top_builddir = @top_builddir@
-datarootdir = @datarootdir@
-
 PKG_NAME	= @pkg_name@
 PKG_USER	= @pkg_user@
 PKG_GROUP	= @pkg_group@
@@ -31,10 +26,16 @@ PKG_RELEASE	= @pkg_release@
 PKG_VERSION	= @pkg_version@
 PKG_PLATFORM	= @pkg_platform@
 PKG_DISTRIBUTION= @pkg_distribution@
-PKG_BIN_DIR	= @bindir@
+
+prefix		= @prefix@
+exec_prefix	= @exec_prefix@
+datarootdir	= @datarootdir@
+top_builddir	= @top_builddir@
+
 PKG_SBIN_DIR	= @sbindir@
+PKG_ROOT_SBIN_DIR = @root_sbindir@
+PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
 PKG_LIB_DIR	= @libdir@@libdirsuffix@
-PKG_DEVLIB_DIR	= @libexecdir@@libdirsuffix@
 PKG_INC_DIR	= @includedir@
 PKG_MAN_DIR	= @mandir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
Index: xfsdump-dev/include/buildmacros
===================================================================
--- xfsdump-dev.orig/include/buildmacros	2009-11-19 23:59:54.353274308 +0100
+++ xfsdump-dev/include/buildmacros	2009-11-20 00:00:29.154286452 +0100
@@ -48,16 +48,16 @@ LTINSTALL = $(LIBTOOL) --mode=install $(
 LTCOMPILE = $(LIBTOOL) --tag=CC --mode=compile $(CCF)
 
 ifeq ($(ENABLE_SHARED),yes)
-LTLDFLAGS += -rpath $(PKG_LIB_DIR)
+LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)
 LTLDFLAGS += -version-info $(LTVERSION)
 endif
 
 ifeq ($(ENABLE_SHARED),yes)
 INSTALL_LTLIB = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
-	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
-	../$(INSTALL) -m 644 -T so_dot_version $(LIBNAME).lai $(PKG_LIB_DIR); \
-	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_LIB_DIR)
+	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
+	../$(INSTALL) -m 644 -T so_dot_version $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
+	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_ROOT_LIB_DIR)
 endif
 
 # Libtool thinks the static and shared libs should be in the same dir, so
@@ -69,15 +69,15 @@ endif
 ifeq ($(ENABLE_SHARED),yes)
 INSTALL_LTLIB_DEV = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
-	../$(INSTALL) -m 755 -d $(PKG_DEVLIB_DIR); \
-	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_DEVLIB_DIR); \
-	../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_DEVLIB_DIR)/$(LIBNAME).la ; \
 	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
-	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_LIB_DIR); \
-	if test "x$(PKG_DEVLIB_DIR)" != "x$(PKG_LIB_DIR)" ; then \
-	../$(INSTALL) -S $(PKG_DEVLIB_DIR)/$(LIBNAME).a $(PKG_LIB_DIR)/$(LIBNAME).a; \
-	../$(INSTALL) -S $(PKG_DEVLIB_DIR)/$(LIBNAME).la $(PKG_LIB_DIR)/$(LIBNAME).la; \
-	../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).so $(PKG_DEVLIB_DIR)/$(LIBNAME).so; \
+	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_LIB_DIR); \
+	../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_LIB_DIR)/$(LIBNAME).la ; \
+	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
+	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
+	if test "x$(PKG_LIB_DIR)" != "x$(PKG_ROOT_LIB_DIR)" ; then \
+	../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \
+	../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
+	../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
 	fi
 else
 INSTALL_LTLIB_DEV = $(INSTALL_LTLIB_STATIC)
@@ -85,8 +85,8 @@ endif
 
 INSTALL_LTLIB_STATIC = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
-	../$(INSTALL) -m 755 -d $(PKG_DEVLIB_DIR); \
-	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_DEVLIB_DIR)
+	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
+	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_LIB_DIR)
 
 INSTALL_MAN = \
 	@for d in $(MAN_PAGES); do \
Index: xfsdump-dev/invutil/Makefile
===================================================================
--- xfsdump-dev.orig/invutil/Makefile	2009-11-19 23:57:46.371004008 +0100
+++ xfsdump-dev/invutil/Makefile	2009-11-19 23:58:05.543033631 +0100
@@ -62,8 +62,8 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
 $(COMMINCL) $(COMMON):
Index: xfsdump-dev/restore/Makefile
===================================================================
--- xfsdump-dev.orig/restore/Makefile	2009-11-19 23:56:06.470253665 +0100
+++ xfsdump-dev/restore/Makefile	2009-11-19 23:57:58.579033141 +0100
@@ -107,10 +107,11 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(INSTALL) -S $(PKG_SBIN_DIR)/$(LTCOMMAND) $(PKG_BIN_DIR)/$(LTCOMMAND)
+	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) \
+		      $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
 $(COMMINCL) $(COMMON):

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
