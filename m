Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0C7BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fztm8ASs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3992DC433C7;
	Sun, 31 Dec 2023 21:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057744;
	bh=sAU56PLEwzmxqxb/+0DSb8bQRj4qtxqkhfn2gKakUpM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fztm8ASsG1lmnF3Uz3ooNtQVgbcctkPMGw+jS4vOpxNQ2q2wOEmIJYmhdzaHtNT/i
	 2sNZWnSE5dmHfMDKIkk1uuivd/CBE9fZk7bZPAvbhh1ZLSal8ijoOt5GPedU/Ka1Td
	 Sc9qXi/dBm51YAwRk5zjwm3w+z3pMt3E2NBaw/2wrtLqvjeukN9KqBukV/AJdrrmTK
	 20zsditF+UTLEUGVRnKEkGdgNCYncB2LT64M9xrpnjbkeGUn0bfi22t8wNXweZhWxK
	 kJ+2+NMERI16i3ustoUcm7iE9KsbX/1jiLnxXCI889TxK2iW6Nld/D309sLAASA0G1
	 xyf4gO4BHbLTg==
Date: Sun, 31 Dec 2023 13:22:23 -0800
Subject: [PATCH 01/14] xfs: replace shouty XFS_BM{BT,DR} macros
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847383.1763835.8300895490518509530.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr_leaf.c  |    8 +-
 fs/xfs/libxfs/xfs_bmap.c       |   40 ++++----
 fs/xfs/libxfs/xfs_bmap_btree.c |   18 ++--
 fs/xfs/libxfs/xfs_bmap_btree.h |  204 +++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.c |   30 +++---
 fs/xfs/libxfs/xfs_trans_resv.c |    2 
 fs/xfs/scrub/bmap_repair.c     |    2 
 fs/xfs/scrub/inode_repair.c    |   12 +-
 fs/xfs/xfs_xchgrange.c         |    4 -
 9 files changed, 198 insertions(+), 122 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2168747aaa2dc..fee156d72fbac 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -672,7 +672,7 @@ xfs_attr_shortform_bytesfit(
 		 */
 		if (!dp->i_forkoff && dp->i_df.if_bytes >
 		    xfs_default_attroffset(dp))
-			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
+			dsize = xfs_bmdr_space_calc(MINDBTPTRS);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		/*
@@ -686,7 +686,7 @@ xfs_attr_shortform_bytesfit(
 				return 0;
 			return dp->i_forkoff;
 		}
-		dsize = XFS_BMAP_BROOT_SPACE(mp, dp->i_df.if_broot);
+		dsize = xfs_bmap_bmdr_space(dp->i_df.if_broot);
 		break;
 	}
 
@@ -694,11 +694,11 @@ xfs_attr_shortform_bytesfit(
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
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c10ed52433979..da89a76512776 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -79,9 +79,9 @@ xfs_bmap_compute_maxlevels(
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
@@ -102,8 +102,8 @@ xfs_bmap_compute_attr_offset(
 	struct xfs_mount	*mp)
 {
 	if (mp->m_sb.sb_inodesize == 256)
-		return XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	return XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
+		return XFS_LITINO(mp) - xfs_bmdr_space_calc(MINABTPTRS);
+	return xfs_bmdr_space_calc(6 * MINABTPTRS);
 }
 
 STATIC int				/* error */
@@ -276,7 +276,7 @@ xfs_check_block(
 	prevp = NULL;
 	for( i = 1; i <= xfs_btree_get_numrecs(block); i++) {
 		dmxr = mp->m_bmap_dmxr[0];
-		keyp = XFS_BMBT_KEY_ADDR(mp, block, i);
+		keyp = xfs_bmbt_key_addr(mp, block, i);
 
 		if (prevp) {
 			ASSERT(be64_to_cpu(prevp->br_startoff) <
@@ -288,15 +288,15 @@ xfs_check_block(
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
@@ -351,7 +351,7 @@ xfs_bmap_check_leaf_extents(
 	level = be16_to_cpu(block->bb_level);
 	ASSERT(level > 0);
 	xfs_check_block(block, mp, 1, ifp->if_broot_bytes);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
+	pp = xfs_bmap_broot_ptr_addr(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 
 	ASSERT(bno != NULLFSBLOCK);
@@ -386,7 +386,7 @@ xfs_bmap_check_leaf_extents(
 		 */
 
 		xfs_check_block(block, mp, 0, 0);
-		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
+		pp = xfs_bmbt_ptr_addr(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, bno))) {
 			xfs_btree_mark_sick(cur);
@@ -426,14 +426,14 @@ xfs_bmap_check_leaf_extents(
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
@@ -568,7 +568,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
 	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
 
-	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
+	pp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
 	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
@@ -696,7 +696,7 @@ xfs_bmap_extents_to_btree(
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
 			continue;
-		arp = XFS_BMBT_REC_ADDR(mp, ablock, 1 + cnt);
+		arp = xfs_bmbt_rec_addr(mp, ablock, 1 + cnt);
 		xfs_bmbt_disk_set_all(arp, &rec);
 		cnt++;
 	}
@@ -706,10 +706,10 @@ xfs_bmap_extents_to_btree(
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
 
@@ -878,7 +878,7 @@ xfs_bmap_add_attrfork_btree(
 
 	mp = ip->i_mount;
 
-	if (XFS_BMAP_BMDR_SPACE(block) <= xfs_inode_data_fork_size(ip))
+	if (xfs_bmap_bmdr_space(block) <= xfs_inode_data_fork_size(ip))
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
@@ -1145,7 +1145,7 @@ xfs_iread_bmbt_block(
 	}
 
 	/* Copy records into the incore cache. */
-	frp = XFS_BMBT_REC_ADDR(mp, block, 1);
+	frp = xfs_bmbt_rec_addr(mp, block, 1);
 	for (j = 0; j < num_recs; j++, frp++, ir->loaded++) {
 		struct xfs_bmbt_irec	new;
 		xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index fd5fb8abf4448..da63d64f185c8 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -49,10 +49,10 @@ xfs_bmdr_to_bmbt(
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
@@ -152,10 +152,10 @@ xfs_bmbt_to_bmdr(
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
@@ -672,7 +672,7 @@ xfs_bmbt_maxrecs(
 	int			blocklen,
 	int			leaf)
 {
-	blocklen -= XFS_BMBT_BLOCK_LEN(mp);
+	blocklen -= xfs_bmbt_block_len(mp);
 	return xfs_bmbt_block_maxrecs(blocklen, leaf);
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 151b8491f60ee..62fbc4f7c2c40 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7e571fcfe9d1a..62cd25ed4c59d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -181,7 +181,7 @@ xfs_iformat_btree(
 
 	ifp = xfs_ifork_ptr(ip, whichfork);
 	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
-	size = XFS_BMAP_BROOT_SPACE(mp, dfp);
+	size = xfs_bmap_broot_space(mp, dfp);
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
@@ -194,7 +194,7 @@ xfs_iformat_btree(
 	 */
 	if (unlikely(ifp->if_nextents <= XFS_IFORK_MAXEXT(ip, whichfork) ||
 		     nrecs == 0 ||
-		     XFS_BMDR_SPACE_CALC(nrecs) >
+		     xfs_bmdr_space_calc(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
 		     ifp->if_nextents > ip->i_nblocks) ||
 		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork)) {
@@ -405,7 +405,7 @@ xfs_iroot_realloc(
 		 * allocate it now and get out.
 		 */
 		if (ifp->if_broot_bytes == 0) {
-			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
+			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
 			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
@@ -419,15 +419,15 @@ xfs_iroot_realloc(
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
@@ -443,7 +443,7 @@ xfs_iroot_realloc(
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
-		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
+		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	else
 		new_size = 0;
 	if (new_size > 0) {
@@ -452,7 +452,7 @@ xfs_iroot_realloc(
 		 * First copy over the btree block header.
 		 */
 		memcpy(new_broot, ifp->if_broot,
-			XFS_BMBT_BLOCK_LEN(ip->i_mount));
+			xfs_bmbt_block_len(ip->i_mount));
 	} else {
 		new_broot = NULL;
 	}
@@ -464,16 +464,16 @@ xfs_iroot_realloc(
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
@@ -481,7 +481,7 @@ xfs_iroot_realloc(
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
 	if (ifp->if_broot)
-		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 			xfs_inode_fork_size(ip, whichfork));
 	return;
 }
@@ -654,7 +654,7 @@ xfs_iflush_fork(
 		if ((iip->ili_fields & brootflag[whichfork]) &&
 		    (ifp->if_broot_bytes > 0)) {
 			ASSERT(ifp->if_broot != NULL);
-			ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+			ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 			        xfs_inode_fork_size(ip, whichfork));
 			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
 				(xfs_bmdr_block_t *)cp,
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 0840d5000bf97..83922f5e54aed 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -131,7 +131,7 @@ xfs_calc_inode_res(
 		(4 * sizeof(struct xlog_op_header) +
 		 sizeof(struct xfs_inode_log_format) +
 		 mp->m_sb.sb_inodesize +
-		 2 * XFS_BMBT_BLOCK_LEN(mp));
+		 2 * xfs_bmbt_block_len(mp));
 }
 
 /*
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index a4bb89fdd5106..f005c21770204 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -480,7 +480,7 @@ xrep_bmap_iroot_size(
 {
 	ASSERT(level > 0);
 
-	return XFS_BMAP_BROOT_SPACE_CALC(cur->bc_mp, nr_this_level);
+	return xfs_bmap_broot_space_calc(cur->bc_mp, nr_this_level);
 }
 
 /* Update the inode counters. */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 2c4209054f41b..30be423b3716e 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -808,7 +808,7 @@ xrep_dinode_bad_bmbt_fork(
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
-	if (nrecs == 0 || XFS_BMDR_SPACE_CALC(nrecs) > dfork_size)
+	if (nrecs == 0 || xfs_bmdr_space_calc(nrecs) > dfork_size)
 		return true;
 	if (level == 0 || level >= XFS_BM_MAXLEVELS(sc->mp, whichfork))
 		return true;
@@ -820,12 +820,12 @@ xrep_dinode_bad_bmbt_fork(
 		xfs_fileoff_t		fileoff;
 		xfs_fsblock_t		fsbno;
 
-		fkp = XFS_BMDR_KEY_ADDR(dfp, i);
+		fkp = xfs_bmdr_key_addr(dfp, i);
 		fileoff = be64_to_cpu(fkp->br_startoff);
 		if (!xfs_verify_fileoff(sc->mp, fileoff))
 			return true;
 
-		fpp = XFS_BMDR_PTR_ADDR(dfp, i, dmxr);
+		fpp = xfs_bmdr_ptr_addr(dfp, i, dmxr);
 		fsbno = be64_to_cpu(*fpp);
 		if (!xfs_verify_fsbno(sc->mp, fsbno))
 			return true;
@@ -1083,7 +1083,7 @@ xrep_dinode_ensure_forkoff(
 	struct xfs_bmdr_block	*bmdr;
 	struct xfs_scrub	*sc = ri->sc;
 	xfs_extnum_t		attr_extents, data_extents;
-	size_t			bmdr_minsz = XFS_BMDR_SPACE_CALC(1);
+	size_t			bmdr_minsz = xfs_bmdr_space_calc(1);
 	unsigned int		lit_sz = XFS_LITINO(sc->mp);
 	unsigned int		afork_min, dfork_min;
 
@@ -1135,7 +1135,7 @@ xrep_dinode_ensure_forkoff(
 	case XFS_DINODE_FMT_BTREE:
 		/* Must have space for btree header and key/pointers. */
 		bmdr = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);
-		afork_min = XFS_BMAP_BROOT_SPACE(sc->mp, bmdr);
+		afork_min = xfs_bmap_broot_space(sc->mp, bmdr);
 		break;
 	default:
 		/* We should never see any other formats. */
@@ -1185,7 +1185,7 @@ xrep_dinode_ensure_forkoff(
 	case XFS_DINODE_FMT_BTREE:
 		/* Must have space for btree header and key/pointers. */
 		bmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
-		dfork_min = XFS_BMAP_BROOT_SPACE(sc->mp, bmdr);
+		dfork_min = xfs_bmap_broot_space(sc->mp, bmdr);
 		break;
 	default:
 		dfork_min = 0;
diff --git a/fs/xfs/xfs_xchgrange.c b/fs/xfs/xfs_xchgrange.c
index d805678e946c1..e8d44e4de5a81 100644
--- a/fs/xfs/xfs_xchgrange.c
+++ b/fs/xfs/xfs_xchgrange.c
@@ -566,7 +566,7 @@ xfs_swap_extents_check_format(
 	 */
 	if (tifp->if_format == XFS_DINODE_FMT_BTREE) {
 		if (xfs_inode_has_attr_fork(ip) &&
-		    XFS_BMAP_BMDR_SPACE(tifp->if_broot) > xfs_inode_fork_boff(ip))
+		    xfs_bmap_bmdr_space(tifp->if_broot) > xfs_inode_fork_boff(ip))
 			return -EINVAL;
 		if (tifp->if_nextents <= XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
 			return -EINVAL;
@@ -575,7 +575,7 @@ xfs_swap_extents_check_format(
 	/* Reciprocal target->temp btree format checks */
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		if (xfs_inode_has_attr_fork(tip) &&
-		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > xfs_inode_fork_boff(tip))
+		    xfs_bmap_bmdr_space(ip->i_df.if_broot) > xfs_inode_fork_boff(tip))
 			return -EINVAL;
 		if (ifp->if_nextents <= XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
 			return -EINVAL;

