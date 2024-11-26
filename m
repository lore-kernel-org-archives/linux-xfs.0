Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3862193419
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 20:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732652779; cv=none; b=Oo7nlEUw2xLCA5Cw0QrK2GMrnihW51C4+NbGnRl6musNrsjDylxVGQlU6jfbqSdx2eNiO3f9X45sSwxYRE2kg0VIIWZbNRajr2/+d5/C8Mkxve0vdntOdAz7V4QFrkI+0yiG4ehHw/eXXDwDZlIP1dA4y74zZ+l2b2OhrUmtLlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732652779; c=relaxed/simple;
	bh=XKWAfDlBjK3dtNS5NNERJJyg8oEZ+2X81uqAhUSSHKU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jk7Yv1xYJ93rESGxhaVaiCFd5vTyNRpC5iZWMB4bx0mkDvH8+3//tamhYiGWkb9P1NgSJhwWSQMG1+wKcN8HGI9LFWhGFOBIdEJTyi/A+zAJ5KK238HZK5pZh1MNENJwMmWaGGlyM21ih9mpX3r4a/jeNBTrhgJQaCTw8EtpR1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uuJ/36Nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uuJ/36Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA5DC4CECF;
	Tue, 26 Nov 2024 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732652779;
	bh=XKWAfDlBjK3dtNS5NNERJJyg8oEZ+2X81uqAhUSSHKU=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=uuJ/36Nl2PpFLwER9WHYjYM6KqEviymSdoGyk0uY4OThyVG8/6RufG702DaUvo5IB
	 wzpVRgizP86ZjqsK9owfEqQeOoUuCnxXiWlvwwRFxjVW7PAyZJuOCAim5EPm4oWoko
	 wGqnl8zseIM52WXTaYbE9eHLsbTBJsVM1mbEnv5FnII5isva7qwA94/ASTRo15VwKU
	 w+FiafO3T9ASZJTJfFbpkLtBzJJi9n9Mw4G3t0BUPL8G0fk/401ll8vuDzqkg1Gw5T
	 hyZ1tTW0z/jzu7+OFGCVyLlDWLt3M/zFjyQlh/6YZFi2ZlM0bckk0N1b3mE/zYrbFp
	 xs0UnIdjqs1AA==
Date: Tue, 26 Nov 2024 12:26:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 22/21] xfs: fix sb_spino_align checks for large fsblock sizes
Message-ID: <20241126202619.GO9438@frogsfrogsfrogs>
References: <20241126011838.GI9438@frogsfrogsfrogs>
 <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>

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
 fs/xfs/libxfs/xfs_sb.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a809513a290cf4..3b5623611eba02 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -494,12 +494,13 @@ xfs_validate_sb_common(
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
