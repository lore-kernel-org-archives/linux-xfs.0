Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AB91B040B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 21:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531588; cv=none; b=p41NBYdZujIvoGGYvlPt5PY7589brTYL9UYztW0YOs9YLlkeE+xq1RnYdnosCxJzzuybjj+erHALIu7smiNYoRbtIudUzUcz27qLBq+f5dLH1OPoAhM4gY97eg1zZwiP4c/Y1iHZRQmF6y8VExQVTXXi/ib+7HhzTO/wlczsTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531588; c=relaxed/simple;
	bh=J758shL+w1Nszb0B2FI2nV7CtQ8NpaQoCyk3IQysYiQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+REVyEAZOa851kqCQls/oV+lTvNXMcsDDUxCQYT1CxoVWoxyeT3fHGyrir6HGMHqICtT3/Tb2ciiVyPgUeOCyYN1+bYpluYLiVRNt8M5TH0vDpXmWnucHabq9e4EWSOP0vNVtrc8wr7JuSi7gHuCMSjRQPzFBg/E18spRcKILI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uE48b3gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uE48b3gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DF0C4CEE4;
	Thu, 24 Apr 2025 21:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745531588;
	bh=J758shL+w1Nszb0B2FI2nV7CtQ8NpaQoCyk3IQysYiQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uE48b3gcBZxdtGjeJLwpUPEHV5NeJTqVwginZ1dF2KyTyM7HfcQvwKeeHV6zI3s3Q
	 WcjgQbZzmhRURPdkG+4n9XaBtVA6DL5HJ3yvtmCUuh43Yf4MKw6ldwyzv+QBOA/EkZ
	 zVNYLdBVaECVHe6qnn7C3SBEWNUGo9ckPKNRNneHz5AzFW8A0zWCji87A2eWVwDoQ7
	 m+b2APXg/nUKiHeKXfyu9BIMQNJnftByqRsGNnwQ6fK5ibrZB+ho6q8i08Sco73+Dq
	 ZGWiClz1YN6SNy44Re/oGmcYk50NBep4GyrJF/VvNQJcU7JNLKhfHs2ghi2f8z2cdw
	 IBwMYXt8Dqyuw==
Date: Thu, 24 Apr 2025 14:53:08 -0700
Subject: [PATCH 2/5] xfs_io: catch statx fields up to 6.15
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174553149356.1175632.17456557520696046949.stgit@frogsfrogsfrogs>
In-Reply-To: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add all the new statx fields and flags that have accumulated for the
past couple of years so they all print now.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/statx.h            |   25 ++++++++++++++++++++++++-
 io/stat.c             |    5 +++++
 m4/package_libcdev.m4 |    2 +-
 3 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/io/statx.h b/io/statx.h
index 347f6d08210f83..273644f53cf1c4 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -138,7 +138,10 @@ struct statx {
 	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
 	/* 0xb0 */
 	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
-	__u32   __spare1[1];
+
+	/* File offset alignment for direct I/O reads */
+	__u32	stx_dio_read_offset_align;
+
 	/* 0xb8 */
 	__u64	__spare3[9];	/* Spare space for future expansion */
 	/* 0x100 */
@@ -191,8 +194,28 @@ struct statx {
 
 #endif /* STATX_TYPE */
 
+#ifndef STATX_MNT_ID
+#define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
+#endif
+
+#ifndef STATX_DIOALIGN
+#define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
+#endif
+
+#ifndef STATX_MNT_ID_UNIQUE
+#define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
+#endif
+
+#ifndef STATX_SUBVOL
+#define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
+#endif
+
 #ifndef STATX_WRITE_ATOMIC
 #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
 #endif
 
+#ifndef STATX_DIO_READ_ALIGN
+#define STATX_DIO_READ_ALIGN	0x00020000U	/* Want/got dio read alignment info */
+#endif
+
 #endif /* XFS_IO_STATX_H */
diff --git a/io/stat.c b/io/stat.c
index d27f916800c00a..b37b1a12b8b2fd 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -365,9 +365,14 @@ dump_raw_statx(struct statx *stx)
 	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
 	printf("stat.dev_major = %u\n", stx->stx_dev_major);
 	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
+	printf("stat.mnt_id = 0x%llu\n", (unsigned long long)stx->stx_mnt_id);
+	printf("stat.dio_mem_align = %u\n", stx->stx_dio_mem_align);
+	printf("stat.dio_offset_align = %u\n", stx->stx_dio_offset_align);
+	printf("stat.subvol = 0x%llu\n", (unsigned long long)stx->stx_subvol);
 	printf("stat.atomic_write_unit_min = %u\n", stx->stx_atomic_write_unit_min);
 	printf("stat.atomic_write_unit_max = %u\n", stx->stx_atomic_write_unit_max);
 	printf("stat.atomic_write_segments_max = %u\n", stx->stx_atomic_write_segments_max);
+	printf("stat.dio_read_offset_align = %u\n", stx->stx_dio_read_offset_align);
 	return 0;
 }
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index af9da8124dbdc8..61353d0aa9d536 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -126,7 +126,7 @@ AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_POLICY_V2],
 AC_DEFUN([AC_NEED_INTERNAL_STATX],
   [ AC_CHECK_TYPE(struct statx,
       [
-        AC_CHECK_MEMBER(struct statx.stx_atomic_write_unit_min,
+        AC_CHECK_MEMBER(struct statx.stx_dio_read_offset_align,
           ,
           need_internal_statx=yes,
           [#include <linux/stat.h>]

