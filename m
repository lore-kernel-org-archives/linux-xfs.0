Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79A3C43381
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D50F223E8
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbhAKNZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 08:25:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731180AbhAKNZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 08:25:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610371436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MqfKg4j4L++6ruXjR8/liGk5w+wThWhjU4NhKwLT5m4=;
        b=WzQP9LLcNjDtQeXuOAwRh3Cedh0n1lT6wZypc7a424LytEbCIGmh/Vv7xzeKTV0PG0IMbv
        s9XEyqu+8msUU8W7DHQwg4TO327lP4mdkfarJwbd7hVRRzhyKFWVee9sLZV0NFscJjpaQK
        p8quI6v2Pt3fzFebL3yJ1LO2zeAg5qw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-gzmuTNBBNBKwvbYjW9DXnQ-1; Mon, 11 Jan 2021 08:23:55 -0500
X-MC-Unique: gzmuTNBBNBKwvbYjW9DXnQ-1
Received: by mail-pj1-f70.google.com with SMTP id g7so11200030pji.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 05:23:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MqfKg4j4L++6ruXjR8/liGk5w+wThWhjU4NhKwLT5m4=;
        b=PJdAhm81Gv32IFcBLZhDrqskp103zFA9w4HpXDSNvcIN6PsGzA3LvAB5Hfgx3RG9wC
         fvZ3ROfLkRqPOJQCtA474shlpWSTCkcd8RgChZ4C8yofh92Jc6y3FtmbY6bvimL3666p
         JDZOpxpXuGBP6D5w0j0fXZYKClrQcvypHycrbtzbDhnsKtFDH/G9fgavkoquenECt6fC
         W4vYMZXvUuzqm+Q+LtzwqxDKV9Hbs5tyXjLey1sE9ouYwC3PpndAnsS6l+C9AQWAHZHP
         EmwIyTwd3QRcBHqU3HITSCT1+ytodV2uZb9iNytWDSVcKayHLkY8l2qJVNOxqHWSHcpn
         iAtw==
X-Gm-Message-State: AOAM530YHWVKpHkKhtYlGTcDvxtbJw9VDBZpfNb3AEIm+oFtYfXjo7CO
        eizJLhou6+mxAt8d4sV4hD7TLtB9woo0gWPFKCb0r0ltGer2ZQhGfk4n/JHo6ll2XWqwFt9EuPU
        xjwKM3aLJbPKXhI60U95kY9b4e8oQuk6fMyQ88uJCo+zGpxm47hR6eEic3anNU8Z4fOKST547Jg
        ==
X-Received: by 2002:a17:902:6b87:b029:dc:3402:18af with SMTP id p7-20020a1709026b87b02900dc340218afmr9023819plk.29.1610371433867;
        Mon, 11 Jan 2021 05:23:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7jVycHU5RBztCmwsri0wCBi/0rQAa4YfL0nTnDam861WvPn/ceF/l7C0ynXhmDDXA5unH0A==
X-Received: by 2002:a17:902:6b87:b029:dc:3402:18af with SMTP id p7-20020a1709026b87b02900dc340218afmr9023790plk.29.1610371433516;
        Mon, 11 Jan 2021 05:23:53 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cu4sm16179355pjb.18.2021.01.11.05.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 05:23:53 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 4/4] xfs: support shrinking unused space in the last AG
Date:   Mon, 11 Jan 2021 21:22:43 +0800
Message-Id: <20210111132243.1180013-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210111132243.1180013-1-hsiangkao@redhat.com>
References: <20210111132243.1180013-1-hsiangkao@redhat.com>
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
 fs/xfs/libxfs/xfs_ag.c | 72 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |  2 ++
 fs/xfs/xfs_fsops.c     | 70 +++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_trans.c     |  1 -
 4 files changed, 125 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9331f3516afa..bec10c85e2a9 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -485,6 +485,78 @@ xfs_ag_init_headers(
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
+	int			error, err2;
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
+	if (error)
+		goto out;
+
+	if (args.agbno == NULLAGBLOCK) {
+		error = -ENOSPC;
+		goto out;
+	}
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
+
+out:
+	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
+	if (err2 && err2 != -ENOSPC) {
+		xfs_warn(mp,
+"Error %d reserving per-AG metadata reserve pool.", err2);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return err2;
+	}
+	return error;
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
index 8fde7a2989ce..6ee9ea4d5a67 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -26,7 +26,7 @@ xfs_resizefs_init_new_ags(
 	struct aghdr_init_data	*id,
 	xfs_agnumber_t		oagcount,
 	xfs_agnumber_t		nagcount,
-	xfs_rfsblock_t		*delta)
+	int64_t			*delta)
 {
 	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
 	int			error;
@@ -76,22 +76,28 @@ xfs_growfs_data_private(
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
@@ -99,10 +105,12 @@ xfs_growfs_data_private(
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
-		if (nb < mp->m_sb.sb_dblocks)
+		if (nagcount < 2)
 			return -EINVAL;
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
@@ -178,6 +206,10 @@ xfs_growfs_data_private(
 	return error;
 
 out_trans_cancel:
+	if (!extend && (tp->t_flags & XFS_TRANS_DIRTY)) {
+		xfs_trans_commit(tp);
+		return error;
+	}
 	xfs_trans_cancel(tp);
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

