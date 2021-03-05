Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0755C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB9164F52
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhCEC6C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:58:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229528AbhCEC6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 21:58:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614913081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wkY3FTAIacYrwuPMXIJvXomIx2MVTrRPaR5z08syAQE=;
        b=RUJrWFRRYQl3EKLDy4Ydp7Yypclh/2PIuXJLsumHj4w1pjJso2meAp4vTAB6aae+MbT844
        tplXqBtuJ3/l5mQ+TF080z/ak+JvFCuDvJ4pdM0EDTrfIU2pyUueT8MnzxFL3XESA/8TFD
        SRjW4wD2U7LKhvppmCJu+YzXB9WiEs8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-3DQogZdkMK2CclYbdosclg-1; Thu, 04 Mar 2021 21:57:59 -0500
X-MC-Unique: 3DQogZdkMK2CclYbdosclg-1
Received: by mail-pj1-f69.google.com with SMTP id r18so436478pjz.1
        for <linux-xfs@vger.kernel.org>; Thu, 04 Mar 2021 18:57:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wkY3FTAIacYrwuPMXIJvXomIx2MVTrRPaR5z08syAQE=;
        b=UCh67uk5C7JDj8gJDHZt63hWRokVhAKSviktpFjoJCXQzbQeDLTgrs0Mp/o0Y6Gwh2
         Truh3C1AHf2uSDWGH9H6TXVB27u1YBlJHEKm/wqfJBsL6arCeT0NxBGJGiq+1TbW0cK4
         zfzgeWlNCLZm02IrzlnLkecc9INsiTBYATW/qZrjH220Vb2nq7tyyvD9Iwdxm20lb59l
         VsOEyT9Ns8UydeKlLWfoXZt6fvNuSy8XzrXGH0Xrys6GAeOpq4a33Adaa4kqanSh0xff
         fomgFaRnYKRPLqgJrGdVV/w6HUntbUJaarsSYMPb9yhR1seY73B2u9N5fzEWNyOQ2D6u
         l1xw==
X-Gm-Message-State: AOAM533eiVyuPFBME60z8u3b9s0WIxlZwqH3dtfFoDy5HCOyjZqjfcVD
        A5DuXrDPM7hNuKVi4Wg5F1qn/cllheobwWIQpLLMeISsBFebPuZadmMc3pdz1VZPJF9gbluXRZV
        TUms4cq6NvCcdP1ZWp4ORoKbLi+cx/5ujHzWe9rEnYvwv4ESNufqeND4e7HEHLVfvDURgxsrJ4w
        ==
X-Received: by 2002:a17:90b:1950:: with SMTP id nk16mr7774736pjb.140.1614913078279;
        Thu, 04 Mar 2021 18:57:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziHc/lr/M9mh0jIYW3SaN3UkEaOUulhUOpkb8Lqcb6nC/FlSfDEaNzbHiHiXQHEfcn/patYw==
X-Received: by 2002:a17:90b:1950:: with SMTP id nk16mr7774696pjb.140.1614913077830;
        Thu, 04 Mar 2021 18:57:57 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m19sm533414pjn.21.2021.03.04.18.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:57:57 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v8 4/5] xfs: support shrinking unused space in the last AG
Date:   Fri,  5 Mar 2021 10:57:02 +0800
Message-Id: <20210305025703.3069469-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305025703.3069469-1-hsiangkao@redhat.com>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
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
 fs/xfs/xfs_fsops.c | 88 ++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_trans.c |  1 -
 2 files changed, 53 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index fc9e799b2ae3..71cba61a451c 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -91,23 +91,28 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
-	xfs_rfsblock_t		delta;
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
@@ -115,10 +120,15 @@ xfs_growfs_data_private(
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
@@ -126,15 +136,22 @@ xfs_growfs_data_private(
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
 	if (error)
 		goto out_trans_cancel;
 
@@ -145,7 +162,7 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (delta > 0)
+	if (delta)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
@@ -169,28 +186,29 @@ xfs_growfs_data_private(
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

