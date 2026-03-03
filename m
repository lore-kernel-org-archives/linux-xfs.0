Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C5122CBC6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498218; cv=none; b=hMAGhsVba+7Mnsi9LZ1MDw29PoU2VXUUdkAjt04Qo/VmOz8O6WGAwA0M/J2YSS8EjpaQ2gQkPjUPjAtVbZ/GdiluaGkdYxCZ7OA8U2aGx+gZivm1wAQpo9TNDDSCJ3bd89wtXCB2MrYyzw5th41ikk0Qm/eEtg476BXOl7Wbi/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498218; c=relaxed/simple;
	bh=F91GBlRb9pcpzGdP+QI1Slrt54hqMHtx9C5/JlfPr4Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIpJ25OQclZhj2wasJFGoH8g3hk91/++qzj1tnOYTPXFAoH/BzBCB+tccEoVLaPiyamO+LlRLWutrA9LCguF4//WNT9lfgAQcDKQAykb7p2dETdOm2kuo0fnT4/jGVGmSeaivzVFb7FG9iaAqbVFYCVMYBpSUadzdTx6t3N0yDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frfxd+Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frfxd+Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78DEC19423;
	Tue,  3 Mar 2026 00:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498218;
	bh=F91GBlRb9pcpzGdP+QI1Slrt54hqMHtx9C5/JlfPr4Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=frfxd+RmfOdeh1vdjMRAP7vuG/Pv8ooI2g9lVHvPkhjhaBrageCIXCdM8kSZEQ6NA
	 +CuJSUN20hL8VsaWKS8zpCTHkzPEYmHFD+TWHpFoGZEj/+WpVMq4hColLGYS7g7eX+
	 M4w11prQVj8dYzshLTqk4bp6VQkNEfUq2WgjxE3ABq2NUxdJUKfn4+xhc3oPWrfr2c
	 T518PcYNHNIwkI1D9N+Z6DRPXYJ7Rb8Pcza9IFZFoSpNGa+b+aqgdv2g9rpLB01Xzd
	 XIrjaGlSPFw4kDnrd0miX+Sz0poTjrSOB9VnVCAmQwv49tlFLmZNvuI9E5RRQ1QD6t
	 OK03ngfdpfKFw==
Date: Mon, 02 Mar 2026 16:36:57 -0800
Subject: [PATCH 12/26] xfs_healer: create a per-mount background monitoring
 service
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783509.482027.13001515079400864128.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a systemd service definition for our self-healing filesystem
daemon so that we can run it for every mounted filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile                |   19 +++++++
 healer/system-xfs_healer.slice |   31 ++++++++++++
 healer/xfs_healer.c            |    3 +
 healer/xfs_healer@.service.in  |  107 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 158 insertions(+), 2 deletions(-)
 create mode 100644 healer/system-xfs_healer.slice
 create mode 100644 healer/xfs_healer@.service.in


diff --git a/healer/Makefile b/healer/Makefile
index 981192b81af626..86d6f50781f9b6 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -22,7 +22,20 @@ LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
 
-default: depend $(LTCOMMAND)
+ifeq ($(HAVE_SYSTEMD),yes)
+INSTALL_HEALER += install-systemd
+SYSTEMD_SERVICES=\
+	system-xfs_healer.slice \
+	xfs_healer@.service
+OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
+endif
+
+default: depend $(LTCOMMAND) $(SYSTEMD_SERVICES)
+
+%.service: %.service.in $(builddefs)
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
+		   < $< > $@
 
 include $(BUILDRULES)
 
@@ -32,6 +45,10 @@ install-healer: default
 	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
 	$(INSTALL) -m 755 $(LTCOMMAND) $(PKG_LIBEXEC_DIR)
 
+install-systemd: default
+	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
+	$(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
+
 install-dev:
 
 -include .dep
diff --git a/healer/system-xfs_healer.slice b/healer/system-xfs_healer.slice
new file mode 100644
index 00000000000000..b8f5bca03963ff
--- /dev/null
+++ b/healer/system-xfs_healer.slice
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
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
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index c9892168c706cb..2f431f18c69318 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -12,6 +12,7 @@
 #include "libfrog/paths.h"
 #include "libfrog/healthevent.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/systemd.h"
 #include "xfs_healer.h"
 
 /* Program name; needed for libfrog error reports. */
@@ -470,5 +471,5 @@ main(
 	teardown_monitor(&ctx);
 	free((char *)ctx.fsname);
 out:
-	return ret != 0 ? EXIT_FAILURE : EXIT_SUCCESS;
+	return systemd_service_exit(ret);
 }
diff --git a/healer/xfs_healer@.service.in b/healer/xfs_healer@.service.in
new file mode 100644
index 00000000000000..385257872b0cbb
--- /dev/null
+++ b/healer/xfs_healer@.service.in
@@ -0,0 +1,107 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
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
+ExecStart=@pkg_libexec_dir@/xfs_healer %f
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

