Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F8712BEB2
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998967; cv=none; b=NGf/eDzc79Z/6ip7wzy58QVDtqz0H8GARdVFyN0THToqGUx9sXjDX+kgtsVzXNUcN4fq5ObPHZoOKFTY9UiNoQ0as1FAZQCIrqTRHH5Es0BmAdfn43rri1SZIur3cVyUCsiqQqgTgnYmISGI8rDlCRrwAcLT2xvWP98kj4FVmvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998967; c=relaxed/simple;
	bh=+AyRkOzk2qrkE10/2BsMvLQaKTMtgxEmEHYQ5NjLOCI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e06cwV207P90NhVSYcubTcAKMPwmMGwzpkQ2YRMpAqRj2KfExJADPG+aDvFQbBso6bXlk9Q+xdsUY85lCYiTjGWKfY15D9o2r3HPC3v13ZkEhd20MIQh8i3zPsIcLZUzfMF8wOp35E/FmotaP7/Vhm06mQMN+02w0tC6Ga/aZHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4tq5V6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4tq5V6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CD5C433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998967;
	bh=+AyRkOzk2qrkE10/2BsMvLQaKTMtgxEmEHYQ5NjLOCI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=p4tq5V6ASi0YPrzk/w+hKcfJ3VIB1SMEDXFCcGywudjSsGqPMkt9QnG2BfE797n08
	 OpF88viwEJqBlS0jcmh9WXeC32ptZK3HJHhrMbRM5DB8IHLpoo8I47OWzyVwmg6cqK
	 yimxzzdyam1O0bJ5Rmwxd10WK5cnW1BXqx+opNAIVNdlsHqr/Jr6x/+/PbSpkns5rN
	 gZW9j4mOe1H4uNQ2PvVUexBLLaRQQ+YkT+/5DC1DWOs2QMGwZkzNPlxFmQiTRLH0fT
	 fYkGqm335TQapHhqf2YMtwU4neCNwZsc7KbqKspzglk1fPPQW31vRDOILhCk3VD5pY
	 Yc6m/nwsro9fg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 12/35] xfs: create a helper to convert extlen to rtextlen
Date: Thu, 15 Feb 2024 13:08:24 +0100
Message-ID: <20240215120907.1542854-13-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 2c2b981b737a519907429f62148bbd9e40e01132

Create a helper to compute the realtime extent (xfs_rtxlen_t) from an
extent length (xfs_extlen_t) value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.h   | 8 ++++++++
 libxfs/xfs_trans_resv.c | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index b6a4c46bd..e2a36fc15 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -31,6 +31,14 @@ xfs_extlen_to_rtxmod(
 	return len % mp->m_sb.sb_rextsize;
 }
 
+static inline xfs_rtxlen_t
+xfs_extlen_to_rtxlen(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		len)
+{
+	return len / mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 04c444806..53c190b72 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_quota_defs.h"
+#include "xfs_rtbitmap.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -219,7 +220,7 @@ xfs_rtalloc_block_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
-- 
2.43.0

