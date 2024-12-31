Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8838729415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689129; cv=none; b=VfnYXEhC4TD3aznRdeC3dzMgD7wMoI9v5W6lG72jhM9AXzZuadyQ1wKhW8M+2nPpkawSYxrc6PffXTNZ0dnFe71VyuO94wrY8LenhuuCQPGd3BI0yyQrQd9rD9OLjVUcBQ6V5xrWFqDnHAOSTZz5BYMISos4XScYSDmoZM8S7HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689129; c=relaxed/simple;
	bh=08Ckdi8mNaeblSNZJERNI12xCexDUc7fJvBQ+qBIXuo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ShEqLxaKesZbQJNTOm0SqOqzZyuIZ3OdA7AGsbBvZzM5PUueav9g4gQ14ZWNV5m5Skqwckm1n7SWKyJfxS+0/qeV62HhyKtgmWvHW0A6HvQ0nbbV1aIgborHSeVwtnaafMTiq1rHALpzd7z8yl4CO4K/mXBiS5j4hAMnkA4yC/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=booNxzHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="booNxzHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20467C4CED2;
	Tue, 31 Dec 2024 23:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689129;
	bh=08Ckdi8mNaeblSNZJERNI12xCexDUc7fJvBQ+qBIXuo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=booNxzHaWbkLPC+Uw9HJkRIT9l1VlQz6h1kXfACZJRJqlwnDcWGGRB2Rro46p/0fx
	 YCnT2upifLXiuPvhJF3/JtcxJnil8XENomaNPLAP7WlVYGEeotb/2+kwV5OxFCB+nN
	 +goshFM3Yu4PwDPX18P5vQlE8S13u+1Y16azZrS45poJsyklmBXkyrD1MXUdKd8WpP
	 Hsn83I/iIySStJK9SlrKcYkuh/MwPRDMicoqTEJNLxLl1cyTlTNpcqnVUpqCr/kUEv
	 1zEKLg9mGXMQ93JRHw734oA+IDYDFxAb6N6DIfAP+lGMhXz+vcQxeMd7zE8GU1kH7N
	 Y1Pvn3EMhgmSw==
Date: Tue, 31 Dec 2024 15:52:08 -0800
Subject: [PATCH 17/21] xfs_scrubbed: create a background monitoring service
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778722.2710211.17201402564311213099.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/Makefile                 |   18 +++++++
 scrub/xfs_scrubbed.in          |    9 +++
 scrub/xfs_scrubbed.rules       |    7 +++
 scrub/xfs_scrubbed@.service.in |  103 ++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrubbed_start       |   17 +++++++
 5 files changed, 153 insertions(+), 1 deletion(-)
 create mode 100644 scrub/xfs_scrubbed.rules
 create mode 100644 scrub/xfs_scrubbed@.service.in
 create mode 100755 scrub/xfs_scrubbed_start


diff --git a/scrub/Makefile b/scrub/Makefile
index 7d4fa0ddc09685..731810d7c7fd9a 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -29,8 +29,16 @@ SYSTEMD_SERVICES=\
 	xfs_scrub_all.service \
 	xfs_scrub_all_fail.service \
 	xfs_scrub_all.timer \
-	system-xfs_scrub.slice
+	system-xfs_scrub.slice \
+	xfs_scrubbed@.service
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
+
+ifeq ($(HAVE_UDEV),yes)
+	XFS_SCRUBBED_UDEV_RULES = xfs_scrubbed.rules
+	XFS_SCRUBBED_HELPER = xfs_scrubbed_start
+	INSTALL_SCRUB += install-udev-scrubbed
+	OPTIONAL_TARGETS += $(XFS_SCRUBBED_HELPER)
+endif
 endif
 ifeq ($(HAVE_CROND),yes)
 INSTALL_SCRUB += install-crond
@@ -185,6 +193,14 @@ install-udev: $(UDEV_RULES)
 		$(INSTALL) -m 644 $$i $(UDEV_RULE_DIR)/64-$$i; \
 	done
 
+install-udev-scrubbed: $(XFS_SCRUBBED_HELPER)
+	$(INSTALL) -m 755 -d $(UDEV_DIR)
+	$(INSTALL) -m 755 $(XFS_SCRUBBED_HELPER) $(UDEV_DIR)
+	$(INSTALL) -m 755 -d $(UDEV_RULE_DIR)
+	for i in $(XFS_SCRUBBED_UDEV_RULES); do \
+		$(INSTALL) -m 644 $$i $(UDEV_RULE_DIR)/64-$$i; \
+	done
+
 install-dev:
 
 -include .dep
diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index a4e073b3098f7a..9df6f45e53ad80 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -19,6 +19,7 @@ import gc
 from concurrent.futures import ProcessPoolExecutor
 import ctypes.util
 import collections
+import time
 
 try:
 	# Not all systems will have this json schema validation libarary,
@@ -994,6 +995,14 @@ def main():
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
diff --git a/scrub/xfs_scrubbed.rules b/scrub/xfs_scrubbed.rules
new file mode 100644
index 00000000000000..c651126d5373a1
--- /dev/null
+++ b/scrub/xfs_scrubbed.rules
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (c) 2024-2025 Oracle.  All rights reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+#
+# Start autonomous self healing automatically
+ACTION=="add", SUBSYSTEM=="xfs", ENV{TYPE}=="mount", RUN+="xfs_scrubbed_start"
diff --git a/scrub/xfs_scrubbed@.service.in b/scrub/xfs_scrubbed@.service.in
new file mode 100644
index 00000000000000..9656bdb3cd9a9d
--- /dev/null
+++ b/scrub/xfs_scrubbed@.service.in
@@ -0,0 +1,103 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Self Healing of XFS Metadata for %f
+Documentation=man:xfs_scrubbed(8)
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
+ExecStart=@pkg_libexec_dir@/xfs_scrubbed --log %f
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
+# xfs_scrubbed needs these privileges to open the rootdir and monitor
+CapabilityBoundingSet=CAP_SYS_ADMIN CAP_DAC_OVERRIDE
+AmbientCapabilities=CAP_SYS_ADMIN CAP_DAC_OVERRIDE
+NoNewPrivileges=true
+
+# xfs_scrubbed doesn't create files
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
+# initramfs, the udev rules in xfs_scrubbed.rules run before systemd starts.
+DefaultInstance=-
diff --git a/scrub/xfs_scrubbed_start b/scrub/xfs_scrubbed_start
new file mode 100755
index 00000000000000..82530cf7862717
--- /dev/null
+++ b/scrub/xfs_scrubbed_start
@@ -0,0 +1,17 @@
+#!/bin/sh
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
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

