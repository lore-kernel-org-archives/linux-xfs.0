Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Nov 2008 11:28:26 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA7JSJWA002913
	for <xfs@oss.sgi.com>; Fri, 7 Nov 2008 11:28:19 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B96D0151490E
	for <xfs@oss.sgi.com>; Fri,  7 Nov 2008 11:28:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id trbhGX62nCBP3lpW for <xfs@oss.sgi.com>; Fri, 07 Nov 2008 11:28:18 -0800 (PST)
Message-ID: <491496D2.70906@sandeen.net>
Date: Fri, 07 Nov 2008 13:28:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfsdump parallel build
References: <491490D2.70804@sandeen.net>
In-Reply-To: <491490D2.70804@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: Bill Kendall <wkendall@sgi.com>

(oops, cvs version)

I got tired of waiting for xfsdump to build
serially...

On a 16p altix, make -j16 (excluding the configure
phase) went from 55s to 12s.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfsdump/Makefile
===================================================================
--- xfs-cmds.orig/xfsdump/Makefile
+++ xfs-cmds/xfsdump/Makefile
@@ -15,23 +15,28 @@ LSRCFILES = configure configure.in acloc
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	Logs/* built .census install.* install-dev.* *.gz
 
-SUBDIRS = include librmt \
-	common fsr inventory invutil dump restore \
+LIB_SUBDIRS = include librmt
+TOOL_SUBDIRS = common fsr inventory invutil dump restore \
 	m4 man doc po debian build
 
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+
 default: $(CONFIGURE)
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(MAKE) -C . $@
 else
-	$(SUBDIRS_MAKERULE)
+	$(MAKE) $(SUBDIRS)
 endif
 
+$(TOOL_SUBDIRS) : $(LIB_SUBDIRS)
+
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
 else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
+.NOTPARALLEL: $(CONFIGURE)
 $(CONFIGURE):
 	autoconf
 	./configure \
@@ -51,13 +56,17 @@ $(CONFIGURE):
 aclocal.m4::
 	aclocal --acdir=`pwd`/m4 --output=$@
 
-install: default
-	$(SUBDIRS_MAKERULE)
+install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 README $(PKG_DOC_DIR)
 
-install-dev: default
-	$(SUBDIRS_MAKERULE)
+%-install:
+	$(MAKE) -C $* install
+
+install-dev: default $(addsuffix -install-dev,$(SUBDIRS))
+
+%-install-dev:
+	$(MAKE) -C $* install-dev
 
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)
Index: xfs-cmds/xfsdump/include/buildmacros
===================================================================
--- xfs-cmds.orig/xfsdump/include/buildmacros
+++ xfs-cmds/xfsdump/include/buildmacros
@@ -123,14 +123,6 @@ INSTALL_LINGUAS = \
 	done
 endif
 
-SUBDIRS_MAKERULE = \
-	@for d in $(SUBDIRS) ""; do \
-		if test -d "$$d" -a ! -z "$$d"; then \
-			$(ECHO) === $$d ===; \
-			$(MAKEF) -C $$d $@ || exit $$?; \
-		fi; \
-	done
-
 MAN_MAKERULE = \
 	@for f in *.[12345678] ""; do \
 		if test ! -z "$$f"; then \
Index: xfs-cmds/xfsdump/include/buildrules
===================================================================
--- xfs-cmds.orig/xfsdump/include/buildrules
+++ xfs-cmds/xfsdump/include/buildrules
@@ -6,18 +6,23 @@ _BUILDRULES_INCLUDED_ = 1
 
 include $(TOPDIR)/include/builddefs
 
-clean clobber : $(SUBDIRS)
+clean clobber: $(addsuffix -clean,$(SUBDIRS))
 	rm -f $(DIRT)
 	@rm -fr .libs
-	$(SUBDIRS_MAKERULE)
+
+%-clean::
+	$(MAKE) -C $* clean
 
 # Never blow away subdirs
 ifdef SUBDIRS
 .PRECIOUS: $(SUBDIRS)
-$(SUBDIRS):
-	$(SUBDIRS_MAKERULE)
 endif
 
+.PHONY: $(SUBDIRS)
+
+$(SUBDIRS):
+	$(MAKE) -C $@
+
 #
 # Standard targets
 #
@@ -68,11 +73,13 @@ ifdef LTLIBRARY
 DEPENDSCRIPT := $(DEPENDSCRIPT) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,'
 endif
 
-depend : $(CFILES) $(HFILES)
-	$(SUBDIRS_MAKERULE)
+depend : $(CFILES) $(HFILES) $(addsuffix -depend,$(SUBDIRS))
 	$(DEPENDSCRIPT) > .dep
 	test -s .dep || rm -f .dep
 
+%-depend:
+	$(MAKE) -C $* depend
+
 # Include dep, but only if it exists
 ifeq ($(shell test -f .dep && echo .dep), .dep)
 include .dep
Index: xfs-cmds/xfsdump/man/Makefile
===================================================================
--- xfs-cmds.orig/xfsdump/man/Makefile
+++ xfs-cmds/xfsdump/man/Makefile
@@ -7,7 +7,16 @@ include $(TOPDIR)/include/builddefs
 
 SUBDIRS = man8
 
-default install install-dev : $(SUBDIRS)
-	$(SUBDIRS_MAKERULE)
+default : $(SUBDIRS)
+
+install : $(addsuffix -install,$(SUBDIRS))
+
+install-dev : $(addsuffix -install-dev,$(SUBDIRS))
+
+%-install:
+	$(MAKE) -C $* install
+
+%-install-dev:
+	$(MAKE) -C $* install-dev
 
 include $(BUILDRULES)
