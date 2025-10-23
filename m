Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DA3A95E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178419; cv=none; b=SODaIxCJV9gbYBtHaaCqkYJT8QfdUw2wPaun3JRrZ486zj8kmXUOj+N+NjUKhTA6cKwXYQ4xJzibmEMHrHtVZPbvTJq8aUtS2+coFqJIR30R5ycSYFM7zYnt7XjcuA8wtpoF4VUe9ZjfHeHa6F1AC0eL+dbvlgg1s1FqfyVbcvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178419; c=relaxed/simple;
	bh=aH5nJkvSGbw9c8e0QaAYO48hbK3WrLWaocpOKyItGZg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLQ9bBfJbCFgiM2KO52GL5t6FNUdxjI0FeFI1xs/AR3iAld8ALAfQPfR+rJuJQ6R9+MwF3BWKKUa0uah5UEXGsmunSbGryA5igxzRgzzh3rrKAkTFARjPdc4141hRCZf/oEai6TTLLNH2D6SFEm4R7x1ivxWHqgzQgRepqjPS3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/iDuWm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/iDuWm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E99C4CEE7;
	Thu, 23 Oct 2025 00:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178419;
	bh=aH5nJkvSGbw9c8e0QaAYO48hbK3WrLWaocpOKyItGZg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A/iDuWm7M32MB8+Lz9VvFmG/8AtnWYMmVLqCNOfANOQj+Vt81pkkAVd+xtHK1az8g
	 PuaRm0SK8uCeDIrSTkvdvOgxOx63ryJNmEo50ZcSlawJmjauU85NLWKfjTmMV2g29G
	 yn8TJk7hQlTBK6YZ83uaNy4lqr4hqhKpPZSoIQ0YL8HYQSHs/5NyiBUR/mUsG+iBkN
	 fD8rqeXvOc59+G4aN59h5eUq7VsREpal+O7adC1fl5V0lhs24hCQ8LXuiLPXcOJC34
	 0iNyC1s2RVkWW4hn5NgO/eZp5rspSVlOLc8EMLvccivcZBg29Zx3pS+lhj6cGhac9l
	 E4qcjHulP/j6w==
Date: Wed, 22 Oct 2025 17:13:38 -0700
Subject: [PATCH 05/19] xfs_healer: read binary health events from the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748350.1029045.9165184740390705872.stgit@frogsfrogsfrogs>
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

Decode binary health events objects read from the kernel into the
corresponding Rust objects so that we can deal with the events.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile                 |    1 
 healer/src/healthmon/cstruct.rs |  343 +++++++++++++++++++++++++++++++++++++++
 healer/src/healthmon/mod.rs     |    1 
 healer/src/main.rs              |   25 +++
 4 files changed, 369 insertions(+), 1 deletion(-)
 create mode 100644 healer/src/healthmon/cstruct.rs


diff --git a/healer/Makefile b/healer/Makefile
index 5df3ca105e143a..c40663bcc79075 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -23,6 +23,7 @@ RUSTFILES = \
 	src/xfs_fs.rs \
 	src/xfsprogs.rs \
 	src/xfs_types.rs \
+	src/healthmon/cstruct.rs \
 	src/healthmon/event.rs \
 	src/healthmon/fs.rs \
 	src/healthmon/groups.rs \
diff --git a/healer/src/healthmon/cstruct.rs b/healer/src/healthmon/cstruct.rs
new file mode 100644
index 00000000000000..58463b0f6fa5b9
--- /dev/null
+++ b/healer/src/healthmon/cstruct.rs
@@ -0,0 +1,343 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+use crate::baddata;
+use crate::healthmon::event::LostEvent;
+use crate::healthmon::event::RunningEvent;
+use crate::healthmon::event::UnknownEvent;
+use crate::healthmon::event::XfsHealthEvent;
+use crate::healthmon::event::XfsHealthStatus;
+use crate::healthmon::fs::XfsMediaErrorEvent;
+use crate::healthmon::fs::XfsUnmountEvent;
+use crate::healthmon::fs::{XfsShutdownEvent, XfsShutdownReason};
+use crate::healthmon::fs::{XfsWholeFsEvent, XfsWholeFsMetadata};
+use crate::healthmon::groups::{XfsPeragEvent, XfsPeragMetadata};
+use crate::healthmon::groups::{XfsRtgroupEvent, XfsRtgroupMetadata};
+use crate::healthmon::inodes::{XfsFileIoErrorEvent, XfsFileIoErrorType};
+use crate::healthmon::inodes::{XfsInodeEvent, XfsInodeMetadata};
+use crate::healthmon::xfs_ioc_health_monitor;
+use crate::xfs_fs;
+use crate::xfs_fs::xfs_health_monitor;
+use crate::xfs_fs::xfs_health_monitor_event;
+use crate::xfs_types::{XfsAgNumber, XfsRgNumber};
+use crate::xfs_types::{XfsDevice, XfsPhysRange};
+use crate::xfs_types::{XfsFid, XfsFileRange, XfsIgeneration, XfsIno, XfsIoLen, XfsPos};
+use crate::xfsprogs::M_;
+use anyhow::{Context, Result};
+use std::fs::File;
+use std::io::BufReader;
+use std::io::ErrorKind;
+use std::io::Read;
+use std::os::fd::AsRawFd;
+use std::os::fd::FromRawFd;
+use std::path::Path;
+
+/// Boilerplate to stamp out functions to convert a u32 mask to an enumset
+/// of the given enum type.
+macro_rules! enum_set_from_mask {
+    ($enum_type:ty , $err_msg:expr , { $($a:ident => $b:ident,)+ } ) => {
+        impl $enum_type {
+            /// Convert from a bitmask to a set of enum
+            pub fn from_mask(mask: u32) -> std::io::Result<enumset::EnumSet<$enum_type>> {
+                let mut ret = enumset::EnumSet::new();
+                let badmask = 0 |
+                $($crate::xfs_fs::$a | )+
+                0;
+                if mask & !badmask != 0 { return Err(baddata!($err_msg, $enum_type, mask)); }
+                $(if mask & $crate::xfs_fs::$a != 0 { ret |= <$enum_type>::$b; })+
+                Ok(ret)
+            }
+        }
+    };
+}
+
+/// Boilerplate to stamp out functions to convert a u32 field to the given enum
+/// type.
+macro_rules! enum_from_field {
+    ($enum_type:ty , { $($a:ident => $b:ident,)+ } ) => {
+        impl $enum_type {
+            /// Convert from a u32 field to an enum
+            pub fn from_value(value: u32) -> std::io::Result<$enum_type> {
+                $(if value == $crate::xfs_fs::$a { return Ok(<$enum_type>::$b); })+
+                Err(baddata!($crate::xfsprogs::M_("Unknown value"), $enum_type, value))
+            }
+        }
+    };
+}
+
+/// Iterator object that returns health events in binary
+pub struct CStructMonitor<'a> {
+    /// health monitor fd
+    objiter: BufReader<File>,
+
+    /// path to the filesystem mountpoint
+    mountpoint: &'a Path,
+}
+
+impl CStructMonitor<'_> {
+    /// Open a health monitor for an open file on an XFS filesystem
+    pub fn try_new(fp: File, mountpoint: &Path, everything: bool) -> Result<CStructMonitor> {
+        let mut hminfo = xfs_health_monitor {
+            format: xfs_fs::XFS_HEALTH_MONITOR_FMT_CSTRUCT as u8,
+            ..Default::default()
+        };
+
+        if everything {
+            hminfo.flags |= xfs_fs::XFS_HEALTH_MONITOR_VERBOSE as u64;
+        }
+
+        // SAFETY: Trusting the kernel ioctl not to corrupt stack contents, and to return us a valid
+        // file description number.
+        let health_fp = unsafe {
+            let health_fd = xfs_ioc_health_monitor(fp.as_raw_fd(), &hminfo)?;
+            File::from_raw_fd(health_fd)
+        };
+        drop(fp);
+
+        Ok(CStructMonitor {
+            objiter: BufReader::new(health_fp),
+            mountpoint,
+        })
+    }
+}
+
+enum_from_field!(XfsHealthStatus, {
+    XFS_HEALTH_MONITOR_TYPE_SICK    => Sick,
+    XFS_HEALTH_MONITOR_TYPE_CORRUPT => Corrupt,
+    XFS_HEALTH_MONITOR_TYPE_HEALTHY => Healthy,
+});
+
+enum_set_from_mask!(XfsPeragMetadata, M_("Unknown per-AG metadata"), {
+    XFS_AG_GEOM_SICK_AGF      => Agf,
+    XFS_AG_GEOM_SICK_AGFL     => Agfl,
+    XFS_AG_GEOM_SICK_AGI      => Agi,
+    XFS_AG_GEOM_SICK_BNOBT    => Bnobt,
+    XFS_AG_GEOM_SICK_CNTBT    => Cntbt,
+    XFS_AG_GEOM_SICK_FINOBT   => Finobt,
+    XFS_AG_GEOM_SICK_INOBT    => Inobt,
+    XFS_AG_GEOM_SICK_INODES   => Inodes,
+    XFS_AG_GEOM_SICK_REFCNTBT => Refcountbt,
+    XFS_AG_GEOM_SICK_RMAPBT   => Rmapbt,
+    XFS_AG_GEOM_SICK_SB       => Super,
+});
+
+/// Create a per-AG health event from C structure
+fn perag_event_from_cstruct(v: xfs_health_monitor_event) -> Result<Box<dyn XfsHealthEvent>> {
+    // SAFETY: Union access checked by caller
+    let ge = unsafe { v.e.group };
+
+    Ok(Box::new(XfsPeragEvent::new(
+        XfsAgNumber::try_from(ge.gno as u64).with_context(|| M_("Reading per-AG event"))?,
+        XfsPeragMetadata::from_mask(ge.mask).with_context(|| M_("Reading per-AG event"))?,
+        XfsHealthStatus::from_value(v.type_).with_context(|| M_("Reading per-AG event"))?,
+    )))
+}
+
+/// Create a rtgroup health event from C structure
+fn rtgroup_event_from_cstruct(v: xfs_health_monitor_event) -> Result<Box<dyn XfsHealthEvent>> {
+    // SAFETY: Union access checked by caller
+    let ge = unsafe { v.e.group };
+
+    Ok(Box::new(XfsRtgroupEvent::new(
+        XfsRgNumber::try_from(ge.gno as u64).with_context(|| M_("Reading rtgroup event"))?,
+        XfsRtgroupMetadata::from_mask(ge.mask).with_context(|| M_("Reading rtgroup event"))?,
+        XfsHealthStatus::from_value(v.type_).with_context(|| M_("Reading rtgroup event"))?,
+    )))
+}
+
+enum_set_from_mask!(XfsRtgroupMetadata, M_("Unknown rtgroup metadata"), {
+    XFS_RTGROUP_GEOM_SICK_BITMAP   => Bitmap,
+    XFS_RTGROUP_GEOM_SICK_SUMMARY  => Summary,
+    XFS_RTGROUP_GEOM_SICK_REFCNTBT => Refcountbt,
+    XFS_RTGROUP_GEOM_SICK_RMAPBT   => Rmapbt,
+    XFS_RTGROUP_GEOM_SICK_SUPER    => Super,
+});
+
+enum_set_from_mask!(XfsInodeMetadata, M_("Unknown inode metadata"), {
+    XFS_BS_SICK_BMBTA          => Bmapbta,
+    XFS_BS_SICK_BMBTC          => Bmapbtc,
+    XFS_BS_SICK_BMBTD          => Bmapbtd,
+    XFS_BS_SICK_INODE          => Core,
+    XFS_BS_SICK_DIR            => Directory,
+    XFS_BS_SICK_DIRTREE        => Dirtree,
+    XFS_BS_SICK_PARENT         => Parent,
+    XFS_BS_SICK_SYMLINK        => Symlink,
+    XFS_BS_SICK_XATTR          => Xattr,
+});
+
+/// Create an inode health event from C structure
+fn inode_event_from_cstruct(v: xfs_health_monitor_event) -> Result<Box<dyn XfsHealthEvent>> {
+    // SAFETY: Union access checked by caller
+    let ie = unsafe { v.e.inode };
+
+    Ok(Box::new(XfsInodeEvent::new(
+        XfsFid {
+            ino: XfsIno::try_from(ie.ino).with_context(|| M_("Reading inode event"))?,
+            gen: XfsIgeneration::try_from(ie.gen as u64)
+                .with_context(|| M_("Reading inode event"))?,
+        },
+        XfsInodeMetadata::from_mask(ie.mask).with_context(|| M_("Reading inode event"))?,
+        XfsHealthStatus::from_value(v.type_).with_context(|| M_("Reading inode event"))?,
+    )))
+}
+
+enum_from_field!(XfsFileIoErrorType, {
+    XFS_HEALTH_MONITOR_TYPE_BUFREAD  => Readahead,
+    XFS_HEALTH_MONITOR_TYPE_BUFWRITE => Writeback,
+    XFS_HEALTH_MONITOR_TYPE_DIOREAD  => DirectioRead,
+    XFS_HEALTH_MONITOR_TYPE_DIOWRITE => DirectioWrite,
+});
+
+/// Create a file I/O error event from a C struct
+fn file_io_error_event_from_cstruct(
+    v: xfs_health_monitor_event,
+) -> Result<Box<dyn XfsHealthEvent>> {
+    // SAFETY: Union access checked by caller
+    let fe = unsafe { v.e.filerange };
+
+    Ok(Box::new(XfsFileIoErrorEvent::new(
+        XfsFileIoErrorType::from_value(v.type_).with_context(|| M_("Reading file I/O event"))?,
+        XfsFid {
+            ino: XfsIno::try_from(fe.ino).with_context(|| M_("Reading file I/O event"))?,
+            gen: XfsIgeneration::try_from(fe.gen as u64)
+                .with_context(|| M_("Reading file I/O event"))?,
+        },
+        XfsFileRange {
+            pos: XfsPos::try_from(fe.pos).with_context(|| M_("Reading file I/O event"))?,
+            len: XfsIoLen::try_from(fe.len).with_context(|| M_("Reading file I/O event"))?,
+        },
+    )))
+}
+
+enum_set_from_mask!(XfsWholeFsMetadata, M_("Unknown whole-fs metadata"), {
+    XFS_FSOP_GEOM_SICK_COUNTERS   => FsCounters,
+    XFS_FSOP_GEOM_SICK_GQUOTA     => GrpQuota,
+    XFS_FSOP_GEOM_SICK_NLINKS     => NLinks,
+    XFS_FSOP_GEOM_SICK_PQUOTA     => PrjQuota,
+    XFS_FSOP_GEOM_SICK_QUOTACHECK => QuotaCheck,
+    XFS_FSOP_GEOM_SICK_UQUOTA     => UsrQuota,
+    XFS_FSOP_GEOM_SICK_METADIR    => MetaDir,
+    XFS_FSOP_GEOM_SICK_METAPATH   => MetaPath,
+});
+
+/// Create an whole-fs health event from a C struct
+fn wholefs_event_from_cstruct(v: xfs_health_monitor_event) -> Result<Box<dyn XfsHealthEvent>> {
+    // SAFETY: Union access checked by caller
+    let fe = unsafe { v.e.fs };
+
+    Ok(Box::new(XfsWholeFsEvent::new(
+        XfsWholeFsMetadata::from_mask(fe.mask).with_context(|| M_("Reading whole-fs event"))?,
+        XfsHealthStatus::from_value(v.type_).with_context(|| M_("Reading whole-fs event"))?,
+    )))
+}
+
+enum_set_from_mask!(XfsShutdownReason, M_("Unknown fs shutdown reason"), {
+    XFS_HEALTH_SHUTDOWN_META_IO_ERROR  => MetaIoerr,
+    XFS_HEALTH_SHUTDOWN_LOG_IO_ERROR   => LogIoerr,
+    XFS_HEALTH_SHUTDOWN_FORCE_UMOUNT   => ForceUmount,
+    XFS_HEALTH_SHUTDOWN_CORRUPT_INCORE => CorruptIncore,
+    XFS_HEALTH_SHUTDOWN_CORRUPT_ONDISK => CorruptOndisk,
+    XFS_HEALTH_SHUTDOWN_DEVICE_REMOVED => DeviceRemoved,
+});
+
+/// Create an shutdown event from a C struct
+fn shutdown_event_from_cstruct(v: xfs_health_monitor_event) -> Result<Box<dyn XfsHealthEvent>> {
+    // SAFETY: Union access checked by caller
+    let se = unsafe { v.e.shutdown };
+
+    Ok(Box::new(XfsShutdownEvent::new(
+        XfsShutdownReason::from_mask(se.reasons)
+            .with_context(|| M_("Reading fs shutdown event"))?,
+    )))
+}
+
+enum_from_field!(XfsDevice, {
+    XFS_HEALTH_MONITOR_DOMAIN_DATADEV => Data,
+    XFS_HEALTH_MONITOR_DOMAIN_RTDEV   => Realtime,
+    XFS_HEALTH_MONITOR_DOMAIN_LOGDEV  => Log,
+});
+
+/// Create a media error event from a C struct
+fn media_error_event_from_cstruct(v: xfs_health_monitor_event) -> Result<Box<dyn XfsHealthEvent>> {
+    // SAFETY: Union access checked by caller
+    let me = unsafe { v.e.media };
+
+    Ok(Box::new(XfsMediaErrorEvent::new(XfsPhysRange {
+        device: XfsDevice::from_value(v.domain).with_context(|| M_("Reading media error event"))?,
+        daddr: me.daddr.into(),
+        bbcount: me.bbcount.into(),
+    })))
+}
+
+/// Create event for the kernel telling us that it lost an event
+fn lost_event_from_cstruct(v: xfs_health_monitor_event) -> Result<Box<dyn XfsHealthEvent>> {
+    // SAFETY: Union access checked by caller
+    let le = unsafe { v.e.lost };
+
+    Ok(Box::new(LostEvent::new(le.count)))
+}
+
+impl xfs_health_monitor_event {
+    /// Return an event object that can react to a health event.
+    pub fn cook(self) -> Result<Box<dyn XfsHealthEvent>> {
+        match self.domain {
+            xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_RTGROUP => rtgroup_event_from_cstruct(self),
+
+            xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_AG => perag_event_from_cstruct(self),
+
+            xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_INODE => inode_event_from_cstruct(self),
+
+            xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_FS => wholefs_event_from_cstruct(self),
+
+            xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_MOUNT => match self.type_ {
+                xfs_fs::XFS_HEALTH_MONITOR_TYPE_LOST => lost_event_from_cstruct(self),
+
+                xfs_fs::XFS_HEALTH_MONITOR_TYPE_SHUTDOWN => shutdown_event_from_cstruct(self),
+
+                xfs_fs::XFS_HEALTH_MONITOR_TYPE_UNMOUNT => Ok(Box::new(XfsUnmountEvent {})),
+
+                xfs_fs::XFS_HEALTH_MONITOR_TYPE_RUNNING => Ok(Box::new(RunningEvent {})),
+
+                _ => Ok(Box::new(UnknownEvent {})),
+            },
+
+            xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_DATADEV
+            | xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_LOGDEV
+            | xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_RTDEV => media_error_event_from_cstruct(self),
+
+            xfs_fs::XFS_HEALTH_MONITOR_DOMAIN_FILERANGE => file_io_error_event_from_cstruct(self),
+
+            _ => Ok(Box::new(UnknownEvent {})),
+        }
+    }
+}
+
+impl Iterator for CStructMonitor<'_> {
+    type Item = xfs_health_monitor_event;
+
+    /// Return health monitoring events
+    fn next(&mut self) -> Option<Self::Item> {
+        let sz = std::mem::size_of::<xfs_health_monitor_event>();
+        let mut buf: Vec<u8> = vec![0; sz];
+        if let Err(e) = self.objiter.read_exact(&mut buf) {
+            if e.kind() != ErrorKind::UnexpectedEof {
+                eprintln!(
+                    "{}: {}: {:#}",
+                    self.mountpoint.display(),
+                    M_("Reading event blob"),
+                    e
+                );
+            }
+            return None;
+        };
+
+        let hme: *const xfs_health_monitor_event = buf.as_ptr() as *const xfs_health_monitor_event;
+
+        // SAFETY: Copying from a Vec that we sized to fit one xfs_health_monitor_event into an
+        // object of that type.
+        let ret: xfs_health_monitor_event = unsafe { *hme };
+        Some(ret)
+    }
+}
diff --git a/healer/src/healthmon/mod.rs b/healer/src/healthmon/mod.rs
index a22248398a53a7..ebafd767452349 100644
--- a/healer/src/healthmon/mod.rs
+++ b/healer/src/healthmon/mod.rs
@@ -6,6 +6,7 @@
 use crate::xfs_fs::xfs_health_monitor;
 use nix::ioctl_write_ptr;
 
+pub mod cstruct;
 pub mod event;
 pub mod fs;
 pub mod groups;
diff --git a/healer/src/main.rs b/healer/src/main.rs
index 3908dcd23922da..3d4d91b17708dd 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -8,6 +8,8 @@ use clap::{value_parser, Arg, ArgAction, ArgMatches, Command};
 use std::fs::File;
 use std::path::PathBuf;
 use std::process::ExitCode;
+use xfs_healer::healthmon::cstruct::CStructMonitor;
+use xfs_healer::healthmon::event::XfsHealthEvent;
 use xfs_healer::printlogln;
 use xfs_healer::xfsprogs;
 use xfs_healer::xfsprogs::M_;
@@ -70,9 +72,30 @@ impl App {
         self.path.display().to_string()
     }
 
+    /// Handle a health event that has been decoded into real objects
+    fn process_event(&self, cooked: Result<Box<dyn XfsHealthEvent>>) {
+        match cooked {
+            Err(e) => {
+                eprintln!("{}: {:#}", self.path.display(), e)
+            }
+            Ok(event) => {
+                if self.log || event.must_log() {
+                    printlogln!("{}: {}", self.path.display(), event.format());
+                }
+            }
+        }
+    }
+
     /// Main app method
     fn main(&self) -> Result<ExitCode> {
-        let _fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
+        let fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
+
+        let hmon = CStructMonitor::try_new(fp, &self.path, self.everything)
+            .with_context(|| M_("Opening health monitor file"))?;
+
+        for raw_event in hmon {
+            self.process_event(raw_event.cook());
+        }
 
         Ok(ExitCode::SUCCESS)
     }

