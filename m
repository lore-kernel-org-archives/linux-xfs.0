Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D04F79CC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882376; cv=none; b=rmnjQwR75QI1cfZGZZf8D86MzlXiWs779zLvwZqTz/tCTCZb1e/KA+68vurWhw/LuaBOhctLWslU2UEVEZQr3pgy2FfLuzaS8ZIW5N39EK8sMfSvUPrka+vAfj1ZHCay5SAwH3CZI8XfOVdhRzSajhx+erVWWLix70x5msLRhhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882376; c=relaxed/simple;
	bh=RVXQhExL0prrk+NCxWMc2eTLUuEcaMpYH6p7JAFGxZc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwhjYT2ulSxoFjOyNBzAQi+vOUKJ4HiSOJq9o4jbIJP/E6STxoskT9Pish+ZVfUWsFnWMUoEcz83CCFhVcixoRex+qcF/n0UMqHxyYwDr6Rx2buGS5iaGX5Gnm6S+hn/+4ELqTZ1YWZhptzru84nm+S06HoKxc5RlcF3aBdLTKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tkp2YTqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tkp2YTqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248B0C116B1;
	Tue,  2 Jul 2024 01:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882376;
	bh=RVXQhExL0prrk+NCxWMc2eTLUuEcaMpYH6p7JAFGxZc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tkp2YTqLO4iISpp/jJSDt0qGp96U6+KtmiSd6Mwtfx7jKINOVoEYjdppAHTSP8qfB
	 dP6ojzIQ0PSYk6QNSx0RK4wSS4U2kcuyOqquVGDdDkJ8nUm2PTRCO6bZiKE9RosZv6
	 1MiRpPT+JD/P1dFA9W3yB2tdbwCe1iYmLsq1E9eeHj3xfZ/aTkA6Ya+kyL43exdLJT
	 v2eiQoDcN8eGf6GFhqp5saMC3VDOzIg2nyGX5IU7I+vHwnKtIpLbkYRW5+hhJPXy9J
	 4UruuX64ri6YFwaSHf+DK4a0BeiGgJbd3GXXug+dze5xPNfA68hpUbUxsjp2dKjbXx
	 axTMsg9iGXOuA==
Date: Mon, 01 Jul 2024 18:06:15 -0700
Subject: [PATCH 6/6] xfs_scrub_all: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119097.2008208.5897497587818401006.stgit@frogsfrogsfrogs>
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
index 96be90e74ee6..478cd8d057a2 100644
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

