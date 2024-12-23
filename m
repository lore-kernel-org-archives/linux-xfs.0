Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6637462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995803; cv=none; b=VSpgV42yFdZnarMMkiH0Vf3GKYpbSyRQGOzi9jbtrxaU01Ts4AugjRZFiXb7AQf5sGLx3kNZ8uafcB1lJft6wQVwS30SIuv31sdW2IoID69KjFYdip+r7inRxPXYgvzl5XeUOhlmltGb3ngYZJxr6iia+EqPDT3h2HM8HztfeN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995803; c=relaxed/simple;
	bh=N6jhuOH6nAirVOJnHVL7sFwfhfG1pR5ZFrgNuoV274I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSD4pXxohvqYM7Ooqtb1xJQtnn/eMh/KqxmduTHlQ1c8wbl+4W/DmJiyqJ5qkEwsug9xNYyhfjuseIZ6Vqj7vz/VAFnRDTOPLc8GhwCg3OUHnFmGu2iLvdWyCUVRM1jpuP2dDBKhaIZRLezfkQmFheyDckku3uvT3RIa2RMAoJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hB62Ul3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hB62Ul3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5954C4CED3;
	Mon, 23 Dec 2024 23:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995802;
	bh=N6jhuOH6nAirVOJnHVL7sFwfhfG1pR5ZFrgNuoV274I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hB62Ul3z86d3rB3/ynW/K3xFVSPnv5bmNe/4lY3opkL/v3LmDxajefYpl3FnpE64A
	 HHOtsDlxkrii41SKlf1CQ6sD+VREG0o3FrVVyRWIWLWcyPGPOBWhPnUVzEdsuXuzMs
	 IXPuCs9dIg1ycbA4K3ZECGYbIwJbJSn+rFx4UviNqtKFfGBxsfH0C4Qwj1dWQY4MMA
	 DmV5S0ZD/jbQUw8m5LCTW2qX4jzsN0+9seSqkFP3cWdtsxF+f9xObLpHLs6peEe3h6
	 ZrvmVrnzN1tJ+n57kG7i/EmKH1gEXy/b89/8EsK4A6S0VLwXYfhQNTT16TVsfFccoK
	 zL/7goWlpxw0w==
Date: Mon, 23 Dec 2024 15:16:42 -0800
Subject: [PATCH 40/43] xfs: repair inodes that have a refcount btree in the
 data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420623.2381378.2678036565876501364.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Plumb knowledge of refcount btrees into the inode core repair code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 701baee144a66e..2f641b6d663eb2 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -40,6 +40,7 @@
 #include "xfs_symlink_remote.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -970,6 +971,34 @@ xrep_dinode_bad_rtrmapbt_fork(
 	return false;
 }
 
+/* Return true if this refcount-format ifork looks like garbage. */
+STATIC bool
+xrep_dinode_bad_rtrefcountbt_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	unsigned int		dfork_size)
+{
+	struct xfs_rtrefcount_root *dfp;
+	unsigned int		nrecs;
+	unsigned int		level;
+
+	if (dfork_size < sizeof(struct xfs_rtrefcount_root))
+		return true;
+
+	dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	nrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
+
+	if (level > sc->mp->m_rtrefc_maxlevels)
+		return true;
+	if (xfs_rtrefcount_droot_space_calc(level, nrecs) > dfork_size)
+		return true;
+	if (level > 0 && nrecs == 0)
+		return true;
+
+	return false;
+}
+
 /* Check a metadata-btree fork. */
 STATIC bool
 xrep_dinode_bad_metabt_fork(
@@ -984,6 +1013,8 @@ xrep_dinode_bad_metabt_fork(
 	switch (be16_to_cpu(dip->di_metatype)) {
 	case XFS_METAFILE_RTRMAP:
 		return xrep_dinode_bad_rtrmapbt_fork(sc, dip, dfork_size);
+	case XFS_METAFILE_RTREFCOUNT:
+		return xrep_dinode_bad_rtrefcountbt_fork(sc, dip, dfork_size);
 	default:
 		return true;
 	}
@@ -1249,6 +1280,7 @@ xrep_dinode_ensure_forkoff(
 {
 	struct xfs_bmdr_block	*bmdr;
 	struct xfs_rtrmap_root	*rmdr;
+	struct xfs_rtrefcount_root *rcdr;
 	struct xfs_scrub	*sc = ri->sc;
 	xfs_extnum_t		attr_extents, data_extents;
 	size_t			bmdr_minsz = xfs_bmdr_space_calc(1);
@@ -1361,6 +1393,10 @@ xrep_dinode_ensure_forkoff(
 			rmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
 			dfork_min = xfs_rtrmap_broot_space(sc->mp, rmdr);
 			break;
+		case XFS_METAFILE_RTREFCOUNT:
+			rcdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+			dfork_min = xfs_rtrefcount_broot_space(sc->mp, rcdr);
+			break;
 		default:
 			dfork_min = 0;
 			break;

