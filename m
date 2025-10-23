Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2961CD2C
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178576; cv=none; b=kyPHSSUQTSDIoNCdahtPjvDMhpIgQlATenofL3Jx2NaL75v9Yv7etmVj3jn3phyLgAt96JusP3lTStDwBhEA4HwUYEJz1dEqaKS75Zq+/WnFfnN/998nbEsgRvWi35o4g78uNa2RspU80h4cVBkhF5U2wxnHW7a0lnmc+EROkqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178576; c=relaxed/simple;
	bh=B6WKjDtx9uUlkpksnwJIlnS81ZFbiJQBpu1C7PRvGRk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GKoUBix6UfirWsVOPAonyRDcEU1hIuWs2H4kOzrMzW9ExU8FeIg01gR/RUJ/uKnLPYAUv9vjtCB0hDkHinDTiPZZma7cxkqGMXau+2IvxXVNRVfNjeSV28oBjE6s1fqSXMDcoCdTx6XXsZGznOMhIpk5hNR5ngkjXcp3Nkr4na8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6bfVCMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6bfVCMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710DDC4CEE7;
	Thu, 23 Oct 2025 00:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178575;
	bh=B6WKjDtx9uUlkpksnwJIlnS81ZFbiJQBpu1C7PRvGRk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f6bfVCMlxUT6+NHUYMdYzLL7XyjG7lWvuhnol5dKYCu2wjHIekejCEJp3GJAMigYr
	 5IC4tI/cE8F+FDMnHFJgZ4gmOiOptRSf3F5/pnxf0n7yFmWi9LlLcqet1avnKDP7Xi
	 bfiEViylN6PNygLXU6TNLwrIpSdylZSGKXralFc9CYcvbJ5NkHCuyrdeo6WkKjARGS
	 YJ5QyTPp/6HxAgCi3IEV9qfw4U0nfmbh53pweN2ZD6UkjOzavCsKCSWhjEC0V0dA6C
	 RX4zueusOuqjmQyerRR0NXBDxhAzyN+ixecEzsEBDvzHsF+EqW8RBcflUz1Oi/MDgC
	 nN+RuNocu/peA==
Date: Wed, 22 Oct 2025 17:16:15 -0700
Subject: [PATCH 15/19] xfs_healer: run full scrub after lost corruption events
 or targeted repair failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748539.1029045.17627079124057784211.stgit@frogsfrogsfrogs>
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

If we fail to perform a spot repair of metadata or the kernel tells us
that it lost corruption events due to queue limits, initiate a full run
of the online fsck service to try to fix the error.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile               |    1 +
 healer/src/healthmon/event.rs |   12 +++++++-
 healer/src/main.rs            |    4 ++-
 healer/src/repair.rs          |   60 ++++++++++++++++++++++++++++++++++++++++-
 healer/src/util.rs            |    9 ++++++
 healer/src/weakhandle.rs      |   22 +++++++++++++++
 healer/src/xfsprogs.rs.in     |    1 +
 7 files changed, 104 insertions(+), 5 deletions(-)


diff --git a/healer/Makefile b/healer/Makefile
index 76977e527c56e6..ae01e30403d0e5 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -131,6 +131,7 @@ src/xfsprogs.rs: src/xfsprogs.rs.in $(builddefs)
 	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@PACKAGE@|$(PKG_NAME)|g" \
 		   -e "s|@LOCALEDIR@|$(PKG_LOCALE_DIR)|g" \
+		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
 		   < $< > $@
 
 $(CARGO_MANIFEST): $(CARGO_MANIFEST).in $(builddefs)
diff --git a/healer/src/healthmon/event.rs b/healer/src/healthmon/event.rs
index ea3a6b21f744df..702d460bca2816 100644
--- a/healer/src/healthmon/event.rs
+++ b/healer/src/healthmon/event.rs
@@ -22,7 +22,7 @@ pub trait XfsHealthEvent {
     fn format(&self, fh: &WeakHandle) -> (Option<PathBuf>, String);
 
     /// Generate the inputs to a kernel scrub ioctl
-    fn schedule_repairs(&self) -> Vec<Repair> {
+    fn schedule_repairs(&self, _everything: bool) -> Vec<Repair> {
         vec![]
     }
 }
@@ -32,7 +32,7 @@ pub trait XfsHealthEvent {
 #[macro_export]
 macro_rules! schedule_repairs {
     ($event_type:ty , $lambda: expr ) => {
-        fn schedule_repairs(&self) -> Vec<$crate::repair::Repair> {
+        fn schedule_repairs(&self, _: bool) -> Vec<$crate::repair::Repair> {
             if self.status != $crate::healthmon::event::XfsHealthStatus::Sick {
                 return vec![];
             }
@@ -89,6 +89,14 @@ impl XfsHealthEvent for LostEvent {
     fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
         (None, format!("{} {}", self.count, M_("events lost")))
     }
+
+    fn schedule_repairs(&self, everything: bool) -> Vec<Repair> {
+        if everything {
+            vec![]
+        } else {
+            vec![Repair::full_repair()]
+        }
+    }
 }
 
 /// Event for the monitor starting up
diff --git a/healer/src/main.rs b/healer/src/main.rs
index 4d0f6021177ac9..b7d4b0dfc6a083 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -109,6 +109,7 @@ struct App {
 #[derive(Debug)]
 struct EventThread {
     log: bool,
+    everything: bool,
     repair: bool,
 }
 
@@ -118,6 +119,7 @@ impl EventThread {
     fn new(app: &App) -> Self {
         EventThread {
             log: app.log,
+            everything: app.everything,
             repair: app.repair,
         }
     }
@@ -162,7 +164,7 @@ impl App {
                     };
                 }
                 if et.repair {
-                    for mut repair in event.schedule_repairs() {
+                    for mut repair in event.schedule_repairs(et.everything) {
                         repair.perform(&fh)
                     }
                 }
diff --git a/healer/src/repair.rs b/healer/src/repair.rs
index c0cd7d64306536..975c3cb9cb412a 100644
--- a/healer/src/repair.rs
+++ b/healer/src/repair.rs
@@ -3,6 +3,7 @@
  * Copyright (C) 2025 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
+use crate::badness;
 use crate::display_for_enum;
 use crate::healthmon::fs::XfsWholeFsMetadata;
 use crate::healthmon::groups::{XfsPeragMetadata, XfsRtgroupMetadata};
@@ -12,31 +13,35 @@ use crate::weakhandle::WeakHandle;
 use crate::xfs_fs;
 use crate::xfs_fs::xfs_scrub_metadata;
 use crate::xfs_types::{XfsAgNumber, XfsFid, XfsRgNumber};
+use crate::xfsprogs;
 use crate::xfsprogs::M_;
 use anyhow::{Context, Result};
 use nix::ioctl_readwrite;
 use std::fs::File;
 use std::os::fd::AsRawFd;
+use std::process::Command;
 
 ioctl_readwrite!(xfs_ioc_scrub_metadata, 'X', 60, xfs_scrub_metadata);
 
 /// Classification information for later reporting
-#[derive(Debug)]
+#[derive(Debug, PartialEq)]
 enum RepairGroup {
     WholeFs,
     PerAg,
     RtGroup,
     File,
+    FullRepair,
 }
 
 /// What happened when we tried to repair something?
-#[derive(Debug)]
+#[derive(Debug, PartialEq)]
 enum RepairOutcome {
     Queued,
     Success,
     Unnecessary,
     MightBeOk,
     Failed,
+    Running,
 }
 
 display_for_enum!(RepairOutcome, {
@@ -45,6 +50,7 @@ display_for_enum!(RepairOutcome, {
     MightBeOk   => M_("Seems correct but cross-referencing failed; offline repair recommended."),
     Unnecessary => M_("No modification needed."),
     Success     => M_("Repairs successful."),
+    Running     => M_("Repairs in progress."),
 });
 
 /// Kernel scrub type code
@@ -245,6 +251,18 @@ impl Repair {
         }
     }
 
+    /// Schedule the full online fsck
+    pub fn full_repair() -> Repair {
+        Repair {
+            group: RepairGroup::FullRepair,
+            detail: xfs_scrub_metadata {
+                ..Default::default()
+            },
+            outcome: RepairOutcome::Queued,
+            scrub_type: XfsScrubType(0),
+        }
+    }
+
     /// Decode what happened when we tried to repair
     fn outcome(detail: &xfs_scrub_metadata) -> RepairOutcome {
         const REPAIR_FAILED: u32 =
@@ -282,6 +300,9 @@ impl Repair {
 
                 format!("{} {} {}", M_("Repair of"), fid, self.scrub_type)
             }
+            RepairGroup::FullRepair => {
+                M_("Full repair")
+            }
         }
     }
 
@@ -298,8 +319,37 @@ impl Repair {
         fh.mountpoint()
     }
 
+    /// Start the background xfs_scrub service on a filesystem in the hopes that its autofsck
+    /// setting allows repairs.  Does not wait for the service to complete.  Multiple activations
+    /// while the service runs will be coalesced into a single service instance.
+    fn run_full_repair(&self, fh: &WeakHandle) -> Result<bool> {
+        let unit_name = fh.instance_unit_name(xfsprogs::XFS_SCRUB_SVCNAME)?;
+
+        let output = Command::new("systemctl")
+            .arg("start")
+            .arg("--no-block")
+            .arg(unit_name)
+            .output()?;
+
+        if !output.status.success() {
+            return Err(badness!(M_("Could not start xfs_scrub service.")).into());
+        }
+
+        Ok(true)
+    }
+
     /// Call the kernel to repair things
     fn repair(&mut self, fh: &WeakHandle) -> Result<bool> {
+        if self.group == RepairGroup::FullRepair {
+            let started = self
+                .run_full_repair(fh)
+                .with_context(|| self.summary().to_string())?;
+            if started {
+                self.outcome = RepairOutcome::Running;
+            }
+            return Ok(started);
+        }
+
         let fp = fh
             .reopen()
             .with_context(|| M_("Reopening filesystem to repair metadata"))?;
@@ -327,6 +377,12 @@ impl Repair {
                     self.summary(),
                     self.outcome
                 );
+
+                // Transform into a full repair if we failed to fix things.
+                if self.outcome == RepairOutcome::Failed && self.group != RepairGroup::FullRepair {
+                    self.group = RepairGroup::FullRepair;
+                    self.perform(fh);
+                }
             }
         };
     }
diff --git a/healer/src/util.rs b/healer/src/util.rs
index bce48f83b01da0..5340724654552e 100644
--- a/healer/src/util.rs
+++ b/healer/src/util.rs
@@ -55,6 +55,15 @@ macro_rules! display_for_enum {
     };
 }
 
+/// Simple macro for creating errors for random badness.  The only parameter describes why the
+/// badness happened.
+#[macro_export]
+macro_rules! badness {
+    ($message:expr) => {{
+        std::io::Error::new(std::io::ErrorKind::Other, $message)
+    }};
+}
+
 /// Format an enum set into a string
 pub fn format_set<T: EnumSetType + Display>(f: EnumSet<T>) -> String {
     let mut ret = "".to_string();
diff --git a/healer/src/weakhandle.rs b/healer/src/weakhandle.rs
index 8c3dd7e04a64c2..8650f6b9633b4d 100644
--- a/healer/src/weakhandle.rs
+++ b/healer/src/weakhandle.rs
@@ -4,6 +4,7 @@
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 use crate::baddata;
+use crate::badness;
 use crate::xfs_fs::xfs_fid;
 use crate::xfs_fs::xfs_fsop_geom;
 use crate::xfs_fs::xfs_fsop_handlereq;
@@ -13,13 +14,16 @@ use crate::xfsprogs::M_;
 use anyhow::{Error, Result};
 use nix::ioctl_readwrite;
 use nix::libc::O_LARGEFILE;
+use std::ffi::OsString;
 use std::fmt::Display;
 use std::fmt::Formatter;
 use std::fs::File;
 use std::io::ErrorKind;
 use std::os::fd::AsRawFd;
 use std::os::raw::c_void;
+use std::os::unix::ffi::OsStringExt;
 use std::path::PathBuf;
+use std::process::Command;
 use std::sync::Arc;
 
 ioctl_readwrite!(xfs_ioc_fd_to_handle, 'X', 106, xfs_fsop_handlereq);
@@ -134,6 +138,24 @@ impl WeakHandle {
     pub fn can_get_parents(&self) -> bool {
         self.has_parent
     }
+
+    /// Compute the systemd instance unit name for this mountpoint.
+    pub fn instance_unit_name(&self, service_template: &str) -> Result<OsString> {
+        let output = Command::new("systemd-escape")
+            .arg("--template")
+            .arg(service_template)
+            .arg("--path")
+            .arg(self.mountpoint.as_ref())
+            .output()?;
+
+        if !output.status.success() {
+            return Err(badness!("Could not format systemd instance unit name.").into());
+        }
+
+        // systemd always adds a newline to the end of the output; remove it
+        let trunc_out = &output.stdout[0..output.stdout.len() - 1];
+        Ok(OsString::from_vec(trunc_out.to_vec()))
+    }
 }
 
 impl Display for WeakHandle {
diff --git a/healer/src/xfsprogs.rs.in b/healer/src/xfsprogs.rs.in
index 0c5cd2d00f7c26..e57995d5a9c429 100644
--- a/healer/src/xfsprogs.rs.in
+++ b/healer/src/xfsprogs.rs.in
@@ -6,6 +6,7 @@
 #![allow(unexpected_cfgs)]
 
 pub const VERSION: &str = "@pkg_version@";
+pub const XFS_SCRUB_SVCNAME: &str = "@scrub_svcname@";
 
 /// Try to initialize a localization library.  Like the other xfsprogs utilities, we don't care
 /// if this fails.

