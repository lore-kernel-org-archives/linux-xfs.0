Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7B7F9C3
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7AOGOng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C90C433C8;
	Sun, 31 Dec 2023 21:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059716;
	bh=elzKaMcuOW4ifxnuGyV+M6fsuiIhxRHqnQLChFBGfcI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H7AOGOng7Z9wsMcQ/tK6CWz5xRTu1zQsZnLL6Q8BOSTGD25je/4ydqI7v/3zU8st5
	 iPqx/XPUG2jZAAhRnYkSMoQ9ewTozigAA2aj9psWmSGMX+R8rgsKZY+JZFHzW0dLAj
	 z2SgnrA3R5CowHYgavkgSdvVpd263h+bcLb918bVVHMATPNEVC36GW4Pbsf0re7P9Q
	 Jv9LX31ckhlIoL95xAwB//UeHwVLniRML82TEPxlFg8ji/QkwfUOyXiBkpLaWptwte
	 LFfo6ZKzTv/kjV9xdn4QDVOrgTxzTxeDseTguRs7nNhf6oYll3gIXnnwsXpGLcJixF
	 fENeLdXWQRAgg==
Date: Sun, 31 Dec 2023 13:55:15 -0800
Subject: [PATCH 41/44] xfs: repair inodes that have a refcount btree in the
 data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852239.1766284.2392902277010863021.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   47 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index b6b37652c4a35..a182a9551c08c 100644
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
@@ -924,6 +925,37 @@ xrep_dinode_bad_rmapbt_fork(
 	return false;
 }
 
+/* Return true if this refcount-format ifork looks like garbage. */
+STATIC bool
+xrep_dinode_bad_refcountbt_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	unsigned int		dfork_size,
+	int			whichfork)
+{
+	struct xfs_rtrefcount_root *dfp;
+	unsigned int		nrecs;
+	unsigned int		level;
+
+	if (whichfork != XFS_DATA_FORK)
+		return true;
+	if (dfork_size < sizeof(struct xfs_rtrefcount_root))
+		return true;
+
+	dfp = XFS_DFORK_PTR(dip, whichfork);
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
 /*
  * Check the data fork for things that will fail the ifork verifiers or the
  * ifork formatters.
@@ -1009,6 +1041,11 @@ xrep_dinode_check_dfork(
 				XFS_DATA_FORK))
 			return true;
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		if (xrep_dinode_bad_refcountbt_fork(sc, dip, dfork_size,
+				XFS_DATA_FORK))
+			return true;
+		break;
 	default:
 		return true;
 	}
@@ -1134,6 +1171,11 @@ xrep_dinode_check_afork(
 				XFS_ATTR_FORK))
 			return true;
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		if (xrep_dinode_bad_refcountbt_fork(sc, dip, afork_size,
+				XFS_ATTR_FORK))
+			return true;
+		break;
 	default:
 		return true;
 	}
@@ -1182,6 +1224,7 @@ xrep_dinode_ensure_forkoff(
 {
 	struct xfs_bmdr_block	*bmdr;
 	struct xfs_rtrmap_root	*rmdr;
+	struct xfs_rtrefcount_root *rcdr;
 	struct xfs_scrub	*sc = ri->sc;
 	xfs_extnum_t		attr_extents, data_extents;
 	size_t			bmdr_minsz = xfs_bmdr_space_calc(1);
@@ -1292,6 +1335,10 @@ xrep_dinode_ensure_forkoff(
 		rmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
 		dfork_min = xfs_rtrmap_broot_space(sc->mp, rmdr);
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		rcdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+		dfork_min = xfs_rtrefcount_broot_space(sc->mp, rcdr);
+		break;
 	default:
 		dfork_min = 0;
 		break;

