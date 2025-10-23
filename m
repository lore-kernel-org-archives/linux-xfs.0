Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0331862
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178481; cv=none; b=C/xGxbM9RW7kkawNCCkZC3X+Ti3DnGa89YBDKV7C2Fa13upIX+sctmhl10gT4TowRY4IEUpIm0DiKbdQgyZKA/3k200pP/0brtwhlD18M8soxgH/hOxs68MdfnxLZ4WO/43AEMAIm/iH2h7KfEPpcu8LmqCHqhbyQcHD4W8dzJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178481; c=relaxed/simple;
	bh=JVM8ZJ5m4KXwEB87J4PDaNECZQfwIm51gknyUaYmz9Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=In41Jxzypdt43WnU7HeJ+291NgD+gytWwfShcT0eJ/SLTa0FVwSbGoR9AhaTptH49gWgguF8ZveyP//0M+y2BAG7HF3nuFCj3vze47nyMK8EcxcFdyPujBuCJHQ/+u6Wf43YtSKshOIh+RjQVyGdkm+J1ck/kOCpghkxgEWCwEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYK+JTDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYK+JTDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D67C4CEF5;
	Thu, 23 Oct 2025 00:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178481;
	bh=JVM8ZJ5m4KXwEB87J4PDaNECZQfwIm51gknyUaYmz9Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sYK+JTDr38aC4s+B2SZWtPp4etPhSwnPs4usruzxW6w5VB16IUpY0sVBTZSm1GGfy
	 bTST4PzVL/ZW2w31KPF6uPNOsGVYaSz/X1PZcjbXGXUA+7OVpE0EbVTLIE1xC1SoLG
	 U/7Xu+BU737nQoJ++5K76tgzLowOWmjqlmeZX99WkkZt0Id6rL8vNJqe0N8EXcA/tQ
	 eyabtbLAGHb1m/nTsMvxrZDpSP/weykqORSV5UvW4PzdADXj3U6Z4FFPr4XDM3qUDY
	 l/Fp4yRub+/B8aDWzUN4lUt22QeC2PsXilwnFZJPW8SS/HT7XZKaZqEPVoGY7zbgyE
	 f+Ew0QlZa7h3Q==
Date: Wed, 22 Oct 2025 17:14:41 -0700
Subject: [PATCH 09/19] xfs_healer: check for fs features needed for effective
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748426.1029045.16250605701766051076.stgit@frogsfrogsfrogs>
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

Online repair relies heavily on back references such as reverse mappings
and directory parent pointers to add redundancy to the filesystem.  Make
the rust program check for these two features and whine a bit if they
are missing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile      |    1 +
 healer/src/fsgeom.rs |   41 +++++++++++++++++++++++++++++++++++++++++
 healer/src/lib.rs    |    1 +
 healer/src/main.rs   |   41 +++++++++++++++++++++++++++++++++++++++++
 healer/src/repair.rs |   13 +++++++++++++
 5 files changed, 97 insertions(+)
 create mode 100644 healer/src/fsgeom.rs


diff --git a/healer/Makefile b/healer/Makefile
index 05ea73b8163a49..03bfd853a193ee 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -17,6 +17,7 @@ HFILES = \
 	bindgen_xfs_fs.h
 
 RUSTFILES = \
+	src/fsgeom.rs \
 	src/lib.rs \
 	src/main.rs \
 	src/repair.rs \
diff --git a/healer/src/fsgeom.rs b/healer/src/fsgeom.rs
new file mode 100644
index 00000000000000..cb8e8acc107575
--- /dev/null
+++ b/healer/src/fsgeom.rs
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::xfs_fs;
+use crate::xfs_fs::xfs_fsop_geom;
+use nix::ioctl_read;
+use std::fs::File;
+use std::io::Error;
+use std::io::Result;
+use std::os::fd::AsRawFd;
+
+ioctl_read!(xfs_ioc_fsgeometry, 'X', 126, xfs_fsop_geom);
+
+impl TryFrom<&File> for xfs_fsop_geom {
+    type Error = Error;
+
+    /// Retrieve the XFS geometry of an open file.
+    fn try_from(fp: &File) -> Result<xfs_fsop_geom> {
+        let mut ret: xfs_fsop_geom = Default::default();
+
+        // SAFETY: Trusting the kernel not to corrupt memory.
+        unsafe {
+            xfs_ioc_fsgeometry(fp.as_raw_fd(), &mut ret)?;
+            Ok(ret)
+        }
+    }
+}
+
+impl xfs_fsop_geom {
+    /// Does this filesystem have reverse space mappings?
+    pub fn has_rmapbt(&self) -> bool {
+        self.flags & xfs_fs::XFS_FSOP_GEOM_FLAGS_RMAPBT != 0
+    }
+
+    /// Does this filesystem have parent pointers?
+    pub fn has_parent(&self) -> bool {
+        self.flags & xfs_fs::XFS_FSOP_GEOM_FLAGS_PARENT != 0
+    }
+}
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
index f08f9a65ced674..0b5735b7183138 100644
--- a/healer/src/lib.rs
+++ b/healer/src/lib.rs
@@ -11,3 +11,4 @@ pub mod util;
 pub mod healthmon;
 pub mod weakhandle;
 pub mod repair;
+pub mod fsgeom;
diff --git a/healer/src/main.rs b/healer/src/main.rs
index b2a69c388bd8ef..ed118243dd911b 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -12,7 +12,9 @@ use xfs_healer::healthmon::cstruct::CStructMonitor;
 use xfs_healer::healthmon::event::XfsHealthEvent;
 use xfs_healer::healthmon::json::JsonMonitor;
 use xfs_healer::printlogln;
+use xfs_healer::repair::Repair;
 use xfs_healer::weakhandle::WeakHandle;
+use xfs_healer::xfs_fs::xfs_fsop_geom;
 use xfs_healer::xfsprogs;
 use xfs_healer::xfsprogs::M_;
 
@@ -107,9 +109,48 @@ impl App {
         }
     }
 
+    /// Complain if repairs won't be entirely effective.
+    fn check_repair(&self, fp: &File, fsgeom: &xfs_fsop_geom) -> Option<ExitCode> {
+        if !Repair::is_supported(fp) {
+            printlogln!(
+                "{}: {}",
+                self.path.display(),
+                M_("XFS online repair is not supported, exiting")
+            );
+            return Some(ExitCode::FAILURE);
+        }
+
+        if !fsgeom.has_rmapbt() {
+            printlogln!(
+                "{}: {}",
+                self.path.display(),
+                M_("XFS online repair is less effective without rmap btrees")
+            );
+        }
+        if !fsgeom.has_parent() {
+            printlogln!(
+                "{}: {}",
+                self.path.display(),
+                M_("XFS online repair is less effective without parent pointers")
+            );
+        }
+
+        None
+    }
+
     /// Main app method
     fn main(&self) -> Result<ExitCode> {
         let fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
+
+        // Make sure that we can initiate repairs
+        let fsgeom =
+            xfs_fsop_geom::try_from(&fp).with_context(|| M_("Querying filesystem geometry"))?;
+        if self.repair {
+            if let Some(ret) = self.check_repair(&fp, &fsgeom) {
+                return Ok(ret);
+            }
+        }
+
         let fh = WeakHandle::try_new(&fp, &self.path)
             .with_context(|| M_("Configuring filesystem handle"))?;
 
diff --git a/healer/src/repair.rs b/healer/src/repair.rs
index 8b9a665d1bcc36..1312efd87281dd 100644
--- a/healer/src/repair.rs
+++ b/healer/src/repair.rs
@@ -15,6 +15,7 @@ use crate::xfs_types::{XfsAgNumber, XfsFid, XfsRgNumber};
 use crate::xfsprogs::M_;
 use anyhow::{Context, Result};
 use nix::ioctl_readwrite;
+use std::fs::File;
 use std::os::fd::AsRawFd;
 
 ioctl_readwrite!(xfs_ioc_scrub_metadata, 'X', 60, xfs_scrub_metadata);
@@ -172,6 +173,18 @@ pub struct Repair {
 }
 
 impl Repair {
+    /// Determine if repairs are supported by this kernel
+    pub fn is_supported(fp: &File) -> bool {
+        let mut detail = xfs_scrub_metadata {
+            sm_type: xfs_fs::XFS_SCRUB_TYPE_PROBE,
+            sm_flags: xfs_fs::XFS_SCRUB_IFLAG_REPAIR,
+            ..Default::default()
+        };
+
+        // SAFETY: Trusting the kernel not to corrupt memory.
+        unsafe { xfs_ioc_scrub_metadata(fp.as_raw_fd(), &mut detail).is_ok() }
+    }
+
     /// Schedule a full-filesystem metadata repair
     pub fn from_whole_fs(t: XfsScrubType) -> Repair {
         Repair {

