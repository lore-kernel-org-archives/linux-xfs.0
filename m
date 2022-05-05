Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43FAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358396AbiEEQHk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353854AbiEEQHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:07:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEFE515A3
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A91B8B82DEE
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505E1C385A8;
        Thu,  5 May 2022 16:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766636;
        bh=7ZwN4scGpBJAjU2EE8vgClGQXXZK0jkl52juVzePDc0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VYZL7yy/BODQxdQfo3yoIim1Y46ACUQ8Gp8vUzPs34y8M6vqesyQIvwu2i9MM3xRj
         nqeSyAeXJBxrkXv5Wh/baQiLjd3/JqK7zv0lMdOwTZDV/RG0zu4b8VR3Wakl3TnFLE
         aKD/CewL/KrIr5wKd11e4ip2d+ovUazcYLWJavZjpAyuLAHqhWGunn6k777bqEsbTM
         8OoKb3dWqD7rL4Is4qv0pxS7+UxyNUL0Qvz7nXvR3RoB/pMTSfpjq2BGbjB7A+EuWM
         2gdtb0GeadsTi65oPRsqPef04zYIzZnMaIa5zO3tOdv1HN1vv4nkQauPS4A1LR0YZI
         uT+REj6+kL0KQ==
Subject: [PATCH 3/3] debian: support multiarch for libhandle
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:03:55 -0700
Message-ID: <165176663588.246788.12144011845413653233.stgit@magnolia>
In-Reply-To: <165176661877.246788.7113237793899538040.stgit@magnolia>
References: <165176661877.246788.7113237793899538040.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For nearly a decade now, Debian and derivatives have supported the
"multiarch" layout, where shared libraries are installed to
/lib/<gcc triple>/ instead of /lib.  This enables a single rootfs to
support binaries from multiple architectures (e.g. i386 inside an amd64
system).  We should follow this, since libhandle is useful.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac         |   11 +++++++++++
 debian/rules         |    6 ++++--
 include/builddefs.in |    1 +
 m4/multilib.m4       |   12 ++++++++++++
 scrub/Makefile       |   11 ++++++-----
 5 files changed, 34 insertions(+), 7 deletions(-)


diff --git a/configure.ac b/configure.ac
index 3e7563f9..160f64dd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -60,6 +60,11 @@ AC_ARG_ENABLE(lib64,
 	enable_lib64=yes)
 AC_SUBST(enable_lib64)
 
+AC_ARG_WITH([multiarch],
+[  --with-multiarch=ARCH   Specify the multiarch triplet],
+	multiarch=$withval)
+AC_SUBST(multiarch)
+
 AC_ARG_ENABLE(librt,
 [  --enable-librt=[yes/no]   Enable librt support [default=yes]],,
 	enable_librt=yes)
@@ -109,6 +114,11 @@ lib64)
   enable_lib64=no
 esac
 
+#
+# If the user specified a multiarch path then disable lib64
+#
+test -n "$multiarch" && enable_lib64=no
+
 #
 # Some important tools should be installed into the root partitions.
 #
@@ -143,6 +153,7 @@ AC_SUBST(LOCALIZED_FILES)
 AC_PACKAGE_GLOBALS(xfsprogs)
 AC_PACKAGE_UTILITIES(xfsprogs)
 AC_MULTILIB($enable_lib64)
+AC_MULTIARCH($multiarch)
 AC_RT($enable_librt)
 
 AC_PACKAGE_NEED_INI_H
diff --git a/debian/rules b/debian/rules
index df023c65..95df4835 100755
--- a/debian/rules
+++ b/debian/rules
@@ -13,6 +13,7 @@ bootpkg = xfsprogs-udeb
 
 DEB_BUILD_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_BUILD_GNU_TYPE)
 DEB_HOST_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_HOST_GNU_TYPE)
+DEB_HOST_MULTIARCH ?= $(shell dpkg-architecture -qDEB_HOST_MULTIARCH)
 
 version = $(shell dpkg-parsechangelog | grep ^Version: | cut -d ' ' -f 2 | cut -d '-' -f 1)
 target ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)
@@ -28,6 +29,7 @@ stdenv = @GZIP=-q; export GZIP;
 
 configure_options = \
 	--build=$(DEB_BUILD_GNU_TYPE) \
+	--with-multiarch=$(DEB_HOST_MULTIARCH) \
 	--host=$(DEB_HOST_GNU_TYPE) \
 	--disable-ubsan \
 	--disable-addrsan \
@@ -97,8 +99,8 @@ binary-arch: checkroot built
 	$(pkgme)  $(MAKE) dist
 	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
-	rm -f debian/xfslibs-dev/lib/libhandle.la
-	rm -f debian/xfslibs-dev/lib/libhandle.a
+	rm -f debian/xfslibs-dev/lib/$(DEB_HOST_MULTIARCH)/libhandle.la
+	rm -f debian/xfslibs-dev/lib/$(DEB_HOST_MULTIARCH)/libhandle.a
 	rm -fr debian/xfslibs-dev/usr/lib
 	dh_installdocs -XCHANGES
 	dh_installchangelogs
diff --git a/include/builddefs.in b/include/builddefs.in
index 0bb36431..626db210 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -51,6 +51,7 @@ PKG_SBIN_DIR	= @sbindir@
 PKG_ROOT_SBIN_DIR = @root_sbindir@
 PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
 PKG_LIB_DIR	= @libdir@@libdirsuffix@
+PKG_LIB_SCRIPT_DIR	= @libdir@
 PKG_INC_DIR	= @includedir@/xfs
 DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
diff --git a/m4/multilib.m4 b/m4/multilib.m4
index 8d991d8d..862fd8ab 100644
--- a/m4/multilib.m4
+++ b/m4/multilib.m4
@@ -41,3 +41,15 @@ AC_DEFUN([AC_MULTILIB],
   fi
   AC_SUBST(libdirsuffix)
 ])
+
+dnl AC_MULTIARCH creates a variable libdirsuffix containing the suffix of the
+dnl libdir to follow the Debian multiarch spec.  (i.e. "/$multiarch")
+AC_DEFUN([AC_MULTIARCH],
+[
+  if test -n "$1"; then
+    libdirsuffix="/$1"
+    AC_MSG_CHECKING([multiarch triplet])
+    AC_MSG_RESULT([$multiarch])
+  fi
+  AC_SUBST(libdirsuffix)
+])
diff --git a/scrub/Makefile b/scrub/Makefile
index 335e1e8d..74492fb6 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -23,7 +23,7 @@ INSTALL_SCRUB += install-crond
 CRONTABS = xfs_scrub_all.cron
 OPTIONAL_TARGETS += $(CRONTABS)
 # Don't enable the crontab by default for now
-CROND_DIR = $(PKG_LIB_DIR)/$(PKG_NAME)
+CROND_DIR = $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
 endif
 
 endif	# scrub_prereqs
@@ -119,8 +119,9 @@ install: $(INSTALL_SCRUB)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
-		   -e "s|@pkg_lib_dir@|$(PKG_LIB_DIR)|g" \
-		   -e "s|@pkg_name@|$(PKG_NAME)|g" < $< > $@
+		   -e "s|@pkg_lib_dir@|$(PKG_LIB_SCRIPT_DIR)|g" \
+		   -e "s|@pkg_name@|$(PKG_NAME)|g" \
+		   < $< > $@
 
 %.cron: %.cron.in $(builddefs)
 	@echo "    [SED]    $@"
@@ -129,8 +130,8 @@ install: $(INSTALL_SCRUB)
 install-systemd: default $(SYSTEMD_SERVICES)
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
 	$(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
-	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(PKG_NAME)
-	$(INSTALL) -m 755 xfs_scrub_fail $(PKG_LIB_DIR)/$(PKG_NAME)
+	$(INSTALL) -m 755 -d $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
+	$(INSTALL) -m 755 xfs_scrub_fail $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
 
 install-crond: default $(CRONTABS)
 	$(INSTALL) -m 755 -d $(CROND_DIR)

