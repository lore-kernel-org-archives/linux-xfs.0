Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D2b2XN105953 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 20:37:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EDA91C492D6
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 18:37:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	NilLJtAFd0i9BLVX for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2010 18:37:55 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11579427-1927428
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 13:07:54 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUt7I-0005uC-TZ
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 13:37:52 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUt3G-0001VT-0B
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 13:33:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsprogs: Make the compile output cleaner
Date: Wed, 13 Jan 2010 13:33:41 +1100
Message-Id: <1263350021-5733-1-git-send-email-david@fromorbit.com>
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
diretory/file being operated on.

Turn down the verbosity of output by suppressing various make output
and provide better overall visibility of which directory is being
operated on, what the operation is and what is being done to the
files by the build/clean process.

Sample output from a build:

....
Building libxlog
    [CC] xfs_log_recover.c
    [CC] util.c
    [LD] libxlog.la
Building libxcmd
    [CC] command.c
    [CC] input.c
    [CC] paths.c
    [CC] projects.c
    [CC] help.c
    [CC] quit.c
    [LD] libxcmd.la
....

Sample output from cleaning:

$ make clean
Cleaning include
Cleaning libxfs
Cleaning libxlog
Cleaning libxcmd
Cleaning libhandle
Cleaning libdisk
Cleaning copy
Cleaning db
....

If you want to see a noisy build (i.e. every command), use:

$ make Q=

and that will output all the commands that are now suppressed by
default.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 Makefile            |   24 +++++++++++++-----------
 include/buildmacros |   10 +++++-----
 include/buildrules  |   24 +++++++++++++++++-------
 mkfs/Makefile       |    3 ++-
 4 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/Makefile b/Makefile
index 2d394e4..2fbfb51 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,8 @@
 #
 # Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
 #
+Q ?= @
+MAKEOPTS = --no-print-directory Q=$(Q)
 
 TOPDIR = .
 HAVE_BUILDDEFS = $(shell test -f $(TOPDIR)/include/builddefs && echo yes || echo no)
@@ -36,9 +38,9 @@ SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
 default: include/builddefs include/platform_defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
-	$(MAKE) -C . $@
+	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
-	$(MAKE) $(SUBDIRS)
+	$(Q)$(MAKE) $(MAKEOPTS) $(SUBDIRS)
 endif
 
 # tool/lib dependencies
@@ -80,7 +82,7 @@ include/platform_defs.h: include/builddefs
 ## Recover from the removal of $@
 	@if test -f $@; then :; else \
 		rm -f include/builddefs; \
-		$(MAKE) $(AM_MAKEFLAGS) include/builddefs; \
+		$(MAKE) $(MAKEOPTS) $(AM_MAKEFLAGS) include/builddefs; \
 	fi
 
 install: default $(addsuffix -install,$(SUBDIRS))
@@ -111,19 +113,19 @@ realclean: distclean
 #
 dist: include/builddefs include/platform_defs.h default
 ifeq ($(HAVE_BUILDDEFS), no)
-	$(MAKE) -C . $@
+	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
-	$(MAKE) $(SRCTAR)
+	$(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
 endif
 
 deb: include/builddefs include/platform_defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
-	$(MAKE) -C . $@
+	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
-	$(MAKE) $(SRCDIR)
-	$(MAKE) -C po
-	$(MAKE) source-link
-	cd $(SRCDIR) && dpkg-buildpackage
+	$(Q)$(MAKE) $(MAKEOPTS) $(SRCDIR)
+	$(Q)$(MAKE) $(MAKEOPTS) -C po
+	$(Q)$(MAKE) $(MAKEOPTS) source-link
+	$(Q)cd $(SRCDIR) && dpkg-buildpackage
 endif
 
 $(SRCDIR) : $(_FORCE)
@@ -131,6 +133,6 @@ $(SRCDIR) : $(_FORCE)
 	mkdir -p $@
 
 $(SRCTAR) : default $(SRCDIR)
-	$(MAKE) source-link
+	$(Q)$(MAKE) $(MAKEOPTS) source-link
 	unset TAPE; $(TAR) -cf - $(SRCDIR) | $(ZIP) --best > $@ && \
 	echo Wrote: $@
diff --git a/include/buildmacros b/include/buildmacros
index 099570f..62babca 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -13,7 +13,7 @@ LDFLAGS += $(LOADERFLAGS) $(LLDFLAGS)
 LTLDFLAGS += $(LOADERFLAGS)
 LDLIBS = $(LLDLIBS) $(PLDLIBS) $(MALLOCLIB)
 
-MAKEOPTS = --no-print-directory
+MAKEOPTS = --no-print-directory Q=$(Q)
 SRCFILES = Makefile $(HFILES) $(CFILES) $(LSRCFILES) $(LFILES) $(YFILES)
 SRCFILES += $(QAHFILES)
 
@@ -45,10 +45,10 @@ LIBNAME = $(basename $(LTLIBRARY))
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
 LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)
diff --git a/include/buildrules b/include/buildrules
index a06d480..a0c77a9 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -7,10 +7,11 @@ _BUILDRULES_INCLUDED_ = 1
 include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
-	rm -f $(DIRT)
-	rm -fr $(DIRDIRT)
+	$(Q)rm -f $(DIRT)
+	$(Q)rm -fr $(DIRDIRT)
 %-clean:
-	$(MAKE) -C $* clean
+	@echo "Cleaning $*"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* clean
 
 # Never blow away subdirs
 ifdef SUBDIRS
@@ -18,7 +19,8 @@ ifdef SUBDIRS
 .PHONY: $(SUBDIRS)
 
 $(SUBDIRS):
-	$(MAKE) -C $@
+	@echo "Building $@"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $@
 endif
 
 source-link: 
@@ -38,15 +40,23 @@ source-link:
 
 ifdef LTCOMMAND
 $(LTCOMMAND) : $(SUBDIRS) $(OBJECTS) $(LTDEPENDENCIES)
-	$(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
+	@echo "    [LD] $@"
+	$(Q)$(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
 endif
 
 ifdef LTLIBRARY
 $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
-	$(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
+	@echo "    [LD] $@"
+	$(Q)$(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
 
 %.lo: %.c
-	$(LTCOMPILE) -c $<
+	@echo "    [CC] $<"
+	$(Q)$(LTCOMPILE) -c $<
+else
+%.o: %.c
+	@echo "    [CC] $<"
+	$(Q)$(CC) $(CFLAGS) -c $<
+
 endif
 
 ifdef POTHEAD
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 9fcadf2..7065f24 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -36,7 +36,8 @@ endif
 include $(BUILDRULES)
 
 $(FSTYP):
-	$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $(PLDLIBS)
+	@echo "    [CC] $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $(PLDLIBS)
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
