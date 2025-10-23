Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A74536124
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178529; cv=none; b=RbXGgJf9HQqJQwPpLMWxbS/e1L4Fp1VnHjNGq7dVAv7HcIfqSkcMJWFPnENIiEsM1xUasLZFX6KJbfklSijANRvr9snA7wnMgmDWf40ODdHSyGdFBVPVgxz3hvmXBMe0q4HDILZIppSQU67ipAfjMp90pqQWrQf15VXFLjF65N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178529; c=relaxed/simple;
	bh=zceJ/pnOgQZnSMxHYZJlzpLI6lX+gQaDcRNqtqILuCA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iB9JlSLZYt0/hJCN43WDnR6O3+kpElJwPBYjtaqf3H0bSabNUpNh5ulqQ0+t22flnD514kGaZ56C0bTJuprvygkYCqdqZcXxpCoBCvQMvgWKsaydl4dg2NAh77XF7zDkXGQg1SMEXfaNGoRl8z61fcEunYAhaM1c+FsGMauo9OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jx3lUori; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jx3lUori"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983C4C4CEE7;
	Thu, 23 Oct 2025 00:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178528;
	bh=zceJ/pnOgQZnSMxHYZJlzpLI6lX+gQaDcRNqtqILuCA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jx3lUori5pPMGNomeRV/k+sEiyrnmd3FV/Te0JLOTp8c59i8pRGAoTbllQf+P4ZKI
	 EhoaTt6dQ0BFWwPQX3Ge+WpNYd/5RYdzBO3VGVZ/Q944rXDGXJJMII7vheiuhq+gkA
	 ycN27/sA+cvUA99fmd6LbtMJb4ObDWJDhIqhs2ifSMCGOVgH1y+/0aE+8Z2RD0Hjhg
	 el/g+WLIS4paYGMfZS6+SodwIi1WPt1V0utvthYPUtTBp2vQNN6eqd3WGFEts8wXHr
	 amz6HG8zwV051xNq5sbGfKdWk1b+swQJlVUGWfJhMmeJwLaoJz8Qen2yO1tiFTR7XE
	 lcZAa0nmePW/g==
Date: Wed, 22 Oct 2025 17:15:28 -0700
Subject: [PATCH 12/19] xfs_healer: use the autofsck fsproperty to select mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748483.1029045.2916765319011499919.stgit@frogsfrogsfrogs>
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

Make the rust xfs_healer program query the autofsck filesystem property
to figure out which operating mode it should use.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Cargo.toml.in  |    1 
 healer/Makefile       |    1 
 healer/src/fsprops.rs |  101 +++++++++++++++++++++++++++++++++++++++++++++++++
 healer/src/lib.rs     |    1 
 healer/src/main.rs    |   93 +++++++++++++++++++++++++++++++++++++++++----
 m4/package_rust.m4    |    1 
 6 files changed, 189 insertions(+), 9 deletions(-)
 create mode 100644 healer/src/fsprops.rs


diff --git a/healer/Cargo.toml.in b/healer/Cargo.toml.in
index fcf7f7a6d9373b..dcb356b7772674 100644
--- a/healer/Cargo.toml.in
+++ b/healer/Cargo.toml.in
@@ -28,6 +28,7 @@ serde_json = { version = "1.0.87" }
 nix = { version = "0", features = ["ioctl"] }	# 0.26.1
 strum = { version = "0" }			# 0.19.2
 strum_macros = { version = "0" }		# 0.19.2
+libc = { version = "0" }			# 0.2.139
 
 # Dynamically comment out all the gettextrs related dependency information in
 # Cargo.toml becuse cargo requires the crate to be present so that it can
diff --git a/healer/Makefile b/healer/Makefile
index 796bed3e166487..76977e527c56e6 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -18,6 +18,7 @@ HFILES = \
 
 RUSTFILES = \
 	src/fsgeom.rs \
+	src/fsprops.rs \
 	src/getparents.rs \
 	src/lib.rs \
 	src/main.rs \
diff --git a/healer/src/fsprops.rs b/healer/src/fsprops.rs
new file mode 100644
index 00000000000000..652daf33cb1eb1
--- /dev/null
+++ b/healer/src/fsprops.rs
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use libc::fgetxattr;
+use std::ffi::CString;
+use std::fs::File;
+use std::os::fd::AsRawFd;
+use std::os::raw::c_void;
+use std::str::FromStr;
+use strum_macros::EnumString;
+
+/// Property name for coordinating automatic fsck
+const AUTOFSCK_NAME: &str = "autofsck";
+
+/// Boilerplate to stamp out functions to convert json array to the given enum
+/// type; or return an error with the given message.
+macro_rules! fsprop_from_string {
+    ($enum_type:ty , $default:ident) => {
+        impl From<Option<String>> for $enum_type {
+            /// Convert from a json value to an enum
+            fn from(v: Option<String>) -> $enum_type {
+                if let Some(value) = v {
+                    match <$enum_type>::from_str(&value) {
+                        Ok(o) => o,
+                        Err(_) => <$enum_type>::$default,
+                    }
+                } else {
+                    <$enum_type>::$default
+                }
+            }
+        }
+    };
+}
+
+/// Values for the autofsck property
+#[derive(Debug, strum_macros::Display, EnumString)]
+#[strum(serialize_all = "lowercase")]
+pub enum XfsAutofsck {
+    /// No value set
+    Unset,
+
+    /// Do not do background repairs
+    None,
+
+    /// Check but do not change anything
+    Check,
+
+    /// Optimize only, do not repair
+    Optimize,
+
+    /// Repair and optimize
+    Repair,
+}
+fsprop_from_string!(XfsAutofsck, Unset);
+
+const FSPROP_MAX_VALUELEN: usize = 256;
+
+fn propname(realname: &str) -> String {
+    let mut ret: String = "trusted.xfs:".to_owned();
+    ret.push_str(realname);
+    ret
+}
+
+/// Return the value of a filesystem property as a string.  Returns None on
+/// any kind of error, or an empty value.
+fn get(fp: &File, property: &str) -> Option<String> {
+    let cname: CString = match CString::new(propname(property)) {
+        Ok(x) => x,
+        Err(_) => return None,
+    };
+    let mut value: Vec<u8> = vec![0; FSPROP_MAX_VALUELEN];
+
+    // SAFETY: Trusting the kernel not to corrupt either buffer that we pass in.
+    let ret = unsafe {
+        fgetxattr(
+            fp.as_raw_fd(),
+            cname.as_ptr(),
+            value.as_mut_ptr() as *mut c_void,
+            FSPROP_MAX_VALUELEN,
+        )
+    };
+    if ret < 1 {
+        return None;
+    }
+
+    let cvalue: CString = match CString::new(&value[0..ret as usize]) {
+        Ok(x) => x,
+        _ => return None,
+    };
+    match cvalue.into_string() {
+        Ok(x) => Some(x),
+        _ => None,
+    }
+}
+
+/// Return the autofsck filesystem property.
+pub fn get_autofsck(fp: &File) -> XfsAutofsck {
+    get(fp, AUTOFSCK_NAME).into()
+}
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
index e0e59a5868af75..d952b61646114d 100644
--- a/healer/src/lib.rs
+++ b/healer/src/lib.rs
@@ -13,3 +13,4 @@ pub mod weakhandle;
 pub mod repair;
 pub mod fsgeom;
 pub mod getparents;
+pub mod fsprops;
diff --git a/healer/src/main.rs b/healer/src/main.rs
index fe125c4c4ee5f3..580ca5a0b13508 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -4,10 +4,12 @@
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 use anyhow::{Context, Result};
-use clap::{value_parser, Arg, ArgAction, ArgMatches, Command};
+use clap::{value_parser, Arg, ArgAction, ArgGroup, ArgMatches, Command};
 use std::fs::File;
 use std::path::PathBuf;
 use std::process::ExitCode;
+use xfs_healer::fsprops;
+use xfs_healer::fsprops::XfsAutofsck;
 use xfs_healer::healthmon::cstruct::CStructMonitor;
 use xfs_healer::healthmon::event::XfsHealthEvent;
 use xfs_healer::healthmon::json::JsonMonitor;
@@ -75,6 +77,13 @@ impl Cli {
                     .help(M_("Check that health monitoring is supported"))
                     .action(ArgAction::SetTrue),
             )
+            .arg(
+                Arg::new("autofsck")
+                    .long("autofsck")
+                    .help(M_("Use the \"autofsck\" fs property to decide to repair"))
+                    .action(ArgAction::SetTrue),
+            )
+            .group(ArgGroup::new("decide_repair").args(["repair", "autofsck"]))
             .get_matches())
     }
 }
@@ -88,9 +97,24 @@ struct App {
     json: bool,
     repair: bool,
     check: bool,
+    autofsck: bool,
     path: PathBuf,
 }
 
+/// Outcome of checking if the kernel supports metadata repair
+enum CheckRepair {
+    ExitWith(ExitCode),
+    Downgrade,
+    Proceed,
+}
+
+/// Outcome of looking at the autofsck fsproperty to decide if we will repair metadata
+enum CheckAutofsck {
+    ExitWith(ExitCode),
+    Upgrade,
+    Proceed,
+}
+
 impl App {
     /// Return mountpoint as string, for printing messages
     fn mountpoint(&self) -> String {
@@ -121,14 +145,23 @@ impl App {
     }
 
     /// Complain if repairs won't be entirely effective.
-    fn check_repair(&self, fp: &File, fsgeom: &xfs_fsop_geom) -> Option<ExitCode> {
+    fn check_repair(&self, fp: &File, fsgeom: &xfs_fsop_geom) -> CheckRepair {
         if !Repair::is_supported(fp) {
+            if !self.autofsck {
+                printlogln!(
+                    "{}: {}",
+                    self.path.display(),
+                    M_("XFS online repair is not supported, exiting")
+                );
+                return CheckRepair::ExitWith(ExitCode::FAILURE);
+            }
+
             printlogln!(
                 "{}: {}",
                 self.path.display(),
-                M_("XFS online repair is not supported, exiting")
+                M_("XFS online repair is not supported, will report only")
             );
-            return Some(ExitCode::FAILURE);
+            return CheckRepair::Downgrade;
         }
 
         if !fsgeom.has_rmapbt() {
@@ -146,19 +179,60 @@ impl App {
             );
         }
 
-        None
+        CheckRepair::Proceed
+    }
+
+    /// Set the behavior of the program from the autofsck fs property.
+    fn check_autofsck(&self, fp: &File) -> CheckAutofsck {
+        match fsprops::get_autofsck(fp) {
+            XfsAutofsck::None => {
+                printlogln!(
+                    "{}: {}",
+                    self.path.display(),
+                    M_("Disabling healer per autofsck directive.")
+                );
+                return CheckAutofsck::ExitWith(ExitCode::SUCCESS);
+            }
+            XfsAutofsck::Check | XfsAutofsck::Optimize | XfsAutofsck::Unset => {
+                printlogln!(
+                    "{}: {}",
+                    self.path.display(),
+                    M_("Will not automatically heal per autofsck directive.")
+                );
+            }
+            XfsAutofsck::Repair => {
+                printlogln!(
+                    "{}: {}",
+                    self.path.display(),
+                    M_("Automatically healing per autofsck directive.")
+                );
+                return CheckAutofsck::Upgrade;
+            }
+        }
+        CheckAutofsck::Proceed
     }
 
     /// Main app method
-    fn main(&self) -> Result<ExitCode> {
+    fn main(&mut self) -> Result<ExitCode> {
         let fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
 
+        // Decide if we're going to enable repairs, which must come before check_repair.
+        if self.autofsck {
+            match self.check_autofsck(&fp) {
+                CheckAutofsck::ExitWith(ret) => return Ok(ret),
+                CheckAutofsck::Upgrade => self.repair = true,
+                CheckAutofsck::Proceed => {}
+            }
+        }
+
         // Make sure that we can initiate repairs
         let fsgeom =
             xfs_fsop_geom::try_from(&fp).with_context(|| M_("Querying filesystem geometry"))?;
         if self.repair {
-            if let Some(ret) = self.check_repair(&fp, &fsgeom) {
-                return Ok(ret);
+            match self.check_repair(&fp, &fsgeom) {
+                CheckRepair::ExitWith(ret) => return Ok(ret),
+                CheckRepair::Downgrade => self.repair = false,
+                CheckRepair::Proceed => {}
             }
         }
 
@@ -205,6 +279,7 @@ impl From<Cli> for App {
             json: cli.0.get_flag("json"),
             repair: cli.0.get_flag("repair"),
             check: cli.0.get_flag("check"),
+            autofsck: cli.0.get_flag("autofsck"),
         }
     }
 }
@@ -222,7 +297,7 @@ fn main() -> ExitCode {
         printlogln!("args: {:?}", args);
     }
 
-    let app: App = args.into();
+    let mut app: App = args.into();
     match app.main() {
         Ok(f) => f,
         Err(e) => {
diff --git a/m4/package_rust.m4 b/m4/package_rust.m4
index 192d84651df909..109e4ba51d6356 100644
--- a/m4/package_rust.m4
+++ b/m4/package_rust.m4
@@ -134,6 +134,7 @@ enumset = { version = "1.0.12" }
 strum = { version = "0" }				# 0.19.2
 strum_macros = { version = "0" }			# 0.19.2
 serde_json = { version = "1.0.87" }
+libc = { version = "0" }				# 0.2.139
 ],
     [yes], [no])
 ])

