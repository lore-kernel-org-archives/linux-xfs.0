Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AF44A06
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882345; cv=none; b=bNxlPey9qim9Ns0BjWoO13a2qb1H5X0Glb094BRoYg/X9Lenqwz3gXjTHU8G7A2W78IxQpCO/qYmZ6QcN8Hrs4vkOshhTfJctK5K/Cbl4K4CV7cEGwY3d9nBSL4JVqf4/SafnM00BFUTgHm9dPitQG2U7KyG5kBn/fz77Zo0rRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882345; c=relaxed/simple;
	bh=Ki/m6hbBw5WA3SFG0UiJ4oWE+fecQhitDqih3j1v8SI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LlROCcdylr4Dylyu1EgwoqHdY3BLZEJHWe52qUTrJvu/yoVNZ10urmJ7VNvE/zxBkb3JTOby6dBW3J6ELulK9nxvc9HI1fmo6qnnwMezkw4PAHxBKVbuBz7EyyN/Omo081eI7oxnA0j/LAiSPjgqcyTszyfWW2fPMxo8rkptqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjqzK0SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjqzK0SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC502C116B1;
	Tue,  2 Jul 2024 01:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882344;
	bh=Ki/m6hbBw5WA3SFG0UiJ4oWE+fecQhitDqih3j1v8SI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fjqzK0SHsARVP3i1yXFt9sM6XHVRbWCD66K+UaT1IyTqbQL0jx9kuvwiX7uuq/xi5
	 dIUxhmAEgSxxIYAmOYR0aq6rcPuj9SzFgAD03MQwJp9mblNrOrToMB+OLI7pswBCD9
	 Ol6uE27uLlxeuvv7+KtCzXr1iAtAc8Kt5AqegSiEpNoqTSkvd7KiACGIyDgCrbXPtt
	 VcVCgJ7Ua+AJneGeieC3NL7f9DizdpS9LhRTgUIgN5Mb98s2Y2p06VVcyilLbnN8qW
	 kYtUusHX/n6WoJWcMtOGuw7ejr4YH2TOixS1wudpX5MX7GV5Q+3sDtbsuiMt+6xI2K
	 bJq9yiZ67Zn/Q==
Date: Mon, 01 Jul 2024 18:05:44 -0700
Subject: [PATCH 4/6] xfs_scrub: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119067.2008208.15565100581130657110.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs>
References: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs>
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
index 52068add834d..a8dd9052f0e0 100644
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

