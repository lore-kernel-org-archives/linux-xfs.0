Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C92310651
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 06:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835820; cv=none; b=ZyYKdwfn4Ra3PXWpDvzzJx8TGZAHqQr9GQnCv2b5IQ/AWdI7Gm08Sv30AEIKqsNqygkOoajNd4C0NOKcB5QJaFhnB978dWPbNVB9ww4bW4FKhnCoKUdpqqe/uBCUosfPpbnn3YRd0iu3xIFaXzSEdS5iOHb/0m2JZaETOYQQrYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835820; c=relaxed/simple;
	bh=QuqyQXjk1sefod3LZNhLHfINRitiTSmVk994yDoUGNw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dRQpVM93zg3qW+ATbXcBlT8mXnrpqZipM6ngIR4K0yKQcESbhViN6AIJH44J2jvlwrBGpAHUhQ2b/ySrBVH72dRFvzWzhxCaAl2hu90C8XOXKBpm+zsHUKHgwRpQa0ey8mx2eYrp0P0xYlXKMe4g4U+8x1FXlZ2NR9qtHLTFUF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmuWFcl3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmuWFcl3"
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
Subject: [PATCH] xfs_healer: fail earlier on non-xfs filesystems
Message-ID: <20261001062338.GV2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
