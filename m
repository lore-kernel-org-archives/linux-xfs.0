Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21212D130B
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556723; cv=none; b=fIOpczhlyGK69YQk3X6qtcnYPO5m9JEZ/QJgTKNdKmtB1Vw7qmqiELZRyRPXh6Kz45L68/vI7MCg55fmFIOKQz4nn5qvPMMSP/pMhIzgyKgCjdihpNmLCgULKi/pUez9TADzKJw4IUIDRVk1Og2lIbuQokokYyCTd0brSSONe+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556723; c=relaxed/simple;
	bh=fuZRe3ZHPALyVt3mp/MNsnXIjASgnesRBsoKCGm8f5I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hsgIK3Kd80szDyJKe8sLEZLwxEfhBzcOrddU5ZeeXDeBKcCIXRtLvNxhFBt24TPOqvShhUc0HzeOqQHncs0GfD6RmiyNgSLYdKSKG5D7sLonO6RsNR6m69A3lFwXyk3Q6JNe67H1xXSf9LoD6EBsbp7pzKfAiqU9T+jQRzFwv5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4GmR2lB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4GmR2lB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DC6C4CEE3;
	Tue, 15 Jul 2025 05:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556723;
	bh=fuZRe3ZHPALyVt3mp/MNsnXIjASgnesRBsoKCGm8f5I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S4GmR2lB81GHZlD3qW2wFXqQSEahaHcbhlE9uJ3C08UiXbBe3oJS06eUGNpx/2W62
	 KJNgRmHsBINToot7CBSdSYZJLKkVNbVVHsD+gpHY7ct/B8cqgPLlA3xsPzUfA25nlR
	 HDz67At9icoKVLZu4rlnohsKiepECTN91veYwAes83e3ygfjkCWqnYviobhfzNa4Kh
	 jzaKaY/ecJiJmweiSDiOFWSPrp338NTZgzjyPAyBhSOEUJBY3qlGuiGzOJnF0gcfnD
	 1dIpn49eAk1EirYYrxem0fUtCSUsXz6pIe5c+1U3eYq2fa275aGBtmQ4TlGc1snmdK
	 UNx2Lm39cbTOg==
Date: Mon, 14 Jul 2025 22:18:43 -0700
Subject: [PATCH 3/7] xfs_io: dump new atomic_write_unit_max_opt statx field
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652509.1831001.15375900558391013689.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
References: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
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
Reviewed-by: John Garry <john.g.garry@oracle.com>
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

