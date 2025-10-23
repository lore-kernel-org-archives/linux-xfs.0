Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DD636124
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178560; cv=none; b=b8XCmwqkJngfArOYRPsk/3iDJ0m2kQcgzSaxORTEfow+pe91szBWuUymZNuOtxCRPwhvG4shGzNe+Eywk2kzWuBeuJN1akokUy+CuwJ6OHu6WxIGfrFrZAmT3W9CPQ54dBsIZi2T4pgtNOjPMFENKwiuhhSATzmruzAoVLlXNcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178560; c=relaxed/simple;
	bh=U0OWtU8G5WD4+oz7HBG9mmI2RBUyC5kqG9GEUditX0Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBLCEQJzeXBpxHygiuZbhpMQXYqUv79Yb4aoZwPefLV3dW0oRKAeu8Zk8SmUDzBlzZuXYGga/qk6auB17Vvyx+hoUW2rvGFpPzvwh9FxW9wxyGu4rJFOMRwH2fOFCBHFKzya6824/Tj+HeC3+BHdL3hWnvqWI1rz7YuWckolrYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BqoB+zEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqoB+zEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA582C4CEE7;
	Thu, 23 Oct 2025 00:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178559;
	bh=U0OWtU8G5WD4+oz7HBG9mmI2RBUyC5kqG9GEUditX0Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BqoB+zEC6RItloCPicFi8ifubb4KHuMbo9tgCwnsYJoaxeN9b5ck9GFZQxP6X5XUL
	 MjkD6SyRRk1Td1TL1G2nT48BU+Mx9PL2c9B+P4RmEcdd6veqSFThRJ0t/4mX/XCQpS
	 bB8O69pCRCO7ggk++SApwYk+AeplfY3hrWgfzGgFGUYOsuF8S37D0u34hbVN0/yBM6
	 oQiN9CqiwFgOoPbT/aTke3pKDKLrJ+Np6tQKKKKLPxkjzpgi+aH/alrsvHw/s2F9c7
	 NrB+B3m11V/Kss+TSIf96LAyFzjsVYecBADovISHauvdT7G4d4TpO4SgLfLNkJDgVa
	 KHbEXaAj/JyqA==
Date: Wed, 22 Oct 2025 17:15:59 -0700
Subject: [PATCH 14/19] xfs_healer: use thread pools
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748521.1029045.5867647755358840607.stgit@frogsfrogsfrogs>
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

Use a thread pool so that the kernel event reader thread can spend as
much time sleeping in the kernel while other threads actually deal with
decoding and processing the events.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Cargo.toml.in     |    1 +
 healer/src/main.rs       |   87 +++++++++++++++++++++++++++++++++++++++-------
 healer/src/weakhandle.rs |    6 ++-
 m4/package_rust.m4       |    1 +
 4 files changed, 78 insertions(+), 17 deletions(-)


diff --git a/healer/Cargo.toml.in b/healer/Cargo.toml.in
index dcb356b7772674..433be243e3846c 100644
--- a/healer/Cargo.toml.in
+++ b/healer/Cargo.toml.in
@@ -18,6 +18,7 @@ clap = { version = "4.0.32", features = ["derive"] }
 anyhow = { version = "1.0.69" }
 enumset = { version = "1.0.12" }
 serde_json = { version = "1.0.87" }
+threadpool = { version = "1.8.1" }
 
 # XXX: Crates with major version 0 are not considered ABI-stable, so the minor
 # version is treated as if it were the major version.  This creates problems
diff --git a/healer/src/main.rs b/healer/src/main.rs
index 777b5c2804b297..4d0f6021177ac9 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -8,16 +8,19 @@ use clap::{value_parser, Arg, ArgAction, ArgGroup, ArgMatches, Command};
 use std::fs::File;
 use std::path::PathBuf;
 use std::process::ExitCode;
-use std::rc::Rc;
+use std::sync::Arc;
+use threadpool::ThreadPool;
 use xfs_healer::fsprops;
 use xfs_healer::fsprops::XfsAutofsck;
 use xfs_healer::healthmon::cstruct::CStructMonitor;
 use xfs_healer::healthmon::event::XfsHealthEvent;
+use xfs_healer::healthmon::json::JsonEventWrapper;
 use xfs_healer::healthmon::json::JsonMonitor;
 use xfs_healer::printlogln;
 use xfs_healer::repair::Repair;
 use xfs_healer::weakhandle::WeakHandle;
 use xfs_healer::xfs_fs::xfs_fsop_geom;
+use xfs_healer::xfs_fs::xfs_health_monitor_event;
 use xfs_healer::xfsprogs;
 use xfs_healer::xfsprogs::M_;
 
@@ -99,7 +102,25 @@ struct App {
     repair: bool,
     check: bool,
     autofsck: bool,
-    path: Rc<PathBuf>,
+    path: Arc<PathBuf>,
+}
+
+/// Contains all the per-thread state
+#[derive(Debug)]
+struct EventThread {
+    log: bool,
+    repair: bool,
+}
+
+impl EventThread {
+    /// Create a new thread context from an App reference
+    // XXX: I don't know how to do From<&App>
+    fn new(app: &App) -> Self {
+        EventThread {
+            log: app.log,
+            repair: app.repair,
+        }
+    }
 }
 
 /// Outcome of checking if the kernel supports metadata repair
@@ -123,28 +144,55 @@ impl App {
     }
 
     /// Handle a health event that has been decoded into real objects
-    fn process_event(&self, fh: &WeakHandle, cooked: Result<Box<dyn XfsHealthEvent>>) {
+    fn process_event(
+        et: EventThread,
+        fh: Arc<WeakHandle>,
+        cooked: Result<Box<dyn XfsHealthEvent>>,
+    ) {
         match cooked {
             Err(e) => {
-                eprintln!("{}: {:#}", self.path.display(), e)
+                eprintln!("{}: {:#}", fh.mountpoint(), e)
             }
             Ok(event) => {
-                if self.log || event.must_log() {
-                    let (maybe_path, message) = event.format(fh);
+                if et.log || event.must_log() {
+                    let (maybe_path, message) = event.format(&fh);
                     match maybe_path {
                         Some(x) => printlogln!("{}: {}", x.display(), message),
-                        None => printlogln!("{}: {}", self.path.display(), message),
+                        None => printlogln!("{}: {}", fh.mountpoint(), message),
                     };
                 }
-                if self.repair {
+                if et.repair {
                     for mut repair in event.schedule_repairs() {
-                        repair.perform(fh)
+                        repair.perform(&fh)
                     }
                 }
             }
         }
     }
 
+    // fugly helpers to reduce the scope of the variables moved into the closure
+    fn dispatch_json_event(
+        threads: &ThreadPool,
+        et: EventThread,
+        fh: Arc<WeakHandle>,
+        raw_event: JsonEventWrapper,
+    ) {
+        threads.execute(move || {
+            App::process_event(et, fh, raw_event.cook());
+        })
+    }
+
+    fn dispatch_cstruct_event(
+        threads: &ThreadPool,
+        et: EventThread,
+        fh: Arc<WeakHandle>,
+        raw_event: xfs_health_monitor_event,
+    ) {
+        threads.execute(move || {
+            App::process_event(et, fh, raw_event.cook());
+        })
+    }
+
     /// Complain if repairs won't be entirely effective.
     fn check_repair(&self, fp: &File, fsgeom: &xfs_fsop_geom) -> CheckRepair {
         if !Repair::is_supported(fp) {
@@ -247,24 +295,35 @@ impl App {
             });
         }
 
-        let fh = WeakHandle::try_new(&fp, self.path.clone(), fsgeom)
-            .with_context(|| M_("Configuring filesystem handle"))?;
+        let fh = Arc::new(
+            WeakHandle::try_new(&fp, self.path.clone(), fsgeom)
+                .with_context(|| M_("Configuring filesystem handle"))?,
+        );
+
+        // Creates a threadpool with nr_cpus workers.
+        let threads = threadpool::Builder::new().build();
 
         if self.json {
             let hmon = JsonMonitor::try_new(fp, &self.path, self.everything, self.debug)
                 .with_context(|| M_("Opening js health monitor file"))?;
 
             for raw_event in hmon {
-                self.process_event(&fh, raw_event.cook());
+                App::dispatch_json_event(&threads, EventThread::new(self), fh.clone(), raw_event);
             }
         } else {
             let hmon = CStructMonitor::try_new(fp, &self.path, self.everything)
                 .with_context(|| M_("Opening health monitor file"))?;
 
             for raw_event in hmon {
-                self.process_event(&fh, raw_event.cook());
+                App::dispatch_cstruct_event(
+                    &threads,
+                    EventThread::new(self),
+                    fh.clone(),
+                    raw_event,
+                );
             }
         }
+        threads.join();
 
         Ok(ExitCode::SUCCESS)
     }
@@ -276,7 +335,7 @@ impl From<Cli> for App {
             debug: cli.0.get_flag("debug"),
             log: cli.0.get_flag("log"),
             everything: cli.0.get_flag("everything"),
-            path: Rc::new(cli.0.get_one::<PathBuf>("path").unwrap().to_path_buf()),
+            path: Arc::new(cli.0.get_one::<PathBuf>("path").unwrap().to_path_buf()),
             json: cli.0.get_flag("json"),
             repair: cli.0.get_flag("repair"),
             check: cli.0.get_flag("check"),
diff --git a/healer/src/weakhandle.rs b/healer/src/weakhandle.rs
index 8734d421fe5f32..8c3dd7e04a64c2 100644
--- a/healer/src/weakhandle.rs
+++ b/healer/src/weakhandle.rs
@@ -20,7 +20,7 @@ use std::io::ErrorKind;
 use std::os::fd::AsRawFd;
 use std::os::raw::c_void;
 use std::path::PathBuf;
-use std::rc::Rc;
+use std::sync::Arc;
 
 ioctl_readwrite!(xfs_ioc_fd_to_handle, 'X', 106, xfs_fsop_handlereq);
 
@@ -73,7 +73,7 @@ impl TryFrom<&File> for xfs_handle {
 /// Filesystem handle that can be disconnected from any open files
 pub struct WeakHandle {
     /// path to the filesystem mountpoint
-    mountpoint: Rc<PathBuf>,
+    mountpoint: Arc<PathBuf>,
 
     /// Filesystem handle
     handle: xfs_handle,
@@ -108,7 +108,7 @@ impl WeakHandle {
     /// Create a soft handle from an open file descriptor and its mount point
     pub fn try_new(
         fp: &File,
-        mountpoint: Rc<PathBuf>,
+        mountpoint: Arc<PathBuf>,
         fsgeom: xfs_fsop_geom,
     ) -> Result<WeakHandle> {
         Ok(WeakHandle {
diff --git a/m4/package_rust.m4 b/m4/package_rust.m4
index 109e4ba51d6356..a6fb0b9a8fc50c 100644
--- a/m4/package_rust.m4
+++ b/m4/package_rust.m4
@@ -135,6 +135,7 @@ strum = { version = "0" }				# 0.19.2
 strum_macros = { version = "0" }			# 0.19.2
 serde_json = { version = "1.0.87" }
 libc = { version = "0" }				# 0.2.139
+threadpool = { version = "1.8.1" }
 ],
     [yes], [no])
 ])

