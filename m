Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AAC33D5
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738561; cv=none; b=TGI4dxci+5JuaOMRqShBv7KYrkR3+ezfajh5nsl9NaJHdI7cMd8hPYRHmm6/gNCiDS5EWu1+UjNBtDIgaMtE77SB0TPgPcnhorJMfHuBg3zMccwqgT1+Mz1SyrkIPANTJApiOw8vgqjo18UnDiV4Rh2fxvttM5r6pbZLCcBiFQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738561; c=relaxed/simple;
	bh=NFo0oi0tAjlb+uLEH68PJkSolX3bpiE7cFalC9YYbqc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wk/5AkuRPOmAZxJjtr2E7o0Bu1lXKqZRSZnD3fN2FQlD+GfEIb5yH1oaEJVp1RE8pGNMr1J+5bvNJDtdIzTZdXRFP4PWKndk9FpNlWlKj9AGbXNBiZc2BoTd7+vVEWu1mZ+tuczU8+vvygMmqf/XIRFkR1g8mli5INkXevzir2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ln2xvehw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ln2xvehw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F472C433F1;
	Sat, 24 Feb 2024 01:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738560;
	bh=NFo0oi0tAjlb+uLEH68PJkSolX3bpiE7cFalC9YYbqc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ln2xvehw9Uy4QmuPY5CCIPnxy5Ehrxtd0fiNIiadlmMy6Gytnb4D0znEPevi4D76b
	 OUfTrWOWTZsEV4E3eO2+NXZro4dzp+rzm1t9nKhd0vQ1dDJZYcdhihqrRSR9yyr3Nc
	 Y1Nbn/Lx/YzX815i5xbms0kOr00WsGnOsnydf6ipTN4Wge9CplFbI/EUiurZh0f4VM
	 uPeLrBRYxv2rFB+/WBsqZrRzWHu4uBG0a9OgjoAEvMQHjBMKKIOAWSuNeR2/qk+GzN
	 bmUVT7MPrvW4lwFEaQBzNbyVeJEAfz8VoKNSAneIT0GimMTAR008baSdV3l1WTpDyd
	 L9sfpIETLj/eA==
Date: Fri, 23 Feb 2024 17:36:00 -0800
Subject: [PATCH 7/7] xfs_scrubbed: create a background monitoring service
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170873836655.1902540.5434675001559946363.stgit@frogsfrogsfrogs>
In-Reply-To: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
References: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a systemd service and activate it automatically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                 |    8 ++-
 scrub/xfs.rules                |    3 +
 scrub/xfs_scrubbed.in          |    8 +++
 scrub/xfs_scrubbed@.service.in |   95 ++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrubbed_start       |   17 +++++++
 5 files changed, 128 insertions(+), 3 deletions(-)
 create mode 100644 scrub/xfs_scrubbed@.service.in
 create mode 100755 scrub/xfs_scrubbed_start


diff --git a/scrub/Makefile b/scrub/Makefile
index cf112018376b..7c1b5c742be2 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -19,6 +19,7 @@ XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
 XFS_SCRUB_ARGS = -p
 XFS_SCRUB_SERVICE_ARGS = -b
 XFS_SCRUBBED_PROG = xfs_scrubbed
+XFS_SCRUBBED_HELPER = xfs_scrubbed_start
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
@@ -29,8 +30,9 @@ SYSTEMD_SERVICES=\
 	xfs_scrub_all.service \
 	xfs_scrub_all_fail.service \
 	xfs_scrub_all.timer \
-	system-xfs_scrub.slice
-OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
+	system-xfs_scrub.slice \
+	xfs_scrubbed@.service
+OPTIONAL_TARGETS += $(SYSTEMD_SERVICES) $(XFS_SCRUBBED_HELPER)
 endif
 ifeq ($(HAVE_CROND),yes)
 INSTALL_SCRUB += install-crond
@@ -181,7 +183,7 @@ install-systemd: default $(SYSTEMD_SERVICES)
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
 	$(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
 	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
-	$(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(XFS_SCRUBBED_HELPER) $(PKG_LIBEXEC_DIR)
 
 install-crond: default $(CRONTABS)
 	$(INSTALL) -m 755 -d $(CROND_DIR)
diff --git a/scrub/xfs.rules b/scrub/xfs.rules
index c3f69b3ab909..f3ec21c322fe 100644
--- a/scrub/xfs.rules
+++ b/scrub/xfs.rules
@@ -11,3 +11,6 @@
 # supplying UDISKS_AUTO=0 here changes the HintAuto property of the block
 # device abstraction to mean "do not automatically start" (e.g. mount).
 SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="xfs|xfs_external_log", ENV{UDISKS_AUTO}="0"
+
+# Start the background scrubber automatically
+ACTION=="add", SUBSYSTEM=="xfs", ENV{TYPE}=="mount", RUN+="xfs_scrubbed_start"
diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index 5458d39486bc..6d12efc2998b 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -17,6 +17,7 @@ import datetime
 import errno
 import ctypes
 import ctypes.util
+import time
 
 debug = False
 log = False
@@ -505,6 +506,13 @@ def main():
 		ret = monitor(args.mountpoint)
 	except KeyboardInterrupt:
 		ret = 0
+
+	# See the service mode comments in xfs_scrub.c for why we do this.
+	if 'SERVICE_MODE' in os.environ:
+		time.sleep(2)
+		if ret != 0:
+			ret = 1
+
 	sys.exit(ret)
 
 if __name__ == '__main__':
diff --git a/scrub/xfs_scrubbed@.service.in b/scrub/xfs_scrubbed@.service.in
new file mode 100644
index 000000000000..c33efbbbc7e5
--- /dev/null
+++ b/scrub/xfs_scrubbed@.service.in
@@ -0,0 +1,95 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Self Healing of XFS Metadata for %f
+Documentation=man:xfs_scrubbed(8)
+
+# Explicitly require the capabilities that this program needs
+ConditionCapability=CAP_SYS_ADMIN
+
+# Must be a mountpoint
+ConditionPathIsMountPoint=%f
+RequiresMountsFor=%f
+
+[Service]
+Type=oneshot
+Environment=SERVICE_MODE=1
+ExecStart=@pkg_libexec_dir@/xfs_scrubbed --repair --log %f
+SyslogIdentifier=%N
+
+# Run scrub with minimal CPU and IO priority so that nothing else will starve.
+IOSchedulingClass=idle
+CPUSchedulingPolicy=idle
+CPUAccounting=true
+Nice=19
+
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice
+
+# No realtime CPU scheduling
+RestrictRealtime=true
+
+# Dynamically create a user that isn't root
+DynamicUser=true
+
+# Make the entire filesystem readonly, but don't hide /home and don't use a
+# private bind mount like xfs_scrub.  We don't want to pin the filesystem,
+# because we want umount to work correctly and this service to stop
+# automatically.
+ProtectSystem=strict
+ProtectHome=no
+PrivateTmp=true
+PrivateDevices=true
+
+# Don't let scrub complain about paths in /etc/projects that have been hidden
+# by our sandboxing.  scrub doesn't care about project ids anyway.
+InaccessiblePaths=-/etc/projects
+
+# No network access
+PrivateNetwork=true
+ProtectHostname=true
+RestrictAddressFamilies=none
+IPAddressDeny=any
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+
+# Hide everything in /proc, even /proc/mounts
+ProcSubset=pid
+
+# Only allow the default personality Linux
+LockPersonality=true
+
+# No writable memory pages
+MemoryDenyWriteExecute=true
+
+# Don't let our mounts leak out to the host
+PrivateMounts=true
+
+# Restrict system calls to the native arch and only enough to get things going
+SystemCallArchitectures=native
+SystemCallFilter=@system-service
+SystemCallFilter=~@privileged
+SystemCallFilter=~@resources
+SystemCallFilter=~@mount
+
+# xfs_scrub needs these privileges to run, and no others
+CapabilityBoundingSet=CAP_SYS_ADMIN
+AmbientCapabilities=CAP_SYS_ADMIN
+NoNewPrivileges=true
+
+# xfs_scrubbed doesn't create files
+UMask=7777
+
+# No access to hardware /dev files except for block devices
+ProtectClock=true
+DevicePolicy=closed
diff --git a/scrub/xfs_scrubbed_start b/scrub/xfs_scrubbed_start
new file mode 100755
index 000000000000..471fdc99eb16
--- /dev/null
+++ b/scrub/xfs_scrubbed_start
@@ -0,0 +1,17 @@
+#!/bin/sh
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+# Start the xfs_scrubbed service when the filesystem is mounted
+
+command -v systemctl || exit 0
+
+grep "^$SOURCE[[:space:]]" /proc/mounts | while read source mntpt therest; do
+	inst="$(systemd-escape --path "$mntpt")"
+	systemctl restart --no-block "xfs_scrubbed@$inst" && break
+done
+
+exit 0

