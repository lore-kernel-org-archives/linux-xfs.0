Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D87C3B42E7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 10:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382880; cv=none; b=L0JY1LYFzAKMZCdftz6M+VaovKI1DFyLwKJujD0htSMwm/MfuqqUcPM2kbwpOBfZUGyhrmi9C474WMxtKP4dKyuYjZ3SRUaCzTXPFVQ0SCSe4gCoMmgPle6FfTQnotKHeJ/c/HWWBkhXfTXYTT2WBWcLyqF+7NweMEQ07Mw5OHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382880; c=relaxed/simple;
	bh=mwdFy7ZsvD8+6QRIQukzUwnGt6wB8pr7P0aTII8joyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X8rkg5DDe7r7YV813SFy6ZN+3DmIy7bqnbN7rCLK8eGm7BxURMdaVHsZ+ngqAORg9sHDrbVYU7JHSQzSY/+wRWpDxUIoXElbdj2Sl9r4Eg5Osx7bsV4/lvdwGaH7z16ntAx/bh0TNs1x1zXC4i3kyMCq9uO5LMvg3YA49j+swm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JI2ZmXt5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JI2ZmXt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7A41F000FF;
	Mon, 14 Sep 2026 10:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789382875;
	bh=OvGdtPA9K7UqJvnrZIWy2Air35gSjKnBwLj7VhquKVY=;
	h=From:To:Cc:Subject:Date;
	b=JI2ZmXt59gdxZpATeNVHae09/gTHiezHxsecFTpM6N+Maj5vtQC24JcLxAvq8tbz0
	 VL77Jbv10GgwL94dnyRvSq+Gxg+NHfARUSiA1DEINZnguT+JKMplTcsGYH+66oGjuy
	 lFmKXuB/pc1y7AITLbn/rQCzXs/ZXnwWvfIkzyvdEgjX3NI1zma4HERKU/dnebMyOQ
	 nIU2tYbeEP3UwtLhVu/IUxmUPvABoXTNgDOG9S/GIK0xNBhpRNx6Y6C2nndL2lacLZ
	 FAv8qtnsH5a6yjo6W8g1QudoV1dJSOeifejl+gcX/6bkDKqGStNlEShQ05iAXQN5KP
	 LeCmn+61WY+UA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>,
	djwong@kernel.org
Subject: [PATCH v2] man: document that XFS_IOC_FS[G|S]ETXATTR can not be used on special files
Date: Mon, 14 Sep 2026 12:47:48 +0200
Message-ID: <20260914104750.1727589-1-aalbersh@kernel.org>
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
Reviewed-by: Alejandro Colomar <alx@kernel.org>

---
Changes from v1:
- Use semantic newlines
- pathname-based
- RvB
---
 man/man2/ioctl_xfs_fsgetxattr.2 | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
index 25a9ba7965d1..db5eb232319e 100644
--- a/man/man2/ioctl_xfs_fsgetxattr.2
+++ b/man/man2/ioctl_xfs_fsgetxattr.2
@@ -238,6 +238,27 @@ Caller did not have permission to change the attributes.
 This API is implemented by the ext4, xfs, btrfs, and f2fs filesystems on the
 Linux kernel.
 Not all fields may be understood by filesystems other than xfs.
+.SH CAVEATS
+The
+.B XFS_IOC_FSGETXATTR
+and
+.B XFS_IOC_FSSETXATTR
+.BR ioctl (2)
+operations require the user to open the file,
+but this may not be possible or
+lead to side effects on special files such as FIFOs,
+sockets,
+block devices,
+character devices,
+and symlinks.
+.P
+For a pathname-based interface see the
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

