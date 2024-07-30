Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921451854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309756; cv=none; b=apn0pjAOua4C0cuDLGJskqxATA9KmQiiianfkN23Oax1MZLfGaJzAK9YOy89q+Wo6TC4nj4UEP3VlTKHzN/rB21Rwo4bh4DNPfXtmStpYqMfx3NSYFiidEFYz0sj9Kv/5MbZUZJY38LpSqeME4ww3iJAsl+9KjpjclavH50nHXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309756; c=relaxed/simple;
	bh=788UmdEQaMWPxdDo3XXhYSK4J9wDXK/ZIY/oh08sMD8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dMkrVADhSWK1UThZpzz+q93IuJg56Mc/Ns6ifzBoUI5Za8bud6Nsr7oDG9LFbGIAV6dSc1BvNAHVyOnMzwMrr1ZExAJNSOD/PQosc1oHybCB4p5ix1kQlQh3PaVnrk7JydV1Wt2wlWAKetMEnBNRvSJpHd5IhyqCPRTxFNW+/6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PtzL8MZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtzL8MZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18316C32786;
	Tue, 30 Jul 2024 03:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309756;
	bh=788UmdEQaMWPxdDo3XXhYSK4J9wDXK/ZIY/oh08sMD8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PtzL8MZsv1fAMNJQvdiuFjfHwIVnFsVV+PFU8P4Da90rxW1cbaxa+9b1wkkMU0/WS
	 yl4mcNr95AlW9NB8lmdFIngGYGJeph5n2pTmnjJxJ24vjHBuZJ2qtbOXIxp1TLISh4
	 S4X6aFaM/tK4luzjXTzdFUMsNXoFRftca/64nYWsqIiG+52lowj2UVd0/gMblquM1U
	 r9spy83WS2kt5ZvVjd1bZcK82wbn6qaUOWzfomx6VeG2qPGwHd6xy9G8kcd2k96IFL
	 936JkZRsdtz/mu5Wraa/idyk0Il3sfH3Cp30ep18nQPO1P42Yu0B30E4ShJMS/ScxS
	 9PrSaUyvmX9QQ==
Date: Mon, 29 Jul 2024 20:22:35 -0700
Subject: [PATCH 1/3] misc: shift install targets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230941358.1544199.8764965060997616615.stgit@frogsfrogsfrogs>
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

Modify each Makefile so that "install-pkg" installs the main package
contents, and "install" just invokes "install-pkg".  We'll need this
indirection for the next patch where we add an install-selfheal target
to build the xfsprogs-self-healing package but will still want 'make
install' to install everything on a developer's workstation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Makefile           |    8 +++++---
 copy/Makefile      |    4 +++-
 db/Makefile        |    4 +++-
 debian/Makefile    |    4 +++-
 debian/rules       |    2 +-
 doc/Makefile       |    4 +++-
 estimate/Makefile  |    4 +++-
 fsck/Makefile      |    4 +++-
 fsr/Makefile       |    4 +++-
 growfs/Makefile    |    4 +++-
 include/Makefile   |    4 +++-
 io/Makefile        |    4 +++-
 libfrog/Makefile   |    2 +-
 libhandle/Makefile |    4 +++-
 libxcmd/Makefile   |    2 +-
 libxfs/Makefile    |    4 +++-
 libxlog/Makefile   |    2 +-
 logprint/Makefile  |    4 +++-
 m4/Makefile        |    2 +-
 man/Makefile       |    8 +++++---
 man/man2/Makefile  |    4 +++-
 man/man3/Makefile  |    4 +++-
 man/man5/Makefile  |    5 ++++-
 man/man8/Makefile  |    4 +++-
 mdrestore/Makefile |    4 +++-
 mkfs/Makefile      |    4 +++-
 po/Makefile        |    4 +++-
 quota/Makefile     |    4 +++-
 repair/Makefile    |    4 +++-
 rtcp/Makefile      |    4 +++-
 scrub/Makefile     |    4 +++-
 spaceman/Makefile  |    4 +++-
 32 files changed, 91 insertions(+), 36 deletions(-)


diff --git a/Makefile b/Makefile
index 4e768526c6fe..44b6c3501539 100644
--- a/Makefile
+++ b/Makefile
@@ -116,15 +116,17 @@ configure: configure.ac
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS
 
-install: $(addsuffix -install,$(SUBDIRS))
+install: install-pkg
+
+install-pkg: $(addsuffix -install-pkg,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 README $(PKG_DOC_DIR)
 
 install-dev: $(addsuffix -install-dev,$(SUBDIRS))
 
-%-install:
+%-install-pkg:
 	@echo "Installing $@"
-	$(Q)$(MAKE) $(MAKEOPTS) -C $* install
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-pkg
 
 %-install-dev:
 	@echo "Installing $@"
diff --git a/copy/Makefile b/copy/Makefile
index 55160f848225..446d38bea576 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -18,7 +18,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/db/Makefile b/db/Makefile
index 83389376c36c..91e259044beb 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -81,7 +81,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 xfs_admin.sh $(PKG_SBIN_DIR)/xfs_admin
diff --git a/debian/Makefile b/debian/Makefile
index 2f9cd38c2ea6..f6a996e91871 100644
--- a/debian/Makefile
+++ b/debian/Makefile
@@ -15,7 +15,9 @@ default:
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 ifeq ($(PKG_DISTRIBUTION), debian)
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 changelog $(PKG_DOC_DIR)/changelog.Debian
diff --git a/debian/rules b/debian/rules
index 69a79fc67405..e4eb2499e768 100755
--- a/debian/rules
+++ b/debian/rules
@@ -100,7 +100,7 @@ binary-arch: checkroot built
 	@echo "== dpkg-buildpackage: binary-arch" 1>&2
 	$(checkdir)
 	-rm -rf $(dirme) $(dirdev) $(dirdi)
-	$(pkgme)  $(MAKE) -C . install
+	$(pkgme)  $(MAKE) -C . install-pkg
 	$(pkgdev) $(MAKE) -C . install-dev
 	$(pkgdi)  $(MAKE) -C debian install-d-i
 	$(pkgme)  $(MAKE) dist
diff --git a/doc/Makefile b/doc/Makefile
index 83dfa38bedd1..ad6749b8d0be 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -16,7 +16,9 @@ CHANGES.gz:
 	@echo "    [ZIP]    $@"
 	$(Q)$(ZIP) --best -c < CHANGES > $@
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 CHANGES.gz CREDITS $(PKG_DOC_DIR)
 ifeq ($(PKG_DISTRIBUTION), debian)
diff --git a/estimate/Makefile b/estimate/Makefile
index 1080129b3a62..d5f8a6d81d65 100644
--- a/estimate/Makefile
+++ b/estimate/Makefile
@@ -12,7 +12,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/fsck/Makefile b/fsck/Makefile
index 5ca529f53e42..ccba7f0b6892 100644
--- a/fsck/Makefile
+++ b/fsck/Makefile
@@ -11,7 +11,9 @@ default: $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 xfs_fsck.sh $(PKG_SBIN_DIR)/fsck.xfs
 install-dev:
diff --git a/fsr/Makefile b/fsr/Makefile
index d57f2de24c22..3ad9f6d824c6 100644
--- a/fsr/Makefile
+++ b/fsr/Makefile
@@ -15,7 +15,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/growfs/Makefile b/growfs/Makefile
index 2f4cc66a76f3..e0ab870bd6ba 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -23,7 +23,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/include/Makefile b/include/Makefile
index f7c40a5ce1a1..23727fccfdcd 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -57,7 +57,9 @@ install-headers: $(addsuffix -hdrs, $(DKHFILES) $(HFILES))
 %-hdrs:
 	$(Q)$(LN_S) -f $(CURDIR)/$* xfs/$*
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 
 install-dev: install
diff --git a/io/Makefile b/io/Makefile
index 3192b813c740..d035420b555c 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -85,7 +85,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 xfs_bmap.sh $(PKG_SBIN_DIR)/xfs_bmap
diff --git a/libfrog/Makefile b/libfrog/Makefile
index acddc894ee93..5ebe36fb58c8 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -79,6 +79,6 @@ crc32table.h: gen_crc32table.c crc32defs.h
 
 include $(BUILDRULES)
 
-install install-dev: default
+install install-pkg install-dev: default
 
 -include .ltdep
diff --git a/libhandle/Makefile b/libhandle/Makefile
index f297a59e47f9..7cfd0fa4f27e 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -19,7 +19,9 @@ default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL_LTLIB)
 
 install-dev: default
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index 70e54308c34b..afd5349c8af3 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -23,6 +23,6 @@ default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
-install install-dev: default
+install install-pkg install-dev: default
 
 -include .ltdep
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 2f2791cae587..2c6b45953661 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -140,7 +140,9 @@ default: ltdepend $(LTLIBRARY)
 # set up include/xfs header directory
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 
 install-headers: $(addsuffix -hdrs, $(PKGHFILES))
diff --git a/libxlog/Makefile b/libxlog/Makefile
index b0f5ef154133..3710729fe703 100644
--- a/libxlog/Makefile
+++ b/libxlog/Makefile
@@ -21,6 +21,6 @@ default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
-install install-dev: default
+install install-pkg install-dev: default
 
 -include .ltdep
diff --git a/logprint/Makefile b/logprint/Makefile
index bbbed5d259af..5ec02539a7bb 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -21,7 +21,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/m4/Makefile b/m4/Makefile
index 84174c3d3e30..eda4c06f6864 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -33,7 +33,7 @@ default:
 
 include $(BUILDRULES)
 
-install install-dev install-lib: default
+install install-pkg install-dev install-lib: default
 
 realclean: distclean
 	rm -f $(CONFIGURE)
diff --git a/man/Makefile b/man/Makefile
index cd1aed6cf202..f62286e8339d 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -9,12 +9,14 @@ SUBDIRS = man2 man3 man5 man8
 
 default : $(SUBDIRS)
 
-install : $(addsuffix -install,$(SUBDIRS))
+install : install-pkg
+
+install-pkg : $(addsuffix -install-pkg,$(SUBDIRS))
 
 install-dev : $(addsuffix -install-dev,$(SUBDIRS))
 
-%-install:
-	$(Q)$(MAKE) $(MAKEOPTS) -C $* install
+%-install-pkg:
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-pkg
 
 %-install-dev:
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-dev
diff --git a/man/man2/Makefile b/man/man2/Makefile
index 8aecde3321b0..190ea18e7c6c 100644
--- a/man/man2/Makefile
+++ b/man/man2/Makefile
@@ -15,7 +15,9 @@ default : $(MAN_PAGES)
 
 include $(BUILDRULES)
 
-install :
+install : install-pkg
+
+install-pkg :
 
 install-dev : default
 	$(INSTALL) -m 755 -d $(MAN_DEST)
diff --git a/man/man3/Makefile b/man/man3/Makefile
index a7f607fcbad9..1553e2b2de82 100644
--- a/man/man3/Makefile
+++ b/man/man3/Makefile
@@ -15,7 +15,9 @@ default : $(MAN_PAGES)
 
 include $(BUILDRULES)
 
-install :
+install : install-pkg
+
+install-pkg :
 
 install-dev : default
 	$(INSTALL) -m 755 -d $(MAN_DEST)
diff --git a/man/man5/Makefile b/man/man5/Makefile
index fe0aef6f016b..1fcd3995036f 100644
--- a/man/man5/Makefile
+++ b/man/man5/Makefile
@@ -15,7 +15,10 @@ default : $(MAN_PAGES)
 
 include $(BUILDRULES)
 
-install : default
+install : install-pkg
+
+install-pkg : default
 	$(INSTALL) -m 755 -d $(MAN_DEST)
 	$(INSTALL_MAN)
+
 install-dev :
diff --git a/man/man8/Makefile b/man/man8/Makefile
index 5be76ab727a1..0b40a409a913 100644
--- a/man/man8/Makefile
+++ b/man/man8/Makefile
@@ -22,7 +22,9 @@ default : $(MAN_PAGES)
 
 include $(BUILDRULES)
 
-install : default
+install : install-pkg
+
+install-pkg : default
 	$(INSTALL) -m 755 -d $(MAN_DEST)
 	$(INSTALL_MAN)
 
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index 4a932efb8098..0d02fb383404 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -16,7 +16,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/mkfs/Makefile b/mkfs/Makefile
index a6173083e4c2..cf945aa10c25 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -27,7 +27,9 @@ default: depend $(LTCOMMAND) $(CFGFILES)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(MKFS_CFG_DIR)
diff --git a/po/Makefile b/po/Makefile
index 1d35f5191ba2..3cc0b4177c64 100644
--- a/po/Makefile
+++ b/po/Makefile
@@ -19,7 +19,9 @@ default: $(POTHEAD) $(LINGUAS:%=%.mo)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL_LINGUAS)
 
 install-dev install-lib:
diff --git a/quota/Makefile b/quota/Makefile
index da5a1489e468..01584635b3dd 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -23,7 +23,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/repair/Makefile b/repair/Makefile
index a36a95e353a5..096ae8c6a5b1 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -106,7 +106,9 @@ include $(BUILDRULES)
 #
 #CFLAGS += ...
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/rtcp/Makefile b/rtcp/Makefile
index 264b4f27b5fd..4adb58c4b783 100644
--- a/rtcp/Makefile
+++ b/rtcp/Makefile
@@ -16,7 +16,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
diff --git a/scrub/Makefile b/scrub/Makefile
index 885b43e9948d..653aafd171b5 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -138,7 +138,9 @@ phase5.o unicrash.o xfs.o: $(builddefs)
 
 include $(BUILDRULES)
 
-install: $(INSTALL_SCRUB)
+install: install-pkg
+
+install-pkg: $(INSTALL_SCRUB)
 
 %.service: %.service.in $(builddefs)
 	@echo "    [SED]    $@"
diff --git a/spaceman/Makefile b/spaceman/Makefile
index e914b921de8b..49fbc9290c02 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -38,7 +38,9 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install: default
+install: install-pkg
+
+install-pkg: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 xfs_info.sh $(PKG_SBIN_DIR)/xfs_info

