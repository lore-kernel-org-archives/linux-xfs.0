Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD524132117
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178513; cv=none; b=VOu0oU61gsz/ytIb0RJhnRlDSklYd/rFJrulSgRWeY1uw8vYxWeRmiIiWEf31UUczTfKYZYQvjdwpGIFR+XugH8alWnQNrarYTvk/TonHpL6Li5H85OBGofmVWiJ/7PSl/jHogvmFAql4UhTvbZt3SLWmCgWGlDWyiiBVk4R7us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178513; c=relaxed/simple;
	bh=Bdk0VAu119+iD6I0eX3smdxbcMs9qJ+CDMmaMcgwiEw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oPurHMibG2bfNj1KjUYFjw6dk9e7GSblkSg15Ngx3TwY4ckJcCAwr7gf30f6fbI7OIq8nO4tkX0O4vZymcCXlClC+kA42FIAiL6mGh2oSs1LiZqOVB1YO0hOL1UyuSbalMAewH7XRpGSWdgFShvjmGBPLTj82eafIKTelcEg+TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAqDy8Ym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAqDy8Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C9AC4CEE7;
	Thu, 23 Oct 2025 00:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178513;
	bh=Bdk0VAu119+iD6I0eX3smdxbcMs9qJ+CDMmaMcgwiEw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EAqDy8YmFB62cJe5Gq8AtGQGRUscCw/Dv6zDkXAUP/w+ZUTFtcheopBG6c3ffgWUu
	 ZXifi2dGrUifTcXlnJqLikjXlRqcPXjoqEYejwgfGL4lfOYWfflO/uXfAPwYbZnaIC
	 8NcUSHeK36TxJGb77YaFRePstGtCyC+f+JaTbaMqqrClyiw8gcuUcgKIqIrTLQJjkz
	 Gk2Ixseh9TA/Ndl/VnHnz723SZc9fWrbXqALIhysiVf2vdgx2skwYU3MsSXdWzDLMK
	 5a9EYMPsX1XuNNwnlwSn8PJcxPPkH7rbv4njYXCD9qDq4IZNw8JFbTcg6CBkikq0TP
	 LBp93U+Y0YLIA==
Date: Wed, 22 Oct 2025 17:15:12 -0700
Subject: [PATCH 11/19] xfs_healer: make the rust program check if kernel
 support available
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748464.1029045.9301847174563723449.stgit@frogsfrogsfrogs>
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

Teach the rust port program to check if kernel support is available, to
duplicate existing python functionality.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/src/healthmon/mod.rs |   28 ++++++++++++++++++++++++++++
 healer/src/main.rs          |   18 ++++++++++++++++++
 2 files changed, 46 insertions(+)


diff --git a/healer/src/healthmon/mod.rs b/healer/src/healthmon/mod.rs
index 5116361146db18..f73babbe001154 100644
--- a/healer/src/healthmon/mod.rs
+++ b/healer/src/healthmon/mod.rs
@@ -3,8 +3,12 @@
  * Copyright (C) 2025 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
+use crate::xfs_fs;
 use crate::xfs_fs::xfs_health_monitor;
 use nix::ioctl_write_ptr;
+use std::fs::File;
+use std::os::fd::AsRawFd;
+use std::os::fd::FromRawFd;
 
 pub mod cstruct;
 pub mod event;
@@ -14,3 +18,27 @@ pub mod inodes;
 pub mod json;
 
 ioctl_write_ptr!(xfs_ioc_health_monitor, 'X', 68, xfs_health_monitor);
+
+/// Check if the open file supports a health monitor.
+pub fn is_supported(fp: &File, use_json: bool) -> bool {
+    let hminfo = xfs_health_monitor {
+        format: if use_json {
+            xfs_fs::XFS_HEALTH_MONITOR_FMT_JSON as u8
+        } else {
+            xfs_fs::XFS_HEALTH_MONITOR_FMT_CSTRUCT as u8
+        },
+        ..Default::default()
+    };
+
+    // SAFETY: Trusting the kernel not to corrupt our memory, and for it to return a valid file
+    // description number, which we immediately convert to a File and drop to close the fd.
+    unsafe {
+        match xfs_ioc_health_monitor(fp.as_raw_fd(), &hminfo) {
+            Ok(x) => {
+                File::from_raw_fd(x);
+                true
+            }
+            Err(_) => false,
+        }
+    }
+}
diff --git a/healer/src/main.rs b/healer/src/main.rs
index 191018779f335d..fe125c4c4ee5f3 100644
--- a/healer/src/main.rs
+++ b/healer/src/main.rs
@@ -69,6 +69,12 @@ impl Cli {
                     .help(M_("Always repair corrupt metadata"))
                     .action(ArgAction::SetTrue),
             )
+            .arg(
+                Arg::new("check")
+                    .long("check")
+                    .help(M_("Check that health monitoring is supported"))
+                    .action(ArgAction::SetTrue),
+            )
             .get_matches())
     }
 }
@@ -81,6 +87,7 @@ struct App {
     everything: bool,
     json: bool,
     repair: bool,
+    check: bool,
     path: PathBuf,
 }
 
@@ -155,6 +162,16 @@ impl App {
             }
         }
 
+        // Now that we know that we can repair if the user wanted to, make sure that the kernel
+        // supports reporting events if that was as far as the user wanted us to go.
+        if self.check {
+            return Ok(if xfs_healer::healthmon::is_supported(&fp, self.json) {
+                ExitCode::SUCCESS
+            } else {
+                ExitCode::FAILURE
+            });
+        }
+
         let fh = WeakHandle::try_new(&fp, &self.path, fsgeom)
             .with_context(|| M_("Configuring filesystem handle"))?;
 
@@ -187,6 +204,7 @@ impl From<Cli> for App {
             path: cli.0.get_one::<PathBuf>("path").unwrap().to_path_buf(),
             json: cli.0.get_flag("json"),
             repair: cli.0.get_flag("repair"),
+            check: cli.0.get_flag("check"),
         }
     }
 }

