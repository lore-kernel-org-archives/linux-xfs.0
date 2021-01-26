Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61949C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358D32310E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389576AbhAZNGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:06:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392478AbhAZM7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 07:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611665851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TR+YNMuonzDgGTUvLpD5UpS1io3STFRigW7QOJNlHg=;
        b=atr4uOzv0rKUuikWmPFIbqq9cZottvAv6TIsfO9E+41fsFRp9g4AHlU7/Z2jZSKYZlxU/O
        h4Ik2xxfl2KUFfNkNkhgVVEfcGbBRMUxRHb83nkRipwNF7Hi3l3waVdW3P9DKs9LraoOVB
        bkALShkYqPIflZJ8pkZKUzx+xrU6GWU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-zESZY5HTM0aJjL7JC00ibQ-1; Tue, 26 Jan 2021 07:57:30 -0500
X-MC-Unique: zESZY5HTM0aJjL7JC00ibQ-1
Received: by mail-pj1-f69.google.com with SMTP id t10so1851589pjw.4
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 04:57:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5TR+YNMuonzDgGTUvLpD5UpS1io3STFRigW7QOJNlHg=;
        b=cYmzBHmbKq44ETUTHWEVPciWsgoipqru4Ll5V/Dz73fG1oXOKoLubl1/y1D1MH1IE5
         Z6q1BapXCAZh7xMAlG/Dny8TU80ci8tnfJA5dUhtikZ2SY3BQ1UH9tHCmjlSt07crBGr
         b9kAHH0LndW1cSilCTu52EB3GKtnxLIsFo9O3BATEJW36KQpf8ZlppbizqqRYbCs9CYV
         IQmHsXwO1ck3ieco31lirls95FaB9c3vpzi8gja1UBpT7iFWOiGPYJ7BYnro4FCceRZu
         1VxJjCjNyIp9B8t/3jHdHMTlEcFT++ZS2oxlnN4/cZfYEND7M8Wt8gY/IWLQ/1zcznHP
         xvUA==
X-Gm-Message-State: AOAM53016VvlmvI7/tyjgvMV0+37Fg86YJhjQjN7P9YLrfmi68+hj0L0
        AqPyIwx0RED7zqJG26oFkuwQyloMet2hNQqlnSAEsznZyySfpkWds+/Dmd5f6q5v4jRiGKDVPDz
        3jQvXxPXh0uLSVry7QJbHaN1PT6MS3FJi1W7pT/aUQ5CoMp+nQOgKOfBIN8Fy5M3P14k7Lwwu6g
        ==
X-Received: by 2002:a17:90b:28d:: with SMTP id az13mr6318789pjb.55.1611665849023;
        Tue, 26 Jan 2021 04:57:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2dSJLYRMIIA8yJiXarVGz/9yG2B9tv3KFk3ACKgp5AfIauLKhYQcxVTMzMD65LdwvL0G4lQ==
X-Received: by 2002:a17:90b:28d:: with SMTP id az13mr6318767pjb.55.1611665848732;
        Tue, 26 Jan 2021 04:57:28 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b203sm19243174pfb.11.2021.01.26.04.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:57:28 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Date:   Tue, 26 Jan 2021 20:56:20 +0800
Message-Id: <20210126125621.3846735-7-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126125621.3846735-1-hsiangkao@redhat.com>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
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
 fs/xfs/xfs_fsops.c | 64 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_trans.c |  1 -
 2 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6c4ab5e31054..4bcea22f7b3f 100644
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
+	} else if (nagcount < oagcount) {
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
+			error = xfs_ag_shrink_space(mp, &tp, &id, -delta);
+		}
+
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -137,15 +157,15 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (nb > mp->m_sb.sb_dblocks)
+	if (nb != mp->m_sb.sb_dblocks)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
 				 nb - mp->m_sb.sb_dblocks);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
 
 	/*
-	 * update in-core counters now to reflect the real numbers
-	 * (especially sb_fdblocks)
+	 * update in-core counters now to reflect the real numbers (especially
+	 * sb_fdblocks). And xfs_validate_sb_write() can pass for shrinkfs.
 	 */
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
 		xfs_log_sb(tp);
@@ -165,7 +185,7 @@ xfs_growfs_data_private(
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
 	 */
-	if (delta) {
+	if (extend && delta) {
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, id.agno);
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

