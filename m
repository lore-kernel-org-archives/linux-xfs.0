Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E783B3C0E;
	Fri, 10 Jul 2026 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673665; cv=none; b=lsKZWfenixHoLiWvyEjQvWDxn3N3psvw5Ibk9y19L4j+aA/aM03x9jw+tk5mSf85jPaAZSnPf0lj1W+vO51Y7W9kvdsuhkbSBWQZWeNu9EL81keIig2ZvZ37Y0VQG2aPydP/Dl3WULbmSAzpeJU6Z5oai7ogZNJmxlkNNZBs3HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673665; c=relaxed/simple;
	bh=oLsUxhIgOGII8FockpMXTs1qqBWzV+X+1MIELSdjFQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/lJ8xktDOIX/roRJJ9jFDkAze8/D8bLEnpLZi/yd+C9WGyYpgeLVMTYqzoZ5zMv3HMZZI6GisIxfye092W7CQ++eQkizzgOuFrwsBxbglA4aCfPshreNvSCg7AgdPn9O59CjWmoqqaJz3/h7NxXABWqjz+H8R5uyGjN5PS9NlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nK5jpHF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nK5jpHF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAE51F000E9;
	Fri, 10 Jul 2026 08:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673664;
	bh=+47nVRLEZQw/YviSfUoLbkFDroVKuX0Z4+TWL8l7VFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nK5jpHF93VoaK0Uhid8ipouObrVpM3Q2pjZhykcHhSf2MYV9sb4ESGUt5y9VOFCM2
	 qVPZu4gDfn9hDtEOIlOUYi5c6dPDEr0YBcEIUUH/MOTj6TCe2Cw+/CPnmoNs3Q1CSb
	 wRH4z2Bb/gp0mTrCYRWq5HSd6gSz/EA3dY/w+Xza4pAHSaULDSEE1Jkcgc9KWVCE0+
	 bNcdk2MBRjznD900Uc0NkbqXkQ5ueyk9/Xruv4yS0hXqkiy2iO14ivSsYzkrTv0NCf
	 qM/EFM8QTepMQB8kNht45t0H0lVrevMdTMdhnALYs0D0Db+6eob+39c6tB+UIIs312
	 2v9eWIU5BXJ1w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v11 20/20] xfs: enable ro-compat fs-verity flag
Date: Fri, 10 Jul 2026 10:52:48 +0200
Message-ID: <20260710085256.3464201-21-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add spaces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7b0511eb03d0..2878bc9cb656 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,8 +378,9 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.54.0

