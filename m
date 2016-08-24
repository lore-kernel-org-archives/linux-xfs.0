Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84ABD7CB1
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:25:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 472058F8033
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:25:10 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7bbnz9LlSKjpydLv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:25:05 -0700 (PDT)
Subject: [PATCH 6/7] misc: fix libxfs api violations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:25:02 -0700
Message-ID: <147200550258.15538.5184942465515335880.stgit@birch.djwong.org>
In-Reply-To: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
References: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Fix all the client programs to use 'libxfs_' prefixes for non-inline
function calls and to negate integer return codes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/bmap.c                    |    4 ++-
 db/bmroot.c                  |    4 ++-
 db/check.c                   |    6 +++--
 db/frag.c                    |    2 +-
 db/fsmap.c                   |    8 +++----
 db/init.c                    |    2 +-
 db/logformat.c               |    2 +-
 db/metadump.c                |    4 ++-
 io/open.c                    |    2 +-
 libxfs/libxfs_api_defs.h     |   15 +++++++++++++
 mkfs/maxtrres.c              |    2 +-
 mkfs/xfs_mkfs.c              |   46 +++++++++++++++++++--------------------
 repair/dinode.c              |    8 +++----
 repair/phase5.c              |   50 +++++++++++++++++++++---------------------
 repair/phase6.c              |    6 +++--
 repair/prefetch.c            |    4 ++-
 repair/rmap.c                |   24 ++++++++++----------
 repair/sb.c                  |    2 +-
 tools/find-api-violations.sh |   38 ++++++++++++++++++++++++++++++++
 19 files changed, 141 insertions(+), 88 deletions(-)
 create mode 100755 tools/find-api-violations.sh


diff --git a/db/bmap.c b/db/bmap.c
index c71b6b4..58833f7 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -90,7 +90,7 @@ bmap(
 		push_cur();
 		rblock = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 		fsize = XFS_DFORK_SIZE(dip, mp, whichfork);
-		pp = XFS_BMDR_PTR_ADDR(rblock, 1, xfs_bmdr_maxrecs(fsize, 0));
+		pp = XFS_BMDR_PTR_ADDR(rblock, 1, libxfs_bmdr_maxrecs(fsize, 0));
 		kp = XFS_BMDR_KEY_ADDR(rblock, 1);
 		bno = select_child(curoffset, kp, pp,
 					be16_to_cpu(rblock->bb_numrecs));
@@ -101,7 +101,7 @@ bmap(
 			if (be16_to_cpu(block->bb_level) == 0)
 				break;
 			pp = XFS_BMBT_PTR_ADDR(mp, block, 1,
-				xfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
+				libxfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
 			kp = XFS_BMBT_KEY_ADDR(mp, block, 1);
 			bno = select_child(curoffset, kp, pp,
 					be16_to_cpu(block->bb_numrecs));
diff --git a/db/bmroot.c b/db/bmroot.c
index 0950e19..7697e61 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -140,7 +140,7 @@ bmroota_ptr_offset(
 	ASSERT(XFS_DFORK_Q(dip) && (char *)block == XFS_DFORK_APTR(dip));
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
 	pp = XFS_BMDR_PTR_ADDR(block, idx,
-		xfs_bmdr_maxrecs(XFS_DFORK_ASIZE(dip, mp), 0));
+		libxfs_bmdr_maxrecs(XFS_DFORK_ASIZE(dip, mp), 0));
 	return bitize((int)((char *)pp - (char *)block));
 }
 
@@ -235,7 +235,7 @@ bmrootd_ptr_offset(
 	block = (xfs_bmdr_block_t *)((char *)obj + byteize(startoff));
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
 	pp = XFS_BMDR_PTR_ADDR(block, idx,
-		xfs_bmdr_maxrecs(XFS_DFORK_DSIZE(dip, mp), 0));
+		libxfs_bmdr_maxrecs(XFS_DFORK_DSIZE(dip, mp), 0));
 	return bitize((int)((char *)pp - (char *)block));
 }
 
diff --git a/db/check.c b/db/check.c
index 11c6b56..a6a8372 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2186,7 +2186,7 @@ process_btinode(
 		return;
 	}
 	if (be16_to_cpu(dib->bb_numrecs) >
-			xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork),
+			libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork),
 			be16_to_cpu(dib->bb_level) == 0)) {
 		if (!sflag || id->ilist)
 			dbprintf(_("numrecs for ino %lld %s fork bmap root too "
@@ -2204,7 +2204,7 @@ process_btinode(
 		*nex += be16_to_cpu(dib->bb_numrecs);
 		return;
 	} else {
-		pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(
+		pp = XFS_BMDR_PTR_ADDR(dib, 1, libxfs_bmdr_maxrecs(
 				XFS_DFORK_SIZE(dip, mp, whichfork), 0));
 		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
 			scan_lbtree(get_unaligned_be64(&pp[i]),
@@ -2684,7 +2684,7 @@ process_inode(
 		error++;
 		return;
 	}
-	if (!xfs_dinode_good_version(mp, xino.i_d.di_version)) {
+	if (!libxfs_dinode_good_version(mp, xino.i_d.di_version)) {
 		if (isfree || v)
 			dbprintf(_("bad version number %#x for inode %lld\n"),
 				xino.i_d.di_version, ino);
diff --git a/db/frag.c b/db/frag.c
index e11b140..8005e45 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -260,7 +260,7 @@ process_btinode(
 		return;
 	}
 	pp = XFS_BMDR_PTR_ADDR(dib, 1,
-		xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
+		libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
 	for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
 		scan_lbtree(get_unaligned_be64(&pp[i]),
 			 be16_to_cpu(dib->bb_level), scanfunc_bmap, extmapp,
diff --git a/db/fsmap.c b/db/fsmap.c
index 4b245b9..67fed20 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -85,13 +85,13 @@ fsmap(
 		if (agno == end_ag)
 			high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsb);
 
-		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+		error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
 		if (error) {
 			dbprintf(_("Error %d while reading AGF.\n"), error);
 			return;
 		}
 
-		bt_cur = xfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+		bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
 		if (!bt_cur) {
 			libxfs_putbuf(agbp);
 			dbprintf(_("Not enough memory.\n"));
@@ -102,14 +102,14 @@ fsmap(
 		error = -libxfs_rmap_query_range(bt_cur, &low, &high,
 				fsmap_fn, &info);
 		if (error) {
-			xfs_btree_del_cursor(bt_cur, XFS_BTREE_ERROR);
+			libxfs_btree_del_cursor(bt_cur, XFS_BTREE_ERROR);
 			libxfs_putbuf(agbp);
 			dbprintf(_("Error %d while querying fsmap btree.\n"),
 				error);
 			return;
 		}
 
-		xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 		libxfs_putbuf(agbp);
 
 		if (agno == start_ag)
diff --git a/db/init.c b/db/init.c
index c0472c8..ec1e274 100644
--- a/db/init.c
+++ b/db/init.c
@@ -164,7 +164,7 @@ init(
 	 */
 	if (sbp->sb_rootino != NULLFSINO &&
 	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
-		int error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
+		int error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);
 		if (error) {
 			fprintf(stderr,
 	_("%s: cannot init perag data (%d). Continuing anyway.\n"),
diff --git a/db/logformat.c b/db/logformat.c
index 254f33d..70097bc 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -101,7 +101,7 @@ logformat_f(int argc, char **argv)
 
 	dbprintf("Formatting the log to cycle %d, stripe unit %d bytes.\n",
 		 cycle, lsunit);
-	error = libxfs_log_clear(mp->m_logdev_targp, NULL,
+	error = -libxfs_log_clear(mp->m_logdev_targp, NULL,
 				 mp->m_log->l_logBBstart,
 				 mp->m_log->l_logBBsize,
 				 &mp->m_sb.sb_uuid, logversion, lsunit,
diff --git a/db/metadump.c b/db/metadump.c
index 609a5d7..44359e1 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2016,7 +2016,7 @@ process_btinode(
 					    nrecs, itype);
 	}
 
-	maxrecs = xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
+	maxrecs = libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
 	if (nrecs > maxrecs) {
 		if (show_warnings)
 			print_warning("invalid numrecs (%u) in inode %lld %s "
@@ -2132,7 +2132,7 @@ process_inode(
 
 	/* we only care about crc recalculation if we will modify the inode. */
 	if (obfuscate || zero_stale_data) {
-		crc_was_ok = xfs_verify_cksum((char *)dip,
+		crc_was_ok = libxfs_verify_cksum((char *)dip,
 					mp->m_sb.sb_inodesize,
 					offsetof(struct xfs_dinode, di_crc));
 	}
diff --git a/io/open.c b/io/open.c
index 2303527..a5d465a 100644
--- a/io/open.c
+++ b/io/open.c
@@ -878,7 +878,7 @@ inode_f(
 
 	lastgrp--;
 	lastino = igroup[lastgrp].xi_startino +
-		  xfs_highbit64(igroup[lastgrp].xi_allocmask);
+		  libxfs_highbit64(igroup[lastgrp].xi_allocmask);
 
 	if (verbose)
 		printf("%llu:%d\n", lastino,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 993ca9f..626c79f 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -122,4 +122,19 @@
 
 #define xfs_verify_cksum		libxfs_verify_cksum
 
+#define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
+#define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
+#define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
+#define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
+#define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_dir_ino_validate		libxfs_dir_ino_validate
+#define xfs_initialize_perag_data	libxfs_initialize_perag_data
+#define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
+#define xfs_iread_extents		libxfs_iread_extents
+#define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
+#define xfs_perag_get			libxfs_perag_get
+#define xfs_perag_put			libxfs_perag_put
+#define xfs_prealloc_blocks		libxfs_prealloc_blocks
+#define xfs_dinode_good_version		libxfs_dinode_good_version
+
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index fc24eac..d7978b6 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -77,7 +77,7 @@ max_trans_res(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 
 	libxfs_mount(&mount, sbp, 0,0,0,0);
-	maxfsb = xfs_log_calc_minimum_size(&mount);
+	maxfsb = libxfs_log_calc_minimum_size(&mount);
 	libxfs_umount(&mount);
 
 #if 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8c69f69..580119e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2675,7 +2675,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	/*
 	 * sb_versionnum, finobt and rmapbt flags must be set before we use
-	 * xfs_prealloc_blocks().
+	 * libxfs_prealloc_blocks().
 	 */
 	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
 
@@ -2687,12 +2687,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 */
 		if (!logsize) {
 			logblocks = MIN(logblocks,
-					xfs_alloc_ag_max_usable(mp));
+					libxfs_alloc_ag_max_usable(mp));
 
 			/* revalidate the log size is valid if we changed it */
 			validate_log_size(logblocks, blocklog, min_logblocks);
 		}
-		if (logblocks > agsize - xfs_prealloc_blocks(mp)) {
+		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
 			fprintf(stderr,
 	_("internal log size %lld too large, must fit in allocation group\n"),
 				(long long)logblocks);
@@ -2709,7 +2709,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		} else
 			logagno = (xfs_agnumber_t)(agcount / 2);
 
-		logstart = XFS_AGB_TO_FSB(mp, logagno, xfs_prealloc_blocks(mp));
+		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
 		/*
 		 * Align the logstart at stripe unit boundary.
 		 */
@@ -2788,7 +2788,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_imax_pct = imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
-	sbp->sb_fdblocks = dblocks - agcount * xfs_prealloc_blocks(mp) -
+	sbp->sb_fdblocks = dblocks - agcount * libxfs_prealloc_blocks(mp) -
 		(loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
@@ -2893,7 +2893,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	for (agno = 0; agno < agcount; agno++) {
 		struct xfs_agfl	*agfl;
 		int		bucket;
-		struct xfs_perag *pag = xfs_perag_get(mp, agno);
+		struct xfs_perag *pag = libxfs_perag_get(mp, agno);
 
 		/*
 		 * Superblock.
@@ -2937,7 +2937,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
-		nbmblocks = (xfs_extlen_t)(agsize - xfs_prealloc_blocks(mp));
+		nbmblocks = (xfs_extlen_t)(agsize - libxfs_prealloc_blocks(mp));
 		agf->agf_freeblks = cpu_to_be32(nbmblocks);
 		agf->agf_longest = cpu_to_be32(nbmblocks);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -2948,8 +2948,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			agf->agf_longest = cpu_to_be32(agsize -
 				XFS_FSB_TO_AGBNO(mp, logstart) - logblocks);
 		}
-		if (xfs_alloc_min_freelist(mp, pag) > worst_freelist)
-			worst_freelist = xfs_alloc_min_freelist(mp, pag);
+		if (libxfs_alloc_min_freelist(mp, pag) > worst_freelist)
+			worst_freelist = libxfs_alloc_min_freelist(mp, pag);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 		/*
@@ -3011,14 +3011,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, buf, XFS_ABTB_CRC_MAGIC, 0, 1,
+			libxfs_btree_init_block(mp, buf, XFS_ABTB_CRC_MAGIC, 0, 1,
 						agno, XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, buf, XFS_ABTB_MAGIC, 0, 1,
+			libxfs_btree_init_block(mp, buf, XFS_ABTB_MAGIC, 0, 1,
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(xfs_prealloc_blocks(mp));
+		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
 		if (loginternal && agno == logagno) {
 			if (lalign) {
 				/*
@@ -3066,14 +3066,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, buf, XFS_ABTC_CRC_MAGIC, 0, 1,
+			libxfs_btree_init_block(mp, buf, XFS_ABTC_CRC_MAGIC, 0, 1,
 						agno, XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, buf, XFS_ABTC_MAGIC, 0, 1,
+			libxfs_btree_init_block(mp, buf, XFS_ABTC_MAGIC, 0, 1,
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(xfs_prealloc_blocks(mp));
+		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
 		if (loginternal && agno == logagno) {
 			if (lalign) {
 				arec->ar_blockcount = cpu_to_be32(
@@ -3111,10 +3111,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, buf, XFS_IBT_CRC_MAGIC, 0, 0,
+			libxfs_btree_init_block(mp, buf, XFS_IBT_CRC_MAGIC, 0, 0,
 						agno, XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, buf, XFS_IBT_MAGIC, 0, 0,
+			libxfs_btree_init_block(mp, buf, XFS_IBT_MAGIC, 0, 0,
 						agno, 0);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
@@ -3129,10 +3129,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			block = XFS_BUF_TO_BLOCK(buf);
 			memset(block, 0, blocksize);
 			if (xfs_sb_version_hascrc(&mp->m_sb))
-				xfs_btree_init_block(mp, buf, XFS_FIBT_CRC_MAGIC, 0, 0,
+				libxfs_btree_init_block(mp, buf, XFS_FIBT_CRC_MAGIC, 0, 0,
 							agno, XFS_BTREE_CRC_BLOCKS);
 			else
-				xfs_btree_init_block(mp, buf, XFS_FIBT_MAGIC, 0, 0,
+				libxfs_btree_init_block(mp, buf, XFS_FIBT_MAGIC, 0, 0,
 							agno, 0);
 			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 		}
@@ -3148,7 +3148,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			block = XFS_BUF_TO_BLOCK(buf);
 			memset(block, 0, blocksize);
 
-			xfs_btree_init_block(mp, buf, XFS_RMAP_CRC_MAGIC, 0, 0,
+			libxfs_btree_init_block(mp, buf, XFS_RMAP_CRC_MAGIC, 0, 0,
 						agno, XFS_BTREE_CRC_BLOCKS);
 
 			/*
@@ -3203,7 +3203,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 		}
 
-		xfs_perag_put(pag);
+		libxfs_perag_put(pag);
 	}
 
 	/*
@@ -3241,10 +3241,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		args.mp = mp;
 		args.agno = agno;
 		args.alignment = 1;
-		args.pag = xfs_perag_get(mp,agno);
+		args.pag = libxfs_perag_get(mp,agno);
 
 		libxfs_alloc_fix_freelist(&args, 0);
-		xfs_perag_put(args.pag);
+		libxfs_perag_put(args.pag);
 		libxfs_trans_commit(tp);
 	}
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 89163b1..db55860 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -131,7 +131,7 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 		dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	}
 
-	if (!xfs_dinode_good_version(mp, dinoc->di_version)) {
+	if (!libxfs_dinode_good_version(mp, dinoc->di_version)) {
 		__dirty_no_modify_ret(dirty);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			dinoc->di_version = 3;
@@ -966,7 +966,7 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 	init_bm_cursor(&cursor, level + 1);
 
 	pp = XFS_BMDR_PTR_ADDR(dib, 1,
-		xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
+		libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
 	pkey = XFS_BMDR_KEY_ADDR(dib, 1);
 	last_key = NULLFILEOFF;
 
@@ -2240,7 +2240,7 @@ process_dinode_int(xfs_mount_t *mp,
 	 * rewritten, and the CRC is updated automagically.
 	 */
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
+	    !libxfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
 				XFS_DINODE_CRC_OFF)) {
 		retval = 1;
 		if (!uncertain)
@@ -2271,7 +2271,7 @@ process_dinode_int(xfs_mount_t *mp,
 		}
 	}
 
-	if (!xfs_dinode_good_version(mp, dino->di_version)) {
+	if (!libxfs_dinode_good_version(mp, dino->di_version)) {
 		retval = 1;
 		if (!uncertain)
 			do_warn(_("bad version number 0x%x on inode %" PRIu64 "%c"),
diff --git a/repair/phase5.c b/repair/phase5.c
index 5a7185c..93b1f75 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -360,7 +360,7 @@ finish_cursor(bt_status_t *curs)
  * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
  */
 #define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
-	(xfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
+	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
 
 /*
  * this calculates a freespace cursor for an ag.
@@ -693,10 +693,10 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, lptr->buf_p, crc_magic, level,
+			libxfs_btree_init_block(mp, lptr->buf_p, crc_magic, level,
 						0, agno, XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, lptr->buf_p, magic, level,
+			libxfs_btree_init_block(mp, lptr->buf_p, magic, level,
 						0, agno, 0);
 
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
@@ -779,10 +779,10 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, lptr->buf_p, crc_magic, i,
+			libxfs_btree_init_block(mp, lptr->buf_p, crc_magic, i,
 						0, agno, XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, lptr->buf_p, magic, i,
+			libxfs_btree_init_block(mp, lptr->buf_p, magic, i,
 						0, agno, 0);
 	}
 	/*
@@ -811,10 +811,10 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, lptr->buf_p, crc_magic, 0,
+			libxfs_btree_init_block(mp, lptr->buf_p, crc_magic, 0,
 						0, agno, XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, lptr->buf_p, magic, 0,
+			libxfs_btree_init_block(mp, lptr->buf_p, magic, 0,
 						0, agno, 0);
 
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
@@ -895,7 +895,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
  * XXX(hch): any reason we don't just look at mp->m_inobt_mxr?
  */
 #define XR_INOBT_BLOCK_MAXRECS(mp, level) \
-			xfs_inobt_maxrecs((mp), (mp)->m_sb.sb_blocksize, \
+			libxfs_inobt_maxrecs((mp), (mp)->m_sb.sb_blocksize, \
 						(level) == 0)
 
 /*
@@ -1073,11 +1073,11 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_CRC_MAGIC,
+			libxfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_CRC_MAGIC,
 						level, 0, agno,
 						XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_MAGIC,
+			libxfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_MAGIC,
 						level, 0, agno, 0);
 
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
@@ -1198,11 +1198,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, lptr->buf_p, magic,
+			libxfs_btree_init_block(mp, lptr->buf_p, magic,
 						i, 0, agno,
 						XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, lptr->buf_p, magic,
+			libxfs_btree_init_block(mp, lptr->buf_p, magic,
 						i, 0, agno, 0);
 	}
 
@@ -1232,11 +1232,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, lptr->buf_p, magic,
+			libxfs_btree_init_block(mp, lptr->buf_p, magic,
 						0, 0, agno,
 						XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, lptr->buf_p, magic,
+			libxfs_btree_init_block(mp, lptr->buf_p, magic,
 						0, 0, agno, 0);
 
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
@@ -1490,7 +1490,7 @@ prop_rmap_cursor(
 		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		xfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
+		libxfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
 					level, 0, agno,
 					XFS_BTREE_CRC_BLOCKS);
 
@@ -1604,7 +1604,7 @@ build_rmap_tree(
 		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		xfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
+		libxfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
 					i, 0, agno,
 					XFS_BTREE_CRC_BLOCKS);
 	}
@@ -1629,7 +1629,7 @@ _("Insufficient memory to construct reverse-map cursor."));
 		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		xfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
+		libxfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
 					0, 0, agno,
 					XFS_BTREE_CRC_BLOCKS);
 
@@ -2162,21 +2162,21 @@ phase5(xfs_mount_t *mp)
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
-		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
-		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
+		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
+		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
 	fprintf(stderr, "inobt level 0 (leaf), maxrec = %d, minrec = %d\n",
-		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
-		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
+		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
+		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
 	fprintf(stderr, "xr inobt level 0 (leaf), maxrec = %d\n",
 		XR_INOBT_BLOCK_MAXRECS(mp, 0));
 	fprintf(stderr, "xr inobt level 1 (int), maxrec = %d\n",
 		XR_INOBT_BLOCK_MAXRECS(mp, 1));
 	fprintf(stderr, "bnobt level 1, maxrec = %d, minrec = %d\n",
-		xfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
-		xfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
+		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
+		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
 	fprintf(stderr, "bnobt level 0 (leaf), maxrec = %d, minrec = %d\n",
-		xfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
-		xfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
+		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
+		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
 #endif
 	/*
 	 * make sure the root and realtime inodes show up allocated
diff --git a/repair/phase6.c b/repair/phase6.c
index 2500def..973a5f8 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -451,7 +451,7 @@ bmap_next_offset(
 	}
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
-	    (error = xfs_iread_extents(tp, ip, whichfork)))
+	    (error = -libxfs_iread_extents(tp, ip, whichfork)))
 		return error;
 	bno = *bnop + 1;
 	libxfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx,
@@ -1286,7 +1286,7 @@ longform_dir2_rebuild(
 	 */
 	pip.i_ino = get_inode_parent(irec, ino_offset);
 	if (pip.i_ino == NULLFSINO ||
-	    xfs_dir_ino_validate(mp, pip.i_ino))
+	    libxfs_dir_ino_validate(mp, pip.i_ino))
 		pip.i_ino = mp->m_sb.sb_rootino;
 
 	libxfs_defer_init(&dfops, &firstblock);
@@ -1311,7 +1311,7 @@ longform_dir2_rebuild(
 
 	ASSERT(done);
 
-	error = libxfs_dir_init(tp, ip, &pip);
+	error = -libxfs_dir_init(tp, ip, &pip);
 	if (error) {
 		do_warn(_("xfs_dir_init failed -- error - %d\n"), error);
 		goto out_bmap_cancel;
diff --git a/repair/prefetch.c b/repair/prefetch.c
index b4f20d9..b76a784 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -369,7 +369,7 @@ pf_read_btinode(
 		return;
 
 	dsize = XFS_DFORK_DSIZE(dino, mp);
-	pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(dsize, 0));
+	pp = XFS_BMDR_PTR_ADDR(dib, 1, libxfs_bmdr_maxrecs(dsize, 0));
 
 	for (i = 0; i < numrecs; i++) {
 		dbno = get_unaligned_be64(&pp[i]);
@@ -431,7 +431,7 @@ pf_read_inode_dirs(
 		if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)
 			continue;
 
-		if (!xfs_dinode_good_version(mp, dino->di_version))
+		if (!libxfs_dinode_good_version(mp, dino->di_version))
 			continue;
 
 		if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp))
diff --git a/repair/rmap.c b/repair/rmap.c
index b3d4c25..43b821d 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -61,8 +61,8 @@ rmap_compare(
 	__u64			ob;
 
 	pa = a; pb = b;
-	oa = xfs_rmap_irec_offset_pack(pa);
-	ob = xfs_rmap_irec_offset_pack(pb);
+	oa = libxfs_rmap_irec_offset_pack(pa);
+	ob = libxfs_rmap_irec_offset_pack(pb);
 
 	if (pa->rm_startblock < pb->rm_startblock)
 		return -1;
@@ -498,7 +498,7 @@ store_ag_btree_rmap_data(
 		goto err;
 
 	/* Add the AGFL blocks to the rmap list */
-	error = libxfs_trans_read_buf(
+	error = -libxfs_trans_read_buf(
 			mp, NULL, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &agflbp, &xfs_agfl_buf_ops);
@@ -536,13 +536,13 @@ store_ag_btree_rmap_data(
 		if (error)
 			goto err_slab;
 
-		error = libxfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+		error = -libxfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 		if (error)
 			goto err_trans;
 
 		ASSERT(XFS_RMAP_NON_INODE_OWNER(rm_rec->rm_owner));
 		libxfs_rmap_ag_owner(&oinfo, rm_rec->rm_owner);
-		error = libxfs_rmap_alloc(tp, agbp, agno, rm_rec->rm_startblock,
+		error = -libxfs_rmap_alloc(tp, agbp, agno, rm_rec->rm_startblock,
 				rm_rec->rm_blockcount, &oinfo);
 		if (error)
 			goto err_trans;
@@ -716,9 +716,9 @@ check_rmaps(
 		goto err;
 
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
-	pag = xfs_perag_get(mp, agno);
+	pag = libxfs_perag_get(mp, agno);
 	pag->pagf_init = 0;
-	xfs_perag_put(pag);
+	libxfs_perag_put(pag);
 
 	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
 	if (!bt_cur) {
@@ -804,10 +804,10 @@ rmap_diffkeys(
 
 	tmp = *kp1;
 	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
-	oa = xfs_rmap_irec_offset_pack(&tmp);
+	oa = libxfs_rmap_irec_offset_pack(&tmp);
 	tmp = *kp2;
 	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
-	ob = xfs_rmap_irec_offset_pack(&tmp);
+	ob = libxfs_rmap_irec_offset_pack(&tmp);
 
 	d = (__int64_t)kp1->rm_startblock - kp2->rm_startblock;
 	if (d)
@@ -867,7 +867,7 @@ fix_freelist(
 	args.mp = mp;
 	args.agno = agno;
 	args.alignment = 1;
-	args.pag = xfs_perag_get(mp, agno);
+	args.pag = libxfs_perag_get(mp, agno);
 	error = -libxfs_trans_alloc(mp, &tres,
 			libxfs_alloc_min_freelist(mp, args.pag), 0, 0, &tp);
 	if (error)
@@ -899,8 +899,8 @@ fix_freelist(
 	flags = XFS_ALLOC_FLAG_NOSHRINK;
 	if (skip_rmapbt)
 		flags |= XFS_ALLOC_FLAG_NORMAP;
-	error = libxfs_alloc_fix_freelist(&args, flags);
-	xfs_perag_put(args.pag);
+	error = -libxfs_alloc_fix_freelist(&args, flags);
+	libxfs_perag_put(args.pag);
 	if (error) {
 		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
 				agno, error);
diff --git a/repair/sb.c b/repair/sb.c
index a8170ba..ac13a66 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -384,7 +384,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 
 	/* sector size in range - CRC check time */
 	if (xfs_sb_version_hascrc(sb) &&
-	    !xfs_verify_cksum(sb_buf, sb->sb_sectsize, XFS_SB_CRC_OFF))
+	    !libxfs_verify_cksum(sb_buf, sb->sb_sectsize, XFS_SB_CRC_OFF))
 		return XR_BAD_CRC;
 
 	/* check to ensure blocksize and blocklog are legal */
diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
new file mode 100755
index 0000000..7937749
--- /dev/null
+++ b/tools/find-api-violations.sh
@@ -0,0 +1,38 @@
+#!/bin/bash
+
+# Find libxfs API violations -- calls to functions defined in libxfs/*.c that
+# don't use the libxfs wrappers; or failing to negate the integer return
+# values.
+
+# NOTE: This script doesn't look for API violations in function parameters.
+
+tool_dirs="copy db estimate fs fsck fsr growfs io mdrestore mkfs quota repair rtcp"
+
+# Calls to xfs_* functions in libxfs/*.c without the libxfs_ prefix
+find_possible_api_calls() {
+	grep -rn '[[:space:],-(]xfs_[a-z_]*(' $tool_dirs | sed -e 's/^.*\(xfs_[a-z_]*\)(.*$/\1/g' | sort | uniq
+}
+
+check_if_api_calls() {
+	while read f; do grep "^$f(" libxfs/*.c; done | sed -e 's/^.*:xfs_/xfs_/g' -e 's/.$//g'
+}
+
+find_libxfs_violations() {
+	grep -r -n -f <(find_possible_api_calls | check_if_api_calls | sed -e 's/^/[[:space:],-(]/g' -e 's/$/(/g' ) $tool_dirs
+}
+
+# libxfs calls without negated error codes
+find_errcode_violations() {
+	grep -r -n 'err.* = libxfs' $tool_dirs
+}
+
+# Find xfs_* calls that are in the libxfs definition list
+find_possible_libxfs_api_calls() {
+	grep '#define[[:space:]]*xfs' libxfs/libxfs_api_defs.h | awk '{print $2}'
+}
+
+find_libxfs_api_violations() {
+	grep -r -n -f <(find_possible_libxfs_api_calls | sed -e 's/^/[[:space:],-(]/g' -e 's/$/(/g') $tool_dirs
+}
+
+(find_libxfs_violations ; find_errcode_violations ; find_libxfs_api_violations) | sort -g -t ':' -k 2 | sort -g -t ':' -k 1 | uniq

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
