Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8738F3D3CF7;
	Mon, 20 Jul 2026 09:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538322; cv=none; b=n+PmWw3XjDcIIqS+e6Ia/1r8v/Ybrzud59TR9KnWi2knICfLPnInd73I3nkRyzyaTt+QPmt40k6ArKm0YKT45qsayX5oHLvtmBMZfg0v91c8WHHIAmBc7XOeQbsJYwGPOKzXVZod+bs0VOUDaOjxKtu/7zTsp9qiSRj3okmHGMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538322; c=relaxed/simple;
	bh=gHl4HQg4dFPXM12xo/VO+LNovevHv2UmpG8XKevlUCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npwI9qd+DKzfhDr9zZkNBJHfW5wmgzTO6Jiqtg9Q9e19wfkAhZ5YRoYCi/SQHU9pH954hYeA0K+YXUfQiru4QI8fQRfmC/mH4M1Q8Szz6uoOY8aKHgwG9P5LBE7S/hTa1y1WVk9qTD4qi2o3ne8q7uDzA/v2SfZVRET4oCti820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4tTs5sn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4tTs5sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58A71F00A3A;
	Mon, 20 Jul 2026 09:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538321;
	bh=AufMkm+nEeCieeEcnf+ZJSfHdxMb9GSGIeKul87lEHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4tTs5snpsGIyCxOsMqLuiTUHKXvzvDv1HKYpw8kASU2Yg3mI58jja6lV2cHVbuuP
	 6uIY2GJ6olbkPEASMhJsh8xIylZe0OXiXORO3r6TAF/BBE/4EuUS2HcDn73lb3hATc
	 z72MpXklKW2PKnLRBZXcp6tuhP3FlEdljkg84DQcDtlE1e12qqgrve2n3oC6DWGYqR
	 YHjVLsqD3awT/B0dEX7gSSBNW73uPO8Y6RPIlqBTkpAhwe4ISYmWF5JjPjqC0wEH+z
	 1sk4lKi96rQi6rDqJ793H82RelVwap4IOgMzZuuCdpsbeGYoq/jAFgN+Y3OY1K53bl
	 cwzv0nH9tNdVQ==
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
Subject: [PATCH v12 09/21] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Mon, 20 Jul 2026 11:03:37 +0200
Message-ID: <20260720090410.3487990-10-aalbersh@kernel.org>
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

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 11dc1a485ca7..55667cc762f8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1370,6 +1370,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.54.0

