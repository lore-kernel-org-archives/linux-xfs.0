Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A218BF0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302034; cv=none; b=pK9Uqll+BdrjM7MLgs5A7xZrA+GB7bsoQtovOJzHzjpBIe67/dR33HZBrye/91ij5TwaCNPP+i4xk5mDuxEFnX3HrYokoI/Bc30hafNI81wexHNN6oqVI+dxc/eVpryUO5MX5gpR5WlL9oY9yQi3ItHMp94oLhetWYtBbkXJIWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302034; c=relaxed/simple;
	bh=9Zon9OVzk55dODAtcu5JzGThuhwNdEYt2V3Wnqm9BnY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ncHp1XzzAweJKVCctBqTybxzbYsjR+/szUiXYVrm0jzA3Uz9FVjOyHcKrwuYX0jrJnGO6gl3odxItNd+hZAZYwv0lmURrCY/jpiwXs6XiunLIxgFZHOd6yZvE0jQrlIPDS9iF3k09xNf678/PmFSG84AwTSeCrfDL+vlo3yovDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FbP8Y4PO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FbP8Y4PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8071C32786;
	Tue, 30 Jul 2024 01:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302033;
	bh=9Zon9OVzk55dODAtcu5JzGThuhwNdEYt2V3Wnqm9BnY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FbP8Y4POf1R28jIkeU6XFZPr5tArqH5Wkb78Gb2FYM0R/JgFp+4KpxE+fbwmdMNYx
	 tww46Yh0i7INrUOV+i8ZmFgP9fKWwEbxh+dLYFk1tZE6428FrrIdVThdLLlhiUzZt2
	 sScuHV+lLA32LVVCuoJ9cm3To33XoedFVBFUgGCQaZqtgUOH+EeftBKv25hKBJ2Dgz
	 jp7QjweoYt3BvuLUEIZkkAohxJ38Q3xiraZuzQxbInBCAPgZ5PLi26lsVs2X3kLYzK
	 LyP3BAkIuS/jAYWXzH1l7FTaFXpbd+Q6XmvEzZNo8s3X197bM926cv/XrKF0pL0L6o
	 7WaEUqowMK64g==
Date: Mon, 29 Jul 2024 18:13:53 -0700
Subject: [PATCH 4/6] xfs_scrub: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848917.1349910.13460116022520022971.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848851.1349910.300458734867859926.stgit@frogsfrogsfrogs>
References: <172229848851.1349910.300458734867859926.stgit@frogsfrogsfrogs>
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
index 52068add8..a8dd9052f 100644
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

