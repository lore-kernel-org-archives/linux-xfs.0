Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40488 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751926AbdH2XvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:07 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002cx-RX
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005WA-Q7
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/42] mkfs: factor writing AG headers
Date: Wed, 30 Aug 2017 09:50:27 +1000
Message-Id: <20170829235052.21050-18-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There are some slight changes to the way log alignment is calculated
in the change. Instead of using a flag, it checks the log start
block to see if it's different to the first free block in the log
AG, and if it is different then does the aligned setup. This means
we no longer have to care if the log is aligned or not, the code
will do the right thing in all cases.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 750 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 390 insertions(+), 360 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2438e50d3f33..13af1ef1cd41 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2084,22 +2084,401 @@ prepare_devices(
 
 }
 
+/*
+ * XXX: this code is mostly common with the kernel growfs code.
+ * These initialisations should be pulled into libxfs to keep the
+ * kernel/userspace header initialisation code the same.
+ */
+static void
+initialise_ag_headers(
+	struct mkfs_params	*cfg,
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp,
+	xfs_agnumber_t		agno,
+	int			*worst_freelist)
+{
+	struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
+	struct xfs_agfl		*agfl;
+	struct xfs_agf		*agf;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*buf;
+	struct xfs_btree_block	*block;
+	struct xfs_alloc_rec	*arec;
+	struct xfs_alloc_rec	*nrec;
+	int			bucket;
+	uint64_t		agsize = cfg->agsize;
+	xfs_agblock_t		agblocks;
+	bool			is_log_ag = false;
+	int			c;
+
+	if (cfg->loginternal && agno == cfg->logagno)
+		is_log_ag = true;
+
+	/*
+	 * Superblock.
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+			XFS_FSS_TO_BB(mp, 1));
+	buf->b_ops = &xfs_sb_buf_ops;
+	memset(XFS_BUF_PTR(buf), 0, cfg->sectorsize);
+	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+	/*
+	 * AG header block: freespace
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1));
+	buf->b_ops = &xfs_agf_buf_ops;
+	agf = XFS_BUF_TO_AGF(buf);
+	memset(agf, 0, cfg->sectorsize);
+	if (agno == cfg->agcount - 1)
+		agsize = cfg->dblocks - (xfs_rfsblock_t)(agno * agsize);
+	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
+	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
+	agf->agf_seqno = cpu_to_be32(agno);
+	agf->agf_length = cpu_to_be32(agsize);
+	agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(XFS_BNO_BLOCK(mp));
+	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
+	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
+	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
+	pag->pagf_levels[XFS_BTNUM_BNOi] = 1;
+	pag->pagf_levels[XFS_BTNUM_CNTi] = 1;
+
+	if (xfs_sb_version_hasrmapbt(sbp)) {
+		agf->agf_roots[XFS_BTNUM_RMAPi] = cpu_to_be32(XFS_RMAP_BLOCK(mp));
+		agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
+		agf->agf_rmap_blocks = cpu_to_be32(1);
+	}
+
+	if (xfs_sb_version_hasreflink(sbp)) {
+		agf->agf_refcount_root = cpu_to_be32(libxfs_refc_block(mp));
+		agf->agf_refcount_level = cpu_to_be32(1);
+		agf->agf_refcount_blocks = cpu_to_be32(1);
+	}
+
+	agf->agf_flfirst = 0;
+	agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
+	agf->agf_flcount = 0;
+	agblocks = (xfs_agblock_t)(agsize - libxfs_prealloc_blocks(mp));
+	agf->agf_freeblks = cpu_to_be32(agblocks);
+	agf->agf_longest = cpu_to_be32(agblocks);
+
+	if (xfs_sb_version_hascrc(sbp))
+		platform_uuid_copy(&agf->agf_uuid, &sbp->sb_uuid);
+
+	if (is_log_ag) {
+		be32_add_cpu(&agf->agf_freeblks, -(int64_t)cfg->logblocks);
+		agf->agf_longest = cpu_to_be32(agsize -
+			XFS_FSB_TO_AGBNO(mp, cfg->logstart) - cfg->logblocks);
+	}
+	if (libxfs_alloc_min_freelist(mp, pag) > *worst_freelist)
+		*worst_freelist = libxfs_alloc_min_freelist(mp, pag);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+	/*
+	 * AG freelist header block
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1));
+	buf->b_ops = &xfs_agfl_buf_ops;
+	agfl = XFS_BUF_TO_AGFL(buf);
+	/* setting to 0xff results in initialisation to NULLAGBLOCK */
+	memset(agfl, 0xff, cfg->sectorsize);
+	if (xfs_sb_version_hascrc(sbp)) {
+		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
+		agfl->agfl_seqno = cpu_to_be32(agno);
+		platform_uuid_copy(&agfl->agfl_uuid, &sbp->sb_uuid);
+		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
+			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
+	}
+
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+	/*
+	 * AG header block: inodes
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1));
+	agi = XFS_BUF_TO_AGI(buf);
+	buf->b_ops = &xfs_agi_buf_ops;
+	memset(agi, 0, cfg->sectorsize);
+	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
+	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
+	agi->agi_seqno = cpu_to_be32(agno);
+	agi->agi_length = cpu_to_be32(agsize);
+	agi->agi_count = 0;
+	agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
+	agi->agi_level = cpu_to_be32(1);
+	if (xfs_sb_version_hasfinobt(sbp)) {
+		agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
+		agi->agi_free_level = cpu_to_be32(1);
+	}
+	agi->agi_freecount = 0;
+	agi->agi_newino = cpu_to_be32(NULLAGINO);
+	agi->agi_dirino = cpu_to_be32(NULLAGINO);
+	if (xfs_sb_version_hascrc(sbp))
+		platform_uuid_copy(&agi->agi_uuid, &sbp->sb_uuid);
+	for (c = 0; c < XFS_AGI_UNLINKED_BUCKETS; c++)
+		agi->agi_unlinked[c] = cpu_to_be32(NULLAGINO);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+	/*
+	 * BNO btree root block
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
+			BTOBB(cfg->blocksize));
+	buf->b_ops = &xfs_allocbt_buf_ops;
+	block = XFS_BUF_TO_BLOCK(buf);
+	memset(block, 0, cfg->blocksize);
+	libxfs_btree_init_block(mp, buf, XFS_BTNUM_BNO, 0, 1, agno, 0);
+
+	arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
+	arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
+	if (is_log_ag) {
+		xfs_agblock_t	start = XFS_FSB_TO_AGBNO(mp, cfg->logstart);
+
+		ASSERT(start >= libxfs_prealloc_blocks(mp));
+		if (start != libxfs_prealloc_blocks(mp)) {
+			/*
+			 * Modify first record to pad stripe align of log
+			 */
+			arec->ar_blockcount = cpu_to_be32(start -
+						libxfs_prealloc_blocks(mp));
+			nrec = arec + 1;
+			/*
+			 * Insert second record at start of internal log
+			 * which then gets trimmed.
+			 */
+			nrec->ar_startblock = cpu_to_be32(
+					be32_to_cpu(arec->ar_startblock) +
+					be32_to_cpu(arec->ar_blockcount));
+			arec = nrec;
+			be16_add_cpu(&block->bb_numrecs, 1);
+		}
+		/*
+		 * Change record start to after the internal log
+		 */
+		be32_add_cpu(&arec->ar_startblock, cfg->logblocks);
+	}
+	/*
+	 * Calculate the record block count and check for the case where
+	 * the log might have consumed all available space in the AG. If
+	 * so, reset the record count to 0 to avoid exposure of an invalid
+	 * record start block.
+	 */
+	arec->ar_blockcount = cpu_to_be32(agsize -
+					  be32_to_cpu(arec->ar_startblock));
+	if (!arec->ar_blockcount)
+		block->bb_numrecs = 0;
+
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+	/*
+	 * CNT btree root block
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
+			BTOBB(cfg->blocksize));
+	buf->b_ops = &xfs_allocbt_buf_ops;
+	block = XFS_BUF_TO_BLOCK(buf);
+	memset(block, 0, cfg->blocksize);
+	libxfs_btree_init_block(mp, buf, XFS_BTNUM_CNT, 0, 1, agno, 0);
+
+	arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
+	arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
+	if (is_log_ag) {
+		xfs_agblock_t	start = XFS_FSB_TO_AGBNO(mp, cfg->logstart);
+
+		ASSERT(start >= libxfs_prealloc_blocks(mp));
+		if (start != libxfs_prealloc_blocks(mp)) {
+			arec->ar_blockcount = cpu_to_be32(start -
+					libxfs_prealloc_blocks(mp));
+			nrec = arec + 1;
+			nrec->ar_startblock = cpu_to_be32(
+					be32_to_cpu(arec->ar_startblock) +
+					be32_to_cpu(arec->ar_blockcount));
+			arec = nrec;
+			be16_add_cpu(&block->bb_numrecs, 1);
+		}
+		be32_add_cpu(&arec->ar_startblock, cfg->logblocks);
+	}
+	/*
+	 * Calculate the record block count and check for the case where
+	 * the log might have consumed all available space in the AG. If
+	 * so, reset the record count to 0 to avoid exposure of an invalid
+	 * record start block.
+	 */
+	arec->ar_blockcount = cpu_to_be32(agsize -
+					  be32_to_cpu(arec->ar_startblock));
+	if (!arec->ar_blockcount)
+		block->bb_numrecs = 0;
+
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+	/*
+	 * refcount btree root block
+	 */
+	if (xfs_sb_version_hasreflink(sbp)) {
+		buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AGB_TO_DADDR(mp, agno, libxfs_refc_block(mp)),
+			BTOBB(cfg->blocksize));
+		buf->b_ops = &xfs_refcountbt_buf_ops;
+
+		block = XFS_BUF_TO_BLOCK(buf);
+		memset(block, 0, cfg->blocksize);
+		libxfs_btree_init_block(mp, buf, XFS_BTNUM_REFC, 0, 0, agno, 0);
+		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	}
+
+	/*
+	 * INO btree root block
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
+			BTOBB(cfg->blocksize));
+	buf->b_ops = &xfs_inobt_buf_ops;
+	block = XFS_BUF_TO_BLOCK(buf);
+	memset(block, 0, cfg->blocksize);
+	libxfs_btree_init_block(mp, buf, XFS_BTNUM_INO, 0, 0, agno, 0);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+	/*
+	 * Free INO btree root block
+	 */
+	if (xfs_sb_version_hasfinobt(sbp)) {
+		buf = libxfs_getbuf(mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
+				BTOBB(cfg->blocksize));
+		buf->b_ops = &xfs_inobt_buf_ops;
+		block = XFS_BUF_TO_BLOCK(buf);
+		memset(block, 0, cfg->blocksize);
+		libxfs_btree_init_block(mp, buf, XFS_BTNUM_FINO, 0, 0, agno, 0);
+		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	}
+
+	/* RMAP btree root block */
+	if (xfs_sb_version_hasrmapbt(sbp)) {
+		struct xfs_rmap_rec	*rrec;
+
+		buf = libxfs_getbuf(mp->m_ddev_targp,
+			XFS_AGB_TO_DADDR(mp, agno, XFS_RMAP_BLOCK(mp)),
+			BTOBB(cfg->blocksize));
+		buf->b_ops = &xfs_rmapbt_buf_ops;
+		block = XFS_BUF_TO_BLOCK(buf);
+		memset(block, 0, cfg->blocksize);
+
+		libxfs_btree_init_block(mp, buf, XFS_BTNUM_RMAP, 0, 0, agno, 0);
+
+		/*
+		 * mark the AG header regions as static metadata
+		 * The BNO btree block is the first block after the
+		 * headers, so it's location defines the size of region
+		 * the static metadata consumes.
+		 */
+		rrec = XFS_RMAP_REC_ADDR(block, 1);
+		rrec->rm_startblock = 0;
+		rrec->rm_blockcount = cpu_to_be32(XFS_BNO_BLOCK(mp));
+		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_FS);
+		rrec->rm_offset = 0;
+		be16_add_cpu(&block->bb_numrecs, 1);
+
+		/* account freespace btree root blocks */
+		rrec = XFS_RMAP_REC_ADDR(block, 2);
+		rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
+		rrec->rm_blockcount = cpu_to_be32(2);
+		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+		rrec->rm_offset = 0;
+		be16_add_cpu(&block->bb_numrecs, 1);
+
+		/* account inode btree root blocks */
+		rrec = XFS_RMAP_REC_ADDR(block, 3);
+		rrec->rm_startblock = cpu_to_be32(XFS_IBT_BLOCK(mp));
+		rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
+						XFS_IBT_BLOCK(mp));
+		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
+		rrec->rm_offset = 0;
+		be16_add_cpu(&block->bb_numrecs, 1);
+
+		/* account for rmap btree root */
+		rrec = XFS_RMAP_REC_ADDR(block, 4);
+		rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
+		rrec->rm_blockcount = cpu_to_be32(1);
+		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+		rrec->rm_offset = 0;
+		be16_add_cpu(&block->bb_numrecs, 1);
+
+		/* account for refcount btree root */
+		if (xfs_sb_version_hasreflink(sbp)) {
+			rrec = XFS_RMAP_REC_ADDR(block, 5);
+			rrec->rm_startblock = cpu_to_be32(libxfs_refc_block(mp));
+			rrec->rm_blockcount = cpu_to_be32(1);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_REFC);
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+		}
+
+		/* account for the log space */
+		if (is_log_ag) {
+			rrec = XFS_RMAP_REC_ADDR(block,
+					be16_to_cpu(block->bb_numrecs) + 1);
+			rrec->rm_startblock = cpu_to_be32(
+					XFS_FSB_TO_AGBNO(mp, cfg->logstart));
+			rrec->rm_blockcount = cpu_to_be32(cfg->logblocks);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+		}
+
+		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	}
+
+	libxfs_perag_put(pag);
+}
+
+static void
+initialise_ag_freespace(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			worst_freelist)
+{
+	struct xfs_alloc_arg	args;
+	struct xfs_trans	*tp;
+	struct xfs_trans_res tres = {0};
+	int			c;
+
+	c = libxfs_trans_alloc(mp, &tres, worst_freelist, 0, 0, &tp);
+	if (c)
+		res_failed(c);
+
+	memset(&args, 0, sizeof(args));
+	args.tp = tp;
+	args.mp = mp;
+	args.agno = agno;
+	args.alignment = 1;
+	args.pag = libxfs_perag_get(mp, agno);
+
+	libxfs_alloc_fix_freelist(&args, 0);
+	libxfs_perag_put(args.pag);
+	libxfs_trans_commit(tp);
+}
+
 int
 main(
 	int			argc,
 	char			**argv)
 {
 	uint64_t		agcount;
-	xfs_agf_t		*agf;
-	xfs_agi_t		*agi;
 	xfs_agnumber_t		agno;
 	uint64_t		agsize;
-	xfs_alloc_rec_t		*arec;
-	struct xfs_btree_block	*block;
 	int			blflag;
 	int			blocklog;
 	int			bsflag;
-	int			bsize;
 	xfs_buf_t		*buf;
 	int			c;
 	int			daflag;
@@ -2152,7 +2531,6 @@ main(
 	int			nlflag;
 	int			nodsflag;
 	int			norsflag;
-	xfs_alloc_rec_t		*nrec;
 	int			nsflag;
 	int			nvflag;
 	int			Nflag;
@@ -3153,7 +3531,6 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	validate_log_size(logblocks, blocklog, min_logblocks);
 
 	protostring = setup_proto(protofile);
-	bsize = 1 << (blocklog - BBSHIFT);
 	mp = &mbuf;
 	sbp = &mp->m_sb;
 	memset(mp, 0, sizeof(xfs_mount_t));
@@ -3284,363 +3661,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	}
 
 	/*
-	 * XXX: this code is effectively shared with the kernel growfs code.
-	 * These initialisations should be pulled into libxfs to keep the
-	 * kernel/userspace header initialisation code the same.
+	 * Initialise all the static on disk metadata.
 	 */
-	for (agno = 0; agno < agcount; agno++) {
-		struct xfs_agfl	*agfl;
-		int		bucket;
-		struct xfs_perag *pag = libxfs_perag_get(mp, agno);
-
-		/*
-		 * Superblock.
-		 */
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-				XFS_FSS_TO_BB(mp, 1));
-		buf->b_ops = &xfs_sb_buf_ops;
-		memset(XFS_BUF_PTR(buf), 0, sectorsize);
-		libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-		/*
-		 * AG header block: freespace
-		 */
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-				XFS_FSS_TO_BB(mp, 1));
-		buf->b_ops = &xfs_agf_buf_ops;
-		agf = XFS_BUF_TO_AGF(buf);
-		memset(agf, 0, sectorsize);
-		if (agno == agcount - 1)
-			agsize = dblocks - (xfs_rfsblock_t)(agno * agsize);
-		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
-		agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
-		agf->agf_seqno = cpu_to_be32(agno);
-		agf->agf_length = cpu_to_be32(agsize);
-		agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(XFS_BNO_BLOCK(mp));
-		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
-		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
-		agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
-		pag->pagf_levels[XFS_BTNUM_BNOi] = 1;
-		pag->pagf_levels[XFS_BTNUM_CNTi] = 1;
-		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-			agf->agf_roots[XFS_BTNUM_RMAPi] =
-						cpu_to_be32(XFS_RMAP_BLOCK(mp));
-			agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
-			agf->agf_rmap_blocks = cpu_to_be32(1);
-		}
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-			agf->agf_refcount_root = cpu_to_be32(
-					libxfs_refc_block(mp));
-			agf->agf_refcount_level = cpu_to_be32(1);
-			agf->agf_refcount_blocks = cpu_to_be32(1);
-		}
-		agf->agf_flfirst = 0;
-		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
-		agf->agf_flcount = 0;
-		nbmblocks = (xfs_extlen_t)(agsize - libxfs_prealloc_blocks(mp));
-		agf->agf_freeblks = cpu_to_be32(nbmblocks);
-		agf->agf_longest = cpu_to_be32(nbmblocks);
-		if (xfs_sb_version_hascrc(&mp->m_sb))
-			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
-
-		if (loginternal && agno == logagno) {
-			be32_add_cpu(&agf->agf_freeblks, -logblocks);
-			agf->agf_longest = cpu_to_be32(agsize -
-				XFS_FSB_TO_AGBNO(mp, logstart) - logblocks);
-		}
-		if (libxfs_alloc_min_freelist(mp, pag) > worst_freelist)
-			worst_freelist = libxfs_alloc_min_freelist(mp, pag);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-		/*
-		 * AG freelist header block
-		 */
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-				XFS_FSS_TO_BB(mp, 1));
-		buf->b_ops = &xfs_agfl_buf_ops;
-		agfl = XFS_BUF_TO_AGFL(buf);
-		/* setting to 0xff results in initialisation to NULLAGBLOCK */
-		memset(agfl, 0xff, sectorsize);
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
-			agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
-			agfl->agfl_seqno = cpu_to_be32(agno);
-			platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
-			for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
-				agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
-		}
-
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-		/*
-		 * AG header block: inodes
-		 */
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				XFS_FSS_TO_BB(mp, 1));
-		agi = XFS_BUF_TO_AGI(buf);
-		buf->b_ops = &xfs_agi_buf_ops;
-		memset(agi, 0, sectorsize);
-		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
-		agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
-		agi->agi_seqno = cpu_to_be32(agno);
-		agi->agi_length = cpu_to_be32((xfs_agblock_t)agsize);
-		agi->agi_count = 0;
-		agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
-		agi->agi_level = cpu_to_be32(1);
-		if (sb_feat.finobt) {
-			agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
-			agi->agi_free_level = cpu_to_be32(1);
-		}
-		agi->agi_freecount = 0;
-		agi->agi_newino = cpu_to_be32(NULLAGINO);
-		agi->agi_dirino = cpu_to_be32(NULLAGINO);
-		if (xfs_sb_version_hascrc(&mp->m_sb))
-			platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
-		for (c = 0; c < XFS_AGI_UNLINKED_BUCKETS; c++)
-			agi->agi_unlinked[c] = cpu_to_be32(NULLAGINO);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-		/*
-		 * BNO btree root block
-		 */
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
-				bsize);
-		buf->b_ops = &xfs_allocbt_buf_ops;
-		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, blocksize);
-		libxfs_btree_init_block(mp, buf, XFS_BTNUM_BNO, 0, 1, agno, 0);
-
-		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-		if (loginternal && agno == logagno) {
-			if (lalign) {
-				/*
-				 * Have to insert two records
-				 * Insert pad record for stripe align of log
-				 */
-				arec->ar_blockcount = cpu_to_be32(
-					XFS_FSB_TO_AGBNO(mp, logstart) -
-					be32_to_cpu(arec->ar_startblock));
-				nrec = arec + 1;
-				/*
-				 * Insert record at start of internal log
-				 */
-				nrec->ar_startblock = cpu_to_be32(
-					be32_to_cpu(arec->ar_startblock) +
-					be32_to_cpu(arec->ar_blockcount));
-				arec = nrec;
-				be16_add_cpu(&block->bb_numrecs, 1);
-			}
-			/*
-			 * Change record start to after the internal log
-			 */
-			be32_add_cpu(&arec->ar_startblock, logblocks);
-		}
-		/*
-		 * Calculate the record block count and check for the case where
-		 * the log might have consumed all available space in the AG. If
-		 * so, reset the record count to 0 to avoid exposure of an invalid
-		 * record start block.
-		 */
-		arec->ar_blockcount = cpu_to_be32(agsize -
-					be32_to_cpu(arec->ar_startblock));
-		if (!arec->ar_blockcount)
-			block->bb_numrecs = 0;
-
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-		/*
-		 * CNT btree root block
-		 */
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
-				bsize);
-		buf->b_ops = &xfs_allocbt_buf_ops;
-		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, blocksize);
-		libxfs_btree_init_block(mp, buf, XFS_BTNUM_CNT, 0, 1, agno, 0);
-
-		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-		if (loginternal && agno == logagno) {
-			if (lalign) {
-				arec->ar_blockcount = cpu_to_be32(
-					XFS_FSB_TO_AGBNO(mp, logstart) -
-					be32_to_cpu(arec->ar_startblock));
-				nrec = arec + 1;
-				nrec->ar_startblock = cpu_to_be32(
-					be32_to_cpu(arec->ar_startblock) +
-					be32_to_cpu(arec->ar_blockcount));
-				arec = nrec;
-				be16_add_cpu(&block->bb_numrecs, 1);
-			}
-			be32_add_cpu(&arec->ar_startblock, logblocks);
-		}
-		/*
-		 * Calculate the record block count and check for the case where
-		 * the log might have consumed all available space in the AG. If
-		 * so, reset the record count to 0 to avoid exposure of an invalid
-		 * record start block.
-		 */
-		arec->ar_blockcount = cpu_to_be32(agsize -
-					be32_to_cpu(arec->ar_startblock));
-		if (!arec->ar_blockcount)
-			block->bb_numrecs = 0;
-
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-		/*
-		 * refcount btree root block
-		 */
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-			buf = libxfs_getbuf(mp->m_ddev_targp,
-					XFS_AGB_TO_DADDR(mp, agno,
-						libxfs_refc_block(mp)),
-					bsize);
-			buf->b_ops = &xfs_refcountbt_buf_ops;
-
-			block = XFS_BUF_TO_BLOCK(buf);
-			memset(block, 0, blocksize);
-			libxfs_btree_init_block(mp, buf, XFS_BTNUM_REFC, 0,
-						0, agno, 0);
-
-			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-		}
-
-		/*
-		 * INO btree root block
-		 */
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
-				bsize);
-		buf->b_ops = &xfs_inobt_buf_ops;
-		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, blocksize);
-		libxfs_btree_init_block(mp, buf, XFS_BTNUM_INO, 0, 0, agno, 0);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-		/*
-		 * Free INO btree root block
-		 */
-		if (sb_feat.finobt) {
-			buf = libxfs_getbuf(mp->m_ddev_targp,
-					XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
-					bsize);
-			buf->b_ops = &xfs_inobt_buf_ops;
-			block = XFS_BUF_TO_BLOCK(buf);
-			memset(block, 0, blocksize);
-			libxfs_btree_init_block(mp, buf, XFS_BTNUM_FINO, 0, 0, agno, 0);
-			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-		}
-
-		/* RMAP btree root block */
-		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-			struct xfs_rmap_rec	*rrec;
-
-			buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, XFS_RMAP_BLOCK(mp)),
-				bsize);
-			buf->b_ops = &xfs_rmapbt_buf_ops;
-			block = XFS_BUF_TO_BLOCK(buf);
-			memset(block, 0, blocksize);
-
-			libxfs_btree_init_block(mp, buf, XFS_BTNUM_RMAP, 0, 0, agno, 0);
-
-			/*
-			 * mark the AG header regions as static metadata
-			 * The BNO btree block is the first block after the
-			 * headers, so it's location defines the size of region
-			 * the static metadata consumes.
-			 */
-			rrec = XFS_RMAP_REC_ADDR(block, 1);
-			rrec->rm_startblock = 0;
-			rrec->rm_blockcount = cpu_to_be32(XFS_BNO_BLOCK(mp));
-			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_FS);
-			rrec->rm_offset = 0;
-			be16_add_cpu(&block->bb_numrecs, 1);
-
-			/* account freespace btree root blocks */
-			rrec = XFS_RMAP_REC_ADDR(block, 2);
-			rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
-			rrec->rm_blockcount = cpu_to_be32(2);
-			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
-			rrec->rm_offset = 0;
-			be16_add_cpu(&block->bb_numrecs, 1);
-
-			/* account inode btree root blocks */
-			rrec = XFS_RMAP_REC_ADDR(block, 3);
-			rrec->rm_startblock = cpu_to_be32(XFS_IBT_BLOCK(mp));
-			rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
-							XFS_IBT_BLOCK(mp));
-			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
-			rrec->rm_offset = 0;
-			be16_add_cpu(&block->bb_numrecs, 1);
-
-			/* account for rmap btree root */
-			rrec = XFS_RMAP_REC_ADDR(block, 4);
-			rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
-			rrec->rm_blockcount = cpu_to_be32(1);
-			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
-			rrec->rm_offset = 0;
-			be16_add_cpu(&block->bb_numrecs, 1);
-
-			/* account for refcount btree root */
-			if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-				rrec = XFS_RMAP_REC_ADDR(block, 5);
-				rrec->rm_startblock = cpu_to_be32(
-							libxfs_refc_block(mp));
-				rrec->rm_blockcount = cpu_to_be32(1);
-				rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_REFC);
-				rrec->rm_offset = 0;
-				be16_add_cpu(&block->bb_numrecs, 1);
-			}
-
-			/* account for the log space */
-			if (loginternal && agno == logagno) {
-				rrec = XFS_RMAP_REC_ADDR(block,
-					be16_to_cpu(block->bb_numrecs) + 1);
-				rrec->rm_startblock = cpu_to_be32(
-						XFS_FSB_TO_AGBNO(mp, logstart));
-				rrec->rm_blockcount = cpu_to_be32(logblocks);
-				rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
-				rrec->rm_offset = 0;
-				be16_add_cpu(&block->bb_numrecs, 1);
-			}
-
-			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-		}
-
-		libxfs_perag_put(pag);
-	}
+	for (agno = 0; agno < cfg.agcount; agno++)
+		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist);
 
 	/*
-	 * BNO, CNT free block list
+	 * Initialise the freespace freelists (i.e. AGFLs) in each AG.
 	 */
-	for (agno = 0; agno < agcount; agno++) {
-		xfs_alloc_arg_t	args;
-		xfs_trans_t	*tp;
-		struct xfs_trans_res tres = {0};
-
-		c = libxfs_trans_alloc(mp, &tres, worst_freelist, 0, 0, &tp);
-		if (c)
-			res_failed(c);
-
-		memset(&args, 0, sizeof(args));
-		args.tp = tp;
-		args.mp = mp;
-		args.agno = agno;
-		args.alignment = 1;
-		args.pag = libxfs_perag_get(mp,agno);
-
-		libxfs_alloc_fix_freelist(&args, 0);
-		libxfs_perag_put(args.pag);
-		libxfs_trans_commit(tp);
-	}
+	for (agno = 0; agno < cfg.agcount; agno++)
+		initialise_ag_freespace(mp, agno, worst_freelist);
 
 	/*
 	 * Allocate the root inode and anything else in the proto file.
-- 
2.13.3

