Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948143D3305;
	Mon, 20 Jul 2026 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538358; cv=none; b=Akj9MgrnkCcP9MOboxv1pE2shCROCXdlpTY81Z+y3m1w7VfbGCSKxkedlnxLY+QLOMx8cIEkBeMsDevb1BA80S+2BMUa7ZFMlCzFn7WN4+WmnqdwRYQS/uTmtC2lq4IRtYySRh7dZ5k7fFlswhWrHkX+PvjQ2z652nXCkaHAyzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538358; c=relaxed/simple;
	bh=oLsUxhIgOGII8FockpMXTs1qqBWzV+X+1MIELSdjFQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qENz6ylQrlQhohIhRR7Pr/0dPyfEObej5f8nHDS4DqtesIAJ3RJbAEtrqfWaNCzCVwNObsU4HB7Z/7mOiYd5jkQuR/vARYtD4tY4iIZbFRCCvgztSLh6Ff9Gs7J2s5wZ19Rhmj4JNmuJltkBiyzR2tizB4LBCHWi8EYhwwCPVjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=djz3AyRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djz3AyRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D701F000E9;
	Mon, 20 Jul 2026 09:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538357;
	bh=+47nVRLEZQw/YviSfUoLbkFDroVKuX0Z4+TWL8l7VFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djz3AyRlLkB4EkzF9XWbuuDmZe4Vyk4m9uHeptIXgIMMQDolgQXMzFDrwrVOvNuCD
	 0ePpAYkqAfTuh4rjVA7tgpC1Aq2nPtxte0FPnLjE3yRxyxW4uBDwA/+PrDFi0jQo2J
	 QlUNV/fstm94CtFNZHncpUfU0mFEPumgaj0xQ6upXL1qrNj4u0iDEujohhGxo0SPO2
	 27pDk680D1ldc5hbBPLeE4PM45qQpEgVxNtGH++yAXVOa8BJwNUNmleu2VAu1A7MVZ
	 /iUNh2cCa5AmVBILtt+zIYtrCrMTRUJLYI1198U/WpO3T1ZITzNgi7/Vi8NU7GjZLA
	 TNYl1NDqbW5NQ==
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
Subject: [PATCH v12 21/21] xfs: enable ro-compat fs-verity flag
Date: Mon, 20 Jul 2026 11:03:49 +0200
Message-ID: <20260720090410.3487990-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
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

