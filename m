Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J8wjH5177988 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 02:58:45 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2302C173462
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 00:59:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	asUX0xBw3lG4UeI9 for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 00:59:44 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11709899-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:29:41 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX9w3-0003fL-BI
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 19:59:39 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX9w2-00080x-HB
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 19:59:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfstests: Clean up build output
Date: Tue, 19 Jan 2010 19:59:33 +1100
Message-Id: <1263891574-30762-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1263891574-30762-1-git-send-email-david@fromorbit.com>
References: <1263891574-30762-1-git-send-email-david@fromorbit.com>
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

This patch only addresses the top level makefile and build rules; it
does not clean up the subdirectories - these will be addressed by a
followup patch. It also does not touch the dmapi section of the
xfstests build system.

The old style verbose builds can still be run via "make V=1 ..."

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 Makefile            |   28 +++++++++++++++++++++++-----
 include/buildmacros |   10 +++++-----
 include/buildrules  |   24 +++++++++++++++++-------
 3 files changed, 45 insertions(+), 17 deletions(-)

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
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
