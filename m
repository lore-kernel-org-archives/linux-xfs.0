Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA263B0AE1;
	Wed, 24 Jun 2026 13:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309542; cv=none; b=hdi2VwEBuOl4hzKpSqn/TZUXC+SKYOyqRfA+8jtYQCRbPoLCQsXLrlNF81+tcp2mVljW9gkNGvfh9/Crifb8JUMmA92Ro/zoW6rGi4a0vNviG8sfT1ChDRL8KU8pY75yO1iylwpwVSznvWlCqlYTu0OOHBtbJAa8KYLiwqKJklo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309542; c=relaxed/simple;
	bh=+99QLQgaJF4upqT9gfpX2CeDtQk1MVxrvLFbYKLMKIg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ALtwieXUbSbJT94ZCGm2RPiW6Pvg2p4KYx+BX7WWYXepUKE6mPV8qi5oHrs2tyMmHFS+0DmxFQtST0edYxCjlVv/qIHP6CGgWowIvDzRMJvXNbBhQ5l9gHmeDC51MfMFDHIyJ0MO1PJLO9e1rnvm1r21WekH9ZcjkQbwJW2RLLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Wx9mXd+1; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Wx9mXd+1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782309484;
	bh=HTIH+nkJqK+dRaqrOMUZtgLqrPrJYSIhbPS0TlqybAY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Wx9mXd+1OlXOXHOulRXCm4yIF7EaGMHiy1qoqXBXkib1S01oDvLGaJlBVKfPbLH5X
	 hZSM00pUSaSXPdAaLURGHQhsxcApK7Tyt985vfaSHTXJY7CFZmabSPyD5/DFbZBkhw
	 DSHZ/0uuEm3LnlLBiydZzpfX0utqWcxz89Qd+fug=
X-QQ-mid: esmtpsz17t1782309478tfee550eb
X-QQ-Originating-IP: DlsecvetP3RstHwax72U/AwRWCDFX9ovkvJUvGw72N0=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 24 Jun 2026 21:57:56 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13248926347998950642
EX-QQ-RecipientCnt: 8
From: Gou Hao <gouhao@uniontech.com>
To: cem@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	kees@kernel.org
Cc: linux-kernel@vger.kernel.org,
	gouhaojake@163.com,
	kernel@uniontech.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove dead NULL check after __GFP_NOFAIL allocation
Date: Wed, 24 Jun 2026 21:51:55 +0800
Message-Id: <20260624135155.326834-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MfQ6P9s9cWJwuBgy0X/w1p7Ekp+QJ16ZPgHnzmdVNd/WZ4RKCbEC7lzz
	6qjUM2U2yl4Je8Hsv5gT8Gpa2SHz5xQc7P8h220XpFYcCQf71TyIXDk0eVXUvRQRj96JdKf
	a6hINydy/WlTlKMCUx7h6Anf5mSeehfLBExTZ4DRoqTHLRVyXLJsabRehB1trnQIa/2lzxx
	e+CtFIWQ1s52JmvzWPP5f20trHEYfSJNbjSxPQzF3qg51aSWisH9lXUv1hy3waC4ihn1v6Q
	UcHNm51JVwPyXUP3fGrcscBZl1P206vdMEAa56P6qO+7deq8uzts3L/iR1B/Vcgv8W0dYPo
	sr4BeuMFGzRx4qZe8t4Uvw/Lv38Gop5Xa0Nlz9yACUONs3pMFmAxQUkAhUol/dSNMRC2KtZ
	vNentX4Y11vKydmb2vNJosd9R5yJ9a7o4NkSNR6Mk5kHBVF0tGRQtEMOz78jdXSEHJXHnGT
	43MmVdr1uc+v4gmhtEznRDaFbbweCjpgbE7s1+QOizW1bbg/vSPN+9wPJimA3w8VLKkFFE6
	N2iw/r6tMhK9v/K3vgUSRbVTF7ZWyrRVmh/BllTOMKc+aE4Ck5IYh9fR+xxlayb2iKL0Wzq
	cKB3FCzjA7+29M4foq2myfVYNhr1BRjibdYVv3Xmmqi+NCZbkVm/RmspelE+FVu4P8oEOgz
	xLt+j8rIf4uyYWm2wI1cSFBU+MOEPr1A5DHXehgqvZbU6sW4KJHtC93D5J6CRPF8JqFmJWw
	tYv4G0nIrCVrOMlqyOGRUrzWU51WYYrRBZeqisXPB2U80JicZP0NwUNyzccaSq04n6qu1J1
	YWw8KjK31xUDry/FcLR+8jCuuEUMhwf2Bp6DUyNLSrABjN/gswJMtDSM5AB7Ev5wIEHRemR
	v53QaLzEuN4NELZiFZR5L3rqKxEBhyxor1BtEg+w01m4yU5LL7rTLHI4SiMKebf6/UW4FuZ
	5NQ/CLwdZZJiaIgt2fxz7DWNWDX7xy2LcNK6JAHlQXBedQyQEyvzt/XJju+T8VpVKRBXBhW
	zWmuY3yl8fvAKuepoQ
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

kmalloc with the __GFP_NOFAIL flag will never return NULL, so the
subsequent ENOMEM check is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 fs/xfs/libxfs/xfs_dir2.c     | 12 ------------
 fs/xfs/libxfs/xfs_exchmaps.c |  5 -----
 fs/xfs/xfs_buf.c             |  3 ---
 fs/xfs/xfs_mru_cache.c       |  8 --------
 4 files changed, 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 0c0402a29b6b..6009ec26843d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -249,9 +249,6 @@ xfs_dir_init(
 		return error;
 
 	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
-	if (!args)
-		return -ENOMEM;
-
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
@@ -342,9 +339,6 @@ xfs_dir_createname(
 	}
 
 	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
-	if (!args)
-		return -ENOMEM;
-
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
@@ -503,9 +497,6 @@ xfs_dir_removename(
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
 	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
-	if (!args)
-		return -ENOMEM;
-
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
@@ -563,9 +554,6 @@ xfs_dir_replace(
 		return rval;
 
 	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
-	if (!args)
-		return -ENOMEM;
-
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index dcd0bd0b13b4..bd897676e38a 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -500,11 +500,6 @@ xfs_exchmaps_link_to_sf(
 	/* Read the current symlink target into a buffer. */
 	buf = kmalloc(ip->i_disk_size + 1,
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-	if (!buf) {
-		ASSERT(0);
-		return -ENOMEM;
-	}
-
 	error = xfs_symlink_remote_read(ip, buf);
 	if (error)
 		goto free;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3ce12fe1c307..5583139d7478 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -130,9 +130,6 @@ xfs_buf_alloc_kmem(
 	ASSERT(size < PAGE_SIZE);
 
 	bp->b_addr = kmalloc(size, gfp_mask | __GFP_NOFAIL);
-	if (!bp->b_addr)
-		return -ENOMEM;
-
 	/*
 	 * Slab guarantees that we get back naturally aligned allocations for
 	 * power of two sizes.  Keep this check as the canary in the coal mine
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index d61ec8cb126d..258c07da73e1 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -334,18 +334,10 @@ xfs_mru_cache_create(
 		return -EINVAL;
 
 	mru = kzalloc_obj(*mru, GFP_KERNEL | __GFP_NOFAIL);
-	if (!mru)
-		return -ENOMEM;
-
 	/* An extra list is needed to avoid reaping up to a grp_time early. */
 	mru->grp_count = grp_count + 1;
 	mru->lists = kzalloc(mru->grp_count * sizeof(*mru->lists),
 				GFP_KERNEL | __GFP_NOFAIL);
-	if (!mru->lists) {
-		kfree(mru);
-		return -ENOMEM;
-	}
-
 	for (grp = 0; grp < mru->grp_count; grp++)
 		INIT_LIST_HEAD(mru->lists + grp);
 
-- 
2.20.1

