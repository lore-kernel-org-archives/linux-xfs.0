Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B84B296BD4
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 23:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760398629; cv=none; b=SisL4u0Sve+PvyCFPE4f2EMMkmKYbSZHapRtWIxbiq2Px+NMCqTCjxUH0SjQUnhO4j6tDJYA4aQawy/A7y3H2yU6mLATvc+e1LrBww385YfJpuQqfy9qRilV+2dt7tnkq9Vu5hC3gHHu7u6OX3ZFNF4xC5CBIZo5sf0lNo5RIJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760398629; c=relaxed/simple;
	bh=8p5h8ubpwH2DC6Eo2rzvAs6CsYoCfO34jLCN/ex+Nbc=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition; b=Umg+uIPchyVKOPt/9GCyxIiPl+yeL2mCK9veENDXnSpzIvRE0bHs6VvY14LTmTc1U/iYDUfVvb9T4v3Tm8gD7KWHHQwQJWcx0EFjFfvq8OH1Veg+BPPpyqK7tEcEC+/GriOTg4itPsh7PcuH0xIXxtmuA1xReo6vjZg6mNIk9z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2HXLi+E reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2HXLi+E"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1v8S6C-00BLId-2L;
	Mon, 13 Oct 2025 23:37:04 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1116595: [PATCH] xfs_scrub_fail: reduce security lockdowns to avoid postfix problems
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1116595@bugs.debian.org
Resent-From: "Darrick J. Wong" <djwong@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Mon, 13 Oct 2025 23:37:04 +0000
Resent-Message-ID: <handler.1116595.B1116595.17603984662701927@bugs.debian.org>
X-Debian-PR-Message: followup 1116595
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <aNmt9M4e9Q6wqwxH@teal.hq.k1024.org>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1116595-submit@bugs.debian.org id=B1116595.17603984662701927
          (code B ref 1116595); Mon, 13 Oct 2025 23:37:04 +0000
Received: (at 1116595) by bugs.debian.org; 13 Oct 2025 23:34:26 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 36; hammy, 150; neutral, 208; spammy,
	0. spammytokens: hammytokens:0.000-+--Signed-off-by,
	0.000-+--Signedoffby, 0.000-+--journalctl, 0.000-+--UD:slice,
	0.000-+--HCc:D*kernel.org
Received: from sea.source.kernel.org ([2600:3c0a:e001:78e:0:1991:8:25]:51052)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <djwong@kernel.org>)
	id 1v8S3e-00BKt3-1p
	for 1116595@bugs.debian.org;
	Mon, 13 Oct 2025 23:34:26 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE7694524D;
	Mon, 13 Oct 2025 23:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A507AC4CEE7;
	Mon, 13 Oct 2025 23:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760398464;
	bh=8p5h8ubpwH2DC6Eo2rzvAs6CsYoCfO34jLCN/ex+Nbc=;
	h=Date:From:To:Cc:Subject:From;
	b=c2HXLi+EzLjQpMqYkVjpVDid3J03fGZFnd/3GiYu7xxqj14ChCQF896Pe7ED20bLN
	 oiyYNcH+lPq1lO+99T9lO8MmcJwVlCBTwVQekU/J6l6VGKk8Z1BFnZoQfX5ULE3eWd
	 1255fsYXu9cFToY/uiyLrvXN84o+4bVaMuot48OSha8Fol6kuN7WNyu3HCI54NpREg
	 ByIzi5WcQTtTQ70AxgZB3LC2tK6MjAhVo7rSgufgEeuq2IFNGmACNIFw7uSiZ7udX5
	 pQ5EtEAQ6X5GI7J4eAhA6gXtVYy7cOkxCKTUTWGOQa/uQKe2wwuUUfQTlhq4a4LtVG
	 OualN1dpMPFSA==
Date: Mon, 13 Oct 2025 16:34:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: 1116595@bugs.debian.org, Iustin Pop <iustin@debian.org>,
	xfs <linux-xfs@vger.kernel.org>
Message-ID: <20251013233424.GT6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Greylist: delayed 411 seconds by postgrey-1.37 at buxtehude; Mon, 13 Oct 2025 23:34:26 UTC
Message-ID: <20251013233424.IKX4V9KjyP7ahTNZUxZE71m8MaEWz2fVJ5AQoAI-keM@z>

From: Darrick J. Wong <djwong@kernel.org>

Iustin Pop reports that the xfs_scrub_fail service fails to email
problem reports on Debian when postfix is installed.  This is apparently
due to several factors:

1. postfix's sendmail wrapper calling postdrop directly,
2. postdrop requiring the ability to write to the postdrop group,
3. lockdown preventing the xfs_scrub_fail@ service to have postdrop in
   the supplemental group list or the ability to run setgid programs

Item (3) could be solved by adding the whole service to the postdrop
group via SupplementalGroups=, but that will fail if postfix is not
installed and hence there is no postdrop group.

It could also be solved by forcing msmtp to be installed, bind mounting
msmtp into the service container, and injecting a config file that
instructs msmtp to connect to port 25, but that in turn isn't compatible
with systems not configured to allow an smtp server to listen on ::1.

So we'll go with the less restrictive approach that e2scrub_fail@ does,
which is to say that we just turn off all the sandboxing. :( :(

Reported-by: iustin@debian.org
Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 9042fcc08eed6a ("xfs_scrub_fail: tighten up the security on the background systemd service")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub_fail@.service.in |   57 ++------------------------------------
 1 file changed, 3 insertions(+), 54 deletions(-)

diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 16077888df3391..1e205768133467 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -19,57 +19,6 @@ SupplementaryGroups=systemd-journal
 # can control resource usage.
 Slice=system-xfs_scrub.slice
 
-# No realtime scheduling
-RestrictRealtime=true
-
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
