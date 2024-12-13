Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF3E10F7
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052841; cv=none; b=hxVQIZ5nRxpJ9eaRCZbzBHrmmFh/b4OoIocVK42KNZ69mNR/U2aD56t4N6kAq6/XXTomOwJasnWqI3oho0xCUs/ra7euUmFgfm20Yr5mEyu3F2BdPL4fU4ooA9cuRtD6m+fwpB0GqbCiOGrrHRgr/TXcY77n34+fsuSBqzSGp48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052841; c=relaxed/simple;
	bh=suWySFVfzwiN5L/TfRLQnEH5VUaqp3DpL9y1ZDy6QSA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STKwQc+ahlkRWc49VyYHADFf6R+qDqIcQIU9PxhlOhpz1A8TZmGy2hp9RYhwqdJrvUnKjZ1+voN5Wb9PsNPjYbdQydPPQdLke5uPFy6UXDaj3AnY/Dv+wRXQPShCynAMMpN2YLvQycunUXY4wT/ph9+zEDHWjZ2uF+qLDIlFzco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHrcTj6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHrcTj6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023F8C4CECE;
	Fri, 13 Dec 2024 01:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052841;
	bh=suWySFVfzwiN5L/TfRLQnEH5VUaqp3DpL9y1ZDy6QSA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CHrcTj6CD2H9ZGNN4DHEUYEYAGvk9Ukz7BOtknN+miybSFJw0YtZbwEsBjkIgLeLL
	 aqJfqGS/1GWayLsqQT65OMmDjI277eyqRV3CywHV4lgpHzRYPY8KLK7mQBRz5bcAHw
	 5TQeVoEwbb9sx/BK2a+sfSdZPvyLykZ6PnaOt8gmXbmNK6j8LEPDGfqrZSx3Pbq5X2
	 /9ObwrGb2jCGa5VmNEC+5bBOkSux29vDPV/4rPA3cO+Q5i8fy13m3vKxieN8JIB1wp
	 HCFQTVoWBF/Q7PvGyN0Qd4hzOO8dHbX+lcIHcY4MvfNC/8gam0z3X9ixr9i1c4+0nE
	 +lqxJhqUSXZbA==
Date: Thu, 12 Dec 2024 17:20:40 -0800
Subject: [PATCH 40/43] xfs: repair inodes that have a refcount btree in the
 data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125252.1182620.17852915977168175150.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

