Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5985A3E2764;
	Wed, 20 May 2026 12:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280706; cv=none; b=J3wFwYwJkf16tyCkL2kRn2s2jONtvCekm9wBPn86XNsT88Evf5abWni26CPKWv8yRjf7oqKLpMQ4Un9hrDHqG84JpTYhLil4RHetRBIT4AhAyxm0T/nfj9dkkR1iPQZxl8xRt4gtzXu38ceR7PwOE+I5NM44+ODA4CIfGTAJFxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280706; c=relaxed/simple;
	bh=ED63hkK8etbxautcxx1u5AO9FSZT6ssFdgXiGIlo5Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7aeP1WeQgm9gfM++yuS40r2LULtyV8UuTuVXKPYD1pXElbcMb72Qz4W1VaBpLS+E/WCfTHDPs+7qfn61KlvaZrk6XF8YkkPL987oQiyY+eWHpuRlbvXEmAFGgXRIPgHQ32adQQt/sk6tMp9nY0uBNsEs8xfwFv3Pdf+YG0pt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1Y54qAh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1Y54qAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760041F000E9;
	Wed, 20 May 2026 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280702;
	bh=Xui3Yd2dYz+96SItktvVLM/CAryyTbeJqWzBMfavRug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o1Y54qAhJ+MlxLZEm34rOkFWoYDs6EpF5rRGiQxtOf/dkT3d6pKYzBvHIfo8NO3H1
	 9XvV6r7oJ8xiZjhbsYdW6kJhgMxOAiifi00n1VMJu4p6ePfib2S8A9Sw3IX4/xToBg
	 8iToT+Z8XG/HCgQDyRsi7c4MDkeL+n0cwWXE5afFOyr1hZstn35FMbCCm6NI7pJjVk
	 2fVy378BOftYgRAEbKqz1Ycnwdf1ZlFAAzKfvSBTy5zKIDSTgxUxC1bt8pbO1uTaNW
	 RN+Y/MiV7LxUyIBEK12JrxZwv+jqOUBRy0ZQUJNKL1chTTuEBlqUaN8EZCTd2g2WdH
	 dq7/puFX3RRfA==
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
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v10 22/22] xfs: enable ro-compat fs-verity flag
Date: Wed, 20 May 2026 14:37:20 +0200
Message-ID: <20260520123722.405752-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
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
index 4dff29659e40..0ce46c234b9c 100644
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
2.51.2

