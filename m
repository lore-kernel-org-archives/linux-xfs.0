Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C584FC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81271206F8
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387876AbhARIjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 03:39:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387863AbhARIjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 03:39:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610959088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3envSSRZYzU9hytgEjJuRSixnSNcyfdmD8FtxcTSV0=;
        b=UfvIeNUomvDX61m4lxTlWr67cS/LQkAnQWdEqw31eHPwTGbQGdptt8HyfiYF9274azMbpx
        DmK1AD8PyEDwVD/t0yTTZAPqVX/m5UKSVWXwu8R7G55bITwUZYaQLpMMJQt69/EtCPrIgy
        5wwp8/PK6DzA6ArxXNYgx/MA300BCBM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-rLS-qtWqPlyzekhtanlusA-1; Mon, 18 Jan 2021 03:38:07 -0500
X-MC-Unique: rLS-qtWqPlyzekhtanlusA-1
Received: by mail-pg1-f197.google.com with SMTP id n2so12750069pgj.12
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 00:38:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y3envSSRZYzU9hytgEjJuRSixnSNcyfdmD8FtxcTSV0=;
        b=V2ABP94Ks60pTDArVflF3ZIjtCHOzquif38L+tfgTZ38ZPaVXoddOxJE9cgWC2/DBK
         jsDGd8L7ZLwW8fP51LqMZdRl3pb3Gk1FWzX1R4ILO44dzvi+VtXNX+HReCTMHwvL2EF6
         4XomfThCbcV6ONVTsHow3qKM1+P6R5Zwq43DD2YaQyObfo9o5+Ne14YijpxA+Nx60Oqn
         thtqORBg3DZgRbZVijNMCyOzs0s6tBUvDrd8ZLF9u03JGz61ZfsT58um2wkOXPmxj1wX
         JNI6P/9J8sOe++6orqZrCarrZW3fs9Nj7NR3R44NmzoSbHQZ72BJYwVRz9iB/a2SkT12
         7jMQ==
X-Gm-Message-State: AOAM532r7hUrETfRO7PvKY6jiPngnqDPhteuLQZ0S+3XAQGv7pTDLZTv
        cqL5lVcw1JkwGPqBNypwatsz2ftce4yorBGCcXpsaZIDh78pBNcsFOyr+T37RnmuN8ETlT/Fhdr
        pl0GrdGCRUU9RGa0t0VYNublZUmChUxlqMRlqW+1Fwgp35n8etYpJnnQG48l0l8hrOYlYFQkkVg
        ==
X-Received: by 2002:aa7:95a4:0:b029:1a5:b7a4:9aa1 with SMTP id a4-20020aa795a40000b02901a5b7a49aa1mr24920793pfk.53.1610959085405;
        Mon, 18 Jan 2021 00:38:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJfyMgkb7rFWi4JDtQWCMBftyuZc0PQEBi/ba4yXHd6yTMgOm3GuHFJ9V8OIVg7sHgnUaMlA==
X-Received: by 2002:aa7:95a4:0:b029:1a5:b7a4:9aa1 with SMTP id a4-20020aa795a40000b02901a5b7a49aa1mr24920768pfk.53.1610959085025;
        Mon, 18 Jan 2021 00:38:05 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e5sm16293916pjs.0.2021.01.18.00.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 00:38:04 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 4/5] xfs: support shrinking unused space in the last AG
Date:   Mon, 18 Jan 2021 16:36:59 +0800
Message-Id: <20210118083700.2384277-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210118083700.2384277-1-hsiangkao@redhat.com>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As the first step of shrinking, this attempts to enable shrinking
unused space in the last allocation group by fixing up freespace
btree, agi, agf and adjusting super block and introduce a helper
xfs_ag_shrink_space() to fixup the last AG.

This can be all done in one transaction for now, so I think no
additional protection is needed.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c | 88 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |  2 +
 fs/xfs/xfs_fsops.c     | 77 ++++++++++++++++++++++++++----------
 fs/xfs/xfs_trans.c     |  1 -
 4 files changed, 146 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9331f3516afa..04a7c9b20470 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -22,6 +22,8 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
+#include "xfs_error.h"
+#include "xfs_bmap.h"
 
 static int
 xfs_get_aghdr_buf(
@@ -485,6 +487,92 @@ xfs_ag_init_headers(
 	return error;
 }
 
+int
+xfs_ag_shrink_space(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct aghdr_init_data	*id,
+	xfs_extlen_t		len)
+{
+	struct xfs_alloc_arg	args = {
+		.tp	= tp,
+		.mp	= mp,
+		.type	= XFS_ALLOCTYPE_THIS_BNO,
+		.minlen = len,
+		.maxlen = len,
+		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
+		.resv	= XFS_AG_RESV_NONE,
+		.prod	= 1
+	};
+	struct xfs_buf		*agibp, *agfbp;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	int			error, err2;
+
+	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
+	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
+	if (error)
+		return error;
+
+	agi = agibp->b_addr;
+
+	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
+	if (error)
+		return error;
+
+	agf = agfbp->b_addr;
+	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
+		return -EFSCORRUPTED;
+
+	args.fsbno = XFS_AGB_TO_FSB(mp, id->agno,
+				    be32_to_cpu(agi->agi_length) - len);
+
+	/* remove the preallocations before allocation and re-establish then */
+	error = xfs_ag_resv_free(agibp->b_pag);
+	if (error)
+		return error;
+
+	/* internal log shouldn't also show up in the free space btrees */
+	error = xfs_alloc_vextent(&args);
+	if (!error && args.agbno == NULLAGBLOCK)
+		error = -ENOSPC;
+
+	if (error) {
+		err2 = xfs_ag_resv_init(agibp->b_pag, tp);
+		if (err2)
+			goto resv_err;
+		return error;
+	}
+
+	/*
+	 * if successfully deleted from freespace btrees, need to confirm
+	 * per-AG reservation works as expected.
+	 */
+	be32_add_cpu(&agi->agi_length, -len);
+	be32_add_cpu(&agf->agf_length, -len);
+
+	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
+	if (err2) {
+		be32_add_cpu(&agi->agi_length, len);
+		be32_add_cpu(&agf->agf_length, len);
+		if (err2 != -ENOSPC)
+			goto resv_err;
+
+		__xfs_bmap_add_free(tp, args.fsbno, len,
+				    &XFS_RMAP_OINFO_SKIP_UPDATE, true);
+		return err2;
+	}
+	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
+	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
+	return 0;
+
+resv_err:
+	xfs_warn(mp,
+"Error %d reserving per-AG metadata reserve pool.", err2);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return err2;
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
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index db6ed354c465..2ae4f33b42c9 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -38,7 +38,7 @@ xfs_resizefs_init_new_ags(
 	struct aghdr_init_data	*id,
 	xfs_agnumber_t		oagcount,
 	xfs_agnumber_t		nagcount,
-	xfs_rfsblock_t		*delta)
+	int64_t			*delta)
 {
 	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
 	int			error;
@@ -76,33 +76,41 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
-	xfs_rfsblock_t		delta;
+	int64_t			delta;
 	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
+	bool			extend;
 	struct aghdr_init_data	id = {};
 
 	nb = in->newblocks;
-	if (nb < mp->m_sb.sb_dblocks)
-		return -EINVAL;
-	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
+	if (nb == mp->m_sb.sb_dblocks)
+		return 0;
+
+	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
+	if (error)
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
 
 	nb_div = nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
 	nagcount = nb_div + (nb_mod != 0);
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
-		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
-		if (nb < mp->m_sb.sb_dblocks)
+		if (nagcount < 2)
 			return -EINVAL;
+		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
 	}
+
 	delta = nb - mp->m_sb.sb_dblocks;
+	extend = (delta > 0);
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
@@ -110,22 +118,34 @@ xfs_growfs_data_private(
 		error = xfs_initialize_perag(mp, nagcount, &nagimax);
 		if (error)
 			return error;
+	} else if (nagcount != oagcount) {
+		/* TODO: shrinking the entire AGs hasn't yet completed */
+		return -EINVAL;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
-			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
+			(extend ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
+			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 
-	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
-	if (error)
-		goto out_trans_cancel;
-
+	if (extend) {
+		error = xfs_resizefs_init_new_ags(mp, &id, oagcount,
+						  nagcount, &delta);
+		if (error)
+			goto out_trans_cancel;
+	}
 	xfs_trans_agblocks_delta(tp, id.nfree);
 
-	/* If there are new blocks in the old last AG, extend it. */
+	/* If there are some blocks in the last AG, resize it. */
 	if (delta) {
-		error = xfs_ag_extend_space(mp, tp, &id, delta);
+		if (extend) {
+			error = xfs_ag_extend_space(mp, tp, &id, delta);
+		} else {
+			id.agno = nagcount - 1;
+			error = xfs_ag_shrink_space(mp, tp, &id, -delta);
+		}
+
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -137,11 +157,19 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (nb > mp->m_sb.sb_dblocks)
+	if (nb != mp->m_sb.sb_dblocks)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
 				 nb - mp->m_sb.sb_dblocks);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+
+	/*
+	 * update in-core counters (especially sb_fdblocks) now
+	 * so xfs_validate_sb_write() can pass.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		xfs_log_sb(tp);
+
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -157,7 +185,7 @@ xfs_growfs_data_private(
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
 	 */
-	if (delta) {
+	if (delta > 0) {
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, id.agno);
@@ -178,7 +206,14 @@ xfs_growfs_data_private(
 	return error;
 
 out_trans_cancel:
-	xfs_trans_cancel(tp);
+	/*
+	 * AGFL fixup can dirty the transaction, so it needs committing anyway.
+	 */
+	if (!extend && ((tp->t_flags & XFS_TRANS_DIRTY) ||
+			!list_empty(&tp->t_dfops)))
+		xfs_trans_commit(tp);
+	else
+		xfs_trans_cancel(tp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index e72730f85af1..fd2cbf414b80 100644
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
2.27.0

