Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAD8C2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 13:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 226462063A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 13:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UDsnt0fR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgA3NeB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 08:34:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33852 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3NeB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 08:34:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=l5oGfwqzTQMZDA42WtbLvf7As0OnilKHJVy7ElPEDN4=; b=UDsnt0fRhdyy9rJA4dsY8iKoAn
        BA024evHG8q3cuu1KxdBmhjbAfa1hNV6DS6tgzVasJQSQGVq7nsd8sfSzS1Tz15LEM83OdzRO8bpQ
        PY1IzaZgv1kZM80HmU0N2F+vEDF9J6u06JBFb8dAmHBNJrplidYKxMRI/YjtTqvQy4HEUfT8TZe8w
        fN0xapdDvwn4wOil/5lIX/r9qAV5LSPFnlxeh+oYoeQf8jm59xfRy3EpwQHJ2HpfakeYlB8+NIueL
        V43UyRSCX8/Ck9BXrIrvdOa8oVHKVANETFeZLPii7GLQ9u9yepZ251VbCAKptdR3jQdAMzUTGlxs8
        epu8pizw==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ix9xI-00043S-Fz; Thu, 30 Jan 2020 13:34:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/6] xfs: remove XFS_BUF_TO_AGF
Date:   Thu, 30 Jan 2020 14:33:42 +0100
Message-Id: <20200130133343.225818-6-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200130133343.225818-1-hch@lst.de>
References: <20200130133343.225818-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just dereference bp->b_addr directly and make the code a little
simpler and more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c             |  6 ++--
 fs/xfs/libxfs/xfs_alloc.c          | 52 +++++++++++++-----------------
 fs/xfs/libxfs/xfs_alloc_btree.c    | 10 +++---
 fs/xfs/libxfs/xfs_format.h         |  1 -
 fs/xfs/libxfs/xfs_refcount_btree.c | 12 +++----
 fs/xfs/libxfs/xfs_rmap_btree.c     | 12 +++----
 fs/xfs/scrub/agheader.c            | 14 ++++----
 fs/xfs/scrub/agheader_repair.c     | 14 ++++----
 fs/xfs/scrub/repair.c              |  8 +++--
 fs/xfs/xfs_discard.c               |  7 ++--
 fs/xfs/xfs_log_recover.c           |  4 +--
 11 files changed, 68 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 465d0d568411..447e363d8468 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -243,7 +243,7 @@ xfs_agfblock_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(bp);
+	struct xfs_agf		*agf = bp->b_addr;
 	xfs_extlen_t		tmpsize;
 
 	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
@@ -515,7 +515,7 @@ xfs_ag_extend_space(
 	if (error)
 		return error;
 
-	agf = XFS_BUF_TO_AGF(bp);
+	agf = bp->b_addr;
 	be32_add_cpu(&agf->agf_length, len);
 	ASSERT(agf->agf_length == agi->agi_length);
 	xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
@@ -573,7 +573,7 @@ xfs_ag_get_geometry(
 	ageo->ag_icount = be32_to_cpu(agi->agi_count);
 	ageo->ag_ifree = be32_to_cpu(agi->agi_freecount);
 
-	agf = XFS_BUF_TO_AGF(agf_bp);
+	agf = agf_bp->b_addr;
 	ageo->ag_length = be32_to_cpu(agf->agf_length);
 	freeblks = pag->pagf_freeblks +
 		   pag->pagf_flcount +
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 2006a49ea95f..8a47fb296082 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -715,7 +715,7 @@ xfs_alloc_update_counters(
 	struct xfs_buf		*agbp,
 	long			len)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 
 	pag->pagf_freeblks += len;
 	be32_add_cpu(&agf->agf_freeblks, len);
@@ -924,13 +924,13 @@ xfs_alloc_cur_finish(
 	struct xfs_alloc_arg	*args,
 	struct xfs_alloc_cur	*acur)
 {
+	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
 	int			error;
 
 	ASSERT(acur->cnt && acur->bnolt);
 	ASSERT(acur->bno >= acur->rec_bno);
 	ASSERT(acur->bno + acur->len <= acur->rec_bno + acur->rec_len);
-	ASSERT(acur->rec_bno + acur->rec_len <=
-	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+	ASSERT(acur->rec_bno + acur->rec_len <= be32_to_cpu(agf->agf_length));
 
 	error = xfs_alloc_fixup_trees(acur->cnt, acur->bnolt, acur->rec_bno,
 				      acur->rec_len, acur->bno, acur->len, 0);
@@ -1028,6 +1028,7 @@ xfs_alloc_ag_vextent_small(
 	xfs_extlen_t		*flenp,	/* result length */
 	int			*stat)	/* status: 0-freelist, 1-normal/none */
 {
+	struct xfs_agf		*agf = args->agbp->b_addr;
 	int			error = 0;
 	xfs_agblock_t		fbno = NULLAGBLOCK;
 	xfs_extlen_t		flen = 0;
@@ -1056,8 +1057,7 @@ xfs_alloc_ag_vextent_small(
 
 	if (args->minlen != 1 || args->alignment != 1 ||
 	    args->resv == XFS_AG_RESV_AGFL ||
-	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
-	     args->minleft))
+	    be32_to_cpu(agf->agf_flcount) <= args->minleft)
 		goto out;
 
 	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
@@ -1081,9 +1081,7 @@ xfs_alloc_ag_vextent_small(
 	}
 	*fbnop = args->agbno = fbno;
 	*flenp = args->len = 1;
-	if (XFS_IS_CORRUPT(args->mp,
-			   fbno >= be32_to_cpu(
-				   XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+	if (XFS_IS_CORRUPT(args->mp, fbno >= be32_to_cpu(agf->agf_length))) {
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -1205,6 +1203,7 @@ STATIC int			/* error */
 xfs_alloc_ag_vextent_exact(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
+	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
 	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
 	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
 	int		error;
@@ -1283,8 +1282,7 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
-	ASSERT(args->agbno + args->len <=
-		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
 	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
 				      args->len, XFSA_FIXUP_BNO_OK);
 	if (error) {
@@ -1663,6 +1661,7 @@ STATIC int				/* error */
 xfs_alloc_ag_vextent_size(
 	xfs_alloc_arg_t	*args)		/* allocation argument structure */
 {
+	struct xfs_agf	*agf = args->agbp->b_addr;
 	xfs_btree_cur_t	*bno_cur;	/* cursor for bno btree */
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for cnt btree */
 	int		error;		/* error result */
@@ -1853,8 +1852,7 @@ xfs_alloc_ag_vextent_size(
 	args->agbno = rbno;
 	if (XFS_IS_CORRUPT(args->mp,
 			   args->agbno + args->len >
-			   be32_to_cpu(
-				   XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+			   be32_to_cpu(agf->agf_length))) {
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -2426,7 +2424,7 @@ xfs_agfl_reset(
 	struct xfs_perag	*pag)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 
 	ASSERT(pag->pagf_agflreset);
 	trace_xfs_agfl_reset(mp, agf, 0, _RET_IP_);
@@ -2657,7 +2655,7 @@ xfs_alloc_get_freelist(
 	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
 	int		btreeblk) /* destination is a AGF btree */
 {
-	xfs_agf_t	*agf;	/* a.g. freespace structure */
+	struct xfs_agf	*agf = agbp->b_addr;
 	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	__be32		*agfl_bno;
@@ -2669,7 +2667,6 @@ xfs_alloc_get_freelist(
 	/*
 	 * Freelist is empty, give up.
 	 */
-	agf = XFS_BUF_TO_AGF(agbp);
 	if (!agf->agf_flcount) {
 		*bnop = NULLAGBLOCK;
 		return 0;
@@ -2747,7 +2744,7 @@ xfs_alloc_log_agf(
 		sizeof(xfs_agf_t)
 	};
 
-	trace_xfs_agf(tp->t_mountp, XFS_BUF_TO_AGF(bp), fields, _RET_IP_);
+	trace_xfs_agf(tp->t_mountp, bp->b_addr, fields, _RET_IP_);
 
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGF_BUF);
 
@@ -2785,18 +2782,15 @@ xfs_alloc_put_freelist(
 	xfs_agblock_t		bno,	/* block being freed */
 	int			btreeblk) /* block came from a AGF btree */
 {
-	xfs_agf_t		*agf;	/* a.g. freespace structure */
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agf		*agf = agbp->b_addr;
 	__be32			*blockp;/* pointer to array entry */
 	int			error;
 	int			logflags;
-	xfs_mount_t		*mp;	/* mount structure */
 	xfs_perag_t		*pag;	/* per allocation group data */
 	__be32			*agfl_bno;
 	int			startoff;
 
-	agf = XFS_BUF_TO_AGF(agbp);
-	mp = tp->t_mountp;
-
 	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
 			be32_to_cpu(agf->agf_seqno), &agflbp)))
 		return error;
@@ -2840,13 +2834,12 @@ xfs_agf_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_mount;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(bp);
+	struct xfs_agf		*agf = bp->b_addr;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (!xfs_log_check_lsn(mp,
-				be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(agf->agf_lsn)))
 			return __this_address;
 	}
 
@@ -2916,6 +2909,7 @@ xfs_agf_write_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_agf		*agf = bp->b_addr;
 	xfs_failaddr_t		fa;
 
 	fa = xfs_agf_verify(bp);
@@ -2928,7 +2922,7 @@ xfs_agf_write_verify(
 		return;
 
 	if (bip)
-		XFS_BUF_TO_AGF(bp)->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+		agf->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
 	xfs_buf_update_cksum(bp, XFS_AGF_CRC_OFF);
 }
@@ -2996,7 +2990,7 @@ xfs_alloc_read_agf(
 		return error;
 	ASSERT(!(*bpp)->b_error);
 
-	agf = XFS_BUF_TO_AGF(*bpp);
+	agf = (*bpp)->b_addr;
 	pag = xfs_perag_get(mp, agno);
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
@@ -3277,6 +3271,7 @@ __xfs_free_extent(
 	struct xfs_buf			*agbp;
 	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp, bno);
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	struct xfs_agf			*agf;
 	int				error;
 	unsigned int			busy_flags = 0;
 
@@ -3290,6 +3285,7 @@ __xfs_free_extent(
 	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
 	if (error)
 		return error;
+	agf = agbp->b_addr;
 
 	if (XFS_IS_CORRUPT(mp, agbno >= mp->m_sb.sb_agblocks)) {
 		error = -EFSCORRUPTED;
@@ -3297,9 +3293,7 @@ __xfs_free_extent(
 	}
 
 	/* validate the extent size is legal now we have the agf locked */
-	if (XFS_IS_CORRUPT(mp,
-			   agbno + len >
-			   be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length))) {
+	if (XFS_IS_CORRUPT(mp, agbno + len > be32_to_cpu(agf->agf_length))) {
 		error = -EFSCORRUPTED;
 		goto err;
 	}
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 279694d73e4e..b1b3dc1b0b89 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -36,7 +36,7 @@ xfs_allocbt_set_root(
 	int			inc)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
 	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
@@ -87,7 +87,7 @@ xfs_allocbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -113,7 +113,7 @@ xfs_allocbt_update_lastrec(
 	int			ptr,
 	int			reason)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	struct xfs_perag	*pag;
 	__be32			len;
@@ -226,7 +226,7 @@ xfs_allocbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
 
@@ -482,7 +482,7 @@ xfs_allocbt_init_cursor(
 	xfs_agnumber_t		agno,		/* allocation group number */
 	xfs_btnum_t		btnum)		/* btree identifier */
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5710fed6c75a..03531f0f537a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -707,7 +707,6 @@ typedef struct xfs_agf {
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
-#define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)((bp)->b_addr))
 
 /*
  * Size of the unlinked inode hash table in the agi.
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 38529dbacd55..a76997740e45 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -35,7 +35,7 @@ xfs_refcountbt_set_root(
 	int			inc)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
 
@@ -58,7 +58,7 @@ xfs_refcountbt_alloc_block(
 	int			*stat)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_alloc_arg	args;		/* block allocation args */
 	int			error;		/* error return value */
 
@@ -102,7 +102,7 @@ xfs_refcountbt_free_block(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	int			error;
 
@@ -169,7 +169,7 @@ xfs_refcountbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
 
@@ -320,7 +320,7 @@ xfs_refcountbt_init_cursor(
 	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(agno != NULLAGNUMBER);
@@ -420,7 +420,7 @@ xfs_refcountbt_calc_reserves(
 	if (error)
 		return error;
 
-	agf = XFS_BUF_TO_AGF(agbp);
+	agf = agbp->b_addr;
 	agblocks = be32_to_cpu(agf->agf_length);
 	tree_len = be32_to_cpu(agf->agf_refcount_blocks);
 	xfs_trans_brelse(tp, agbp);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index fc78efa52c94..725cb892f157 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -61,7 +61,7 @@ xfs_rmapbt_set_root(
 	int			inc)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
 	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
@@ -84,7 +84,7 @@ xfs_rmapbt_alloc_block(
 	int			*stat)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	int			error;
 	xfs_agblock_t		bno;
 
@@ -121,7 +121,7 @@ xfs_rmapbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -215,7 +215,7 @@ xfs_rmapbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
 
@@ -458,7 +458,7 @@ xfs_rmapbt_init_cursor(
 	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
@@ -569,7 +569,7 @@ xfs_rmapbt_calc_reserves(
 	if (error)
 		return error;
 
-	agf = XFS_BUF_TO_AGF(agbp);
+	agf = agbp->b_addr;
 	agblocks = be32_to_cpu(agf->agf_length);
 	tree_len = be32_to_cpu(agf->agf_rmap_blocks);
 	xfs_trans_brelse(tp, agbp);
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index a117e10feb82..163478855e7b 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -358,7 +358,7 @@ static inline void
 xchk_agf_xref_freeblks(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	xfs_extlen_t		blocks = 0;
 	int			error;
 
@@ -378,7 +378,7 @@ static inline void
 xchk_agf_xref_cntbt(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	xfs_agblock_t		agbno;
 	xfs_extlen_t		blocks;
 	int			have;
@@ -410,7 +410,7 @@ STATIC void
 xchk_agf_xref_btreeblks(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		blocks;
 	xfs_agblock_t		btreeblks;
@@ -456,7 +456,7 @@ static inline void
 xchk_agf_xref_refcblks(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	xfs_agblock_t		blocks;
 	int			error;
 
@@ -525,7 +525,7 @@ xchk_agf(
 		goto out;
 	xchk_buffer_recheck(sc, sc->sa.agf_bp);
 
-	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agf = sc->sa.agf_bp->b_addr;
 
 	/* Check the AG length */
 	eoag = be32_to_cpu(agf->agf_length);
@@ -711,7 +711,7 @@ xchk_agfl(
 		goto out;
 
 	/* Allocate buffer to ensure uniqueness of AGFL entries. */
-	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agf = sc->sa.agf_bp->b_addr;
 	agflcount = be32_to_cpu(agf->agf_flcount);
 	if (agflcount > xfs_agfl_size(sc->mp)) {
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
@@ -728,7 +728,7 @@ xchk_agfl(
 	}
 
 	/* Check the blocks in the AGFL. */
-	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
+	error = xfs_agfl_walk(sc->mp, sc->sa.agf_bp->b_addr,
 			sc->sa.agfl_bp, xchk_agfl_block, &sai);
 	if (error == -ECANCELED) {
 		error = 0;
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 6f0f5ff2cb3f..c801f5892210 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -140,7 +140,7 @@ xrep_agf_find_btrees(
 	struct xrep_find_ag_btree	*fab,
 	struct xfs_buf			*agfl_bp)
 {
-	struct xfs_agf			*old_agf = XFS_BUF_TO_AGF(agf_bp);
+	struct xfs_agf			*old_agf = agf_bp->b_addr;
 	int				error;
 
 	/* Go find the root data. */
@@ -181,7 +181,7 @@ xrep_agf_init_header(
 	struct xfs_agf		*old_agf)
 {
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agf_bp);
+	struct xfs_agf		*agf = agf_bp->b_addr;
 
 	memcpy(old_agf, agf, sizeof(*old_agf));
 	memset(agf, 0, BBTOB(agf_bp->b_length));
@@ -238,7 +238,7 @@ xrep_agf_calc_from_btrees(
 {
 	struct xrep_agf_allocbt	raa = { .sc = sc };
 	struct xfs_btree_cur	*cur = NULL;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agf_bp);
+	struct xfs_agf		*agf = agf_bp->b_addr;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		btreeblks;
 	xfs_agblock_t		blocks;
@@ -302,7 +302,7 @@ xrep_agf_commit_new(
 	struct xfs_buf		*agf_bp)
 {
 	struct xfs_perag	*pag;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agf_bp);
+	struct xfs_agf		*agf = agf_bp->b_addr;
 
 	/* Trigger fdblocks recalculation */
 	xfs_force_summary_recalc(sc->mp);
@@ -376,7 +376,7 @@ xrep_agf(
 	if (error)
 		return error;
 	agf_bp->b_ops = &xfs_agf_buf_ops;
-	agf = XFS_BUF_TO_AGF(agf_bp);
+	agf = agf_bp->b_addr;
 
 	/*
 	 * Load the AGFL so that we can screen out OWN_AG blocks that are on
@@ -395,7 +395,7 @@ xrep_agf(
 	 * Spot-check the AGFL blocks; if they're obviously corrupt then
 	 * there's nothing we can do but bail out.
 	 */
-	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(agf_bp), agfl_bp,
+	error = xfs_agfl_walk(sc->mp, agf_bp->b_addr, agfl_bp,
 			xrep_agf_check_agfl_block, sc);
 	if (error)
 		return error;
@@ -550,7 +550,7 @@ xrep_agfl_update_agf(
 	struct xfs_buf		*agf_bp,
 	xfs_agblock_t		flcount)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agf_bp);
+	struct xfs_agf		*agf = agf_bp->b_addr;
 
 	ASSERT(flcount <= xfs_agfl_size(sc->mp));
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index e489d7a8446a..0d5509bf8581 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -208,8 +208,10 @@ xrep_calc_ag_resblks(
 	/* Now grab the block counters from the AGF. */
 	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
 	if (!error) {
-		aglen = be32_to_cpu(XFS_BUF_TO_AGF(bp)->agf_length);
-		freelen = be32_to_cpu(XFS_BUF_TO_AGF(bp)->agf_freeblks);
+		struct xfs_agf	*agf = bp->b_addr;
+
+		aglen = be32_to_cpu(agf->agf_length);
+		freelen = be32_to_cpu(agf->agf_freeblks);
 		usedlen = aglen - freelen;
 		xfs_buf_relse(bp);
 	}
@@ -879,7 +881,7 @@ xrep_find_ag_btree_roots(
 
 	ri.sc = sc;
 	ri.btree_info = btree_info;
-	ri.agf = XFS_BUF_TO_AGF(agf_bp);
+	ri.agf = agf_bp->b_addr;
 	ri.agfl_bp = agfl_bp;
 	for (fab = btree_info; fab->buf_ops; fab++) {
 		ASSERT(agfl_bp || fab->rmap_owner != XFS_RMAP_OWN_AG);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 0b8350e84d28..f979d0d7e6cd 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -31,6 +31,7 @@ xfs_trim_extents(
 	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
+	struct xfs_agf		*agf;
 	struct xfs_perag	*pag;
 	int			error;
 	int			i;
@@ -47,14 +48,14 @@ xfs_trim_extents(
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
 	if (error)
 		goto out_put_perag;
+	agf = agbp->b_addr;
 
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
 
 	/*
 	 * Look up the longest btree in the AGF and start with it.
 	 */
-	error = xfs_alloc_lookup_ge(cur, 0,
-			    be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest), &i);
+	error = xfs_alloc_lookup_ge(cur, 0, be32_to_cpu(agf->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
 
@@ -75,7 +76,7 @@ xfs_trim_extents(
 			error = -EFSCORRUPTED;
 			goto out_del_cursor;
 		}
-		ASSERT(flen <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest));
+		ASSERT(flen <= be32_to_cpu(agf->agf_longest));
 
 		/*
 		 * use daddr format for all range/len calculations as that is
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 00d5df5fb26b..b6cf99f7153f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5809,7 +5809,6 @@ xlog_recover_check_summary(
 	struct xlog	*log)
 {
 	xfs_mount_t	*mp;
-	xfs_agf_t	*agfp;
 	xfs_buf_t	*agfbp;
 	xfs_buf_t	*agibp;
 	xfs_agnumber_t	agno;
@@ -5829,7 +5828,8 @@ xlog_recover_check_summary(
 			xfs_alert(mp, "%s agf read failed agno %d error %d",
 						__func__, agno, error);
 		} else {
-			agfp = XFS_BUF_TO_AGF(agfbp);
+			struct xfs_agf	*agfp = agfbp->b_addr;
+
 			freeblks += be32_to_cpu(agfp->agf_freeblks) +
 				    be32_to_cpu(agfp->agf_flcount);
 			xfs_buf_relse(agfbp);
-- 
2.24.1

