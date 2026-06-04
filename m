Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CC13D45EA
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553109; cv=none; b=tnivL8FYqZuLJoWwUCHFJre8DPQUZHUrjjx253g2tPD+s37bliaZaRsa/8eB37LapTtsdMWA5t7LdlO60mhxsli6ZgrnofGIHEPG5DOxL8o2LeTZjGacs/SOpxJIg6QVoKeVAjUpT5J026X70+3ff+kYQilGCk+aOqkHsR/sCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553109; c=relaxed/simple;
	bh=z0izWv+CYbtx87s4ymh9X18iJvK9+jVwZhy2h1kOtFc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JF3mFXdcTiXoJXjS7zpF407iGQIwl8qAiFVgfLPDmQpnGaOcOjtrB3ZVriGo/HrIVgRNE1+zWyluhVVu93gzLjPgst6WuZbrYdpwA3jSOQ4Nxva/ZWDI2t2UmyzZcuDGGWrbCF98suyowYN501dVBaWeYKcG2ohhsIJ/cou3vAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i3LjK9sw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i3LjK9sw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2374C1F00893;
	Thu,  4 Jun 2026 06:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553108;
	bh=C4VIx8MSGX3nmckUNDt84Zero3hHk9+kq1aYrkS3FyI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=i3LjK9swTQMNYNksrfPvMsgYo9Qyxlex8tmGuUnnLgVVKmfYuxZOAOgl+rGfhkJqK
	 jf2luLWOU8RMSb37lVy0L3/qvLdtJdp3eWwRA6xx6pcexjsWT4O/bB85Wn0AE3JVrp
	 jkiFHKB3V+mWBr0RPrlcL7ETdocz54gfZvNJmzrP9pQz08ZpUZGMHV8FqO3Z3oa90g
	 ST6CzP2C5Cr06+ZHA3eOI5Sb2VcR3zt7nDVAemLed68RwotqAisQ5X2z1TWQ6glgFP
	 t9ROhKMLpP6bRYXrEOKhS1J0TOKIIsaptwgRnjFCvwVl5nuf/PJiXbCbQZHSN80Y3R
	 MEHCgxKTA/RUg==
Date: Wed, 03 Jun 2026 23:05:07 -0700
Subject: [PATCH 03/21] xfs_scrub_all_fail: reduce security lockdowns to avoid
 postfix problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303164.2608728.5936112369383781102.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The same lockdown logic of commit 9042fcc08eed6a ("xfs_scrub_fail:
tighten up the security on the background systemd service") was applied
to the media scan failure reporting service.  Therefore, it's also
broken on systems that have setgid mailer programs (e.g. postfix).  Fix
this by applying the same change from commit 15fd6fc686d5ce here too.

While we're at it, put this service in the background scrub slice for
resource control.

Cc: <linux-xfs@vger.kernel.org> # v6.17.0
Fixes: 15fd6fc686d5ce ("xfs_scrub_fail: reduce security lockdowns to avoid postfix problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub_all_fail.service.in |   59 ++++-------------------------------
 1 file changed, 6 insertions(+), 53 deletions(-)


diff --git a/scrub/xfs_scrub_all_fail.service.in b/scrub/xfs_scrub_all_fail.service.in
index 53479db8477175..e11ca5460457a7 100644
--- a/scrub/xfs_scrub_all_fail.service.in
+++ b/scrub/xfs_scrub_all_fail.service.in
@@ -15,57 +15,10 @@ User=mail
 Group=mail
 SupplementaryGroups=systemd-journal
 
-# No realtime scheduling
-RestrictRealtime=true
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice
 
-# Make the entire filesystem readonly and /home inaccessible.
-ProtectSystem=full
-ProtectHome=yes
-PrivateTmp=true
-RestrictSUIDSGID=true
-
-# Emailing reports requires network access, but not the ability to change the
-# hostname.
-ProtectHostname=true
-
-# Don't let the program mess with the kernel configuration at all
-ProtectKernelLogs=true
-ProtectKernelModules=true
-ProtectKernelTunables=true
-ProtectControlGroups=true
-ProtectProc=invisible
-RestrictNamespaces=true
-
-# Can't hide /proc because journalctl needs it to find various pieces of log
-# information
-#ProcSubset=pid
-
-# Only allow the default personality Linux
-LockPersonality=true
-
-# No writable memory pages
-MemoryDenyWriteExecute=true
-
-# Don't let our mounts leak out to the host
-PrivateMounts=true
-
-# Restrict system calls to the native arch and only enough to get things going
-SystemCallArchitectures=native
-SystemCallFilter=@system-service
-SystemCallFilter=~@privileged
-SystemCallFilter=~@resources
-SystemCallFilter=~@mount
-
-# xfs_scrub needs these privileges to run, and no others
-CapabilityBoundingSet=
-NoNewPrivileges=true
-
-# Failure reporting shouldn't create world-readable files
-UMask=0077
-
-# Clean up any IPC objects when this unit stops
-RemoveIPC=true
-
-# No access to hardware device files
-PrivateDevices=true
-ProtectClock=true
+# No further restrictions because some installations may have MTAs such as
+# postfix, which require the ability to run setgid programs and other
+# foolishness.

