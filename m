Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5AE1E9B37
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 23:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760398466; cv=none; b=SU+In+cAcSw1Egpdom5Y7/ou4DlViomryCmrwM7COeKomxJ0ZZD16vWI/7TcHjnfrMDGubxuPDWGVkOpbj0Hw+1C3UIEdoBJYFvjl7DxylWZCL9ip6BLDi+9fV7AOuNHsxLRUqDyx/F/e4Bp1p2sfVRvx3cyEAPgfzLY8aczBDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760398466; c=relaxed/simple;
	bh=8p5h8ubpwH2DC6Eo2rzvAs6CsYoCfO34jLCN/ex+Nbc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pf1cmeguY1XaJYUmf64I1eBreE1xp9Nz38xDCFgGLgG6mjozUUmfiVME3WcpqD2PsuHmiIiSXTr66oSJKNSFi0dwSuvjPpBOOw4w1mRLnTh56Dy5pBB7SDiDjUXEwyeViJ+Kiwbw/MZfY/iRd7qEHpKy8pbKYey+nSE7SylC0fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2HXLi+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2HXLi+E"
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
Subject: [PATCH] xfs_scrub_fail: reduce security lockdowns to avoid postfix
 problems
Message-ID: <20251013233424.GT6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
