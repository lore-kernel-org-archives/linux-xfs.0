Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAL0s0Fi010466 for <xfs@oss.sgi.com>; Thu, 20 Nov 2008 18:54:00 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A12D15B8D3E
	for <xfs@oss.sgi.com>; Thu, 20 Nov 2008 16:53:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id WJYheefRf1bNNv7q for <xfs@oss.sgi.com>;
	Thu, 20 Nov 2008 16:53:59 -0800 (PST)
Message-ID: <49260557.9010507@sandeen.net>
Date: Thu, 20 Nov 2008 18:48:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 7/7] xfstests parallel build
References: <49223C13.2080507@sandeen.net> <49223E80.5080504@sandeen.net>
	<op.ukx09mh13jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ukx09mh13jf8g2@pc-bnaujok.melbourne.sgi.com>
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
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Barry Naujok wrote:

> On Tue, 18 Nov 2008 15:03:12 +1100, Eric Sandeen <sandeen@sandeen.net>  
> wrote:
>
>   
>> Allow parallel builds of the xfstests package
>>     
>
> Eric, this patch doesn't apply anymore with the DMAPI patch you posted  
> earlier.
>
>   
Try this on for size (quick merge, not tested...)



Index: xfs-cmds/xfstests/Makefile
===================================================================
--- xfs-cmds.orig/xfstests/Makefile
+++ xfs-cmds/xfstests/Makefile
@@ -16,33 +16,46 @@ LSRCFILES = configure configure.in acloc
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	check.log check.time
 
-SUBDIRS = include lib ltp src m4
+LIB_SUBDIRS = include lib
+TOOL_SUBDIRS = ltp src m4
 
-default: $(CONFIGURE) $(DMAPI_MAKEFILE) new remake check $(TESTS)
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+
+default: include/builddefs include/config.h $(DMAPI_MAKEFILE) new remake check $(TESTS)
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(MAKE) $@
 else
-	$(SUBDIRS_MAKERULE)
+	$(MAKE) $(SUBDIRS)
 	# automake doesn't always support "default" target 
 	# so do dmapi make explicitly with "all"
 ifeq ($(HAVE_DMAPI), true)
-	cd $(TOPDIR)/dmapi; make all
+	$(MAKE) -C $(TOPDIR)/dmapi all
 endif
 endif
 
+# tool/lib dependencies
+src ltp: lib
+
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
 else
 clean:  # if configure hasn't run, nothing to clean
 endif
 
-$(CONFIGURE):
+include/builddefs.h:
 	autoheader
 	autoconf
 	./configure \
                 --libexecdir=/usr/lib \
                 --enable-lib64=yes
 
+include/config.h: include/builddefs
+## Recover from the removal of $@
+	@if test -f $@; then :; else \
+	rm -f include/builddefs; \
+		$(MAKE) $(AM_MAKEFLAGS) include/builddefs; \
+	fi
+
 $(DMAPI_MAKEFILE):
 	cd $(TOPDIR)/dmapi/ ; ./configure
 
Index: xfs-cmds/xfstests/include/buildmacros
===================================================================
--- xfs-cmds.orig/xfstests/include/buildmacros
+++ xfs-cmds/xfstests/include/buildmacros
@@ -122,14 +122,6 @@ INSTALL_LINGUAS = \
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
Index: xfs-cmds/xfstests/include/buildrules
===================================================================
--- xfs-cmds.orig/xfstests/include/buildrules
+++ xfs-cmds/xfstests/include/buildrules
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
