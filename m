Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB8B10E9
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831223; cv=none; b=ipSuHfjXcXfQvGdyK48/1t/qXB7gh5hB+xB/KYLgxpIq2nhRK5DM9ShRe0Liy4KdzU5MBO0a6rvLyirs5esdGC4Flg056VNRowuRgvAAEw04IgU+qyy83yx3vMnylbClysyI+YQj5uGU2YNABvsoxl0mSrrun0fy5NrAcZE0fNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831223; c=relaxed/simple;
	bh=XehaY6yEVm6m3AQRPZ23obtBTsCBQrhqgJhhBUQyRos=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JEA2cGTiGx8EFTD35kH/tH4XqxtWxG+gE+j9scamTQi5VahqmNxlbcksXy7vnN+UvRIvvej53IR+g81slWmVIodB/tu6tUD0vMfTHjT57q8/Dc8lLKl2hMQkuxSkwXmoq9P0qrcMxAQtB4oP4IzFTFRTqtU3dPjZOKq2rR6lMcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4dL7Jyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4dL7Jyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BDDC4CEC6;
	Wed,  2 Oct 2024 01:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831223;
	bh=XehaY6yEVm6m3AQRPZ23obtBTsCBQrhqgJhhBUQyRos=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E4dL7JydkEnf9ZfYZddg6i3vGe0sKNNGIJ6t6FMSoz6WwZQGSVSxKnk3upNcZiPav
	 ukaE/Jgo3+T7br2gDauPhf07hbpn3ULgvUXWB5utKcVGHRDXXLjHWgme7cPw++3qXf
	 UH01EiMnvS0+nz3TFng0Sb0f6TNuFC3ZgTrYSPKWohKlUDdpjAMtokQv4gJL2Q8HRw
	 b3ARBujuYly2TktOj3Nul4+U2CA8J85weZWSNfCEkmRJ5FVvCllgC2DTaaKYq8yZXN
	 /SXtY+s3WlBGUXftUdIEsKtnjwYIWoX9ktLJ+phsKu+cnibKuZ/vutUhyB0zyz96rN
	 1py+nJxefRY0g==
Date: Tue, 01 Oct 2024 18:07:02 -0700
Subject: [PATCH 5/6] debian: Modernize build script
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Zixing Liu <zixing.liu@canonical.com>, Bastian Germann <bage@debian.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172783101044.4034333.11643454184890386095.stgit@frogsfrogsfrogs>
In-Reply-To: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
References: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Bastian Germann <bage@debian.org>

- Use autoreconf template, this will now properly installs the
  translation files
- Use $(CURDIR) to replace `pwd` syntax

Link: https://bugs.launchpad.net/ubuntu/+source/xfsprogs/+bug/2076309
Suggested-by: Zixing Liu <zixing.liu@canonical.com>
Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |   80 +++++++++++++++++++---------------------------------------
 1 file changed, 26 insertions(+), 54 deletions(-)


diff --git a/debian/rules b/debian/rules
index 98dafcab8..7c9f90e6c 100755
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
 
-binary-indep:
-
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
+
+override_dh_installdocs:
 	dh_installdocs -XCHANGES
-	dh_installchangelogs
-	dh_strip
-	dh_compress
-	dh_fixperms
-	dh_makeshlibs
+
+override_dh_installsystemd:
 	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer
-	dh_installdeb
-	dh_shlibdeps
-	dh_gencontrol
-	dh_md5sums
-	dh_builddeb
-
-binary: binary-indep binary-arch
-
-checkroot:
-	test 0 -eq `id -u`
-
-.PHONY: binary binary-arch binary-indep clean checkroot

