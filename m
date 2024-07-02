Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E206FCB
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882360; cv=none; b=P1dNjbwfz2qXW5ljiLykv2Gz6DktdZHzW06olHrgDQC6E6b6qH2HNcLPwE/9zb32XRH8BnO0awP+m7aMSMDogiim5HsFknve472uf5LnzSWM6r5wT7XPt9FIRU14bvby6i7NtGcSW5YVskKBXtpY3Buaqr0/jyhcZBga/0cQSGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882360; c=relaxed/simple;
	bh=x4eutwcjUDCv9hEzlUvjhvuK9PmVDMz0xpRVOLRV4Uc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZO5e7+LYg4hQvuCyPnOAhuidUoU0fY/C3G4Tqnxsr6Fv4Woi0SimTYosiIXj1Rv4tawP+4/Qsq00Ntr0VtRp9H9GiTde3PZjmHDxzWAN4ZwOjMfvq8AJeFk0ffCdaKu33iHz4K1WUFUC0WgCHhk71IN0kVln7DS+HZCxV1+DuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QD34tzOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QD34tzOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BA2C116B1;
	Tue,  2 Jul 2024 01:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882360;
	bh=x4eutwcjUDCv9hEzlUvjhvuK9PmVDMz0xpRVOLRV4Uc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QD34tzOyVbggmr8QsW1fZrPg01D1d6+nbQfzoaRVjWUskKiIIEQn9Bjis09JmpXiY
	 z90ndH3JptBPuGXjQnfvkSyhpmagOOFB2oBL7slxSSKAEQzXeXILKXn9Mk0O4zRiXH
	 XYX9Mscsop7KtkrWGYgpFt54kQ6VuK5vm4c3bRO6vl4mYD7LDtIfoxaYZZHKmT2TLg
	 gnrjichHnlUjAN2TM5t0YiQG8dbUNeawhl7qMg4GepReTPNc6oW/h5OMEkZNd3TwF2
	 LaQRXPSsudKZm+oy0jo2KJefyzz9OdXApXzvXe5TIDsfb2sQOY24Nl4hK0lypnpuN6
	 usun/TM8arRIQ==
Date: Mon, 01 Jul 2024 18:06:00 -0700
Subject: [PATCH 5/6] xfs_scrub_fail: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119082.2008208.12273526437995077384.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub_fail has to run with enough privileges to access
the journal contents for a given scrub run and to send a report via
email.  Minimize the risk of xfs_scrub_fail escaping its service
container or contaminating the rest of the system by using systemd's
sandboxing controls to prohibit as much access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub_fail@.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail@.service.in |   55 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)


diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 32012ec35366..2c879afd6d8e 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -18,3 +18,58 @@ SupplementaryGroups=systemd-journal
 # Create the service underneath the scrub background service slice so that we
 # can control resource usage.
 Slice=system-xfs_scrub.slice
+
+# No realtime scheduling
+RestrictRealtime=true
+
+# Make the entire filesystem readonly and /home inaccessible.
+ProtectSystem=full
+ProtectHome=yes
+PrivateTmp=true
+RestrictSUIDSGID=true
+
+# Emailing reports requires network access, but not the ability to change the
+# hostname.
+ProtectHostname=true
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+
+# Can't hide /proc because journalctl needs it to find various pieces of log
+# information
+#ProcSubset=pid
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
+CapabilityBoundingSet=
+NoNewPrivileges=true
+
+# Failure reporting shouldn't create world-readable files
+UMask=0077
+
+# Clean up any IPC objects when this unit stops
+RemoveIPC=true
+
+# No access to hardware device files
+PrivateDevices=true
+ProtectClock=true

