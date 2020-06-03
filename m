Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE1CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 12:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A105C20678
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 12:12:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Th1jQrvI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgFCMMs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:12:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35990 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725833AbgFCMMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 08:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591186365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=FexqB2z52jptPBFpVngRcTNOdPiibRABXcP4fctQomM=;
        b=Th1jQrvIyxjN1hAHJAqryAQ0duzfCDuz59cPzNtmxwSkizMYuQniBTnOr4EoIFLUgIxlY7
        CCWSPuZ+vyIQVIvppk7WgrzrZdyT2VYgGXW1Bv9K7dMnOi/KI5ubDIGaxiCjPZTJS4d/yM
        8HHkwc1QKwnkHjO9Evwd1ig04l7Jtzc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-URofycKaP66ppf2udqZgVA-1; Wed, 03 Jun 2020 08:12:39 -0400
X-MC-Unique: URofycKaP66ppf2udqZgVA-1
Received: by mail-pl1-f198.google.com with SMTP id o1so1643424plk.22
        for <linux-xfs@vger.kernel.org>; Wed, 03 Jun 2020 05:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FexqB2z52jptPBFpVngRcTNOdPiibRABXcP4fctQomM=;
        b=KbhQFuibM9OK4fkuVnqB6hWSopxrJdfd/qcRd1BzRP5Z9gOuxJ2WM22+7KM50lXVv4
         An5WED9X+60a2r67Ma3foBxDq2vpv7E4z7MWPOKYbdD6IA87r3YRi9Dek0fR0TGfaSUF
         3tA5BJYjdsSnH4xIKiiU1t5XWBx6cNec02NlxBE6bndI/va3GdN1M15CUuAKsBnJAss1
         hfZJ/edzelZVGEeokhCOdYe2WmTIIc/0LSUIN2IEgOPKSEWPeM8I5A2ojdrMZNpUya1E
         q2/Eh24TDLmsqITSAlUam3GERo8P4sLODpjdSFQcFoe3C618NPD6d/L2SeM4Q9DWNesO
         gUfg==
X-Gm-Message-State: AOAM532mrBzk1AfUziVRHlV2ugqN21eectM94WiW4T3OjC/8sICc3gA/
        QiWhsWUIt+2SorlqwC6wVKL41tNNBil72QLL6bi89u86/jb/mNzVba1IW7htUfryaG1wTQax48C
        AVtbDRnHrC2/m64FjD1Bj
X-Received: by 2002:a17:90a:bf92:: with SMTP id d18mr5548530pjs.120.1591186357750;
        Wed, 03 Jun 2020 05:12:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCtGd7Fopru16zT9dLCFD68uDbQGAi/SeQ3n187lDmjzmrnxisNW6UNsDRXyVobE1rAvqSBQ==
X-Received: by 2002:a17:90a:bf92:: with SMTP id d18mr5548484pjs.120.1591186357335;
        Wed, 03 Jun 2020 05:12:37 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id np5sm2640811pjb.43.2020.06.03.05.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 05:12:36 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Date:   Wed,  3 Jun 2020 20:11:56 +0800
Message-Id: <20200603121156.3399-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200602145238.1512-1-hsiangkao@redhat.com>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In the course of some operations, we look up the perag from
the mount multiple times to get or change perag information.
These are often very short pieces of code, so while the
lookup cost is generally low, the cost of the lookup is far
higher than the cost of the operation we are doing on the
perag.

Since we changed buffers to hold references to the perag
they are cached in, many modification contexts already hold
active references to the perag that are held across these
operations. This is especially true for any operation that
is serialised by an allocation group header buffer.

In these cases, we can just use the buffer's reference to
the perag to avoid needing to do lookups to access the
perag. This means that many operations don't need to do
perag lookups at all to access the perag because they've
already looked up objects that own persistent references
and hence can use that reference instead.

Cc: Dave Chinner <dchinner@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v1:
 - update the commit message suggested by Dave;
 - fold in all corresponding ASSERTs I made;
 - apply another trivial case xfs_ag_resv_rmapbt_free as well.
   the counterpart xfs_ag_resv_rmapbt_alloc also needed by
   scrub, which seems some way indirect though (I didn't
   trace into that path).

 fs/xfs/libxfs/xfs_ag.c             |  5 ++--
 fs/xfs/libxfs/xfs_ag_resv.h        | 12 ---------
 fs/xfs/libxfs/xfs_alloc.c          | 27 +++++++++-----------
 fs/xfs/libxfs/xfs_alloc_btree.c    | 10 +++-----
 fs/xfs/libxfs/xfs_ialloc.c         | 34 ++++++++++---------------
 fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     | 11 ++++----
 fs/xfs/xfs_inode.c                 | 41 ++++++++++--------------------
 8 files changed, 54 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9d84007a5c65..4b8c7cb87b84 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -563,7 +563,9 @@ xfs_ag_get_geometry(
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
 	if (error)
 		goto out_agi;
-	pag = xfs_perag_get(mp, agno);
+
+	pag = agi_bp->b_pag;
+	ASSERT(pag->pag_agno == agno);
 
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
@@ -583,7 +585,6 @@ xfs_ag_get_geometry(
 	xfs_ag_geom_health(pag, ageo);
 
 	/* Release resources. */
-	xfs_perag_put(pag);
 	xfs_buf_relse(agf_bp);
 out_agi:
 	xfs_buf_relse(agi_bp);
diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index f3fd0ee9a7f7..8a8eb4bc48bb 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -37,16 +37,4 @@ xfs_ag_resv_rmapbt_alloc(
 	xfs_perag_put(pag);
 }
 
-static inline void
-xfs_ag_resv_rmapbt_free(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_perag	*pag;
-
-	pag = xfs_perag_get(mp, agno);
-	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
-	xfs_perag_put(pag);
-}
-
 #endif	/* __XFS_AG_RESV_H__ */
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 203e74fa64aa..df89279bbe1b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -710,13 +710,12 @@ xfs_alloc_read_agfl(
 STATIC int
 xfs_alloc_update_counters(
 	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
 	struct xfs_buf		*agbp,
 	long			len)
 {
 	struct xfs_agf		*agf = agbp->b_addr;
 
-	pag->pagf_freeblks += len;
+	agbp->b_pag->pagf_freeblks += len;
 	be32_add_cpu(&agf->agf_freeblks, len);
 
 	xfs_trans_agblocks_delta(tp, len);
@@ -1175,8 +1174,8 @@ xfs_alloc_ag_vextent(
 	}
 
 	if (!args->wasfromfl) {
-		error = xfs_alloc_update_counters(args->tp, args->pag,
-						  args->agbp,
+		ASSERT(args->pag == args->agbp->b_pag);
+		error = xfs_alloc_update_counters(args->tp, args->agbp,
 						  -((long)(args->len)));
 		if (error)
 			return error;
@@ -1887,7 +1886,6 @@ xfs_free_ag_extent(
 	enum xfs_ag_resv_type		type)
 {
 	struct xfs_mount		*mp;
-	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*bno_cur;
 	struct xfs_btree_cur		*cnt_cur;
 	xfs_agblock_t			gtbno; /* start of right neighbor */
@@ -2167,10 +2165,9 @@ xfs_free_ag_extent(
 	/*
 	 * Update the freespace totals in the ag and superblock.
 	 */
-	pag = xfs_perag_get(mp, agno);
-	error = xfs_alloc_update_counters(tp, pag, agbp, len);
-	xfs_ag_resv_free_extent(pag, type, tp, len);
-	xfs_perag_put(pag);
+	ASSERT(agno == agbp->b_pag->pag_agno);
+	error = xfs_alloc_update_counters(tp, agbp, len);
+	xfs_ag_resv_free_extent(agbp->b_pag, type, tp, len);
 	if (error)
 		goto error0;
 
@@ -2689,7 +2686,8 @@ xfs_alloc_get_freelist(
 	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
 		agf->agf_flfirst = 0;
 
-	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
+	pag = agbp->b_pag;
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
@@ -2701,7 +2699,6 @@ xfs_alloc_get_freelist(
 		pag->pagf_btreeblks++;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
@@ -2797,7 +2794,8 @@ xfs_alloc_put_freelist(
 	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
 		agf->agf_fllast = 0;
 
-	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
+	pag = agbp->b_pag;
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
@@ -2809,7 +2807,6 @@ xfs_alloc_put_freelist(
 		pag->pagf_btreeblks--;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
@@ -3006,7 +3003,8 @@ xfs_alloc_read_agf(
 	ASSERT(!(*bpp)->b_error);
 
 	agf = (*bpp)->b_addr;
-	pag = xfs_perag_get(mp, agno);
+	pag = (*bpp)->b_pag;
+	ASSERT(pag->pag_agno == agno);
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
@@ -3034,7 +3032,6 @@ xfs_alloc_read_agf(
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
 	}
 #endif
-	xfs_perag_put(pag);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 60c453cb3ee3..c1d276f791ea 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -38,16 +38,15 @@ xfs_allocbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
-	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+	struct xfs_perag	*pag = agbp->b_pag;
 
 	ASSERT(ptr->s != 0);
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	agf->agf_roots[btnum] = ptr->s;
 	be32_add_cpu(&agf->agf_levels[btnum], inc);
 	pag->pagf_levels[btnum] += inc;
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -115,7 +114,6 @@ xfs_allocbt_update_lastrec(
 	int			reason)
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
-	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	struct xfs_perag	*pag;
 	__be32			len;
 	int			numrecs;
@@ -160,9 +158,9 @@ xfs_allocbt_update_lastrec(
 	}
 
 	agf->agf_longest = len;
-	pag = xfs_perag_get(cur->bc_mp, seqno);
+	pag = cur->bc_ag.agbp->b_pag;
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 	pag->pagf_longest = be32_to_cpu(len);
-	xfs_perag_put(pag);
 	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7fcf62b324b0..53b156c9ec84 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -888,10 +888,10 @@ xfs_ialloc_ag_alloc(
 	 */
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
-	pag = xfs_perag_get(args.mp, agno);
+	pag = agbp->b_pag;
+	ASSERT(pag->pag_agno == agno);
 	pag->pagi_freecount += newlen;
 	pag->pagi_count += newlen;
-	xfs_perag_put(pag);
 	agi->agi_newino = cpu_to_be32(newino);
 
 	/*
@@ -1134,7 +1134,7 @@ xfs_dialloc_ag_inobt(
 	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agnumber_t		pagno = XFS_INO_TO_AGNO(mp, parent);
 	xfs_agino_t		pagino = XFS_INO_TO_AGINO(mp, parent);
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = agbp->b_pag;
 	struct xfs_btree_cur	*cur, *tcur;
 	struct xfs_inobt_rec_incore rec, trec;
 	xfs_ino_t		ino;
@@ -1143,8 +1143,7 @@ xfs_dialloc_ag_inobt(
 	int			i, j;
 	int			searchdistance = 10;
 
-	pag = xfs_perag_get(mp, agno);
-
+	ASSERT(pag->pag_agno == agno);
 	ASSERT(pag->pagi_init);
 	ASSERT(pag->pagi_inodeok);
 	ASSERT(pag->pagi_freecount > 0);
@@ -1384,14 +1383,12 @@ xfs_dialloc_ag_inobt(
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
-	xfs_perag_put(pag);
 	*inop = ino;
 	return 0;
 error1:
 	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
 error0:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_perag_put(pag);
 	return error;
 }
 
@@ -1587,7 +1584,6 @@ xfs_dialloc_ag(
 	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agnumber_t			pagno = XFS_INO_TO_AGNO(mp, parent);
 	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
-	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*cur;	/* finobt cursor */
 	struct xfs_btree_cur		*icur;	/* inobt cursor */
 	struct xfs_inobt_rec_incore	rec;
@@ -1599,8 +1595,6 @@ xfs_dialloc_ag(
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return xfs_dialloc_ag_inobt(tp, agbp, parent, inop);
 
-	pag = xfs_perag_get(mp, agno);
-
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1667,7 +1661,8 @@ xfs_dialloc_ag(
 	 */
 	be32_add_cpu(&agi->agi_freecount, -1);
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-	pag->pagi_freecount--;
+	ASSERT(agbp->b_pag->pag_agno == agno);
+	agbp->b_pag->pagi_freecount--;
 
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
 
@@ -1680,7 +1675,6 @@ xfs_dialloc_ag(
 
 	xfs_btree_del_cursor(icur, XFS_BTREE_NOERROR);
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-	xfs_perag_put(pag);
 	*inop = ino;
 	return 0;
 
@@ -1688,7 +1682,6 @@ xfs_dialloc_ag(
 	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
 error_cur:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_perag_put(pag);
 	return error;
 }
 
@@ -1945,7 +1938,6 @@ xfs_difree_inobt(
 {
 	struct xfs_agi			*agi = agbp->b_addr;
 	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
-	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				ilen;
@@ -2007,6 +1999,8 @@ xfs_difree_inobt(
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
 	    rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
+		struct xfs_perag	*pag = agbp->b_pag;
+
 		xic->deleted = true;
 		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
 		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
@@ -2020,10 +2014,9 @@ xfs_difree_inobt(
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
-		pag = xfs_perag_get(mp, agno);
+		ASSERT(pag->pag_agno == agno);
 		pag->pagi_freecount -= ilen - 1;
 		pag->pagi_count -= ilen;
-		xfs_perag_put(pag);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
@@ -2049,9 +2042,8 @@ xfs_difree_inobt(
 		 */
 		be32_add_cpu(&agi->agi_freecount, 1);
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-		pag = xfs_perag_get(mp, agno);
-		pag->pagi_freecount++;
-		xfs_perag_put(pag);
+		ASSERT(agbp->b_pag->pag_agno == agno);
+		agbp->b_pag->pagi_freecount++;
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
 	}
 
@@ -2661,7 +2653,8 @@ xfs_ialloc_read_agi(
 		return error;
 
 	agi = (*bpp)->b_addr;
-	pag = xfs_perag_get(mp, agno);
+	pag = (*bpp)->b_pag;
+	ASSERT(pag->pag_agno == agno);
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
@@ -2674,7 +2667,6 @@ xfs_ialloc_read_agi(
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
 		XFS_FORCED_SHUTDOWN(mp));
-	xfs_perag_put(pag);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 7fd6044a4f78..f445a8e2d04e 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -37,15 +37,14 @@ xfs_refcountbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
-	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+	struct xfs_perag	*pag = agbp->b_pag;
 
 	ASSERT(ptr->s != 0);
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	agf->agf_refcount_root = ptr->s;
 	be32_add_cpu(&agf->agf_refcount_level, inc);
 	pag->pagf_refcount_level += inc;
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp,
 			XFS_AGF_REFCOUNT_ROOT | XFS_AGF_REFCOUNT_LEVEL);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b7c05314d07c..be660b2fd422 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -63,16 +63,15 @@ xfs_rmapbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
-	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+	struct xfs_perag	*pag = agbp->b_pag;
 
 	ASSERT(ptr->s != 0);
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	agf->agf_roots[btnum] = ptr->s;
 	be32_add_cpu(&agf->agf_levels[btnum], inc);
 	pag->pagf_levels[btnum] += inc;
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -123,6 +122,7 @@ xfs_rmapbt_free_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_perag	*pag;
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -139,8 +139,9 @@ xfs_rmapbt_free_block(
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 
-	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_ag.agno);
-
+	pag = cur->bc_ag.agbp->b_pag;
+	ASSERT(pag->pag_agno == cur->bc_ag.agno);
+	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 64f5f9a440ae..bcc5a6eb6a50 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2248,7 +2248,6 @@ xfs_iunlink(
 	}
 
 	if (next_agino != NULLAGINO) {
-		struct xfs_perag	*pag;
 		xfs_agino_t		old_agino;
 
 		/*
@@ -2265,9 +2264,8 @@ xfs_iunlink(
 		 * agino has been unlinked, add a backref from the next inode
 		 * back to agino.
 		 */
-		pag = xfs_perag_get(mp, agno);
-		error = xfs_iunlink_add_backref(pag, agino, next_agino);
-		xfs_perag_put(pag);
+		ASSERT(agibp->b_pag->pag_agno == agno);
+		error = xfs_iunlink_add_backref(agibp->b_pag, agino, next_agino);
 		if (error)
 			return error;
 	}
@@ -2403,7 +2401,6 @@ xfs_iunlink_remove(
 	struct xfs_buf		*agibp;
 	struct xfs_buf		*last_ibp;
 	struct xfs_dinode	*last_dip = NULL;
-	struct xfs_perag	*pag = NULL;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
@@ -2447,32 +2444,24 @@ xfs_iunlink_remove(
 	 * this inode's backref to point from the next inode.
 	 */
 	if (next_agino != NULLAGINO) {
-		pag = xfs_perag_get(mp, agno);
-		error = xfs_iunlink_change_backref(pag, next_agino,
+		ASSERT(agibp->b_pag->pag_agno == agno);
+		error = xfs_iunlink_change_backref(agibp->b_pag, next_agino,
 				NULLAGINO);
 		if (error)
-			goto out;
+			return error;
 	}
 
-	if (head_agino == agino) {
-		/* Point the head of the list to the next unlinked inode. */
-		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
-				next_agino);
-		if (error)
-			goto out;
-	} else {
+	if (head_agino != agino) {
 		struct xfs_imap	imap;
 		xfs_agino_t	prev_agino;
 
-		if (!pag)
-			pag = xfs_perag_get(mp, agno);
-
+		ASSERT(agibp->b_pag->pag_agno == agno);
 		/* We need to search the list for the inode being freed. */
 		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
 				&prev_agino, &imap, &last_dip, &last_ibp,
-				pag);
+				agibp->b_pag);
 		if (error)
-			goto out;
+			return error;
 
 		/* Point the previous inode on the list to the next inode. */
 		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
@@ -2486,15 +2475,13 @@ xfs_iunlink_remove(
 		 * change_backref takes care of deleting the backref if
 		 * next_agino is NULLAGINO.
 		 */
-		error = xfs_iunlink_change_backref(pag, agino, next_agino);
-		if (error)
-			goto out;
+		return xfs_iunlink_change_backref(agibp->b_pag, agino,
+				next_agino);
 	}
 
-out:
-	if (pag)
-		xfs_perag_put(pag);
-	return error;
+	/* Point the head of the list to the next unlinked inode. */
+	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
+			next_agino);
 }
 
 /*
-- 
2.18.1

