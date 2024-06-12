Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83053EA7B
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218824; cv=none; b=eNiW9TN7Z0d/M7ZA4jodFPNG4o8YDQa0pg1RDu8CFttFT2wAb6ZsaeNhwdD3wb/iDEUCJh4tlRqVB9DlmvK8BJZT5deOWyNFGPNuVVw/msxWHcsYCEBpDV0Vu7tjYRkGl+K0ITMKTDjMjRj7MMkFc6Br//IaWXPzj2iEyZdHoss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218824; c=relaxed/simple;
	bh=K5vIUHMPU2JZAEEjTyzgh3NPn10n5y5cbn0JAmdffE4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=mPKclPci7q3f5CPp/G/61Cj6agaZYe6gJbc/C+/7SHWDtezgjrBSlQui4zK7AASkifZUP+tlrrMeu5ISXNVamN0GgcoN/qWnfP7VKqwBp2+Dzz05UIKkW2TFQTGtJYOPevPcT5VirhFOF3pqDtp0AaEBY1A4WFmtm9n7hMAATdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=ZwgkgWzc; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="ZwgkgWzc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:References;
	bh=fFVs9b9hpL47Cp5jrjrYRoEgNBg5ppWhpWMA5+rZbFo=; b=ZwgkgWzcVv0qqRCgwy19wQmtMy
	NZjxzukfeBgBMB8dbl2G1yma9HEA0Cbbsqhgq0DX3B1O4pxcZBIt2EZU0Tyf8WuVD65gCO+/R7EYi
	TYGe0VOWviZ3e1KhXzHvueT1qHLJrDP2QT15lJDNkj/oj/nLR7mnEx5uKpkHZifekN2lCY4Sa36uo
	rHCDMhx8oMg8wqVKQ+34li8Bim38UfvkUnOtNhkO/RB26zAP2kDWKPTBtkp9rIGaWXDwkorFPAXbS
	pEW3ptG1zaHSJXhp0kGrU/pP2eJnQT//7YF1AIVh6ifPDhqFFwbx/JJROfU0H23dETPU9qwbQ4445
	9yMy3Jfw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <zeha@debian.org>)
	id 1sHTCm-0083Vy-Hn; Wed, 12 Jun 2024 19:00:20 +0000
Date: Wed, 12 Jun 2024 21:00:19 +0200
From: Chris Hofstaedtler <zeha@debian.org>
To: linux-xfs@vger.kernel.org, Bastian Germann <bage@debian.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2 1/1] Install files into UsrMerged layout
Message-ID: <xs47xj5jfbbap3324fwt753eimbe265i6wa2uhafcz5hsi6wnt@k6m3cwfvi4zh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240612173551.6510-2-bage@debian.org>
X-Debian-User: zeha

From: Chris Hofstaedtler <zeha@debian.org>

Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
---
V1 -> V2: remove root_sbindir, root_libdir, PKG_ROOT_SBIN_DIR,
          PKG_ROOT_LIB_DIR

 configure.ac                | 21 ---------------------
 debian/Makefile             |  4 ++--
 debian/local/initramfs.hook |  2 +-
 fsck/Makefile               |  4 ++--
 include/builddefs.in        |  2 --
 include/buildmacros         | 20 ++++++++++----------
 mkfs/Makefile               |  4 ++--
 repair/Makefile             |  4 ++--
 8 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/configure.ac b/configure.ac
index da30fc5c..4530f387 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,27 +113,6 @@ esac
 #
 test -n "$multiarch" && enable_lib64=no
 
-#
-# Some important tools should be installed into the root partitions.
-#
-# Check whether exec_prefix=/usr: and install them to /sbin in that
-# case.  If the user chooses a different prefix assume they just want
-# a local install for testing and not a system install.
-#
-case $exec_prefix:$prefix in
-NONE:NONE | NONE:/usr | /usr:*)
-  root_sbindir='/sbin'
-  root_libdir="/${base_libdir}"
-  ;;
-*)
-  root_sbindir="${sbindir}"
-  root_libdir="${libdir}"
-  ;;
-esac
-
-AC_SUBST([root_sbindir])
-AC_SUBST([root_libdir])
-
 # Find localized files.  Don't descend into any "dot directories"
 # (like .git or .pc from quilt).  Strangely, the "-print" argument
 # to "find" is required, to avoid including such directories in the
diff --git a/debian/Makefile b/debian/Makefile
index cafe8bbb..2f9cd38c 100644
--- a/debian/Makefile
+++ b/debian/Makefile
@@ -31,6 +31,6 @@ endif
 
 install-d-i: default
 ifeq ($(PKG_DISTRIBUTION), debian)
-	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
-	$(INSTALL) -m 755 $(BOOT_MKFS_BIN) $(PKG_ROOT_SBIN_DIR)/mkfs.xfs
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 $(BOOT_MKFS_BIN) $(PKG_SBIN_DIR)/mkfs.xfs
 endif
diff --git a/debian/local/initramfs.hook b/debian/local/initramfs.hook
index 5b24eaec..eac7e79e 100644
--- a/debian/local/initramfs.hook
+++ b/debian/local/initramfs.hook
@@ -45,7 +45,7 @@ rootfs_type() {
 . /usr/share/initramfs-tools/hook-functions
 
 if [ "$(rootfs_type)" = "xfs" ]; then
-	copy_exec /sbin/xfs_repair
+	copy_exec /usr/sbin/xfs_repair
 	copy_exec /usr/sbin/xfs_db
 	copy_exec /usr/sbin/xfs_metadump
 fi
diff --git a/fsck/Makefile b/fsck/Makefile
index da9b6ded..5ca529f5 100644
--- a/fsck/Makefile
+++ b/fsck/Makefile
@@ -12,6 +12,6 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
-	$(INSTALL) -m 755 xfs_fsck.sh $(PKG_ROOT_SBIN_DIR)/fsck.xfs
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 xfs_fsck.sh $(PKG_SBIN_DIR)/fsck.xfs
 install-dev:
diff --git a/include/builddefs.in b/include/builddefs.in
index 644ed1cb..6ac36c14 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -48,8 +48,6 @@ datarootdir	= @datarootdir@
 top_builddir	= @top_builddir@
 
 PKG_SBIN_DIR	= @sbindir@
-PKG_ROOT_SBIN_DIR = @root_sbindir@
-PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
 PKG_LIB_DIR	= @libdir@@libdirsuffix@
 PKG_LIBEXEC_DIR	= @libexecdir@/@pkg_name@
 PKG_INC_DIR	= @includedir@/xfs
diff --git a/include/buildmacros b/include/buildmacros
index 6f34d7c5..9183e5bc 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -50,16 +50,16 @@ LTINSTALL = $(LIBTOOL) --quiet --mode=install $(INSTALL)
 LTCOMPILE = $(LIBTOOL) --quiet --tag=CC --mode=compile $(CCF)
 
 ifeq ($(ENABLE_SHARED),yes)
-LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)
+LTLDFLAGS += -rpath $(PKG_LIB_DIR)
 LTLDFLAGS += -version-info $(LTVERSION)
 endif
 
 ifeq ($(ENABLE_SHARED),yes)
 INSTALL_LTLIB = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
-	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
-	../$(INSTALL) -m 755 -T so_dot_version $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
-	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_ROOT_LIB_DIR)
+	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
+	../$(INSTALL) -m 755 -T so_dot_version $(LIBNAME).lai $(PKG_LIB_DIR); \
+	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_LIB_DIR)
 endif
 
 # Libtool thinks the static and shared libs should be in the same dir, so
@@ -74,13 +74,13 @@ INSTALL_LTLIB_DEV = \
 	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
 	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_LIB_DIR); \
 	../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_LIB_DIR)/$(LIBNAME).la ; \
-	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
-	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
+	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
+	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_LIB_DIR); \
 	if [ "x$(shell readlink -f $(PKG_LIB_DIR))" != \
-	     "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))" ]; then \
-		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \
-		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
-		../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
+	     "x$(shell readlink -f $(PKG_LIB_DIR))" ]; then \
+		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_LIB_DIR)/$(LIBNAME).a; \
+		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_LIB_DIR)/$(LIBNAME).la; \
+		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
 	fi
 else
 INSTALL_LTLIB_DEV = $(INSTALL_LTLIB_STATIC)
diff --git a/mkfs/Makefile b/mkfs/Makefile
index a0c168e3..a6173083 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -28,8 +28,8 @@ default: depend $(LTCOMMAND) $(CFGFILES)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(MKFS_CFG_DIR)
 	$(INSTALL) -m 644 $(CFGFILES) $(MKFS_CFG_DIR)
 
diff --git a/repair/Makefile b/repair/Makefile
index e5014deb..c5b0d4cb 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -99,8 +99,8 @@ include $(BUILDRULES)
 #CFLAGS += ...
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
 -include .dep
-- 
2.39.2

