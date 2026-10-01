Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2011F3BC69C
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 06:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835905; cv=none; b=iLJoXObf6eUw+441R5jhxxnYTBfifSuluHMcvwyOxHvinCJJft5D/WUZ2gNdg3Lu19jTMEcWL49cVmrhUUHX5y2wXQiBU5g70LoBlr5lg1uXuUEB9QO+Wv4KOcSWNQRfu6TPHFosUNi72GDEnqBecm7jRcjGbO04lJPTyhsTg3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835905; c=relaxed/simple;
	bh=QuqyQXjk1sefod3LZNhLHfINRitiTSmVk994yDoUGNw=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition; b=XMh6tsNTaDeoiOpz8lhSBqi/g/S8/hv5sjpIVMnyL/v8E0pvjrZSi8MKSGr62E111pj4bN5I+Ob+LlBTHUFYE4qgCmS+iXjCfHFuXLQEnhMiDawViIpbM1MHM76KITfBYbane6HNOP5/Da7E+btOu5ltuxKn+F2w6Bfcd1mLOjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmuWFcl3 reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmuWFcl3"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1xCAE1-00HIrc-23;
	Thu, 01 Oct 2026 06:25:01 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1149571: [PATCH] xfs_healer: fail earlier on non-xfs filesystems
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1149571@bugs.debian.org
Resent-From: "Darrick J. Wong" <djwong@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Thu, 01 Oct 2026 06:25:01 +0000
Resent-Message-ID: <handler.1149571.B1149571.17908358214122383@bugs.debian.org>
X-Debian-PR-Message: followup 1149571
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <179080491253.7201.8697529754428195540.reportbug@mars>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1149571-submit@bugs.debian.org id=B1149571.17908358214122383
          (code B ref 1149571); Thu, 01 Oct 2026 06:25:01 +0000
Received: (at 1149571) by bugs.debian.org; 1 Oct 2026 06:23:41 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 60; hammy, 149; neutral, 103; spammy,
	1. spammytokens:0.988-+--health hammytokens:0.000-+--Signedoffby,
	0.000-+--Signed-off-by, 0.000-+--libexec, 0.000-+--fprintf,
	0.000-+--exitcode
Received: from tor.source.kernel.org ([172.105.4.254]:45186)
	by buxtehude.debian.org with utf8esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <djwong@kernel.org>)
	id 1xCACj-00HIPl-1d
	for 1149571@bugs.debian.org;
	Thu, 01 Oct 2026 06:23:41 +0000
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 25CD3601F6;
	Thu,  1 Oct 2026 06:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C0F1F1F000FF;
	Thu,  1 Oct 2026 06:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835818;
	bh=GV7VFAzexEwRconrzzvS6CDN1ZuMzITkB/JexXLxFhc=;
	h=Date:From:To:Cc:Subject;
	b=TmuWFcl3qdgeJjLy7Jfb/P/YXOsV3WvAOXo74feZ/6nRAVRPsOOJnRM47dfA6fuFb
	 cKp2xrYGOQmE5B4pbSAbt7QbQlS6oVWfOgLIscUQI5bDL1mFSP3fD5j6psVHfO6XGV
	 7iK8s6TomQnM+pcUCdQ04ldfxqJS+X1QNPrthzsroCCaqDk61zaVSm3Xn53XwwpA+q
	 z6BsJdoH64SNtpdHIjzzMw/S1QsU3JkrBjOhvIfWz3iPX5MC/u5Ma1jX9x4IRYTPT2
	 YRT7gEJ8rUUd0/8vMJoDxo/x9AVjnx+cReMmYK/yxOIMPSMkAB+7FkHDQpIVnN+sag
	 M+dVvER3ywEDw==
Date: Wed, 30 Sep 2026 23:23:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: biebl@debian.org, 1149571@bugs.debian.org,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Message-ID: <20261001062338.GV2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-ID: <20261001062338.SxALk4UGFK_jqav5pxnkQM5guqN1UJfDPqs63pFg18E@z>

From: Darrick J. Wong <djwong@kernel.org>

A Debian user reported that the root filesystem service fails with:

 systemd[1]: Starting xfs_healer@-.service - Self Healing of XFS Metadata for /...
 xfs_healer@-[976]: /: Inappropriate ioctl for device
 systemd[1]: xfs_healer@-.service: Condition check process exited, code=exited, status=255/EXCEPTION
 systemd[1]: xfs_healer@-.service: Failed with result 'exit-code'.
 systemd[1]: Failed to start xfs_healer@-.service - Self Healing of XFS Metadata for /.

when the root filesystem is not XFS.  It's most likely ext4 given
Debian's defaults.  However, the actual service failure here is a result
of the ExecCondition program exiting with 255 instead of EXIT_FAILURE.
EXIT_FAILURE is what we're supposed to return to mean "do not run
service".

Note that xfs_healer@- is always started by systemd (and not
xfs_healer_start) because the root filesystem is usually mounted before
systemd starts.

stracing this program a litle further reveals this:

 # strace -e ioctl /usr/libexec/xfsprogs/xfs_healer --supported /
 ioctl(3, _IOC(_IOC_READ, 0x58, 0x7e, 0x100), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
 ioctl(3, _IOC(_IOC_READ, 0x58, 0x7c, 0x70), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
 ioctl(3, _IOC(_IOC_READ, 0x58, 0x64, 0x70), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
 /: Inappropriate ioctl for device

All three ioctls are XFS_IOC_FSGEOMETRY calls, and they all fail with
ENOTTY because this is an ext4 filesystem.  The fsgeometry call occurs
under xfd_open(), so fix this error by special-casing the error return
handling.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1149571
Reported-by: Michael Biebl <biebl@debian.org>
Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Cc: 1149571@bugs.debian.org
Fixes: ea178059ff72c3 ("xfs_healer: don't start service if kernel support unavailable")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index ec402a78d5d2bf..b71695db05876f 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -317,6 +317,16 @@ setup_monitor(
 
 	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
 	if (ret) {
+		if (ret == -ENOTTY) {
+			/*
+			 * If this isn't even an XFS filesystem, the fsgeometry
+			 * call will return ENOTTY.
+			 */
+			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+ _("XFS health monitoring not supported."));
+			return MON_UNSUPPORTED;
+		}
+
 		perror(ctx->mntpoint);
 		return outcome;
 	}
