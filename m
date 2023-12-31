Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C58BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xo3LlZpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271FDC433C8;
	Sun, 31 Dec 2023 21:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058746;
	bh=jb1UgfnOPX94YCGJJeKTy0vnAuzFOj9qU9vy65qEDNI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xo3LlZpZ0sxAbar+jrsnWKdieRhwNDOURhXFHOURTve4bmgUjXS73pVys0tyudKgr
	 rAzLgau/9PniVA2XoAvbUskZeo6DQZEc3F9yohBfkVzUb0rxjpPV8Hb6VExi7mRIGE
	 5Qfl709osxjohsexFDGR06SCW2sg6orYbKg10bPiLUe2DmJloo4LlHoNEYSLVMrZ4I
	 ScTFVgbyn0KMPnI2cY6oNQ/HwP4mZN4pQWoVJdtk7PiWM7MsR2X+41w41aS9dw2DA/
	 s+YB1hIFVcFGcccJXaI45x4GbtlvRa4vxzb25H5uxLTN2oQZPHDIN8uis5B/5hDlzr
	 S2Yq+3lMNSQMQ==
Date: Sun, 31 Dec 2023 13:39:05 -0800
Subject: [PATCH 28/39] xfs: scan rt rmap when we're doing an intense rmap
 check of bmbt mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850351.1764998.5239025918043401996.stgit@frogsfrogsfrogs>
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

Teach the bmbt scrubber how to perform a comprehensive check that the
rmapbt does not contain /any/ mappings that are not described by bmbt
records when it's dealing with a realtime file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   60 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 604c4df2fdb34..696ac7208c4d5 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -21,6 +21,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_health.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -637,12 +639,20 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		xfs_fsblock_t	startblock;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
-		if (irec.br_startblock != XFS_AGB_TO_FSB(sc->mp,
-				cur->bc_ag.pag->pag_agno,
-				check_rec.rm_startblock))
+		if (cur->bc_btnum == XFS_BTNUM_RMAP)
+			startblock = XFS_AGB_TO_FSB(sc->mp,
+					cur->bc_ag.pag->pag_agno,
+					check_rec.rm_startblock);
+		else
+			startblock = xfs_rgbno_to_rtb(sc->mp,
+					cur->bc_ino.rtg->rtg_rgno,
+					check_rec.rm_startblock);
+		if (irec.br_startblock != startblock)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_blockcount > check_rec.rm_blockcount)
@@ -696,6 +706,30 @@ xchk_bmap_check_ag_rmaps(
 	return error;
 }
 
+/* Make sure each rt rmap has a corresponding bmbt entry. */
+STATIC int
+xchk_bmap_check_rt_rmaps(
+	struct xfs_scrub		*sc,
+	struct xfs_rtgroup		*rtg)
+{
+	struct xchk_bmap_check_rmap_info sbcri;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	xfs_rtgroup_lock(NULL, rtg, XFS_RTGLOCK_RMAP);
+	cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp, rtg, rtg->rtg_rmapip);
+
+	sbcri.sc = sc;
+	sbcri.whichfork = XFS_DATA_FORK;
+	error = xfs_rmap_query_all(cur, xchk_bmap_check_rmap, &sbcri);
+	if (error == -ECANCELED)
+		error = 0;
+
+	xfs_btree_del_cursor(cur, error);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+	return error;
+}
+
 /*
  * Decide if we want to scan the reverse mappings to determine if the attr
  * fork /really/ has zero space mappings.
@@ -750,10 +784,6 @@ xchk_bmap_check_empty_datafork(
 {
 	struct xfs_ifork	*ifp = &ip->i_df;
 
-	/* Don't support realtime rmap checks yet. */
-	if (XFS_IS_REALTIME_INODE(ip))
-		return false;
-
 	/*
 	 * If the dinode repair found a bad data fork, it will reset the fork
 	 * to extents format with zero records and wait for the this scrubber
@@ -805,6 +835,22 @@ xchk_bmap_check_rmaps(
 	xfs_agnumber_t		agno;
 	int			error;
 
+	if (xfs_ifork_is_realtime(sc->ip, whichfork)) {
+		struct xfs_rtgroup	*rtg;
+		xfs_rgnumber_t		rgno;
+
+		for_each_rtgroup(sc->mp, rgno, rtg) {
+			error = xchk_bmap_check_rt_rmaps(sc, rtg);
+			if (error ||
+			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
+				xfs_rtgroup_rele(rtg);
+				return error;
+			}
+		}
+
+		return 0;
+	}
+
 	for_each_perag(sc->mp, agno, pag) {
 		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
 		if (error ||

