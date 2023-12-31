Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5B1C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUk/4Ekj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348A9C433C8;
	Sun, 31 Dec 2023 22:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063422;
	bh=CRT6+7XJjVytP/pdcxGP04oLLNV+H26lOrSrxSGGjbY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GUk/4EkjAA5kCfmUkMm/y7ty4CO2BOkcWC2ls2Uz4xhzCUgaGOhm2ueMI7ghYgjsw
	 JytbAY5k0fcYfYtKhJClIldpRBNdVVOB54PybNtNuZCKPGqvKa2BGuRKaZmASVMMA1
	 XBjbRSeqzWxXmHg+9EikvpwoVapWmCXABypYNjyIbueNGdGf1kGoLqL55y3Fj0mFb3
	 nonLVPiYg6VcYYxoJnr+bVOFCo+lMkgqPD+NgtQwLLuQ4F89ZREFlVRVum1H0p+/wB
	 lmNE6TIMdxf9ewcfm+l5XeQHLgFdoU/BhFPPhvnOy4rldZgBU40gLopLxJiyFXbS5/
	 Ex+HgTysjLHMg==
Date: Sun, 31 Dec 2023 14:57:01 -0800
Subject: [PATCH 5/6] xfs_scrub_fail: tighten up the security on the background
 systemd service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405002672.1801298.17944033724602795810.stgit@frogsfrogsfrogs>
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
index dfbbd3b8218..4a40f3bdc85 100644
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

