Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E3CEACD
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178216; cv=none; b=fb1PxhPQ2hdiLDuAYfAPoCTn22rQUjVwy0WEsnA8Io/4NBpGtECbaumf/dpI7zA0KYIsb3fQmfr7HvdKcmmw0cn6oidfxwkJZHdIbH+YSeatYuQG661GOZ9otHsoA5MTwXMeHa/LMc/l5Q8u5c5ioLjgLUmqwQOJs4FLJlhfT3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178216; c=relaxed/simple;
	bh=owRdSYZLHSiBpk2MBJMXFxmKVX4cSO/IUtKAmJgQba0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KyGxFDJjWMr5wxkIsAN6bG+JcA60luyb7JC/840MFSQpzGjTI9RhLQCTqBd3bl9/kf0FeiUKfpXf/M2hOEHEWi1Pxil4bWbFCzE6uJQxV0m4JtOwZyH/uxTh4pgiDr31B88tgIGJKjRoRVxx0msIAneXq/6l0JJPRdw3r1nmeos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WA5BARb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WA5BARb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE43C4CEE7;
	Thu, 23 Oct 2025 00:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178215;
	bh=owRdSYZLHSiBpk2MBJMXFxmKVX4cSO/IUtKAmJgQba0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WA5BARb1d/HrYEKn329/6TfH6nDiiUTvvhe77xPkw4iJyJaoy2RgO7a7ZSx1qNqM4
	 SUF6pzeZNkW97LY5VRbD8eEscWMpftVNKQh6jc7to8hm47d2nl1zb/QIVrBrMSLhtp
	 icXMEAfNnPMp8VOAjI8LIDckLVhlBvL+hsn6SPWOQA56leLutVLbAEwhQSgx6TiMce
	 tbCiAtGiftj15pcHYfBRThsD/d1ni1yaxuyLSDNr0U+swpIvqWIwDCjZLkJVcOOE8x
	 3bil7eiG/8UcHM9SNge/iAHeDr/OvCcHGGvLJr19DnG4V5pmJpLHWCHtFqQiPPP6bh
	 c79xJmYUZfxNQ==
Date: Wed, 22 Oct 2025 17:10:15 -0700
Subject: [PATCH 18/26] xfs_healer: create a background monitoring service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747805.1028044.11654217407567139092.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a systemd service for our self-healing service and activate it
automatically.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile                |   34 ++++++++++++-
 healer/system-xfs_healer.slice |   31 ++++++++++++
 healer/xfs_healer.py.in        |    9 +++
 healer/xfs_healer.rules        |    7 +++
 healer/xfs_healer@.service.in  |  107 ++++++++++++++++++++++++++++++++++++++++
 healer/xfs_healer_start        |   17 ++++++
 6 files changed, 204 insertions(+), 1 deletion(-)
 create mode 100644 healer/system-xfs_healer.slice
 create mode 100644 healer/xfs_healer.rules
 create mode 100644 healer/xfs_healer@.service.in
 create mode 100755 healer/xfs_healer_start


diff --git a/healer/Makefile b/healer/Makefile
index 100e99cc9ef0a2..a30e0714309295 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -9,9 +9,24 @@ include $(builddefs)
 XFS_HEALER_PROG = xfs_healer.py
 INSTALL_HEALER = install-healer
 
+ifeq ($(HAVE_SYSTEMD),yes)
+INSTALL_HEALER += install-systemd
+SYSTEMD_SERVICES=\
+	system-xfs_healer.slice \
+	xfs_healer@.service
+OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
+
+ifeq ($(HAVE_UDEV),yes)
+	UDEV_RULES = xfs_healer.rules
+	XFS_HEALER_HELPER = xfs_healer_start
+	INSTALL_HEALER += install-udev
+	OPTIONAL_TARGETS += $(XFS_HEALER_HELPER)
+endif
+endif
+
 LDIRT = $(XFS_HEALER_PROG)
 
-default: $(XFS_HEALER_PROG)
+default: $(XFS_HEALER_PROG) $(SYSTEMD_SERVICES) $(UDEV_RULES) $(XFS_HEALER_HELPER)
 
 $(XFS_HEALER_PROG): $(XFS_HEALER_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext.py
 	@echo "    [SED]    $@"
@@ -22,6 +37,11 @@ $(XFS_HEALER_PROG): $(XFS_HEALER_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext
 		   < $< > $@
 	$(Q)chmod a+x $@
 
+%.service: %.service.in $(builddefs)
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
+		   < $< > $@
+
 include $(BUILDRULES)
 
 install: $(INSTALL_HEALER)
@@ -30,6 +50,18 @@ install-healer: default
 	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
 	$(INSTALL) -m 755 $(XFS_HEALER_PROG) $(PKG_LIBEXEC_DIR)/xfs_healer
 
+install-systemd: default
+	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
+	$(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
+
+install-udev: default
+	$(INSTALL) -m 755 -d $(UDEV_DIR)
+	$(INSTALL) -m 755 $(XFS_HEALER_HELPER) $(UDEV_DIR)
+	$(INSTALL) -m 755 -d $(UDEV_RULE_DIR)
+	for i in $(UDEV_RULES); do \
+		$(INSTALL) -m 644 $$i $(UDEV_RULE_DIR)/64-$$i; \
+	done
+
 install-dev:
 
 -include .dep
diff --git a/healer/system-xfs_healer.slice b/healer/system-xfs_healer.slice
new file mode 100644
index 00000000000000..c58d6813549e50
--- /dev/null
+++ b/healer/system-xfs_healer.slice
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=xfs_healer background service slice
+Before=slices.target
+
+[Slice]
+
+# If the CPU usage cgroup controller is available, don't use more than 2 cores
+# for all background processes.  One thread to read events, another to run
+# repairs.
+CPUQuota=200%
+CPUAccounting=true
+
+[Install]
+# As of systemd 249, the systemd cgroupv2 configuration code will drop resource
+# controllers from the root and system.slice cgroups at startup if it doesn't
+# find any direct dependencies that require a given controller.  Newly
+# activated units with resource control directives are created under the system
+# slice but do not cause a reconfiguration of the slice's resource controllers.
+# Hence we cannot put CPUQuota= into the xfs_healer service units directly.
+#
+# For the CPUQuota directive to have any effect, we must therefore create an
+# explicit definition file for the slice that systemd creates to contain the
+# xfs_healer instance units (e.g. xfs_healer@.service) and we must configure
+# this slice as a dependency of the system slice to establish the direct
+# dependency relation.
+WantedBy=system.slice
diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index 5ed2198a0c1687..e594ad4fc2c53e 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -22,6 +22,7 @@ from concurrent.futures import ProcessPoolExecutor
 import ctypes.util
 from enum import Enum
 import collections
+import time
 
 try:
 	# Not all systems will have this json schema validation libarary,
@@ -1137,6 +1138,14 @@ def main():
 		pass
 
 	args.event_queue.shutdown()
+
+	# See the service mode comments in xfs_scrub.c for why we sleep and
+	# compress all nonzero exit codes to 1.
+	if 'SERVICE_MODE' in os.environ:
+		time.sleep(2)
+		if ret != 0:
+			ret = 1
+
 	return ret
 
 if __name__ == '__main__':
diff --git a/healer/xfs_healer.rules b/healer/xfs_healer.rules
new file mode 100644
index 00000000000000..c9bbb4c9f28186
--- /dev/null
+++ b/healer/xfs_healer.rules
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (c) 2024-2025 Oracle.  All rights reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+#
+# Start autonomous self healing automatically
+ACTION=="add", SUBSYSTEM=="xfs", ENV{TYPE}=="mount", RUN+="xfs_healer_start"
diff --git a/healer/xfs_healer@.service.in b/healer/xfs_healer@.service.in
new file mode 100644
index 00000000000000..1f74fc000ce490
--- /dev/null
+++ b/healer/xfs_healer@.service.in
@@ -0,0 +1,107 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Self Healing of XFS Metadata for %f
+
+# Explicitly require the capabilities that this program needs
+ConditionCapability=CAP_SYS_ADMIN
+ConditionCapability=CAP_DAC_OVERRIDE
+
+# Must be a mountpoint
+ConditionPathIsMountPoint=%f
+RequiresMountsFor=%f
+
+[Service]
+Type=exec
+Environment=SERVICE_MODE=1
+ExecStart=@pkg_libexec_dir@/xfs_healer --log %f
+SyslogIdentifier=%N
+
+# Create the service underneath the healer background service slice so that we
+# can control resource usage.
+Slice=system-xfs_healer.slice
+
+# No realtime CPU scheduling
+RestrictRealtime=true
+
+# xfs_healer avoids pinning mounted filesystems by recording the file handle
+# for the provided mountpoint (%f) before opening the health monitor, after
+# which it closes the fd for the mountpoint.  If repairs are needed, it will
+# reopen the mountpoint, resample the file handle, and proceed only if the
+# handles match.  If the filesystem is unmounted, the daemon exits.  If the
+# mountpoint moves, repairs will not be attempted against the wrong filesystem.
+#
+# Due to this resampling behavior, xfs_healer must see the same filesystem
+# mount tree inside the service container as outside, with the same ro/rw
+# state.  BindPaths doesn't work on the paths that are made readonly by
+# ProtectSystem and ProtectHome, so it is not possible to set either option.
+# DynamicUser sets ProtectSystem, so that also cannot be used.  We cannot use
+# BindPaths to bind the desired mountpoint somewhere under /tmp like xfs_scrub
+# does because that pins the mount.
+#
+# Regrettably, this leaves xfs_healer less hardened than xfs_scrub.
+# Surprisingly, this doesn't affect xfs_healer's score dramatically.
+DynamicUser=false
+ProtectSystem=false
+ProtectHome=no
+PrivateTmp=true
+PrivateDevices=true
+
+# Don't let healer complain about paths in /etc/projects that have been hidden
+# by our sandboxing.  healer doesn't care about project ids anyway.
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
+# xfs_healer needs these privileges to open the rootdir and monitor
+CapabilityBoundingSet=CAP_SYS_ADMIN CAP_DAC_OVERRIDE
+AmbientCapabilities=CAP_SYS_ADMIN CAP_DAC_OVERRIDE
+NoNewPrivileges=true
+
+# xfs_healer doesn't create files
+UMask=7777
+
+# No access to hardware /dev files except for block devices
+ProtectClock=true
+DevicePolicy=closed
+
+[Install]
+WantedBy=multi-user.target
+# If someone tries to enable the template itself, translate that into enabling
+# this service on the root directory at systemd startup time.  In the
+# initramfs, the udev rules in xfs_healer.rules run before systemd starts.
+DefaultInstance=-
diff --git a/healer/xfs_healer_start b/healer/xfs_healer_start
new file mode 100755
index 00000000000000..6f2d23318828d6
--- /dev/null
+++ b/healer/xfs_healer_start
@@ -0,0 +1,17 @@
+#!/bin/sh
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+# Start the xfs_healer service when the filesystem is mounted
+
+command -v systemctl || exit 0
+
+grep "^$SOURCE[[:space:]]" /proc/mounts | while read source mntpt therest; do
+	inst="$(systemd-escape --path "$mntpt")"
+	systemctl restart --no-block "xfs_healer@$inst" && break
+done
+
+exit 0

