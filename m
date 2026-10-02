Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3402047F3B5;
	Fri,  2 Oct 2026 22:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980708; cv=none; b=KyMbKo40QcDDqYLIyZkgC/lwJc76BFazC4Rd3SIHZsYrRBtcmmpsxyrpC8SHyKWb1ShAakpoLy/Ha77qlr1oTpMfloEm4RtidtgUp6RCaq5dDJ5ViPJWxVvy1p+0keMVRlJkltab1HMqYO/QUwzHKDOc1PhiAktDHfCzTF0ukq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980708; c=relaxed/simple;
	bh=zD3fqdriNeyS4psrX9dNSbGJrsTYYoWrAlK7wvQAbGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oxpcs8rSg3deG8VG7UrL7a3J4HZugpk0jtx7iM1Y2kXzLfEQs6C0nLXz+qIiTZ+1/Il5JPUeoVHZupJJVtljhL9+1OkN6aJ7TzLz5zEUfQyDZQSCBo5V36UT8+gmPN1D1BL7BH2oKTVZ6t9ApaJAAqHtEgbZG/A/XfW+JPit4GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CoJCQSqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CoJCQSqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E791F00893;
	Fri,  2 Oct 2026 22:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980706;
	bh=9UsWTPXNPtGAnC/NXDW+DJPQrI7L9qVnDZTXWpl6xCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CoJCQSqArVqS0yKPYrOGWg4qTKQn2ygVJn+7hmo/BCrCkxzJv5atgfDpFT8avQm/g
	 DGNvxqqoAJIbU//Wy5j4qch4BUgGKmtRXU0VNSgOUaIV4SRlbYIUYkMZNbahH/jERW
	 e+psjlv8/NZecBW5zWx8NndLCuoWlqGOLZYGxzt25FxphFT4uGvU6xx6eEmXbP99L3
	 XYoFYFyPq42CpODG66a+MpnH0r2b1o85XXMEOUNG8strfFwdWMYibG5/4Y/SZoUn8i
	 Xdz+3SXxSBQP0AnOw9jtq/I+0tVUH60SqmQUcUCoKEryplFze0e9wd1LSDkWWJ5W5J
	 81YnHyO6PHvcA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 21/21] xfs: enable ro-compat fs-verity flag
Date: Sat,  3 Oct 2026 00:37:02 +0200
Message-ID: <20261002223705.2175542-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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
index fc196d9e12dd..8be1b101b196 100644
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

