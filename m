Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9713912BF05
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998964; cv=none; b=GpELORMb0IFjZ4Bx93EU+GpgSrgB8+tLQzZupAE/1dPUrKGo3DoZkoagM54d5Y6jFC9ovJkBs3/sROPA32+JdEX9Ar4T2k0dnM3hICOr+KBVgg9ko6HMZ7J5Z+t7E0WjeVKpCl2fpnTvKENUAA6834WdunoFzoaasmyCvKGepjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998964; c=relaxed/simple;
	bh=rwBI/dDE7Qmp1j9UqVsna3tIx+wdSx8uJoAzprPTOqo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wl48bVKEpC6+mK7IHFbctTaH/PQYz7W04dhHbGcxEeg/ZZ5bbY1aHeKWZ5IX4Xknl1baE0VYPtOhwg5gJRsispBRwZzZo4ddQsVUV0z2MGuYnTr/H+XdQOn0RSSI9GwBLltVjv16UXB8rLnD+atepy32t+HDdhnmBQQq5DkAGWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QV/9bgsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QV/9bgsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F9EC433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998963;
	bh=rwBI/dDE7Qmp1j9UqVsna3tIx+wdSx8uJoAzprPTOqo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QV/9bgsDLPihNefTVL0100nYvTPzNj2LACyeiay84mV7NC1Ru9fDNpT1kKtOecMcC
	 6DXRV+j27YYBNlPfFgiR6h/dIUn0qWAl5yjMvxFCHyUFuPxDNlDs9UgpagooKCuslI
	 HaqpD1v9sFiVrPBIZeyCVZBxoJ6ZTH9TxZYUJ00QGCHM13GWTLRZkFo5y5CIDneUk3
	 wxmk9dbiG63Pb1jfRq9cWSByZqVVeCchQf/03e05kasoaQqUo1cy1BYLyL7F73JEd8
	 AJaAGB8YivTz37rvsTGsR39LZ3dOr/5oYCA/r2atK4p0mlQJyBNHucyHI+Pll8DiVC
	 pGV1uwO9Iz/Ow==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 08/35] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
Date: Thu, 15 Feb 2024 13:08:20 +0100
Message-ID: <20240215120907.1542854-9-cem@kernel.org>
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

Source kernel commit: 3d2b6d034f0feb7741b313f978a2fe45e917e1be

This helper function validates that a range of *blocks* in the
realtime section is completely contained within the realtime section.
It does /not/ validate ranges of *rtextents*.  Rename the function to
avoid suggesting that it does, and change the type of the @len parameter
since xfs_rtblock_t is a position unit, not a length unit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c  | 4 ++--
 libxfs/xfs_types.c | 4 ++--
 libxfs/xfs_types.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index bc82b71f3..69549a94a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6190,8 +6190,8 @@ xfs_bmap_validate_extent(
 		return __this_address;
 
 	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
-		if (!xfs_verify_rtext(mp, irec->br_startblock,
-					  irec->br_blockcount))
+		if (!xfs_verify_rtbext(mp, irec->br_startblock,
+					   irec->br_blockcount))
 			return __this_address;
 	} else {
 		if (!xfs_verify_fsbext(mp, irec->br_startblock,
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 87abc8244..74ab1965a 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -148,10 +148,10 @@ xfs_verify_rtbno(
 
 /* Verify that a realtime device extent is fully contained inside the volume. */
 bool
-xfs_verify_rtext(
+xfs_verify_rtbext(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno,
-	xfs_rtblock_t		len)
+	xfs_filblks_t		len)
 {
 	if (rtbno + len <= rtbno)
 		return false;
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 9af98a975..9e45f13f6 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -231,8 +231,8 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-bool xfs_verify_rtext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
-		xfs_rtblock_t len);
+bool xfs_verify_rtbext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
+		xfs_filblks_t len);
 bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
-- 
2.43.0

