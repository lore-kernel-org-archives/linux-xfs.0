Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAI3utm8016787 for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 19:56:56 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A6E4159256E
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 19:56:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 3fhFEl7NVKbiIY0J for <xfs@oss.sgi.com>;
	Mon, 17 Nov 2008 19:56:45 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 78DF6AC3591
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 21:56:14 -0600 (CST)
Message-ID: <49223CDE.20803@sandeen.net>
Date: Mon, 17 Nov 2008 21:56:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/7] acl parallel build
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

Allow parallel builds of the acl package

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/acl/Makefile
===================================================================
--- xfs-cmds.orig/acl/Makefile
+++ xfs-cmds/acl/Makefile
@@ -16,23 +16,29 @@ LSRCFILES = configure configure.in acloc
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	Logs/* built .census install.* install-dev.* install-lib.* *.gz
 
-SUBDIRS = include libmisc libacl getfacl setfacl chacl m4 man doc po \
-	  test examples build debian
+LIB_SUBDIRS = include libmisc libacl
+TOOL_SUBDIRS = getfacl setfacl chacl m4 man doc po test examples build debian
 
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
+libacl: libmisc
+getfacl setfacl chacl: libacl
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
@@ -48,19 +54,32 @@ $(CONFIGURE):
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
+install-lib: default $(addsuffix -install-lib,$(SUBDIRS))
+
+%-install:
+	$(MAKE) -C $* install
+
+%-install-lib:
+	$(MAKE) -C $* install-lib
 
-install-lib: default
-	$(SUBDIRS_MAKERULE)
+%-install-dev:
+	$(MAKE) -C $* install-dev
 
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)
Index: xfs-cmds/acl/include/buildrules
===================================================================
--- xfs-cmds.orig/acl/include/buildrules
+++ xfs-cmds/acl/include/buildrules
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
Index: xfs-cmds/acl/man/Makefile
===================================================================
--- xfs-cmds.orig/acl/man/Makefile
+++ xfs-cmds/acl/man/Makefile
@@ -7,7 +7,16 @@ include $(TOPDIR)/include/builddefs
 
 SUBDIRS = man1 man3 man5
 
-default install install-dev install-lib: $(SUBDIRS)
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
Index: xfs-cmds/acl/include/buildmacros
===================================================================
--- xfs-cmds.orig/acl/include/buildmacros
+++ xfs-cmds/acl/include/buildmacros
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
