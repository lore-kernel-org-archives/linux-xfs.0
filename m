Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E5E226D02
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801640; cv=none; b=nWNeVuj9sUZokGRjqubc6K0+rnsraQ/PdmvVr5lzLgWcfpYUbn6DLrQkP+h+ZYJuQ+yZxrWgKmivmHtGsO86IhbHPF7gzGRM/5Cw+4QTzEQ/8PgtxkPQmnGOAJ0mNVp+uE0RtpDkg0rZS2Bx5M2xhFT6AB0pOEK3+x2QFA2wc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801640; c=relaxed/simple;
	bh=Bu+6cuGV5xkSN/Tcx1dUAgmRj/uq1+d9JGsw2Kre4tQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h84pBn9ra2nUveUdDaJMRxKny01t3z3ypaEABpe9kozVGc+rzkFrStF4aBP2MV7z0RpGJPNGcwzaf0vFbmPyB4QNRus/Grwqom92ntg1naTmf6Gcy0xg4vB3aEeHFHf9k+scNyp5g8452L22dEVXQsjRf33dFHxr8W2PA9QXpCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZknzQGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZknzQGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C895C19421;
	Fri, 10 Apr 2026 06:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801640;
	bh=Bu+6cuGV5xkSN/Tcx1dUAgmRj/uq1+d9JGsw2Kre4tQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AZknzQGyC5Kn6hY4Y7bofLtQxE2kYsd17AwTy+94FA8VoTbClekdOL3NVjFN7bCpE
	 LS7/8ebGycI/FBgiCNMWnCJddFj4QwYxz2zYHD1JPkzfHRaUjSk6Vu/ZMRqCsMdI7e
	 dpylQpMBLX/LSRAMf7fOrtAH9KQNhCtx5HO2KjXEwz3UALCoxfbfoZ/kbiW9OoEk26
	 gdGgsyK/rtQQWDIBhSZRY71t+scmiDpt7thCo/kfimv8FfZwCnF40c53sX4VlHzP1O
	 w2SHLIujg1jINWhiOOxjXPNOwFIvxB+jTY3K/0M8N+jSgZHnzDoj5CiDTRaEq9KSsz
	 bJ4mdCDiuKjsQ==
Date: Thu, 09 Apr 2026 23:13:59 -0700
Subject: [PATCH 13/26] xfs_healer: create a per-mount background monitoring
 service
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384471.2089237.12226277543897733077.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
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
daemon so that we can run it for every mounted filesystem.  Add a
hidden switch so that we can print the service unit name for fstests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/xfs_healer.h            |    1 
 healer/Makefile                |   22 ++++++++
 healer/system-xfs_healer.slice |   31 ++++++++++++
 healer/xfs_healer.c            |   16 ++++++
 healer/xfs_healer@.service.in  |  107 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100644 healer/system-xfs_healer.slice
 create mode 100644 healer/xfs_healer@.service.in


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index 6d12921245934c..679bdc95ae48f8 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -26,6 +26,7 @@ struct healer_ctx {
 	int			everything;
 	int			foreground;
 	int			want_repair;
+	int			print_svcname;
 
 	/* fd and fs geometry for mount */
 	struct xfs_fd		mnt;
diff --git a/healer/Makefile b/healer/Makefile
index 981192b81af626..ee44aaee461250 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -22,7 +22,23 @@ LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
 
-default: depend $(LTCOMMAND)
+XFS_HEALER_SVCNAME=xfs_healer@.service
+CFLAGS += -DXFS_HEALER_SVCNAME=\"$(XFS_HEALER_SVCNAME)\"
+
+ifeq ($(HAVE_SYSTEMD),yes)
+INSTALL_HEALER += install-systemd
+SYSTEMD_SERVICES=\
+	system-xfs_healer.slice \
+	$(XFS_HEALER_SVCNAME)
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
 
@@ -32,6 +48,10 @@ install-healer: default
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
index 71afa0331c8c7e..d9ab53c153a456 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -424,6 +424,7 @@ enum long_opt_nr {
 	LOPT_HELP,
 	LOPT_QUIET,
 	LOPT_REPAIR,
+	LOPT_SVCNAME,
 
 	LOPT_MAX,
 };
@@ -455,6 +456,7 @@ main(
 		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
 		[LOPT_QUIET]	   = {"quiet", no_argument, &ctx.log, 0 },
 		[LOPT_REPAIR]	   = {"repair", no_argument, &ctx.want_repair, 1 },
+		[LOPT_SVCNAME]	   = {"svcname", no_argument, &ctx.print_svcname, 1 },
 
 		[LOPT_MAX]	   = {NULL, 0, NULL, 0 },
 	};
@@ -491,6 +493,20 @@ main(
 
 	ctx.mntpoint = argv[optind];
 
+	if (ctx.print_svcname) {
+		char	unitname[PATH_MAX];
+
+		ret = systemd_path_instance_unit_name(XFS_HEALER_SVCNAME,
+				ctx.mntpoint, unitname, sizeof(unitname));
+		if (ret) {
+			perror(ctx.mntpoint);
+			return EXIT_FAILURE;
+		}
+
+		printf("%s\n", unitname);
+		return EXIT_SUCCESS;
+	}
+
 	ret = setup_monitor(&ctx);
 	if (ret)
 		goto out_events;
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

