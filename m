Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7AA1ADFE4;
	Mon, 20 Apr 2026 11:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685721; cv=none; b=of35MV49ky9H2hGlRQjXRFQbUI1L/FlCcFglH161Y5SIgEdLlhv9ZUOY8SXv+A429XaKD7tZUKC5h80nybH0fMdiIbFlq1G/VsEr4SlQUwPpW7JU/2/X3fDr2e3QVmncteJof33uTMOYbGCbGfhveVB/FrtLzRVcrJrik9dSNRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685721; c=relaxed/simple;
	bh=ED63hkK8etbxautcxx1u5AO9FSZT6ssFdgXiGIlo5Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEWh3NJ8B9Ct6SYbkoEx0dQLAnQy+tD66y4DMp2LU75zOY1Tl1++lr8pcDkAjE011ckqRc+mqD5MMlJHE1NKFICsrzIpXUKpjpHg2YrW+3OhO3JvrxPzfFCV+jpd0/SPTX2Lo3Up3AksejajJfGS5/IHvMWNaqLF2xsTKsRxuC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ai4tBxXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ai4tBxXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74534C19425;
	Mon, 20 Apr 2026 11:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685720;
	bh=ED63hkK8etbxautcxx1u5AO9FSZT6ssFdgXiGIlo5Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ai4tBxXnb6Q6Om3Wf03DLZiYeJtpsj3GdIe4hKff147JbjcXEwG/YKMilPtSU0UZT
	 0/rYTN6KoGve8Cgs3AMzx3epjYZFxnkZCmoMI4NJ4luuSouWzwODtMq9YHbStv6DL4
	 BQkYFPw2sGhUMjWUy/yCjscKDu6lPopcsleW02Mln5LDpfnAea2t6jb2qItutCU1uA
	 c2lKEdjspn+mzm9cyklKx8G//fkxEKAdA3N29udK7f6l9lpBBH88beFmKxdAP7CCW8
	 R+jDOuenLkl+ujGhelgXOQQB1IoHFqaCa6pksNeWmJ7ttHPlbUYHQgobYcUQS7IzBw
	 STYeXI/Q896yA==
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
Subject: [PATCH v8 22/22] xfs: enable ro-compat fs-verity flag
Date: Mon, 20 Apr 2026 13:47:09 +0200
Message-ID: <20260420114714.1621982-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
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

