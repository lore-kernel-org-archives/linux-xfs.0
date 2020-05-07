Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1BCC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE48208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lcxhknh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgEGMUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgEGMUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444C9C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IU6a5kWzMa5gUDhUBmh4jBZOxiec52chMXpwiUbQoMs=; b=Lcxhknh4Ymg2AkhuN2bNxqEfni
        OrrVwI9mLil/+qzmXU86ZYU6KxZIq5Wa5T6hVQnHGNIFbl46xqo0kayhS12z5Y29M+po5t6B1bZjn
        waSfX/RanvEnEDXHG0m/2RvfxJAagwXRwwQph3gqXfPcuqZLnttIx8z+I4kV1cs06fTMzghYcISUh
        2PNzkwtqAvOVESig/2GXWDgyM6mM5/vKu9eLFCF62jGbsXJcjFTd+iTlzNtLukOO9AE1UUAMWlQfs
        yPCinBSv4vGHsQuU8tx7CH1Y+gF5RXaZUrIBP+qVIG0HLNpRGH8Ilfua/6FW7wW2KP5CQGI+Z3bOJ
        ur/uvZWA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVU-0005Uu-Ky; Thu, 07 May 2020 12:20:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 29/58] xfs: remove XFS_BUF_TO_AGI
Date:   Thu,  7 May 2020 14:18:22 +0200
Message-Id: <20200507121851.304002-30-hch@lst.de>
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

Source kernel commit: 370c782b98436bb3f9d14a7394ab126cdbeac233

Just dereference bp->b_addr directly and make the code a little
simpler and more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c           |  6 +++---
 libxfs/xfs_format.h       |  1 -
 libxfs/xfs_ialloc.c       | 27 +++++++++++++--------------
 libxfs/xfs_ialloc_btree.c | 10 +++++-----
 repair/phase3.c           |  2 +-
 repair/phase5.c           |  2 +-
 repair/scan.c             |  2 +-
 7 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 57f31e2f..375eeeae 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -312,7 +312,7 @@ xfs_agiblock_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(bp);
+	struct xfs_agi		*agi = bp->b_addr;
 	int			bucket;
 
 	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
@@ -502,7 +502,7 @@ xfs_ag_extend_space(
 	if (error)
 		return error;
 
-	agi = XFS_BUF_TO_AGI(bp);
+	agi = bp->b_addr;
 	be32_add_cpu(&agi->agi_length, len);
 	ASSERT(id->agno == mp->m_sb.sb_agcount - 1 ||
 	       be32_to_cpu(agi->agi_length) == mp->m_sb.sb_agblocks);
@@ -569,7 +569,7 @@ xfs_ag_get_geometry(
 	memset(ageo, 0, sizeof(*ageo));
 	ageo->ag_number = agno;
 
-	agi = XFS_BUF_TO_AGI(agi_bp);
+	agi = agi_bp->b_addr;
 	ageo->ag_icount = be32_to_cpu(agi->agi_count);
 	ageo->ag_ifree = be32_to_cpu(agi->agi_freecount);
 
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 32b1651d..dbcd8b27 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -775,7 +775,6 @@ typedef struct xfs_agi {
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
 #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
-#define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)((bp)->b_addr))
 
 /*
  * The third a.g. block contains the a.g. freelist, an array
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 00b33263..4906e89b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -172,7 +172,7 @@ xfs_inobt_insert(
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi		*agi = agbp->b_addr;
 	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agino_t		thisino;
 	int			i;
@@ -520,7 +520,7 @@ xfs_inobt_insert_sprec(
 	bool				merge)	/* merge or replace */
 {
 	struct xfs_btree_cur		*cur;
-	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi			*agi = agbp->b_addr;
 	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	int				error;
 	int				i;
@@ -653,7 +653,7 @@ xfs_ialloc_ag_alloc(
 	 * chunk of inodes.  If the filesystem is striped, this will fill
 	 * an entire stripe unit with inodes.
 	 */
-	agi = XFS_BUF_TO_AGI(agbp);
+	agi = agbp->b_addr;
 	newino = be32_to_cpu(agi->agi_newino);
 	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
@@ -1125,7 +1125,7 @@ xfs_dialloc_ag_inobt(
 	xfs_ino_t		*inop)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi		*agi = agbp->b_addr;
 	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agnumber_t		pagno = XFS_INO_TO_AGNO(mp, parent);
 	xfs_agino_t		pagino = XFS_INO_TO_AGINO(mp, parent);
@@ -1578,7 +1578,7 @@ xfs_dialloc_ag(
 	xfs_ino_t		*inop)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi			*agi = agbp->b_addr;
 	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agnumber_t			pagno = XFS_INO_TO_AGNO(mp, parent);
 	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
@@ -1938,7 +1938,7 @@ xfs_difree_inobt(
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
-	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi			*agi = agbp->b_addr;
 	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*cur;
@@ -2074,7 +2074,7 @@ xfs_difree_finobt(
 	xfs_agino_t			agino,
 	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
 {
-	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi			*agi = agbp->b_addr;
 	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
@@ -2484,9 +2484,8 @@ xfs_ialloc_log_agi(
 		sizeof(xfs_agi_t)
 	};
 #ifdef DEBUG
-	xfs_agi_t		*agi;	/* allocation group header */
+	struct xfs_agi		*agi = bp->b_addr;
 
-	agi = XFS_BUF_TO_AGI(bp);
 	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 #endif
 
@@ -2518,14 +2517,13 @@ xfs_agi_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_mount;
-	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
+	struct xfs_agi	*agi = bp->b_addr;
 	int		i;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (!xfs_log_check_lsn(mp,
-				be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn)))
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(agi->agi_lsn)))
 			return __this_address;
 	}
 
@@ -2588,6 +2586,7 @@ xfs_agi_write_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_agi		*agi = bp->b_addr;
 	xfs_failaddr_t		fa;
 
 	fa = xfs_agi_verify(bp);
@@ -2600,7 +2599,7 @@ xfs_agi_write_verify(
 		return;
 
 	if (bip)
-		XFS_BUF_TO_AGI(bp)->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+		agi->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 	xfs_buf_update_cksum(bp, XFS_AGI_CRC_OFF);
 }
 
@@ -2656,7 +2655,7 @@ xfs_ialloc_read_agi(
 	if (error)
 		return error;
 
-	agi = XFS_BUF_TO_AGI(*bpp);
+	agi = (*bpp)->b_addr;
 	pag = xfs_perag_get(mp, agno);
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 948b02ee..79c5721b 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -44,7 +44,7 @@ xfs_inobt_set_root(
 	int			inc)	/* level change */
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi		*agi = agbp->b_addr;
 
 	agi->agi_root = nptr->s;
 	be32_add_cpu(&agi->agi_level, inc);
@@ -58,7 +58,7 @@ xfs_finobt_set_root(
 	int			inc)	/* level change */
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi		*agi = agbp->b_addr;
 
 	agi->agi_free_root = nptr->s;
 	be32_add_cpu(&agi->agi_free_level, inc);
@@ -211,7 +211,7 @@ xfs_inobt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
+	struct xfs_agi		*agi = cur->bc_private.a.agbp->b_addr;
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
 
@@ -223,7 +223,7 @@ xfs_finobt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
+	struct xfs_agi		*agi = cur->bc_private.a.agbp->b_addr;
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
 	ptr->s = agi->agi_free_root;
@@ -409,7 +409,7 @@ xfs_inobt_init_cursor(
 	xfs_agnumber_t		agno,		/* allocation group number */
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_agi		*agi = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
diff --git a/repair/phase3.c b/repair/phase3.c
index d30a698e..ca4dbee4 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -37,7 +37,7 @@ process_agi_unlinked(
 		do_error(_("cannot read agi block %" PRId64 " for ag %u\n"),
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)), agno);
 
-	agip = XFS_BUF_TO_AGI(bp);
+	agip = bp->b_addr;
 
 	ASSERT(be32_to_cpu(agip->agi_seqno) == agno);
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 980ad045..f41e9716 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1136,7 +1136,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		do_error(_("Cannot grab AG %u AGI buffer, err=%d"),
 				agno, error);
 	agi_buf->b_ops = &xfs_agi_buf_ops;
-	agi = XFS_BUF_TO_AGI(agi_buf);
+	agi = agi_buf->b_addr;
 	memset(agi, 0, mp->m_sb.sb_sectsize);
 
 	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
diff --git a/repair/scan.c b/repair/scan.c
index 33a8476e..32937ada 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2393,7 +2393,7 @@ scan_ag(
 		objname = _("agi block");
 		goto out_free_agfbuf;
 	}
-	agi = XFS_BUF_TO_AGI(agibuf);
+	agi = agibuf->b_addr;
 
 	/* fix up bad ag headers */
 
-- 
2.26.2

