Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192CA4C85
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178404; cv=none; b=HmbYHwDV+X8hYNcNPiChbbEKRyFG4LG2FHU5xuA+RPjT8WP06AJcmsP6QzK6RHvsR7jNYNBk/MyHJRKEQd50NS6f8AvIXcZ7szFUzuRRvw/QYYK6bviXRKXTvW5AcOsLz1GUV2tmVaSPyBNhHWzuBvL+T+fDp16qSdn9giCcIJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178404; c=relaxed/simple;
	bh=BVaNo5us+KbskEdJPgCPXXKzB4vimB52ocSMfmq5D3U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ohar3KRq0pOAnf98JkstV2SxATPohyMPHzL02KfLUEAp0gCHmJNtkrUTKyNZsVTz7TV6xXlHwxzvXMOjpzicO7QEPou3LdS0f1Yr37rYFlpIQUEtspDAa5Ut8T2SHhnClkB/U6VkGKQt0bJkTvaqTV70vnDfRSAXkVhUSMFxnSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPCgoG/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPCgoG/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77486C4CEE7;
	Thu, 23 Oct 2025 00:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178403;
	bh=BVaNo5us+KbskEdJPgCPXXKzB4vimB52ocSMfmq5D3U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IPCgoG/eTiXtS+lKJV2z4vBTO7Yd2XMSrXrhTS97dApuG4yViXjCzbnNtoB0L6fjR
	 mBxtNJ7n0FrpB3E+K+huTfyxVIVoi5YbYKiTGRjNcNvchjyPVJvTY2v9YJN6MGa9Vw
	 IZEvJ2VirERRRbTDxsv+6rpdfSJ+V8J84+C6lNKEaUT5QyBhp/sKueytOZxLABUmZD
	 DhseE7c/51nldQ9U9/nHIsKR2v6FzAfoOysOP2L0G+GEk9prHsjBiRHBOsH0xz5LrH
	 1aArELyix3ShRmxv3Hngzoid1T1xdC34Wez5fUAmPMRsqfoZ3evkkDs25biDSJaVMG
	 uX/Sg32l2EznQ==
Date: Wed, 22 Oct 2025 17:13:23 -0700
Subject: [PATCH 04/19] xfs_healer: define Rust objects for health events and
 kernel interface
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748331.1029045.8175003068963650679.stgit@frogsfrogsfrogs>
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

Create our own Rust types for health events; these objects will know how
to report themselves and (later) how to initiate repairs.  Create the
Rust binding to the kernel ioctl interface.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Cargo.toml.in           |    2 
 healer/Makefile                |    9 +-
 healer/src/healthmon/event.rs  |   82 ++++++++++++++
 healer/src/healthmon/fs.rs     |  146 ++++++++++++++++++++++++
 healer/src/healthmon/groups.rs |  139 +++++++++++++++++++++++
 healer/src/healthmon/inodes.rs |  119 ++++++++++++++++++++
 healer/src/healthmon/mod.rs    |   14 ++
 healer/src/lib.rs              |    3 +
 healer/src/main.rs             |    5 +
 healer/src/util.rs             |   72 ++++++++++++
 healer/src/xfs_types.rs        |  240 ++++++++++++++++++++++++++++++++++++++++
 m4/package_rust.m4             |    2 
 12 files changed, 830 insertions(+), 3 deletions(-)
 create mode 100644 healer/src/healthmon/event.rs
 create mode 100644 healer/src/healthmon/fs.rs
 create mode 100644 healer/src/healthmon/groups.rs
 create mode 100644 healer/src/healthmon/inodes.rs
 create mode 100644 healer/src/healthmon/mod.rs
 create mode 100644 healer/src/util.rs
 create mode 100644 healer/src/xfs_types.rs


diff --git a/healer/Cargo.toml.in b/healer/Cargo.toml.in
index e62480ff17d58e..04e9df5c1a2a70 100644
--- a/healer/Cargo.toml.in
+++ b/healer/Cargo.toml.in
@@ -16,6 +16,7 @@ lto = @cargo_lto@
 [dependencies]
 clap = { version = "4.0.32", features = ["derive"] }
 anyhow = { version = "1.0.69" }
+enumset = { version = "1.0.12" }
 
 # XXX: Crates with major version 0 are not considered ABI-stable, so the minor
 # version is treated as if it were the major version.  This creates problems
@@ -23,6 +24,7 @@ anyhow = { version = "1.0.69" }
 # version 0.  Until these crates reach 1.0.0, we'll have to patch when things
 # break.  Ref:
 # https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html
+nix = { version = "0", features = ["ioctl"] }	# 0.26.1
 
 # Dynamically comment out all the gettextrs related dependency information in
 # Cargo.toml becuse cargo requires the crate to be present so that it can
diff --git a/healer/Makefile b/healer/Makefile
index 407e49ad868f4d..5df3ca105e143a 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -19,8 +19,15 @@ HFILES = \
 RUSTFILES = \
 	src/lib.rs \
 	src/main.rs \
+	src/util.rs \
 	src/xfs_fs.rs \
-	src/xfsprogs.rs
+	src/xfsprogs.rs \
+	src/xfs_types.rs \
+	src/healthmon/event.rs \
+	src/healthmon/fs.rs \
+	src/healthmon/groups.rs \
+	src/healthmon/inodes.rs \
+	src/healthmon/mod.rs
 
 BUILT_RUSTFILES = \
 	src/xfs_fs.rs \
diff --git a/healer/src/healthmon/event.rs b/healer/src/healthmon/event.rs
new file mode 100644
index 00000000000000..fe15156ca9e95a
--- /dev/null
+++ b/healer/src/healthmon/event.rs
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::display_for_enum;
+use crate::xfsprogs::M_;
+
+/// Common behaviors of all health events
+pub trait XfsHealthEvent {
+    /// Return true if this event should always be logged
+    fn must_log(&self) -> bool {
+        false
+    }
+
+    /// Format this event as something we can display
+    fn format(&self) -> String;
+}
+
+/// Health status for metadata events
+#[derive(Debug)]
+pub enum XfsHealthStatus {
+    /// Problems have been observed at runtime
+    Sick,
+
+    /// Problems have been observed by xfs_scrub
+    Corrupt,
+
+    /// No problems at all
+    Healthy,
+}
+
+display_for_enum!(XfsHealthStatus, {
+    Sick    => M_("sick"),
+    Corrupt => M_("corrupt"),
+    Healthy => M_("healthy"),
+});
+
+/// Event for the kernel losing events due to us being slow
+pub struct LostEvent {
+    /// Number of events lost
+    count: u64,
+}
+
+impl LostEvent {
+    /// Create a new lost event object
+    pub fn new(count: u64) -> LostEvent {
+        LostEvent { count }
+    }
+}
+
+impl XfsHealthEvent for LostEvent {
+    fn must_log(&self) -> bool {
+        true
+    }
+
+    fn format(&self) -> String {
+        format!("{} {}", self.count, M_("events lost"))
+    }
+}
+
+/// Event for the monitor starting up
+pub struct RunningEvent {}
+
+impl XfsHealthEvent for RunningEvent {
+    fn format(&self) -> String {
+        M_("monitoring started")
+    }
+}
+
+/// Event for the program losing events due to unrecognized inputs
+pub struct UnknownEvent {}
+
+impl XfsHealthEvent for UnknownEvent {
+    fn must_log(&self) -> bool {
+        true
+    }
+
+    fn format(&self) -> String {
+        M_("unrecognized event")
+    }
+}
diff --git a/healer/src/healthmon/fs.rs b/healer/src/healthmon/fs.rs
new file mode 100644
index 00000000000000..ca50683dce7f04
--- /dev/null
+++ b/healer/src/healthmon/fs.rs
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::display_for_enum;
+use crate::healthmon::event::XfsHealthEvent;
+use crate::healthmon::event::XfsHealthStatus;
+use crate::util::format_set;
+use crate::xfs_types::XfsPhysRange;
+use crate::xfsprogs::M_;
+use enumset::EnumSet;
+use enumset::EnumSetType;
+
+/// Metadata types for an XFS whole-fs metadata
+#[derive(EnumSetType, Debug)]
+pub enum XfsWholeFsMetadata {
+    FsCounters,
+    GrpQuota,
+    MetaDir,
+    MetaPath,
+    NLinks,
+    PrjQuota,
+    QuotaCheck,
+    UsrQuota,
+}
+
+display_for_enum!(XfsWholeFsMetadata, {
+    FsCounters => M_("fscounters"),
+    GrpQuota =>   M_("grpquota"),
+    MetaDir =>    M_("metadir"),
+    MetaPath =>   M_("metapath"),
+    NLinks =>     M_("nlinks"),
+    PrjQuota =>   M_("prjquota"),
+    QuotaCheck => M_("quotacheck"),
+    UsrQuota =>   M_("usrquota"),
+});
+
+/// XFS whole-fs health event
+#[derive(Debug)]
+pub struct XfsWholeFsEvent {
+    /// What is being reported on?
+    metadata: EnumSet<XfsWholeFsMetadata>,
+
+    /// Reported state
+    status: XfsHealthStatus,
+}
+
+impl XfsWholeFsEvent {
+    /// Create a new whole-fs event object
+    pub fn new(metadata: EnumSet<XfsWholeFsMetadata>, status: XfsHealthStatus) -> XfsWholeFsEvent {
+        XfsWholeFsEvent { metadata, status }
+    }
+}
+
+impl XfsHealthEvent for XfsWholeFsEvent {
+    fn format(&self) -> String {
+        format!(
+            "{} {} {}",
+            format_set(self.metadata),
+            M_("status"),
+            self.status
+        )
+    }
+}
+
+/// Reasons for a filesystem shutdown event
+#[derive(EnumSetType, Debug)]
+pub enum XfsShutdownReason {
+    CorruptIncore,
+    CorruptOndisk,
+    DeviceRemoved,
+    ForceUmount,
+    LogIoerr,
+    MetaIoerr,
+}
+
+display_for_enum!(XfsShutdownReason, {
+    CorruptIncore => M_("in-memory state corruption"),
+    CorruptOndisk => M_("ondisk metadata corruption"),
+    DeviceRemoved => M_("device removed"),
+    ForceUmount   => M_("forced unmount"),
+    LogIoerr      => M_("log I/O error"),
+    MetaIoerr     => M_("metadata I/O error"),
+});
+
+/// XFS shutdown health event
+#[derive(Debug)]
+pub struct XfsShutdownEvent {
+    /// Why did the filesystem shut down?
+    reasons: EnumSet<XfsShutdownReason>,
+}
+
+impl XfsShutdownEvent {
+    /// Create a new whole-fs event object
+    pub fn new(reasons: EnumSet<XfsShutdownReason>) -> XfsShutdownEvent {
+        XfsShutdownEvent { reasons }
+    }
+}
+
+impl XfsHealthEvent for XfsShutdownEvent {
+    fn must_log(&self) -> bool {
+        true
+    }
+
+    fn format(&self) -> String {
+        format!(
+            "{} {}",
+            M_("filesystem shut down due to"),
+            format_set(self.reasons)
+        )
+    }
+}
+
+/// Event for the filesystem being unmounted
+pub struct XfsUnmountEvent {}
+
+impl XfsHealthEvent for XfsUnmountEvent {
+    fn must_log(&self) -> bool {
+        true
+    }
+
+    fn format(&self) -> String {
+        M_("filesystem unmounted")
+    }
+}
+
+/// Media error event
+#[derive(Debug)]
+pub struct XfsMediaErrorEvent {
+    /// Where was the media error?
+    range: XfsPhysRange,
+}
+
+impl XfsMediaErrorEvent {
+    /// Create a new file IO error event object
+    pub fn new(range: XfsPhysRange) -> XfsMediaErrorEvent {
+        XfsMediaErrorEvent { range }
+    }
+}
+
+impl XfsHealthEvent for XfsMediaErrorEvent {
+    fn format(&self) -> String {
+        format!("{} {}", M_("media error on"), self.range)
+    }
+}
diff --git a/healer/src/healthmon/groups.rs b/healer/src/healthmon/groups.rs
new file mode 100644
index 00000000000000..0c3719fc5099eb
--- /dev/null
+++ b/healer/src/healthmon/groups.rs
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::display_for_enum;
+use crate::healthmon::event::XfsHealthEvent;
+use crate::healthmon::event::XfsHealthStatus;
+use crate::util::format_set;
+use crate::xfs_types::{XfsAgNumber, XfsRgNumber};
+use crate::xfsprogs::M_;
+use enumset::EnumSet;
+use enumset::EnumSetType;
+
+/// Metadata types for an allocation group on the data device
+#[derive(EnumSetType, Debug)]
+pub enum XfsPeragMetadata {
+    Agf,
+    Agfl,
+    Agi,
+    Bnobt,
+    Cntbt,
+    Finobt,
+    Inobt,
+    Inodes,
+    Refcountbt,
+    Rmapbt,
+    Super,
+}
+
+display_for_enum!(XfsPeragMetadata, {
+    Agf        => M_("agf"),
+    Agfl       => M_("agfl"),
+    Agi        => M_("agi"),
+    Bnobt      => M_("bnobt"),
+    Cntbt      => M_("cntbt"),
+    Finobt     => M_("finobt"),
+    Inobt      => M_("inobt"),
+    Inodes     => M_("inodes"),
+    Refcountbt => M_("refcountbt"),
+    Rmapbt     => M_("rmapbt"),
+    Super      => M_("super"),
+});
+
+/// XFS perag health event
+#[derive(Debug)]
+pub struct XfsPeragEvent {
+    /// Allocation group number
+    group: XfsAgNumber,
+
+    /// What is being reported on?
+    metadata: EnumSet<XfsPeragMetadata>,
+
+    /// Reported state
+    status: XfsHealthStatus,
+}
+
+impl XfsPeragEvent {
+    /// Create a new perag event object
+    pub fn new(
+        group: XfsAgNumber,
+        metadata: EnumSet<XfsPeragMetadata>,
+        status: XfsHealthStatus,
+    ) -> XfsPeragEvent {
+        XfsPeragEvent {
+            group,
+            metadata,
+            status,
+        }
+    }
+}
+
+impl XfsHealthEvent for XfsPeragEvent {
+    fn format(&self) -> String {
+        format!(
+            "{} {} {}",
+            self.group,
+            format_set(self.metadata),
+            self.status
+        )
+    }
+}
+
+/// Metadata types for an allocation group on the realtime device
+#[derive(EnumSetType, Debug)]
+pub enum XfsRtgroupMetadata {
+    Bitmap,
+    Summary,
+    Refcountbt,
+    Rmapbt,
+    Super,
+}
+
+display_for_enum!(XfsRtgroupMetadata, {
+    Bitmap     => M_("bitmap"),
+    Summary    => M_("summary"),
+    Refcountbt => M_("refcountbt"),
+    Rmapbt     => M_("rmapbt"),
+    Super      => M_("super"),
+});
+
+/// XFS rtgroup health event
+#[derive(Debug)]
+pub struct XfsRtgroupEvent {
+    /// Allocation group number
+    group: XfsRgNumber,
+
+    /// What is being reported on?
+    metadata: EnumSet<XfsRtgroupMetadata>,
+
+    /// Reported state
+    status: XfsHealthStatus,
+}
+
+impl XfsRtgroupEvent {
+    /// Create a new rtgroup event object
+    pub fn new(
+        group: XfsRgNumber,
+        metadata: EnumSet<XfsRtgroupMetadata>,
+        status: XfsHealthStatus,
+    ) -> XfsRtgroupEvent {
+        XfsRtgroupEvent {
+            group,
+            metadata,
+            status,
+        }
+    }
+}
+
+impl XfsHealthEvent for XfsRtgroupEvent {
+    fn format(&self) -> String {
+        format!(
+            "{} {} {}",
+            self.group,
+            format_set(self.metadata),
+            self.status
+        )
+    }
+}
diff --git a/healer/src/healthmon/inodes.rs b/healer/src/healthmon/inodes.rs
new file mode 100644
index 00000000000000..5fac02a9d9cbe7
--- /dev/null
+++ b/healer/src/healthmon/inodes.rs
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::display_for_enum;
+use crate::healthmon::event::XfsHealthEvent;
+use crate::healthmon::event::XfsHealthStatus;
+use crate::util::format_set;
+use crate::xfs_types::{XfsFid, XfsFileRange};
+use crate::xfsprogs::M_;
+use enumset::EnumSet;
+use enumset::EnumSetType;
+
+/// Metadata types for an XFS inode
+#[derive(EnumSetType, Debug)]
+pub enum XfsInodeMetadata {
+    Bmapbta,
+    Bmapbtc,
+    Bmapbtd,
+    Core,
+    Directory,
+    Dirtree,
+    Parent,
+    Symlink,
+    Xattr,
+}
+
+display_for_enum!(XfsInodeMetadata, {
+    Bmapbta   => M_("attrfork"),
+    Bmapbtc   => M_("cowfork"),
+    Bmapbtd   => M_("datafork"),
+    Core      => M_("core"),
+    Directory => M_("directory"),
+    Dirtree   => M_("dirtree"),
+    Parent    => M_("parent"),
+    Symlink   => M_("symlink"),
+    Xattr     => M_("xattr"),
+});
+
+/// XFS inode health event
+#[derive(Debug)]
+pub struct XfsInodeEvent {
+    /// File information
+    fid: XfsFid,
+
+    /// What is being reported on?
+    metadata: EnumSet<XfsInodeMetadata>,
+
+    /// Reported state
+    status: XfsHealthStatus,
+}
+
+impl XfsInodeEvent {
+    /// Create a new inode metadata event object
+    pub fn new(
+        fid: XfsFid,
+        metadata: EnumSet<XfsInodeMetadata>,
+        status: XfsHealthStatus,
+    ) -> XfsInodeEvent {
+        XfsInodeEvent {
+            fid,
+            metadata,
+            status,
+        }
+    }
+}
+
+impl XfsHealthEvent for XfsInodeEvent {
+    fn format(&self) -> String {
+        format!("{} {} {}", self.fid, format_set(self.metadata), self.status)
+    }
+}
+
+/// File I/O types
+#[derive(Debug)]
+pub enum XfsFileIoErrorType {
+    Readahead,
+    Writeback,
+    DirectioRead,
+    DirectioWrite,
+}
+
+display_for_enum!(XfsFileIoErrorType, {
+    Readahead     => M_("readahead"),
+    Writeback     => M_("writeback"),
+    DirectioRead  => M_("directio_read"),
+    DirectioWrite => M_("directio_write"),
+});
+
+/// XFS file I/O error event
+#[derive(Debug)]
+pub struct XfsFileIoErrorEvent {
+    /// What file I/O went wrong?
+    iotype: XfsFileIoErrorType,
+
+    /// Which file?
+    fid: XfsFid,
+
+    /// Which file and where?
+    range: XfsFileRange,
+}
+
+impl XfsFileIoErrorEvent {
+    /// Create a new file IO error event object
+    pub fn new(
+        iotype: XfsFileIoErrorType,
+        fid: XfsFid,
+        range: XfsFileRange,
+    ) -> XfsFileIoErrorEvent {
+        XfsFileIoErrorEvent { iotype, fid, range }
+    }
+}
+
+impl XfsHealthEvent for XfsFileIoErrorEvent {
+    fn format(&self) -> String {
+        format!("{} {} {}", self.fid, self.iotype, self.range)
+    }
+}
diff --git a/healer/src/healthmon/mod.rs b/healer/src/healthmon/mod.rs
new file mode 100644
index 00000000000000..a22248398a53a7
--- /dev/null
+++ b/healer/src/healthmon/mod.rs
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::xfs_fs::xfs_health_monitor;
+use nix::ioctl_write_ptr;
+
+pub mod event;
+pub mod fs;
+pub mod groups;
+pub mod inodes;
+
+ioctl_write_ptr!(xfs_ioc_health_monitor, 'X', 68, xfs_health_monitor);
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
index 9455ed840b3ab0..e9b4795be00904 100644
--- a/healer/src/lib.rs
+++ b/healer/src/lib.rs
@@ -6,3 +6,6 @@
 
 pub mod xfsprogs;
 pub mod xfs_fs;
+pub mod xfs_types;
+pub mod util;
+pub mod healthmon;
diff --git a/healer/src/main.rs b/healer/src/main.rs
index d43640e140d46c..3908dcd23922da 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -8,6 +8,7 @@ use clap::{value_parser, Arg, ArgAction, ArgMatches, Command};
 use std::fs::File;
 use std::path::PathBuf;
 use std::process::ExitCode;
+use xfs_healer::printlogln;
 use xfs_healer::xfsprogs;
 use xfs_healer::xfsprogs::M_;
 
@@ -93,12 +94,12 @@ fn main() -> ExitCode {
 
     let args = Cli::new();
     if args.0.get_flag("version") {
-        println!("{} {}", M_("xfs_healer version"), xfsprogs::VERSION);
+        printlogln!("{} {}", M_("xfs_healer version"), xfsprogs::VERSION);
         return ExitCode::SUCCESS;
     }
 
     if args.0.get_flag("debug") {
-        println!("args: {:?}", args);
+        printlogln!("args: {:?}", args);
     }
 
     let app: App = args.into();
diff --git a/healer/src/util.rs b/healer/src/util.rs
new file mode 100644
index 00000000000000..bce48f83b01da0
--- /dev/null
+++ b/healer/src/util.rs
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use enumset::EnumSet;
+use enumset::EnumSetType;
+use std::fmt::Display;
+
+/// Simple macro for creating errors for badly formatted event data.  The first parameter describes
+/// why the data is bad; the second is the target type; and the third is value provided.
+#[macro_export]
+macro_rules! baddata {
+    ($message:expr , $type:tt , $value:expr) => {{
+        match (&$message, &$value) {
+            (message_val, value_val) => {
+                let s = format!(
+                    "{}: {} {} {}.",
+                    value_val,
+                    message_val,
+                    $crate::xfsprogs::M_("for"),
+                    std::any::type_name::<$type>()
+                );
+                std::io::Error::new(std::io::ErrorKind::InvalidData, s)
+            }
+        }
+    }};
+}
+
+/// Write a line to standard output and flush it.
+#[macro_export]
+macro_rules! printlogln {
+    ( $($t:tt)* ) => {
+        {
+            use std::io::Write;
+            let mut h = std::io::stdout().lock();
+            write!(h, $($t)* ).unwrap();
+            write!(h, "\n").unwrap();
+            h.flush().unwrap();
+        }
+    }
+}
+
+/// Boilerplate to stamp out functions to convert an enum to some sort of pretty string.
+// XXX: This could have been a derive macro
+#[macro_export]
+macro_rules! display_for_enum {
+    ($enum_type:ty , { $($a:ident => $b:expr,)+ } ) => {
+        impl std::fmt::Display for $enum_type {
+            /// Convert from an enum to a string
+            fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
+                write!(f, "{}", match self { $(<$enum_type>::$a => $b,)+ })
+            }
+        }
+    };
+}
+
+/// Format an enum set into a string
+pub fn format_set<T: EnumSetType + Display>(f: EnumSet<T>) -> String {
+    let mut ret = "".to_string();
+    let mut is_first = true;
+
+    for v in f {
+        if !is_first {
+            ret.push_str(", ");
+        }
+        is_first = false;
+        ret.push_str(&format!("{}", v));
+    }
+
+    ret
+}
diff --git a/healer/src/xfs_types.rs b/healer/src/xfs_types.rs
new file mode 100644
index 00000000000000..5ce1d73d8e9342
--- /dev/null
+++ b/healer/src/xfs_types.rs
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::baddata;
+use crate::display_for_enum;
+use crate::xfsprogs::M_;
+use anyhow::{Error, Result};
+use std::fmt::Display;
+use std::fmt::Formatter;
+
+/// Allocation group number on the data device
+#[derive(Debug)]
+pub struct XfsAgNumber(u32);
+
+impl TryFrom<u64> for XfsAgNumber {
+    type Error = Error;
+
+    fn try_from(v: u64) -> Result<Self> {
+        if v > i32::MAX as u64 {
+            Err(baddata!(M_("AG number too large"), Self, v).into())
+        } else {
+            Ok(XfsAgNumber(v as u32))
+        }
+    }
+}
+
+impl Display for XfsAgNumber {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {}", M_("agno"), self.0)
+    }
+}
+
+/// Realtime group number on the realtime device
+#[derive(Debug)]
+pub struct XfsRgNumber(u32);
+
+impl Display for XfsRgNumber {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {}", M_("rgno"), self.0)
+    }
+}
+
+impl TryFrom<u64> for XfsRgNumber {
+    type Error = Error;
+
+    fn try_from(v: u64) -> Result<Self> {
+        if v > i32::MAX as u64 {
+            Err(baddata!(M_("rtgroup number too large"), Self, v).into())
+        } else {
+            Ok(XfsRgNumber(v as u32))
+        }
+    }
+}
+
+/// Disk devices
+#[derive(Debug)]
+pub enum XfsDevice {
+    Data,
+    Log,
+    Realtime,
+}
+
+display_for_enum!(XfsDevice, {
+    Data     => M_("datadev"),
+    Log      => M_("logdev"),
+    Realtime => M_("rtdev"),
+});
+
+/// Disk address, in 512b units
+#[derive(Debug)]
+pub struct XfsDaddr(u64);
+
+impl Display for XfsDaddr {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {:#x}", M_("daddr"), self.0)
+    }
+}
+
+impl From<u64> for XfsDaddr {
+    fn from(v: u64) -> XfsDaddr {
+        XfsDaddr(v)
+    }
+}
+
+/// Disk space length, in 512b units
+#[derive(Debug)]
+pub struct XfsBbcount(u64);
+
+impl Display for XfsBbcount {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {:#x}", M_("bbcount"), self.0)
+    }
+}
+
+impl From<u64> for XfsBbcount {
+    fn from(v: u64) -> XfsBbcount {
+        XfsBbcount(v)
+    }
+}
+
+/// Range of physical storage
+#[derive(Debug)]
+pub struct XfsPhysRange {
+    /// Which device is this?
+    pub device: XfsDevice,
+
+    /// Start of the range, in 512b units
+    pub daddr: XfsDaddr,
+
+    /// Size of the range, in 512b units
+    pub bbcount: XfsBbcount,
+}
+
+impl Display for XfsPhysRange {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {} {}", self.device, self.daddr, self.bbcount)
+    }
+}
+
+/// Inode number
+#[derive(Debug)]
+pub struct XfsIno(u64);
+
+impl Display for XfsIno {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {}", M_("ino"), self.0)
+    }
+}
+
+impl TryFrom<u64> for XfsIno {
+    type Error = Error;
+
+    fn try_from(v: u64) -> Result<Self> {
+        if v > i64::MAX as u64 {
+            Err(baddata!(M_("inode number too large"), Self, v).into())
+        } else {
+            Ok(XfsIno(v))
+        }
+    }
+}
+
+/// Inode generation number
+#[derive(Debug)]
+pub struct XfsIgeneration(u32);
+
+impl Display for XfsIgeneration {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {:#x}", M_("gen"), self.0)
+    }
+}
+
+impl TryFrom<u64> for XfsIgeneration {
+    type Error = Error;
+
+    fn try_from(v: u64) -> Result<Self> {
+        if v > u32::MAX as u64 {
+            Err(baddata!(M_("inode generation number too large"), Self, v).into())
+        } else {
+            Ok(XfsIgeneration(v as u32))
+        }
+    }
+}
+
+/// Miniature FID for a handle
+#[derive(Debug)]
+pub struct XfsFid {
+    /// Inode number
+    pub ino: XfsIno,
+
+    /// Inode generation
+    pub gen: XfsIgeneration,
+}
+
+impl Display for XfsFid {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {}", self.ino, self.gen)
+    }
+}
+
+/// File position
+#[derive(Debug)]
+pub struct XfsPos(u64);
+
+impl Display for XfsPos {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {}", M_("pos"), self.0)
+    }
+}
+
+impl TryFrom<u64> for XfsPos {
+    type Error = Error;
+
+    fn try_from(v: u64) -> Result<Self> {
+        if v > i64::MAX as u64 {
+            Err(baddata!(M_("file position too large"), Self, v).into())
+        } else {
+            Ok(XfsPos(v))
+        }
+    }
+}
+
+/// File IO length
+#[derive(Debug)]
+pub struct XfsIoLen(i64);
+
+impl Display for XfsIoLen {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {}", M_("len"), self.0)
+    }
+}
+
+impl TryFrom<u64> for XfsIoLen {
+    type Error = Error;
+
+    fn try_from(v: u64) -> Result<Self> {
+        if v > i64::MAX as u64 {
+            Err(baddata!(M_("file IO length too large"), Self, v).into())
+        } else {
+            Ok(XfsIoLen(v as i64))
+        }
+    }
+}
+
+/// Range of a file's bytes
+#[derive(Debug)]
+pub struct XfsFileRange {
+    /// Start of range, in bytes
+    pub pos: XfsPos,
+
+    /// Length of range, in bytes
+    pub len: XfsIoLen,
+}
+
+impl Display for XfsFileRange {
+    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
+        write!(f, "{} {}", self.pos, self.len)
+    }
+}
diff --git a/m4/package_rust.m4 b/m4/package_rust.m4
index 0c25d7fba02243..4b426f968c263c 100644
--- a/m4/package_rust.m4
+++ b/m4/package_rust.m4
@@ -129,6 +129,8 @@ AC_DEFUN([AC_HAVE_HEALER_CRATES],
 clap = { version = "4.0.32", features = [["derive"]] }
 anyhow = { version = "1.0.69" }
 $gettext_dep
+nix = { version = "0", features = [["ioctl"]] }		# 0.26.1
+enumset = { version = "1.0.12" }
 ],
     [yes], [no])
 ])

