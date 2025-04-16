Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2052DFA2D
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 05:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744780895; cv=none; b=GZUvPnY50uxMmwmw/tn/0YYWy8Mq8iSjVTcD0fJ+ef96C4ohi6hen9t3OmBZvT+/RLo/xpMnfNFz1chPJE9W32U8xWW1spId4eWbMJ4KDzsL4z/HQ9zeHrJBjBao6Vk/WIMVZo9/De+Ph6sEDHnux/LZWhuA76TovFPav9xUN/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744780895; c=relaxed/simple;
	bh=ZXsiTvVyMiQW3ImakhQ8aE7tYOCTsflQU9Hah7Kjzzs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eNz98xcWi2JMseqiX4EZ8dopfDx8eNlSq4yilgC7AZkQSZ+GH4+hT/bvBLoclpPOCpg/hLiePEwnTCTSNSsifLol04HmpALh+q59YZAOUrIaY8s67EUW6A3BbnNpUY9ybz6+WJsPuJgrstJtHvFABwG/TGrxSJRTM+iCGA26Nvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u2bNDkoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u2bNDkoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCE0C4CEE2;
	Wed, 16 Apr 2025 05:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744780895;
	bh=ZXsiTvVyMiQW3ImakhQ8aE7tYOCTsflQU9Hah7Kjzzs=;
	h=Date:From:To:Cc:Subject:From;
	b=u2bNDkoB8QYKgxAU0rk9FKZOkd/EEtHAPv0PASSgp5HhCsId9qSwT6KmRtvYgRU8+
	 KUmt8GPj0DrHITtIq9pHiD8/k5bedGvqR3XIsRin58dpDmx8o0WWb8DpAzxV0T6mYs
	 +Ce806MSjrnKP9zYjsCrXkQpB+pmcQrcZIez/2+mJ2LPqvLicN/5rSPPZc+zlQqtJ+
	 iJoyo800YE08INFj5YFP7LTUhFX05JfczKC7937hRQ8Lj4yymHntQAfifYuzsQp9jP
	 C0AhPa2CCt8Ea2cCK11zp5OvKlVQBHEm02tIdAjyzrmSwcU9FRltthAyfdXcMHbZ8E
	 ZxxqmC+Dh9+CQ==
Date: Tue, 15 Apr 2025 22:21:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs_io: catch statx fields up to 6.15
Message-ID: <20250416052134.GB25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Add all the new statx fields that have accumulated for the past couple
of years.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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
