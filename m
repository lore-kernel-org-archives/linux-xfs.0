Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E0hAVT205058 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 18:43:11 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95811164448
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:44:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	og0HKKIJUr8tyWww for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 16:44:05 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11511453-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 11:14:03 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVDof-0007JF-1m
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 11:44:01 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVDkb-0003MW-O4
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 11:39:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsdump: Clean up build output
Date: Thu, 14 Jan 2010 11:39:49 +1100
Message-Id: <1263429589-12896-1-git-send-email-david@fromorbit.com>
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
files by the build/clean process. Also fix the top level clean rule
so that we don't run configure scripts after a make clean, only
after a make distclean.

The old style verbose builds can still be run via "make V=1 ..."

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 Makefile            |   43 +++++++++++++++++++++++++++++--------------
 doc/Makefile        |    3 ++-
 dump/Makefile       |    6 ++++--
 include/buildmacros |   10 +++++-----
 include/buildrules  |   30 +++++++++++++++++++++---------
 invutil/Makefile    |    6 ++++--
 restore/Makefile    |    6 ++++--
 7 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/Makefile b/Makefile
index 13c8834..a044512 100644
--- a/Makefile
+++ b/Makefile
@@ -2,6 +2,21 @@
 # Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
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
 
@@ -15,7 +30,7 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
 CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
 LSRCFILES = configure.in release.sh README VERSION $(CONFIGURE)
 
-LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
+DISTDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
 	include/builddefs include/config.h
 
@@ -31,9 +46,9 @@ SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
 default: include/builddefs include/config.h
 ifeq ($(HAVE_BUILDDEFS), no)
-	$(MAKE) -C . $@
+	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
-	$(MAKE) $(SUBDIRS)
+	$(Q)$(MAKE) $(MAKEOPTS) $(SUBDIRS)
 endif
 
 # tool/lib dependencies
@@ -74,13 +89,13 @@ install: default $(addsuffix -install,$(SUBDIRS))
 install-dev: default $(addsuffix -install-dev,$(SUBDIRS))
 
 %-install:
-	$(MAKE) -C $* install
+	$(Q)$(MAKE) -C $* install
 
 %-install-dev:
-	$(MAKE) -C $* install-dev
+	$(Q)$(MAKE) -C $* install-dev
 
 distclean: clean
-	rm -f $(LDIRT)
+	rm -f $(DISTDIRT)
 
 realclean: distclean
 	rm -f $(CONFIGURE)
@@ -90,19 +105,19 @@ realclean: distclean
 #
 dist: include/builddefs include/config.h default
 ifeq ($(HAVE_BUILDDEFS), no)
-	$(MAKE) -C . $@
+	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
-	$(MAKE) $(SRCTAR)
+	$(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
 endif
 
 deb: include/builddefs include/config.h
 ifeq ($(HAVE_BUILDDEFS), no)
-	$(MAKE) -C . $@
+	$(MAKE) $(MAKEOPTS) -C . $@
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
@@ -110,6 +125,6 @@ $(SRCDIR) : $(_FORCE)
 	mkdir -p $@
 
 $(SRCTAR) : default $(SRCDIR)
-	$(MAKE) source-link
+	$(Q)$(MAKE) $(MAKEOPTS) source-link
 	unset TAPE; $(TAR) -cf - $(SRCDIR) | $(ZIP) --best > $@ && \
 	echo Wrote: $@
diff --git a/doc/Makefile b/doc/Makefile
index 8567172..dac0401 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -17,7 +17,8 @@ default: CHANGES.gz
 include $(BUILDRULES)
 
 CHANGES.gz:
-	$(ZIP) --best -c < CHANGES > $@
+	@echo "    [ZIP]    $@"
+	$(Q)$(ZIP) --best -c < CHANGES > $@
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
diff --git a/dump/Makefile b/dump/Makefile
index a24fde3..a0c74dc 100644
--- a/dump/Makefile
+++ b/dump/Makefile
@@ -106,7 +106,9 @@ install: default
 install-dev:
 
 $(COMMINCL) $(COMMON):
-	$(RM) $@; $(LN_S) ../common/$@ $@
+	@echo "    [LN]     $@"
+	$(Q)$(RM) $@; $(LN_S) ../common/$@ $@
 
 $(INVINCL) $(INVCOMMON):
-	$(RM) $@; $(LN_S) ../inventory/$@ $@
+	@echo "    [LN]     $@"
+	$(Q)$(RM) $@; $(LN_S) ../inventory/$@ $@
diff --git a/include/buildmacros b/include/buildmacros
index ea769fa..a7eebe6 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -13,7 +13,7 @@ LDFLAGS += $(LOADERFLAGS) $(LLDFLAGS)
 LTLDFLAGS += $(LOADERFLAGS)
 LDLIBS = $(LLDLIBS) $(PLDLIBS) $(MALLOCLIB)
 
-MAKEOPTS = --no-print-directory
+MAKEOPTS = --no-print-directory Q=$(Q)
 SRCFILES = Makefile $(HFILES) $(CFILES) $(LSRCFILES) $(LFILES) $(YFILES)
 
 DEPDIRT = dep dep.bak
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
index 2e3d3bb..a9eb092 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -7,10 +7,11 @@ _BUILDRULES_INCLUDED_ = 1
 include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
-	rm -f $(DIRT)
-	rm -fr $(DIRDIRT)
+	@rm -f $(DIRT)
+	@rm -fr $(DIRDIRT)
 %-clean:
-	$(MAKE) -C $* clean
+	@echo "Cleaning $*"
+	$(Q)$(MAKE) $(MAKEOPTS) -q -C $* clean || $(MAKE) $(MAKEOPTS) -C $* clean
 
 # Never blow away subdirs
 ifdef SUBDIRS
@@ -18,7 +19,8 @@ ifdef SUBDIRS
 .PHONY: $(SUBDIRS)
 
 $(SUBDIRS):
-	$(MAKE) -C $@
+	@echo "Building $@"
+	$(Q)$(MAKE) $(MAKEOPTS) -q -C $@ || $(MAKE) $(MAKEOPTS) -C $@
 endif
 
 source-link: 
@@ -38,20 +40,29 @@ source-link:
 
 ifdef LTCOMMAND
 $(LTCOMMAND) : $(SUBDIRS) $(OBJECTS) $(LTDEPENDENCIES)
-	$(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(LTLINK) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)
 endif
 
 ifdef LTLIBRARY
 $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
-	$(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
 
 %.lo: %.c
-	$(LTCOMPILE) -c $<
+	@echo "    [CC]     $@"
+	$(Q)$(LTCOMPILE) -c $<
+else
+%.o: %.c
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(CFLAGS) -c $<
+
 endif
 
 ifdef POTHEAD
 $(POTHEAD): $(XGETTEXTFILES)
-	$(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $(XGETTEXTFILES)
+	@echo "    [GETTXT] $@"
+	$(Q)$(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $(XGETTEXTFILES)
 
 # Update translations
 update-po: $(POTHEAD) $(wildcard $(TOPDIR)/po/*.po)
@@ -70,7 +81,8 @@ update-po: $(POTHEAD) $(wildcard $(TOPDIR)/po/*.po)
 	done
 
 %.mo: %.po
-	$(MSGFMT) -c --statistics -o $@ $<
+	@echo "    [MSGFMT] $@"
+	$(Q)$(MSGFMT) -c --statistics -o $@ $<
 endif
 
 endif # _BUILDRULES_INCLUDED_
diff --git a/invutil/Makefile b/invutil/Makefile
index 5ea0719..9e361f1 100644
--- a/invutil/Makefile
+++ b/invutil/Makefile
@@ -71,7 +71,9 @@ install: default
 install-dev:
 
 $(COMMINCL) $(COMMON):
-	$(RM) $@; $(LN_S) ../common/$@ $@
+	@echo "    [LN]     $@"
+	$(Q)$(RM) $@; $(LN_S) ../common/$@ $@
 
 $(INVINCL) $(INVCOMMON):
-	$(RM) $@; $(LN_S) ../inventory/$@ $@
+	@echo "    [LN]     $@"
+	$(Q)$(RM) $@; $(LN_S) ../inventory/$@ $@
diff --git a/restore/Makefile b/restore/Makefile
index 3890af5..a587632 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -118,7 +118,9 @@ install: default
 install-dev:
 
 $(COMMINCL) $(COMMON):
-	$(RM) $@; $(LN_S) ../common/$@ $@
+	@echo "    [LN]     $@"
+	$(Q)$(RM) $@; $(LN_S) ../common/$@ $@
 
 $(INVINCL) $(INVCOMMON):
-	$(RM) $@; $(LN_S) ../inventory/$@ $@
+	@echo "    [LN]     $@"
+	$(Q)$(RM) $@; $(LN_S) ../inventory/$@ $@
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
