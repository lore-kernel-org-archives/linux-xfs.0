Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56620C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 00:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE13920EDD
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 00:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="JOFyKnkM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgJNA61 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 20:58:27 -0400
Received: from sonic305-21.consmr.mail.gq1.yahoo.com ([98.137.64.84]:35197
        "EHLO sonic305-21.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726974AbgJNA61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 20:58:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1602637105; bh=4YdoAvl2uC/TJ7Cjl5ow9Z4CBgBZFb5VyUsBro9dmEU=; h=From:To:Cc:Subject:Date:References:From:Subject; b=JOFyKnkMcv5b9eLOktrfeBUhivwPMxvinzo51hHIxet0A8/etmVGV+ua7kVFvXle2LgTlXu//VrwH6SGhw5+F99v3oK7I8L6BvuOVg11lhfvG4kRsr9V2VxDWOGYABfOmdcmlc9lK7Kop4HgiVxG2IRR4COvVEjz10BH/1FvWEJC8rWhk6k3KHi5fE8EjI1ZiBH3FZp2EXI/FRCi75++tteGBPHCyeqA9LCxdORHreuu0FN3NfUIv4ZzX3TFH5YPLkxyoCzLMsWSIqfzHKDsmeuNqTMuwm30y4IfMkXWbQV9nu0ihzaZWQD0NG9k5WRUxw38T6rsoRqofDuXSVf7gQ==
X-YMail-OSG: BTU_xqsVM1mM_22q7RTSRiCc5IbI4VKTS4ylbvCGe43jB.Xv7f4iAHCrTUI9APf
 PBTjB6Za9g2hb7P5gnfcQa1chGp70fngEmfASU5Q.jqZLrYIkmVIj5wotU3e8BuDQlgqJldBhqd3
 TuzkVaZUBBCJKU.mL33bR_OydSvG6He8FMsLEb7c5lggMd6x9DKNVBhkB3xePx7.wlXFBNGvWJnT
 yAv7uGZal9VWzmKREIbVYhV_qcJV2qMX4Y346QZ2zXwGXryLGQJVMTYx3UI4XwVeTTeBKyMFYLs9
 icWsUuninPjoLrukWmnDHnpIEVBgISE80WAOMHNq17aXxSG6NbpQmVaGRQqd5dTcAA3gl3BWOrtK
 RmlIkAyPJe.yJ0Khm5n5vj55hopMl.CIQWUrozAozTRtdhHyqQ14ux8AkwKnTcLVhK.rfATTQBVw
 AvtBGYcqTc8yv0bRu1m3_Ulp4pozzoHFJg8wNyi0hFqTQcYJ_XuOWBMGgL7eFWAe7dwlKHKjJ2.y
 lPaGs0LD3nP1VtL0if5HhICQiupbITEJK2YuoTJEE30EDn7rUfGH4K_8jry82yKa1qaV_EZ6mFV.
 cZRjFNaDmIjXVj8bs6wGzdBXaH_NrOoVO91d1J8tbKxtoNB5G9Ldtv1FNYYVBr6_h_vpkk5ui2xb
 HjwqtSvZIJbMWYePhV5n21puHa06CTtU.Z9neZwQ9jEASsvunL0Ay7686c44Gc1rB8hRVhbe0FfI
 LTmw2dOy8bkXZO9jSb70Qw..pTkI1PK28wAq40G0xKlO8k0af88vF5rKO87Dot_0SP8tAOfQKy2O
 xQFOw3ZdrCpLPSF3yWantjRr7Gedke9MZmtLQJM9bnxgxfOthmgBt8GlutVeLqq1EWbEZWnJP1bn
 npgO1g.2vT4j38mEHBmJe7EEh5KoT0V5KCdnydTT620qOVxl0WjwyBBbbpqbID_p72_R6qMJU_O0
 LWlY3EbPlpkSJ5L7ULc6AB5pf.4UfE0rKFMd5plpyeqj2P_Xx4jBoi8xj5kGKSxfBGyv7a1G1ta2
 zwnPw4FPYu3HXW4mQF2aQk09wzxhIzHMpHEC4EKbf3eBVf61RyTwkBvg6HfR9cbU8P7IrSu48x9T
 VKPmZh0yeYSF_UFlatNHyMNzcx5_PL_p4fZg8O0v8C4UenIihdVvSW16Vx7QMiy6w74tWXDwsQgR
 h5O4T02WPSt6WyiuZGe6NhFsPXvA3FfP7XbiboiBK218xcFDEn11ouM6.oxjus2yjl.QsiY2cZ3S
 ZNxkT5aB_LM_33BG2s80XkG7TtM4UQELewWWLB2knCU_wXkh8VWTqqFHUpGJQEjwkuIamX8ByDQ6
 5lXma3aFlrj7uoc.kj7D2.P1jnUyMG9h1w6FVzFjXvPSiLp3pVg3i_YEHGb1XqhHadSDn5sy_FHB
 ooGNaDkbgrzd8kUifxZU8WjZbanbXPoagOyyXVhRRzOQTsK6eXPug3bh32XMowN1vORs3UrvPxMW
 sDrMqQzdA73yk6MwjQkclPMNCDJZIwKfPV3RabK5FVrpRtBPkj88A.TgOPmvo508pQQ9O6UYNWRo
 F
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.gq1.yahoo.com with HTTP; Wed, 14 Oct 2020 00:58:25 +0000
Received: by smtp406.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 049eaeceefd6cf44f322c763c068d02a;
          Wed, 14 Oct 2020 00:58:21 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH] xfs: support shrinking unused space in the last AG
Date:   Wed, 14 Oct 2020 08:58:09 +0800
Message-Id: <20201014005809.6619-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

At the first step of shrinking, this attempts to enable shrinking
unused space in the last allocation group by fixing up freespace
btree, agi, agf and adjusting super block.

This can be all done in one transaction for now, so I think no
additional protection is needed.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---

Honestly, I've got headache about shrinking entire AGs
since the codebase doesn't expect agcount can be decreased
suddenly, I got some ideas from people but the modification
seems all over the codebase, I will keep on this at least
to learn more about XFS internals.

It might be worth sending out shrinking the last AG first
since users might need to shrink a little unused space
occasionally, yet I'm not quite sure the log space reservation
calculation in this patch and other details are correct.
I've done some manual test and it seems work. Yeah, as a
formal patch it needs more test to be done but I'd like
to hear more ideas about this first since I'm not quite
familiar with XFS for now and this topic involves a lot
new XFS-specific implementation details.

Kindly point out all strange places and what I'm missing
so I can revise it. It would be of great help for me to
learn more about XFS. At least just as a record on this
topic for further discussion.

Thanks,
Gao Xiang

 fs/xfs/libxfs/xfs_ag.c    | 46 ++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h    |  2 ++
 fs/xfs/libxfs/xfs_alloc.c | 55 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h | 10 +++++++
 fs/xfs/xfs_fsops.c        | 49 ++++++++++++++++++++++++----------
 fs/xfs/xfs_trans.c        |  1 -
 6 files changed, 148 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9331f3516afa..cac7b715e90b 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -485,6 +485,52 @@ xfs_ag_init_headers(
 	return error;
 }
 
+int
+xfs_ag_shrink_space(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct aghdr_init_data	*id,
+	xfs_extlen_t		len)
+{
+	struct xfs_buf		*agibp, *agfbp;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	int			error;
+
+	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
+	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
+	if (error)
+		return error;
+
+	agi = agibp->b_addr;
+
+	/* Cannot touch the log space */
+	if (is_log_ag(mp, id) &&
+	    XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart) +
+	    mp->m_sb.sb_logblocks > be32_to_cpu(agi->agi_length) - len)
+		return -EINVAL;
+
+	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
+	if (error)
+		return error;
+
+	error = xfs_alloc_vextent_shrink(tp, agfbp,
+			be32_to_cpu(agi->agi_length) - len, len);
+	if (error)
+		return error;
+
+	/* Change the agi length */
+	be32_add_cpu(&agi->agi_length, -len);
+	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
+
+	/* Change agf length */
+	agf = agfbp->b_addr;
+	be32_add_cpu(&agf->agf_length, -len);
+	ASSERT(agf->agf_length == agi->agi_length);
+	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
+	return 0;
+}
+
 /*
  * Extent the AG indicated by the @id by the length passed in
  */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 5166322807e7..f3b5bbfeadce 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -24,6 +24,8 @@ struct aghdr_init_data {
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
+int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans *tp,
+			struct aghdr_init_data *id, xfs_extlen_t len);
 int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
 			struct aghdr_init_data *id, xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 852b536551b5..681357bb2701 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1118,6 +1118,61 @@ xfs_alloc_ag_vextent_small(
 	return error;
 }
 
+/*
+ * Allocate an extent for shrinking the last allocation group
+ * to fix the freespace btree.
+ * agfl fix is avoided in order to keep from dirtying the
+ * transaction unnecessarily compared with xfs_alloc_vextent().
+ */
+int
+xfs_alloc_vextent_shrink(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agnumber_t		agno = agbp->b_pag->pag_agno;
+	struct xfs_alloc_arg	args = {
+		.tp = tp,
+		.mp = mp,
+		.type = XFS_ALLOCTYPE_THIS_BNO,
+		.agbp = agbp,
+		.agno = agno,
+		.agbno = agbno,
+		.fsbno = XFS_AGB_TO_FSB(mp, agno, agbno),
+		.minlen = len,
+		.maxlen = len,
+		.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE,
+		.resv = XFS_AG_RESV_NONE,
+		.prod = 1,
+		.alignment = 1,
+		.pag = agbp->b_pag
+	};
+	int			error;
+
+	error = xfs_alloc_ag_vextent_exact(&args);
+	if (error || args.agbno == NULLAGBLOCK)
+		return -EBUSY;
+
+	ASSERT(args.agbno == agbno);
+	ASSERT(args.len == len);
+	ASSERT(!args.wasfromfl || args.resv != XFS_AG_RESV_AGFL);
+
+	if (!args.wasfromfl) {
+		error = xfs_alloc_update_counters(tp, agbp, -(long)len);
+		if (error)
+			return error;
+
+		ASSERT(!xfs_extent_busy_search(mp, args.agno, agbno, args.len));
+	}
+	xfs_ag_resv_alloc_extent(args.pag, args.resv, &args);
+
+	XFS_STATS_INC(mp, xs_allocx);
+	XFS_STATS_ADD(mp, xs_allocb, args.len);
+	return 0;
+}
+
 /*
  * Allocate a variable extent in the allocation group agno.
  * Type and bno are used to determine where in the allocation group the
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6c22b12176b8..6080140bcb56 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -160,6 +160,16 @@ int				/* error */
 xfs_alloc_vextent(
 	xfs_alloc_arg_t	*args);	/* allocation argument structure */
 
+/*
+ * Allocate an extent for shrinking the last AG
+ */
+int
+xfs_alloc_vextent_shrink(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len);	/* length of extent */
+
 /*
  * Free an extent.
  */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ef1d5bb88b93..80927d323939 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -36,19 +36,21 @@ xfs_growfs_data_private(
 	xfs_rfsblock_t		new;
 	xfs_agnumber_t		oagcount;
 	xfs_trans_t		*tp;
+	bool			extend;
 	struct aghdr_init_data	id = {};
 
 	nb = in->newblocks;
-	if (nb < mp->m_sb.sb_dblocks)
-		return -EINVAL;
 	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
 		return error;
-	error = xfs_buf_read_uncached(mp->m_ddev_targp,
+
+	if (nb > mp->m_sb.sb_dblocks) {
+		error = xfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
 				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
-	if (error)
-		return error;
-	xfs_buf_relse(bp);
+		if (error)
+			return error;
+		xfs_buf_relse(bp);
+	}
 
 	new = nb;	/* use new as a temporary here */
 	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
@@ -56,10 +58,18 @@ xfs_growfs_data_private(
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
-		if (nb < mp->m_sb.sb_dblocks)
+		if (!nagcount)
 			return -EINVAL;
 	}
-	new = nb - mp->m_sb.sb_dblocks;
+
+	if (nb > mp->m_sb.sb_dblocks) {
+		new = nb - mp->m_sb.sb_dblocks;
+		extend = true;
+	} else {
+		new = mp->m_sb.sb_dblocks - nb;
+		extend = false;
+	}
+
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
@@ -67,10 +77,14 @@ xfs_growfs_data_private(
 		error = xfs_initialize_perag(mp, nagcount, &nagimax);
 		if (error)
 			return error;
+	} else if (nagcount != oagcount) {
+		/* TODO: shrinking a whole AG hasn't yet implemented */
+		return -EINVAL;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
-			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
+			(extend ? 0 : new) + XFS_GROWFS_SPACE_RES(mp), 0,
+			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 
@@ -103,15 +117,22 @@ xfs_growfs_data_private(
 			goto out_trans_cancel;
 		}
 	}
-	error = xfs_buf_delwri_submit(&id.buffer_list);
-	if (error)
-		goto out_trans_cancel;
+
+	if (!list_empty(&id.buffer_list)) {
+		error = xfs_buf_delwri_submit(&id.buffer_list);
+		if (error)
+			goto out_trans_cancel;
+	}
 
 	xfs_trans_agblocks_delta(tp, id.nfree);
 
 	/* If there are new blocks in the old last AG, extend it. */
 	if (new) {
-		error = xfs_ag_extend_space(mp, tp, &id, new);
+		if (extend)
+			error = xfs_ag_extend_space(mp, tp, &id, new);
+		else
+			error = xfs_ag_shrink_space(mp, tp, &id, new);
+
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -123,7 +144,7 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (nb > mp->m_sb.sb_dblocks)
+	if (nb != mp->m_sb.sb_dblocks)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
 				 nb - mp->m_sb.sb_dblocks);
 	if (id.nfree)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c94e71f741b6..81b9c32f9bef 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -419,7 +419,6 @@ xfs_trans_mod_sb(
 		tp->t_res_frextents_delta += delta;
 		break;
 	case XFS_TRANS_SB_DBLOCKS:
-		ASSERT(delta > 0);
 		tp->t_dblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-- 
2.24.0

