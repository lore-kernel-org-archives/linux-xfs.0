Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2B3D3482;
	Thu,  9 Apr 2026 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740487; cv=none; b=KgZASLcyf4j3fgI+tehnsnMCtCE6kLQFAdWg2o119utMVN2Ovb8yBNDYXMYe8pu6hnBw0PbLIm3d6Yk619JK1f9qPf0dg/SSZaAi5Nps/tsN/svxdeV1Gc/o3Pco9Usio2USOAFym2ja8PZPPw3wepF2fKzd/9s8klh5XFIB89Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740487; c=relaxed/simple;
	bh=60UpzLwPFsE/OH5uzd9+hLYE021xyutp1l0GCWgkWzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwSCpx+tQgbQhXAxndwT8eaHSGN4oAUXwNr2ocqeSd7NqKKN/H/t9jZHMr3jGvoxQiw+Dt9Ok6MYUEx1TcXThgVYJ28GF8K4PeGvRy23l6u8PZBLptsWY4CB366k1bucfWGsyJJsOygRomcZCJ3v1fBa1nub4YRxuBD/9vOhqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UKD4lyFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UKD4lyFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9DAC19424;
	Thu,  9 Apr 2026 13:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740486;
	bh=60UpzLwPFsE/OH5uzd9+hLYE021xyutp1l0GCWgkWzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKD4lyFg4opZe3vfypZtbbemlJWxR74gyF8riPaWp/xnwDFuVoAY78ueFD+2T2GJ5
	 eI/25Ap+BuEK0DC/qkrF8QKwRd7i1sYmv5Zjy1Qc6W8/cuBfpuBn+qUxMBoyKPiasR
	 PapB7mfMcqrEkhP3XpXy/5TQavwLaqr2eFrXAd+IZ53ZbztKBVB5TyoQ9Up7AumjIN
	 QJTFJ3UAP7gLxCEvCQfMIMFWZA6RRbXNX9xZaCBL4Mgby0VOleIaHlTPEzAEKNj1uG
	 rR8BYewYTc4WWmvMFq1d02o8H+ggr6XWfS4c+Wk6mVmpUxQEHtmxxtnkqdpAjASeme
	 Apn3gS5pc026g==
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
Subject: [PATCH v7 12/22] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Thu,  9 Apr 2026 15:13:44 +0200
Message-ID: <20260409131404.1545834-13-aalbersh@kernel.org>
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
index ca369eb96561..17efc83a86ed 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1387,6 +1387,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.51.2

