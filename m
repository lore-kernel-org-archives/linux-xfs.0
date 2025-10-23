Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C147A95E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178466; cv=none; b=D1bQOkixMeLbB7oSR2qYU7KlD0VXvxIVrbuShhdLWrYluUnAvREkVyaElM3PYZZzogYT/vIFbemmQ0cM9tSc6V3W9XPh97yB0fYB0Q0KS5dOZlkkZ2JIsrpkJLg6QmgLPGTF9gujWvz16EO5UE1brV4Q5BJT/j/KmKJ2/rf9TtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178466; c=relaxed/simple;
	bh=WcE0dPNXK/+GhGslLOF5YHn9pFdRsWnbqBmhp0HD8XY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xs4ejIlWANy4eTUUU615QECkh5sOal5kzCzvee6QKdIevPgbdwFchfvroJ2r9NLRAr+R+UeGNZ57GtsGKdsplzeQfaKmm5Z3QoCkVcfxUePnA+RhE3xxdifMqVdGQnP01w6TksC0KJNpGiexX3UETtm9zrm6GIloi3TodJ1ntmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnxuXpk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnxuXpk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10343C4CEE7;
	Thu, 23 Oct 2025 00:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178466;
	bh=WcE0dPNXK/+GhGslLOF5YHn9pFdRsWnbqBmhp0HD8XY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CnxuXpk1SBE6eCPQXlAzODDlu6nvl6r5jIRArp/FZMviJG752bnbYs1RI4nkW16o9
	 Gd0+M/FonSjGTk2oNMeg7gE04tO+ZhIKdlurgfGzFddGNRfwA8WXVtKneRCm5751IX
	 4QgW5Tzt2AO9EGZpSWkhJDzvyye8FW1OatRdYtLPZLcrKPvxPmuodTfbcf3z9d+PPD
	 8a7o+4Whq242mPVfBcAU3cpPjWjtwWE9KbaWIzYwxqByziRAyLml3u/xwSUdXoWbaO
	 iLceuT3YsUDwC2DhB8wmfuBuG2JdVFMDW27vDSBJE5cNVmFw8jm5BAiNHY0rQZVS+E
	 jYYCDZWhiv38Q==
Date: Wed, 22 Oct 2025 17:14:25 -0700
Subject: [PATCH 08/19] xfs_healer: fix broken filesystem metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748407.1029045.8559624452733443456.stgit@frogsfrogsfrogs>
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

Use the soft file handle we created in the previous patch to schedule
repairs when possible.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile                |    1 
 healer/src/healthmon/event.rs  |   29 ++++
 healer/src/healthmon/fs.rs     |    6 +
 healer/src/healthmon/groups.rs |   10 +
 healer/src/healthmon/inodes.rs |    6 +
 healer/src/lib.rs              |    1 
 healer/src/main.rs             |   21 ++-
 healer/src/repair.rs           |  302 ++++++++++++++++++++++++++++++++++++++++
 healer/src/weakhandle.rs       |   13 ++
 healer/src/xfs_types.rs        |   56 +++++++
 10 files changed, 435 insertions(+), 10 deletions(-)
 create mode 100644 healer/src/repair.rs


diff --git a/healer/Makefile b/healer/Makefile
index 75227820a51e79..05ea73b8163a49 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -19,6 +19,7 @@ HFILES = \
 RUSTFILES = \
 	src/lib.rs \
 	src/main.rs \
+	src/repair.rs \
 	src/util.rs \
 	src/weakhandle.rs \
 	src/xfs_fs.rs \
diff --git a/healer/src/healthmon/event.rs b/healer/src/healthmon/event.rs
index b7a0effab94a3c..0fcd34dee38e4c 100644
--- a/healer/src/healthmon/event.rs
+++ b/healer/src/healthmon/event.rs
@@ -4,6 +4,7 @@
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 use crate::display_for_enum;
+use crate::repair::Repair;
 use crate::xfsprogs::M_;
 use strum_macros::EnumString;
 
@@ -16,10 +17,36 @@ pub trait XfsHealthEvent {
 
     /// Format this event as something we can display
     fn format(&self) -> String;
+
+    /// Generate the inputs to a kernel scrub ioctl
+    fn schedule_repairs(&self) -> Vec<Repair> {
+        vec![]
+    }
 }
 
+/// Boilerplate implementation of a schedule_repairs function.  Pass a lambda
+/// that generates a Repair object from &self and sm_type.
+#[macro_export]
+macro_rules! schedule_repairs {
+    ($event_type:ty , $lambda: expr ) => {
+        fn schedule_repairs(&self) -> Vec<$crate::repair::Repair> {
+            if self.status != $crate::healthmon::event::XfsHealthStatus::Sick {
+                return vec![];
+            }
+            let mut ret = Vec::new();
+            for f in self.metadata {
+                if let Some(sm_type) = f.to_scrub() {
+                    ret.push($lambda(self, sm_type));
+                }
+            }
+            ret
+        }
+    };
+}
+pub(crate) use schedule_repairs;
+
 /// Health status for metadata events
-#[derive(Debug, EnumString)]
+#[derive(PartialEq, Debug, EnumString)]
 #[strum(serialize_all = "lowercase")]
 pub enum XfsHealthStatus {
     /// Problems have been observed at runtime
diff --git a/healer/src/healthmon/fs.rs b/healer/src/healthmon/fs.rs
index f216867acdf71a..7a2307d29e7abd 100644
--- a/healer/src/healthmon/fs.rs
+++ b/healer/src/healthmon/fs.rs
@@ -4,8 +4,10 @@
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 use crate::display_for_enum;
+use crate::healthmon::event::schedule_repairs;
 use crate::healthmon::event::XfsHealthEvent;
 use crate::healthmon::event::XfsHealthStatus;
+use crate::repair::Repair;
 use crate::util::format_set;
 use crate::xfs_types::XfsPhysRange;
 use crate::xfsprogs::M_;
@@ -64,6 +66,10 @@ impl XfsHealthEvent for XfsWholeFsEvent {
             self.status
         )
     }
+
+    schedule_repairs!(XfsWholeFsEvent, |_: &XfsWholeFsEvent, sm_type| {
+        Repair::from_whole_fs(sm_type)
+    });
 }
 
 /// Reasons for a filesystem shutdown event
diff --git a/healer/src/healthmon/groups.rs b/healer/src/healthmon/groups.rs
index 4384de50b4c63f..60a44defb5d307 100644
--- a/healer/src/healthmon/groups.rs
+++ b/healer/src/healthmon/groups.rs
@@ -4,8 +4,10 @@
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 use crate::display_for_enum;
+use crate::healthmon::event::schedule_repairs;
 use crate::healthmon::event::XfsHealthEvent;
 use crate::healthmon::event::XfsHealthStatus;
+use crate::repair::Repair;
 use crate::util::format_set;
 use crate::xfs_types::{XfsAgNumber, XfsRgNumber};
 use crate::xfsprogs::M_;
@@ -81,6 +83,10 @@ impl XfsHealthEvent for XfsPeragEvent {
             self.status
         )
     }
+
+    schedule_repairs!(XfsPeragEvent, |s: &XfsPeragEvent, sm_type| {
+        Repair::from_perag(sm_type, s.group)
+    });
 }
 
 /// Metadata types for an allocation group on the realtime device
@@ -139,4 +145,8 @@ impl XfsHealthEvent for XfsRtgroupEvent {
             self.status
         )
     }
+
+    schedule_repairs!(XfsRtgroupEvent, |s: &XfsRtgroupEvent, sm_type| {
+        Repair::from_rtgroup(sm_type, s.group)
+    });
 }
diff --git a/healer/src/healthmon/inodes.rs b/healer/src/healthmon/inodes.rs
index 5775f9ffa69b6b..a4324c7d834b42 100644
--- a/healer/src/healthmon/inodes.rs
+++ b/healer/src/healthmon/inodes.rs
@@ -4,8 +4,10 @@
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 use crate::display_for_enum;
+use crate::healthmon::event::schedule_repairs;
 use crate::healthmon::event::XfsHealthEvent;
 use crate::healthmon::event::XfsHealthStatus;
+use crate::repair::Repair;
 use crate::util::format_set;
 use crate::xfs_types::{XfsFid, XfsFileRange};
 use crate::xfsprogs::M_;
@@ -72,6 +74,10 @@ impl XfsHealthEvent for XfsInodeEvent {
     fn format(&self) -> String {
         format!("{} {} {}", self.fid, format_set(self.metadata), self.status)
     }
+
+    schedule_repairs!(XfsInodeEvent, |s: &XfsInodeEvent, sm_type| {
+        Repair::from_file(sm_type, s.fid)
+    });
 }
 
 /// File I/O types
diff --git a/healer/src/lib.rs b/healer/src/lib.rs
index bd39f4d47b5068..f08f9a65ced674 100644
--- a/healer/src/lib.rs
+++ b/healer/src/lib.rs
@@ -10,3 +10,4 @@ pub mod xfs_types;
 pub mod util;
 pub mod healthmon;
 pub mod weakhandle;
+pub mod repair;
diff --git a/healer/src/main.rs b/healer/src/main.rs
index 24281ac7f1eeea..b2a69c388bd8ef 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -61,6 +61,12 @@ impl Cli {
                     .help(M_("Use the JSON kernel interface instead of C"))
                     .action(ArgAction::SetTrue),
             )
+            .arg(
+                Arg::new("repair")
+                    .long("repair")
+                    .help(M_("Always repair corrupt metadata"))
+                    .action(ArgAction::SetTrue),
+            )
             .get_matches())
     }
 }
@@ -72,6 +78,7 @@ struct App {
     log: bool,
     everything: bool,
     json: bool,
+    repair: bool,
     path: PathBuf,
 }
 
@@ -82,7 +89,7 @@ impl App {
     }
 
     /// Handle a health event that has been decoded into real objects
-    fn process_event(&self, cooked: Result<Box<dyn XfsHealthEvent>>) {
+    fn process_event(&self, fh: &WeakHandle, cooked: Result<Box<dyn XfsHealthEvent>>) {
         match cooked {
             Err(e) => {
                 eprintln!("{}: {:#}", self.path.display(), e)
@@ -91,6 +98,11 @@ impl App {
                 if self.log || event.must_log() {
                     printlogln!("{}: {}", self.path.display(), event.format());
                 }
+                if self.repair {
+                    for mut repair in event.schedule_repairs() {
+                        repair.perform(fh)
+                    }
+                }
             }
         }
     }
@@ -98,7 +110,7 @@ impl App {
     /// Main app method
     fn main(&self) -> Result<ExitCode> {
         let fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
-        let _fh = WeakHandle::try_new(&fp, &self.path)
+        let fh = WeakHandle::try_new(&fp, &self.path)
             .with_context(|| M_("Configuring filesystem handle"))?;
 
         if self.json {
@@ -106,14 +118,14 @@ impl App {
                 .with_context(|| M_("Opening js health monitor file"))?;
 
             for raw_event in hmon {
-                self.process_event(raw_event.cook());
+                self.process_event(&fh, raw_event.cook());
             }
         } else {
             let hmon = CStructMonitor::try_new(fp, &self.path, self.everything)
                 .with_context(|| M_("Opening health monitor file"))?;
 
             for raw_event in hmon {
-                self.process_event(raw_event.cook());
+                self.process_event(&fh, raw_event.cook());
             }
         }
 
@@ -129,6 +141,7 @@ impl From<Cli> for App {
             everything: cli.0.get_flag("everything"),
             path: cli.0.get_one::<PathBuf>("path").unwrap().to_path_buf(),
             json: cli.0.get_flag("json"),
+            repair: cli.0.get_flag("repair"),
         }
     }
 }
diff --git a/healer/src/repair.rs b/healer/src/repair.rs
new file mode 100644
index 00000000000000..8b9a665d1bcc36
--- /dev/null
+++ b/healer/src/repair.rs
@@ -0,0 +1,302 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::display_for_enum;
+use crate::healthmon::fs::XfsWholeFsMetadata;
+use crate::healthmon::groups::{XfsPeragMetadata, XfsRtgroupMetadata};
+use crate::healthmon::inodes::XfsInodeMetadata;
+use crate::printlogln;
+use crate::weakhandle::WeakHandle;
+use crate::xfs_fs;
+use crate::xfs_fs::xfs_scrub_metadata;
+use crate::xfs_types::{XfsAgNumber, XfsFid, XfsRgNumber};
+use crate::xfsprogs::M_;
+use anyhow::{Context, Result};
+use nix::ioctl_readwrite;
+use std::os::fd::AsRawFd;
+
+ioctl_readwrite!(xfs_ioc_scrub_metadata, 'X', 60, xfs_scrub_metadata);
+
+/// Classification information for later reporting
+#[derive(Debug)]
+enum RepairGroup {
+    WholeFs,
+    PerAg,
+    RtGroup,
+    File,
+}
+
+/// What happened when we tried to repair something?
+#[derive(Debug)]
+enum RepairOutcome {
+    Queued,
+    Success,
+    Unnecessary,
+    MightBeOk,
+    Failed,
+}
+
+display_for_enum!(RepairOutcome, {
+    Queued      => M_("Repair queued."),
+    Failed      => M_("Repair unsuccessful; offline repair required."),
+    MightBeOk   => M_("Seems correct but cross-referencing failed; offline repair recommended."),
+    Unnecessary => M_("No modification needed."),
+    Success     => M_("Repairs successful."),
+});
+
+/// Kernel scrub type code
+#[derive(Debug)]
+pub struct XfsScrubType(pub u32);
+
+/// Boilerplate to stamp out functions to convert json array to the given enum
+/// type; or return an error with the given message.
+macro_rules! metadata_to_scrub_type {
+    ($enum_type:ty , { $($a:ident => $b:ident,)+ } ) => {
+        impl $enum_type {
+            /// Convert to scrub type
+            #[allow(unreachable_patterns)]
+            pub fn to_scrub(self) -> Option<XfsScrubType> {
+                match self {
+                    $(<$enum_type>::$a => Some($crate::repair::XfsScrubType($crate::xfs_fs::$b)),)+
+                    _ => None,
+                }
+            }
+        }
+    };
+}
+
+metadata_to_scrub_type!(XfsPeragMetadata, {
+    Agf        => XFS_SCRUB_TYPE_AGF,
+    Agfl       => XFS_SCRUB_TYPE_AGFL,
+    Agi        => XFS_SCRUB_TYPE_AGI,
+    Bnobt      => XFS_SCRUB_TYPE_BNOBT,
+    Cntbt      => XFS_SCRUB_TYPE_CNTBT,
+    Finobt     => XFS_SCRUB_TYPE_FINOBT,
+    Inobt      => XFS_SCRUB_TYPE_INOBT,
+    Refcountbt => XFS_SCRUB_TYPE_REFCNTBT,
+    Rmapbt     => XFS_SCRUB_TYPE_RMAPBT,
+    Super      => XFS_SCRUB_TYPE_SB,
+});
+
+metadata_to_scrub_type!(XfsRtgroupMetadata, {
+    Bitmap     => XFS_SCRUB_TYPE_RTBITMAP,
+    Summary    => XFS_SCRUB_TYPE_RTSUM,
+    Refcountbt => XFS_SCRUB_TYPE_RTREFCBT,
+    Rmapbt     => XFS_SCRUB_TYPE_RTRMAPBT,
+    Super      => XFS_SCRUB_TYPE_RGSUPER,
+});
+
+metadata_to_scrub_type!(XfsInodeMetadata, {
+    Bmapbta   => XFS_SCRUB_TYPE_BMBTA,
+    Bmapbtc   => XFS_SCRUB_TYPE_BMBTC,
+    Bmapbtd   => XFS_SCRUB_TYPE_BMBTD,
+    Core      => XFS_SCRUB_TYPE_INODE,
+    Directory => XFS_SCRUB_TYPE_DIR,
+    Dirtree   => XFS_SCRUB_TYPE_DIRTREE,
+    Parent    => XFS_SCRUB_TYPE_PARENT,
+    Symlink   => XFS_SCRUB_TYPE_SYMLINK,
+    Xattr     => XFS_SCRUB_TYPE_XATTR,
+});
+
+metadata_to_scrub_type!(XfsWholeFsMetadata, {
+    FsCounters => XFS_SCRUB_TYPE_FSCOUNTERS,
+    GrpQuota   => XFS_SCRUB_TYPE_GQUOTA,
+    NLinks     => XFS_SCRUB_TYPE_NLINKS,
+    PrjQuota   => XFS_SCRUB_TYPE_PQUOTA,
+    QuotaCheck => XFS_SCRUB_TYPE_QUOTACHECK,
+    UsrQuota   => XFS_SCRUB_TYPE_UQUOTA,
+});
+
+/// Boilerplate to stamp out functions to print the scrub type newtype as a pretty string.
+macro_rules! display_for_newtype {
+    ($newtype:ty , { $($a:ident => $b:expr,)+ } ) => {
+        impl std::fmt::Display for $newtype {
+            fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
+                write!(f, "{}", match self.0 {
+                    $(xfs_fs::$a => $b,)+
+                    _ => $crate::xfsprogs::M_("unknown")
+                })
+            }
+        }
+    };
+}
+
+display_for_newtype!(XfsScrubType, {
+    XFS_SCRUB_TYPE_PROBE      => M_("probe"),
+    XFS_SCRUB_TYPE_SB         => M_("sb"),
+    XFS_SCRUB_TYPE_AGF        => M_("agf"),
+    XFS_SCRUB_TYPE_AGFL       => M_("agfl"),
+    XFS_SCRUB_TYPE_AGI        => M_("agi"),
+    XFS_SCRUB_TYPE_BNOBT      => M_("bnobt"),
+    XFS_SCRUB_TYPE_CNTBT      => M_("cntbt"),
+    XFS_SCRUB_TYPE_INOBT      => M_("inobt"),
+    XFS_SCRUB_TYPE_FINOBT     => M_("finobt"),
+    XFS_SCRUB_TYPE_RMAPBT     => M_("rmapbt"),
+    XFS_SCRUB_TYPE_REFCNTBT   => M_("refcountbt"),
+    XFS_SCRUB_TYPE_INODE      => M_("inode"),
+    XFS_SCRUB_TYPE_BMBTD      => M_("bmapbtd"),
+    XFS_SCRUB_TYPE_BMBTA      => M_("bmapbta"),
+    XFS_SCRUB_TYPE_BMBTC      => M_("bmapbtc"),
+    XFS_SCRUB_TYPE_DIR        => M_("directory"),
+    XFS_SCRUB_TYPE_XATTR      => M_("xattr"),
+    XFS_SCRUB_TYPE_SYMLINK    => M_("symlink"),
+    XFS_SCRUB_TYPE_PARENT     => M_("parent"),
+    XFS_SCRUB_TYPE_RTBITMAP   => M_("rtbitmap"),
+    XFS_SCRUB_TYPE_RTSUM      => M_("rtsummary"),
+    XFS_SCRUB_TYPE_UQUOTA     => M_("usrquota"),
+    XFS_SCRUB_TYPE_GQUOTA     => M_("grpquota"),
+    XFS_SCRUB_TYPE_PQUOTA     => M_("prjquota"),
+    XFS_SCRUB_TYPE_FSCOUNTERS => M_("fscounters"),
+    XFS_SCRUB_TYPE_QUOTACHECK => M_("quotacheck"),
+    XFS_SCRUB_TYPE_NLINKS     => M_("nlinks"),
+    XFS_SCRUB_TYPE_HEALTHY    => M_("healthy"),
+    XFS_SCRUB_TYPE_DIRTREE    => M_("dirtree"),
+    XFS_SCRUB_TYPE_METAPATH   => M_("metapath"),
+});
+
+/// Information about a repair
+pub struct Repair {
+    /// Actual details of the repair
+    detail: xfs_scrub_metadata,
+
+    /// What group does this belong to?
+    group: RepairGroup,
+
+    /// What scrub type did we actually pick?
+    scrub_type: XfsScrubType,
+
+    /// What happened when repairs were tried?
+    outcome: RepairOutcome,
+}
+
+impl Repair {
+    /// Schedule a full-filesystem metadata repair
+    pub fn from_whole_fs(t: XfsScrubType) -> Repair {
+        Repair {
+            group: RepairGroup::WholeFs,
+            detail: xfs_scrub_metadata {
+                sm_type: t.0,
+                sm_flags: xfs_fs::XFS_SCRUB_IFLAG_REPAIR,
+                ..Default::default()
+            },
+            outcome: RepairOutcome::Queued,
+            scrub_type: t,
+        }
+    }
+
+    /// Schedule a per-AG repair
+    pub fn from_perag(t: XfsScrubType, group: XfsAgNumber) -> Repair {
+        Repair {
+            group: RepairGroup::PerAg,
+            detail: xfs_scrub_metadata {
+                sm_type: t.0,
+                sm_flags: xfs_fs::XFS_SCRUB_IFLAG_REPAIR,
+                sm_agno: group.into(),
+                ..Default::default()
+            },
+            outcome: RepairOutcome::Queued,
+            scrub_type: t,
+        }
+    }
+
+    /// Schedule a rtgroup repair
+    pub fn from_rtgroup(t: XfsScrubType, group: XfsRgNumber) -> Repair {
+        Repair {
+            group: RepairGroup::RtGroup,
+            detail: xfs_scrub_metadata {
+                sm_type: t.0,
+                sm_flags: xfs_fs::XFS_SCRUB_IFLAG_REPAIR,
+                sm_agno: group.into(),
+                ..Default::default()
+            },
+            outcome: RepairOutcome::Queued,
+            scrub_type: t,
+        }
+    }
+
+    /// Schedule a file metadata repair
+    pub fn from_file(t: XfsScrubType, fid: XfsFid) -> Repair {
+        Repair {
+            group: RepairGroup::File,
+            detail: xfs_scrub_metadata {
+                sm_type: t.0,
+                sm_flags: xfs_fs::XFS_SCRUB_IFLAG_REPAIR,
+                sm_ino: fid.ino.into(),
+                sm_gen: fid.gen.into(),
+                ..Default::default()
+            },
+            outcome: RepairOutcome::Queued,
+            scrub_type: t,
+        }
+    }
+
+    /// Decode what happened when we tried to repair
+    fn outcome(detail: &xfs_scrub_metadata) -> RepairOutcome {
+        const REPAIR_FAILED: u32 =
+            xfs_fs::XFS_SCRUB_OFLAG_CORRUPT | xfs_fs::XFS_SCRUB_OFLAG_INCOMPLETE;
+
+        if detail.sm_flags & REPAIR_FAILED != 0 {
+            RepairOutcome::Failed
+        } else if detail.sm_flags & xfs_fs::XFS_SCRUB_OFLAG_XFAIL != 0 {
+            RepairOutcome::MightBeOk
+        } else if detail.sm_flags & xfs_fs::XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED != 0 {
+            RepairOutcome::Unnecessary
+        } else {
+            RepairOutcome::Success
+        }
+    }
+
+    /// Summarize this repair for reporting
+    fn summary(&self) -> String {
+        match self.group {
+            RepairGroup::WholeFs => {
+                format!("{} {}", M_("Repair of"), self.scrub_type)
+            }
+            RepairGroup::PerAg => {
+                let agno: XfsAgNumber = self.detail.into();
+
+                format!("{} {} {}", M_("Repair of"), agno, self.scrub_type)
+            }
+            RepairGroup::RtGroup => {
+                let rgno: XfsRgNumber = self.detail.into();
+
+                format!("{} {} {}", M_("Repair of"), rgno, self.scrub_type)
+            }
+            RepairGroup::File => {
+                let fid: XfsFid = self.detail.into();
+
+                format!("{} {} {}", M_("Repair of"), fid, self.scrub_type)
+            }
+        }
+    }
+
+    /// Call the kernel to repair things
+    fn repair(&mut self, fh: &WeakHandle) -> Result<bool> {
+        let fp = fh
+            .reopen()
+            .with_context(|| M_("Reopening filesystem to repair metadata"))?;
+
+        // SAFETY: Trusting the kernel not to corrupt memory.
+        unsafe {
+            xfs_ioc_scrub_metadata(fp.as_raw_fd(), &mut self.detail)
+                .with_context(|| self.summary().to_string())?;
+        }
+
+        self.outcome = Repair::outcome(&self.detail);
+        Ok(true)
+    }
+
+    /// Try to repair something, or log whatever went wrong
+    pub fn perform(&mut self, fh: &WeakHandle) {
+        match self.repair(fh) {
+            Err(e) => {
+                eprintln!("{}: {:#}", fh.mountpoint(), e);
+            }
+            _ => {
+                printlogln!("{}: {}: {}", fh.mountpoint(), self.summary(), self.outcome);
+            }
+        };
+    }
+}
diff --git a/healer/src/weakhandle.rs b/healer/src/weakhandle.rs
index f532c530d4ff5e..ccac5d86d3be41 100644
--- a/healer/src/weakhandle.rs
+++ b/healer/src/weakhandle.rs
@@ -10,6 +10,8 @@ use crate::xfsprogs::M_;
 use anyhow::{Error, Result};
 use nix::ioctl_readwrite;
 use nix::libc::O_LARGEFILE;
+use std::fmt::Display;
+use std::fmt::Formatter;
 use std::fs::File;
 use std::io::ErrorKind;
 use std::os::fd::AsRawFd;
@@ -91,6 +93,11 @@ impl WeakHandle<'_> {
         Ok(fp)
     }
 
+    /// Report mountpoint in a displayable manner
+    pub fn mountpoint(&self) -> String {
+        self.mountpoint.display().to_string()
+    }
+
     /// Create a soft handle from an open file descriptor and its mount point
     pub fn try_new<'a>(fp: &File, mountpoint: &'a Path) -> Result<WeakHandle<'a>> {
         Ok(WeakHandle {
@@ -99,3 +106,9 @@ impl WeakHandle<'_> {
         })
     }
 }
+
+impl Display for WeakHandle<'_> {
+    fn fmt(&self, f: &mut Formatter) -> std::fmt::Result {
+        write!(f, "{}", self.mountpoint.display())
+    }
+}
diff --git a/healer/src/xfs_types.rs b/healer/src/xfs_types.rs
index 37ca1b3e5a3cc0..fee284b93264f5 100644
--- a/healer/src/xfs_types.rs
+++ b/healer/src/xfs_types.rs
@@ -5,6 +5,7 @@
  */
 use crate::baddata;
 use crate::display_for_enum;
+use crate::xfs_fs::xfs_scrub_metadata;
 use crate::xfsprogs::M_;
 use anyhow::{Error, Result};
 use std::fmt::Display;
@@ -12,7 +13,7 @@ use std::fmt::Formatter;
 use strum_macros::EnumString;
 
 /// Allocation group number on the data device
-#[derive(Debug)]
+#[derive(Debug, Copy, Clone)]
 pub struct XfsAgNumber(u32);
 
 impl TryFrom<u64> for XfsAgNumber {
@@ -33,8 +34,20 @@ impl Display for XfsAgNumber {
     }
 }
 
+impl From<XfsAgNumber> for u32 {
+    fn from(val: XfsAgNumber) -> Self {
+        val.0
+    }
+}
+
+impl From<xfs_scrub_metadata> for XfsAgNumber {
+    fn from(val: xfs_scrub_metadata) -> Self {
+        XfsAgNumber(val.sm_agno)
+    }
+}
+
 /// Realtime group number on the realtime device
-#[derive(Debug)]
+#[derive(Debug, Copy, Clone)]
 pub struct XfsRgNumber(u32);
 
 impl Display for XfsRgNumber {
@@ -55,6 +68,18 @@ impl TryFrom<u64> for XfsRgNumber {
     }
 }
 
+impl From<XfsRgNumber> for u32 {
+    fn from(val: XfsRgNumber) -> Self {
+        val.0
+    }
+}
+
+impl From<xfs_scrub_metadata> for XfsRgNumber {
+    fn from(val: xfs_scrub_metadata) -> Self {
+        XfsRgNumber(val.sm_agno)
+    }
+}
+
 /// Disk devices
 #[derive(Debug, EnumString)]
 pub enum XfsDevice {
@@ -126,7 +151,7 @@ impl Display for XfsPhysRange {
 }
 
 /// Inode number
-#[derive(Debug)]
+#[derive(Debug, Copy, Clone)]
 pub struct XfsIno(u64);
 
 impl Display for XfsIno {
@@ -147,8 +172,14 @@ impl TryFrom<u64> for XfsIno {
     }
 }
 
+impl From<XfsIno> for u64 {
+    fn from(val: XfsIno) -> Self {
+        val.0
+    }
+}
+
 /// Inode generation number
-#[derive(Debug)]
+#[derive(Debug, Copy, Clone)]
 pub struct XfsIgeneration(u32);
 
 impl Display for XfsIgeneration {
@@ -169,8 +200,14 @@ impl TryFrom<u64> for XfsIgeneration {
     }
 }
 
+impl From<XfsIgeneration> for u32 {
+    fn from(val: XfsIgeneration) -> Self {
+        val.0
+    }
+}
+
 /// Miniature FID for a handle
-#[derive(Debug)]
+#[derive(Debug, Copy, Clone)]
 pub struct XfsFid {
     /// Inode number
     pub ino: XfsIno,
@@ -185,6 +222,15 @@ impl Display for XfsFid {
     }
 }
 
+impl From<xfs_scrub_metadata> for XfsFid {
+    fn from(val: xfs_scrub_metadata) -> Self {
+        XfsFid {
+            ino: XfsIno(val.sm_ino),
+            gen: XfsIgeneration(val.sm_gen),
+        }
+    }
+}
+
 /// File position
 #[derive(Debug)]
 pub struct XfsPos(u64);

