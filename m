Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80754E5354;
	Fri, 18 Sep 2026 11:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730177; cv=none; b=QnH4EtvfnwAt0ljsDZctUIyHrT4fnrdcMf+z3J+32AtL2XTzFCSfF7LLzq+WD8WBvRnAuvNqsVMJa3fFJ8jvcWskwiK3f79we7kBMr7EcAX3K+5BW9Dpg/aOLqk1HlvH5kihY6kFZjSsoAEpTJpL5JlUX8N/a3Y4+lOYMVBPCY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730177; c=relaxed/simple;
	bh=H/e0P+UlJBXIJCMWsp5bxESKBgwV9KeCad/muhyUdmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4B6VMUYFpEB9YgHemUjDh/7GT8wljTUbpedilfhmrbz6cOlXEPKYPLtr+BrpG8ZA1GGyrFnemntdfdCp0h6gipQdj6qaH4hObeMUrBnVyUIqC/sSNbyDQlLw1ASnLrnsNOXsgz/EGLaLqqE9f+VTOruTM+TbRnPWPtemgg9Qiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1zmhfPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1zmhfPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D2E1F000FF;
	Fri, 18 Sep 2026 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730175;
	bh=tyN8+gtU92vgNY5ULImxmqhPQNG/e7/IRfFO6L6Bczg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1zmhfPuB3eWjGJ8+HUeW4aOIv9heH2h4oqCwT1HbwzCMvxN3cVAmC3mW4GycylLU
	 sDhK8csu45egFrMwtGAskDjO+9AAObefpTeATg0fSGm7iO6dUXDmICIyyWhaGqSqt/
	 C303RxKaFzCQveOKD3O5zt14IwOYr8bkrQ+5FgVtSOyA5vVEYGZr7/cKFHUOFuzau1
	 a5IhAxrbSYeu284PF5eCoKFUULRK4nNWAy6sWb0NVcC9QS6OdlyBlAHAwr6J01E8cL
	 a4wpzEAAzmj3j87VNvivqy1EGXL/S67XbZm4PPEnVT4Dfaao34l9UASlNuPNIRHFQR
	 Hon1W5fezjpJA==
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
Subject: [PATCH v16 08/21] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Fri, 18 Sep 2026 13:15:20 +0200
Message-ID: <20260918111539.1003439-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
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
index c7ecbb3d258a..b07ca2a33c64 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1369,6 +1369,8 @@ xfs_inode_should_enable_dax(
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

