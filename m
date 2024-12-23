Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BED518FC89;
	Mon, 23 Dec 2024 22:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991891; cv=none; b=KRYBhkFdpiWjYWjBxdReB31Gb74CYpykYmbYN6GELKb4MmXe4e5X41A7L46HNG2KVB2uxoADF5bN5CO9bLLGAm94k6KHJP7IHNDfEsNdKW9Mo3zHAdfv5Lm7K5effZN9q4ZtE5RVfGjAuTrzLCic5jrXLw+dSpZJvTnOhMIzfNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991891; c=relaxed/simple;
	bh=6p0Sr/ygEeg2WmiEEQbDZ3EC59uKdIspS9B5fAln5mU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g9ELnfczvSskoU8v+NuF4xYkOJqa+o2fg26TLnYso3JO2iy8UloGkgI9zKk65WzOLNsNJQhdNLxGM1bMNBQCXdn9K3KXQfeEygv/CfBnHaC62PFIy7bjGIoJ6qVE/ux8CoB3NMC/NJ4iOUy3FY/BkM2noLA1qMQwGuh6T/GPWFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpGP2lKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpGP2lKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E045C4CED3;
	Mon, 23 Dec 2024 22:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991891;
	bh=6p0Sr/ygEeg2WmiEEQbDZ3EC59uKdIspS9B5fAln5mU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CpGP2lKBmVYFg4uxtkk0XmaCCHtEBbx1qeMuOcH0rfHGDxTCEwBC/1MomYwzP97l7
	 ya+3ln4Oxynoanr/XyVpP2KDYFuOYRpiTKb/Re7DAIoQPmWG8TJDYDrUvF3V8uQWRe
	 AKPyhAjYA1r49NBoHuEw2ZdOzkdQTuMB69i8f6VaLZINJ1FHfPiME0JQJnUKj04tfD
	 SQKclZZSwrI5qzGjcnN1k10/KplESJv2jzIKvPxTYYdo/GDGiz3sasIx7HRWO2pTn3
	 G4hBPnHsqW8fDJIGm0au2ATQQYxjLgLenPat+qn0RwidextHUnvhKP/fvC5LWTHiGy
	 +LN0BqUIU/cmQ==
Date: Mon, 23 Dec 2024 14:11:30 -0800
Subject: [PATCH 51/52] xfs: fix sb_spino_align checks for large fsblock sizes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943271.2295836.9010694528322717024.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7f8a44f37229fc76bfcafa341a4b8862368ef44a

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

