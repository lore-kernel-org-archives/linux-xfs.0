Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941661F3B98
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393264; cv=none; b=llk6pHQRjY7TU7NcjdAHBM4R2KfBuSExnYG1+/5emsdI1ouYky/L7WIym6dAiAArLWHb1uCF6youblLKBHrwKg+E3E2ONHkZzVPCVVmqnXgQD2UEoP0rNxukTD4KqbiP4CHxGsEfk6AUVMzellHeFS/NqWkCWhB8NB53zxQc/04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393264; c=relaxed/simple;
	bh=uKMRU0I3f+q1avbkBM8cdfVm0zYhrFz2QBHWsToTrMg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ctGEpRUgMuEVrhSMtautOs3765W6MOTZPv7nFkYXcNzKfGPQZWMQy3WsZqTMP2IEqBh7G0PT2tesN8mgs1xL6Ud7id0huC1yqz/SrnLTCV22IYFONQTOzg8GgP1aDj3BN5oFkPOCJ7c7dbRabi5qMOyNFxFUq7D6S2qBlDkEgMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRkwFk3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRkwFk3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5CBC4CEEB;
	Tue,  1 Jul 2025 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393264;
	bh=uKMRU0I3f+q1avbkBM8cdfVm0zYhrFz2QBHWsToTrMg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vRkwFk3KWV+1kBkA/QAK3DZPvW0swiSEhueiW/gaxyk+Pj6YioOsxWoNq+vYIHu2W
	 GnpZvrKw17pUb6Vvc9CLw6nAQkvhAEuhD89Q+MEshPou1pGMsLDJH9ay43+nc3JIwn
	 15IQboN+5MMBhMZMhmzZRTYAxAIuqM2CN02zS230SGN/NGm9LgAcqdor2OnW/CRciN
	 tp4iXqklysq6osYzQeSkr1KN/5DXJ33KucT9eaQHoQx9foH3L4V9GAiHWNFAL5/Yaw
	 TwYS5yxRAjc7AD+eqG6jlxPvPymL/r0YhPWGhO7JiSM6wb5xxipuzzn3akTWG5eK4I
	 tfwi0F/bzjxJw==
Date: Tue, 01 Jul 2025 11:07:43 -0700
Subject: [PATCH 3/7] xfs_io: dump new atomic_write_unit_max_opt statx field
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, john.g.garry@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <175139303893.916168.16245124372956701031.stgit@frogsfrogsfrogs>
In-Reply-To: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Dump the new atomic writes statx field that's being submitted for 6.16.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/statx.h       |    6 +++++-
 io/stat.c             |    1 +
 m4/package_libcdev.m4 |    2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/libfrog/statx.h b/libfrog/statx.h
index b76dfae21e7092..e11e2d8f49fa5f 100644
--- a/libfrog/statx.h
+++ b/libfrog/statx.h
@@ -143,7 +143,11 @@ struct statx {
 	__u32	stx_dio_read_offset_align;
 
 	/* 0xb8 */
-	__u64	__spare3[9];	/* Spare space for future expansion */
+	/* Optimised max atomic write unit in bytes */
+	__u32	stx_atomic_write_unit_max_opt;
+	__u32	__spare2[1];
+	/* 0xc0 */
+	__u64	__spare3[8];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
diff --git a/io/stat.c b/io/stat.c
index 46475df343470c..c257037aa8eec3 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -396,6 +396,7 @@ dump_raw_statx(struct statx *stx)
 	printf("stat.atomic_write_unit_max = %u\n", stx->stx_atomic_write_unit_max);
 	printf("stat.atomic_write_segments_max = %u\n", stx->stx_atomic_write_segments_max);
 	printf("stat.dio_read_offset_align = %u\n", stx->stx_dio_read_offset_align);
+	printf("stat.atomic_write_unit_max_opt = %u\n", stx->stx_atomic_write_unit_max_opt);
 	return 0;
 }
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 61353d0aa9d536..b77ac1a7580a80 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -126,7 +126,7 @@ AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_POLICY_V2],
 AC_DEFUN([AC_NEED_INTERNAL_STATX],
   [ AC_CHECK_TYPE(struct statx,
       [
-        AC_CHECK_MEMBER(struct statx.stx_dio_read_offset_align,
+        AC_CHECK_MEMBER(struct statx.stx_atomic_write_unit_max_opt,
           ,
           need_internal_statx=yes,
           [#include <linux/stat.h>]

