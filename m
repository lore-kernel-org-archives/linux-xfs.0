Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D925C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B71DA64DE5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344150AbhCBGka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:40:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242610AbhCBCy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 21:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614653581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MraiXaE0u7RmLhSa50D+nQuOPjAXP6+wUb0BlyniFyI=;
        b=JcYDaUW8eCaXHNN8j2NRenM7FM8gFQGljL3Kvcwta/4wsuFr1o4afa4PD7pgfJip/k9Frq
        f+w6qdSUzjYnwgMB8n0yOzwXMXtpJlrMvKkY2DePVOrd+4k45LQlhNtnjQZaAvbK6YU3Ke
        6z1og1j6EJsL/0GwhVEHNl6ALp/SLeo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-vAlpE-PkNLawBVrLHcRJYA-1; Mon, 01 Mar 2021 21:49:28 -0500
X-MC-Unique: vAlpE-PkNLawBVrLHcRJYA-1
Received: by mail-pf1-f199.google.com with SMTP id e199so12515367pfh.11
        for <linux-xfs@vger.kernel.org>; Mon, 01 Mar 2021 18:49:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MraiXaE0u7RmLhSa50D+nQuOPjAXP6+wUb0BlyniFyI=;
        b=MPsDhFiyuRUtlfO1CvFXHm8fUFLkBo5YJ1swO65HZzorLsTjH8KGq3Mure+Egp9Ei/
         7KzZBSSKSQEvucd7UXm3GMbdpHgZV4/fPD3lla5ELF/YbSyMQ57ipC84KK11vW+ixFOq
         ZjvgskIaXQw95WVAhKTIysoiFMng3NRA+RxaqXT77IpWS5cgzpkN8Xg9JO1+ayE6bY6c
         ktA75+h5S8h2BNcnG7r1v01oYDNC3xn0cSl6FQJ9Ilh2srx2jkKbmj3AcVDzdYQYSyh9
         ev5nofnhicl+Nc/MZD2vlJc6UMVbf49cW4x0GVPe4de36sx/lva3v27hWTMm2Iha88Tx
         bLBA==
X-Gm-Message-State: AOAM5326XGVI5x6UoJrZD1SZLVcqHr8lHZo0lu6YYKIoMQSq//3vYqoZ
        zmabI4b0dSbcEqY3ePSXH4Hov8q0LozXcJbYn4X3GwnIN1U09Ie5jXjbYWdKMLpW7CfmuKbH3Uj
        R3F6xZbnxBTI7oX3e3pKriaA/K60DDLfmTBUMA0xX2WuYk96p4PRuc7W4G7+stm1pbm6ecUmayw
        ==
X-Received: by 2002:a17:90a:17ea:: with SMTP id q97mr2028245pja.71.1614653366822;
        Mon, 01 Mar 2021 18:49:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzo+UgwZcYYhLVCtDZ5f7bNhvT5kVv8kBWq1RrCXODzokIbZ+Bqmz2TPO8ArEhjjQhuad4lpQ==
X-Received: by 2002:a17:90a:17ea:: with SMTP id q97mr2028227pja.71.1614653366493;
        Mon, 01 Mar 2021 18:49:26 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d24sm18451031pfr.139.2021.03.01.18.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:49:26 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v7 4/5] xfs: support shrinking unused space in the last AG
Date:   Tue,  2 Mar 2021 10:48:15 +0800
Message-Id: <20210302024816.2525095-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210302024816.2525095-1-hsiangkao@redhat.com>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
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

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 90 ++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_trans.c |  1 -
 2 files changed, 55 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 494f9354e3fb..204c96d0010f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -90,23 +90,29 @@ xfs_growfs_data_private(
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
-	xfs_rfsblock_t		nb, nb_div, nb_mod, delta;
+	xfs_rfsblock_t		nb, nb_div, nb_mod;
+	int64_t			delta;
 	bool			lastag_resetagres;
 	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
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
@@ -114,10 +120,15 @@ xfs_growfs_data_private(
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
-		if (nb < mp->m_sb.sb_dblocks)
-			return -EINVAL;
 	}
 	delta = nb - mp->m_sb.sb_dblocks;
+	/*
+	 * XFS doesn't really support single-AG filesystems, so do not
+	 * permit callers to remove the filesystem's second and last AG.
+	 */
+	if (delta < 0 && nagcount < 2)
+		return -EINVAL;
+
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
@@ -125,15 +136,23 @@ xfs_growfs_data_private(
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
-					  delta, &lastag_resetagres);
+	if (delta > 0)
+		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
+						  delta, &lastag_resetagres);
+	else
+		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
+
 	if (error)
 		goto out_trans_cancel;
 
@@ -144,7 +163,7 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (delta > 0)
+	if (delta)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
@@ -168,28 +187,29 @@ xfs_growfs_data_private(
 	xfs_set_low_space_thresholds(mp);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
-	/*
-	 * If we expanded the last AG, free the per-AG reservation
-	 * so we can reinitialize it with the new size.
-	 */
-	if (lastag_resetagres) {
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
+		if (lastag_resetagres) {
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
index 44f72c09c203..d047f5f26cc0 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -434,7 +434,6 @@ xfs_trans_mod_sb(
 		tp->t_res_frextents_delta += delta;
 		break;
 	case XFS_TRANS_SB_DBLOCKS:
-		ASSERT(delta > 0);
 		tp->t_dblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-- 
2.27.0

