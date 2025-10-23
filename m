Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A8279F2
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178435; cv=none; b=j+6edsGdkKCtdtU/9u++tbXLffj4HsixLwxnSEO4Uhw4i7u5aPhd57OAAtLOTqQg5ZugSvYz2dUZVqs//5blRe2aYHcjiy6U/DdsUefw5lRY3csyvDxQyWiv5aKqFqgAmx/+rbhZs8Y5303OiQUXs33sKxpW5xwhpcPAuj3yhyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178435; c=relaxed/simple;
	bh=W2w6MmrncN0JZxADd8j2EXtpwMitsPSGpy/+GI1y2QQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JLzgEDpHEbFxbA5Od686XZ6Y8tc2nHvm+i0XEaWCv0uXX4ZFoDTH4EiFySI+mYCeINGIhE746IQFZliJzwQ2RodDdHD66I7bogDAU47W7xIlUFMgY09r5m/Tj6fA1NcOIp5B9sVD4+w6oF5qovnz4QOl2j4TKdAj5nObDe7OVR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sSJTOsLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sSJTOsLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEFCC4CEE7;
	Thu, 23 Oct 2025 00:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178434;
	bh=W2w6MmrncN0JZxADd8j2EXtpwMitsPSGpy/+GI1y2QQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sSJTOsLlhX88WmmXD8egHvCd+Hj/j9ACFBhsbIaSS6WJiN+RNpIi5y3TN3Wb4fXRH
	 jOI3fPCbov1g8nl0rtL/nKyhlImM9zY7JWjxoXLrwYhZ8/hazYHAMCwFAgC61+unrb
	 iloMmOwaVy1EFDfRDuCiRq7Sx9RbTiaUWgGYa02Rla9TD/L0nWQtHCp4U+6PKYB+Tq
	 b55tdFQuLSOcytlJE1BDutf/yooyG2wANfRx+cl21oKRLRvdgJXOAaofCQKsKEE9F2
	 0zNfbj5LjnTZVMCh7L2tBIkf2smtThWF1tLxVUhcruzBRpe8ZrErGf6wt5ctDoNham
	 sFKVTARWzk+5A==
Date: Wed, 22 Oct 2025 17:13:54 -0700
Subject: [PATCH 06/19] xfs_healer: read json health events from the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748369.1029045.4206482226785383860.stgit@frogsfrogsfrogs>
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

The kernel can give us filesystem health events in json, so let's use
the json deserializer to turn them into Rust associative arrays and
return them from our iterator.  This isn't totally necessary since we
have the C structure variant, but it'll help us test the other
interface.  Note that we use a fair amount of EnumString magic to
automatically provide translators for the json.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Cargo.toml.in           |    3 
 healer/Makefile                |    1 
 healer/src/healthmon/event.rs  |    4 
 healer/src/healthmon/fs.rs     |    7 +
 healer/src/healthmon/groups.rs |    7 +
 healer/src/healthmon/inodes.rs |    7 +
 healer/src/healthmon/json.rs   |  398 ++++++++++++++++++++++++++++++++++++++++
 healer/src/healthmon/mod.rs    |    1 
 healer/src/main.rs             |   26 ++-
 healer/src/xfs_types.rs        |    8 +
 m4/package_rust.m4             |    3 
 11 files changed, 453 insertions(+), 12 deletions(-)
 create mode 100644 healer/src/healthmon/json.rs


diff --git a/healer/Cargo.toml.in b/healer/Cargo.toml.in
index 04e9df5c1a2a70..fcf7f7a6d9373b 100644
--- a/healer/Cargo.toml.in
+++ b/healer/Cargo.toml.in
@@ -17,6 +17,7 @@ lto = @cargo_lto@
 clap = { version = "4.0.32", features = ["derive"] }
 anyhow = { version = "1.0.69" }
 enumset = { version = "1.0.12" }
+serde_json = { version = "1.0.87" }
 
 # XXX: Crates with major version 0 are not considered ABI-stable, so the minor
 # version is treated as if it were the major version.  This creates problems
@@ -25,6 +26,8 @@ enumset = { version = "1.0.12" }
 # break.  Ref:
 # https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html
 nix = { version = "0", features = ["ioctl"] }	# 0.26.1
+strum = { version = "0" }			# 0.19.2
+strum_macros = { version = "0" }		# 0.19.2
 
 # Dynamically comment out all the gettextrs related dependency information in
 # Cargo.toml becuse cargo requires the crate to be present so that it can
diff --git a/healer/Makefile b/healer/Makefile
index c40663bcc79075..515238982aad24 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -28,6 +28,7 @@ RUSTFILES = \
 	src/healthmon/fs.rs \
 	src/healthmon/groups.rs \
 	src/healthmon/inodes.rs \
+	src/healthmon/json.rs \
 	src/healthmon/mod.rs
 
 BUILT_RUSTFILES = \
diff --git a/healer/src/healthmon/event.rs b/healer/src/healthmon/event.rs
index fe15156ca9e95a..b7a0effab94a3c 100644
--- a/healer/src/healthmon/event.rs
+++ b/healer/src/healthmon/event.rs
@@ -5,6 +5,7 @@
  */
 use crate::display_for_enum;
 use crate::xfsprogs::M_;
+use strum_macros::EnumString;
 
 /// Common behaviors of all health events
 pub trait XfsHealthEvent {
@@ -18,7 +19,8 @@ pub trait XfsHealthEvent {
 }
 
 /// Health status for metadata events
-#[derive(Debug)]
+#[derive(Debug, EnumString)]
+#[strum(serialize_all = "lowercase")]
 pub enum XfsHealthStatus {
     /// Problems have been observed at runtime
     Sick,
diff --git a/healer/src/healthmon/fs.rs b/healer/src/healthmon/fs.rs
index ca50683dce7f04..f216867acdf71a 100644
--- a/healer/src/healthmon/fs.rs
+++ b/healer/src/healthmon/fs.rs
@@ -11,9 +11,11 @@ use crate::xfs_types::XfsPhysRange;
 use crate::xfsprogs::M_;
 use enumset::EnumSet;
 use enumset::EnumSetType;
+use strum_macros::EnumString;
 
 /// Metadata types for an XFS whole-fs metadata
-#[derive(EnumSetType, Debug)]
+#[derive(EnumSetType, Debug, EnumString)]
+#[strum(serialize_all = "lowercase")]
 pub enum XfsWholeFsMetadata {
     FsCounters,
     GrpQuota,
@@ -65,7 +67,8 @@ impl XfsHealthEvent for XfsWholeFsEvent {
 }
 
 /// Reasons for a filesystem shutdown event
-#[derive(EnumSetType, Debug)]
+#[derive(EnumSetType, Debug, EnumString)]
+#[strum(serialize_all = "snake_case")]
 pub enum XfsShutdownReason {
     CorruptIncore,
     CorruptOndisk,
diff --git a/healer/src/healthmon/groups.rs b/healer/src/healthmon/groups.rs
index 0c3719fc5099eb..4384de50b4c63f 100644
--- a/healer/src/healthmon/groups.rs
+++ b/healer/src/healthmon/groups.rs
@@ -11,9 +11,11 @@ use crate::xfs_types::{XfsAgNumber, XfsRgNumber};
 use crate::xfsprogs::M_;
 use enumset::EnumSet;
 use enumset::EnumSetType;
+use strum_macros::EnumString;
 
 /// Metadata types for an allocation group on the data device
-#[derive(EnumSetType, Debug)]
+#[derive(EnumSetType, Debug, EnumString)]
+#[strum(serialize_all = "lowercase")]
 pub enum XfsPeragMetadata {
     Agf,
     Agfl,
@@ -82,7 +84,8 @@ impl XfsHealthEvent for XfsPeragEvent {
 }
 
 /// Metadata types for an allocation group on the realtime device
-#[derive(EnumSetType, Debug)]
+#[derive(EnumSetType, Debug, EnumString)]
+#[strum(serialize_all = "lowercase")]
 pub enum XfsRtgroupMetadata {
     Bitmap,
     Summary,
diff --git a/healer/src/healthmon/inodes.rs b/healer/src/healthmon/inodes.rs
index 5fac02a9d9cbe7..5775f9ffa69b6b 100644
--- a/healer/src/healthmon/inodes.rs
+++ b/healer/src/healthmon/inodes.rs
@@ -11,9 +11,11 @@ use crate::xfs_types::{XfsFid, XfsFileRange};
 use crate::xfsprogs::M_;
 use enumset::EnumSet;
 use enumset::EnumSetType;
+use strum_macros::EnumString;
 
 /// Metadata types for an XFS inode
-#[derive(EnumSetType, Debug)]
+#[derive(EnumSetType, Debug, EnumString)]
+#[strum(serialize_all = "lowercase")]
 pub enum XfsInodeMetadata {
     Bmapbta,
     Bmapbtc,
@@ -73,7 +75,8 @@ impl XfsHealthEvent for XfsInodeEvent {
 }
 
 /// File I/O types
-#[derive(Debug)]
+#[derive(Debug, EnumString)]
+#[strum(serialize_all = "snake_case")]
 pub enum XfsFileIoErrorType {
     Readahead,
     Writeback,
diff --git a/healer/src/healthmon/json.rs b/healer/src/healthmon/json.rs
new file mode 100644
index 00000000000000..2fae6f4b48e68b
--- /dev/null
+++ b/healer/src/healthmon/json.rs
@@ -0,0 +1,398 @@
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
+use crate::printlogln;
+use crate::xfs_fs;
+use crate::xfs_fs::xfs_health_monitor;
+use crate::xfs_types::{XfsAgNumber, XfsRgNumber};
+use crate::xfs_types::{XfsDevice, XfsPhysRange};
+use crate::xfs_types::{XfsFid, XfsFileRange, XfsIgeneration, XfsIno, XfsIoLen, XfsPos};
+use crate::xfsprogs::M_;
+use anyhow::{Context, Error, Result};
+use serde_json::from_str;
+use serde_json::Value;
+use std::fmt::Display;
+use std::fmt::Formatter;
+use std::fs::File;
+use std::io::BufRead;
+use std::io::BufReader;
+use std::io::Lines;
+use std::os::fd::AsRawFd;
+use std::os::fd::FromRawFd;
+use std::path::Path;
+use std::str::FromStr;
+
+/// Boilerplate to stamp out functions to convert json array to an enumset
+/// of the given enum type; or return an error with the given message.
+// XXX: Not sure how to make this a TryFrom on EnumSet<T>.
+macro_rules! enum_set_from_json {
+    ($enum_type:ty , $err_msg:expr) => {
+        impl $enum_type {
+            /// Convert from an array of json to a set of enum
+            pub fn try_set_from(
+                v: &serde_json::Value,
+            ) -> std::io::Result<enumset::EnumSet<$enum_type>> {
+                let array = v.as_array().ok_or(baddata!(
+                    $crate::xfsprogs::M_("Not an array"),
+                    $enum_type,
+                    v
+                ))?;
+                let mut set = enumset::EnumSet::new();
+
+                for jsvalue in array {
+                    let value = jsvalue.as_str().ok_or(baddata!(
+                        $crate::xfsprogs::M_("Not a string"),
+                        $enum_type,
+                        jsvalue
+                    ))?;
+                    set |= match <$enum_type>::from_str(value) {
+                        Ok(o) => o,
+                        Err(_) => return Err(baddata!($err_msg, $enum_type, value)),
+                    };
+                }
+                Ok(set)
+            }
+        }
+    };
+}
+
+/// Boilerplate to stamp out functions to convert json array to the given enum
+/// type; or return an error with the given message.
+macro_rules! enum_from_json {
+    ($enum_type:ty , $err_msg:expr) => {
+        impl TryFrom<&serde_json::Value> for $enum_type {
+            type Error = std::io::Error;
+
+            /// Convert from a json value to an enum
+            fn try_from(v: &serde_json::Value) -> std::io::Result<$enum_type> {
+                let value = v.as_str().ok_or(baddata!(
+                    $crate::xfsprogs::M_("Not a string"),
+                    $enum_type,
+                    v
+                ))?;
+                match <$enum_type>::from_str(value) {
+                    Ok(o) => Ok(o),
+                    Err(_) => return Err(baddata!($err_msg, $enum_type, value)),
+                }
+            }
+        }
+    };
+}
+
+/// Iterator object that returns health events in json
+pub struct JsonMonitor<'a> {
+    /// health monitor fd, but wrapped to iterate lines as they come in
+    lineiter: Lines<BufReader<File>>,
+
+    /// path to the filesystem mountpoint
+    mountpoint: &'a Path,
+
+    /// are we debugging?
+    debug: bool,
+}
+
+impl JsonMonitor<'_> {
+    /// Open a health monitor for an open file on an XFS filesystem
+    pub fn try_new(
+        fp: File,
+        mountpoint: &Path,
+        everything: bool,
+        debug: bool,
+    ) -> Result<JsonMonitor> {
+        let mut hminfo = xfs_health_monitor {
+            format: xfs_fs::XFS_HEALTH_MONITOR_FMT_JSON as u8,
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
+        Ok(JsonMonitor {
+            lineiter: BufReader::new(health_fp).lines(),
+            mountpoint,
+            debug,
+        })
+    }
+}
+
+/// Raw health event, used to create the real objects
+pub struct JsonEventWrapper(Vec<String>);
+
+impl JsonEventWrapper {
+    /// Push a string into the event string collection
+    fn push(&mut self, s: String) {
+        self.0.push(s)
+    }
+}
+
+impl TryFrom<JsonEventWrapper> for Value {
+    type Error = serde_json::Error;
+
+    /// Return a json value from this raw event
+    fn try_from(val: JsonEventWrapper) -> serde_json::Result<Self> {
+        from_str(&val.0.join(""))
+    }
+}
+
+impl TryFrom<&Value> for XfsAgNumber {
+    type Error = Error;
+
+    /// Extract group number from a json value
+    fn try_from(v: &Value) -> Result<Self> {
+        let m = v
+            .as_u64()
+            .ok_or(baddata!(M_("AG number must be integer"), Self, v))?;
+        XfsAgNumber::try_from(m)
+    }
+}
+
+enum_from_json!(XfsHealthStatus, M_("Unknown health event status"));
+
+enum_set_from_json!(XfsPeragMetadata, M_("Unknown per-AG metadata"));
+
+/// Create a per-AG health event from json
+fn perag_event_from_json(v: Value) -> Result<Box<dyn XfsHealthEvent>> {
+    Ok(Box::new(XfsPeragEvent::new(
+        XfsAgNumber::try_from(&v["group"]).with_context(|| M_("Reading per-AG event"))?,
+        XfsPeragMetadata::try_set_from(&v["structures"])
+            .with_context(|| M_("Reading per-AG event"))?,
+        XfsHealthStatus::try_from(&v["type"]).with_context(|| M_("Reading per-AG event"))?,
+    )))
+}
+
+impl TryFrom<&Value> for XfsRgNumber {
+    type Error = Error;
+
+    /// Extract group number from a json value
+    fn try_from(v: &Value) -> Result<Self> {
+        let m = v
+            .as_u64()
+            .ok_or(baddata!(M_("rtgroup number must be integer"), Self, v))?;
+        XfsRgNumber::try_from(m)
+    }
+}
+
+enum_set_from_json!(XfsRtgroupMetadata, M_("Unknown rtgroup metadata"));
+
+fn rtgroup_event_from_json(v: Value) -> Result<Box<dyn XfsHealthEvent>> {
+    Ok(Box::new(XfsRtgroupEvent::new(
+        XfsRgNumber::try_from(&v["group"]).with_context(|| M_("Reading rtgroup event"))?,
+        XfsRtgroupMetadata::try_set_from(&v["structures"])
+            .with_context(|| M_("Reading rtgroup event"))?,
+        XfsHealthStatus::try_from(&v["type"]).with_context(|| M_("Reading rtgroup event"))?,
+    )))
+}
+
+/// Convert json values to a fid
+fn to_fid(ino: &Value, gen: &Value) -> Result<XfsFid> {
+    let i = ino
+        .as_u64()
+        .ok_or(baddata!(M_("inode number must be integer"), XfsFid, ino))?;
+    let g = gen.as_u64().ok_or(baddata!(
+        M_("inode generation must be integer"),
+        XfsFid,
+        gen
+    ))?;
+
+    Ok(XfsFid {
+        ino: XfsIno::try_from(i)?,
+        gen: XfsIgeneration::try_from(g)?,
+    })
+}
+
+enum_set_from_json!(XfsInodeMetadata, M_("Unknown inode metadata"));
+
+/// Create an inode health event from json
+fn inode_event_from_json(v: Value) -> Result<Box<dyn XfsHealthEvent>> {
+    Ok(Box::new(XfsInodeEvent::new(
+        to_fid(&v["inumber"], &v["generation"]).with_context(|| M_("Reading inode event"))?,
+        XfsInodeMetadata::try_set_from(&v["structures"])
+            .with_context(|| M_("Reading inode event"))?,
+        XfsHealthStatus::try_from(&v["type"]).with_context(|| M_("Reading inode event"))?,
+    )))
+}
+
+/// Convert json values to a file range.
+fn to_range(pos: &Value, len: &Value) -> Result<XfsFileRange> {
+    let p = pos.as_u64().ok_or(baddata!(
+        M_("file position must be integer"),
+        XfsFileRange,
+        pos
+    ))?;
+    let l = len.as_u64().ok_or(baddata!(
+        M_("file length must be integer"),
+        XfsFileRange,
+        len
+    ))?;
+
+    Ok(XfsFileRange {
+        pos: XfsPos::try_from(p)?,
+        len: XfsIoLen::try_from(l)?,
+    })
+}
+
+enum_from_json!(XfsFileIoErrorType, M_("Unknown file I/O error type"));
+
+/// Create a file I/O error event from json
+pub fn file_io_error_event_from_json(v: Value) -> Result<Box<dyn XfsHealthEvent>> {
+    Ok(Box::new(XfsFileIoErrorEvent::new(
+        XfsFileIoErrorType::try_from(&v["type"])
+            .with_context(|| M_("Reading file I/O error event"))?,
+        to_fid(&v["inumber"], &v["generation"])
+            .with_context(|| M_("Reading file I/O error event"))?,
+        to_range(&v["pos"], &v["len"]).with_context(|| M_("Reading file I/O error event"))?,
+    )))
+}
+
+enum_set_from_json!(XfsWholeFsMetadata, M_("Unknown whole-fs metadata"));
+
+/// Create an whole-fs health event from json
+fn wholefs_event_from_json(v: Value) -> Result<Box<dyn XfsHealthEvent>> {
+    Ok(Box::new(XfsWholeFsEvent::new(
+        XfsWholeFsMetadata::try_set_from(&v["structures"])
+            .with_context(|| M_("Reading whole-fs event"))?,
+        XfsHealthStatus::try_from(&v["type"]).with_context(|| M_("Reading whole-fs event"))?,
+    )))
+}
+
+enum_set_from_json!(XfsShutdownReason, M_("Unknown fs shutdown reason"));
+
+/// Create a shutdown event from json
+fn shutdown_event_from_json(v: Value) -> Result<Box<dyn XfsHealthEvent>> {
+    Ok(Box::new(XfsShutdownEvent::new(
+        XfsShutdownReason::try_set_from(&v["reasons"])
+            .with_context(|| M_("Reading fs shutdown event"))?,
+    )))
+}
+
+/// Convert json values to a physrange
+fn to_phys(dev: &Value, daddr: &Value, bbcount: &Value) -> Result<XfsPhysRange> {
+    let a = daddr
+        .as_u64()
+        .ok_or(baddata!(M_("daddr must be integer"), XfsPhysRange, daddr))?;
+    let b = bbcount.as_u64().ok_or(baddata!(
+        M_("bbcount must be integer"),
+        XfsPhysRange,
+        bbcount
+    ))?;
+
+    Ok(XfsPhysRange {
+        device: XfsDevice::try_from(dev)?,
+        daddr: a.into(),
+        bbcount: b.into(),
+    })
+}
+
+enum_from_json!(XfsDevice, M_("Unknown XFS device"));
+
+/// Create a media error event from json
+fn media_error_event_from_json(v: Value) -> Result<Box<dyn XfsHealthEvent>> {
+    Ok(Box::new(XfsMediaErrorEvent::new(
+        to_phys(&v["domain"], &v["daddr"], &v["bbcount"])
+            .with_context(|| M_("Reading media error event"))?,
+    )))
+}
+
+/// Create event for the kernel telling us that it lost an event
+fn lost_event_from_json(v: Value) -> Result<Box<dyn XfsHealthEvent>> {
+    let r = &v["count"];
+    let count = r
+        .as_u64()
+        .ok_or(baddata!(M_("Not a count"), LostEvent, r))
+        .with_context(|| M_("Reading lost event"))?;
+
+    Ok(Box::new(LostEvent::new(count)))
+}
+
+impl JsonEventWrapper {
+    /// Return an event object that can react to a health event.
+    pub fn cook(self) -> Result<Box<dyn XfsHealthEvent>> {
+        let json = Value::try_from(self).with_context(|| M_("Interpreting json event"))?;
+        match json["domain"].as_str() {
+            Some("rtgroup") => rtgroup_event_from_json(json),
+            Some("perag") => perag_event_from_json(json),
+            Some("inode") => inode_event_from_json(json),
+            Some("fs") => wholefs_event_from_json(json),
+            Some("mount") => match json["type"].as_str() {
+                Some("lost") => lost_event_from_json(json),
+                Some("shutdown") => shutdown_event_from_json(json),
+                Some("unmount") => Ok(Box::new(XfsUnmountEvent {})),
+                Some("running") => Ok(Box::new(RunningEvent {})),
+                _ => Ok(Box::new(UnknownEvent {})),
+            },
+            Some("datadev") | Some("rtdev") | Some("logdev") => media_error_event_from_json(json),
+
+            Some("filerange") => file_io_error_event_from_json(json),
+
+            _ => Ok(Box::new(UnknownEvent {})),
+        }
+    }
+}
+
+impl Display for JsonEventWrapper {
+    /// Turn this collection of strings into a single string
+    fn fmt(&self, f: &mut Formatter) -> std::fmt::Result {
+        write!(f, "{}", self.0.join(""))
+    }
+}
+
+impl Iterator for JsonMonitor<'_> {
+    type Item = JsonEventWrapper;
+
+    /// Return health monitoring events
+    fn next(&mut self) -> Option<Self::Item> {
+        let mut ret = JsonEventWrapper(Vec::new());
+        loop {
+            match self.lineiter.next() {
+                // read lines until we encounter a closing brace by itself
+                Some(Ok(line)) => {
+                    if self.debug {
+                        printlogln!("{}: \"{}\"", M_("new line"), line);
+                    }
+                    let done = line == "}";
+                    ret.push(line);
+                    if done {
+                        break;
+                    }
+                    continue;
+                }
+
+                // ran out of data
+                None => return None,
+
+                // io error on the monitoring fd, stop reading
+                Some(Err(e)) => {
+                    eprintln!("{}: {}: {:#}", self.mountpoint.display(), M_("Reading event json object"), e);
+                    return None;
+                }
+            }
+        }
+        Some(ret)
+    }
+}
diff --git a/healer/src/healthmon/mod.rs b/healer/src/healthmon/mod.rs
index ebafd767452349..5116361146db18 100644
--- a/healer/src/healthmon/mod.rs
+++ b/healer/src/healthmon/mod.rs
@@ -11,5 +11,6 @@ pub mod event;
 pub mod fs;
 pub mod groups;
 pub mod inodes;
+pub mod json;
 
 ioctl_write_ptr!(xfs_ioc_health_monitor, 'X', 68, xfs_health_monitor);
diff --git a/healer/src/main.rs b/healer/src/main.rs
index 3d4d91b17708dd..456dc44289d534 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -10,6 +10,7 @@ use std::path::PathBuf;
 use std::process::ExitCode;
 use xfs_healer::healthmon::cstruct::CStructMonitor;
 use xfs_healer::healthmon::event::XfsHealthEvent;
+use xfs_healer::healthmon::json::JsonMonitor;
 use xfs_healer::printlogln;
 use xfs_healer::xfsprogs;
 use xfs_healer::xfsprogs::M_;
@@ -53,6 +54,12 @@ impl Cli {
                     .value_parser(value_parser!(PathBuf))
                     .required_unless_present("version"),
             )
+            .arg(
+                Arg::new("json")
+                    .long("json")
+                    .help(M_("Use the JSON kernel interface instead of C"))
+                    .action(ArgAction::SetTrue),
+            )
             .get_matches())
     }
 }
@@ -63,6 +70,7 @@ struct App {
     debug: bool,
     log: bool,
     everything: bool,
+    json: bool,
     path: PathBuf,
 }
 
@@ -90,11 +98,20 @@ impl App {
     fn main(&self) -> Result<ExitCode> {
         let fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
 
-        let hmon = CStructMonitor::try_new(fp, &self.path, self.everything)
-            .with_context(|| M_("Opening health monitor file"))?;
+        if self.json {
+            let hmon = JsonMonitor::try_new(fp, &self.path, self.everything, self.debug)
+                .with_context(|| M_("Opening js health monitor file"))?;
 
-        for raw_event in hmon {
-            self.process_event(raw_event.cook());
+            for raw_event in hmon {
+                self.process_event(raw_event.cook());
+            }
+        } else {
+            let hmon = CStructMonitor::try_new(fp, &self.path, self.everything)
+                .with_context(|| M_("Opening health monitor file"))?;
+
+            for raw_event in hmon {
+                self.process_event(raw_event.cook());
+            }
         }
 
         Ok(ExitCode::SUCCESS)
@@ -108,6 +125,7 @@ impl From<Cli> for App {
             log: cli.0.get_flag("log"),
             everything: cli.0.get_flag("everything"),
             path: cli.0.get_one::<PathBuf>("path").unwrap().to_path_buf(),
+            json: cli.0.get_flag("json"),
         }
     }
 }
diff --git a/healer/src/xfs_types.rs b/healer/src/xfs_types.rs
index 5ce1d73d8e9342..37ca1b3e5a3cc0 100644
--- a/healer/src/xfs_types.rs
+++ b/healer/src/xfs_types.rs
@@ -9,6 +9,7 @@ use crate::xfsprogs::M_;
 use anyhow::{Error, Result};
 use std::fmt::Display;
 use std::fmt::Formatter;
+use strum_macros::EnumString;
 
 /// Allocation group number on the data device
 #[derive(Debug)]
@@ -55,10 +56,15 @@ impl TryFrom<u64> for XfsRgNumber {
 }
 
 /// Disk devices
-#[derive(Debug)]
+#[derive(Debug, EnumString)]
 pub enum XfsDevice {
+    #[strum(serialize = "datadev")]
     Data,
+
+    #[strum(serialize = "logdev")]
     Log,
+
+    #[strum(serialize = "rtdev")]
     Realtime,
 }
 
diff --git a/m4/package_rust.m4 b/m4/package_rust.m4
index 4b426f968c263c..192d84651df909 100644
--- a/m4/package_rust.m4
+++ b/m4/package_rust.m4
@@ -131,6 +131,9 @@ anyhow = { version = "1.0.69" }
 $gettext_dep
 nix = { version = "0", features = [["ioctl"]] }		# 0.26.1
 enumset = { version = "1.0.12" }
+strum = { version = "0" }				# 0.19.2
+strum_macros = { version = "0" }			# 0.19.2
+serde_json = { version = "1.0.87" }
 ],
     [yes], [no])
 ])

