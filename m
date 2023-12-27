Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A72CA4E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfLtUKt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D1AC433C7;
	Mon,  1 Jan 2024 00:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067283;
	bh=493wTA1sxqL+Ad3stb8HOPEGU1Y/8kEjZyzUZDBKpNQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VfLtUKt6Eto31S1ke4f9fMSuWyNRaXIbE8LdHk+F5H4/XnUCoOJiTPIJa3RP2r56U
	 9OUij+CoSZvM5c1noj1wCK0Uy4mSfiYSwbGiDB++Ff3ehVhCvQSqXXkNidKBXVKcFk
	 Fsv0CJWingEUnkFEmi/nWTSkTrNssaVnB8bmlChE+cgWOXgWCOMXMxWR1xawZKPJ5a
	 z9p8bgnp3dtEL6sJY9K4ruBr/B3L0pRAhZP+CyrjyA5B3e5zU+euozvvILyrw097Ek
	 y7+TA6rT/2il6fi4iR138Rt6fBOP0o7FUsN05LYotw4qe3/tqC9heVQl42ZYBOP5yB
	 dYHQr+RlbQMEw==
Date: Sun, 31 Dec 2023 16:01:22 +9900
Subject: [PATCH 01/14] xfs: replace shouty XFS_BM{BT,DR} macros
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013213.1812545.3599503738664394372.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
References: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
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

Replace all the shouty bmap btree and bmap disk root macros with actual
functions, and fix a type handling error in the xattr code that the
macros previously didn't care about.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bmap.c               |   10 +-
 db/bmap_inflate.c       |    2 
 db/bmroot.c             |    8 +-
 db/check.c              |    8 +-
 db/frag.c               |    8 +-
 db/metadump.c           |   16 ++--
 libxfs/xfs_attr_leaf.c  |    8 +-
 libxfs/xfs_bmap.c       |   40 +++++----
 libxfs/xfs_bmap_btree.c |   18 ++--
 libxfs/xfs_bmap_btree.h |  204 ++++++++++++++++++++++++++++++++---------------
 libxfs/xfs_inode_fork.c |   30 +++----
 libxfs/xfs_trans_resv.c |    2 
 repair/bmap_repair.c    |    2 
 repair/dinode.c         |   10 +-
 repair/prefetch.c       |    8 +-
 repair/scan.c           |    6 +
 16 files changed, 228 insertions(+), 152 deletions(-)


diff --git a/db/bmap.c b/db/bmap.c
index 874135f001e..7915772aaee 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -78,8 +78,8 @@ bmap(
 		push_cur();
 		rblock = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 		fsize = XFS_DFORK_SIZE(dip, mp, whichfork);
-		pp = XFS_BMDR_PTR_ADDR(rblock, 1, libxfs_bmdr_maxrecs(fsize, 0));
-		kp = XFS_BMDR_KEY_ADDR(rblock, 1);
+		pp = xfs_bmdr_ptr_addr(rblock, 1, libxfs_bmdr_maxrecs(fsize, 0));
+		kp = xfs_bmdr_key_addr(rblock, 1);
 		bno = select_child(curoffset, kp, pp,
 					be16_to_cpu(rblock->bb_numrecs));
 		for (;;) {
@@ -88,9 +88,9 @@ bmap(
 			block = (struct xfs_btree_block *)iocur_top->data;
 			if (be16_to_cpu(block->bb_level) == 0)
 				break;
-			pp = XFS_BMBT_PTR_ADDR(mp, block, 1,
+			pp = xfs_bmbt_ptr_addr(mp, block, 1,
 				libxfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
-			kp = XFS_BMBT_KEY_ADDR(mp, block, 1);
+			kp = xfs_bmbt_key_addr(mp, block, 1);
 			bno = select_child(curoffset, kp, pp,
 					be16_to_cpu(block->bb_numrecs));
 		}
@@ -98,7 +98,7 @@ bmap(
 			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 			nextents = be16_to_cpu(block->bb_numrecs);
 			xp = (xfs_bmbt_rec_t *)
-				XFS_BMBT_REC_ADDR(mp, block, 1);
+				xfs_bmbt_rec_addr(mp, block, 1);
 			for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 				if (!bmap_one_extent(ep, &curoffset, eoffset,
 						&n, bep)) {
diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index a3ad6ad3832..118d911a1db 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -282,7 +282,7 @@ iroot_size(
 	unsigned int		nr_this_level,
 	void			*priv)
 {
-	return XFS_BMAP_BROOT_SPACE_CALC(cur->bc_mp, nr_this_level);
+	return xfs_bmap_broot_space_calc(cur->bc_mp, nr_this_level);
 }
 
 static int
diff --git a/db/bmroot.c b/db/bmroot.c
index 246e390a8a3..7ef07da181e 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -89,7 +89,7 @@ bmroota_key_offset(
 	block = (xfs_bmdr_block_t *)((char *)obj + byteize(startoff));
 	ASSERT(dip->di_forkoff != 0 && (char *)block == XFS_DFORK_APTR(dip));
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	kp = XFS_BMDR_KEY_ADDR(block, idx);
+	kp = xfs_bmdr_key_addr(block, idx);
 	return bitize((int)((char *)kp - (char *)block));
 }
 
@@ -127,7 +127,7 @@ bmroota_ptr_offset(
 	block = (xfs_bmdr_block_t *)((char *)obj + byteize(startoff));
 	ASSERT(dip->di_forkoff != 0 && (char *)block == XFS_DFORK_APTR(dip));
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	pp = XFS_BMDR_PTR_ADDR(block, idx,
+	pp = xfs_bmdr_ptr_addr(block, idx,
 		libxfs_bmdr_maxrecs(XFS_DFORK_ASIZE(dip, mp), 0));
 	return bitize((int)((char *)pp - (char *)block));
 }
@@ -185,7 +185,7 @@ bmrootd_key_offset(
 	ASSERT(obj == iocur_top->data);
 	block = (xfs_bmdr_block_t *)((char *)obj + byteize(startoff));
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	kp = XFS_BMDR_KEY_ADDR(block, idx);
+	kp = xfs_bmdr_key_addr(block, idx);
 	return bitize((int)((char *)kp - (char *)block));
 }
 
@@ -222,7 +222,7 @@ bmrootd_ptr_offset(
 	dip = obj;
 	block = (xfs_bmdr_block_t *)((char *)obj + byteize(startoff));
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	pp = XFS_BMDR_PTR_ADDR(block, idx,
+	pp = xfs_bmdr_ptr_addr(block, idx,
 		libxfs_bmdr_maxrecs(XFS_DFORK_DSIZE(dip, mp), 0));
 	return bitize((int)((char *)pp - (char *)block));
 }
diff --git a/db/check.c b/db/check.c
index 7d0687a9db7..d1c86206c08 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2366,13 +2366,13 @@ process_btinode(
 		return;
 	}
 	if (be16_to_cpu(dib->bb_level) == 0) {
-		xfs_bmbt_rec_t	*rp = XFS_BMDR_REC_ADDR(dib, 1);
+		xfs_bmbt_rec_t	*rp = xfs_bmdr_rec_addr(dib, 1);
 		process_bmbt_reclist(rp, be16_to_cpu(dib->bb_numrecs), type,
 							id, totd, blkmapp);
 		*nex += be16_to_cpu(dib->bb_numrecs);
 		return;
 	} else {
-		pp = XFS_BMDR_PTR_ADDR(dib, 1, libxfs_bmdr_maxrecs(
+		pp = xfs_bmdr_ptr_addr(dib, 1, libxfs_bmdr_maxrecs(
 				XFS_DFORK_SIZE(dip, mp, whichfork), 0));
 		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
 			scan_lbtree(get_unaligned_be64(&pp[i]),
@@ -4422,7 +4422,7 @@ scanfunc_bmap(
 			error++;
 			return;
 		}
-		rp = XFS_BMBT_REC_ADDR(mp, block, 1);
+		rp = xfs_bmbt_rec_addr(mp, block, 1);
 		*nex += be16_to_cpu(block->bb_numrecs);
 		process_bmbt_reclist(rp, be16_to_cpu(block->bb_numrecs), type, id, totd,
 			blkmapp);
@@ -4438,7 +4438,7 @@ scanfunc_bmap(
 		error++;
 		return;
 	}
-	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[0]);
+	pp = xfs_bmbt_ptr_addr(mp, block, 1, mp->m_bmap_dmxr[0]);
 	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
 		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, type, id,
 					totd, toti, nex, blkmapp, 0, btype);
diff --git a/db/frag.c b/db/frag.c
index 4efc6ad07f8..1165e824a37 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -243,11 +243,11 @@ process_btinode(
 
 	dib = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	if (be16_to_cpu(dib->bb_level) == 0) {
-		xfs_bmbt_rec_t		*rp = XFS_BMDR_REC_ADDR(dib, 1);
+		xfs_bmbt_rec_t		*rp = xfs_bmdr_rec_addr(dib, 1);
 		process_bmbt_reclist(rp, be16_to_cpu(dib->bb_numrecs), extmapp);
 		return;
 	}
-	pp = XFS_BMDR_PTR_ADDR(dib, 1,
+	pp = xfs_bmdr_ptr_addr(dib, 1,
 		libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
 	for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
 		scan_lbtree(get_unaligned_be64(&pp[i]),
@@ -437,7 +437,7 @@ scanfunc_bmap(
 				   nrecs, typtab[btype].name);
 			return;
 		}
-		rp = XFS_BMBT_REC_ADDR(mp, block, 1);
+		rp = xfs_bmbt_rec_addr(mp, block, 1);
 		process_bmbt_reclist(rp, nrecs, extmapp);
 		return;
 	}
@@ -447,7 +447,7 @@ scanfunc_bmap(
 			   nrecs, typtab[btype].name);
 		return;
 	}
-	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[0]);
+	pp = xfs_bmbt_ptr_addr(mp, block, 1, mp->m_bmap_dmxr[0]);
 	for (i = 0; i < nrecs; i++)
 		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, extmapp,
 									btype);
diff --git a/db/metadump.c b/db/metadump.c
index be4cc01ff26..ccf7b89ccd5 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -250,8 +250,8 @@ zero_btree_node(
 		if (nrecs > mp->m_bmap_dmxr[1])
 			return;
 
-		bkp = XFS_BMBT_KEY_ADDR(mp, block, 1);
-		bpp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
+		bkp = xfs_bmbt_key_addr(mp, block, 1);
+		bpp = xfs_bmbt_ptr_addr(mp, block, 1, mp->m_bmap_dmxr[1]);
 		zp1 = (char *)&bkp[nrecs];
 		zp2 = (char *)&bpp[nrecs];
 		key_end = (char *)bpp;
@@ -316,7 +316,7 @@ zero_btree_leaf(
 		if (nrecs > mp->m_bmap_dmxr[0])
 			return;
 
-		brp = XFS_BMBT_REC_ADDR(mp, block, 1);
+		brp = xfs_bmbt_rec_addr(mp, block, 1);
 		zp = (char *)&brp[nrecs];
 		break;
 	case TYP_INOBT:
@@ -2156,7 +2156,7 @@ scanfunc_bmap(
 					typtab[btype].name, agno, agbno);
 			return 1;
 		}
-		return process_bmbt_reclist(XFS_BMBT_REC_ADDR(mp, block, 1),
+		return process_bmbt_reclist(xfs_bmbt_rec_addr(mp, block, 1),
 					    nrecs, sbm->typ, sbm->is_meta);
 	}
 
@@ -2166,7 +2166,7 @@ scanfunc_bmap(
 					nrecs, typtab[btype].name, agno, agbno);
 		return 1;
 	}
-	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
+	pp = xfs_bmbt_ptr_addr(mp, block, 1, mp->m_bmap_dmxr[1]);
 	for (i = 0; i < nrecs; i++) {
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
@@ -2229,7 +2229,7 @@ process_btinode(
 	}
 
 	if (level == 0) {
-		return process_bmbt_reclist(XFS_BMDR_REC_ADDR(dib, 1),
+		return process_bmbt_reclist(xfs_bmdr_rec_addr(dib, 1),
 					    nrecs, itype, is_meta);
 	}
 
@@ -2242,13 +2242,13 @@ process_btinode(
 		return 1;
 	}
 
-	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
+	pp = xfs_bmdr_ptr_addr(dib, 1, maxrecs);
 
 	if (metadump.zero_stale_data) {
 		char	*top;
 
 		/* Unused btree key space */
-		top = (char*)XFS_BMDR_KEY_ADDR(dib, nrecs + 1);
+		top = (char*)xfs_bmdr_key_addr(dib, nrecs + 1);
 		memset(top, 0, (char*)pp - top);
 
 		/* Unused btree ptr space */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 14020c09146..28bb72f7a8a 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -669,7 +669,7 @@ xfs_attr_shortform_bytesfit(
 		 */
 		if (!dp->i_forkoff && dp->i_df.if_bytes >
 		    xfs_default_attroffset(dp))
-			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
+			dsize = xfs_bmdr_space_calc(MINDBTPTRS);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		/*
@@ -683,7 +683,7 @@ xfs_attr_shortform_bytesfit(
 				return 0;
 			return dp->i_forkoff;
 		}
-		dsize = XFS_BMAP_BROOT_SPACE(mp, dp->i_df.if_broot);
+		dsize = xfs_bmap_bmdr_space(dp->i_df.if_broot);
 		break;
 	}
 
@@ -691,11 +691,11 @@ xfs_attr_shortform_bytesfit(
 	 * A data fork btree root must have space for at least
 	 * MINDBTPTRS key/ptr pairs if the data fork is small or empty.
 	 */
-	minforkoff = max_t(int64_t, dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
+	minforkoff = max_t(int64_t, dsize, xfs_bmdr_space_calc(MINDBTPTRS));
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = XFS_LITINO(mp) - xfs_bmdr_space_calc(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= maxforkoff)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c69cb5c66df..d7cbef76067 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -73,9 +73,9 @@ xfs_bmap_compute_maxlevels(
 	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
 				whichfork);
 	if (whichfork == XFS_DATA_FORK)
-		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
+		sz = xfs_bmdr_space_calc(MINDBTPTRS);
 	else
-		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
+		sz = xfs_bmdr_space_calc(MINABTPTRS);
 
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
@@ -96,8 +96,8 @@ xfs_bmap_compute_attr_offset(
 	struct xfs_mount	*mp)
 {
 	if (mp->m_sb.sb_inodesize == 256)
-		return XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	return XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
+		return XFS_LITINO(mp) - xfs_bmdr_space_calc(MINABTPTRS);
+	return xfs_bmdr_space_calc(6 * MINABTPTRS);
 }
 
 STATIC int				/* error */
@@ -270,7 +270,7 @@ xfs_check_block(
 	prevp = NULL;
 	for( i = 1; i <= xfs_btree_get_numrecs(block); i++) {
 		dmxr = mp->m_bmap_dmxr[0];
-		keyp = XFS_BMBT_KEY_ADDR(mp, block, i);
+		keyp = xfs_bmbt_key_addr(mp, block, i);
 
 		if (prevp) {
 			ASSERT(be64_to_cpu(prevp->br_startoff) <
@@ -282,15 +282,15 @@ xfs_check_block(
 		 * Compare the block numbers to see if there are dups.
 		 */
 		if (root)
-			pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, i, sz);
+			pp = xfs_bmap_broot_ptr_addr(mp, block, i, sz);
 		else
-			pp = XFS_BMBT_PTR_ADDR(mp, block, i, dmxr);
+			pp = xfs_bmbt_ptr_addr(mp, block, i, dmxr);
 
 		for (j = i+1; j <= be16_to_cpu(block->bb_numrecs); j++) {
 			if (root)
-				thispa = XFS_BMAP_BROOT_PTR_ADDR(mp, block, j, sz);
+				thispa = xfs_bmap_broot_ptr_addr(mp, block, j, sz);
 			else
-				thispa = XFS_BMBT_PTR_ADDR(mp, block, j, dmxr);
+				thispa = xfs_bmbt_ptr_addr(mp, block, j, dmxr);
 			if (*thispa == *pp) {
 				xfs_warn(mp, "%s: thispa(%d) == pp(%d) %lld",
 					__func__, j, i,
@@ -345,7 +345,7 @@ xfs_bmap_check_leaf_extents(
 	level = be16_to_cpu(block->bb_level);
 	ASSERT(level > 0);
 	xfs_check_block(block, mp, 1, ifp->if_broot_bytes);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
+	pp = xfs_bmap_broot_ptr_addr(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 
 	ASSERT(bno != NULLFSBLOCK);
@@ -380,7 +380,7 @@ xfs_bmap_check_leaf_extents(
 		 */
 
 		xfs_check_block(block, mp, 0, 0);
-		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
+		pp = xfs_bmbt_ptr_addr(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, bno))) {
 			xfs_btree_mark_sick(cur);
@@ -420,14 +420,14 @@ xfs_bmap_check_leaf_extents(
 		 * conform with the first entry in this one.
 		 */
 
-		ep = XFS_BMBT_REC_ADDR(mp, block, 1);
+		ep = xfs_bmbt_rec_addr(mp, block, 1);
 		if (i) {
 			ASSERT(xfs_bmbt_disk_get_startoff(&last) +
 			       xfs_bmbt_disk_get_blockcount(&last) <=
 			       xfs_bmbt_disk_get_startoff(ep));
 		}
 		for (j = 1; j < num_recs; j++) {
-			nextp = XFS_BMBT_REC_ADDR(mp, block, j + 1);
+			nextp = xfs_bmbt_rec_addr(mp, block, j + 1);
 			ASSERT(xfs_bmbt_disk_get_startoff(ep) +
 			       xfs_bmbt_disk_get_blockcount(ep) <=
 			       xfs_bmbt_disk_get_startoff(nextp));
@@ -562,7 +562,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
 	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
 
-	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
+	pp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
 	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
@@ -690,7 +690,7 @@ xfs_bmap_extents_to_btree(
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
 			continue;
-		arp = XFS_BMBT_REC_ADDR(mp, ablock, 1 + cnt);
+		arp = xfs_bmbt_rec_addr(mp, ablock, 1 + cnt);
 		xfs_bmbt_disk_set_all(arp, &rec);
 		cnt++;
 	}
@@ -700,10 +700,10 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the root key and pointer.
 	 */
-	kp = XFS_BMBT_KEY_ADDR(mp, block, 1);
-	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
+	kp = xfs_bmbt_key_addr(mp, block, 1);
+	arp = xfs_bmbt_rec_addr(mp, ablock, 1);
 	kp->br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(arp));
-	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, xfs_bmbt_get_maxrecs(cur,
+	pp = xfs_bmbt_ptr_addr(mp, block, 1, xfs_bmbt_get_maxrecs(cur,
 						be16_to_cpu(block->bb_level)));
 	*pp = cpu_to_be64(args.fsbno);
 
@@ -872,7 +872,7 @@ xfs_bmap_add_attrfork_btree(
 
 	mp = ip->i_mount;
 
-	if (XFS_BMAP_BMDR_SPACE(block) <= xfs_inode_data_fork_size(ip))
+	if (xfs_bmap_bmdr_space(block) <= xfs_inode_data_fork_size(ip))
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
@@ -1139,7 +1139,7 @@ xfs_iread_bmbt_block(
 	}
 
 	/* Copy records into the incore cache. */
-	frp = XFS_BMBT_REC_ADDR(mp, block, 1);
+	frp = xfs_bmbt_rec_addr(mp, block, 1);
 	for (j = 0; j < num_recs; j++, frp++, ir->loaded++) {
 		struct xfs_bmbt_irec	new;
 		xfs_failaddr_t		fa;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 160f7b08ffd..be4979894a0 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -47,10 +47,10 @@ xfs_bmdr_to_bmbt(
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
 	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
-	fkp = XFS_BMDR_KEY_ADDR(dblock, 1);
-	tkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
-	fpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
-	tpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
+	fkp = xfs_bmdr_key_addr(dblock, 1);
+	tkp = xfs_bmbt_key_addr(mp, rblock, 1);
+	fpp = xfs_bmdr_ptr_addr(dblock, 1, dmxr);
+	tpp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, rblocklen);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
 	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
@@ -150,10 +150,10 @@ xfs_bmbt_to_bmdr(
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
 	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
-	fkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
-	tkp = XFS_BMDR_KEY_ADDR(dblock, 1);
-	fpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
-	tpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
+	fkp = xfs_bmbt_key_addr(mp, rblock, 1);
+	tkp = xfs_bmdr_key_addr(dblock, 1);
+	fpp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, rblocklen);
+	tpp = xfs_bmdr_ptr_addr(dblock, 1, dmxr);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
 	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
@@ -670,7 +670,7 @@ xfs_bmbt_maxrecs(
 	int			blocklen,
 	int			leaf)
 {
-	blocklen -= XFS_BMBT_BLOCK_LEN(mp);
+	blocklen -= xfs_bmbt_block_len(mp);
 	return xfs_bmbt_block_maxrecs(blocklen, leaf);
 }
 
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 151b8491f60..62fbc4f7c2c 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -13,70 +13,6 @@ struct xfs_inode;
 struct xfs_trans;
 struct xbtree_ifakeroot;
 
-/*
- * Btree block header size depends on a superblock flag.
- */
-#define XFS_BMBT_BLOCK_LEN(mp) \
-	(xfs_has_crc(((mp))) ? \
-		XFS_BTREE_LBLOCK_CRC_LEN : XFS_BTREE_LBLOCK_LEN)
-
-#define XFS_BMBT_REC_ADDR(mp, block, index) \
-	((xfs_bmbt_rec_t *) \
-		((char *)(block) + \
-		 XFS_BMBT_BLOCK_LEN(mp) + \
-		 ((index) - 1) * sizeof(xfs_bmbt_rec_t)))
-
-#define XFS_BMBT_KEY_ADDR(mp, block, index) \
-	((xfs_bmbt_key_t *) \
-		((char *)(block) + \
-		 XFS_BMBT_BLOCK_LEN(mp) + \
-		 ((index) - 1) * sizeof(xfs_bmbt_key_t)))
-
-#define XFS_BMBT_PTR_ADDR(mp, block, index, maxrecs) \
-	((xfs_bmbt_ptr_t *) \
-		((char *)(block) + \
-		 XFS_BMBT_BLOCK_LEN(mp) + \
-		 (maxrecs) * sizeof(xfs_bmbt_key_t) + \
-		 ((index) - 1) * sizeof(xfs_bmbt_ptr_t)))
-
-#define XFS_BMDR_REC_ADDR(block, index) \
-	((xfs_bmdr_rec_t *) \
-		((char *)(block) + \
-		 sizeof(struct xfs_bmdr_block) + \
-	         ((index) - 1) * sizeof(xfs_bmdr_rec_t)))
-
-#define XFS_BMDR_KEY_ADDR(block, index) \
-	((xfs_bmdr_key_t *) \
-		((char *)(block) + \
-		 sizeof(struct xfs_bmdr_block) + \
-		 ((index) - 1) * sizeof(xfs_bmdr_key_t)))
-
-#define XFS_BMDR_PTR_ADDR(block, index, maxrecs) \
-	((xfs_bmdr_ptr_t *) \
-		((char *)(block) + \
-		 sizeof(struct xfs_bmdr_block) + \
-		 (maxrecs) * sizeof(xfs_bmdr_key_t) + \
-		 ((index) - 1) * sizeof(xfs_bmdr_ptr_t)))
-
-/*
- * These are to be used when we know the size of the block and
- * we don't have a cursor.
- */
-#define XFS_BMAP_BROOT_PTR_ADDR(mp, bb, i, sz) \
-	XFS_BMBT_PTR_ADDR(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0))
-
-#define XFS_BMAP_BROOT_SPACE_CALC(mp, nrecs) \
-	(int)(XFS_BMBT_BLOCK_LEN(mp) + \
-	       ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t))))
-
-#define XFS_BMAP_BROOT_SPACE(mp, bb) \
-	(XFS_BMAP_BROOT_SPACE_CALC(mp, be16_to_cpu((bb)->bb_numrecs)))
-#define XFS_BMDR_SPACE_CALC(nrecs) \
-	(int)(sizeof(xfs_bmdr_block_t) + \
-	       ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t))))
-#define XFS_BMAP_BMDR_SPACE(bb) \
-	(XFS_BMDR_SPACE_CALC(be16_to_cpu((bb)->bb_numrecs)))
-
 /*
  * Maximum number of bmap btree levels.
  */
@@ -120,4 +56,144 @@ unsigned int xfs_bmbt_maxlevels_ondisk(void);
 int __init xfs_bmbt_init_cur_cache(void);
 void xfs_bmbt_destroy_cur_cache(void);
 
+/*
+ * Btree block header size depends on a superblock flag.
+ */
+static inline size_t
+xfs_bmbt_block_len(struct xfs_mount *mp)
+{
+	return xfs_has_crc(mp) ?
+			XFS_BTREE_LBLOCK_CRC_LEN : XFS_BTREE_LBLOCK_LEN;
+}
+
+/* Addresses of key, pointers, and records within an incore bmbt block. */
+
+static inline struct xfs_bmbt_rec *
+xfs_bmbt_rec_addr(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_bmbt_rec *)
+		((char *)block + xfs_bmbt_block_len(mp) +
+		 (index - 1) * sizeof(struct xfs_bmbt_rec));
+}
+
+static inline struct xfs_bmbt_key *
+xfs_bmbt_key_addr(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_bmbt_key *)
+		((char *)block + xfs_bmbt_block_len(mp) +
+		 (index - 1) * sizeof(struct xfs_bmbt_key *));
+}
+
+static inline xfs_bmbt_ptr_t *
+xfs_bmbt_ptr_addr(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	unsigned int		index,
+	unsigned int		maxrecs)
+{
+	return (xfs_bmbt_ptr_t *)
+		((char *)block + xfs_bmbt_block_len(mp) +
+		 maxrecs * sizeof(struct xfs_bmbt_key) +
+		 (index - 1) * sizeof(xfs_bmbt_ptr_t));
+}
+
+/* Addresses of key, pointers, and records within an ondisk bmbt block. */
+
+static inline struct xfs_bmbt_rec *
+xfs_bmdr_rec_addr(
+	struct xfs_bmdr_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_bmbt_rec *)
+		((char *)(block + 1) +
+		 (index - 1) * sizeof(struct xfs_bmbt_rec));
+}
+
+static inline struct xfs_bmbt_key *
+xfs_bmdr_key_addr(
+	struct xfs_bmdr_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_bmbt_key *)
+		((char *)(block + 1) +
+		 (index - 1) * sizeof(struct xfs_bmbt_key));
+}
+
+static inline xfs_bmbt_ptr_t *
+xfs_bmdr_ptr_addr(
+	struct xfs_bmdr_block	*block,
+	unsigned int		index,
+	unsigned int		maxrecs)
+{
+	return (xfs_bmbt_ptr_t *)
+		((char *)(block + 1) +
+		 maxrecs * sizeof(struct xfs_bmbt_key) +
+		 (index - 1) * sizeof(xfs_bmbt_ptr_t));
+}
+
+/*
+ * Address of pointers within the incore btree root.
+ *
+ * These are to be used when we know the size of the block and
+ * we don't have a cursor.
+ */
+static inline xfs_bmbt_ptr_t *
+xfs_bmap_broot_ptr_addr(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*bb,
+	unsigned int		i,
+	unsigned int		sz)
+{
+	return xfs_bmbt_ptr_addr(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0));
+}
+
+/*
+ * Compute the space required for the incore btree root containing the given
+ * number of records.
+ */
+static inline size_t
+xfs_bmap_broot_space_calc(
+	struct xfs_mount	*mp,
+	unsigned int		nrecs)
+{
+	return xfs_bmbt_block_len(mp) + \
+	       (nrecs * (sizeof(struct xfs_bmbt_key) + sizeof(xfs_bmbt_ptr_t)));
+}
+
+/*
+ * Compute the space required for the incore btree root given the ondisk
+ * btree root block.
+ */
+static inline size_t
+xfs_bmap_broot_space(
+	struct xfs_mount	*mp,
+	struct xfs_bmdr_block	*bb)
+{
+	return xfs_bmap_broot_space_calc(mp, be16_to_cpu(bb->bb_numrecs));
+}
+
+/* Compute the space required for the ondisk root block. */
+static inline size_t
+xfs_bmdr_space_calc(unsigned int nrecs)
+{
+	return sizeof(struct xfs_bmdr_block) +
+	       (nrecs * (sizeof(struct xfs_bmbt_key) + sizeof(xfs_bmbt_ptr_t)));
+}
+
+/*
+ * Compute the space required for the ondisk root block given an incore root
+ * block.
+ */
+static inline size_t
+xfs_bmap_bmdr_space(struct xfs_btree_block *bb)
+{
+	return xfs_bmdr_space_calc(be16_to_cpu(bb->bb_numrecs));
+}
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 46da5edfb11..2d67e35c7e3 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -179,7 +179,7 @@ xfs_iformat_btree(
 
 	ifp = xfs_ifork_ptr(ip, whichfork);
 	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
-	size = XFS_BMAP_BROOT_SPACE(mp, dfp);
+	size = xfs_bmap_broot_space(mp, dfp);
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
@@ -192,7 +192,7 @@ xfs_iformat_btree(
 	 */
 	if (unlikely(ifp->if_nextents <= XFS_IFORK_MAXEXT(ip, whichfork) ||
 		     nrecs == 0 ||
-		     XFS_BMDR_SPACE_CALC(nrecs) >
+		     xfs_bmdr_space_calc(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
 		     ifp->if_nextents > ip->i_nblocks) ||
 		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork)) {
@@ -403,7 +403,7 @@ xfs_iroot_realloc(
 		 * allocate it now and get out.
 		 */
 		if (ifp->if_broot_bytes == 0) {
-			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
+			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
 			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
@@ -417,15 +417,15 @@ xfs_iroot_realloc(
 		 */
 		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 		new_max = cur_max + rec_diff;
-		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
+		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_NOFS | __GFP_NOFAIL);
-		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
 						     (int)new_size);
 		ifp->if_broot_bytes = (int)new_size;
-		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 			xfs_inode_fork_size(ip, whichfork));
 		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
 		return;
@@ -441,7 +441,7 @@ xfs_iroot_realloc(
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
-		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
+		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	else
 		new_size = 0;
 	if (new_size > 0) {
@@ -450,7 +450,7 @@ xfs_iroot_realloc(
 		 * First copy over the btree block header.
 		 */
 		memcpy(new_broot, ifp->if_broot,
-			XFS_BMBT_BLOCK_LEN(ip->i_mount));
+			xfs_bmbt_block_len(ip->i_mount));
 	} else {
 		new_broot = NULL;
 	}
@@ -462,16 +462,16 @@ xfs_iroot_realloc(
 		/*
 		 * First copy the records.
 		 */
-		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
-		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
+		op = (char *)xfs_bmbt_rec_addr(mp, ifp->if_broot, 1);
+		np = (char *)xfs_bmbt_rec_addr(mp, new_broot, 1);
 		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
 
 		/*
 		 * Then copy the pointers.
 		 */
-		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, new_broot, 1,
+		np = (char *)xfs_bmap_broot_ptr_addr(mp, new_broot, 1,
 						     (int)new_size);
 		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
 	}
@@ -479,7 +479,7 @@ xfs_iroot_realloc(
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
 	if (ifp->if_broot)
-		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 			xfs_inode_fork_size(ip, whichfork));
 	return;
 }
@@ -652,7 +652,7 @@ xfs_iflush_fork(
 		if ((iip->ili_fields & brootflag[whichfork]) &&
 		    (ifp->if_broot_bytes > 0)) {
 			ASSERT(ifp->if_broot != NULL);
-			ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+			ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 			        xfs_inode_fork_size(ip, whichfork));
 			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
 				(xfs_bmdr_block_t *)cp,
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 74f46539179..800a2f9ecb8 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -128,7 +128,7 @@ xfs_calc_inode_res(
 		(4 * sizeof(struct xlog_op_header) +
 		 sizeof(struct xfs_inode_log_format) +
 		 mp->m_sb.sb_inodesize +
-		 2 * XFS_BMBT_BLOCK_LEN(mp));
+		 2 * xfs_bmbt_block_len(mp));
 }
 
 /*
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 7705980621c..a8cbff67ceb 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -285,7 +285,7 @@ xrep_bmap_iroot_size(
 {
 	ASSERT(level > 0);
 
-	return XFS_BMAP_BROOT_SPACE_CALC(cur->bc_mp, nr_this_level);
+	return xfs_bmap_broot_space_calc(cur->bc_mp, nr_this_level);
 }
 
 /* Update the inode counters. */
diff --git a/repair/dinode.c b/repair/dinode.c
index 5a57069c29e..31b3cd74139 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -842,19 +842,19 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 	/*
 	 * use bmdr/dfork_dsize since the root block is in the data fork
 	 */
-	if (XFS_BMDR_SPACE_CALC(numrecs) > XFS_DFORK_SIZE(dip, mp, whichfork)) {
+	if (xfs_bmdr_space_calc(numrecs) > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		do_warn(
-	_("indicated size of %s btree root (%d bytes) greater than space in "
+	_("indicated size of %s btree root (%zu bytes) greater than space in "
 	  "inode %" PRIu64 " %s fork\n"),
-			forkname, XFS_BMDR_SPACE_CALC(numrecs), lino, forkname);
+			forkname, xfs_bmdr_space_calc(numrecs), lino, forkname);
 		return(1);
 	}
 
 	init_bm_cursor(&cursor, level + 1);
 
-	pp = XFS_BMDR_PTR_ADDR(dib, 1,
+	pp = xfs_bmdr_ptr_addr(dib, 1,
 		libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
-	pkey = XFS_BMDR_KEY_ADDR(dib, 1);
+	pkey = xfs_bmdr_key_addr(dib, 1);
 	last_key = NULLFILEOFF;
 
 	for (i = 0; i < numrecs; i++)  {
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 58fc2dac1a8..5caa41beb74 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -328,13 +328,13 @@ pf_scanfunc_bmap(
 		if (numrecs > mp->m_bmap_dmxr[0] || !isadir)
 			return 0;
 		return pf_read_bmbt_reclist(args,
-			XFS_BMBT_REC_ADDR(mp, block, 1), numrecs);
+			xfs_bmbt_rec_addr(mp, block, 1), numrecs);
 	}
 
 	if (numrecs > mp->m_bmap_dmxr[1])
 		return 0;
 
-	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
+	pp = xfs_bmbt_ptr_addr(mp, block, 1, mp->m_bmap_dmxr[1]);
 
 	for (i = 0; i < numrecs; i++) {
 		dbno = get_unaligned_be64(&pp[i]);
@@ -372,11 +372,11 @@ pf_read_btinode(
 	/*
 	 * use bmdr/dfork_dsize since the root block is in the data fork
 	 */
-	if (XFS_BMDR_SPACE_CALC(numrecs) > XFS_DFORK_DSIZE(dino, mp))
+	if (xfs_bmdr_space_calc(numrecs) > XFS_DFORK_DSIZE(dino, mp))
 		return;
 
 	dsize = XFS_DFORK_DSIZE(dino, mp);
-	pp = XFS_BMDR_PTR_ADDR(dib, 1, libxfs_bmdr_maxrecs(dsize, 0));
+	pp = xfs_bmdr_ptr_addr(dib, 1, libxfs_bmdr_maxrecs(dsize, 0));
 
 	for (i = 0; i < numrecs; i++) {
 		dbno = get_unaligned_be64(&pp[i]);
diff --git a/repair/scan.c b/repair/scan.c
index 3857593b165..1cd4d0ad2e1 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -445,7 +445,7 @@ _("inode %" PRIu64 " bad # of bmap records (%" PRIu64 ", min - %u, max - %u)\n")
 					mp->m_bmap_dmxr[0]);
 			return(1);
 		}
-		rp = XFS_BMBT_REC_ADDR(mp, block, 1);
+		rp = xfs_bmbt_rec_addr(mp, block, 1);
 		*nex += numrecs;
 		/*
 		 * XXX - if we were going to fix up the btree record,
@@ -496,8 +496,8 @@ _("inode %" PRIu64 " bad # of bmap records (%" PRIu64 ", min - %u, max - %u)\n")
 			ino, numrecs, mp->m_bmap_dmnr[1], mp->m_bmap_dmxr[1]);
 		return(1);
 	}
-	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
-	pkey = XFS_BMBT_KEY_ADDR(mp, block, 1);
+	pp = xfs_bmbt_ptr_addr(mp, block, 1, mp->m_bmap_dmxr[1]);
+	pkey = xfs_bmbt_key_addr(mp, block, 1);
 
 	last_key = NULLFILEOFF;
 

