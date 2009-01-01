Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01MPuhm030698 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 16:25:56 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7F6258593
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 14:25:52 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id QE5AUzN63D9LJnXi for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 14:25:52 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 9A64DAC6273
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 16:25:19 -0600 (CST)
Message-ID: <495D42CE.6060806@sandeen.net>
Date: Thu, 01 Jan 2009 16:25:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] create xfstests install target
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

Not sure what the best location for this is in the end, but that's
just a one-line change in builddefs.in if it should move.  Currently
it goes to whatever configure thinks "libexecdir" is.

Once we have an install target we can probably hook this up
to makepkgs etc, too, and even publish tarballs & packages.  :)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfstests-dev.work/Makefile
===================================================================
--- xfstests-dev.work.orig/Makefile
+++ xfstests-dev.work/Makefile
@@ -62,7 +62,21 @@ $(DMAPI_MAKEFILE):
 aclocal.m4::
 	aclocal --acdir=`pwd`/m4 --output=$@
 
-install install-dev install-lib:
+install: default $(addsuffix -install,$(SUBDIRS))
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)
+	$(INSTALL) -m 755 check $(PKG_LIB_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(PKG_LIB_DIR)
+	$(INSTALL) -m 755 run.* $(PKG_LIB_DIR)
+	$(INSTALL) -m 644 group $(PKG_LIB_DIR)
+	$(INSTALL) -m 644 randomize.awk $(PKG_LIB_DIR)
+	$(INSTALL) -m 644 [0-9]??.* $(PKG_LIB_DIR)
+	$(INSTALL) -m 644 common* $(PKG_LIB_DIR)
+
+# Nothing.
+install-dev install-lib:
+
+%-install:
+	$(MAKE) -C $* install
 
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)
Index: xfstests-dev.work/include/builddefs.in
===================================================================
--- xfstests-dev.work.orig/include/builddefs.in
+++ xfstests-dev.work/include/builddefs.in
@@ -27,6 +27,8 @@ PKG_RELEASE     = @pkg_release@
 PKG_VERSION     = @pkg_version@
 PKG_PLATFORM    = @pkg_platform@
 PKG_DISTRIBUTION= @pkg_distribution@
+PKG_SBIN_DIR    = @sbindir@
+PKG_LIB_DIR     = @libexecdir@@libdirsuffix@/@pkg_name@
 
 CC              = @cc@
 AWK             = @awk@
Index: xfstests-dev.work/ltp/Makefile
===================================================================
--- xfstests-dev.work.orig/ltp/Makefile
+++ xfstests-dev.work/ltp/Makefile
@@ -49,3 +49,8 @@ ifeq ($(HAVE_AIO), true)
 aio-stress: aio-stress.c
 	$(LINKTEST) $(LIBAIO) $(LDLIBS)
 endif
+
+install:
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
+	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
+
Index: xfstests-dev.work/src/Makefile
===================================================================
--- xfstests-dev.work.orig/src/Makefile
+++ xfstests-dev.work/src/Makefile
@@ -126,3 +126,10 @@ open_unlink: open_unlink.o $(LIBHANDLE)
 	$(LINKTEST) $(LIBHANDLE) $(LDLIBS)
 
 endif
+
+install:
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
+	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
+	$(INSTALL) -m 755 fill2attr fill2fs $(PKG_LIB_DIR)/src
+	$(INSTALL) -m 755 fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
+	$(INSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
