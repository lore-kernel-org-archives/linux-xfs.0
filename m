Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D8CC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3DD32083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rPGuP8uZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEGMUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgEGMUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2BEC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TL50tMPoctIQ6MSMTaXYbwvjt4WDcdgcN8YgRGoFOno=; b=rPGuP8uZW42SLT2z3b3/BYxHOX
        x04g2n/x9rpKxFKOWFA898y+LbyhNA6/OtX8sZXMlQ/80OeiiZ7dAnJsAb9rXnkHDdaCliGMXCQSF
        DGLLUVRS9FY4LR222jT1dvu6GQ2jEwCMFYe76JK66JrjB9O7vYVXOmxsu75XL9qrQ0UVmcQS5WQ6i
        U3HVB/C42OabO6CLg8JHtybWNiWcYGk6kStzx8KIKP90wlhvAdw5y/dlRLq9aTl8skhXHOER2jqpm
        8JpnV9wqaIWksU2xzu5N+bnTlCSZ7Ls4rbw7yWmH0kRCeZbzstBSWI6RJ7uxsOn1XnZDanP30EMz6
        og3n5L+g==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVP-0005EU-SA; Thu, 07 May 2020 12:20:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 27/58] xfs: remove the agfl_bno member from struct xfs_agfl
Date:   Thu,  7 May 2020 14:18:20 +0200
Message-Id: <20200507121851.304002-28-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 183606d82446110e23987d4b693f3d3fc300bd82

struct xfs_agfl is a header in front of the AGFL entries that exists
for CRC enabled file systems.  For not CRC enabled file systems the AGFL
is simply a list of agbno.  Make the CRC case similar to that by just
using the list behind the new header.  This indirectly solves a problem
with modern gcc versions that warn about taking addresses of packed
structures (and we have to pack the AGFL given that gcc rounds up
structure sizes).  Also replace the helper macro to get from a buffer
with an inline function in xfs_alloc.h to make the code easier to
read.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/agfl.c           |  5 +++--
 db/check.c          |  2 +-
 db/metadump.c       |  2 +-
 libxfs/xfs_ag.c     |  2 +-
 libxfs/xfs_alloc.c  | 11 ++++++-----
 libxfs/xfs_alloc.h  |  9 +++++++++
 libxfs/xfs_format.h |  6 ------
 repair/phase5.c     |  4 ++--
 repair/rmap.c       |  2 +-
 9 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/db/agfl.c b/db/agfl.c
index 4fb0d460..33075351 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -47,8 +47,9 @@ const field_t	agfl_crc_flds[] = {
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
-	{ "bno", FLDT_AGBLOCKNZ, OI(OFF(bno)), agfl_bno_size,
-	  FLD_ARRAY|FLD_COUNT, TYP_DATA },
+	/* the bno array really is behind the actual structure */
+	{ "bno", FLDT_AGBLOCKNZ, OI(bitize(sizeof(struct xfs_agfl))),
+	  agfl_bno_size, FLD_ARRAY|FLD_COUNT, TYP_DATA },
 	{ NULL }
 };
 
diff --git a/db/check.c b/db/check.c
index f2eca458..217060b5 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4074,7 +4074,7 @@ scan_freelist(
 		return;
 	}
 
-	/* open coded XFS_BUF_TO_AGFL_BNO */
+	/* open coded xfs_buf_to_agfl_bno */
 	state.count = 0;
 	state.agno = seqno;
 	libxfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &state);
diff --git a/db/metadump.c b/db/metadump.c
index d542762e..ac0e28b2 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2750,7 +2750,7 @@ scan_ag(
 			int i;
 			 __be32  *agfl_bno;
 
-			agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, iocur_top->bp);
+			agfl_bno = xfs_buf_to_agfl_bno(iocur_top->bp);
 			i = be32_to_cpu(agf->agf_fllast);
 
 			for (;;) {
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 73fb30cb..57f31e2f 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -301,7 +301,7 @@ xfs_agflblock_init(
 		uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
 	}
 
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
+	agfl_bno = xfs_buf_to_agfl_bno(bp);
 	for (bucket = 0; bucket < xfs_agfl_size(mp); bucket++)
 		agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 09db6693..268776f2 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -585,6 +585,7 @@ xfs_agfl_verify(
 {
 	struct xfs_mount *mp = bp->b_mount;
 	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
+	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
 	int		i;
 
 	/*
@@ -610,8 +611,8 @@ xfs_agfl_verify(
 		return __this_address;
 
 	for (i = 0; i < xfs_agfl_size(mp); i++) {
-		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
-		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
+		if (be32_to_cpu(agfl_bno[i]) != NULLAGBLOCK &&
+		    be32_to_cpu(agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return __this_address;
 	}
 
@@ -2680,7 +2681,7 @@ xfs_alloc_get_freelist(
 	/*
 	 * Get the block number and update the data structures.
 	 */
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
 	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
@@ -2816,7 +2817,7 @@ xfs_alloc_put_freelist(
 
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
 
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	blockp = &agfl_bno[be32_to_cpu(agf->agf_fllast)];
 	*blockp = cpu_to_be32(bno);
 	startoff = (char *)blockp - (char *)agflbp->b_addr;
@@ -3420,7 +3421,7 @@ xfs_agfl_walk(
 	unsigned int		i;
 	int			error;
 
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	i = be32_to_cpu(agf->agf_flfirst);
 
 	/* Nothing to walk in an empty AGFL. */
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 7380fbe4..a851bf77 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -236,4 +236,13 @@ typedef int (*xfs_agfl_walk_fn)(struct xfs_mount *mp, xfs_agblock_t bno,
 int xfs_agfl_walk(struct xfs_mount *mp, struct xfs_agf *agf,
 		struct xfs_buf *agflbp, xfs_agfl_walk_fn walk_fn, void *priv);
 
+static inline __be32 *
+xfs_buf_to_agfl_bno(
+	struct xfs_buf		*bp)
+{
+	if (xfs_sb_version_hascrc(&bp->b_mount->m_sb))
+		return bp->b_addr + sizeof(struct xfs_agfl);
+	return bp->b_addr;
+}
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 3dcc1ed5..c1c69a4c 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -785,18 +785,12 @@ typedef struct xfs_agi {
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
 #define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
 
-#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
-		(__be32 *)(bp)->b_addr)
-
 typedef struct xfs_agfl {
 	__be32		agfl_magicnum;
 	__be32		agfl_seqno;
 	uuid_t		agfl_uuid;
 	__be64		agfl_lsn;
 	__be32		agfl_crc;
-	__be32		agfl_bno[];	/* actually xfs_agfl_size(mp) */
 } __attribute__((packed)) xfs_agfl_t;
 
 #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
diff --git a/repair/phase5.c b/repair/phase5.c
index abae8a08..8a2ef64f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2149,14 +2149,14 @@ build_agf_agfl(
 
 	/* setting to 0xff results in initialisation to NULLAGBLOCK */
 	memset(agfl, 0xff, mp->m_sb.sb_sectsize);
+	freelist = xfs_buf_to_agfl_bno(agfl_buf);
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(agno);
 		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
 		for (i = 0; i < libxfs_agfl_size(mp); i++)
-			agfl->agfl_bno[i] = cpu_to_be32(NULLAGBLOCK);
+			freelist[i] = cpu_to_be32(NULLAGBLOCK);
 	}
-	freelist = XFS_BUF_TO_AGFL_BNO(mp, agfl_buf);
 
 	/*
 	 * do we have left-over blocks in the btree cursors that should
diff --git a/repair/rmap.c b/repair/rmap.c
index a37efbe7..a4cc6a49 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -512,7 +512,7 @@ rmap_store_ag_btree_rec(
 	free_slab_cursor(&rm_cur);
 
 	/* Create rmaps for any AGFL blocks that aren't already rmapped. */
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	b = agfl_bno + ag_rmap->ar_flcount;
 	while (*b != cpu_to_be32(NULLAGBLOCK) &&
 	       b - agfl_bno < libxfs_agfl_size(mp)) {
-- 
2.26.2

