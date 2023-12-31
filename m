Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D29C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsSqidfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9530C433C7;
	Sun, 31 Dec 2023 22:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063437;
	bh=ludDWoEU3jl5rvz0MW1d5sPSCM168JtAC+6xR/DCmOM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EsSqidfQvGyq3Ej3+pb9ULh3TnE+kQfs75QARW1HEnPD29SIKcGYrrZsUh/gxOztr
	 MfjyBJ4Fs4mSFUE/7sGGEfANFfh/93odZ2VXrvdAXhXMIcGEiGwIzRVSUjnkivbYVm
	 ZdriaiCHJejyw88oLM+l1MQUQzbbw52o9MVsMdGSsCwOOMOewBVgLPxsk+Ef1IrX7F
	 D2f4IUGL3dProIFbaRfe7r1MBYtqxfDoxr1/jWZ6dXGclly3o6wYkJWK+DNYfqpHgY
	 JmiwBOLBI5KWnnDxh5i+JTfBf7P9DXjyfF10LtJ0+l0brWXDdC8RuN6XNaKaqIUUY3
	 n+B2O+NwvvlsA==
Date: Sun, 31 Dec 2023 14:57:17 -0800
Subject: [PATCH 6/6] xfs_scrub_all: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405002685.1801298.8743272644460589764.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002602.1801298.14531646183046394491.stgit@frogsfrogsfrogs>
References: <170405002602.1801298.14531646183046394491.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub_all has to run with enough privileges to find
mounted XFS filesystems and the device associated with that mount and to
start xfs_scrub@<mountpoint> sub-services.  Minimize the risk of
xfs_scrub_all escaping its service container or contaminating the rest
of the system by using systemd's sandboxing controls to prohibit as much
access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub_all.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.service.in |   62 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)


diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 0f4bddf740a..f746f7b69f6 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -18,3 +18,65 @@ SyslogIdentifier=xfs_scrub_all
 # Create the service underneath the scrub background service slice so that we
 # can control resource usage.
 Slice=system-xfs_scrub.slice
+
+# Run scrub_all with minimal CPU and IO priority so that nothing will starve.
+IOSchedulingClass=idle
+CPUSchedulingPolicy=idle
+CPUAccounting=true
+Nice=19
+
+# No realtime scheduling
+RestrictRealtime=true
+
+# No special privileges, but we still have to run as root so that we can
+# contact the service manager to start the sub-units.
+CapabilityBoundingSet=
+NoNewPrivileges=true
+RestrictSUIDSGID=true
+
+# Make the entire filesystem readonly.  We don't want to hide anything because
+# we need to find all mounted XFS filesystems in the host.
+ProtectSystem=strict
+ProtectHome=read-only
+PrivateTmp=false
+
+# No network access except to the systemd control socket
+PrivateNetwork=true
+ProtectHostname=true
+RestrictAddressFamilies=AF_UNIX
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
+# Media scan stamp file shouldn't be readable by regular users
+UMask=0077
+
+# lsblk ignores mountpoints if it can't find the device files, so we cannot
+# hide them
+#ProtectClock=true
+#PrivateDevices=true

