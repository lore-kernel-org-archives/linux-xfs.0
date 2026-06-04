Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764502FC893
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553078; cv=none; b=Q5g2gCInqwXe4IKdmB1Cuy+xY7XomuFjMAxAFPixoz3FeRXDg9F830OMvjaP81uTin/6qluCqd8AT+X9ansEQyXiYWpaLTlqFXrdJlx+Nsvkp6pxwsIEx6g+kTNiPR2qUm6QRPKUOq3/q29lYw6524FqxPFghfcg6Nld5s5VWBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553078; c=relaxed/simple;
	bh=aBH/KZc4q4IWktN1dYo1fB5Dd9sf9C+t38jG6vCD5/I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h29e9ZgNy2ptZ53sxROWHR8xC6uH2/oAcl8ZC5lmK4b3OL0mHil/qXQr8OAnEZAnsXq8U62xXg65Vfg/pbtDawUoEJ7l3GHw260gk9nj5xQfPI0IIKHs/jSoMi9+wNNxQPQthDZKJh+9FTDstGwCnzX2XDch8VvcPnQT0qaV0EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icpj2Alt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icpj2Alt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 17EA81F00893;
	Thu,  4 Jun 2026 06:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553077;
	bh=1ukpzaStwt84CM6ArzDzSVcV3bXtO3kvz0WtttL4504=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=icpj2Alth0yS3GTWXscBtf96iSagruDndCbB80+Sn2syw5QherwQNtCOVP3+aEPlq
	 1ohoCSBxNQ0EwCqvg3W81fpsBMmafdh7y85DtyeOsMj/YEZnMmoGdB6tVGxGHP8l5a
	 jv+bDjRozIUjnA9lfEyzEWCkHLA1fEgWLrmd5ZpWjc9cHdJKjf+fpzl97yKXdUV1oq
	 DnY5taYxC9LeomJw8PsWi8BUS7dwS4ezZN7xunlx2RIarzp8Pa92Ma0XSgXt+Vr0SM
	 tmALyfUlN5jIFnElEk7f5Tf0xwFcZLGABl/Fp5hfYTf0BZceHzPKX2+slR3e0CxEiX
	 9MKk8npadpVYA==
Date: Wed, 03 Jun 2026 23:04:36 -0700
Subject: [PATCH 01/21] xfs_scrub_media_fail: reduce security lockdowns to
 avoid postfix problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303127.2608728.13759559996989386020.stgit@frogsfrogsfrogs>
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
broken on systems that have setgid mailer programs (e.g. postfix).
Fix this by applying the same change from commit 15fd6fc686d5ce here
too.

Cc: <linux-xfs@vger.kernel.org> # v6.17.0
Fixes: 15fd6fc686d5ce ("xfs_scrub_fail: reduce security lockdowns to avoid postfix problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub_media_fail@.service.in |   58 ++------------------------------
 1 file changed, 3 insertions(+), 55 deletions(-)


diff --git a/scrub/xfs_scrub_media_fail@.service.in b/scrub/xfs_scrub_media_fail@.service.in
index 97c0e090721d65..e354dda146f1e3 100644
--- a/scrub/xfs_scrub_media_fail@.service.in
+++ b/scrub/xfs_scrub_media_fail@.service.in
@@ -19,58 +19,6 @@ SupplementaryGroups=systemd-journal
 # can control resource usage.
 Slice=system-xfs_scrub.slice
 
-# No realtime scheduling
-RestrictRealtime=true
-
-# Make the entire filesystem readonly and /home inaccessible, then bind mount
-# the filesystem we're supposed to be checking into our private /tmp dir.
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

