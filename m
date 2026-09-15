Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6CA385D99
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 10:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789468765; cv=none; b=gh3aWchiXo1QvSUYWwmP2Tn0QM+2vKEXZRqC1C9wW8AFlL4Z1oKAXL6idzWNvSnHQCa2skCTIkuf5JD+HSaeYtb79B76lHifRug0zey8p65bzWY+eBQH9kp7ozAm1/PiUI3NHITdhc1cHOc+KkvFV/lWNN2K48Ghfi7VOE1HtcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789468765; c=relaxed/simple;
	bh=ha7OFRbZuShoVn+xsdO2Ix27pvb6GkNgC+sccrkoGaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cLCJE7rUKKtjm104OXWxAgUH2NSBCw2pW+Wr/U02+/Xc7A2hdWkpYe0RxSAmbKPAFIK50FNMII1Q94ThWW+o16UDjVWh9a6YO0Z/UYDSAkbeGK9lXWnmpWEXIaPFPjebIARFnnKekotUTvGfpvp91SbCr0uMWR9cWBO0d9N5u8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/UNOW8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/UNOW8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F901F000FF;
	Tue, 15 Sep 2026 10:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789468764;
	bh=PPgWTR78ASEMuLStjPBCEXiSBHLexrKHCGNWCdONkRU=;
	h=From:To:Cc:Subject:Date;
	b=j/UNOW8FfGP+GSBL/39n8ouD2H5hIFP28bMx0q014wwO8PjF8Se3obgGJwNHvO9eF
	 CgwkuMcRgoZsufZlLB1tjoXKFbtq63kY1NLnG0HWUM+Gd1O3peFHWQBblVq5T1IIJ+
	 Oj4QNjOCt1JeO5DXeZJ+mmJ/4jKbzQq5NhgZLyJRuUBhZN6DxkqUy7DQZKJAWSgHlI
	 oIYItnBCXkPjgLXE4vSvtjb7A9OVhNZyJRGDkzjrMCXKZ3e3a96CXb3jCzKbuouiOL
	 /XexZnLZytZgqiP9nR+IDMJMwvwbo9iXU22HvgIZw/n8jriAAAaL6ffzIx0Xtl5U+j
	 U7N2XtL8mVWBA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>,
	djwong@kernel.org
Subject: [PATCH v3] man: document that XFS_IOC_FS[G|S]ETXATTR can not be used on special files
Date: Tue, 15 Sep 2026 12:39:18 +0200
Message-ID: <20260915103919.2595641-1-aalbersh@kernel.org>
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
Changes from v2:
- FIFO on a new line
Changes from v1:
- Use semantic newlines
- pathname-based
- RvB
---
 man/man2/ioctl_xfs_fsgetxattr.2 | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
index 25a9ba7965d1..9a1983ca1756 100644
--- a/man/man2/ioctl_xfs_fsgetxattr.2
+++ b/man/man2/ioctl_xfs_fsgetxattr.2
@@ -238,6 +238,28 @@ Caller did not have permission to change the attributes.
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
+lead to side effects on special files such as
+FIFOs,
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

