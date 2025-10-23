Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B580B1CD2C
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178544; cv=none; b=kHtueJCe0XhQ4tn8/uJPpEkXACT+KOMW6erkTnZ2bpI/PDO6cCoRAxYORxGrCtu3+1HM9OlGS8R0Pb4QGQcU/FoYOLX1roVAc3NJ0hZETPWYauEHjuoKLQ/tNvceWsj0N4p/Wd06hNz6QZMLGD3i2DNsia5uWyZSyLgSexKMz5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178544; c=relaxed/simple;
	bh=lOGsf7vLpRpR0ruKJ2FyzorFvhLh+Ig2ylY9vElXMuc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WZhO31K+RsEzRMG6+ZV7nLXJ3O7hZCAuVxHNfiJohRRuwyxogXEZvmhKrIb/ZdY22OST4UP0ET0P+D2iDpJYRJBCG8P/RDtoQ+Gls5Ko5jLj8yG1IGeP5ZzJQQhKUllHNuMsI5H3RQ2hqZPPzT6Ls14reglA2YmhhAWo66wfO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qK4t+HW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qK4t+HW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F1DC4CEE7;
	Thu, 23 Oct 2025 00:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178544;
	bh=lOGsf7vLpRpR0ruKJ2FyzorFvhLh+Ig2ylY9vElXMuc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qK4t+HW0WeFf5X0fltnjI51ysupYBbo7ats1F16Nt+j2vB0bqJCz2/Xz6gFdA84NQ
	 aDy9GKkCtepDx/ZjKLErdFRe4QsjTSNcxNWlPf+2rVL87dhQeavKtaUhEFUBuEfn3Z
	 Ai700W/Kn1tRIQvS9pXqvTZWoURusxKYXKmxtDBHthUD0yKDTZm/X0zfW4eHieG6zJ
	 stoYVPrsGxODDYMlZ0RRRAS6lqQF8zMTSQDgFuVmYeg6uSGxYzCr/YpDfQhrB5qWdH
	 MgRUzcaD3rBkmAIQpHIQXUXxHGORxstOCvLWLXZbiSR8zgb5Bpr+eYt9Xm7NlikSuU
	 1ALoiNHcSQaWw==
Date: Wed, 22 Oct 2025 17:15:43 -0700
Subject: [PATCH 13/19] xfs_healer: use rc on the mountpoint instead of
 lifetime annotations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748502.1029045.11372020236098159938.stgit@frogsfrogsfrogs>
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

Institute a refcount on the mountpoint pathbuf so that we don't have to
play around with explicit lifetime rules.  That was fine for single
threaded operation, but in the next patch we'll move the event
processing to another thread to reduce time between read() calls.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/src/getparents.rs |    2 +-
 healer/src/main.rs       |    9 +++++----
 healer/src/weakhandle.rs |   19 ++++++++++---------
 3 files changed, 16 insertions(+), 14 deletions(-)


diff --git a/healer/src/getparents.rs b/healer/src/getparents.rs
index d6d7020e08f9d2..46f9724ee7cf7c 100644
--- a/healer/src/getparents.rs
+++ b/healer/src/getparents.rs
@@ -180,7 +180,7 @@ fn find_path_components(
     Some(false)
 }
 
-impl WeakHandle<'_> {
+impl WeakHandle {
     /// Return a path to the root for the given soft handle and ino/gen info,
     /// or None if errors occurred or we couldn't find the root.
     pub fn path_for(&self, fid: XfsFid) -> Option<PathBuf> {
diff --git a/healer/src/main.rs b/healer/src/main.rs
index 580ca5a0b13508..777b5c2804b297 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -8,6 +8,7 @@ use clap::{value_parser, Arg, ArgAction, ArgGroup, ArgMatches, Command};
 use std::fs::File;
 use std::path::PathBuf;
 use std::process::ExitCode;
+use std::rc::Rc;
 use xfs_healer::fsprops;
 use xfs_healer::fsprops::XfsAutofsck;
 use xfs_healer::healthmon::cstruct::CStructMonitor;
@@ -98,7 +99,7 @@ struct App {
     repair: bool,
     check: bool,
     autofsck: bool,
-    path: PathBuf,
+    path: Rc<PathBuf>,
 }
 
 /// Outcome of checking if the kernel supports metadata repair
@@ -214,7 +215,7 @@ impl App {
 
     /// Main app method
     fn main(&mut self) -> Result<ExitCode> {
-        let fp = File::open(&self.path).with_context(|| M_("Opening filesystem failed"))?;
+        let fp = File::open(&*self.path).with_context(|| M_("Opening filesystem failed"))?;
 
         // Decide if we're going to enable repairs, which must come before check_repair.
         if self.autofsck {
@@ -246,7 +247,7 @@ impl App {
             });
         }
 
-        let fh = WeakHandle::try_new(&fp, &self.path, fsgeom)
+        let fh = WeakHandle::try_new(&fp, self.path.clone(), fsgeom)
             .with_context(|| M_("Configuring filesystem handle"))?;
 
         if self.json {
@@ -275,7 +276,7 @@ impl From<Cli> for App {
             debug: cli.0.get_flag("debug"),
             log: cli.0.get_flag("log"),
             everything: cli.0.get_flag("everything"),
-            path: cli.0.get_one::<PathBuf>("path").unwrap().to_path_buf(),
+            path: Rc::new(cli.0.get_one::<PathBuf>("path").unwrap().to_path_buf()),
             json: cli.0.get_flag("json"),
             repair: cli.0.get_flag("repair"),
             check: cli.0.get_flag("check"),
diff --git a/healer/src/weakhandle.rs b/healer/src/weakhandle.rs
index 57cc7602fbd25e..8734d421fe5f32 100644
--- a/healer/src/weakhandle.rs
+++ b/healer/src/weakhandle.rs
@@ -19,7 +19,8 @@ use std::fs::File;
 use std::io::ErrorKind;
 use std::os::fd::AsRawFd;
 use std::os::raw::c_void;
-use std::path::Path;
+use std::path::PathBuf;
+use std::rc::Rc;
 
 ioctl_readwrite!(xfs_ioc_fd_to_handle, 'X', 106, xfs_fsop_handlereq);
 
@@ -70,9 +71,9 @@ impl TryFrom<&File> for xfs_handle {
 }
 
 /// Filesystem handle that can be disconnected from any open files
-pub struct WeakHandle<'a> {
+pub struct WeakHandle {
     /// path to the filesystem mountpoint
-    mountpoint: &'a Path,
+    mountpoint: Rc<PathBuf>,
 
     /// Filesystem handle
     handle: xfs_handle,
@@ -81,10 +82,10 @@ pub struct WeakHandle<'a> {
     has_parent: bool,
 }
 
-impl WeakHandle<'_> {
+impl WeakHandle {
     /// Try to reopen the filesystem from which we got the handle.
     pub fn reopen(&self) -> Result<File> {
-        let fp = File::open(self.mountpoint)?;
+        let fp = File::open(self.mountpoint.as_path())?;
 
         if xfs_handle::try_from(&fp)? != self.handle {
             let s = format!(
@@ -105,11 +106,11 @@ impl WeakHandle<'_> {
     }
 
     /// Create a soft handle from an open file descriptor and its mount point
-    pub fn try_new<'a>(
+    pub fn try_new(
         fp: &File,
-        mountpoint: &'a Path,
+        mountpoint: Rc<PathBuf>,
         fsgeom: xfs_fsop_geom,
-    ) -> Result<WeakHandle<'a>> {
+    ) -> Result<WeakHandle> {
         Ok(WeakHandle {
             mountpoint,
             handle: xfs_handle::try_from(fp)?,
@@ -135,7 +136,7 @@ impl WeakHandle<'_> {
     }
 }
 
-impl Display for WeakHandle<'_> {
+impl Display for WeakHandle {
     fn fmt(&self, f: &mut Formatter) -> std::fmt::Result {
         write!(f, "{}", self.mountpoint.display())
     }

