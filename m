Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE02BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QeyKBHo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837C8C433C7;
	Sun, 31 Dec 2023 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058808;
	bh=jf3w9WMZmFVo2XW5zq/B9PlurFTOu0PZWALJH/rXQnY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QeyKBHo2rlDk4vEYYuNS6TdTava5uB/OAZ3xwfI5Hw6LCxN+mGM203EVPYTvcFGSW
	 9M1+/Z9jS2OJUMK7EwT+A2gcu9NKBQsVDw3RgkBcEweooLRl125C/bCMf1qinnEciX
	 7D2BEAf0vOZBsGCaWU0gg54KG4nF3pMWb7hEf2/82CQef5+/HI1dt/16Owa+yaOjhj
	 J85gzcabheCL63EK8hKBfWBAgMt04isnL3JEn6p/qHbxpfG6omWIH82+ApShoalXq1
	 o1oYmqlnrHgfkD1UKkqEoqntkz3fpGqUFKXI+bdj7Tk8FfW0A6u6a+GNdwIDgDa/jI
	 dWBBpLEtYcwYw==
Date: Sun, 31 Dec 2023 13:40:08 -0800
Subject: [PATCH 32/39] xfs: repair inodes that have realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850415.1764998.13498058839507532597.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Plumb into the inode core repair code the ability to search for extents
on realtime devices.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   63 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 2b3a6cbadae71..45ad78d1e5404 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -38,6 +38,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -718,18 +720,77 @@ xrep_dinode_count_ag_rmaps(
 	return error;
 }
 
+/* Count extents and blocks for an inode given an rt rmap. */
+STATIC int
+xrep_dinode_walk_rtrmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_inode		*ri = priv;
+	int				error = 0;
+
+	if (xchk_should_terminate(ri->sc, &error))
+		return error;
+
+	/* We only care about this inode. */
+	if (rec->rm_owner != ri->sc->sm->sm_ino)
+		return 0;
+
+	if (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))
+		return -EFSCORRUPTED;
+
+	ri->rt_blocks += rec->rm_blockcount;
+	ri->rt_extents++;
+	return 0;
+}
+
+/* Count extents and blocks for an inode from all realtime rmap data. */
+STATIC int
+xrep_dinode_count_rtgroup_rmaps(
+	struct xrep_inode	*ri,
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	int			error;
+
+	if (!xfs_has_realtime(sc->mp) ||
+	    xrep_is_rtmeta_ino(sc, rtg, sc->sm->sm_ino))
+		return 0;
+
+	error = xrep_rtgroup_init(sc, rtg, &sc->sr, XFS_RTGLOCK_RMAP);
+	if (error)
+		return error;
+
+	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_dinode_walk_rtrmap,
+			ri);
+	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_free(sc, &sc->sr);
+	return error;
+}
+
 /* Count extents and blocks for a given inode from all rmap data. */
 STATIC int
 xrep_dinode_count_rmaps(
 	struct xrep_inode	*ri)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	int			error;
 
-	if (!xfs_has_rmapbt(ri->sc->mp) || xfs_has_realtime(ri->sc->mp))
+	if (!xfs_has_rmapbt(ri->sc->mp))
 		return -EOPNOTSUPP;
 
+	for_each_rtgroup(ri->sc->mp, rgno, rtg) {
+		error = xrep_dinode_count_rtgroup_rmaps(ri, rtg);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
+	}
+
 	for_each_perag(ri->sc->mp, agno, pag) {
 		error = xrep_dinode_count_ag_rmaps(ri, pag);
 		if (error) {

