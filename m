Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DC9N0s151348 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 06:09:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 342DC161B4E
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 04:10:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	K2xaW2mahLCIbyK8 for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 04:10:17 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11503875-1927428
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 22:39:58 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NV22a-0006Vw-Do
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 23:09:36 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NV1yX-0003zd-BE
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 23:05:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: Clean up build output
Date: Wed, 13 Jan 2010 23:05:25 +1100
Message-Id: <1263384325-15300-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We don't need to see every compiler command line for every file that
is compiled. This makes it hard to see warnings and errors during
compile. For progress notification, we really only need to see the
directory/file being operated on.

Turn down the verbosity of output by suppressing various make output
and provide better overall visibility of which directory is being
operated on, what the operation is and what is being done to the
files by the build/clean process.

While doing this, remove explicit target-per-file rules in the
subdirectories being built and replace them with target based rules
using the buildrules hooks for doing this.  This results in the
makefiles being simpler, smaller and more consistent.

This patch does not address the dmapi subdirectory of the xfstests
build system.

The old style verbose builds can still be run via "make V=1 ..."

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 Makefile                     |   28 ++++++++++--
 include/buildmacros          |   10 ++--
 include/buildrules           |   24 +++++++---
 ltp/Makefile                 |   31 +++----------
 src/Makefile                 |  101 +++++++-----------------------------------
 src/aio-dio-regress/Makefile |    7 ++-
 6 files changed, 74 insertions(+), 127 deletions(-)

diff --git a/Makefile b/Makefile
index b017580..a4bb63f 100644
--- a/Makefile
+++ b/Makefile
@@ -2,6 +2,21 @@
 # Copyright (c) 2000-2008 Silicon Graphics, Inc.  All Rights Reserved.
 #
 
+ifeq ("$(origin V)", "command line")
+  BUILD_VERBOSE = $(V)
+endif
+ifndef BUILD_VERBOSE
+  BUILD_VERBOSE = 0
+endif
+
+ifeq ($(BUILD_VERBOSE),1)
+  Q =
+else
+  Q = @
+endif
+
+MAKEOPTS = --no-print-directory Q=$(Q)
+
 TOPDIR = .
 HAVE_BUILDDEFS = $(shell test -f $(TOPDIR)/include/builddefs && echo yes || echo no)
 
@@ -11,11 +26,14 @@ endif
 
 TESTS = $(shell sed -n -e '/^[0-9][0-9][0-9]*/s/ .*//p' group)
 CONFIGURE = configure include/builddefs include/config.h
-DMAPI_MAKEFILE = dmapi/Makefile
 LSRCFILES = configure configure.in aclocal.m4 README VERSION
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	check.log check.time
 
+ifeq ($(HAVE_DMAPI), true)
+DMAPI_MAKEFILE = dmapi/Makefile
+endif
+
 LIB_SUBDIRS = include lib
 TOOL_SUBDIRS = ltp src m4
 
@@ -23,13 +41,13 @@ SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
 default: include/builddefs include/config.h $(DMAPI_MAKEFILE) new remake check $(TESTS)
 ifeq ($(HAVE_BUILDDEFS), no)
-	$(MAKE) $@
+	$(Q)$(MAKE) $(MAKEOPTS) $@
 else
-	$(MAKE) $(SUBDIRS)
+	$(Q)$(MAKE) $(MAKEOPTS) $(SUBDIRS)
 	# automake doesn't always support "default" target 
 	# so do dmapi make explicitly with "all"
 ifeq ($(HAVE_DMAPI), true)
-	$(MAKE) -C $(TOPDIR)/dmapi all
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(TOPDIR)/dmapi all
 endif
 endif
 
@@ -76,7 +94,7 @@ install: default $(addsuffix -install,$(SUBDIRS))
 install-dev install-lib:
 
 %-install:
-	$(MAKE) -C $* install
+	$(MAKE) $(MAKEOPTS) -C $* install
 
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)
diff --git a/include/buildmacros b/include/buildmacros
index 276d2c8..026ca4b 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -12,7 +12,7 @@ BUILDRULES = $(TOPDIR)/include/buildrules
 LDFLAGS += $(LOADERFLAGS) $(LLDFLAGS)
 LDLIBS = $(LLDLIBS) $(PLDLIBS) $(MALLOCLIB)
 
-MAKEOPTS = --no-print-directory
+MAKEOPTS = --no-print-directory Q=$(Q)
 SRCFILES = Makefile $(HFILES) $(CFILES) $(LSRCFILES) $(LFILES) $(YFILES)
 
 DEPDIRT = dep dep.bak
@@ -41,10 +41,10 @@ LIBNAME = $(basename $(LTLIBRARY))
 LTOBJECTS = $(OBJECTS:.o=.lo)
 LTVERSION = $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)
 
-LTLINK = $(LIBTOOL) --tag=CC --mode=link $(CC)
-LTEXEC = $(LIBTOOL) --mode=execute
-LTINSTALL = $(LIBTOOL) --mode=install $(INSTALL)
-LTCOMPILE = $(LIBTOOL) --tag=CC --mode=compile $(CCF)
+LTLINK = $(LIBTOOL) --quiet --tag=CC --mode=link $(CC)
+LTEXEC = $(LIBTOOL) --quiet --mode=execute
+LTINSTALL = $(LIBTOOL) --quiet --mode=install $(INSTALL)
+LTCOMPILE = $(LIBTOOL) --quiet --tag=CC --mode=compile $(CCF)
 
 ifeq ($(ENABLE_SHARED),yes)
 LTLDFLAGS += -rpath $(PKG_LIB_DIR)
diff --git a/include/buildrules b/include/buildrules
index e509833..5428391 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -7,11 +7,12 @@ _BUILDRULES_INCLUDED_ = 1
 include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
-	rm -f $(DIRT)
-	@rm -fr .libs
+	$(Q)rm -f $(DIRT)
+	$(Q)rm -fr .libs
 
 %-clean:
-	$(MAKE) -C $* clean
+	@echo "Cleaning $*"
+	$(Q)$(MAKE) $(MAKEOPTS) -q -C $* clean || $(MAKE) $(MAKEOPTS) -C $* clean
 
 # Never blow away subdirs
 ifdef SUBDIRS
@@ -19,7 +20,8 @@ ifdef SUBDIRS
 .PHONY: $(SUBDIRS)
 
 $(SUBDIRS):
-	$(MAKE) -C $@
+	@echo "Building $@"
+	$(Q)$(MAKE) $(MAKEOPTS) -q -C $@ || $(MAKE) $(MAKEOPTS) -C $@
 endif
 
 #
@@ -28,15 +30,23 @@ endif
 
 ifdef LTCOMMAND
 $(LTCOMMAND) : $(SUBDIRS) $(OBJECTS) $(LTDEPENDENCIES)
-	$(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
+	@echo "    [LD] $*"
+	$(Q)$(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
 endif
 
 ifdef LTLIBRARY
 $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
-	$(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
+	@echo "    [LD] $*"
+	$(Q)$(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
 
 %.lo: %.c
-	$(LTCOMPILE) -c $<
+	@echo "    [CC] $@"
+	$(Q)$(LTCOMPILE) -c $<
+else
+%.o: %.c
+	@echo "    [CC] $@"
+	$(Q)$(CC) $(CFLAGS) -c $<
+
 endif
 
 ifdef POTHEAD
diff --git a/ltp/Makefile b/ltp/Makefile
index bcdac84..fee10f5 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -10,47 +10,32 @@ CFILES = $(TARGETS:=.c)
 HFILES = doio.h
 LDIRT = $(TARGETS)
 LCFLAGS = -DXFS
-IFLAG = -I$(TOPDIR)/src #Used for including $(TOPDIR)/src/global.h
+LCFLAGS += -I$(TOPDIR)/src #Used for including $(TOPDIR)/src/global.h
 
 ifeq ($(HAVE_ATTR_LIST), true)
 LCFLAGS += -DHAVE_ATTR_LIST
+LLDLIBS += $(LIBATTR)
 endif
 ifeq ($(PKG_PLATFORM),irix)
 LCFLAGS += -DHAVE_ATTR_LIST
+LLDLIBS += $(LIBATTR)
 endif
 
 ifeq ($(HAVE_AIO), true)
 TARGETS += aio-stress
 LCFLAGS += -DAIO
-LIBAIO = -laio -lpthread
+LLDLIBS += -laio -lpthread
 endif
 
 default: $(TARGETS)
 
 include $(BUILDRULES)
-LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS)
 
-doio: doio.c $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(IFLAG)
+$(TARGETS): $(LIBTEST)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
-fsstress: fsstress.c $(LIBATTR) $(LIBTEST)
-	$(LINKTEST) $(LIBATTR) $(LIBTEST) $(LDLIBS)  $(IFLAG)
-
-fsx: fsx.c
-	$(LINKTEST) $(LIBAIO) $(LDLIBS)  $(IFLAG)
-
-growfiles: growfiles.c $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LDLIBS)  $(IFLAG)
-
-iogen: iogen.c $(LIBTEST)
-	$(LINKTEST) $(LIBTEST)  $(IFLAG)
-
-ifeq ($(HAVE_AIO), true)
-aio-stress: aio-stress.c
-	$(LINKTEST) $(LIBAIO) $(LDLIBS)
-endif
-
-install:
+install: default
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
 	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
 
diff --git a/src/Makefile b/src/Makefile
index 9f19605..8126a10 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,6 +17,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize \
 	fs_perms testx looptest locktest unwritten_mmap \
 	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset
 
+LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
+
 ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
 LINUX_TARGETS += loggen
 endif
@@ -25,18 +27,17 @@ IRIX_TARGETS = open_unlink
 
 ifeq ($(PKG_PLATFORM),linux)
 TARGETS += $(LINUX_TARGETS)
+TARGETS += t_immutable
 endif
 
 ifeq ($(PKG_PLATFORM),irix)
 TARGETS += $(IRIX_TARGETS)
+LLDLIBS += -lgen
 endif
 
 ifeq ($(HAVE_DB), true)
 TARGETS += dbtest
-endif
-
-ifeq ($(PKG_PLATFORM),linux)
-TARGETS += t_immutable
+LLDLIBS += $(LIBGDBM)
 endif
 
 ifeq ($(HAVE_AIO), true)
@@ -46,96 +47,28 @@ endif
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS)
 
-default: $(TARGETS) $(SUBDIRS)
-
-include $(BUILDRULES)
-LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS)
-
-randholes: randholes.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LDLIBS)
-
-truncfile: truncfile.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LDLIBS)
-
-dbtest:	dbtest.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LIBGDBM) $(LDLIBS)
-
-genhashnames: genhashnames.o
-	$(LINKTEST)
-
-nametest: nametest.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LDLIBS)
-
-bstat: bstat.o
-	$(LINKTEST) $(LIBHANDLE) $(LDLIBS)
-
-t_immutable: t_immutable.o
-	$(LINKTEST) $(LIBACL) $(LIBHANDLE) $(LDLIBS)
-
-loggen:	loggen.o
-	$(LINKTEST) $(LDLIBS)
 
-fstest:	fstest.o
-	$(LINKTEST)
-
-resvtest: resvtest.o
-	$(LINKTEST)
-
-itrash:	itrash.o
-	$(LINKTEST)
-
-multi_open_unlink: multi_open_unlink.o
-	$(LINKTEST) $(LIBATTR) $(LDLIBS)
-
-#scaleread: scaleread.o $(LDLIBS)
-#	$(LINKTEST)
+default: $(TARGETS) $(SUBDIRS)
 
-acl_get: acl_get.o
-	$(LINKTEST) $(LIBACL) $(LIBATTR) $(LDLIBS)
+PREALLO_TARGETS = preallo_rw_pattern_reader preallo_rw_pattern_writer
 
-dmiperf: dmiperf.o
-	$(LINKTEST) $(LIBATTR) $(LDLIBS)
+include $(BUILDRULES)
 
 preallo_rw_pattern_reader:
-	$(CC) $(GCFLAGS) $(LDFLAGS) -DREAD iopat.c -o preallo_rw_pattern_reader
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) iopat.c -DREAD -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
 preallo_rw_pattern_writer:
-	$(CC) $(GCFLAGS) $(LDFLAGS) -DWRITE iopat.c -o preallo_rw_pattern_writer
-
-ftrunc: ftrunc.o
-	$(LINKTEST)
-
-trunc: trunc.o
-	$(LINKTEST)
-
-fs_perms: fs_perms.o
-	$(LINKTEST)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) iopat.c -DWRITE -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
-testx: testx.o
-	$(LINKTEST)
+$(filter-out $(PREALLO_TARGETS), $(TARGETS)): $(LIBTEST)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
-looptest: looptest.o
-	$(LINKTEST)
-
-locktest: locktest.o
-	$(LINKTEST)
-
-unwritten_sync: unwritten_sync.o
-	$(LINKTEST)
-
-ifeq ($(PKG_PLATFORM),irix)
-fill2: fill2.o
-	$(LINKTEST)  -lgen
-
-runas: runas.o
-	$(LINKTEST)  -lgen
-
-open_unlink: open_unlink.o $(LIBHANDLE)
-	$(LINKTEST) $(LIBHANDLE) $(LDLIBS)
-
-endif
+LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS)
 
-install: $(addsuffix -install,$(SUBDIRS))
+install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
 	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
 	$(INSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
diff --git a/src/aio-dio-regress/Makefile b/src/aio-dio-regress/Makefile
index 9968093..f0e4d15 100644
--- a/src/aio-dio-regress/Makefile
+++ b/src/aio-dio-regress/Makefile
@@ -6,14 +6,15 @@ TARGETS = $(basename $(wildcard *.c))
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS)
 
-LIBAIO = -laio -lpthread
+LLDLIBS = -laio -lpthread
 
 default: $(TARGETS)
 
 include $(BUILDRULES)
 
-$(TARGETS): %: %.c
-	$(CC) -g -Wall $(LIBAIO) -o $@ $*.c
+$(TARGETS):
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
 install:
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src/aio-dio-regress
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
