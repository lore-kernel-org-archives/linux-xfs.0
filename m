Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408671E531
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178591; cv=none; b=nupuTB3sxwp7IUp5l4oAsRT9NwrbiceVTk7Ynm7bWkljQchWxXOyaMS+WVxXA6VlcGvIi4TgiWFs5Ug8harRCvcXTs7yVpQ/NLZ97WS1QyBjPvqT7L12cbVGfS4Rzlr+NJJrfn7N1MOvsAbaXCXIbDZn01issppdul6Jnom0dQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178591; c=relaxed/simple;
	bh=pPMB2g+6kPTaJ9gnp5JKsTRF8V5O05cWUSgpo+H/UOY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/ULSi4woP/Ayfw1VOQ4JLibCNu5wo1H5H2MdLZ1lIFFklA9YVYr+nsM5EB2aYlUEeYcKWCt9I/13obyeADQnCF0Mav6z6DEN8yWOT2J8xGY5qveWRAPbp4dSidPqZ+Q5K3gdjRjz9bdAtDoVkZGDi2do1G6ZIo0vLKkOl7wwYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSaxyOwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSaxyOwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17000C4CEE7;
	Thu, 23 Oct 2025 00:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178591;
	bh=pPMB2g+6kPTaJ9gnp5JKsTRF8V5O05cWUSgpo+H/UOY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bSaxyOwSnFmNGy38Nw5KL/GJFjMW14qgjL4CAROTbA3DBHpGiSezdHFDxwH0fiHE6
	 aul83w+8p5JlJQVnpQhJVuSXDpUsjWN/VJXryoA2fo9YzOnFzHT4KmswkWijyhrmL3
	 wZO2ptk/XJX91FYv0DBO3+gGSyoMddNXN3frN8YINQNejWblDLpuzBGexDhCfY3AEi
	 wtH5kRpfIT5UoRH6l1lE8FLy2kc8L3pbWqCxkQHZyNuC1I1D5sMUEoMgL0xV04jUpq
	 6pe95YxpUzGEwP2az8E+myDiN7dGUc4pdztuxU7WLzJsWS4eJj3TrDlsHljoAMwKnF
	 e9Qzytgua+7DA==
Date: Wed, 22 Oct 2025 17:16:30 -0700
Subject: [PATCH 16/19] xfs_healer: use getmntent in Rust to find moved
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748558.1029045.3438272323853947595.stgit@frogsfrogsfrogs>
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

Wrap the libc getmntent function in an iterator.  This enables
xfs_healer to record the fsname (or fs spec) of the mountpoint that it's
running against, and use that fsname to walk /proc/mounts to re-find the
filesystem if the mount has moved elsewhere if it needs to open the fs
to perform repairs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile          |    1 
 healer/src/getmntent.rs  |  117 ++++++++++++++++++++++++++++++++++++++++++++++
 healer/src/lib.rs        |    1 
 healer/src/weakhandle.rs |   52 ++++++++++++++++++--
 4 files changed, 165 insertions(+), 6 deletions(-)
 create mode 100644 healer/src/getmntent.rs


diff --git a/healer/Makefile b/healer/Makefile
index ae01e30403d0e5..b3a9ed579a2a26 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -19,6 +19,7 @@ HFILES = \
 RUSTFILES = \
 	src/fsgeom.rs \
 	src/fsprops.rs \
+	src/getmntent.rs \
 	src/getparents.rs \
 	src/lib.rs \
 	src/main.rs \
diff --git a/healer/src/getmntent.rs b/healer/src/getmntent.rs
new file mode 100644
index 00000000000000..86daeb052b8d55
--- /dev/null
+++ b/healer/src/getmntent.rs
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use anyhow::Result;
+use libc::{endmntent, mntent, setmntent, FILE};
+use std::ffi::{c_char, c_int, CStr, CString};
+use std::io;
+use std::mem::MaybeUninit;
+use std::path::{Path, PathBuf};
+
+/*
+ * XXX: link directly to getmntent_r because the libc crate in Debian 12 is too old.  Note that
+ * the bindgen'd xfs_fs.rs pulls in a similar but not totally identical version so we need to
+ * turn off that warning.
+ */
+#[allow(clashing_extern_declarations)]
+extern "C" {
+    pub fn getmntent_r(
+        stream: *mut FILE,
+        mntbuf: *mut mntent,
+        buf: *mut c_char,
+        buflen: c_int,
+    ) -> *mut mntent;
+}
+
+const NAME_BUFSIZE: usize = 4096;
+
+/// Iterator object that returns mountpoint entries
+pub struct MountEntries {
+    /// mntent file
+    fp: *mut FILE,
+
+    /// local storage for mtab parsing
+    mntbuf: mntent,
+    namebuf: Vec<c_char>,
+}
+
+impl MountEntries {
+    pub fn try_new_from(mountfile: &Path) -> Result<MountEntries> {
+        let path = CString::new(
+            mountfile
+                .to_str()
+                .ok_or(io::Error::new(io::ErrorKind::Other, "bad mntent path"))?,
+        )?;
+        let mode = CString::new("r")?;
+        let fp = unsafe { setmntent(path.as_ptr(), mode.as_ptr()) };
+        if fp.is_null() {
+            return Err(io::Error::new(io::ErrorKind::Other, "setmntent failed").into());
+        }
+
+        let mntbuf = MaybeUninit::<mntent>::zeroed();
+        let namebuf: Vec<c_char> = Vec::with_capacity(NAME_BUFSIZE);
+        Ok(MountEntries {
+            fp,
+            namebuf,
+            mntbuf: unsafe { mntbuf.assume_init() },
+        })
+    }
+
+    pub fn try_new() -> Result<MountEntries> {
+        MountEntries::try_new_from(std::path::Path::new("/proc/self/mounts"))
+    }
+}
+
+#[derive(Debug)]
+pub struct MountEntry {
+    /// filesystem name
+    pub fsname: String,
+
+    /// mountpoint
+    pub dir: PathBuf,
+
+    /// filesystem type
+    pub fstype: String,
+}
+
+impl Iterator for MountEntries {
+    type Item = MountEntry;
+
+    /// Return mount points
+    fn next(&mut self) -> Option<Self::Item> {
+        let ent = unsafe {
+            getmntent_r(
+                self.fp,
+                &mut self.mntbuf,
+                self.namebuf.as_mut_ptr() as *mut c_char,
+                NAME_BUFSIZE as i32,
+            )
+        };
+        if ent.is_null() {
+            return None;
+        }
+
+        let f0 = unsafe { CStr::from_ptr((*ent).mnt_type) };
+        let fstype = String::from_utf8_lossy(f0.to_bytes()).to_string();
+
+        let f0 = unsafe { CStr::from_ptr((*ent).mnt_fsname) };
+        let fsname = String::from_utf8_lossy(f0.to_bytes()).to_string();
+
+        let f0 = unsafe { CStr::from_ptr((*ent).mnt_dir) };
+        let dir = PathBuf::from(f0.to_str().unwrap());
+
+        Some(MountEntry {
+            fsname,
+            fstype,
+            dir,
+        })
+    }
+}
+
+impl Drop for MountEntries {
+    fn drop(&mut self) {
+        unsafe { endmntent(self.fp) };
+    }
+}
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
index d952b61646114d..f59182c4de41e0 100644
--- a/healer/src/lib.rs
+++ b/healer/src/lib.rs
@@ -14,3 +14,4 @@ pub mod repair;
 pub mod fsgeom;
 pub mod getparents;
 pub mod fsprops;
+pub mod getmntent;
diff --git a/healer/src/weakhandle.rs b/healer/src/weakhandle.rs
index 8650f6b9633b4d..9f0dc77b822077 100644
--- a/healer/src/weakhandle.rs
+++ b/healer/src/weakhandle.rs
@@ -5,6 +5,7 @@
  */
 use crate::baddata;
 use crate::badness;
+use crate::getmntent::MountEntries;
 use crate::xfs_fs::xfs_fid;
 use crate::xfs_fs::xfs_fsop_geom;
 use crate::xfs_fs::xfs_fsop_handlereq;
@@ -22,7 +23,7 @@ use std::io::ErrorKind;
 use std::os::fd::AsRawFd;
 use std::os::raw::c_void;
 use std::os::unix::ffi::OsStringExt;
-use std::path::PathBuf;
+use std::path::{Path, PathBuf};
 use std::process::Command;
 use std::sync::Arc;
 
@@ -76,6 +77,9 @@ impl TryFrom<&File> for xfs_handle {
 
 /// Filesystem handle that can be disconnected from any open files
 pub struct WeakHandle {
+    /// device for the xfs filesystem
+    fsname: String,
+
     /// path to the filesystem mountpoint
     mountpoint: Arc<PathBuf>,
 
@@ -87,15 +91,15 @@ pub struct WeakHandle {
 }
 
 impl WeakHandle {
-    /// Try to reopen the filesystem from which we got the handle.
-    pub fn reopen(&self) -> Result<File> {
-        let fp = File::open(self.mountpoint.as_path())?;
+    /// Try to reopen the filesystem with a given mountpoint
+    fn reopen_from(&self, mountpoint: &Path) -> Result<File> {
+        let fp = File::open(mountpoint)?;
 
         if xfs_handle::try_from(&fp)? != self.handle {
             let s = format!(
                 "{} {}: {}",
                 M_("reopening"),
-                self.mountpoint.display(),
+                mountpoint.display(),
                 M_("Stale file handle")
             );
             return Err(std::io::Error::new(ErrorKind::Other, s).into());
@@ -104,19 +108,55 @@ impl WeakHandle {
         Ok(fp)
     }
 
+    /// Try to reopen the filesystem from which we got the handle.
+    pub fn reopen(&self) -> Result<File> {
+        // First try the original mountpoint
+        let orig_result = self.reopen_from(&self.mountpoint);
+        if let Ok(x) = orig_result {
+            return Ok(x);
+        }
+
+        // Now scan /proc/self/mounts for any other bind mounts of this filesystem
+        let entries = MountEntries::try_new()?;
+        for mntent in entries.filter(|x| x.fstype == "xfs" && x.fsname == self.fsname) {
+            if let Ok(x) = self.reopen_from(&mntent.dir) {
+                return Ok(x);
+            }
+        }
+
+        // Return original error
+        orig_result
+    }
+
     /// Report mountpoint in a displayable manner
     pub fn mountpoint(&self) -> String {
         self.mountpoint.display().to_string()
     }
 
+    /// Report xfs device in a displayable manner
+    pub fn fsname(&self) -> String {
+        self.fsname.clone()
+    }
+
     /// Create a soft handle from an open file descriptor and its mount point
     pub fn try_new(
         fp: &File,
         mountpoint: Arc<PathBuf>,
         fsgeom: xfs_fsop_geom,
     ) -> Result<WeakHandle> {
+        // Try to find the xfs device name for this mount point
+        let mut entries = MountEntries::try_new()?;
+        let fsname = match entries.find(|x| x.fstype == "xfs" && x.dir == *mountpoint) {
+            None => {
+                let s = format!("{}: {}", mountpoint.display(), M_("Cannot find xfs device"));
+                return Err(std::io::Error::new(ErrorKind::Other, s).into());
+            }
+            Some(mntent) => mntent.fsname,
+        };
+
         Ok(WeakHandle {
             mountpoint,
+            fsname,
             handle: xfs_handle::try_from(fp)?,
             has_parent: fsgeom.has_parent(),
         })
@@ -160,6 +200,6 @@ impl WeakHandle {
 
 impl Display for WeakHandle {
     fn fmt(&self, f: &mut Formatter) -> std::fmt::Result {
-        write!(f, "{}", self.mountpoint.display())
+        write!(f, "{} {}", self.fsname, self.mountpoint.display())
     }
 }

