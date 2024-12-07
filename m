Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E509139B
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529880; cv=none; b=l1IlAwWVKYKsa1npHK2ZRX1eEooktp9EqxsNRzE6lQop6p3DZgbmllxYMApJDRuSIhFxMZXvgpClFNXwbeuVR7Btt8TbO/1hFbYGjQrtyn57U3l7F4fB0foz91JirH/Vk6MM2mons7b0PPykhcFJlvMmqmJY5Y8x9jEIlV4St6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529880; c=relaxed/simple;
	bh=RUwpNSZPWzJTw/q9ytF6X/09sb0EQADhnmb3c37dtqI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EaB/MVvFA7QFRR1gwtWBOOHQsjCB99hsRqIvSSHQdv3j/rwYlq84vjsu4Saxi9dGxYwthbIeyCwvWYm/jPU5HmYrV+vZGU/IhBgSiHoh1Pg6LD8S4o58yhsteFNMiDiKXPoCZGxnXxUCqfvWfZhQYG5ErMshwf4hxw2JHhHdMR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMIC6p1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMIC6p1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030E5C4CED1;
	Sat,  7 Dec 2024 00:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529880;
	bh=RUwpNSZPWzJTw/q9ytF6X/09sb0EQADhnmb3c37dtqI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tMIC6p1ZVOvHMhgXfJfN1huiZBtYc10JQlVwtKcQDX2cDpvYBO/YxSRRXgWgIIdr/
	 JYkH6is/uwbCzUApRT0H09tzXAyw/fkfisWnTo3MKH1jd2u0ZuwTJhsisMP64ikQNJ
	 H5DJ9tvi3dVf8yzRH0MKRDGmjbam6p2Jv4Oz2uudbf1d+kGu7/xEAjZ9f3ABR3Df8V
	 1ycw5nD5GGaY1c/MV8fAGY7FybbQoEERgYguo4alQy90LvdRlJNaGyvAF/pKqhDGaX
	 +hWz/xu15CgwYB+CuzM1TjDn0QYbHq7ltLgrploUzVh2vU3o52uZFKM9Eccv1/P3Lm
	 YO3/mjlicVhyw==
Date: Fri, 06 Dec 2024 16:04:39 -0800
Subject: [PATCH 5/6] xfs: fix sb_spino_align checks for large fsblock sizes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352751275.126106.4817221069844942594.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
References: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For a sparse inodes filesystem, mkfs.xfs computes the values of
sb_spino_align and sb_inoalignmt with the following code:

	int     cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;

	if (cfg->sb_feat.crcs_enabled)
		cluster_size *= cfg->inodesize / XFS_DINODE_MIN_SIZE;

	sbp->sb_spino_align = cluster_size >> cfg->blocklog;
	sbp->sb_inoalignmt = XFS_INODES_PER_CHUNK *
			cfg->inodesize >> cfg->blocklog;

On a V5 filesystem with 64k fsblocks and 512 byte inodes, this results
in cluster_size = 8192 * (512 / 256) = 16384.  As a result,
sb_spino_align and sb_inoalignmt are both set to zero.  Unfortunately,
this trips the new sb_spino_align check that was just added to
xfs_validate_sb_common, and the mkfs fails:

# mkfs.xfs -f -b size=64k, /dev/sda
meta-data=/dev/sda               isize=512    agcount=4, agsize=81136 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=65536  blocks=324544, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=65536  ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=65536  blocks=5006, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=65536  blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
Discarding blocks...Sparse inode alignment (0) is invalid.
Metadata corruption detected at 0x560ac5a80bbe, xfs_sb block 0x0/0x200
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x1
mkfs.xfs: Releasing dirty buffer to free list!
found dirty buffer (bulk) on free list!
Sparse inode alignment (0) is invalid.
Metadata corruption detected at 0x560ac5a80bbe, xfs_sb block 0x0/0x200
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x1
mkfs.xfs: writing AG headers failed, err=22

Prior to commit 59e43f5479cce1 this all worked fine, even if "sparse"
inodes are somewhat meaningless when everything fits in a single
fsblock.  Adjust the checks to handle existing filesystems.

Fixes: 59e43f5479cce1 ("xfs: sb_spino_align is not verified")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_sb.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 87f740e6c75dce..ff23803a8065bf 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -491,12 +491,13 @@ xfs_validate_sb_common(
 				return -EINVAL;
 			}
 
-			if (!sbp->sb_spino_align ||
-			    sbp->sb_spino_align > sbp->sb_inoalignmt ||
-			    (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0) {
+			if (sbp->sb_spino_align &&
+			    (sbp->sb_spino_align > sbp->sb_inoalignmt ||
+			     (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0)) {
 				xfs_warn(mp,
-				"Sparse inode alignment (%u) is invalid.",
-					sbp->sb_spino_align);
+"Sparse inode alignment (%u) is invalid, must be integer factor of (%u).",
+					sbp->sb_spino_align,
+					sbp->sb_inoalignmt);
 				return -EINVAL;
 			}
 		} else if (sbp->sb_spino_align) {

