Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F8C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxLU1coS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89624C433C7;
	Sun, 31 Dec 2023 22:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063406;
	bh=GtozBuGbD6GTmS4+4nYeFsCVVPkcsvTf+M3njZpXY2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UxLU1coSytJ0KNzTCy+jOk17+2UMjxxVTtZHHWznYZbdM4b54w3bfOEDjXewVFtbH
	 yEaBnELH1DmzW6L3nHIK8LnSGgUuEoFKcX/haXgar5moILpnZAhgrj/iY8U0+ZlXfG
	 NvyQpG6G6ulDVsfhTQFtK/h5WilnNRfxPkpeMsrLwaFA2aCEs/8SCnKQZyqP//w2Ih
	 M0HgDd5f6J7sgBVF0HBMjDCgBLO+pK5B5DnUHKDGV9XPI6JcEEf1Qds0IaPr8FwF8w
	 NK4rZaQ5Hs7EHzGkKXDwZ6LakiS8frGLDGiRNNmYDwVNjgFQQxRNuiDI2Q/Y9VGEvI
	 wyKz0NpPCgRVQ==
Date: Sun, 31 Dec 2023 14:56:46 -0800
Subject: [PATCH 4/6] xfs_scrub: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405002659.1801298.16325608720084880570.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub has to run with some elevated privileges.  Minimize
the risk of xfs_scrub escaping its service container or contaminating
the rest of the system by using systemd's sandboxing controls to
prohibit as much access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub@.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub@.service.in |   81 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 8 deletions(-)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 504d3606985..d834f26bd53 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -8,17 +8,21 @@ Description=Online XFS Metadata Check for %f
 OnFailure=xfs_scrub_fail@%i.service
 Documentation=man:xfs_scrub(8)
 
+# Explicitly require the capabilities that this program needs
+ConditionCapability=CAP_SYS_ADMIN
+ConditionCapability=CAP_FOWNER
+ConditionCapability=CAP_DAC_OVERRIDE
+ConditionCapability=CAP_DAC_READ_SEARCH
+ConditionCapability=CAP_SYS_RAWIO
+
+# Must be a mountpoint
+ConditionPathIsMountPoint=%f
+RequiresMountsFor=%f
+
 [Service]
 Type=oneshot
-PrivateNetwork=true
-ProtectSystem=full
-ProtectHome=read-only
-# Disable private /tmp just in case %f is a path under /tmp.
-PrivateTmp=no
-AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
-NoNewPrivileges=yes
 Environment=SERVICE_MODE=1
-ExecStart=@sbindir@/xfs_scrub @scrub_args@ %f
+ExecStart=@sbindir@/xfs_scrub @scrub_args@ -M /tmp/scrub/ %f
 SyslogIdentifier=%N
 
 # Run scrub with minimal CPU and IO priority so that nothing else will starve.
@@ -31,5 +35,66 @@ Nice=19
 # can control resource usage.
 Slice=system-xfs_scrub.slice
 
+# No realtime CPU scheduling
+RestrictRealtime=true
+
 # Dynamically create a user that isn't root
 DynamicUser=true
+
+# Make the entire filesystem readonly and /home inaccessible, then bind mount
+# the filesystem we're supposed to be checking into our private /tmp dir.
+# 'norbind' means that we don't bind anything under that original mount.
+ProtectSystem=strict
+ProtectHome=yes
+PrivateTmp=true
+BindPaths=%f:/tmp/scrub:norbind
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
+CapabilityBoundingSet=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
+AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
+NoNewPrivileges=true
+
+# xfs_scrub doesn't create files
+UMask=7777
+
+# No access to hardware /dev files except for block devices
+ProtectClock=true
+DevicePolicy=closed
+DeviceAllow=block-*

