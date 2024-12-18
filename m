Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF9155C87;
	Wed, 18 Dec 2024 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734551469; cv=none; b=g1n5T3eLr+xi0xy9s5FsKPTz7lSHSRM4MCE237JbzNelkXOgj8PM4rC53O1zxFuUMOlDcxinvYsSEJ1iyed/uazVlm55++tBbWQ2LxLKRN4JaFiNtIEcdTi9PcWCe3Ux+h/P6hxLht6BvF0bA5VGnUeGPUrM9QDe2Jn4EUCxiVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734551469; c=relaxed/simple;
	bh=MgiFm2ucMhp8vNXtOs5W1tD8ARsPIlL0yy1JIUMJQ1s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ljN18lDXLjnzwDwWsVKcKqiuXauBG69uFNshe2pfv7DzTsi2xqC3cDdS90It/DW/NHVw2mkU4wreis46g9QY+u1iW1y4danP+cgHGvtLZ5tUi51CvLrph/a9hd9wgQegMGDdvAVx4RK2niC3qRLaV59VoA+5R451MrVJ9cp3kP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PufoGnOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PufoGnOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5060DC4CECD;
	Wed, 18 Dec 2024 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734551468;
	bh=MgiFm2ucMhp8vNXtOs5W1tD8ARsPIlL0yy1JIUMJQ1s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PufoGnOj9LmjQObR8paRRvaZfnF9AfPdJ49C/YRStJKBm9R/j5VF4gytrKoU1FPf6
	 /aVskDs9lYVoAwiTrt8xSiXgdM2HUVi8l57h1gKtebLc5B9DMuXiyFl1Q5Jkm5JWfo
	 9TB+CpiGhdGWq5eOOo+dmLG4CB18Q/hZf/VqgxM/R7bdshwWHMH5XgQ70Qy3gLl+as
	 dKm96soQkYBqpAd/9o2s7dHVQOV+fXi7WmOOj6lM7eI5ZLkJ2ZgKbOJbatkrSNVa2Z
	 XMG3HgLUmnnUbmWgTVZaTxtilDr8hqBpXNdH3Aghl8WqLGCa1mlDPrxqR3mY/VOHpk
	 i1hZxs325wO4w==
Date: Wed, 18 Dec 2024 11:51:07 -0800
Subject: [PATCH 4/5] xfs: fix sb_spino_align checks for large fsblock sizes
From: "Darrick J. Wong" <djwong@kernel.org>
To: stable@vger.kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173455093563.305755.14124909419754195900.stgit@frogsfrogsfrogs>
In-Reply-To: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
References: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit 7f8a44f37229fc76bfcafa341a4b8862368ef44a upstream.

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

Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: 59e43f5479cce1 ("xfs: sb_spino_align is not verified")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 9e0ae312bc8035..e27b63281d012a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -392,12 +392,13 @@ xfs_validate_sb_common(
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

