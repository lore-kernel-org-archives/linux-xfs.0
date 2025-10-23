Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7791862
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178497; cv=none; b=gTnvjGFdL9IaGghK1QST25ezx3ZQTQpKyg6kVFiOP2qkwJvWBjj9OsS5rHcRA1/WXS0la7egMLTyoE6bNY9TB+DVAp+6wA3LPtYjy1wpILMHldpwCwO5MgeY/cxJIC0+uXopQ2HsvvztgR2NZ+dgugTlIMHEf2agKI/nld2XaUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178497; c=relaxed/simple;
	bh=UHABBhC5zSxjmS46wBGGPPY2itCCyEAeVHRR8C1Z5VM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qGdTbK6h6epky5qSSCK4BQyDOftm5FY+0gb8J6V4m2Gydylhj5XAeyfGX7V3R9LxWA/AhzooIqEGQaomhKm0eYeCwQqnx3UlNiFK5kKw3qyMuYq/gMHJpnopZsa1H+ye7OgQj5Df5YmlF3Bo1jT3NivHX/eqF52qv7aJywBAwpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSSqui0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSSqui0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5157EC4CEE7;
	Thu, 23 Oct 2025 00:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178497;
	bh=UHABBhC5zSxjmS46wBGGPPY2itCCyEAeVHRR8C1Z5VM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mSSqui0piZZaUezuHA7L9szNvjh1iTmpLoBx9B4z3GXVxXI661es7LfJocWVfRjuN
	 vn7Hct3eXKq1AuOQZTor13TcxsGCBuS/iHkGXqYtt+H7P6pj+ShKq3+cjuO4VFYCEH
	 zdCmShK0C3SGJFOQEoSzjLkQWIKddLmnMa5BR8t0gfU1T5yOxed3l3YxN74IuRAv5g
	 sXaXOXEJKUO+BBvNGkqbXQsyF3PZKyCVpL10kGVJEgdC3d9aIrLfUdnGMXbwFFEBnd
	 LheOC7m5dBsVeFKTUjn+nFOo0wh06XSaBfPP69SKVgAyJoeWTmFiFxOB/StfTRpiOc
	 fB2wsmUFfOaeQ==
Date: Wed, 22 Oct 2025 17:14:56 -0700
Subject: [PATCH 10/19] xfs_healer: use getparents to look up file names
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748445.1029045.13913168782259377552.stgit@frogsfrogsfrogs>
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

If the kernel tells about something that happened to a file, use the
GETPARENTS ioctl to try to look up the path to that file for more
ergonomic reporting.  In Rust.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile                |    1 
 healer/src/getparents.rs       |  210 ++++++++++++++++++++++++++++++++++++++++
 healer/src/healthmon/event.rs  |   19 ++--
 healer/src/healthmon/fs.rs     |   38 ++++---
 healer/src/healthmon/groups.rs |   32 ++++--
 healer/src/healthmon/inodes.rs |   22 +++-
 healer/src/lib.rs              |    1 
 healer/src/main.rs             |    8 +-
 healer/src/repair.rs           |   22 ++++
 healer/src/weakhandle.rs       |   30 ++++++
 10 files changed, 339 insertions(+), 44 deletions(-)
 create mode 100644 healer/src/getparents.rs


diff --git a/healer/Makefile b/healer/Makefile
index 03bfd853a193ee..796bed3e166487 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -18,6 +18,7 @@ HFILES = \
 
 RUSTFILES = \
 	src/fsgeom.rs \
+	src/getparents.rs \
 	src/lib.rs \
 	src/main.rs \
 	src/repair.rs \
diff --git a/healer/src/getparents.rs b/healer/src/getparents.rs
new file mode 100644
index 00000000000000..d6d7020e08f9d2
--- /dev/null
+++ b/healer/src/getparents.rs
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::weakhandle::WeakHandle;
+use crate::xfs_fs;
+use crate::xfs_fs::xfs_getparents;
+use crate::xfs_fs::xfs_getparents_by_handle;
+use crate::xfs_fs::xfs_getparents_rec;
+use crate::xfs_fs::xfs_handle;
+use crate::xfs_types::XfsFid;
+use nix::ioctl_readwrite;
+use std::cmp::min;
+use std::ffi::CStr;
+use std::ffi::OsStr;
+use std::fs::File;
+use std::io::Result;
+use std::os::fd::AsRawFd;
+use std::os::unix::ffi::OsStrExt;
+use std::path::Path;
+use std::path::PathBuf;
+
+ioctl_readwrite!(
+    xfs_ioc_getparents_by_handle,
+    'X',
+    63,
+    xfs_getparents_by_handle
+);
+
+const GETPARENTS_BUFSIZE: usize = 65536;
+
+/// File parent
+#[derive(Debug)]
+struct XfsParent {
+    /// Filename within a directory
+    filename: PathBuf,
+
+    /// Handle to the parent
+    handle: xfs_handle,
+}
+
+/// Iterator for all parents of this file
+struct XfsGetParents<'a> {
+    /// Open file with which we can call the ioctl
+    fp: &'a File,
+
+    /// Head object to pass to GETPARENTS call
+    request: xfs_getparents_by_handle,
+
+    /// Buffer for receiving GETPARENTS information from kernel
+    buf: Vec<u8>,
+
+    /// Position of next parent record in buffer
+    bufpos: usize,
+}
+
+impl Iterator for XfsGetParents<'_> {
+    type Item = Result<XfsParent>;
+
+    /// Return parent pointer objects
+    fn next(&mut self) -> Option<Self::Item> {
+        // Ran out of buffer...
+        if self.bufpos == GETPARENTS_BUFSIZE {
+            const STOP_FLAGS: u32 =
+                xfs_fs::XFS_GETPARENTS_OFLAG_DONE | xfs_fs::XFS_GETPARENTS_OFLAG_ROOT;
+
+            // If the last request got all the parent pointers, stop
+            if self.request.gph_request.gp_oflags & STOP_FLAGS as xfs_fs::__u16 != 0 {
+                return None;
+            }
+
+            // SAFETY: Trusting the kernel to give us more parent data without corrupting memory.
+            match unsafe { xfs_ioc_getparents_by_handle(self.fp.as_raw_fd(), &mut self.request) } {
+                Err(e) => return Some(Err(e.into())),
+                Ok(_) => self.bufpos = 0,
+            }
+        }
+
+        // If the kernel says this is the root directory, return a parent
+        // with an empty filename, because errors abort the iterator.
+        if self.request.gph_request.gp_oflags & xfs_fs::XFS_GETPARENTS_OFLAG_ROOT as xfs_fs::__u16
+            != 0
+        {
+            self.bufpos = GETPARENTS_BUFSIZE;
+            return Some(Ok(XfsParent {
+                filename: PathBuf::from(""),
+                handle: self.request.gph_handle,
+            }));
+        }
+
+        // Cast the buffer contents to a getparents record
+        let ret = unsafe {
+            // SAFETY: Casting a pointer (encoded as a u64 to avoid thunking issues) to a raw
+            // pointer.  getparents.c in libfrog does the same thing.
+            let gpr: *const xfs_getparents_rec =
+                self.buf.as_ptr().add(self.bufpos) as *const xfs_getparents_rec;
+
+            // Advance the buffer pointer
+            self.bufpos += min(GETPARENTS_BUFSIZE - self.bufpos, (*gpr).gpr_reclen as usize);
+
+            // Construct a PathBuf from the raw bytes.  Don't use a slice here because the buffer
+            // contents will change with the next ioctl.  SAFETY: gpr_name is defined to be a
+            // null-terminated sequence, aka a C string.
+            let slice = CStr::from_ptr((*gpr).gpr_name.as_ptr());
+            let osstr = OsStr::from_bytes(slice.to_bytes());
+            let filename: &Path = osstr.as_ref();
+
+            // SAFETY: Copying from a raw pointer to a buffer containing xfs_handle to the
+            // xfs_handle in our new XfsParent object.
+            XfsParent {
+                filename: filename.to_path_buf(),
+                handle: (*gpr).gpr_parent,
+            }
+        };
+
+        Some(Ok(ret))
+    }
+}
+
+/// Create an iterator to walk the parents of a given handle, using the open
+/// file.
+fn from_handle(fp: &File, handle: xfs_handle) -> Result<XfsGetParents> {
+    let mut value: Vec<u8> = vec![0; GETPARENTS_BUFSIZE];
+
+    Ok(XfsGetParents {
+        request: xfs_getparents_by_handle {
+            gph_request: xfs_getparents {
+                gp_bufsize: GETPARENTS_BUFSIZE as xfs_fs::__u32,
+                gp_buffer: value.as_mut_ptr() as xfs_fs::__u64,
+                ..Default::default()
+            },
+            gph_handle: handle,
+        },
+        fp,
+        buf: value,
+        bufpos: GETPARENTS_BUFSIZE,
+    })
+}
+
+/// Recursively fill the path component vector.  Returns true if we walked up
+/// to the root directory and hence have a valid path, false if not, or None
+/// if some error occurred.  We only use paths for display purposes, so that's
+/// why we don't pass back errors.
+fn find_path_components(
+    fp: &File,
+    handle: xfs_handle,
+    depth: u32,
+    components: &mut Vec<PathBuf>,
+) -> Option<bool> {
+    // Don't let us go too deep in the directory hierarchy because this is a
+    // recursive function.
+    if depth > 256 {
+        return Some(false);
+    }
+
+    let parents = match from_handle(fp, handle) {
+        Err(_) => return None,
+        Ok(x) => x,
+    };
+
+    for p in parents {
+        match p {
+            Err(_) => return None,
+            Ok(parent) => {
+                if parent.filename == PathBuf::from("") {
+                    return Some(true);
+                }
+
+                components.push(parent.filename);
+                match find_path_components(fp, parent.handle, depth + 1, components) {
+                    None => return None,
+                    Some(true) => return Some(true),
+                    Some(false) => components.pop(),
+                };
+            }
+        };
+    }
+
+    Some(false)
+}
+
+impl WeakHandle<'_> {
+    /// Return a path to the root for the given soft handle and ino/gen info,
+    /// or None if errors occurred or we couldn't find the root.
+    pub fn path_for(&self, fid: XfsFid) -> Option<PathBuf> {
+        if !self.can_get_parents() {
+            return None;
+        }
+
+        let fp = match self.reopen() {
+            Err(_) => return None,
+            Ok(x) => x,
+        };
+        let handle = self.subst(fid);
+        let mut path_components: Vec<PathBuf> = Vec::new();
+
+        match find_path_components(&fp, handle, 0, &mut path_components) {
+            None => None,
+            Some(false) => None,
+            Some(true) => {
+                let mut ret: PathBuf = self.mountpoint().into();
+                for component in path_components.iter().rev() {
+                    ret.push(component);
+                }
+                Some(ret)
+            }
+        }
+    }
+}
diff --git a/healer/src/healthmon/event.rs b/healer/src/healthmon/event.rs
index 0fcd34dee38e4c..ea3a6b21f744df 100644
--- a/healer/src/healthmon/event.rs
+++ b/healer/src/healthmon/event.rs
@@ -5,7 +5,9 @@
  */
 use crate::display_for_enum;
 use crate::repair::Repair;
+use crate::weakhandle::WeakHandle;
 use crate::xfsprogs::M_;
+use std::path::PathBuf;
 use strum_macros::EnumString;
 
 /// Common behaviors of all health events
@@ -15,8 +17,9 @@ pub trait XfsHealthEvent {
         false
     }
 
-    /// Format this event as something we can display
-    fn format(&self) -> String;
+    /// Format this event as something we can display.  Returns an optional
+    /// pathname string, and the message.
+    fn format(&self, fh: &WeakHandle) -> (Option<PathBuf>, String);
 
     /// Generate the inputs to a kernel scrub ioctl
     fn schedule_repairs(&self) -> Vec<Repair> {
@@ -83,8 +86,8 @@ impl XfsHealthEvent for LostEvent {
         true
     }
 
-    fn format(&self) -> String {
-        format!("{} {}", self.count, M_("events lost"))
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (None, format!("{} {}", self.count, M_("events lost")))
     }
 }
 
@@ -92,8 +95,8 @@ impl XfsHealthEvent for LostEvent {
 pub struct RunningEvent {}
 
 impl XfsHealthEvent for RunningEvent {
-    fn format(&self) -> String {
-        M_("monitoring started")
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (None, M_("monitoring started"))
     }
 }
 
@@ -105,7 +108,7 @@ impl XfsHealthEvent for UnknownEvent {
         true
     }
 
-    fn format(&self) -> String {
-        M_("unrecognized event")
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (None, M_("unrecognized event"))
     }
 }
diff --git a/healer/src/healthmon/fs.rs b/healer/src/healthmon/fs.rs
index 7a2307d29e7abd..2145427d1905ca 100644
--- a/healer/src/healthmon/fs.rs
+++ b/healer/src/healthmon/fs.rs
@@ -9,10 +9,12 @@ use crate::healthmon::event::XfsHealthEvent;
 use crate::healthmon::event::XfsHealthStatus;
 use crate::repair::Repair;
 use crate::util::format_set;
+use crate::weakhandle::WeakHandle;
 use crate::xfs_types::XfsPhysRange;
 use crate::xfsprogs::M_;
 use enumset::EnumSet;
 use enumset::EnumSetType;
+use std::path::PathBuf;
 use strum_macros::EnumString;
 
 /// Metadata types for an XFS whole-fs metadata
@@ -58,12 +60,15 @@ impl XfsWholeFsEvent {
 }
 
 impl XfsHealthEvent for XfsWholeFsEvent {
-    fn format(&self) -> String {
-        format!(
-            "{} {} {}",
-            format_set(self.metadata),
-            M_("status"),
-            self.status
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (
+            None,
+            format!(
+                "{} {} {}",
+                format_set(self.metadata),
+                M_("status"),
+                self.status
+            ),
         )
     }
 
@@ -112,11 +117,14 @@ impl XfsHealthEvent for XfsShutdownEvent {
         true
     }
 
-    fn format(&self) -> String {
-        format!(
-            "{} {}",
-            M_("filesystem shut down due to"),
-            format_set(self.reasons)
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (
+            None,
+            format!(
+                "{} {}",
+                M_("filesystem shut down due to"),
+                format_set(self.reasons)
+            ),
         )
     }
 }
@@ -129,8 +137,8 @@ impl XfsHealthEvent for XfsUnmountEvent {
         true
     }
 
-    fn format(&self) -> String {
-        M_("filesystem unmounted")
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (None, M_("filesystem unmounted"))
     }
 }
 
@@ -149,7 +157,7 @@ impl XfsMediaErrorEvent {
 }
 
 impl XfsHealthEvent for XfsMediaErrorEvent {
-    fn format(&self) -> String {
-        format!("{} {}", M_("media error on"), self.range)
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (None, format!("{} {}", M_("media error on"), self.range))
     }
 }
diff --git a/healer/src/healthmon/groups.rs b/healer/src/healthmon/groups.rs
index 60a44defb5d307..f0b182a632d807 100644
--- a/healer/src/healthmon/groups.rs
+++ b/healer/src/healthmon/groups.rs
@@ -9,10 +9,12 @@ use crate::healthmon::event::XfsHealthEvent;
 use crate::healthmon::event::XfsHealthStatus;
 use crate::repair::Repair;
 use crate::util::format_set;
+use crate::weakhandle::WeakHandle;
 use crate::xfs_types::{XfsAgNumber, XfsRgNumber};
 use crate::xfsprogs::M_;
 use enumset::EnumSet;
 use enumset::EnumSetType;
+use std::path::PathBuf;
 use strum_macros::EnumString;
 
 /// Metadata types for an allocation group on the data device
@@ -75,12 +77,15 @@ impl XfsPeragEvent {
 }
 
 impl XfsHealthEvent for XfsPeragEvent {
-    fn format(&self) -> String {
-        format!(
-            "{} {} {}",
-            self.group,
-            format_set(self.metadata),
-            self.status
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (
+            None,
+            format!(
+                "{} {} {}",
+                self.group,
+                format_set(self.metadata),
+                self.status
+            ),
         )
     }
 
@@ -137,12 +142,15 @@ impl XfsRtgroupEvent {
 }
 
 impl XfsHealthEvent for XfsRtgroupEvent {
-    fn format(&self) -> String {
-        format!(
-            "{} {} {}",
-            self.group,
-            format_set(self.metadata),
-            self.status
+    fn format(&self, _: &WeakHandle) -> (Option<PathBuf>, String) {
+        (
+            None,
+            format!(
+                "{} {} {}",
+                self.group,
+                format_set(self.metadata),
+                self.status
+            ),
         )
     }
 
diff --git a/healer/src/healthmon/inodes.rs b/healer/src/healthmon/inodes.rs
index a4324c7d834b42..b01205cedbfb4d 100644
--- a/healer/src/healthmon/inodes.rs
+++ b/healer/src/healthmon/inodes.rs
@@ -9,10 +9,12 @@ use crate::healthmon::event::XfsHealthEvent;
 use crate::healthmon::event::XfsHealthStatus;
 use crate::repair::Repair;
 use crate::util::format_set;
+use crate::weakhandle::WeakHandle;
 use crate::xfs_types::{XfsFid, XfsFileRange};
 use crate::xfsprogs::M_;
 use enumset::EnumSet;
 use enumset::EnumSetType;
+use std::path::PathBuf;
 use strum_macros::EnumString;
 
 /// Metadata types for an XFS inode
@@ -71,8 +73,17 @@ impl XfsInodeEvent {
 }
 
 impl XfsHealthEvent for XfsInodeEvent {
-    fn format(&self) -> String {
-        format!("{} {} {}", self.fid, format_set(self.metadata), self.status)
+    fn format(&self, fh: &WeakHandle) -> (Option<PathBuf>, String) {
+        match fh.path_for(self.fid) {
+            Some(path) => (
+                Some(path),
+                format!("{} {}", format_set(self.metadata), self.status),
+            ),
+            None => (
+                None,
+                format!("{} {} {}", self.fid, format_set(self.metadata), self.status),
+            ),
+        }
     }
 
     schedule_repairs!(XfsInodeEvent, |s: &XfsInodeEvent, sm_type| {
@@ -122,7 +133,10 @@ impl XfsFileIoErrorEvent {
 }
 
 impl XfsHealthEvent for XfsFileIoErrorEvent {
-    fn format(&self) -> String {
-        format!("{} {} {}", self.fid, self.iotype, self.range)
+    fn format(&self, fh: &WeakHandle) -> (Option<PathBuf>, String) {
+        match fh.path_for(self.fid) {
+            Some(path) => (Some(path), format!("{} {}", self.iotype, self.range)),
+            None => (None, format!("{} {} {}", self.fid, self.iotype, self.range)),
+        }
     }
 }
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
index 0b5735b7183138..e0e59a5868af75 100644
--- a/healer/src/lib.rs
+++ b/healer/src/lib.rs
@@ -12,3 +12,4 @@ pub mod healthmon;
 pub mod weakhandle;
 pub mod repair;
 pub mod fsgeom;
+pub mod getparents;
diff --git a/healer/src/main.rs b/healer/src/main.rs
index ed118243dd911b..191018779f335d 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -98,7 +98,11 @@ impl App {
             }
             Ok(event) => {
                 if self.log || event.must_log() {
-                    printlogln!("{}: {}", self.path.display(), event.format());
+                    let (maybe_path, message) = event.format(fh);
+                    match maybe_path {
+                        Some(x) => printlogln!("{}: {}", x.display(), message),
+                        None => printlogln!("{}: {}", self.path.display(), message),
+                    };
                 }
                 if self.repair {
                     for mut repair in event.schedule_repairs() {
@@ -151,7 +155,7 @@ impl App {
             }
         }
 
-        let fh = WeakHandle::try_new(&fp, &self.path)
+        let fh = WeakHandle::try_new(&fp, &self.path, fsgeom)
             .with_context(|| M_("Configuring filesystem handle"))?;
 
         if self.json {
diff --git a/healer/src/repair.rs b/healer/src/repair.rs
index 1312efd87281dd..c0cd7d64306536 100644
--- a/healer/src/repair.rs
+++ b/healer/src/repair.rs
@@ -285,6 +285,19 @@ impl Repair {
         }
     }
 
+    /// Translate the target of this repair into a filesystem path
+    fn repair_path(&self, fh: &WeakHandle) -> String {
+        if let RepairGroup::File = self.group {
+            let fid: XfsFid = self.detail.into();
+
+            if let Some(path) = fh.path_for(fid) {
+                return path.display().to_string();
+            }
+        }
+
+        fh.mountpoint()
+    }
+
     /// Call the kernel to repair things
     fn repair(&mut self, fh: &WeakHandle) -> Result<bool> {
         let fp = fh
@@ -305,10 +318,15 @@ impl Repair {
     pub fn perform(&mut self, fh: &WeakHandle) {
         match self.repair(fh) {
             Err(e) => {
-                eprintln!("{}: {:#}", fh.mountpoint(), e);
+                eprintln!("{}: {:#}", self.repair_path(fh), e);
             }
             _ => {
-                printlogln!("{}: {}: {}", fh.mountpoint(), self.summary(), self.outcome);
+                printlogln!(
+                    "{}: {}: {}",
+                    self.repair_path(fh),
+                    self.summary(),
+                    self.outcome
+                );
             }
         };
     }
diff --git a/healer/src/weakhandle.rs b/healer/src/weakhandle.rs
index ccac5d86d3be41..57cc7602fbd25e 100644
--- a/healer/src/weakhandle.rs
+++ b/healer/src/weakhandle.rs
@@ -4,8 +4,11 @@
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 use crate::baddata;
+use crate::xfs_fs::xfs_fid;
+use crate::xfs_fs::xfs_fsop_geom;
 use crate::xfs_fs::xfs_fsop_handlereq;
 use crate::xfs_fs::xfs_handle;
+use crate::xfs_types::XfsFid;
 use crate::xfsprogs::M_;
 use anyhow::{Error, Result};
 use nix::ioctl_readwrite;
@@ -73,6 +76,9 @@ pub struct WeakHandle<'a> {
 
     /// Filesystem handle
     handle: xfs_handle,
+
+    /// Does this filesystem support parent pointers?
+    has_parent: bool,
 }
 
 impl WeakHandle<'_> {
@@ -99,12 +105,34 @@ impl WeakHandle<'_> {
     }
 
     /// Create a soft handle from an open file descriptor and its mount point
-    pub fn try_new<'a>(fp: &File, mountpoint: &'a Path) -> Result<WeakHandle<'a>> {
+    pub fn try_new<'a>(
+        fp: &File,
+        mountpoint: &'a Path,
+        fsgeom: xfs_fsop_geom,
+    ) -> Result<WeakHandle<'a>> {
         Ok(WeakHandle {
             mountpoint,
             handle: xfs_handle::try_from(fp)?,
+            has_parent: fsgeom.has_parent(),
         })
     }
+
+    /// Create a new file handle from this one
+    pub fn subst(&self, fid: XfsFid) -> xfs_handle {
+        xfs_handle {
+            ha_fid: xfs_fid {
+                fid_ino: fid.ino.into(),
+                fid_gen: fid.gen.into(),
+                ..self.handle.ha_fid
+            },
+            ..self.handle
+        }
+    }
+
+    /// Can this filesystem do parent pointer lookups?
+    pub fn can_get_parents(&self) -> bool {
+        self.has_parent
+    }
 }
 
 impl Display for WeakHandle<'_> {

