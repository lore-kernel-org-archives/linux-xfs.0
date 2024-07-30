Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AABC2E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302065; cv=none; b=gsw2lf92Cfjww4+CfATUkm0lMVegrW+XlFFH546BhlWjshRwUWGJHVbp8naV5ljUp0/He0rN6Mz9OtGTMtsF+XD5gfIjbq68HHRPV5idx14JnDqriDD5AdtDCbmjNiGl+Ej55axYHTTm5n9RdRo0GQL6wnYCwNhkKpn7VZQJUqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302065; c=relaxed/simple;
	bh=GgjAx1j7O6l2CNrqPO3BBZ0+TmqPFkDbYYt95lAo/X8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eT+piGj+MsO5lgnBoAN1tSqWoEC6nbjZ1IHHYamST7x4ZtLFeCvem4HZwxygFRTe6cLJ/tEdKFisIwHsr1b+c8J3vbxMqj4ZIR6oUnr2Ie2AvDleq9IrAWrJdtSOyYZ4yYj5/xqwNXQko7ygeRDz00dhiy5RHARMG3xGfB1Q7zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mqXd+e2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mqXd+e2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E547C32786;
	Tue, 30 Jul 2024 01:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302065;
	bh=GgjAx1j7O6l2CNrqPO3BBZ0+TmqPFkDbYYt95lAo/X8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mqXd+e2q11vtq1JuBuzJJ6l68vpUdXux5EWpPuqEn7txVQ/JqN+tb50B9i2Zpeavz
	 pZOvsgm4Qbc88//SAecDdVKLnUvzC9JipsANvW70P64LmzA9t7fjHZSQV9mK5xUSPo
	 E0dqXTbkz90pLZgqs8PsQEfLkXjhfv7oceSITpr8f1p+lsOje5YzefKl/GJDv4mGOq
	 uKtxAgql5+p3oOLWay/aFPDZCC+Ma6Ua9JPwLRJLqmGb7fbjsufat9fkS4wdmkCOEL
	 RS/a0y6ID7u0XZ9nJ3ObarOpgHn0o+a86HEEwZg/TPsCjGQAxEKDEygYLlRXhrYGDL
	 qL6PUt//6El3Q==
Date: Mon, 29 Jul 2024 18:14:24 -0700
Subject: [PATCH 6/6] xfs_scrub_all: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848942.1349910.11059506353208746133.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub_all has to run with enough privileges to find
mounted XFS filesystems and the device associated with that mount and to
start xfs_scrub@<mountpoint> sub-services.  Minimize the risk of
xfs_scrub_all escaping its service container or contaminating the rest
of the system by using systemd's sandboxing controls to prohibit as much
access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub_all.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.service.in |   62 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)


diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 96be90e74..478cd8d05 100644
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

