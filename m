Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2C5C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60E182083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AWN6omoz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEGMUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgEGMUH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6702C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JzwOYqiCiAdAppaUytF8HmZvxnXqlJI21EUdU/ZUc0w=; b=AWN6omozJ8ADBI9yMhp7M6dR/v
        R3yy0umd5bn/y6YIVEe7KWsHixU8+WJoRd2m0dTlj3i2dOkd1E+2UnvqAqCiJVl1aAO8FZVKFplOU
        NJ1V30bedS8GVtVZZHQXRQgbuklnlvY6A0cs9yCZ/x2DAx96WCc4y2ksbJCSagvM/sQnRHnP5BmzR
        BTS0SApFrqGcC/68o9yw2JpPyD0KvtCzUlEtPgNsNNl34wEnrLFSJorjsz//RfQsZpBhUkfIXJ5Lo
        gEuHUWP31mP1G8IY0m/aBbDhBkuA6EzhJ+K370BI9Hy3d3j5BD2+OPgxe7LGOWhK3LSsLfCw7qst3
        JwH5B/Ig==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVX-00066F-4G; Thu, 07 May 2020 12:20:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 30/58] xfs: remove XFS_BUF_TO_AGF
Date:   Thu,  7 May 2020 14:18:23 +0200
Message-Id: <20200507121851.304002-31-hch@lst.de>
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

Source kernel commit: 9798f615ad2be48466a01c44ad2257ba64ab03bd

Just dereference bp->b_addr directly and make the code a little
simpler and more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/info.c                   |  2 +-
 include/xfs.h               |  4 +++
 libxfs/xfs_ag.c             |  6 ++---
 libxfs/xfs_alloc.c          | 52 ++++++++++++++++---------------------
 libxfs/xfs_alloc_btree.c    | 10 +++----
 libxfs/xfs_format.h         |  1 -
 libxfs/xfs_refcount_btree.c | 12 ++++-----
 libxfs/xfs_rmap_btree.c     | 12 ++++-----
 repair/phase5.c             |  2 +-
 repair/scan.c               |  2 +-
 10 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/db/info.c b/db/info.c
index 5c941dc4..2731446d 100644
--- a/db/info.c
+++ b/db/info.c
@@ -85,7 +85,7 @@ print_agresv_info(
 	error = -libxfs_read_agf(mp, NULL, agno, 0, &bp);
 	if (error)
 		xfrog_perror(error, "AGF");
-	agf = XFS_BUF_TO_AGF(bp);
+	agf = bp->b_addr;
 	length = be32_to_cpu(agf->agf_length);
 	free = be32_to_cpu(agf->agf_freeblks) +
 	       be32_to_cpu(agf->agf_flcount);
diff --git a/include/xfs.h b/include/xfs.h
index f2f675df..f673d92e 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -30,6 +30,10 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 #define __packed __attribute__((packed))
 #endif
 
+#ifndef __maybe_unused
+#define __maybe_unused __attribute__((__unused__))
+#endif
+
 #ifndef BUILD_BUG_ON
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #endif
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 375eeeae..c6160df7 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
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
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 268776f2..b3abab49 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -710,7 +710,7 @@ xfs_alloc_update_counters(
 	struct xfs_buf		*agbp,
 	long			len)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 
 	pag->pagf_freeblks += len;
 	be32_add_cpu(&agf->agf_freeblks, len);
@@ -919,13 +919,13 @@ xfs_alloc_cur_finish(
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
@@ -1023,6 +1023,7 @@ xfs_alloc_ag_vextent_small(
 	xfs_extlen_t		*flenp,	/* result length */
 	int			*stat)	/* status: 0-freelist, 1-normal/none */
 {
+	struct xfs_agf		*agf = args->agbp->b_addr;
 	int			error = 0;
 	xfs_agblock_t		fbno = NULLAGBLOCK;
 	xfs_extlen_t		flen = 0;
@@ -1051,8 +1052,7 @@ xfs_alloc_ag_vextent_small(
 
 	if (args->minlen != 1 || args->alignment != 1 ||
 	    args->resv == XFS_AG_RESV_AGFL ||
-	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
-	     args->minleft))
+	    be32_to_cpu(agf->agf_flcount) <= args->minleft)
 		goto out;
 
 	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
@@ -1076,9 +1076,7 @@ xfs_alloc_ag_vextent_small(
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
@@ -1200,6 +1198,7 @@ STATIC int			/* error */
 xfs_alloc_ag_vextent_exact(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
+	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
 	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
 	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
 	int		error;
@@ -1278,8 +1277,7 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
-	ASSERT(args->agbno + args->len <=
-		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
 	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
 				      args->len, XFSA_FIXUP_BNO_OK);
 	if (error) {
@@ -1658,6 +1656,7 @@ STATIC int				/* error */
 xfs_alloc_ag_vextent_size(
 	xfs_alloc_arg_t	*args)		/* allocation argument structure */
 {
+	struct xfs_agf	*agf = args->agbp->b_addr;
 	xfs_btree_cur_t	*bno_cur;	/* cursor for bno btree */
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for cnt btree */
 	int		error;		/* error result */
@@ -1848,8 +1847,7 @@ restart:
 	args->agbno = rbno;
 	if (XFS_IS_CORRUPT(args->mp,
 			   args->agbno + args->len >
-			   be32_to_cpu(
-				   XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+			   be32_to_cpu(agf->agf_length))) {
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -2421,7 +2419,7 @@ xfs_agfl_reset(
 	struct xfs_perag	*pag)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 
 	ASSERT(pag->pagf_agflreset);
 	trace_xfs_agfl_reset(mp, agf, 0, _RET_IP_);
@@ -2652,7 +2650,7 @@ xfs_alloc_get_freelist(
 	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
 	int		btreeblk) /* destination is a AGF btree */
 {
-	xfs_agf_t	*agf;	/* a.g. freespace structure */
+	struct xfs_agf	*agf = agbp->b_addr;
 	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	__be32		*agfl_bno;
@@ -2664,7 +2662,6 @@ xfs_alloc_get_freelist(
 	/*
 	 * Freelist is empty, give up.
 	 */
-	agf = XFS_BUF_TO_AGF(agbp);
 	if (!agf->agf_flcount) {
 		*bnop = NULLAGBLOCK;
 		return 0;
@@ -2742,7 +2739,7 @@ xfs_alloc_log_agf(
 		sizeof(xfs_agf_t)
 	};
 
-	trace_xfs_agf(tp->t_mountp, XFS_BUF_TO_AGF(bp), fields, _RET_IP_);
+	trace_xfs_agf(tp->t_mountp, bp->b_addr, fields, _RET_IP_);
 
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGF_BUF);
 
@@ -2780,18 +2777,15 @@ xfs_alloc_put_freelist(
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
@@ -2835,13 +2829,12 @@ xfs_agf_verify(
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
 
@@ -2927,6 +2920,7 @@ xfs_agf_write_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_agf		*agf = bp->b_addr;
 	xfs_failaddr_t		fa;
 
 	fa = xfs_agf_verify(bp);
@@ -2939,7 +2933,7 @@ xfs_agf_write_verify(
 		return;
 
 	if (bip)
-		XFS_BUF_TO_AGF(bp)->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+		agf->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
 	xfs_buf_update_cksum(bp, XFS_AGF_CRC_OFF);
 }
@@ -3007,7 +3001,7 @@ xfs_alloc_read_agf(
 		return error;
 	ASSERT(!(*bpp)->b_error);
 
-	agf = XFS_BUF_TO_AGF(*bpp);
+	agf = (*bpp)->b_addr;
 	pag = xfs_perag_get(mp, agno);
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
@@ -3288,6 +3282,7 @@ __xfs_free_extent(
 	struct xfs_buf			*agbp;
 	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp, bno);
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	struct xfs_agf			*agf;
 	int				error;
 	unsigned int			busy_flags = 0;
 
@@ -3301,6 +3296,7 @@ __xfs_free_extent(
 	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
 	if (error)
 		return error;
+	agf = agbp->b_addr;
 
 	if (XFS_IS_CORRUPT(mp, agbno >= mp->m_sb.sb_agblocks)) {
 		error = -EFSCORRUPTED;
@@ -3308,9 +3304,7 @@ __xfs_free_extent(
 	}
 
 	/* validate the extent size is legal now we have the agf locked */
-	if (XFS_IS_CORRUPT(mp,
-			   agbno + len >
-			   be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length))) {
+	if (XFS_IS_CORRUPT(mp, agbno + len > be32_to_cpu(agf->agf_length))) {
 		error = -EFSCORRUPTED;
 		goto err;
 	}
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 57327deb..337db214 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -34,7 +34,7 @@ xfs_allocbt_set_root(
 	int			inc)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
 	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
@@ -85,7 +85,7 @@ xfs_allocbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -111,7 +111,7 @@ xfs_allocbt_update_lastrec(
 	int			ptr,
 	int			reason)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	struct xfs_perag	*pag;
 	__be32			len;
@@ -224,7 +224,7 @@ xfs_allocbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
 
@@ -480,7 +480,7 @@ xfs_allocbt_init_cursor(
 	xfs_agnumber_t		agno,		/* allocation group number */
 	xfs_btnum_t		btnum)		/* btree identifier */
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index dbcd8b27..1fec1302 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -707,7 +707,6 @@ typedef struct xfs_agf {
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
-#define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)((bp)->b_addr))
 
 /*
  * Size of the unlinked inode hash table in the agi.
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index c1561325..75c60aac 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -34,7 +34,7 @@ xfs_refcountbt_set_root(
 	int			inc)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
 
@@ -57,7 +57,7 @@ xfs_refcountbt_alloc_block(
 	int			*stat)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_alloc_arg	args;		/* block allocation args */
 	int			error;		/* error return value */
 
@@ -101,7 +101,7 @@ xfs_refcountbt_free_block(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	int			error;
 
@@ -168,7 +168,7 @@ xfs_refcountbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
 
@@ -319,7 +319,7 @@ xfs_refcountbt_init_cursor(
 	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(agno != NULLAGNUMBER);
@@ -419,7 +419,7 @@ xfs_refcountbt_calc_reserves(
 	if (error)
 		return error;
 
-	agf = XFS_BUF_TO_AGF(agbp);
+	agf = agbp->b_addr;
 	agblocks = be32_to_cpu(agf->agf_length);
 	tree_len = be32_to_cpu(agf->agf_refcount_blocks);
 	xfs_trans_brelse(tp, agbp);
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 95b1c204..87503247 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -59,7 +59,7 @@ xfs_rmapbt_set_root(
 	int			inc)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
 	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
@@ -82,7 +82,7 @@ xfs_rmapbt_alloc_block(
 	int			*stat)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	int			error;
 	xfs_agblock_t		bno;
 
@@ -119,7 +119,7 @@ xfs_rmapbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -213,7 +213,7 @@ xfs_rmapbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
 
@@ -456,7 +456,7 @@ xfs_rmapbt_init_cursor(
 	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
@@ -567,7 +567,7 @@ xfs_rmapbt_calc_reserves(
 	if (error)
 		return error;
 
-	agf = XFS_BUF_TO_AGF(agbp);
+	agf = agbp->b_addr;
 	agblocks = be32_to_cpu(agf->agf_length);
 	tree_len = be32_to_cpu(agf->agf_rmap_blocks);
 	xfs_trans_brelse(tp, agbp);
diff --git a/repair/phase5.c b/repair/phase5.c
index f41e9716..fd7659dc 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2070,7 +2070,7 @@ build_agf_agfl(
 		do_error(_("Cannot grab AG %u AGF buffer, err=%d"),
 				agno, error);
 	agf_buf->b_ops = &xfs_agf_buf_ops;
-	agf = XFS_BUF_TO_AGF(agf_buf);
+	agf = agf_buf->b_addr;
 	memset(agf, 0, mp->m_sb.sb_sectsize);
 
 #ifdef XR_BLD_FREE_TRACE
diff --git a/repair/scan.c b/repair/scan.c
index 32937ada..e40ce194 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2384,7 +2384,7 @@ scan_ag(
 		objname = _("agf block");
 		goto out_free_sbbuf;
 	}
-	agf = XFS_BUF_TO_AGF(agfbuf);
+	agf = agfbuf->b_addr;
 
 	error = salvage_buffer(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-- 
2.26.2

