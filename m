Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7B51BA89A
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726670215; cv=none; b=Rm5l60M++G/Z+Gjr0eG1iPNGDf3QhP0leO8B7yt9KeTIIaz4BcSI126aSm7N+WANNa7zWWRjw4ZwnQO5VCl9sxq+v0ab4rRjTYi7+qE1EtMZDLogiwt8ry/P1rKH59+flXdq5EwYxmwgtGjKOwIrOeiXyu+0hWr2wNDcLaun/j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726670215; c=relaxed/simple;
	bh=7cJETE/FWGwB9mhDYDhov7m8jPn+WmutoTPete8x4VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCppgUo+tA9/4hcAia3R13MKu0l3ESoCIMX/p9/RTua1ILMF2JI1FROSd7AQKa6fzYbubaiRhW/ZR1afJuQ7WIO1bv++JU3m8crKMkao0fxqHOQUoB13reZoNCyy1Lrukf7Eo9hPtpB07XpjBjAEYtYdaRdX2NMR2MOE5AvS1cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=DAPaVDxD; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="DAPaVDxD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=2ao/OHFG6lqd0d2R12Su+jBwyUMIomLZjPuqa8S7WNo=; b=DAPaVDxD7f4mMmGKAY5lFDg9/D
	ro261bgdXWBgv1B7lipsk4MnhvLoVzwRbugk8pOV7R8FSCkbA4/9cU4/1QQsT+Hm3ScXhFTqXpysw
	UhkK1/pYtNw1FfM0ObYzxRfjF9yLT2bP1K7kiASNoW/dcifn685AWG3VWiIm+rbEmqlA0Aee2VCXU
	IFPFwwX5rq/zXkGqz0tjJ5YCwlT5RnzBxdXXEZIrWO88/zpQjIF63EOfVmv/OiTilYIBa3b9pQcZU
	mjPFPZdLgT8Q2wC56Jrb0SBibPg2AUg6xbSLn8XxWLQh5P4py7EsapaO3jNvz9hBzV4iIQm9ems8/
	hEiyKIhg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sqvnR-00B7VF-5f; Wed, 18 Sep 2024 14:36:46 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>,
	Zixing Liu <zixing.liu@canonical.com>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 5/6] debian: Modernize build script
Date: Wed, 18 Sep 2024 16:36:17 +0200
Message-ID: <20240918143640.29981-6-bage@debian.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918143640.29981-1-bage@debian.org>
References: <20240918143640.29981-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

- Use autoreconf template, this will now properly installs the
  translation files
- Use $(CURDIR) to replace `pwd` syntax

Link: https://bugs.launchpad.net/ubuntu/+source/xfsprogs/+bug/2076309
Suggested-by: Zixing Liu <zixing.liu@canonical.com>
Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules | 80 +++++++++++++++++-----------------------------------
 1 file changed, 26 insertions(+), 54 deletions(-)

diff --git a/debian/rules b/debian/rules
index 98dafcab..7c9f90e6 100755
--- a/debian/rules
+++ b/debian/rules
@@ -2,6 +2,8 @@
 
 export DH_VERBOSE=1
 
+export AUTOHEADER=true
+
 ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
     NUMJOBS = $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
     PMAKEFLAGS += -j$(NUMJOBS)
@@ -15,9 +17,7 @@ package = xfsprogs
 develop = xfslibs-dev
 bootpkg = xfsprogs-udeb
 
-DEB_BUILD_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_BUILD_GNU_TYPE)
-DEB_HOST_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_HOST_GNU_TYPE)
-DEB_HOST_MULTIARCH ?= $(shell dpkg-architecture -qDEB_HOST_MULTIARCH)
+include /usr/share/dpkg/architecture.mk
 
 version = $(shell dpkg-parsechangelog | grep ^Version: | cut -d ' ' -f 2 | cut -d '-' -f 1)
 target ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)
@@ -26,9 +26,9 @@ udebpkg = $(bootpkg)_$(version)_$(target).udeb
 dirme  = debian/$(package)
 dirdev = debian/$(develop)
 dirdi  = debian/$(bootpkg)
-pkgme  = DIST_ROOT=`pwd`/$(dirme);  export DIST_ROOT;
-pkgdev = DIST_ROOT=`pwd`/$(dirdev); export DIST_ROOT;
-pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
+pkgme  = DIST_ROOT=$(CURDIR)/$(dirme);  export DIST_ROOT;
+pkgdev = DIST_ROOT=$(CURDIR)/$(dirdev); export DIST_ROOT;
+pkgdi  = DIST_ROOT=$(CURDIR)/$(dirdi); export DIST_ROOT;
 stdenv = @GZIP=-q; export GZIP;
 
 configure_options = \
@@ -42,35 +42,20 @@ configure_options = \
 	--localstatedir=/var
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
-	  INSTALL_USER=root INSTALL_GROUP=root \
+	  INSTALL_USER=root INSTALL_GROUP=root LDFLAGS='$(LDFLAGS)' \
 	  LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-editline=yes --enable-blkid=yes" ;
 diopts  = $(options) \
 	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-gettext=no" ;
-checkdir = test -f debian/rules
 
-build: build-arch build-indep
-build-arch: built
-build-indep: built
-built: dibuild config
-	@echo "== dpkg-buildpackage: build" 1>&2
-	$(MAKE) $(PMAKEFLAGS) default
-	touch built
+%:
+	dh $@
 
-config: .gitcensus
-.gitcensus:
-	@echo "== dpkg-buildpackage: configure" 1>&2
-	$(checkdir)
-	AUTOHEADER=/bin/true dh_autoreconf
-	dh_update_autotools_config
-	# runs configure with $(options)
-	$(options) $(MAKE) $(PMAKEFLAGS) include/builddefs
-	cp -f include/install-sh .
+override_dh_auto_configure:
+	dh_testdir
 	touch .gitcensus
 
-dibuild:
-	$(checkdir)
+override_dh_auto_build:
 	@echo "== dpkg-buildpackage: installer" 1>&2
-	# runs configure with $(options)
 	if [ ! -f mkfs/mkfs.xfs-$(bootpkg) ]; then \
 		$(diopts) $(MAKE) include/builddefs; \
 		mkdir -p include/xfs; \
@@ -83,46 +68,33 @@ dibuild:
 		mv mkfs/mkfs.xfs mkfs/mkfs.xfs-$(bootpkg); \
 		$(MAKE) distclean; \
 	fi
+	@echo "== dpkg-buildpackage: configure" 1>&2
+	# runs configure with $(options)
+	$(options) $(MAKE) $(PMAKEFLAGS) include/builddefs
+	cp -f include/install-sh .
+	@echo "== dpkg-buildpackage: build" 1>&2
+	$(MAKE) $(PMAKEFLAGS) default
 
-clean:
+execute_before_dh_clean:
 	@echo "== dpkg-buildpackage: clean" 1>&2
-	$(checkdir)
+	dh_testdir
 	-rm -f built .gitcensus mkfs/mkfs.xfs-$(bootpkg)
 	$(MAKE) distclean
 	-rm -rf $(dirme) $(dirdev) $(dirdi)
-	-rm -f debian/*substvars debian/files* debian/*.debhelper
-	dh_autoreconf_clean
-	dh_clean
-
-binary-indep:
 
-binary-arch: checkroot built
+override_dh_auto_install:
 	@echo "== dpkg-buildpackage: binary-arch" 1>&2
-	$(checkdir)
 	-rm -rf $(dirme) $(dirdev) $(dirdi)
+	dh_testdir
 	$(pkgme)  $(MAKE) -C . install
 	$(pkgdev) $(MAKE) -C . install-dev
 	$(pkgdi)  $(MAKE) -C debian install-d-i
 	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
-	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
 	rm -f debian/xfslibs-dev/usr/lib/$(DEB_HOST_MULTIARCH)/libhandle.la
 	rm -f debian/xfslibs-dev/usr/lib/$(DEB_HOST_MULTIARCH)/libhandle.a
-	dh_installdocs -XCHANGES
-	dh_installchangelogs
-	dh_strip
-	dh_compress
-	dh_fixperms
-	dh_makeshlibs
-	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer
-	dh_installdeb
-	dh_shlibdeps
-	dh_gencontrol
-	dh_md5sums
-	dh_builddeb
-
-binary: binary-indep binary-arch
 
-checkroot:
-	test 0 -eq `id -u`
+override_dh_installdocs:
+	dh_installdocs -XCHANGES
 
-.PHONY: binary binary-arch binary-indep clean checkroot
+override_dh_installsystemd:
+	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer
-- 
2.45.2

