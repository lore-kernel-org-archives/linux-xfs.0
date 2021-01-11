Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA22C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA0D21919
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbhAKNZK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 08:25:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730718AbhAKNZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 08:25:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610371423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FizVXYcr2F+sihFxuiWdzCHXvCwM5WHSqlJvIw9kkQE=;
        b=ABxbcVGeuCrBcO3XtsrY3p2BX1yTHIQUxMclzBnbEhCO65y8hMqF0y0OlN/R+SqJaE/jf2
        PVK2Db0DLgza9CEUlCieNOObxAVADoHZDqWOwYixe0koBqWs3ZYWGl2TVNwlBUX/2I6UC0
        7yJIl6VtuoWCjqSb9ltpxiqRHPLFDxg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-RNf2hqWgNBy2rNFW9Knu7A-1; Mon, 11 Jan 2021 08:23:41 -0500
X-MC-Unique: RNf2hqWgNBy2rNFW9Knu7A-1
Received: by mail-pl1-f200.google.com with SMTP id l11so9263162plt.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 05:23:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FizVXYcr2F+sihFxuiWdzCHXvCwM5WHSqlJvIw9kkQE=;
        b=eR4YFMWz5MM+EeVgiCSQEN0jwbzghJ6apxzzPgO4HoMeDv6RWkkuK9+lYx6ltm+WK7
         cqFxwQc7onTWh6ITrQLf65zTy7ues7sYO0QMx/98zgsc70SPQUgk9f0hPZF1H/X5RRox
         6T5Ye6FYkLRNt7oNQBoVtc+1PTRaXYFbY8rI+MvnrLK3PzX6tQ/AwIsU6wFbqwrIhdO3
         HS85lIGY/ADTYvOaUPCFyccMxeF2cju0Hf8c/pAfknx3UbEMkYM1zzCWBEDPGHFfw3LD
         o9FyvJ6+xA1UD2wz+ta39JtqrZeAkiEagBpB9HRVcuUhR6/6GuJwBZF9ho9tHtbTkaDc
         xEmw==
X-Gm-Message-State: AOAM531l1p/Noe+UKFTOh2/EB1IuW666AQkojYQxI223P3l0fXRuVo0T
        lyMhQy8uEeTIU2RnScYvLn3Xt7B9qXxjR3sqi8UZTLSGdlMLvTR6tgkVRjWJSo6lAq7jf/ruZaF
        W9XXrk4MUIxegXGg+lycv4DP2/wU0DnmptPQ1mD+GtW+x4npWXRCGplbi8s6n7NCXs/xc1xmF+w
        ==
X-Received: by 2002:a63:a506:: with SMTP id n6mr11187023pgf.397.1610371420495;
        Mon, 11 Jan 2021 05:23:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdibuXD3UXgdwrTGORJRa54QKF3hwqlqYXvTn3HxZw+XRqImgKXsNSIn3JU2aIAqhAp/BElA==
X-Received: by 2002:a63:a506:: with SMTP id n6mr11187000pgf.397.1610371420186;
        Mon, 11 Jan 2021 05:23:40 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cu4sm16179355pjb.18.2021.01.11.05.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 05:23:39 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 1/4] xfs: rename `new' to `delta' in xfs_growfs_data_private()
Date:   Mon, 11 Jan 2021 21:22:40 +0800
Message-Id: <20210111132243.1180013-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210111132243.1180013-1-hsiangkao@redhat.com>
References: <20210111132243.1180013-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It actually means the delta block count of growfs. Rename it in order
to make it clear. Also introduce nb_div to avoid reusing `delta`.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5870db855e8b..6ad31e6b4a04 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -32,8 +32,8 @@ xfs_growfs_data_private(
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
-	xfs_rfsblock_t		nb, nb_mod;
-	xfs_rfsblock_t		new;
+	xfs_rfsblock_t		nb, nb_div, nb_mod;
+	xfs_rfsblock_t		delta;
 	xfs_agnumber_t		oagcount;
 	xfs_trans_t		*tp;
 	struct aghdr_init_data	id = {};
@@ -50,16 +50,16 @@ xfs_growfs_data_private(
 		return error;
 	xfs_buf_relse(bp);
 
-	new = nb;	/* use new as a temporary here */
-	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
-	nagcount = new + (nb_mod != 0);
+	nb_div = nb;
+	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
+	nagcount = nb_div + (nb_mod != 0);
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
 		if (nb < mp->m_sb.sb_dblocks)
 			return -EINVAL;
 	}
-	new = nb - mp->m_sb.sb_dblocks;
+	delta = nb - mp->m_sb.sb_dblocks;
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
@@ -89,7 +89,7 @@ xfs_growfs_data_private(
 	INIT_LIST_HEAD(&id.buffer_list);
 	for (id.agno = nagcount - 1;
 	     id.agno >= oagcount;
-	     id.agno--, new -= id.agsize) {
+	     id.agno--, delta -= id.agsize) {
 
 		if (id.agno == nagcount - 1)
 			id.agsize = nb -
@@ -110,8 +110,8 @@ xfs_growfs_data_private(
 	xfs_trans_agblocks_delta(tp, id.nfree);
 
 	/* If there are new blocks in the old last AG, extend it. */
-	if (new) {
-		error = xfs_ag_extend_space(mp, tp, &id, new);
+	if (delta) {
+		error = xfs_ag_extend_space(mp, tp, &id, delta);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -143,7 +143,7 @@ xfs_growfs_data_private(
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
 	 */
-	if (new) {
+	if (delta) {
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, id.agno);
-- 
2.27.0

