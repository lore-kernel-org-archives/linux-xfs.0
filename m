Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E2345009
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178607; cv=none; b=nAH9OR5i4v4sgy16d6epLdRkE+WEK3RgnrkrBk0KRs5rt/H4jumWGQGT56lIthZHxmu8mMYOz81rElauYHHA46UxOolruTwxBgdEsm/t6phz00l8kZm8CcT8ZbPIbNzv0umhwSb6Y+9iy1VYvgnoyxMzTQeKL4wj+QeRP19RJ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178607; c=relaxed/simple;
	bh=kcdIBsSL4cnVHIXgsBCZSB+NheDmAmioH6TkBGIPttY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W/1fej+zJIL5bJKB2tGOzsvg/9esddqTHYU70zMiHNL8+5r4AfgL4+xrvyw9IwIDAKGAJguZ0xGXqN4icn+aRc5iAYf4T0fMgtMEpoErvb++oLNZFJ2iMUqjm4c4qVLXvAusGa52Vme2eZMTRA+neYzr71MbLV8nTr+PtNYD4+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUUbLPUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUUbLPUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD081C4CEE7;
	Thu, 23 Oct 2025 00:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178606;
	bh=kcdIBsSL4cnVHIXgsBCZSB+NheDmAmioH6TkBGIPttY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OUUbLPUmmRVePyigELM+5wPDlF5ItQgLi33M2Dw92ipW+Dx1yInGqQP50FasT9X5S
	 LVwgyhQ7+HdG4P3z3VYn3WjRRhESATnqpvaLy7gRMhfz3Cb33TSSMSJHYw42cVYynV
	 NtM1UsKlY/2B2KIsip7LWDtUQTLzd19Ry9Ul0iqQPPin9qltlxZR1Qn26vHO4AMD/P
	 UHjLmMI+xqzn8pXQ8s6t0Ig1yjwGMHNHMe/2CEw5EJvv5KDFOgXkTjtnY7yAzzNOxm
	 xqOuIpBUGHm0oJ00ndxLw963sxIBI53dJC3U4eiiNqrMVbixwcsI+olgYNTS5djf9+
	 PZ1iq05Z4nFEg==
Date: Wed, 22 Oct 2025 17:16:46 -0700
Subject: [PATCH 17/19] xfs_healer: validate that repair fds point to the
 monitored fs in Rust
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748577.1029045.1555759920544449813.stgit@frogsfrogsfrogs>
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

When xfs_healer reopens a mountpoint to perform a repair, it should
validate that the opened fd points to a file on the same filesystem as
the one being monitored.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile                 |    3 ++-
 healer/src/getparents.rs        |    2 +-
 healer/src/healthmon/cstruct.rs |   15 +++++++++++++--
 healer/src/healthmon/json.rs    |   15 +++++++++++++--
 healer/src/healthmon/mod.rs     |    3 +++
 healer/src/healthmon/samefs.rs  |   33 +++++++++++++++++++++++++++++++++
 healer/src/main.rs              |   30 +++++++++++++++++++++++++-----
 healer/src/repair.rs            |   11 ++++++-----
 healer/src/weakhandle.rs        |   14 +++++++++-----
 9 files changed, 105 insertions(+), 21 deletions(-)
 create mode 100644 healer/src/healthmon/samefs.rs


diff --git a/healer/Makefile b/healer/Makefile
index b3a9ed579a2a26..661f7bb27f02a3 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -35,7 +35,8 @@ RUSTFILES = \
 	src/healthmon/groups.rs \
 	src/healthmon/inodes.rs \
 	src/healthmon/json.rs \
-	src/healthmon/mod.rs
+	src/healthmon/mod.rs \
+	src/healthmon/samefs.rs
 
 BUILT_RUSTFILES = \
 	src/xfs_fs.rs \
diff --git a/healer/src/getparents.rs b/healer/src/getparents.rs
index 46f9724ee7cf7c..9ddbd209f8a50c 100644
--- a/healer/src/getparents.rs
+++ b/healer/src/getparents.rs
@@ -188,7 +188,7 @@ impl WeakHandle {
             return None;
         }
 
-        let fp = match self.reopen() {
+        let fp = match self.reopen(|_| true) {
             Err(_) => return None,
             Ok(x) => x,
         };
diff --git a/healer/src/healthmon/cstruct.rs b/healer/src/healthmon/cstruct.rs
index 58463b0f6fa5b9..c9f77be25db410 100644
--- a/healer/src/healthmon/cstruct.rs
+++ b/healer/src/healthmon/cstruct.rs
@@ -17,6 +17,7 @@ use crate::healthmon::groups::{XfsPeragEvent, XfsPeragMetadata};
 use crate::healthmon::groups::{XfsRtgroupEvent, XfsRtgroupMetadata};
 use crate::healthmon::inodes::{XfsFileIoErrorEvent, XfsFileIoErrorType};
 use crate::healthmon::inodes::{XfsInodeEvent, XfsInodeMetadata};
+use crate::healthmon::samefs::SameFs;
 use crate::healthmon::xfs_ioc_health_monitor;
 use crate::xfs_fs;
 use crate::xfs_fs::xfs_health_monitor;
@@ -33,6 +34,7 @@ use std::io::Read;
 use std::os::fd::AsRawFd;
 use std::os::fd::FromRawFd;
 use std::path::Path;
+use std::sync::Arc;
 
 /// Boilerplate to stamp out functions to convert a u32 mask to an enumset
 /// of the given enum type.
@@ -74,6 +76,9 @@ pub struct CStructMonitor<'a> {
 
     /// path to the filesystem mountpoint
     mountpoint: &'a Path,
+
+    /// object that repair threads use to check their reopened files against the monitored fs
+    samefs: Arc<SameFs>,
 }
 
 impl CStructMonitor<'_> {
@@ -90,17 +95,23 @@ impl CStructMonitor<'_> {
 
         // SAFETY: Trusting the kernel ioctl not to corrupt stack contents, and to return us a valid
         // file description number.
-        let health_fp = unsafe {
+        let (health_fp, samefs) = unsafe {
             let health_fd = xfs_ioc_health_monitor(fp.as_raw_fd(), &hminfo)?;
-            File::from_raw_fd(health_fd)
+            (File::from_raw_fd(health_fd), SameFs::new(health_fd))
         };
         drop(fp);
 
         Ok(CStructMonitor {
             objiter: BufReader::new(health_fp),
             mountpoint,
+            samefs: samefs.into(),
         })
     }
+
+    /// Return an object that can be used to check reopened files
+    pub fn new_samefs(&self) -> Arc<SameFs> {
+        self.samefs.clone()
+    }
 }
 
 enum_from_field!(XfsHealthStatus, {
diff --git a/healer/src/healthmon/json.rs b/healer/src/healthmon/json.rs
index 2fae6f4b48e68b..ae1389aa73dd4b 100644
--- a/healer/src/healthmon/json.rs
+++ b/healer/src/healthmon/json.rs
@@ -17,6 +17,7 @@ use crate::healthmon::groups::{XfsPeragEvent, XfsPeragMetadata};
 use crate::healthmon::groups::{XfsRtgroupEvent, XfsRtgroupMetadata};
 use crate::healthmon::inodes::{XfsFileIoErrorEvent, XfsFileIoErrorType};
 use crate::healthmon::inodes::{XfsInodeEvent, XfsInodeMetadata};
+use crate::healthmon::samefs::SameFs;
 use crate::healthmon::xfs_ioc_health_monitor;
 use crate::printlogln;
 use crate::xfs_fs;
@@ -38,6 +39,7 @@ use std::os::fd::AsRawFd;
 use std::os::fd::FromRawFd;
 use std::path::Path;
 use std::str::FromStr;
+use std::sync::Arc;
 
 /// Boilerplate to stamp out functions to convert json array to an enumset
 /// of the given enum type; or return an error with the given message.
@@ -106,6 +108,9 @@ pub struct JsonMonitor<'a> {
 
     /// are we debugging?
     debug: bool,
+
+    /// object that repair threads use to check their reopened files against the monitored fs
+    samefs: Arc<SameFs>,
 }
 
 impl JsonMonitor<'_> {
@@ -127,9 +132,9 @@ impl JsonMonitor<'_> {
 
         // SAFETY: Trusting the kernel ioctl not to corrupt stack contents, and to return us a valid
         // file description number.
-        let health_fp = unsafe {
+        let (health_fp, samefs) = unsafe {
             let health_fd = xfs_ioc_health_monitor(fp.as_raw_fd(), &hminfo)?;
-            File::from_raw_fd(health_fd)
+            (File::from_raw_fd(health_fd), SameFs::new(health_fd))
         };
         drop(fp);
 
@@ -137,8 +142,14 @@ impl JsonMonitor<'_> {
             lineiter: BufReader::new(health_fp).lines(),
             mountpoint,
             debug,
+            samefs: samefs.into(),
         })
     }
+
+    /// Return an object that can be used to check reopened files
+    pub fn new_samefs(&self) -> Arc<SameFs> {
+        self.samefs.clone()
+    }
 }
 
 /// Raw health event, used to create the real objects
diff --git a/healer/src/healthmon/mod.rs b/healer/src/healthmon/mod.rs
index f73babbe001154..624b6f231dd4ce 100644
--- a/healer/src/healthmon/mod.rs
+++ b/healer/src/healthmon/mod.rs
@@ -5,6 +5,7 @@
  */
 use crate::xfs_fs;
 use crate::xfs_fs::xfs_health_monitor;
+use crate::xfs_fs::xfs_health_samefs;
 use nix::ioctl_write_ptr;
 use std::fs::File;
 use std::os::fd::AsRawFd;
@@ -16,8 +17,10 @@ pub mod fs;
 pub mod groups;
 pub mod inodes;
 pub mod json;
+pub mod samefs;
 
 ioctl_write_ptr!(xfs_ioc_health_monitor, 'X', 68, xfs_health_monitor);
+ioctl_write_ptr!(xfs_ioc_health_samefs, 'X', 69, xfs_health_samefs);
 
 /// Check if the open file supports a health monitor.
 pub fn is_supported(fp: &File, use_json: bool) -> bool {
diff --git a/healer/src/healthmon/samefs.rs b/healer/src/healthmon/samefs.rs
new file mode 100644
index 00000000000000..7b578f00556eaf
--- /dev/null
+++ b/healer/src/healthmon/samefs.rs
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::healthmon::xfs_ioc_health_samefs;
+use crate::xfs_fs::xfs_health_samefs;
+use std::fs::File;
+use std::os::fd::AsRawFd;
+use std::os::raw::c_int;
+
+pub struct SameFs(c_int);
+
+/// Predicate object that unsafely borrows the raw fd from a health monitor to check if a reopened
+/// file is actually on the same fs.
+impl SameFs {
+    /// Create a new predicate from the given raw file descriptor.  Caller must ensure that the
+    /// fd is not closed before this object is destroyed.
+    pub fn new(fd: c_int) -> SameFs {
+        SameFs(fd)
+    }
+
+    /// Does this file point to the same filesystem as the health monitor?
+    pub fn is_same_fs(&self, fp: &File) -> bool {
+        let hms = xfs_health_samefs {
+            fd: fp.as_raw_fd(),
+            ..Default::default()
+        };
+
+        // any error means this isn't the same fs mount
+        !matches!(unsafe { xfs_ioc_health_samefs(self.0, &hms) }, Err(_e))
+    }
+}
diff --git a/healer/src/main.rs b/healer/src/main.rs
index b7d4b0dfc6a083..472da3a579051c 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -16,6 +16,7 @@ use xfs_healer::healthmon::cstruct::CStructMonitor;
 use xfs_healer::healthmon::event::XfsHealthEvent;
 use xfs_healer::healthmon::json::JsonEventWrapper;
 use xfs_healer::healthmon::json::JsonMonitor;
+use xfs_healer::healthmon::samefs::SameFs;
 use xfs_healer::printlogln;
 use xfs_healer::repair::Repair;
 use xfs_healer::weakhandle::WeakHandle;
@@ -148,6 +149,7 @@ impl App {
     /// Handle a health event that has been decoded into real objects
     fn process_event(
         et: EventThread,
+        samefs: Arc<SameFs>,
         fh: Arc<WeakHandle>,
         cooked: Result<Box<dyn XfsHealthEvent>>,
     ) {
@@ -165,7 +167,7 @@ impl App {
                 }
                 if et.repair {
                     for mut repair in event.schedule_repairs(et.everything) {
-                        repair.perform(&fh)
+                        repair.perform(&samefs, &fh)
                     }
                 }
             }
@@ -176,22 +178,24 @@ impl App {
     fn dispatch_json_event(
         threads: &ThreadPool,
         et: EventThread,
+        samefs: Arc<SameFs>,
         fh: Arc<WeakHandle>,
         raw_event: JsonEventWrapper,
     ) {
         threads.execute(move || {
-            App::process_event(et, fh, raw_event.cook());
+            App::process_event(et, samefs, fh, raw_event.cook());
         })
     }
 
     fn dispatch_cstruct_event(
         threads: &ThreadPool,
         et: EventThread,
+        samefs: Arc<SameFs>,
         fh: Arc<WeakHandle>,
         raw_event: xfs_health_monitor_event,
     ) {
         threads.execute(move || {
-            App::process_event(et, fh, raw_event.cook());
+            App::process_event(et, samefs, fh, raw_event.cook());
         })
     }
 
@@ -308,24 +312,40 @@ impl App {
         if self.json {
             let hmon = JsonMonitor::try_new(fp, &self.path, self.everything, self.debug)
                 .with_context(|| M_("Opening js health monitor file"))?;
+            let samefs = hmon.new_samefs();
 
             for raw_event in hmon {
-                App::dispatch_json_event(&threads, EventThread::new(self), fh.clone(), raw_event);
+                App::dispatch_json_event(
+                    &threads,
+                    EventThread::new(self),
+                    samefs.clone(),
+                    fh.clone(),
+                    raw_event,
+                );
             }
+
+            // Prohibit hmon from leaving scope (and closing the health mon fd) before the worker
+            // threads have finished whatever they're doing.
+            threads.join();
         } else {
             let hmon = CStructMonitor::try_new(fp, &self.path, self.everything)
                 .with_context(|| M_("Opening health monitor file"))?;
+            let samefs = hmon.new_samefs();
 
             for raw_event in hmon {
                 App::dispatch_cstruct_event(
                     &threads,
                     EventThread::new(self),
+                    samefs.clone(),
                     fh.clone(),
                     raw_event,
                 );
             }
+
+            // Prohibit hmon from leaving scope (and closing the health mon fd) before the worker
+            // threads have finished whatever they're doing.
+            threads.join();
         }
-        threads.join();
 
         Ok(ExitCode::SUCCESS)
     }
diff --git a/healer/src/repair.rs b/healer/src/repair.rs
index 975c3cb9cb412a..bc2dab75a99586 100644
--- a/healer/src/repair.rs
+++ b/healer/src/repair.rs
@@ -8,6 +8,7 @@ use crate::display_for_enum;
 use crate::healthmon::fs::XfsWholeFsMetadata;
 use crate::healthmon::groups::{XfsPeragMetadata, XfsRtgroupMetadata};
 use crate::healthmon::inodes::XfsInodeMetadata;
+use crate::healthmon::samefs::SameFs;
 use crate::printlogln;
 use crate::weakhandle::WeakHandle;
 use crate::xfs_fs;
@@ -339,7 +340,7 @@ impl Repair {
     }
 
     /// Call the kernel to repair things
-    fn repair(&mut self, fh: &WeakHandle) -> Result<bool> {
+    fn repair(&mut self, samefs: &SameFs, fh: &WeakHandle) -> Result<bool> {
         if self.group == RepairGroup::FullRepair {
             let started = self
                 .run_full_repair(fh)
@@ -351,7 +352,7 @@ impl Repair {
         }
 
         let fp = fh
-            .reopen()
+            .reopen(|fp| samefs.is_same_fs(fp))
             .with_context(|| M_("Reopening filesystem to repair metadata"))?;
 
         // SAFETY: Trusting the kernel not to corrupt memory.
@@ -365,8 +366,8 @@ impl Repair {
     }
 
     /// Try to repair something, or log whatever went wrong
-    pub fn perform(&mut self, fh: &WeakHandle) {
-        match self.repair(fh) {
+    pub fn perform(&mut self, samefs: &SameFs, fh: &WeakHandle) {
+        match self.repair(samefs, fh) {
             Err(e) => {
                 eprintln!("{}: {:#}", self.repair_path(fh), e);
             }
@@ -381,7 +382,7 @@ impl Repair {
                 // Transform into a full repair if we failed to fix things.
                 if self.outcome == RepairOutcome::Failed && self.group != RepairGroup::FullRepair {
                     self.group = RepairGroup::FullRepair;
-                    self.perform(fh);
+                    self.perform(samefs, fh);
                 }
             }
         };
diff --git a/healer/src/weakhandle.rs b/healer/src/weakhandle.rs
index 9f0dc77b822077..b958b3ccbed793 100644
--- a/healer/src/weakhandle.rs
+++ b/healer/src/weakhandle.rs
@@ -92,10 +92,14 @@ pub struct WeakHandle {
 
 impl WeakHandle {
     /// Try to reopen the filesystem with a given mountpoint
-    fn reopen_from(&self, mountpoint: &Path) -> Result<File> {
+    fn reopen_from(
+        &self,
+        mountpoint: &Path,
+        is_acceptable: impl Fn(&File) -> bool,
+    ) -> Result<File> {
         let fp = File::open(mountpoint)?;
 
-        if xfs_handle::try_from(&fp)? != self.handle {
+        if xfs_handle::try_from(&fp)? != self.handle || !is_acceptable(&fp) {
             let s = format!(
                 "{} {}: {}",
                 M_("reopening"),
@@ -109,9 +113,9 @@ impl WeakHandle {
     }
 
     /// Try to reopen the filesystem from which we got the handle.
-    pub fn reopen(&self) -> Result<File> {
+    pub fn reopen(&self, is_acceptable: impl Fn(&File) -> bool) -> Result<File> {
         // First try the original mountpoint
-        let orig_result = self.reopen_from(&self.mountpoint);
+        let orig_result = self.reopen_from(&self.mountpoint, &is_acceptable);
         if let Ok(x) = orig_result {
             return Ok(x);
         }
@@ -119,7 +123,7 @@ impl WeakHandle {
         // Now scan /proc/self/mounts for any other bind mounts of this filesystem
         let entries = MountEntries::try_new()?;
         for mntent in entries.filter(|x| x.fstype == "xfs" && x.fsname == self.fsname) {
-            if let Ok(x) = self.reopen_from(&mntent.dir) {
+            if let Ok(x) = self.reopen_from(&mntent.dir, &is_acceptable) {
                 return Ok(x);
             }
         }

