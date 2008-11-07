Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Nov 2008 12:32:16 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA7KW6lP011455
	for <xfs@oss.sgi.com>; Fri, 7 Nov 2008 12:32:06 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65F491514ED8
	for <xfs@oss.sgi.com>; Fri,  7 Nov 2008 12:32:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id hu5NSjRZwwCo6IV3 for <xfs@oss.sgi.com>; Fri, 07 Nov 2008 12:32:06 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 6A1FAA81F03
	for <xfs@oss.sgi.com>; Fri,  7 Nov 2008 13:27:28 -0600 (CST)
Message-ID: <491496A0.2010409@sandeen.net>
Date: Fri, 07 Nov 2008 13:27:28 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfsprogs parallel build
References: <49148FDB.30407@sandeen.net>
In-Reply-To: <49148FDB.30407@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

(oops, cvs version...)

I got tired of waiting for xfsprogs to build
serially...

On a 16p altix, make -j16 (excluding the configure
phase) went from 2m16s to 33s.

I tossed this into an rpm and did a fedora scratch
build on all arches, they all passed - some of them,
at least, should have been doing parallel builds too.

So this has had reasonable testing.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfsprogs/Makefile
===================================================================
--- xfs-cmds.orig/xfsprogs/Makefile
+++ xfs-cmds/xfsprogs/Makefile
@@ -15,23 +15,28 @@ LSRCFILES = configure configure.in Makep
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	Logs/* built .census install.* install-dev.* *.gz
 
-SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk \
-	copy db estimate fsck growfs io logprint mkfs quota mdrestore repair rtcp \
-	m4 man doc po debian build
+LIB_SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk
+TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
+		mdrestore repair rtcp m4 man doc po debian build
+
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
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
@@ -51,16 +56,23 @@ $(CONFIGURE):
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
+
+install-qa: install $(addsuffix -install-qa,$(SUBDIRS))
+
+%-install-qa:
+	$(MAKE) -C $* install-qa
 
-install-qa: install
-	$(SUBDIRS_MAKERULE)
 
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)
Index: xfs-cmds/xfsprogs/include/buildrules
===================================================================
--- xfs-cmds.orig/xfsprogs/include/buildrules
+++ xfs-cmds/xfsprogs/include/buildrules
@@ -6,18 +6,22 @@ _BUILDRULES_INCLUDED_ = 1
 
 include $(TOPDIR)/include/builddefs
 
-clean clobber : $(SUBDIRS)
+clean clobber: $(addsuffix -clean,$(SUBDIRS))
 	rm -f $(DIRT)
 	@rm -fr .libs
-	$(SUBDIRS_MAKERULE)
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
@@ -69,11 +73,13 @@ ifdef LTLIBRARY
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
Index: xfs-cmds/xfsprogs/include/buildmacros
===================================================================
--- xfs-cmds.orig/xfsprogs/include/buildmacros
+++ xfs-cmds/xfsprogs/include/buildmacros
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
Index: xfs-cmds/xfsprogs/man/Makefile
===================================================================
--- xfs-cmds.orig/xfsprogs/man/Makefile
+++ xfs-cmds/xfsprogs/man/Makefile
@@ -7,7 +7,16 @@ include $(TOPDIR)/include/builddefs
 
 SUBDIRS = man3 man5 man8
 
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
