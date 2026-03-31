Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5735945BD57;
	Tue, 31 Mar 2026 21:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992548; cv=none; b=DaNZ74JCOqHQ/QWoLDWZ9YAOYiRmISb6bZ+egzOEqHh+wbT+bRg7C8Xh1Blf/0rDqEOodat06MM0aFyMjEthBAbWOZ/xzZwC/sBi4Q9drTvfc8ZRiaWTCQvRQ8Alhp3ECECAPVlQyL5xLZ3JcnS4BHmxA7LIklZPKoygG1/FYcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992548; c=relaxed/simple;
	bh=60UpzLwPFsE/OH5uzd9+hLYE021xyutp1l0GCWgkWzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzJPPWF+Ca1FM0oxT1377wDpnWTtYZIhT2PQUvTYzM1NkV+Ktp7mpG3kWXpbUdN2gNgh8Yu403Pf1JQCV1MnV6wk5fMdu/AlQ1a6bTdw0C5kNQG738MYHNjo532bse1w2Wwncf2hx6aZsCdgwsgeGYAJgtrkxKBLIHbcNwxYOkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xw+EUWPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xw+EUWPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FC5C2BCB0;
	Tue, 31 Mar 2026 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992548;
	bh=60UpzLwPFsE/OH5uzd9+hLYE021xyutp1l0GCWgkWzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xw+EUWPPKqXI5Y3+7jz37C8gOKzOu5zBRsL9J8Dn0tzhpzQNZwK4qJvpwrakcOhQl
	 SIQ6xvN7CIl+VXGRUtE2fy6rQmaAfaSR0JQF8eYGz8rvPMi8X8GxZfDjtvOIaAGtx5
	 4UzFYtA3iQWQr/sHePMarvGqB0s72i4h/t3S52GVaxjIbpBC25+YHxcBBL7ASHr/FB
	 59AaUCJoqNkTJ1ddFUBMRbYmiwpNMDf8jY9XAMWUHAQY7QXH/+K9gK43iW6wRP3B0K
	 PrNt+DASlufXx//ztkGd8gRrZDFOz/eL7CK+l2RcGRLfYG2wjY0kHKO/YhYLxPQ9JQ
	 wkj3wGWaTsb0Q==
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
Subject: [PATCH v6 11/22] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Tue, 31 Mar 2026 23:28:12 +0200
Message-ID: <20260331212827.2631020-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
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

