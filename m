Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6771EACD
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178372; cv=none; b=itnWeKaGJlUKa35yiWQ4gWWpDFmwtFDmLB94sJRj70K1W6AaAZ1gmTcM0kn8t2P8YJYiEqMJVSLT09rWe+d/emEGCOvcRRg00ANygF+2nBqPzFXOmzRX2BRey3Z1S2c/MDnYQVzaKuZqO3mvDB59nfNbDUO7Qpjm6HEp8YkoVy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178372; c=relaxed/simple;
	bh=AMUKvjmFJHqide711LtU+4gCDGhXzqwtLS1j64D60fs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KxUOe6wetKRoIKyKW2pVHqfSPDE8PeRvyFCRIFuw7vPaxxRKHkNw+LL2AsVuAfE3shNtoIgjdghSikUiU3PlzCHv3CChby/sH7OSgfmEretVI56f43rLhEXm+0tstntrU054ZJbBxV5w3QWUDGMog+LrSg/R3zR5eZSkzNCo7Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jaldSDqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jaldSDqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18055C4CEE7;
	Thu, 23 Oct 2025 00:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178372;
	bh=AMUKvjmFJHqide711LtU+4gCDGhXzqwtLS1j64D60fs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jaldSDqcTNFTYwuzDDOVb/yLxuf9knQDwj9x0e3+KZhin1UX17FCbxWk1GykO8T9/
	 DJJ4fHl4aII6mG4gOkSPfCl9qjtrVONQafiA1N+pe7auge2iHWKEhzkxo7Ucp7okB0
	 P/mzi7jREOo8FxYWaVzaUObq89/X638ZGrphyYUOfbhbja5BlX8L6j436Uhdn0h/BF
	 vVU8RiZGCwAIYUEIZtehl7KNoU2yt3/4UbgefJhAWlZxqIJdEO4JZI/W4WWBE2G5aw
	 fwFCZ7F49otrCkFDx6kF6XI0VKYT5rqW0t44uexLzqSoBFsbt5Y1HeludV059NY/al
	 B2ysRorcsRsHQ==
Date: Wed, 22 Oct 2025 17:12:51 -0700
Subject: [PATCH 02/19] xfs_healer: enable gettext for localization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748294.1029045.12901696920449153691.stgit@frogsfrogsfrogs>
In-Reply-To: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
References: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Include gettext-rs in our Rust application if the builder wants
localization.  It's not clear to me what we're really supposed to use to
localize Rust programs, but xfsprogs uses gettext so let's just plug
into that for now.  Note that xgettext prior to 0.24 doesn't technically
support Rust, but it matches patterns well enough to extract simple
format strings (e.g. M_("hello")) despite the warnings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac              |   13 ++++++++++++-
 healer/Cargo.toml.in      |   15 +++++++++++++++
 healer/Makefile           |   16 ++++++++++++++++
 healer/src/main.rs        |    4 +++-
 healer/src/xfsprogs.rs.in |   20 ++++++++++++++++++++
 include/builddefs.in      |    1 +
 include/buildrules        |    1 +
 m4/package_rust.m4        |    6 ++++++
 8 files changed, 74 insertions(+), 2 deletions(-)


diff --git a/configure.ac b/configure.ac
index 2902fe9ca2227e..4cb253592ce09b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -143,6 +143,17 @@ AC_ARG_ENABLE(crate-checks,
 	enable_crate_checks=yes)
 AC_SUBST(enable_crate_checks)
 
+# Some distributions do not package gettext-rs; provide a way to disable it
+# for Rust without disabling it for the C programs.
+AC_ARG_ENABLE(gettext-rs,
+[  --enable-gettext-rs=[yes/no]   Enable gettext-rs support if gettext is enabled],,
+	enable_gettext_rs="$enable_gettext")
+# If the main gettext is not enabled, then we don't want the Rust version.
+if test "$enable_gettext" = "no"; then
+	enable_gettext_rs="no"
+fi
+AC_SUBST(enable_gettext_rs)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
@@ -163,7 +174,7 @@ test -n "$multiarch" && enable_lib64=no
 # to "find" is required, to avoid including such directories in the
 # list.
 LOCALIZED_FILES=""
-for lfile in `find ${srcdir} -path './.??*' -prune -o -name '*.c' -print -o -name '*.py.in' -print || exit 1`; do
+for lfile in `find ${srcdir} -path './.??*' -prune -o -name '*.c' -print -o -name '*.py.in' -print -o -name '*.rs' -print || exit 1`; do
     LOCALIZED_FILES="$LOCALIZED_FILES \$(TOPDIR)/$lfile"
 done
 AC_SUBST(LOCALIZED_FILES)
diff --git a/healer/Cargo.toml.in b/healer/Cargo.toml.in
index bbd6f930510059..e62480ff17d58e 100644
--- a/healer/Cargo.toml.in
+++ b/healer/Cargo.toml.in
@@ -9,7 +9,22 @@ lto = @cargo_lto@
 [profile.release]
 lto = @cargo_lto@
 
+[features]
+@cargo_cmt_gettext@gettext = ["dep:gettext-rs"]
+
 # Be sure to update AC_HAVE_HEALER_CRATES if you update the dependency list.
 [dependencies]
 clap = { version = "4.0.32", features = ["derive"] }
 anyhow = { version = "1.0.69" }
+
+# XXX: Crates with major version 0 are not considered ABI-stable, so the minor
+# version is treated as if it were the major version.  This creates problems
+# pulling in distro-packaged crates, so we only specify the dependency as major
+# version 0.  Until these crates reach 1.0.0, we'll have to patch when things
+# break.  Ref:
+# https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html
+
+# Dynamically comment out all the gettextrs related dependency information in
+# Cargo.toml becuse cargo requires the crate to be present so that it can
+# generate a Cargo.lock file even if the build never uses it.
+@cargo_cmt_gettext@gettext-rs = { version = "0", optional = true }	# 0.7.0
diff --git a/healer/Makefile b/healer/Makefile
index 4c97430b26bd42..ae248bc984b178 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -44,6 +44,19 @@ else
 	CARGO_INSTALL_FLAGS=--debug
 endif
 
+# Enable gettext if it's available
+ifeq ($(ENABLE_GETTEXT_RS),yes)
+CARGO_BUILD_FLAGS+=--features gettext
+CARGO_CLIPPY_FLAGS+=--features gettext
+CARGO_INSTALL_FLAGS+=--features gettext
+CARGO_CMT_GETTEXT=
+else
+	# This is what you have to do to define a variable to a octothorpe.
+	define CARGO_CMT_GETTEXT
+#
+endef
+endif
+
 # Assume that if rustc supports LTO then cargo knows how to configure it.
 # rustc and cargo support LTO as of Rust-2021.
 ifeq ($(HAVE_RUSTC_LTO),yes)
@@ -97,12 +110,15 @@ $(XFS_HEALER_PROG): $(XFS_HEALER_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext
 src/xfsprogs.rs: src/xfsprogs.rs.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e "s|@PACKAGE@|$(PKG_NAME)|g" \
+		   -e "s|@LOCALEDIR@|$(PKG_LOCALE_DIR)|g" \
 		   < $< > $@
 
 $(CARGO_MANIFEST): $(CARGO_MANIFEST).in $(builddefs)
 	@echo "    [TOML]   $@"
 	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@cargo_lto@|$(CARGO_LTO)|g" \
+		   -e "s|@cargo_cmt_gettext@|$(CARGO_CMT_GETTEXT)|g" \
 		   < $< | sed -e 's|\~WIP.*|"|g' > $@
 
 ifeq ($(USE_SYSTEM_CRATES),yes)
diff --git a/healer/src/main.rs b/healer/src/main.rs
index e58ffdb3eca5e3..d43640e140d46c 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -71,7 +71,7 @@ impl App {
 
     /// Main app method
     fn main(&self) -> Result<ExitCode> {
-        let _fp = File::open(&self.path).with_context(|| "Opening filesystem failed")?;
+        let _fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
 
         Ok(ExitCode::SUCCESS)
     }
@@ -89,6 +89,8 @@ impl From<Cli> for App {
 }
 
 fn main() -> ExitCode {
+    xfsprogs::init_localization();
+
     let args = Cli::new();
     if args.0.get_flag("version") {
         println!("{} {}", M_("xfs_healer version"), xfsprogs::VERSION);
diff --git a/healer/src/xfsprogs.rs.in b/healer/src/xfsprogs.rs.in
index bc5a9b227d26f0..0c5cd2d00f7c26 100644
--- a/healer/src/xfsprogs.rs.in
+++ b/healer/src/xfsprogs.rs.in
@@ -3,10 +3,30 @@
  * Copyright (C) 2025 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
+#![allow(unexpected_cfgs)]
+
 pub const VERSION: &str = "@pkg_version@";
 
+/// Try to initialize a localization library.  Like the other xfsprogs utilities, we don't care
+/// if this fails.
+#[cfg(feature = "gettext")]
+pub fn init_localization() {
+    let _ = gettextrs::setlocale(gettextrs::LocaleCategory::LcAll, "");
+    let _ = gettextrs::bindtextdomain("@PACKAGE@", "@LOCALEDIR@");
+    let _ = gettextrs::textdomain("@PACKAGE@");
+}
+
+/// Look up a string in a message catalog
+#[cfg(feature = "gettext")]
+pub use gettextrs::gettext as M_;
+
+/// Pretend to initialize localization library
+#[cfg(not(feature = "gettext"))]
+pub fn init_localization() {}
+
 /// Dummy function to simulate looking up a string in a message catalog
 #[allow(non_snake_case)]
+#[cfg(not(feature = "gettext"))]
 pub fn M_<T: Into<String>>(msgid: T) -> String {
     msgid.into()
 }
diff --git a/include/builddefs.in b/include/builddefs.in
index e477a77f753a22..3ac4147de8c815 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,6 +102,7 @@ ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
 ENABLE_SCRUB	= @enable_scrub@
 ENABLE_HEALER	= @enable_healer@
+ENABLE_GETTEXT_RS = @enable_gettext_rs@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
diff --git a/include/buildrules b/include/buildrules
index 871e92db02de14..814e0b79ffb8ae 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -88,6 +88,7 @@ ifdef POTHEAD
 XGETTEXT_FLAGS=\
 	--keyword=_ \
 	--keyword=N_ \
+	--keyword=M_ \
 	--package-name=$(PKG_NAME) \
 	--package-version=$(PKG_VERSION) \
 	--msgid-bugs-address=$(PKG_BUGREPORT)
diff --git a/m4/package_rust.m4 b/m4/package_rust.m4
index 7c2504b3390941..a596ec0740f51e 100644
--- a/m4/package_rust.m4
+++ b/m4/package_rust.m4
@@ -119,10 +119,16 @@ ENDL
 # Do we have all the crates we need for xfs_healer?
 AC_DEFUN([AC_HAVE_HEALER_CRATES],
 [
+  if test "$enable_gettext_rs" = "yes"; then
+    gettext_dep='gettext-rs = { version = "0", optional = true }'	# 0.7.0
+  else
+    gettext_dep=""
+  fi
   AC_CHECK_CRATES([have_healer_crates], [xfs_healer],
     [
 clap = { version = "4.0.32", features = [["derive"]] }
 anyhow = { version = "1.0.69" }
+$gettext_dep
 ],
     [yes], [no])
 ])

