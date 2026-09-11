Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81FA44AB88
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 11:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127273; cv=none; b=VhV+QfHP0kFDCHOHs5tz+CAMsDV40em+bcFoMCTwmHx5eieBbsm47JoT9ccUkI/Mv1yjd9K7d2Ffj0vXeEdYCr/xPLdNBi0hxvgMo82h2Tfwae6ADpBXPq6o0EGnttFpPcTOYlmbPvnmy63Q8uF8842TjkYT7sPI8hEAYoFi/k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127273; c=relaxed/simple;
	bh=4NTRX6Pf1He9s2tSAIm2Cj8jOG6vIG8JcvAoqGvVI/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lwpbjex63RjCTCT0Cuj7A+rSDVF7Fxb4QyMLlAE02GU1R5rt62BCRn78hTyzN1gjpkkGglhU08eyawIkWGoqst1OH47YIkzr46c/d+gQL/kZbXUsH6nWGB4U7ltJyu2/3kXPRzc2hQ4qOkjRDuD9zR+x0BV/Bs8BrxLiLKWC/Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUvKZ3nP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUvKZ3nP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DE11F000FF;
	Fri, 11 Sep 2026 11:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789127271;
	bh=XGCgc/sfJpLRE6DqNRjXcK5Be+lYLEjuLZlvopg+6yA=;
	h=From:To:Cc:Subject:Date;
	b=mUvKZ3nPcnQ4ei3ytrrixVbNzuaTXQycb4TkYcFjucrTxqYdpRLyZPkAx7VJywPpZ
	 7DwckTWs3wRQMwibQbpp7UW2hDHtsYLLxgtnaP0xHhHn2qRGoVRGrSMfUegby8Tnm2
	 mC2m7EItTQXuO1m5Z3PU4oqPdozqCZNCLeyt+hcahOEA68e7ipkGpW4iIfquilsyGP
	 E54JUV+5DMQ+KhR6xoBMOcuCqMtDtQF7cXN5qPL2x0dJEA2nMY5FTInadkbO/1wOoy
	 i+V2AY5nbqOVCNg1eLLJh0jJD2lAJPEgaWLVfZXN/FmekSH1hdnZSod/HA4vKIv6OZ
	 D6Ld4ClqAZZoQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>,
	djwong@kernel.org
Subject: [PATCH] man: document that XFS_IOC_FS[G|S]ETXATTR can not be used on special files
Date: Fri, 11 Sep 2026 13:47:44 +0200
Message-ID: <20260911114746.343945-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a CAVEATS section with an note that these ioctls can not be used on
special files and leave a reference to an alternative pathname based
syscall interface.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 man/man2/ioctl_xfs_fsgetxattr.2 | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
index 25a9ba7965d1..5d223138e419 100644
--- a/man/man2/ioctl_xfs_fsgetxattr.2
+++ b/man/man2/ioctl_xfs_fsgetxattr.2
@@ -238,6 +238,23 @@ Caller did not have permission to change the attributes.
 This API is implemented by the ext4, xfs, btrfs, and f2fs filesystems on the
 Linux kernel.
 Not all fields may be understood by filesystems other than xfs.
+.SH CAVEATS
+The
+.B XFS_IOC_FSGETXATTR
+and
+.B XFS_IOC_FSSETXATTR
+.BR ioctl (2)
+operations require the user to open the file, but this may not be possible or
+lead to side effects on special files such as FIFOs, sockets, block devices,
+character devices, and symlinks.
+.P
+For a pathname based interface see
+.BR file_getattr (2)
+and
+.BR file_setattr (2)
+syscalls.
 .SH SEE ALSO
 .BR ioctl (2),
-.BR ioctl_iflags (2)
+.BR ioctl_iflags (2),
+.BR file_getattr (2),
+.BR file_setattr (2)
-- 
2.55.0

