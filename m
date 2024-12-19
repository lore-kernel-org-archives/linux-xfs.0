Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F951ACECE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636579; cv=none; b=YX7+kQkL75LgJnHhf725NZqDLuJMwAfIu13VyMfhxgIQt3tgX+BMIXS6KBmaSD15dC1NBzSCSlCZw13DGtLXPJs07xLxVYeY6WZduTdYhyZTO6/YfiRrkLFBOPCIMsyTwk/w4P2P1IKL9WcSMG5aVY8XaqZEi4OMDe0/c1V3XI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636579; c=relaxed/simple;
	bh=WRh9DLDHhcw25IQoUsFXXjmVsMEim/qaUxSpvez3fAs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UuJnCE0uO98H2wh/T8C1ljR/MOrVwsy+8ZsA5c1W3BUtp9T6RJMiwlcH8d5SkRBM3zkCsnQWkd3tFSBZM/SDEnEtpojPe15l7Z4/UoDZ48MR4iWGMT3rkc0Z6BM+rQpJfpNKYCemshQlARvX5ydhn1GwGxxNHTV8PELZ+9yEIm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VfwrFOcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfwrFOcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFEFC4CECE;
	Thu, 19 Dec 2024 19:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636579;
	bh=WRh9DLDHhcw25IQoUsFXXjmVsMEim/qaUxSpvez3fAs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VfwrFOcXX6P03GQuinegK512Nl0xD5y3HQlWRANT5lBvjeiHPXjj8at4d1T3Kq6PA
	 Xkr3M+QjzTTpKgIbXvsrTBgojqB2Ae2e5KFqv0tCSWI4dxWnww++h0J2lfiX+8oATh
	 X1y2L5TYOcULU5FLL/xvgu2o/gwdugw9HBwEkou23NYmcH0aTvuY0RNAuvuMmAt+B5
	 76svKIzKrAAxfcCtoinQo2Is5URgaA8Fct9Nowt/2ZuIECDIaDNwGWkQz9WK/3jGE/
	 st/OiA+9hkKiPjbhm4X98Z13AUnXj48WMNxAqXMIbm2qVGNc2Wr2qsdK7HNb5as1dr
	 1MGBzLmwwA2Rg==
Date: Thu, 19 Dec 2024 11:29:38 -0800
Subject: [PATCH 24/37] xfs: scan rt rmap when we're doing an intense rmap
 check of bmbt mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580169.1571512.15058335111050252771.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c |   48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b7f9f3b3d81a3a..f6077b0cba8a14 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -21,6 +21,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_rtgroup.h"
 #include "xfs_health.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -641,8 +643,7 @@ xchk_bmap_check_rmap(
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_startblock !=
-		    xfs_agbno_to_fsb(to_perag(cur->bc_group),
-				check_rec.rm_startblock))
+		    xfs_gbno_to_fsb(cur->bc_group, check_rec.rm_startblock))
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_blockcount > check_rec.rm_blockcount)
@@ -696,6 +697,30 @@ xchk_bmap_check_ag_rmaps(
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
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	cur = xfs_rtrmapbt_init_cursor(sc->tp, rtg);
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
@@ -750,10 +775,6 @@ xchk_bmap_check_empty_datafork(
 {
 	struct xfs_ifork	*ifp = &ip->i_df;
 
-	/* Don't support realtime rmap checks yet. */
-	if (XFS_IS_REALTIME_INODE(ip))
-		return false;
-
 	/*
 	 * If the dinode repair found a bad data fork, it will reset the fork
 	 * to extents format with zero records and wait for the this scrubber
@@ -804,6 +825,21 @@ xchk_bmap_check_rmaps(
 	struct xfs_perag	*pag = NULL;
 	int			error;
 
+	if (xfs_ifork_is_realtime(sc->ip, whichfork)) {
+		struct xfs_rtgroup	*rtg = NULL;
+
+		while ((rtg = xfs_rtgroup_next(sc->mp, rtg))) {
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
 	while ((pag = xfs_perag_next(sc->mp, pag))) {
 		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
 		if (error ||

