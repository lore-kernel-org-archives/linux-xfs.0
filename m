Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DF52905
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298964; cv=none; b=QeB5Ftl3/4uSjMt75WRA29+XvaUV1i2PSci00S6wRMN8KfcmfxcrCOogEPmX3L78AE8OAZ0oZdl7gj/A/WxCiPWEdJUohoZlVK1da1zlrpC8IgJzr90DwnDWIPRXAoxlUIrT+VSnXBtQhnEQDl7fDFHzCKhRWxf/WRBhFNf2c5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298964; c=relaxed/simple;
	bh=ES1/GBnQSddH2nl1GVIQCbnNoXt0UHM6sjF9bG2f1bc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MybkAkvevtjH9QwQgn8VhGZIlZzJDALjSxxOMtP407kbRGGKAIAi6BfYSnmmzEAUXypQ/GmCFPRMRZEC61twKkoPU+aTW0zkrUj1+XBRbeL+CdzGmUpBF0KRPfuA86KhzN5/p8gI3AvhG+XGh4X36afjP86UWEb8MVzhprnvHlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5+q3SGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5+q3SGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35843C32786;
	Tue, 30 Jul 2024 00:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298964;
	bh=ES1/GBnQSddH2nl1GVIQCbnNoXt0UHM6sjF9bG2f1bc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H5+q3SGVPvdgSXgSCBU7uA4l/Hzu9P8Jkh3/Qwo4h0E2jT/8eBPx5+AvekqQE5C7m
	 fU0NPnOwyf1bT0UHHn+jkGN9yWKqqBSMAWQNu0bzrxHT02CAabjt8ovKl+hTmeH+zI
	 VYEm9GVlxscDEmZGmFiVpqqN9HyjSWx+gr+n2rr5G3rzDujEfgXynnjJPctW6oC2ni
	 1A/Cif3fsvUs80TT/o1MYsFXRqH8uN8WrLfu+2uH5R+nzjEeh88+25ElGFkbLj8sCc
	 U73aZBsr5gStG8FNrL2/pAwnYR7XZQl+vVCOeFHuW6XS192g6zgzhb9njarRig9W9B
	 YvLJLBPvOO7DA==
Date: Mon, 29 Jul 2024 17:22:43 -0700
Subject: [PATCH 1/5] [PATCH v3] Remove support for split-/usr installs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Chris Hofstaedtler <zeha@debian.org>, linux-xfs@vger.kernel.org
Message-ID: <172229841893.1338302.14575530273503333993.stgit@frogsfrogsfrogs>
In-Reply-To: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
References: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chris Hofstaedtler <zeha@debian.org>

Always install binaries and other files under /usr, not /.  This will
break any distribution that hasn't yet merged the two, which are
vanishingly small these days.  This breaks the usecase of needing to
repair the /usr partition when there is no initramfs or livecd
available and / is the only option.

Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac                |   21 ---------------------
 debian/Makefile             |    4 ++--
 debian/local/initramfs.hook |    2 +-
 debian/rules                |    5 ++---
 fsck/Makefile               |    4 ++--
 include/builddefs.in        |    2 --
 include/buildmacros         |   20 ++++++++++----------
 mkfs/Makefile               |    4 ++--
 repair/Makefile             |    4 ++--
 9 files changed, 21 insertions(+), 45 deletions(-)


diff --git a/configure.ac b/configure.ac
index b692b4b42..b84234b50 100644
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
index cafe8bbb3..2f9cd38c2 100644
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
index 5b24eaece..eac7e79ea 100644
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
diff --git a/debian/rules b/debian/rules
index 0c1cef92d..0db0ed8e7 100755
--- a/debian/rules
+++ b/debian/rules
@@ -105,9 +105,8 @@ binary-arch: checkroot built
 	$(pkgme)  $(MAKE) dist
 	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
-	rm -f debian/xfslibs-dev/lib/$(DEB_HOST_MULTIARCH)/libhandle.la
-	rm -f debian/xfslibs-dev/lib/$(DEB_HOST_MULTIARCH)/libhandle.a
-	rm -fr debian/xfslibs-dev/usr/lib
+	rm -f debian/xfslibs-dev/usr/lib/$(DEB_HOST_MULTIARCH)/libhandle.la
+	rm -f debian/xfslibs-dev/usr/lib/$(DEB_HOST_MULTIARCH)/libhandle.a
 	dh_installdocs -XCHANGES
 	dh_installchangelogs
 	dh_strip
diff --git a/fsck/Makefile b/fsck/Makefile
index da9b6ded8..5ca529f53 100644
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
index 644ed1cb1..6ac36c149 100644
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
index 6f34d7c52..9183e5bc7 100644
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
index a0c168e38..a6173083e 100644
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
index 250c86cca..d94858878 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -103,8 +103,8 @@ include $(BUILDRULES)
 #CFLAGS += ...
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
 -include .dep

