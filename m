Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAI41KNg017168 for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 20:01:21 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43F5715925AB
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 20:01:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id HKw2sVqymz0fSBHi for <xfs@oss.sgi.com>;
	Mon, 17 Nov 2008 20:01:13 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id A605FA8408B
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 22:01:13 -0600 (CST)
Message-ID: <49223E09.3090506@sandeen.net>
Date: Mon, 17 Nov 2008 22:01:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 6/7] nfs4acl parallel build
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

Allow parallel builds of the nfs4acl package

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/nfs4acl/include/buildmacros
===================================================================
--- xfs-cmds.orig/nfs4acl/include/buildmacros
+++ xfs-cmds/nfs4acl/include/buildmacros
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
Index: xfs-cmds/nfs4acl/include/buildrules
===================================================================
--- xfs-cmds.orig/nfs4acl/include/buildrules
+++ xfs-cmds/nfs4acl/include/buildrules
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
Index: xfs-cmds/nfs4acl/Makefile
===================================================================
--- xfs-cmds.orig/nfs4acl/Makefile
+++ xfs-cmds/nfs4acl/Makefile
@@ -18,23 +18,28 @@ LDIRT = config.log .dep config.status co
 
 #SUBDIRS = include libnfs4acl nfs4acl m4 man doc po \
 #	  test examples build debian
-SUBDIRS = include libnfs4acl nfs4acl m4 doc \
-	  test build
+LIB_SUBDIRS = include libnfs4acl
+TOOL_SUBDIRS = nfs4acl m4 doc test build
 
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
+nfs4acl: libnfs4acl
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
@@ -49,20 +54,33 @@ $(CONFIGURE):
 		--datadir=/usr/share \
 		$$LOCAL_CONFIGURE_OPTIONS
 	touch .census
+ 
+include/config.h: include/builddefs
+## Recover from the removal of $@
+	@if test -f $@; then :; else \
+		rm -f include/builddefs; \
+		$(MAKE) $(AM_MAKEFLAGS) include/builddefs; \
+	fi
 
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
+%-install-dev:
+	$(MAKE) -C $* install-dev
 
-install-lib: default
-	$(SUBDIRS_MAKERULE)
+%-install-lib:
+	$(MAKE) -C $* install-lib
 
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
