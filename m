Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9243BBA3D
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178450; cv=none; b=KOw4Z0DBeedv7y59Ct2TON12XPJPrcoalfqeNomMocMWCywEBMQ2TDfnezKe6BEbYpyAhQLUYQs2YBjz64vWVXWm8y/klOmn7jt3q0vayCplLcW1JkTCGfmt1qN6xwtXp95/KmJotqevLKsfjM0nN4L9jS3JlkybIEst07NO+UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178450; c=relaxed/simple;
	bh=J+/spADOh4yYyIjAcsC+CgBCP1TKcucOoDDj6Eom01c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eo/qrRaLTkAgUWRTwLMEjGG2u3y0g5Vz3D5gKb2dGGJ/Cb0xGhNFMRRjpZNi32s4sFjPdnRAgz7FjLpIVKMFJtrS3SC8vd4tkIWHVUnv7MZcxTW1GHPNET/njMGNElkwDgXlR93pygxfwvba4Z6+KLungW0XqUJINE1lK7vqNd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGd0FhbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGd0FhbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2C0C4CEE7;
	Thu, 23 Oct 2025 00:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178450;
	bh=J+/spADOh4yYyIjAcsC+CgBCP1TKcucOoDDj6Eom01c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PGd0FhbFrSNTqXDl6DOZXiGaGCLCi0a5ElprH1hhQ6VN8+s5O6uBr1uDzEz5SZdir
	 YxDMyF4grgqtkdjFRUdQ6jMcPjsQyCoebKA0V6o0xBuiqn2d/VUbNhg8XEeu8QWHLB
	 TlQP86TJZPJ3Q0oS/zk9FyriDOdiGIUfU2mWAEMNYZxbE6rTFJpElGhno1LPjxRQnv
	 INqjibBQYzNfqAhy6yDx8JIIvsripGaHKIzQ69XnikMTo6jCDCcKuY4Bdbg2t+qljU
	 54Rx/StpYt7NM62LXRHf8CM9S6UZXOvpMnCSsPWQcdVHt6zKA/ouPz9lexFi/8CHbt
	 9Q+u0/NIx/Ytg==
Date: Wed, 22 Oct 2025 17:14:09 -0700
Subject: [PATCH 07/19] xfs_healer: create a weak file handle so we don't pin
 the mount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748388.1029045.446291014024054804.stgit@frogsfrogsfrogs>
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

Create a custom file handle object that allows us to maintain a "soft"
reference to a mounted filesystem.  The purpose of this is to avoid
pinning the mount while xfs_healer runs by not leaving an open fd while
retaining the ability to reconnect to the filesystem later so that we
can look up paths for reporting, and run repairs.

This means that the filesystem must still be available at the same path
at reconnect time, which may result in the program exiting if mount
--move is used.

Note that we open-code the XFS_IOC_FD_TO_HANDLE call to avoid
overcomplicating the cargo configuration to link with
../libhandle/libhandle.la as a static import for a single function call.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile          |    1 
 healer/src/lib.rs        |    1 
 healer/src/main.rs       |    3 +
 healer/src/weakhandle.rs |  101 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+)
 create mode 100644 healer/src/weakhandle.rs


diff --git a/healer/Makefile b/healer/Makefile
index 515238982aad24..75227820a51e79 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -20,6 +20,7 @@ RUSTFILES = \
 	src/lib.rs \
 	src/main.rs \
 	src/util.rs \
+	src/weakhandle.rs \
 	src/xfs_fs.rs \
 	src/xfsprogs.rs \
 	src/xfs_types.rs \
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
index e9b4795be00904..bd39f4d47b5068 100644
--- a/healer/src/lib.rs
+++ b/healer/src/lib.rs
@@ -9,3 +9,4 @@ pub mod xfs_fs;
 pub mod xfs_types;
 pub mod util;
 pub mod healthmon;
+pub mod weakhandle;
diff --git a/healer/src/main.rs b/healer/src/main.rs
index 456dc44289d534..24281ac7f1eeea 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -12,6 +12,7 @@ use xfs_healer::healthmon::cstruct::CStructMonitor;
 use xfs_healer::healthmon::event::XfsHealthEvent;
 use xfs_healer::healthmon::json::JsonMonitor;
 use xfs_healer::printlogln;
+use xfs_healer::weakhandle::WeakHandle;
 use xfs_healer::xfsprogs;
 use xfs_healer::xfsprogs::M_;
 
@@ -97,6 +98,8 @@ impl App {
     /// Main app method
     fn main(&self) -> Result<ExitCode> {
         let fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
+        let _fh = WeakHandle::try_new(&fp, &self.path)
+            .with_context(|| M_("Configuring filesystem handle"))?;
 
         if self.json {
             let hmon = JsonMonitor::try_new(fp, &self.path, self.everything, self.debug)
diff --git a/healer/src/weakhandle.rs b/healer/src/weakhandle.rs
new file mode 100644
index 00000000000000..f532c530d4ff5e
--- /dev/null
+++ b/healer/src/weakhandle.rs
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::baddata;
+use crate::xfs_fs::xfs_fsop_handlereq;
+use crate::xfs_fs::xfs_handle;
+use crate::xfsprogs::M_;
+use anyhow::{Error, Result};
+use nix::ioctl_readwrite;
+use nix::libc::O_LARGEFILE;
+use std::fs::File;
+use std::io::ErrorKind;
+use std::os::fd::AsRawFd;
+use std::os::raw::c_void;
+use std::path::Path;
+
+ioctl_readwrite!(xfs_ioc_fd_to_handle, 'X', 106, xfs_fsop_handlereq);
+
+/* just pick a value we know is more than big enough */
+const MAXHANSIZ: usize = 64;
+
+impl PartialEq for xfs_handle {
+    fn eq(&self, other: &Self) -> bool {
+        // SAFETY: accessing an arm of a union that exists only to force memory alignment
+        unsafe { self.ha_u._ha_fsid == other.ha_u._ha_fsid && self.ha_fid == other.ha_fid }
+    }
+}
+
+impl TryFrom<&File> for xfs_handle {
+    type Error = Error;
+
+    /// Create an xfs_handle for an open file
+    fn try_from(fp: &File) -> Result<xfs_handle> {
+        assert!(MAXHANSIZ >= std::mem::size_of::<xfs_handle>());
+
+        let mut value: Vec<u8> = vec![0; MAXHANSIZ];
+        let mut hreq: xfs_fsop_handlereq = Default::default();
+        let mut hlen: u32 = 0;
+
+        hreq.fd = fp.as_raw_fd() as u32;
+        hreq.oflags = O_LARGEFILE as u32;
+        hreq.ohandle = value.as_mut_ptr() as *mut c_void;
+        hreq.ohandlen = &mut hlen;
+
+        // SAFETY: Trusting the kernel not to corrupt hreq, value, or anything else.  This is wildly
+        // incorrect because the kernel interface does not require userspace to pass in the size of
+        // the object ohandle, so it writes blindly to *ohandle.
+        unsafe {
+            xfs_ioc_fd_to_handle(fp.as_raw_fd(), &mut hreq)?;
+        }
+        if hlen as usize != std::mem::size_of::<xfs_handle>() {
+            return Err(baddata!(M_("Bad file handle size"), xfs_handle, hlen).into());
+        }
+
+        // SAFETY: We asserted above that value is large enough to store an xfs_handle, so we can
+        // cast and struct copy here.
+        unsafe {
+            let hanp: *const xfs_handle = value.as_ptr() as *const xfs_handle;
+            let ret: xfs_handle = *hanp;
+            Ok(ret)
+        }
+    }
+}
+
+/// Filesystem handle that can be disconnected from any open files
+pub struct WeakHandle<'a> {
+    /// path to the filesystem mountpoint
+    mountpoint: &'a Path,
+
+    /// Filesystem handle
+    handle: xfs_handle,
+}
+
+impl WeakHandle<'_> {
+    /// Try to reopen the filesystem from which we got the handle.
+    pub fn reopen(&self) -> Result<File> {
+        let fp = File::open(self.mountpoint)?;
+
+        if xfs_handle::try_from(&fp)? != self.handle {
+            let s = format!(
+                "{} {}: {}",
+                M_("reopening"),
+                self.mountpoint.display(),
+                M_("Stale file handle")
+            );
+            return Err(std::io::Error::new(ErrorKind::Other, s).into());
+        }
+
+        Ok(fp)
+    }
+
+    /// Create a soft handle from an open file descriptor and its mount point
+    pub fn try_new<'a>(fp: &File, mountpoint: &'a Path) -> Result<WeakHandle<'a>> {
+        Ok(WeakHandle {
+            mountpoint,
+            handle: xfs_handle::try_from(fp)?,
+        })
+    }
+}

