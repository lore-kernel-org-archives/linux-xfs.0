Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B32D3C4555;
	Fri,  2 Oct 2026 22:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980697; cv=none; b=hGf69/wqcQJgYb3tmKKbzerm1EotiFnP5UVm98/RkzBwWimKUhoHaVLPY2pnbSWNG9vA0ab+Cg3Hz62dSerKEggRPeMEilD6EiDvmODKCDF6rPtiCrZuqpEufbUx1BfaBVCuU5IcH2d1ZUOOHOzqFHaPrxZJpy4I9t/OSO96rHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980697; c=relaxed/simple;
	bh=GoZafcVwYM13EDs2y2xw2tBf35tv1AhEEm1Y2K/M1NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLE61xGpJZha/ChCtjKpRmrQX2pHC9x96wfoKr/yE/TWF2Z+cOQn7kUMbCLgBIAp/C0UOd0IymGUCiO3woFwlA9mz3PQdQJ3BN06UKyoDzPuPsCkrC5WaXkNBsThiaHn+gx6AvQNAnZKrcBuAbdK557GZi4pt2n4K5FSUvhxeN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0wWX9iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0wWX9iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195DC1F000FF;
	Fri,  2 Oct 2026 22:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980696;
	bh=bSv6TKlW4NbrjSEeVlXfAwkAliMrPUfKHonbv3D6dao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0wWX9ivYxTyhCJGmh6b7cl5KdugmN9y7kixaF3pF3CuKALxTEITnlu6quHULbOJq
	 rI+TBQ3p24lsFoZY2367W0bIXiZQiz4/vxm+TbMvRWwLWvUOtQK3m75gPhFmdhSNxl
	 66PHIYgEO1nHOw0ZIP//n2qbl6Z/Z5GVH3rrA6soTFEsSB7xpIGv2z8odxyoWs9wIp
	 /1UlQiAbl5cJrmC8x6mtx8cQQilCHK+/jdZY8LPBdgboPXDGKAgJHiGehgi/50Uvrf
	 jT7h3NOcdS0WRtbsZzuC97/QAE8PCq0zt3BG0Qz9kRzaN20ndr3yqMsB9egd6EK0eC
	 pQ2ZrYbsFIA3g==
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
	david@fromorbit.com,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v17 18/21] xfs: advertise fs-verity being available on filesystem
Date: Sat,  3 Oct 2026 00:36:59 +0200
Message-ID: <20261002223705.2175542-19-aalbersh@kernel.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 185f09f327c0..c80133784419 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 985c7c6a09f2..fd06c3d6cc11 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1587,6 +1587,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.54.0

