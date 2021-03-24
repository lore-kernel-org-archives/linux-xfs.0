Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA41C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A47619F1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhCXBHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:07:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234227AbhCXBHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 21:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616548041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8d26PrDjEs+c1iStkdo3MCyggTrrQtC6w7bWrDJA2Fw=;
        b=LH2l7Xc2niccpNKAHIoKYjq4As7s1nWkjgW3hy5/H3sPOE/MgkdBnyK9nOEz2A7nGeaE8l
        y+8m9TZGjooZsgq9do3o90NS4lLI5loHQNMHvjiTkWOb/jadoYFfV/14LNrIGgRM1WHvCi
        CnZtiF42SzsiY4QP7G5ea2V/6YnPrFo=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-6EzwSAygPNS742My13kVnQ-1; Tue, 23 Mar 2021 21:07:20 -0400
X-MC-Unique: 6EzwSAygPNS742My13kVnQ-1
Received: by mail-pl1-f197.google.com with SMTP id l19so54927plc.14
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 18:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8d26PrDjEs+c1iStkdo3MCyggTrrQtC6w7bWrDJA2Fw=;
        b=mrVdWd/mb2/SVGcVBnSzsJb9h8juJps+/TzCAeDF/VRY9n0wi8J1oK0jmd+5xwLrWD
         B5uq/EKco0p83iIsrM8TxYDc10gbW1vZklw+HNjzJreSMNGobxTMP7NI3stDG8IX5QXq
         UPPcspA07Ot+x/8NMklJ0WMqKXDRqTi6dwhK6uUT9IvGUH9TevAxxREi+GLnw1fxC1JG
         ACIQnDOhOm/a7DSehxCNw1Qr8Zx8Aysb0OFcPkp4xwCt+i9DRibV2a8s3A5TjO+Sedv4
         SQ3PvxXNiZN5FP+Mxj7FCtjJrFKJzq4tQDlkdqeNH+Priz3UwRqrga5A9U2GOYtSP1Dh
         /WFw==
X-Gm-Message-State: AOAM531w1jI53XPbEf4Nynf6rZ2RJXHq8Ii+Xt/HxsltxjQKXXJnIsHp
        /NYGld6aTi+WDPq7C6keN3IbeCl480+/0G24+YdaTAlILW1RVGzLPljNuVpRcOE8vL7CjulkJK0
        C5uZGpzEbdtYNGZP51PibWmcx/JpQOCN0Tbz9NsbFV8iAAL+O+YrvUCpVuUQHHHF2grkKFwH2vw
        ==
X-Received: by 2002:a62:6413:0:b029:1f3:a5b4:d978 with SMTP id y19-20020a6264130000b02901f3a5b4d978mr859769pfb.44.1616548038806;
        Tue, 23 Mar 2021 18:07:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxj3zyymnuuyBajPuXsla9lJlaJouqnm5r+/jw0bp+2ElR3IzSseOcEMi5X5Kz9JJAmduUh2Q==
X-Received: by 2002:a62:6413:0:b029:1f3:a5b4:d978 with SMTP id y19-20020a6264130000b02901f3a5b4d978mr859745pfb.44.1616548038452;
        Tue, 23 Mar 2021 18:07:18 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t18sm379219pgg.33.2021.03.23.18.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:07:18 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v9 4/5] xfs: support shrinking unused space in the last AG
Date:   Wed, 24 Mar 2021 09:06:20 +0800
Message-Id: <20210324010621.2244671-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324010621.2244671-1-hsiangkao@redhat.com>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As the first step of shrinking, this attempts to enable shrinking
unused space in the last allocation group by fixing up freespace
btree, agi, agf and adjusting super block and use a helper
xfs_ag_shrink_space() to fixup the last AG.

This can be all done in one transaction for now, so I think no
additional protection is needed.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 84 +++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_trans.c |  1 -
 2 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index d1ba04124c28..9457b0691ece 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -91,23 +91,25 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
-	xfs_rfsblock_t		delta;
+	int64_t			delta;
 	bool			lastag_extended;
 	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 
 	nb = in->newblocks;
-	if (nb < mp->m_sb.sb_dblocks)
-		return -EINVAL;
-	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
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
@@ -115,10 +117,16 @@ xfs_growfs_data_private(
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
-		if (nb < mp->m_sb.sb_dblocks)
-			return -EINVAL;
 	}
 	delta = nb - mp->m_sb.sb_dblocks;
+	/*
+	 * Reject filesystems with a single AG because they are not
+	 * supported, and reject a shrink operation that would cause a
+	 * filesystem to become unsupported.
+	 */
+	if (delta < 0 && nagcount < 2)
+		return -EINVAL;
+
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
@@ -126,15 +134,22 @@ xfs_growfs_data_private(
 		error = xfs_initialize_perag(mp, nagcount, &nagimax);
 		if (error)
 			return error;
+	} else if (nagcount < oagcount) {
+		/* TODO: shrinking the entire AGs hasn't yet completed */
+		return -EINVAL;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
-			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
+			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
+			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 
-	error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
-					  delta, &lastag_extended);
+	if (delta > 0)
+		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
+						  delta, &lastag_extended);
+	else
+		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
 	if (error)
 		goto out_trans_cancel;
 
@@ -169,28 +184,29 @@ xfs_growfs_data_private(
 	xfs_set_low_space_thresholds(mp);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
-	/*
-	 * If we expanded the last AG, free the per-AG reservation
-	 * so we can reinitialize it with the new size.
-	 */
-	if (lastag_extended) {
-		struct xfs_perag	*pag;
-
-		pag = xfs_perag_get(mp, id.agno);
-		error = xfs_ag_resv_free(pag);
-		xfs_perag_put(pag);
-		if (error)
-			return error;
+	if (delta > 0) {
+		/*
+		 * If we expanded the last AG, free the per-AG reservation
+		 * so we can reinitialize it with the new size.
+		 */
+		if (lastag_extended) {
+			struct xfs_perag	*pag;
+
+			pag = xfs_perag_get(mp, id.agno);
+			error = xfs_ag_resv_free(pag);
+			xfs_perag_put(pag);
+			if (error)
+				return error;
+		}
+		/*
+		 * Reserve AG metadata blocks. ENOSPC here does not mean there
+		 * was a growfs failure, just that there still isn't space for
+		 * new user data after the grow has been run.
+		 */
+		error = xfs_fs_reserve_ag_blocks(mp);
+		if (error == -ENOSPC)
+			error = 0;
 	}
-
-	/*
-	 * Reserve AG metadata blocks. ENOSPC here does not mean there was a
-	 * growfs failure, just that there still isn't space for new user data
-	 * after the grow has been run.
-	 */
-	error = xfs_fs_reserve_ag_blocks(mp);
-	if (error == -ENOSPC)
-		error = 0;
 	return error;
 
 out_trans_cancel:
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b22a09e9daee..052274321993 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -436,7 +436,6 @@ xfs_trans_mod_sb(
 		tp->t_res_frextents_delta += delta;
 		break;
 	case XFS_TRANS_SB_DBLOCKS:
-		ASSERT(delta > 0);
 		tp->t_dblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-- 
2.27.0

