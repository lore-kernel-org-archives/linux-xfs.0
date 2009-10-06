Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96FDXP9073378 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 10:13:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D9141324E4C
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 08:14:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BENC5AKLqieOxNMR for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 08:14:59 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MvBkg-0000gA-L4
	for xfs@oss.sgi.com; Tue, 06 Oct 2009 15:14:58 +0000
Date: Tue, 6 Oct 2009 11:14:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: update configure defaults
Message-ID: <20091006151458.GA2560@infradead.org>
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


Currenly xfsprogs has two different sets for configurating it, those
in the configure.in template, and those passed to configure by the
toplevel Makefile when just running make.

Those in the makefile make a lot more sense as they install xfsprogs
into the / vs /usr split used by most distributions, and enable multi-libs
when detected.

This patch changes the build system to also use the same defaults when
running ./configure.  To do this we get rid of some of the hacky
autoconf abuse we had in the past in xfsprogs and just use the normal
default sbindir and libdir variables for /usr/sbin an /usr/lib respecticly
and define new root_sbindir and root_libdir variables for those few
binaries installed into /.  The installation to / is disabled if the
user chooses a non-default exex prefix.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/configure.in
===================================================================
--- xfsprogs-dev.orig/configure.in	2009-10-06 11:13:33.125253958 -0300
+++ xfsprogs-dev/configure.in	2009-10-06 11:30:00.584019764 -0300
@@ -36,10 +36,26 @@ AC_ARG_ENABLE(termcap,
 AC_SUBST(libtermcap)
 
 AC_ARG_ENABLE(lib64,
-[ --enable-lib64=[yes/no] Enable lib64 support [default=no]],,
-	enable_lib64=no)
+[ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
+	enable_lib64=yes)
 AC_SUBST(enable_lib64)
 
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
+  root_libdir='/lib'
+  AC_SUBST([root_libdir])
+esac
+
 # Find localized files
 LOCALIZED_FILES=""
 for lfile in `find ${srcdir} -name '*.c' -type f || exit 1`; do
Index: xfsprogs-dev/debian/Makefile
===================================================================
--- xfsprogs-dev.orig/debian/Makefile	2009-10-06 11:10:21.868004369 -0300
+++ xfsprogs-dev/debian/Makefile	2009-10-06 11:18:59.844256510 -0300
@@ -29,6 +29,6 @@ endif
 
 install-d-i: default
 ifeq ($(PKG_DISTRIBUTION), debian)
-	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(INSTALL) -m 755 $(BOOT_MKFS_BIN) $(PKG_SBIN_DIR)/mkfs.xfs
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(INSTALL) -m 755 $(BOOT_MKFS_BIN) $(PKG_ROOT_SBIN_DIR)/mkfs.xfs
 endif
Index: xfsprogs-dev/fsck/Makefile
===================================================================
--- xfsprogs-dev.orig/fsck/Makefile	2009-10-06 11:10:06.796004144 -0300
+++ xfsprogs-dev/fsck/Makefile	2009-10-06 11:10:18.407035758 -0300
@@ -12,6 +12,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(INSTALL) -m 755 xfs_fsck.sh $(PKG_SBIN_DIR)/fsck.xfs
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(INSTALL) -m 755 xfs_fsck.sh $(PKG_ROOT_SBIN_DIR)/fsck.xfs
 install-dev:
Index: xfsprogs-dev/include/builddefs.in
===================================================================
--- xfsprogs-dev.orig/include/builddefs.in	2009-10-06 11:10:40.430253897 -0300
+++ xfsprogs-dev/include/builddefs.in	2009-10-06 11:25:53.891032787 -0300
@@ -37,13 +37,6 @@ LIBXLOG = $(TOPDIR)/libxlog/libxlog.la
 LIBDISK = $(TOPDIR)/libdisk/libdisk.la
 LIBHANDLE = $(TOPDIR)/libhandle/libhandle.la
 
-DK_INC_DIR = @includedir@/disk
-
-prefix = @prefix@
-exec_prefix = @exec_prefix@
-top_builddir = @top_builddir@
-datarootdir = @datarootdir@
-
 PKG_NAME	= @pkg_name@
 PKG_USER	= @pkg_user@
 PKG_GROUP	= @pkg_group@
@@ -51,11 +44,18 @@ PKG_RELEASE	= @pkg_release@
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
 PKG_INC_DIR	= @includedir@/xfs
+DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
Index: xfsprogs-dev/include/buildmacros
===================================================================
--- xfsprogs-dev.orig/include/buildmacros	2009-10-06 11:11:09.263261965 -0300
+++ xfsprogs-dev/include/buildmacros	2009-10-06 11:18:25.261006281 -0300
@@ -51,16 +51,16 @@ LTINSTALL = $(LIBTOOL) --mode=install $(
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
@@ -72,15 +72,15 @@ endif
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
@@ -88,8 +88,8 @@ endif
 
 INSTALL_LTLIB_STATIC = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
-	../$(INSTALL) -m 755 -d $(PKG_DEVLIB_DIR); \
-	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_DEVLIB_DIR)
+	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
+	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_LIB_DIR)
 
 INSTALL_MAN = \
 	@for d in $(MAN_PAGES); do \
Index: xfsprogs-dev/mkfs/Makefile
===================================================================
--- xfsprogs-dev.orig/mkfs/Makefile	2009-10-06 11:09:48.814275021 -0300
+++ xfsprogs-dev/mkfs/Makefile	2009-10-06 11:09:58.301006150 -0300
@@ -26,6 +26,6 @@ $(FSTYP):
 	$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $(PLDLIBS)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/repair/Makefile
===================================================================
--- xfsprogs-dev.orig/repair/Makefile	2009-10-06 11:09:35.796022404 -0300
+++ xfsprogs-dev/repair/Makefile	2009-10-06 11:09:44.599256296 -0300
@@ -47,6 +47,6 @@ include $(BUILDRULES)
 #CFLAGS += ...
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/copy/Makefile
===================================================================
--- xfsprogs-dev.orig/copy/Makefile	2009-10-06 11:18:41.963277125 -0300
+++ xfsprogs-dev/copy/Makefile	2009-10-06 11:19:50.867035885 -0300
@@ -18,6 +18,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/db/Makefile
===================================================================
--- xfsprogs-dev.orig/db/Makefile	2009-10-06 11:18:41.975279071 -0300
+++ xfsprogs-dev/db/Makefile	2009-10-06 11:18:57.142259890 -0300
@@ -35,10 +35,10 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
-	$(INSTALL) -m 755 xfs_admin.sh $(PKG_BIN_DIR)/xfs_admin
-	$(INSTALL) -m 755 xfs_check.sh $(PKG_BIN_DIR)/xfs_check
-	$(INSTALL) -m 755 xfs_ncheck.sh $(PKG_BIN_DIR)/xfs_ncheck
-	$(INSTALL) -m 755 xfs_metadump.sh $(PKG_BIN_DIR)/xfs_metadump
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 xfs_admin.sh $(PKG_SBIN_DIR)/xfs_admin
+	$(INSTALL) -m 755 xfs_check.sh $(PKG_SBIN_DIR)/xfs_check
+	$(INSTALL) -m 755 xfs_ncheck.sh $(PKG_SBIN_DIR)/xfs_ncheck
+	$(INSTALL) -m 755 xfs_metadump.sh $(PKG_SBIN_DIR)/xfs_metadump
 install-dev:
Index: xfsprogs-dev/estimate/Makefile
===================================================================
--- xfsprogs-dev.orig/estimate/Makefile	2009-10-06 11:18:42.004254198 -0300
+++ xfsprogs-dev/estimate/Makefile	2009-10-06 11:19:05.620271216 -0300
@@ -13,6 +13,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/fsr/Makefile
===================================================================
--- xfsprogs-dev.orig/fsr/Makefile	2009-10-06 11:18:42.013254645 -0300
+++ xfsprogs-dev/fsr/Makefile	2009-10-06 11:19:10.676256037 -0300
@@ -14,6 +14,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/growfs/Makefile
===================================================================
--- xfsprogs-dev.orig/growfs/Makefile	2009-10-06 11:18:42.022254115 -0300
+++ xfsprogs-dev/growfs/Makefile	2009-10-06 11:19:13.116283780 -0300
@@ -27,7 +27,7 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
-	$(INSTALL) -m 755 xfs_info.sh $(PKG_BIN_DIR)/xfs_info
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 xfs_info.sh $(PKG_SBIN_DIR)/xfs_info
 install-dev:
Index: xfsprogs-dev/io/Makefile
===================================================================
--- xfsprogs-dev.orig/io/Makefile	2009-10-06 11:18:42.064278528 -0300
+++ xfsprogs-dev/io/Makefile	2009-10-06 11:19:18.300256635 -0300
@@ -68,9 +68,9 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 xfs_bmap.sh $(PKG_BIN_DIR)/xfs_bmap
-	$(LTINSTALL) -m 755 xfs_freeze.sh $(PKG_BIN_DIR)/xfs_freeze
-	$(LTINSTALL) -m 755 xfs_mkfile.sh $(PKG_BIN_DIR)/xfs_mkfile
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 xfs_bmap.sh $(PKG_SBIN_DIR)/xfs_bmap
+	$(LTINSTALL) -m 755 xfs_freeze.sh $(PKG_SBIN_DIR)/xfs_freeze
+	$(LTINSTALL) -m 755 xfs_mkfile.sh $(PKG_SBIN_DIR)/xfs_mkfile
 install-dev:
Index: xfsprogs-dev/logprint/Makefile
===================================================================
--- xfsprogs-dev.orig/logprint/Makefile	2009-10-06 11:18:42.137253739 -0300
+++ xfsprogs-dev/logprint/Makefile	2009-10-06 11:19:28.176016011 -0300
@@ -21,6 +21,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/mdrestore/Makefile
===================================================================
--- xfsprogs-dev.orig/mdrestore/Makefile	2009-10-06 11:18:42.180023289 -0300
+++ xfsprogs-dev/mdrestore/Makefile	2009-10-06 11:19:34.450255427 -0300
@@ -17,6 +17,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install:
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/quota/Makefile
===================================================================
--- xfsprogs-dev.orig/quota/Makefile	2009-10-06 11:18:42.207004098 -0300
+++ xfsprogs-dev/quota/Makefile	2009-10-06 11:19:41.557287423 -0300
@@ -33,6 +33,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/rtcp/Makefile
===================================================================
--- xfsprogs-dev.orig/rtcp/Makefile	2009-10-06 11:18:42.222027729 -0300
+++ xfsprogs-dev/rtcp/Makefile	2009-10-06 11:19:45.904034779 -0300
@@ -14,6 +14,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
Index: xfsprogs-dev/Makefile
===================================================================
--- xfsprogs-dev.orig/Makefile	2009-10-06 11:22:23.406003743 -0300
+++ xfsprogs-dev/Makefile	2009-10-06 11:28:55.138031519 -0300
@@ -58,18 +58,7 @@ configure:
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
 
 include/platform_defs.h: include/builddefs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
