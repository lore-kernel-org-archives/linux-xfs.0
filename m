Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 796897CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 15:25:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56F5F304032
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 13:25:40 -0800 (PST)
Received: from mail-pf0-f170.google.com (mail-pf0-f170.google.com
	[209.85.192.170]) by cuda.sgi.com with ESMTP id
	FiCZG2q0KUQfgiZS (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Feb 2016 13:25:34 -0800 (PST)
Received: by mail-pf0-f170.google.com with SMTP id n128so89519269pfn.3
	for <xfs@oss.sgi.com>; Mon, 01 Feb 2016 13:25:34 -0800 (PST)
From: Gwendal Grignou <gwendal@chromium.org>
Subject: xfsprogs: Add BUILD_CFLAGS for cross compilation
Date: Mon,  1 Feb 2016 13:25:09 -0800
Message-Id: <1454361909-36538-1-git-send-email-gwendal@chromium.org>
In-Reply-To: <1437913255-7524-4-git-send-email-tytso@mit.edu>
References: <1437913255-7524-4-git-send-email-tytso@mit.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: hch@infradead.org, tytso@mit.edu
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

When cross compiling, CFLAGS may contains option for the cros-compiler the
host compiler can not handle.
Add BUILD_CFLAGS variable that does not include $OPTIMIZER options.

Signed-off by: Gwendal Grignou <gwendal@chromium.org>

--- a/include/builddefs.in	2016-02-01 09:44:14.636018753 -0800
+++ b/include/builddefs.in	2016-02-01 09:37:29.000000000 -0800
@@ -27,6 +27,7 @@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
 CFLAGS = @CFLAGS@
+BUILD_CFLAGS = @BUILD_CFLAGS@
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
@@ -151,7 +151,7 @@
 endif
 
 
-GCFLAGS = $(OPTIMIZER) $(DEBUG) \
+GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
 
@@ -160,7 +160,8 @@
 endif
 
 # First, Global, Platform, Local CFLAGS
-CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
+BUILD_CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
+CFLAGS += $(FCFLAGS) $(OPTIMIZER) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
 
 include $(TOPDIR)/include/buildmacros
 
--- a/libxfs/Makefile	2016-02-01 09:44:14.644018849 -0800
+++ b/libxfs/Makefile	2016-02-01 09:37:55.000000000 -0800
@@ -111,7 +111,7 @@
 
 crc32table.h: gen_crc32table.c
 	@echo "    [CC]     gen_crc32table"
-	$(Q) $(BUILD_CC) $(CFLAGS) -o gen_crc32table $<
+	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32table $<
 	@echo "    [GENERATE] $@"
 	$(Q) ./gen_crc32table > crc32table.h
 
@@ -122,7 +122,7 @@
 # disk.
 crc32selftest: gen_crc32table.c crc32table.h crc32.c
 	@echo "    [TEST]    CRC32"
-	$(Q) $(BUILD_CC) $(CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
+	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
 	$(Q) ./$@
 
 # set up include/xfs header directory
--- a/configure.ac	2016-02-01 09:56:42.873010767 -0800
+++ b/configure.ac	2016-02-01 09:56:45.885047014 -0800
@@ -11,9 +11,12 @@
 AC_PROG_CC
 if test $cross_compiling = no; then
   BUILD_CC="$CC"
+  BUILD_CFLAGS="$CFLAGS"
   AC_SUBST(BUILD_CC)
 else
   AC_CHECK_PROGS(BUILD_CC, gcc cc)
+  BUILD_CFLAGS="-g"
 fi
+AC_SUBST(BUILD_CFLAGS)
 
 AC_ARG_ENABLE(shared,
 [ --enable-shared=[yes/no] Enable use of shared libraries [default=yes]],,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
