Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EE31854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309787; cv=none; b=T/jtdBYVCAOor4+4m1I9FiXxM5qR66WCZka2GK8V7wv7PzpTcEEqoHqCWdIF90++HIqJNNGAK2XwCK4GfNmBmIR2KNtqw33EDN1sZzdzfecEgjVuXK6WakhcuGATz47BViFqS3D66jiVVfiXMJVMUXLsDYkwJu0N/V2VPr81mP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309787; c=relaxed/simple;
	bh=6qujKIFqWHAQPMRuIpMlXQ5a1mkxMwlNjgpnpJwU3A0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFk9x1rS1d+BmCDhBUkz4UrLsGA1iDblZDHlSAHobf1rr7300enNuIxqXuEXLGCOgAnm8Pqz0wUI2yg6MZnZtHTA8PotYqG0siVpsAM6Mm/nRy2r56fCpkvdmsLmQn8SUNoFpdRxXdWfVHdyrldlCN3LdckH7kwcv9I8S/fwPdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2U+5r4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2U+5r4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64398C32786;
	Tue, 30 Jul 2024 03:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309787;
	bh=6qujKIFqWHAQPMRuIpMlXQ5a1mkxMwlNjgpnpJwU3A0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L2U+5r4tyWnLVsmkvH0/A3IGLK+ZXbcVsO5raU4vHEtsHp+1RobGXJ6CxRyT/Ee9s
	 qrKMWFtNw2sRg7+giP6BblVEMRLtTEr6FnSQXEAdLbLUE6jNxHMZpGxv6BDsPwST+S
	 Uvr2DiVqlfQ8du5S+I0J5H3u0Tf7teDECyaIwyoE5sOX99NCruyUoOlp7Bau8WIkAj
	 mxY7lPdC+3ghxmoE6/T6SqeG7VNcsMj2A3PI6jkiKSH3oB6T/Rp5vsUjWFF4T4Axwq
	 wtjS311yPiZJ0f2BRHgSuA2/p6pYu6Ayu8RnuUKvOOOXZz0BV46wi8nPYYbv+HZ99M
	 nUxJUGVJYZQCQ==
Date: Mon, 29 Jul 2024 20:23:06 -0700
Subject: [PATCH 3/3] debian: create a new package for automatic self-healing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230941388.1544199.4672195967361728491.stgit@frogsfrogsfrogs>
In-Reply-To: <172230941338.1544199.12238614551925293396.stgit@frogsfrogsfrogs>
References: <172230941338.1544199.12238614551925293396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new package for people who explicilty want self-healing turned
on by default for XFS.  This package is named xfsprogs-self-healing.

Note: This introduces a new "install-selfheal" target to install only
the files needed for enabling online fsck by default.  Other
distributions should take note of the new target if they choose to
create a package for enabling autonomous self healing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Makefile           |    8 +++++++-
 copy/Makefile      |    2 ++
 db/Makefile        |    2 ++
 debian/Makefile    |    2 ++
 debian/control     |    8 ++++++++
 debian/rules       |   13 +++++++++----
 doc/Makefile       |    3 +++
 estimate/Makefile  |    2 ++
 fsck/Makefile      |    3 +++
 fsr/Makefile       |    2 ++
 growfs/Makefile    |    2 ++
 include/Makefile   |    3 +++
 io/Makefile        |    2 ++
 libfrog/Makefile   |    2 ++
 libhandle/Makefile |    2 ++
 libxcmd/Makefile   |    2 ++
 libxfs/Makefile    |    3 +++
 libxlog/Makefile   |    2 ++
 logprint/Makefile  |    2 ++
 m4/Makefile        |    2 ++
 man/Makefile       |    2 ++
 mdrestore/Makefile |    2 ++
 mkfs/Makefile      |    2 ++
 po/Makefile        |    3 +++
 quota/Makefile     |    2 ++
 repair/Makefile    |    2 ++
 rtcp/Makefile      |    2 ++
 scrub/Makefile     |   12 ++++++++++--
 spaceman/Makefile  |    2 ++
 29 files changed, 89 insertions(+), 7 deletions(-)


diff --git a/Makefile b/Makefile
index 44b6c3501539..4bd792d191be 100644
--- a/Makefile
+++ b/Makefile
@@ -116,7 +116,7 @@ configure: configure.ac
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS
 
-install: install-pkg
+install: install-pkg install-selfheal
 
 install-pkg: $(addsuffix -install-pkg,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
@@ -124,6 +124,8 @@ install-pkg: $(addsuffix -install-pkg,$(SUBDIRS))
 
 install-dev: $(addsuffix -install-dev,$(SUBDIRS))
 
+install-selfheal: $(addsuffix -install-selfheal,$(SUBDIRS))
+
 %-install-pkg:
 	@echo "Installing $@"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-pkg
@@ -132,6 +134,10 @@ install-dev: $(addsuffix -install-dev,$(SUBDIRS))
 	@echo "Installing $@"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-dev
 
+%-install-selfheal:
+	@echo "Installing $@"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-selfheal
+
 distclean: clean
 	$(Q)rm -f $(LDIRT)
 
diff --git a/copy/Makefile b/copy/Makefile
index 446d38bea576..3013dc2dca27 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -25,4 +25,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/db/Makefile b/db/Makefile
index 91e259044beb..839c51f03593 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -91,4 +91,6 @@ install-pkg: default
 	$(INSTALL) -m 755 xfs_metadump.sh $(PKG_SBIN_DIR)/xfs_metadump
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/debian/Makefile b/debian/Makefile
index f6a996e91871..104d7c5d76d9 100644
--- a/debian/Makefile
+++ b/debian/Makefile
@@ -36,3 +36,5 @@ ifeq ($(PKG_DISTRIBUTION), debian)
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 $(BOOT_MKFS_BIN) $(PKG_SBIN_DIR)/mkfs.xfs
 endif
+
+install-selfheal: default
diff --git a/debian/control b/debian/control
index 31773e53a19a..aa7a920a7964 100644
--- a/debian/control
+++ b/debian/control
@@ -27,6 +27,14 @@ Description: Utilities for managing the XFS filesystem
  Refer to the documentation at https://xfs.wiki.kernel.org/
  for complete details.
 
+Package: xfsprogs-self-healing
+Depends: ${shlibs:Depends}, ${misc:Depends}, xfsprogs, systemd, udev
+Architecture: linux-any
+Description: Automatic self healing for the XFS filesystem
+ A set of background services for the XFS filesystem to make it
+ find and fix corruptions automatically.  These services are activated
+ automatically upon installation of this package.
+
 Package: xfslibs-dev
 Section: libdevel
 Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0), ${misc:Depends}
diff --git a/debian/rules b/debian/rules
index e4eb2499e768..c49aefd10e64 100755
--- a/debian/rules
+++ b/debian/rules
@@ -14,6 +14,7 @@ endif
 package = xfsprogs
 develop = xfslibs-dev
 bootpkg = xfsprogs-udeb
+healpkg = xfsprogs-self-healing
 
 DEB_BUILD_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_BUILD_GNU_TYPE)
 DEB_HOST_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_HOST_GNU_TYPE)
@@ -26,9 +27,11 @@ udebpkg = $(bootpkg)_$(version)_$(target).udeb
 dirme  = debian/$(package)
 dirdev = debian/$(develop)
 dirdi  = debian/$(bootpkg)
-pkgme  = DIST_ROOT=`pwd`/$(dirme);  export DIST_ROOT;
-pkgdev = DIST_ROOT=`pwd`/$(dirdev); export DIST_ROOT;
-pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
+dirheal= debian/$(healpkg)
+pkgme  = DIST_ROOT=`pwd`/$(dirme);   export DIST_ROOT;
+pkgdev = DIST_ROOT=`pwd`/$(dirdev);  export DIST_ROOT;
+pkgdi  = DIST_ROOT=`pwd`/$(dirdi);   export DIST_ROOT;
+pkgheal= DIST_ROOT=`pwd`/$(dirheal); export DIST_ROOT;
 stdenv = @GZIP=-q; export GZIP;
 
 configure_options = \
@@ -103,6 +106,7 @@ binary-arch: checkroot built
 	$(pkgme)  $(MAKE) -C . install-pkg
 	$(pkgdev) $(MAKE) -C . install-dev
 	$(pkgdi)  $(MAKE) -C debian install-d-i
+	$(pkgheal) $(MAKE) -C . install-selfheal
 	$(pkgme)  $(MAKE) dist
 	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
@@ -114,7 +118,8 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
-	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
+	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice
+	dh_installsystemd -p xfsprogs-self-healing --no-restart-after-upgrade --no-stop-on-upgrade xfs_scrub_all.timer
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol
diff --git a/doc/Makefile b/doc/Makefile
index ad6749b8d0be..a6ec65f5edc0 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -26,3 +26,6 @@ ifeq ($(PKG_DISTRIBUTION), debian)
 endif
 
 install-dev:
+
+install-selfheal:
+
diff --git a/estimate/Makefile b/estimate/Makefile
index d5f8a6d81d65..4fce3463d55c 100644
--- a/estimate/Makefile
+++ b/estimate/Makefile
@@ -19,4 +19,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/fsck/Makefile b/fsck/Makefile
index ccba7f0b6892..33fca9e18fb0 100644
--- a/fsck/Makefile
+++ b/fsck/Makefile
@@ -17,3 +17,6 @@ install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 xfs_fsck.sh $(PKG_SBIN_DIR)/fsck.xfs
 install-dev:
+
+install-selfheal:
+
diff --git a/fsr/Makefile b/fsr/Makefile
index 3ad9f6d824c6..da32bc531970 100644
--- a/fsr/Makefile
+++ b/fsr/Makefile
@@ -22,4 +22,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/growfs/Makefile b/growfs/Makefile
index e0ab870bd6ba..61d184328cf6 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -30,4 +30,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/include/Makefile b/include/Makefile
index 23727fccfdcd..c18ab35a9861 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -64,3 +64,6 @@ install-pkg: default
 
 install-dev: install
 	$(INSTALL) -m 644 $(HFILES) $(PKG_INC_DIR)
+
+install-selfheal:
+
diff --git a/io/Makefile b/io/Makefile
index d035420b555c..70c95a5c1425 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -95,4 +95,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 xfs_mkfile.sh $(PKG_SBIN_DIR)/xfs_mkfile
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 5ebe36fb58c8..262a4a0f8cda 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -81,4 +81,6 @@ include $(BUILDRULES)
 
 install install-pkg install-dev: default
 
+install-selfheal:
+
 -include .ltdep
diff --git a/libhandle/Makefile b/libhandle/Makefile
index 7cfd0fa4f27e..28c104a77f95 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -27,4 +27,6 @@ install-pkg: default
 install-dev: default
 	$(INSTALL_LTLIB_DEV)
 
+install-selfheal:
+
 -include .ltdep
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index afd5349c8af3..118ecd3cfc88 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -25,4 +25,6 @@ include $(BUILDRULES)
 
 install install-pkg install-dev: default
 
+install-selfheal:
+
 -include .ltdep
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 2c6b45953661..65d4c7619758 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -162,3 +162,6 @@ install-dev: install
 ifndef NODEP
 -include .ltdep
 endif
+
+install-selfheal:
+
diff --git a/libxlog/Makefile b/libxlog/Makefile
index 3710729fe703..37281eb058f2 100644
--- a/libxlog/Makefile
+++ b/libxlog/Makefile
@@ -23,4 +23,6 @@ include $(BUILDRULES)
 
 install install-pkg install-dev: default
 
+install-selfheal:
+
 -include .ltdep
diff --git a/logprint/Makefile b/logprint/Makefile
index 5ec02539a7bb..f1fccbdc8ca7 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -28,4 +28,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/m4/Makefile b/m4/Makefile
index eda4c06f6864..b894dd3b0222 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -35,5 +35,7 @@ include $(BUILDRULES)
 
 install install-pkg install-dev install-lib: default
 
+install-selfheal:
+
 realclean: distclean
 	rm -f $(CONFIGURE)
diff --git a/man/Makefile b/man/Makefile
index f62286e8339d..258e8732a923 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -21,4 +21,6 @@ install-dev : $(addsuffix -install-dev,$(SUBDIRS))
 %-install-dev:
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-dev
 
+install-selfheal:
+
 include $(BUILDRULES)
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index 0d02fb383404..c75d5875929b 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -23,4 +23,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/mkfs/Makefile b/mkfs/Makefile
index cf945aa10c25..515c2db0639d 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -37,4 +37,6 @@ install-pkg: default
 
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/po/Makefile b/po/Makefile
index 3cc0b4177c64..cb6ef954b695 100644
--- a/po/Makefile
+++ b/po/Makefile
@@ -25,3 +25,6 @@ install-pkg: default
 	$(INSTALL_LINGUAS)
 
 install-dev install-lib:
+
+install-selfheal:
+
diff --git a/quota/Makefile b/quota/Makefile
index 01584635b3dd..e1193bd203ad 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -30,4 +30,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/repair/Makefile b/repair/Makefile
index 096ae8c6a5b1..e7979a817d4f 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -113,4 +113,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/rtcp/Makefile b/rtcp/Makefile
index 4adb58c4b783..ac638bcd1029 100644
--- a/rtcp/Makefile
+++ b/rtcp/Makefile
@@ -23,4 +23,6 @@ install-pkg: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+install-selfheal:
+
 -include .dep
diff --git a/scrub/Makefile b/scrub/Makefile
index b0022cb7f005..2c349c682d3a 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -20,6 +20,7 @@ XFS_SCRUB_ARGS = -p
 XFS_SCRUB_SERVICE_ARGS = -b -o fsprops_advise
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
+INSTALL_SELFHEAL += install-systemd-selfheal
 SYSTEMD_SERVICES=\
 	$(scrub_svcname) \
 	xfs_scrub_fail@.service \
@@ -27,9 +28,10 @@ SYSTEMD_SERVICES=\
 	xfs_scrub_media_fail@.service \
 	xfs_scrub_all.service \
 	xfs_scrub_all_fail.service \
-	xfs_scrub_all.timer \
 	system-xfs_scrub.slice
-OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
+SYSTEMD_SERVICES_SELFHEAL=\
+	xfs_scrub_all.timer
+OPTIONAL_TARGETS += $(SYSTEMD_SERVICES) $(SYSTEMD_SERVICES_SELFHEAL)
 endif
 ifeq ($(HAVE_CROND),yes)
 INSTALL_SCRUB += install-crond
@@ -163,6 +165,10 @@ install-systemd: default $(SYSTEMD_SERVICES)
 	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
 	$(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(PKG_LIBEXEC_DIR)
 
+install-systemd-selfheal: default $(SYSTEMD_SERVICES_SELFHEAL)
+	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
+	$(INSTALL) -m 644 $(SYSTEMD_SERVICES_SELFHEAL) $(SYSTEMD_SYSTEM_UNIT_DIR)
+
 install-crond: default $(CRONTABS)
 	$(INSTALL) -m 755 -d $(CROND_DIR)
 	$(INSTALL) -m 644 $(CRONTABS) $(CROND_DIR)
@@ -181,4 +187,6 @@ install-udev: $(UDEV_RULES)
 
 install-dev:
 
+install-selfheal: $(INSTALL_SELFHEAL)
+
 -include .dep
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 49fbc9290c02..ce1650f99b7c 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -47,4 +47,6 @@ install-pkg: default
 	$(INSTALL) -m 755 xfs_property $(PKG_SBIN_DIR)/xfs_property
 install-dev:
 
+install-selfheal:
+
 -include .dep

