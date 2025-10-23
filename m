Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07AC4C85
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178356; cv=none; b=jTZjPG+vRkE5Sk9z5aGi5GvV1PaT/QFi1YSVTzuunr/glQr3EpN1PrsXulr9LHP04+Wf6OSgjOaFvFIzr+21QQkUcQXq3GIMB73qNy9D4FrIKg8NRTuVo1pjdEE1Xf8Yx4Dsni/QSPGF8sopDAsljKSEos4ozFDlEAnaBkCEXx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178356; c=relaxed/simple;
	bh=ZPNzqYQFI6mnIS18xGAgnIc+34A1Vlam76wfxgTJwGA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kar+YwWQeHUtELjYiTeqcRWp9vP6rWyLqjcxwTJPxA9n/9yW7Z3JN1dUvE5SZKau6tAOeO5BxFpG/ukn2EGmEQZoLikRKBhdWmhyIzPqsHrb2Wqj1MqJGpAZZwozIqIpFwqFss08Ekldl66DkavHkvleOiEGBHP9bB2yL2ifTto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sUrafJ8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sUrafJ8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3DDC4CEE7;
	Thu, 23 Oct 2025 00:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178356;
	bh=ZPNzqYQFI6mnIS18xGAgnIc+34A1Vlam76wfxgTJwGA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sUrafJ8WllZeK+2OUoAwy+Arl2TxABTgr2p1ACf1LOeKC0Tnr2nb81fbjfUCV4h18
	 MQM9WYIAMVSiVgcGeeMyZAuz8IifOfvHxPrAldbcbCKf/w7JpiP38qNmxluRtnqkcF
	 0NZ+ridf9ouO5sJs8kSx+p78L3lgVvJpYTzgxVfiAHA5lDLn/rF2J+IBdqK1Jw05AM
	 7LmSaWX81c6cCImqtfbSI0tQsxRgiLOWSB5vkUFF/tFAtHZAcr/gwk4Hrwqug8H0ht
	 CT9gpZchFBAGwQGEDsCIUkeCJDZTjNGr3IU7v7ReABapNHI3p0CVISjgGvf6EzXNfI
	 gzbIvpU7TOnMg==
Date: Wed, 22 Oct 2025 17:12:35 -0700
Subject: [PATCH 01/19] xfs_healer: start building a Rust version
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748274.1029045.15011384662494510684.stgit@frogsfrogsfrogs>
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

Update the build infrastructure to support building rust programs and
add a stub xfs_healer program.  This is a little gross because cargo
install doesn't handle packaging, according to its maintainers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac                     |   59 ++++++++++++++++++
 debian/rules                     |    2 +
 healer/.cargo/config.toml.system |    6 ++
 healer/Cargo.toml.in             |   15 ++++
 healer/Makefile                  |   96 ++++++++++++++++++++++++++++-
 healer/src/lib.rs                |    7 ++
 healer/src/main.rs               |  110 +++++++++++++++++++++++++++++++++
 healer/src/xfsprogs.rs.in        |   12 ++++
 include/builddefs.in             |    9 +++
 m4/Makefile                      |    1 
 m4/package_rust.m4               |  128 ++++++++++++++++++++++++++++++++++++++
 11 files changed, 443 insertions(+), 2 deletions(-)
 create mode 100644 healer/.cargo/config.toml.system
 create mode 100644 healer/Cargo.toml.in
 create mode 100644 healer/src/lib.rs
 create mode 100644 healer/src/main.rs
 create mode 100644 healer/src/xfsprogs.rs.in
 create mode 100644 m4/package_rust.m4


diff --git a/configure.ac b/configure.ac
index 4e7b917c38ae7c..2902fe9ca2227e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,10 @@ fi
 if test "${CXXFLAGS+set}" != "set"; then
 	CXXFLAGS="-g -O2 -std=gnu++11"
 fi
+if test "${CARGOFLAGS+set}" != "set"; then
+	CARGOFLAGS=""
+fi
+AC_SUBST(CARGOFLAGS)
 
 AC_PROG_INSTALL
 LT_INIT
@@ -116,6 +120,29 @@ AC_ARG_ENABLE(healer,
 	enable_healer=yes)
 AC_SUBST(enable_healer)
 
+# Is this a release build?  Mostly important for cargo/rustc.
+AC_ARG_ENABLE(release,
+[  --enable-release=[yes/no] This is a release build [[default=no]]],,
+	enable_release=no)
+AC_SUBST(enable_release)
+
+# Should we build Rust with the system crates?  "yes" means it's required,
+# "no" means use crates.io, "probe" means figure it out from the distro.
+AC_ARG_WITH([system-crates],
+  [AS_HELP_STRING([--with-system-crates=[yes/no/probe]],
+[Build Rust programs with system crates instead of downloading from crates.io. [default=no]])],
+  [],
+  [with_system_crates=no])
+AC_SUBST(with_system_crates)
+
+# Should we check for Rust crates and skip builds if they are not installed?
+# Distros that package crates themselves and establish build dependencies on
+# those packages can skip the checks.
+AC_ARG_ENABLE(crate-checks,
+[  --enable-crate-checks=[yes/no] Check for Rust crates before building [[default=yes]]],,
+	enable_crate_checks=yes)
+AC_SUBST(enable_crate_checks)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
@@ -224,5 +251,37 @@ fi
 AC_MANUAL_FORMAT
 AC_HAVE_LIBURCU_ATOMIC64
 
+# Check for a Rust compiler
+# XXX: I don't know how to cross compile Rust yet
+if test "$host" = "$build"; then
+	AC_HAVE_RUSTC
+fi
+
+# If we have rustc, check if LTO is supported (it should be)
+if test "$have_rustc" = "yes"; then
+	if test "$enable_lto" = "yes" || test "$enable_lto" = "probe"; then
+		AC_RUSTC_CHECK_LTO
+	fi
+fi
+if test "$enable_lto" = "yes" && test "$have_rustc_lto" != "yes"; then
+	AC_MSG_ERROR([LTO not supported by Rust compiler.])
+fi
+
+# If we still have rustc, check that we have cargo for crate management
+if test "$have_rustc" = "yes"; then
+	AC_HAVE_CARGO
+fi
+
+# If we have cargo, check that our crate dependencies are present
+if test "$have_cargo" = "yes"; then
+	if test "$with_system_crates" = "yes"; then
+		AC_USE_SYSTEM_CRATES
+	elif test "$with_system_crates" = "probe"; then
+		AC_MAYBE_USE_SYSTEM_CRATES
+	fi
+	AC_HAVE_CLIPPY
+	AC_HAVE_HEALER_CRATES
+fi
+
 AC_CONFIG_FILES([include/builddefs])
 AC_OUTPUT
diff --git a/debian/rules b/debian/rules
index 2bf736f340c53d..d13ff5cf954cd2 100755
--- a/debian/rules
+++ b/debian/rules
@@ -39,6 +39,8 @@ configure_options = \
 	--disable-addrsan \
 	--disable-threadsan \
 	--enable-lto \
+	--enable-release \
+	--with-system-crates \
 	--localstatedir=/var
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
diff --git a/healer/.cargo/config.toml.system b/healer/.cargo/config.toml.system
new file mode 100644
index 00000000000000..83e5cb05d0d22a
--- /dev/null
+++ b/healer/.cargo/config.toml.system
@@ -0,0 +1,6 @@
+# XXX gross hack so that we don't download crates from the internet
+[source]
+[source.system-packages]
+directory = "/usr/share/cargo/registry"
+[source.crates-io]
+replace-with = "system-packages"
diff --git a/healer/Cargo.toml.in b/healer/Cargo.toml.in
new file mode 100644
index 00000000000000..bbd6f930510059
--- /dev/null
+++ b/healer/Cargo.toml.in
@@ -0,0 +1,15 @@
+[package]
+name = "xfs_healer"
+version = "@pkg_version@"
+edition = "2021"
+
+[profile.dev]
+lto = @cargo_lto@
+
+[profile.release]
+lto = @cargo_lto@
+
+# Be sure to update AC_HAVE_HEALER_CRATES if you update the dependency list.
+[dependencies]
+clap = { version = "4.0.32", features = ["derive"] }
+anyhow = { version = "1.0.69" }
diff --git a/healer/Makefile b/healer/Makefile
index 798c6f2c8a58e0..4c97430b26bd42 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -6,9 +6,55 @@ TOPDIR = ..
 builddefs=$(TOPDIR)/include/builddefs
 include $(builddefs)
 
+# Python implementation
 XFS_HEALER_PROG = xfs_healer.py
 INSTALL_HEALER = install-healer
 
+# Rust implementation
+ifeq ($(HAVE_HEALER_CRATES),yes)
+
+RUSTFILES = \
+	src/lib.rs \
+	src/main.rs \
+	src/xfsprogs.rs
+
+BUILT_RUSTFILES = \
+	src/xfsprogs.rs
+
+CARGO_MANIFEST=Cargo.toml
+CARGO_CONFIG=.cargo/config.toml
+
+XFS_HEALER_RUST += bin/xfs_healer
+INSTALL_HEALER += install-rust-healer
+CLEAN_HEALER += clean-rust-healer
+
+ifeq ($(HAVE_CLIPPY),yes)
+	CLIPPY=$(Q)cargo clippy
+else
+	CLIPPY=@true
+endif
+
+ifeq ($(ENABLE_RELEASE),yes)
+	CARGO_CLIPPY_FLAGS=--no-deps
+	CARGO_BUILD_FLAGS=--release
+	CARGO_INSTALL_FLAGS=
+else
+	CARGO_CLIPPY_FLAGS=--no-deps
+	CARGO_BUILD_FLAGS=
+	CARGO_INSTALL_FLAGS=--debug
+endif
+
+# Assume that if rustc supports LTO then cargo knows how to configure it.
+# rustc and cargo support LTO as of Rust-2021.
+ifeq ($(HAVE_RUSTC_LTO),yes)
+	CARGO_LTO=true
+else
+	CARGO_LTO=false
+endif
+
+RUST_DIRT=$(CARGO_MANIFEST) $(CARGO_CONFIG) $(XFS_HEALER_RUST) $(BUILT_RUSTFILES)
+endif # HAVE_HEALER_CRATES
+
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_HEALER += install-systemd
 SYSTEMD_SERVICES=\
@@ -24,9 +70,14 @@ ifeq ($(HAVE_UDEV),yes)
 endif
 endif
 
-LDIRT = $(XFS_HEALER_PROG)
+LDIRT = $(XFS_HEALER_PROG) $(RUST_DIRT)
 
-default: $(XFS_HEALER_PROG) $(SYSTEMD_SERVICES) $(UDEV_RULES) $(XFS_HEALER_HELPER)
+default: $(XFS_HEALER_PROG) $(XFS_HEALER_RUST) $(SYSTEMD_SERVICES) $(UDEV_RULES) $(XFS_HEALER_HELPER)
+
+clean: $(CLEAN_HEALER)
+
+clean-rust-healer:
+	-cargo clean
 
 $(XFS_HEALER_PROG): $(XFS_HEALER_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext.py
 	@echo "    [SED]    $@"
@@ -43,6 +94,41 @@ $(XFS_HEALER_PROG): $(XFS_HEALER_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext
 	$(Q)$(SED) -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
 		   < $< > $@
 
+src/xfsprogs.rs: src/xfsprogs.rs.in $(builddefs)
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   < $< > $@
+
+$(CARGO_MANIFEST): $(CARGO_MANIFEST).in $(builddefs)
+	@echo "    [TOML]   $@"
+	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e "s|@cargo_lto@|$(CARGO_LTO)|g" \
+		   < $< | sed -e 's|\~WIP.*|"|g' > $@
+
+ifeq ($(USE_SYSTEM_CRATES),yes)
+$(CARGO_CONFIG): $(CARGO_CONFIG).system
+	@echo "    [TOML]   $@"
+	$(Q)cp $< $@
+else
+$(CARGO_CONFIG):
+	touch $@
+endif
+
+docs:
+	@echo "    [CARGO]  doc $@"
+	$(Q)cargo doc --no-deps
+
+# cargo install only knows how to build a binary and install it to $root/bin,
+# so we install it to ./rust/bin/ and let the install-rust target move it to
+# $prefix/usr/libexec/xfsprogs like we want.
+$(XFS_HEALER_RUST): $(RUSTFILES) $(CARGO_MANIFEST) $(CARGO_CONFIG)
+	@echo "    [CARGO]  clippy $@ $(CARGO_CLIPPY_FLAGS)"
+	$(CLIPPY) $(CARGO_CLIPPY_FLAGS)
+	@echo "    [CARGO]  build $@ $(CARGO_BUILD_FLAGS)"
+	$(Q)cargo build $(CARGOFLAGS) $(CARGO_BUILD_FLAGS)
+	@echo "    [CARGO]  install $@ $(CARGO_INSTALL_FLAGS)"
+	$(Q)cargo install --path . --root . $(CARGOFLAGS) $(CARGO_INSTALL_FLAGS) &>/dev/null
+
 include $(BUILDRULES)
 
 install: $(INSTALL_HEALER)
@@ -63,6 +149,12 @@ install-udev: default
 		$(INSTALL) -m 644 $$i $(UDEV_RULE_DIR)/64-$$i; \
 	done
 
+# Leave the python version in the installed system for now
+install-rust-healer: default install-healer
+	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(XFS_HEALER_PROG) $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(XFS_HEALER_RUST) $(PKG_LIBEXEC_DIR)
+
 install-dev:
 
 -include .dep
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
new file mode 100644
index 00000000000000..34ab19e07de82f
--- /dev/null
+++ b/healer/src/lib.rs
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+
+pub mod xfsprogs;
diff --git a/healer/src/main.rs b/healer/src/main.rs
new file mode 100644
index 00000000000000..e58ffdb3eca5e3
--- /dev/null
+++ b/healer/src/main.rs
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use anyhow::{Context, Result};
+use clap::{value_parser, Arg, ArgAction, ArgMatches, Command};
+use std::fs::File;
+use std::path::PathBuf;
+use std::process::ExitCode;
+use xfs_healer::xfsprogs;
+use xfs_healer::xfsprogs::M_;
+
+/// Contains command line arguments
+#[derive(Debug)]
+struct Cli(ArgMatches);
+
+impl Cli {
+    pub fn new() -> Self {
+        Cli(Command::new("xfs_healer")
+            .disable_version_flag(true)
+            .about(M_("Automatically heal damage to XFS filesystem metadata"))
+            .arg(
+                Arg::new("version")
+                    .short('V')
+                    .help(M_("Print version"))
+                    .action(ArgAction::SetTrue),
+            )
+            .arg(
+                Arg::new("debug")
+                    .long("debug")
+                    .help(M_("Enable debugging messages"))
+                    .action(ArgAction::SetTrue),
+            )
+            .arg(
+                Arg::new("log")
+                    .long("log")
+                    .help(M_("Log health events to stdout"))
+                    .action(ArgAction::SetTrue),
+            )
+            .arg(
+                Arg::new("everything")
+                    .long("everything")
+                    .help(M_("Capture all events"))
+                    .action(ArgAction::SetTrue),
+            )
+            .arg(
+                Arg::new("path")
+                    .help(M_("XFS filesystem mountpoint to monitor"))
+                    .value_parser(value_parser!(PathBuf))
+                    .required_unless_present("version"),
+            )
+            .get_matches())
+    }
+}
+
+/// Contains all the global program state but allows more flexibility.
+#[derive(Debug)]
+struct App {
+    debug: bool,
+    log: bool,
+    everything: bool,
+    path: PathBuf,
+}
+
+impl App {
+    /// Return mountpoint as string, for printing messages
+    fn mountpoint(&self) -> String {
+        self.path.display().to_string()
+    }
+
+    /// Main app method
+    fn main(&self) -> Result<ExitCode> {
+        let _fp = File::open(&self.path).with_context(|| "Opening filesystem failed")?;
+
+        Ok(ExitCode::SUCCESS)
+    }
+}
+
+impl From<Cli> for App {
+    fn from(cli: Cli) -> Self {
+        App {
+            debug: cli.0.get_flag("debug"),
+            log: cli.0.get_flag("log"),
+            everything: cli.0.get_flag("everything"),
+            path: cli.0.get_one::<PathBuf>("path").unwrap().to_path_buf(),
+        }
+    }
+}
+
+fn main() -> ExitCode {
+    let args = Cli::new();
+    if args.0.get_flag("version") {
+        println!("{} {}", M_("xfs_healer version"), xfsprogs::VERSION);
+        return ExitCode::SUCCESS;
+    }
+
+    if args.0.get_flag("debug") {
+        println!("args: {:?}", args);
+    }
+
+    let app: App = args.into();
+    match app.main() {
+        Ok(f) => f,
+        Err(e) => {
+            eprintln!("{}: {:#}", app.mountpoint(), e);
+            ExitCode::FAILURE
+        }
+    }
+}
diff --git a/healer/src/xfsprogs.rs.in b/healer/src/xfsprogs.rs.in
new file mode 100644
index 00000000000000..bc5a9b227d26f0
--- /dev/null
+++ b/healer/src/xfsprogs.rs.in
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+pub const VERSION: &str = "@pkg_version@";
+
+/// Dummy function to simulate looking up a string in a message catalog
+#[allow(non_snake_case)]
+pub fn M_<T: Into<String>>(msgid: T) -> String {
+    msgid.into()
+}
diff --git a/include/builddefs.in b/include/builddefs.in
index 7cf6e0782788ca..e477a77f753a22 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -17,6 +17,15 @@ CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-
 CXXFLAGS = @CXXFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
 BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64
 
+ENABLE_RELEASE = @enable_release@
+HAVE_RUSTC = @have_rustc@
+HAVE_RUSTC_LTO = @have_rustc_lto@
+HAVE_CARGO = @have_cargo@
+HAVE_HEALER_CRATES = @have_healer_crates@
+CARGOFLAGS = @CARGOFLAGS@
+USE_SYSTEM_CRATES = @use_system_crates@
+HAVE_CLIPPY = @have_clippy@
+
 # make sure we don't pick up whacky LDFLAGS from the make environment and
 # only use what we calculate from the configured options above.
 LDFLAGS =
diff --git a/m4/Makefile b/m4/Makefile
index 84174c3d3e3023..715d35d592cbe3 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -23,6 +23,7 @@ LSRCFILES = \
 	package_sanitizer.m4 \
 	package_services.m4 \
 	package_icu.m4 \
+	package_rust.m4 \
 	package_urcu.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
diff --git a/m4/package_rust.m4 b/m4/package_rust.m4
new file mode 100644
index 00000000000000..7c2504b3390941
--- /dev/null
+++ b/m4/package_rust.m4
@@ -0,0 +1,128 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Oracle.  All Rights Reserved.
+
+## Check if the platform has rust tools such as cargo
+
+# Check if rustc is installed
+AC_DEFUN([AC_HAVE_RUSTC],
+[
+  AC_CHECK_PROG([have_rustc], [rustc], [yes], [no])
+  AC_SUBST(have_rustc)
+])
+
+# Check if cargo is installed
+AC_DEFUN([AC_HAVE_CARGO],
+[
+  AC_CHECK_PROG([have_cargo], [cargo], [yes], [no])
+  AC_SUBST(have_cargo)
+])
+
+# Check if cargo-clippy (aka the linter) is installed
+AC_DEFUN([AC_HAVE_CLIPPY],
+[
+  AC_CHECK_PROG([have_clippy], [cargo-clippy], [yes], [no])
+  AC_SUBST(have_clippy)
+])
+
+# Require that we use the system crates
+AC_DEFUN([AC_USE_SYSTEM_CRATES],
+[
+  use_system_crates=yes
+  AC_SUBST(use_system_crates)
+])
+
+# Check if we're building Rust under one of those distributions that provides
+# stabilized Rust crates (e.g. Debian, EPEL) and should therefore use them.
+AC_DEFUN([AC_MAYBE_USE_SYSTEM_CRATES],
+[
+  AC_MSG_CHECKING([if we use system Rust crates])
+  if test -f /etc/debian_version || test -f /etc/redhat-release; then
+    use_system_crates=yes
+    AC_MSG_RESULT(yes)
+  else
+    AC_MSG_RESULT(no)
+  fi
+  AC_SUBST(use_system_crates)
+])
+
+# Check if rustc knows about the LTO option
+AC_DEFUN([AC_RUSTC_CHECK_LTO],
+[
+  AC_MSG_CHECKING([if Rust compiler supports LTO])
+  rm -f /tmp/enoent.rs
+  # check that rustc fails because it can't find enoent.rs, not
+  # because codegen doesn't recognize lto.
+  if LANG=C rustc -C lto /tmp/enoent.rs 2>&1 | grep -q -i 'enoent.rs.*no.*such'; then
+    have_rustc_lto=yes
+    AC_MSG_RESULT(yes)
+  else
+    AC_MSG_RESULT(no)
+  fi
+  AC_SUBST(have_rustc_lto)
+])
+
+# Check if we have a particular crate configuration.  The arguments are:
+#
+# 1. Name of variable to set.
+# 2. User-friendly description of what we're checking.
+# 3. List of crates in Cargo.toml dependencies format.
+# 4. Value if the test build succeeds.
+# 5. Value if the test build fails.
+#
+# The variable will be AC_SUBST'd automatically.  Be careful to escape the
+# brackets that rustc/cargo want.
+AC_DEFUN([AC_CHECK_CRATES],
+[
+  if test "$enable_crate_checks" = "no"; then
+    $1=$4
+    AC_SUBST([$1])
+  else
+    AC_MSG_CHECKING([for Rust crates for $2])
+    rm -r -f .havecrate
+    mkdir -p .havecrate/src/
+    cat > .havecrate/Cargo.toml << ENDL
+[[package]]
+name = "havecrate"
+version = "0.1.0"
+edition = "2021"
+
+[[dependencies]]
+$3
+ENDL
+    cat > .havecrate/src/main.rs << ENDL
+fn main() { }
+ENDL
+    if test -n "$use_system_crates"; then
+      mkdir -p .havecrate/.cargo
+      cat > .havecrate/.cargo/config.toml << ENDL
+[[source]]
+[[source.system-packages]]
+directory = "/usr/share/cargo/registry"
+[[source.crates-io]]
+replace-with = "system-packages"
+ENDL
+    fi
+    cat .havecrate/Cargo.toml >> config.log
+    # Is there a faster way to check crate presence than this?
+    if (cd .havecrate && cargo check) >>config.log 2>&1; then
+      AC_MSG_RESULT([$4])
+      $1=$4
+    else
+      AC_MSG_RESULT([$5])
+      $1=$5
+    fi
+    AC_SUBST([$1])
+    rm -r -f .havecrate
+  fi
+])
+
+# Do we have all the crates we need for xfs_healer?
+AC_DEFUN([AC_HAVE_HEALER_CRATES],
+[
+  AC_CHECK_CRATES([have_healer_crates], [xfs_healer],
+    [
+clap = { version = "4.0.32", features = [["derive"]] }
+anyhow = { version = "1.0.69" }
+],
+    [yes], [no])
+])

