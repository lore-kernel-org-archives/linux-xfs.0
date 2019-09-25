Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A28C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B79DE21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KJnPuaYu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfIYVce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:32:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfIYVce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:32:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTGZO053890;
        Wed, 25 Sep 2019 21:32:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Dycnl933oLH8Ajj6s/0zroM1vbcvSfmG1ehoVYrHB78=;
 b=KJnPuaYuyA6NkHr5H2NpgSb/SMZVWDp9hYf099Fs1zxbKTY6xku8p3vuE8Fb7T0ubNpu
 ox02A4kzwKla3fy8tzml20VqfFPjpQwpSNcQmcru1tYKIybspeU4eXeQzlQgCuObI6Dy
 kPQx0/4wWGvcFVY4unRdj7mIsLE2t89MCUW1WgJPpnIU3ZfzWYCTcDSKiEu3yjJXI1Zv
 YlsZidODu10Y6bZrsGk4NUJ+YYJNe95uAK3oY6ek+kSuNHIY9LLe0MdRqvHNuB4kg8qQ
 ZCrT6UriQ6gIrcZZctbE9IgTaAx2MHb0d/v3oZxgUtdMeKt8Z3pACr9nv3NmwvGCiGZG pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tygqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTESQ011719;
        Wed, 25 Sep 2019 21:32:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuk9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLWQPf013856;
        Wed, 25 Sep 2019 21:32:26 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:32:26 -0700
Subject: [PATCH 4/4] mkfs: use libxfs to write out new AGs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Wed, 25 Sep 2019 14:32:24 -0700
Message-ID: <156944714471.296397.1482817288636439627.stgit@magnolia>
In-Reply-To: <156944712040.296397.10216531793013990772.stgit@magnolia>
References: <156944712040.296397.10216531793013990772.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the libxfs AG initialization functions to write out the new
filesystem instead of open-coding everything.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h         |    1 
 libxfs/libxfs_api_defs.h |    3 
 libxfs/util.c            |    1 
 mkfs/xfs_mkfs.c          |  371 ++++------------------------------------------
 4 files changed, 41 insertions(+), 335 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 663063bc..63696df5 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -63,6 +63,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_ag.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount_btree.h"
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0ae21318..645c9b1b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -154,4 +154,7 @@
 #define LIBXFS_ATTR_CREATE		ATTR_CREATE
 #define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
 
+#define xfs_ag_init_headers		libxfs_ag_init_headers
+#define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
+
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/libxfs/util.c b/libxfs/util.c
index 95054094..885dd42b 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -762,3 +762,4 @@ xfs_fs_mark_healthy(
 	spin_unlock(&mp->m_sb_lock);
 }
 
+void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6254fd42..10a40cd4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3430,349 +3430,30 @@ initialise_ag_headers(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp,
 	xfs_agnumber_t		agno,
-	int			*worst_freelist)
+	int			*worst_freelist,
+	struct list_head	*buffer_list)
 {
+	struct aghdr_init_data	id = {
+		.agno		= agno,
+		.agsize		= cfg->agsize,
+	};
 	struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
-	struct xfs_agfl		*agfl;
-	struct xfs_agf		*agf;
-	struct xfs_agi		*agi;
-	struct xfs_buf		*buf;
-	struct xfs_btree_block	*block;
-	struct xfs_alloc_rec	*arec;
-	struct xfs_alloc_rec	*nrec;
-	int			bucket;
-	uint64_t		agsize = cfg->agsize;
-	xfs_agblock_t		agblocks;
-	bool			is_log_ag = false;
-	int			c;
-
-	if (cfg->loginternal && agno == cfg->logagno)
-		is_log_ag = true;
-
-	/*
-	 * Superblock.
-	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-			XFS_FSS_TO_BB(mp, 1));
-	buf->b_ops = &xfs_sb_buf_ops;
-	memset(buf->b_addr, 0, cfg->sectorsize);
-	libxfs_sb_to_disk(buf->b_addr, sbp);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	int			error;
 
-	/*
-	 * AG header block: freespace
-	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1));
-	buf->b_ops = &xfs_agf_buf_ops;
-	agf = XFS_BUF_TO_AGF(buf);
-	memset(agf, 0, cfg->sectorsize);
 	if (agno == cfg->agcount - 1)
-		agsize = cfg->dblocks - (xfs_rfsblock_t)(agno * agsize);
-	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
-	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
-	agf->agf_seqno = cpu_to_be32(agno);
-	agf->agf_length = cpu_to_be32(agsize);
-	agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(XFS_BNO_BLOCK(mp));
-	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
-	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
-	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
-	pag->pagf_levels[XFS_BTNUM_BNOi] = 1;
-	pag->pagf_levels[XFS_BTNUM_CNTi] = 1;
-
-	if (xfs_sb_version_hasrmapbt(sbp)) {
-		agf->agf_roots[XFS_BTNUM_RMAPi] = cpu_to_be32(XFS_RMAP_BLOCK(mp));
-		agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
-		agf->agf_rmap_blocks = cpu_to_be32(1);
-	}
+		id.agsize = cfg->dblocks - (xfs_rfsblock_t)(agno * cfg->agsize);
 
-	if (xfs_sb_version_hasreflink(sbp)) {
-		agf->agf_refcount_root = cpu_to_be32(libxfs_refc_block(mp));
-		agf->agf_refcount_level = cpu_to_be32(1);
-		agf->agf_refcount_blocks = cpu_to_be32(1);
+	INIT_LIST_HEAD(&id.buffer_list);
+	error = -libxfs_ag_init_headers(mp, &id);
+	if (error) {
+		fprintf(stderr, _("AG header init failed, error %d\n"), error);
+		exit(1);
 	}
 
-	agf->agf_flfirst = 0;
-	agf->agf_fllast = cpu_to_be32(libxfs_agfl_size(mp) - 1);
-	agf->agf_flcount = 0;
-	agblocks = (xfs_agblock_t)(agsize - libxfs_prealloc_blocks(mp));
-	agf->agf_freeblks = cpu_to_be32(agblocks);
-	agf->agf_longest = cpu_to_be32(agblocks);
+	list_splice_tail_init(&id.buffer_list, buffer_list);
 
-	if (xfs_sb_version_hascrc(sbp))
-		platform_uuid_copy(&agf->agf_uuid, &sbp->sb_uuid);
-
-	if (is_log_ag) {
-		be32_add_cpu(&agf->agf_freeblks, -(int64_t)cfg->logblocks);
-		agf->agf_longest = cpu_to_be32(agsize -
-			XFS_FSB_TO_AGBNO(mp, cfg->logstart) - cfg->logblocks);
-	}
 	if (libxfs_alloc_min_freelist(mp, pag) > *worst_freelist)
 		*worst_freelist = libxfs_alloc_min_freelist(mp, pag);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-	/*
-	 * AG freelist header block
-	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1));
-	buf->b_ops = &xfs_agfl_buf_ops;
-	agfl = XFS_BUF_TO_AGFL(buf);
-	/* setting to 0xff results in initialisation to NULLAGBLOCK */
-	memset(agfl, 0xff, cfg->sectorsize);
-	if (xfs_sb_version_hascrc(sbp)) {
-		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
-		agfl->agfl_seqno = cpu_to_be32(agno);
-		platform_uuid_copy(&agfl->agfl_uuid, &sbp->sb_uuid);
-		for (bucket = 0; bucket < libxfs_agfl_size(mp); bucket++)
-			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
-	}
-
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-	/*
-	 * AG header block: inodes
-	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1));
-	agi = XFS_BUF_TO_AGI(buf);
-	buf->b_ops = &xfs_agi_buf_ops;
-	memset(agi, 0, cfg->sectorsize);
-	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
-	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
-	agi->agi_seqno = cpu_to_be32(agno);
-	agi->agi_length = cpu_to_be32(agsize);
-	agi->agi_count = 0;
-	agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
-	agi->agi_level = cpu_to_be32(1);
-	if (xfs_sb_version_hasfinobt(sbp)) {
-		agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
-		agi->agi_free_level = cpu_to_be32(1);
-	}
-	agi->agi_freecount = 0;
-	agi->agi_newino = cpu_to_be32(NULLAGINO);
-	agi->agi_dirino = cpu_to_be32(NULLAGINO);
-	if (xfs_sb_version_hascrc(sbp))
-		platform_uuid_copy(&agi->agi_uuid, &sbp->sb_uuid);
-	for (c = 0; c < XFS_AGI_UNLINKED_BUCKETS; c++)
-		agi->agi_unlinked[c] = cpu_to_be32(NULLAGINO);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-	/*
-	 * BNO btree root block
-	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
-			BTOBB(cfg->blocksize));
-	buf->b_ops = &xfs_bnobt_buf_ops;
-	block = XFS_BUF_TO_BLOCK(buf);
-	memset(block, 0, cfg->blocksize);
-	libxfs_btree_init_block(mp, buf, XFS_BTNUM_BNO, 0, 1, agno);
-
-	arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-	arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-	if (is_log_ag) {
-		xfs_agblock_t	start = XFS_FSB_TO_AGBNO(mp, cfg->logstart);
-
-		ASSERT(start >= libxfs_prealloc_blocks(mp));
-		if (start != libxfs_prealloc_blocks(mp)) {
-			/*
-			 * Modify first record to pad stripe align of log
-			 */
-			arec->ar_blockcount = cpu_to_be32(start -
-						libxfs_prealloc_blocks(mp));
-			nrec = arec + 1;
-			/*
-			 * Insert second record at start of internal log
-			 * which then gets trimmed.
-			 */
-			nrec->ar_startblock = cpu_to_be32(
-					be32_to_cpu(arec->ar_startblock) +
-					be32_to_cpu(arec->ar_blockcount));
-			arec = nrec;
-			be16_add_cpu(&block->bb_numrecs, 1);
-		}
-		/*
-		 * Change record start to after the internal log
-		 */
-		be32_add_cpu(&arec->ar_startblock, cfg->logblocks);
-	}
-	/*
-	 * Calculate the record block count and check for the case where
-	 * the log might have consumed all available space in the AG. If
-	 * so, reset the record count to 0 to avoid exposure of an invalid
-	 * record start block.
-	 */
-	arec->ar_blockcount = cpu_to_be32(agsize -
-					  be32_to_cpu(arec->ar_startblock));
-	if (!arec->ar_blockcount)
-		block->bb_numrecs = 0;
-
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-	/*
-	 * CNT btree root block
-	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
-			BTOBB(cfg->blocksize));
-	buf->b_ops = &xfs_cntbt_buf_ops;
-	block = XFS_BUF_TO_BLOCK(buf);
-	memset(block, 0, cfg->blocksize);
-	libxfs_btree_init_block(mp, buf, XFS_BTNUM_CNT, 0, 1, agno);
-
-	arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-	arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-	if (is_log_ag) {
-		xfs_agblock_t	start = XFS_FSB_TO_AGBNO(mp, cfg->logstart);
-
-		ASSERT(start >= libxfs_prealloc_blocks(mp));
-		if (start != libxfs_prealloc_blocks(mp)) {
-			arec->ar_blockcount = cpu_to_be32(start -
-					libxfs_prealloc_blocks(mp));
-			nrec = arec + 1;
-			nrec->ar_startblock = cpu_to_be32(
-					be32_to_cpu(arec->ar_startblock) +
-					be32_to_cpu(arec->ar_blockcount));
-			arec = nrec;
-			be16_add_cpu(&block->bb_numrecs, 1);
-		}
-		be32_add_cpu(&arec->ar_startblock, cfg->logblocks);
-	}
-	/*
-	 * Calculate the record block count and check for the case where
-	 * the log might have consumed all available space in the AG. If
-	 * so, reset the record count to 0 to avoid exposure of an invalid
-	 * record start block.
-	 */
-	arec->ar_blockcount = cpu_to_be32(agsize -
-					  be32_to_cpu(arec->ar_startblock));
-	if (!arec->ar_blockcount)
-		block->bb_numrecs = 0;
-
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-	/*
-	 * refcount btree root block
-	 */
-	if (xfs_sb_version_hasreflink(sbp)) {
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, libxfs_refc_block(mp)),
-			BTOBB(cfg->blocksize));
-		buf->b_ops = &xfs_refcountbt_buf_ops;
-
-		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, cfg->blocksize);
-		libxfs_btree_init_block(mp, buf, XFS_BTNUM_REFC, 0, 0, agno);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-	}
-
-	/*
-	 * INO btree root block
-	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
-			BTOBB(cfg->blocksize));
-	buf->b_ops = &xfs_inobt_buf_ops;
-	block = XFS_BUF_TO_BLOCK(buf);
-	memset(block, 0, cfg->blocksize);
-	libxfs_btree_init_block(mp, buf, XFS_BTNUM_INO, 0, 0, agno);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-	/*
-	 * Free INO btree root block
-	 */
-	if (xfs_sb_version_hasfinobt(sbp)) {
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
-				BTOBB(cfg->blocksize));
-		buf->b_ops = &xfs_finobt_buf_ops;
-		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, cfg->blocksize);
-		libxfs_btree_init_block(mp, buf, XFS_BTNUM_FINO, 0, 0, agno);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-	}
-
-	/* RMAP btree root block */
-	if (xfs_sb_version_hasrmapbt(sbp)) {
-		struct xfs_rmap_rec	*rrec;
-
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_RMAP_BLOCK(mp)),
-			BTOBB(cfg->blocksize));
-		buf->b_ops = &xfs_rmapbt_buf_ops;
-		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, cfg->blocksize);
-
-		libxfs_btree_init_block(mp, buf, XFS_BTNUM_RMAP, 0, 0, agno);
-
-		/*
-		 * mark the AG header regions as static metadata
-		 * The BNO btree block is the first block after the
-		 * headers, so it's location defines the size of region
-		 * the static metadata consumes.
-		 */
-		rrec = XFS_RMAP_REC_ADDR(block, 1);
-		rrec->rm_startblock = 0;
-		rrec->rm_blockcount = cpu_to_be32(XFS_BNO_BLOCK(mp));
-		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_FS);
-		rrec->rm_offset = 0;
-		be16_add_cpu(&block->bb_numrecs, 1);
-
-		/* account freespace btree root blocks */
-		rrec = XFS_RMAP_REC_ADDR(block, 2);
-		rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
-		rrec->rm_blockcount = cpu_to_be32(2);
-		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
-		rrec->rm_offset = 0;
-		be16_add_cpu(&block->bb_numrecs, 1);
-
-		/* account inode btree root blocks */
-		rrec = XFS_RMAP_REC_ADDR(block, 3);
-		rrec->rm_startblock = cpu_to_be32(XFS_IBT_BLOCK(mp));
-		rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
-						XFS_IBT_BLOCK(mp));
-		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
-		rrec->rm_offset = 0;
-		be16_add_cpu(&block->bb_numrecs, 1);
-
-		/* account for rmap btree root */
-		rrec = XFS_RMAP_REC_ADDR(block, 4);
-		rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
-		rrec->rm_blockcount = cpu_to_be32(1);
-		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
-		rrec->rm_offset = 0;
-		be16_add_cpu(&block->bb_numrecs, 1);
-
-		/* account for refcount btree root */
-		if (xfs_sb_version_hasreflink(sbp)) {
-			rrec = XFS_RMAP_REC_ADDR(block, 5);
-			rrec->rm_startblock = cpu_to_be32(libxfs_refc_block(mp));
-			rrec->rm_blockcount = cpu_to_be32(1);
-			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_REFC);
-			rrec->rm_offset = 0;
-			be16_add_cpu(&block->bb_numrecs, 1);
-		}
-
-		/* account for the log space */
-		if (is_log_ag) {
-			rrec = XFS_RMAP_REC_ADDR(block,
-					be16_to_cpu(block->bb_numrecs) + 1);
-			rrec->rm_startblock = cpu_to_be32(
-					XFS_FSB_TO_AGBNO(mp, cfg->logstart));
-			rrec->rm_blockcount = cpu_to_be32(cfg->logblocks);
-			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
-			rrec->rm_offset = 0;
-			be16_add_cpu(&block->bb_numrecs, 1);
-		}
-
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-	}
-
 	libxfs_perag_put(pag);
 }
 
@@ -3895,6 +3576,8 @@ main(
 		},
 	};
 
+	struct list_head	buffer_list;
+
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -4086,8 +3769,26 @@ main(
 	/*
 	 * Initialise all the static on disk metadata.
 	 */
-	for (agno = 0; agno < cfg.agcount; agno++)
-		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist);
+	INIT_LIST_HEAD(&buffer_list);
+	for (agno = 0; agno < cfg.agcount; agno++) {
+		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist,
+				&buffer_list);
+
+		if (agno % 16)
+			continue;
+
+		if (libxfs_buf_delwri_submit(&buffer_list)) {
+			fprintf(stderr, _("%s: writing AG headers failed\n"),
+					progname);
+			exit(1);
+		}
+	}
+
+	if (libxfs_buf_delwri_submit(&buffer_list)) {
+		fprintf(stderr, _("%s: writing AG headers failed\n"),
+				progname);
+		exit(1);
+	}
 
 	/*
 	 * Initialise the freespace freelists (i.e. AGFLs) in each AG.

