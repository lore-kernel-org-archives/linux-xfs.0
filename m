Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7FD4A2D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302049; cv=none; b=LsHbBN6QzA1wjOgZJkI4FKBnsD2FDqA8NYnoQnRvjfx9SeobPa2/dYcOgYyL64RkuXKxoOJX9JsUgIGAu/6Git4jA8xDF+kIGofwE+AR24h8bIh5nSxIiZ8HpFONRuEO6nDRX4qVR+QBPqDd313lyVkr5pb5teh/7T4pIZBHGXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302049; c=relaxed/simple;
	bh=ZaBVXanaXH0DpsAv6YP/hy7X+vdluMY/FjohbzHKzfw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5CQ1I6T22FWw0Gwb9LUltHDP66xsOLhisOFPCoXcnr1SklJ/RfMKgXzMTQ4cvxA1+MpdmhKJjU1lR8ld7Xj3eUiQyc/5WixrOTHqqT99lUjG0za9RrTj0C1Wuf7zX/pbad4AogvPypfSY5ApJkComY6rK7aM/4iYTFhhgv1hMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qv6OacO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qv6OacO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72642C32786;
	Tue, 30 Jul 2024 01:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302049;
	bh=ZaBVXanaXH0DpsAv6YP/hy7X+vdluMY/FjohbzHKzfw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qv6OacO1tq5+vrXwH56yOb1g7xldeGZR1TBBhBH5wNe2U2spXHtIdr6JqL4FoWkYr
	 Z9U+KtMxqBbmvCeY1akX+Ewfyu94ik/bS6r73O9FExNILameyebZ+k+2MEBGPlXkO4
	 IW3mNpP+R5QERReQEm7rOrUjr+N+W7fLaOfwQkQdvbN8yu0Cdm+gwuvEQmIte9im2p
	 GzKTqFABwRriTt++FFk3JgVnO2cSUp/KNsRaDTSqm56jmU18XAUU0kGQ/GEVfYLUwd
	 ce+g5b5Jmajxn0fqIiuGNwPKKyLcoNGO4eTk/BU3YKWG5cZyB3ylP4yzNW0isDDNes
	 kHT9if6ZMyNFg==
Date: Mon, 29 Jul 2024 18:14:08 -0700
Subject: [PATCH 5/6] xfs_scrub_fail: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848929.1349910.8374450657608066953.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub_fail has to run with enough privileges to access
the journal contents for a given scrub run and to send a report via
email.  Minimize the risk of xfs_scrub_fail escaping its service
container or contaminating the rest of the system by using systemd's
sandboxing controls to prohibit as much access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub_fail@.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_fail@.service.in |   55 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)


diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 32012ec35..2c879afd6 100644
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

