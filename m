Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAI5uV0K006127 for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 21:56:32 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 879F6158EFBD
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 21:56:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id yoRhCzNskWpE28jY for <xfs@oss.sgi.com>;
	Mon, 17 Nov 2008 21:56:28 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id E286FAC3591
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 21:57:33 -0600 (CST)
Message-ID: <49223D2D.7060206@sandeen.net>
Date: Mon, 17 Nov 2008 21:57:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: PATCH 3/7] xfsprogs parallel build
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

Allow parallel builds of the xfsprogs package

I got tired of waiting for xfsprogs to build
serially...

On a 16p altix, make -j16 (excluding the configure
phase) went from 2m16s to 15s.

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
@@ -15,24 +15,36 @@ LSRCFILES = configure configure.in Makep
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	Logs/* built .census install.* install-dev.* *.gz
 
-SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk \
-	copy db estimate fsck growfs io logprint mkfs quota mdrestore repair rtcp \
-	m4 man doc po debian build
+LIB_SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk
+TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
+		mdrestore repair rtcp m4 man doc po debian build
 
-default: $(CONFIGURE)
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+
+default: include/builddefs include/platform_defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(MAKE) -C . $@
 else
-	$(SUBDIRS_MAKERULE)
+	$(MAKE) $(SUBDIRS)
 endif
 
+# tool/lib dependencies
+libxcmd: include
+copy mdrestore: libxfs
+db logprint: libxfs libxlog
+growfs: libxfs libxcmd
+io: libxcmd libhandle
+mkfs: libxfs libdisk
+quota: libxcmd
+repair: libxfs libxlog
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
@@ -48,19 +60,32 @@ $(CONFIGURE):
 		$$LOCAL_CONFIGURE_OPTIONS
 	touch .census
 
+include/platform_defs.h: include/builddefs
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
+install-qa: install $(addsuffix -install-qa,$(SUBDIRS))
+
+%-install:
+	$(MAKE) -C $* install
+
+%-install-dev:
+	$(MAKE) -C $* install-dev
 
-install-qa: install
-	$(SUBDIRS_MAKERULE)
+%-install-qa:
+	$(MAKE) -C $* install-qa
 
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)
Index: xfs-cmds/xfsprogs/include/buildrules
===================================================================
--- xfs-cmds.orig/xfsprogs/include/buildrules
+++ xfs-cmds/xfsprogs/include/buildrules
@@ -6,16 +6,19 @@ _BUILDRULES_INCLUDED_ = 1
 
 include $(TOPDIR)/include/builddefs
 
-clean clobber : $(SUBDIRS)
+clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	rm -f $(DIRT)
 	@rm -fr .libs
-	$(SUBDIRS_MAKERULE)
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
@@ -69,11 +72,13 @@ ifdef LTLIBRARY
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
