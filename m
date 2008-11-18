Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAI4XgDm024551 for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 20:33:42 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 793EB1592792
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 20:33:39 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id rXERc3yC9VFF1fW0 for <xfs@oss.sgi.com>;
	Mon, 17 Nov 2008 20:33:39 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 6E458A9C501
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 22:00:11 -0600 (CST)
Message-ID: <49223DCB.3090505@sandeen.net>
Date: Mon, 17 Nov 2008 22:00:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 5/7] xfsdump parallel build
References: <49223C13.2080507@sandeen.net>
In-Reply-To: <49223C13.2080507@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Allow parallel builds of the xfsdump package

I got tired of waiting for xfsdump to build
serially...

On a 16p altix, make -j16 (excluding the configure
phase) went from 55s to 8s.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfsdump/Makefile
===================================================================
--- xfs-cmds.orig/xfsdump/Makefile
+++ xfs-cmds/xfsdump/Makefile
@@ -15,24 +15,29 @@ LSRCFILES = configure configure.in acloc
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	Logs/* built .census install.* install-dev.* *.gz
 
-SUBDIRS = include librmt \
-	common fsr inventory invutil dump restore \
+LIB_SUBDIRS = include librmt
+TOOL_SUBDIRS = common fsr inventory invutil dump restore \
 	m4 man doc po debian build
 
-default: $(CONFIGURE)
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+
+default: include/builddefs include/config.h
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(MAKE) -C . $@
 else
-	$(SUBDIRS_MAKERULE)
+	$(MAKE) $(SUBDIRS)
 endif
 
+# tool/lib dependencies
+fsr invutil dump restore: librmt
+
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
 else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-$(CONFIGURE):
+include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
@@ -48,16 +53,27 @@ $(CONFIGURE):
 		$$LOCAL_CONFIGURE_OPTIONS
 	touch .census
 
+include/config.h: include/builddefs
+## Recover from the removal of $@
+	@if test -f $@; then :; else \
+		rm -f include/builddefs; \
+		$(MAKE) $(AM_MAKEFLAGS) include/builddefs; \
+	fi
+
 aclocal.m4::
 	aclocal --acdir=`pwd`/m4 --output=$@
 
-install: default
-	$(SUBDIRS_MAKERULE)
+install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 README $(PKG_DOC_DIR)
 
-install-dev: default
-	$(SUBDIRS_MAKERULE)
+install-dev: default $(addsuffix -install-dev,$(SUBDIRS))
+
+%-install:
+	$(MAKE) -C $* install
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
@@ -6,16 +6,20 @@ _BUILDRULES_INCLUDED_ = 1
 
 include $(TOPDIR)/include/builddefs
 
-clean clobber : $(SUBDIRS)
+clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	rm -f $(DIRT)
 	@rm -fr .libs
-	$(SUBDIRS_MAKERULE)
+
+%-clean:
+	$(MAKE) -C $* clean
 
 # Never blow away subdirs
 ifdef SUBDIRS
 .PRECIOUS: $(SUBDIRS)
+.PHONY: $(SUBDIRS)
+
 $(SUBDIRS):
-	$(SUBDIRS_MAKERULE)
+	$(MAKE) -C $@
 endif
 
 #
@@ -68,11 +72,13 @@ ifdef LTLIBRARY
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
