Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CCE1A724C;
	Thu,  9 Apr 2026 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740516; cv=none; b=F0P1wRBn3rk2K1Epnaj9OKDR6UawkRWqhoy6aXtGGZSeSvV4bzVwQvq8gHmCELYWfQi7nRussevL6CJZ71Ji0xrTyus7v3nWgei2leByzuT815uIeHzNiwJRpryDVmdUemo/pwMzlgErl8xHOi33SuPvp8M9n1hoDPenWkYGIWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740516; c=relaxed/simple;
	bh=ED63hkK8etbxautcxx1u5AO9FSZT6ssFdgXiGIlo5Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCWqYbPKnVn4+IRA+u33NtU2uYy1UugPGjMlkqGrsltVRL+LS/b/bjX0u7pCNLzlLHsN7Ptn14D9jynUwMpz88zKAR1ZW4SqXqA+mOr5UFo0PzMZcn/sdK1ltdlFRE6Yv12g65KLm9cwWXY2QyTfhIyVnRzYFD3ccfhZnkJRSpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgnUKH/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgnUKH/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A5DC19424;
	Thu,  9 Apr 2026 13:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740516;
	bh=ED63hkK8etbxautcxx1u5AO9FSZT6ssFdgXiGIlo5Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgnUKH/UmPVe4QCfUQAd367I+wAQhreR/7jRfSjhmskf2ITh4ZeJByNXCpm0gSMAN
	 GrRDZ6tIIzRLTkPPDRuNLRNHjI8zieJVblUNNVyeEp0RRVxnVoVk2ULP7Sdxdnnz1j
	 fQQHqGe1OvKUyJF69mKixM8uBPdCCc5Ggu0lQ865W36TSg2gsGT7Kc+DSZfjqOIf2f
	 kO33NyQgjzb33ZCkJhhmnNmmUSDguta1aOssbIxMYZ0I/zmgbGyOhhCXeu3SGBvJcS
	 IBQ7Od5egeu3UhDxNgQ81hNMHkG07rdNIxO+yZQjIV3wql7az3anRMfY8ZjK7nSYkr
	 OOddv5UJ6xCVw==
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
Subject: [PATCH v7 22/22] xfs: enable ro-compat fs-verity flag
Date: Thu,  9 Apr 2026 15:13:54 +0200
Message-ID: <20260409131404.1545834-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
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

