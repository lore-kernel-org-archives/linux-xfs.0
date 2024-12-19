Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6161990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637408; cv=none; b=Wavf0BEGpSZTtY+kuZ7j0TDslwaSZV8hdfEEon3sfd6psrJwrC7WHnaMtllKna1ZpacJ3bARPCHIkNroWCyTTXmf47xlkenHfTu0DcymYrvrVauXOyxPxgP6p9VPovb11d9A76mvlK7WnPW2uQYfZpCMTReFidpwru16EJ3uNdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637408; c=relaxed/simple;
	bh=N6jhuOH6nAirVOJnHVL7sFwfhfG1pR5ZFrgNuoV274I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cxOyGjnCpwUWYK7wv3EpxtdqOA69wSSm7xw9d7W07s5w52Gp6IYs1uKfiy3Nl0Gk7fMm6bxLczwS/OB5Wz0Ylj4MIiZggCynSXvm3upEfKNZsNL8gk7jL9YAqBY2IP6IJCDCli7z3EGaR7tTiZRvFI42Ktt1okloInp1CjxJC70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udvIOesi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udvIOesi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4881C4CECE;
	Thu, 19 Dec 2024 19:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637407;
	bh=N6jhuOH6nAirVOJnHVL7sFwfhfG1pR5ZFrgNuoV274I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=udvIOesivplqp0i7sAKbLDMhCtMvdOsFRxhXU/bm+/DJSIHoRujecPPvahoWkbt/w
	 0aT3b/WTb0Fs5JDl8kgim7WmLRayfQyUUm5bQNiq7SgF/nfInvvZ5Jf3g3aUr/FgQp
	 GUNit2h2/w9p51Ml7Ko2uKhHavZkxB5FGfXUa599csgvt8ikDa8LPXN0umc3sPIPXW
	 4xs17bxKrvaULiznz8uV9OrtRfP7NvPb2MH4m5uYJXYaAw2AqUFgBYkGIMke7dBIgN
	 ugxYbzg/utzhi3hOKvMfsUtYXmVoGeQJxxQBuOPFQIcDDADOkJ3ImaFtLn6QNGKId1
	 6RC5hFrYOb+wA==
Date: Thu, 19 Dec 2024 11:43:27 -0800
Subject: [PATCH 40/43] xfs: repair inodes that have a refcount btree in the
 data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581662.1572761.7121669588497325519.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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

