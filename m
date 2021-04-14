Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE98C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C3661153
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353524AbhDNTxv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 15:53:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353523AbhDNTxt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 15:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618430007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qR6fSKF4jbqhXgpR/YinlnBP8rdJxsr6LZEc5Z+dtrY=;
        b=M5+RB83ClC8N++ad33+BvCGIDoTpgfmZeZyek0TqfAYoCGj/IkZvSe6o3kCzu2Ma44KVoT
        DxW1522w3vK9VLaQixrs6MmPJropcAe51+i4GvfZlgm7FZBY/oRgmpWTSQf3nCANww7ia6
        zdRO2VTmZFBL3H8Qb0qB2deQkstS2pA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-e9EcgnYPM1uTEmvzi2xdNw-1; Wed, 14 Apr 2021 15:53:25 -0400
X-MC-Unique: e9EcgnYPM1uTEmvzi2xdNw-1
Received: by mail-pl1-f200.google.com with SMTP id v15-20020a170902d68fb02900e981de9bebso7500793ply.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 12:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qR6fSKF4jbqhXgpR/YinlnBP8rdJxsr6LZEc5Z+dtrY=;
        b=qIdcLlmmvz0QKXc7gWJHrVWoa8GZpiy83bZlbZ1aUFUoeIdMqz/xcEX8S50b8fmOhZ
         MJ/jq24/Oxxsf/PLMLTp6BDYznDR5RyCPBXTHfc3uG2hg5wwFMsTTaGVJ5JsaWbetRB1
         gsTH3rFSrTyH5ARAndrmikoqCgAdAIud4ATwlcpoXbSGYx4MQ35R6OFieS9q94MMmRJg
         RDe+PErfBsl1M4WJyykBvRPADAgCImOG0lKgusWlIFrp9nyxeD8mMGDzRX3FLc5fU/Bj
         VlSTR3WHI8f+yT9fdFPcvG7tuWksSCOD4eG0hL1fMvaiOC/cLIKHlBrRY/Udx8uHC91L
         Skdg==
X-Gm-Message-State: AOAM533l57qXokomGoKHBBt+MoEG4oI8crPVPLIWkTSkAIOZgV+TRbFk
        Qtx6KCJNTZag5DWNHWPNPM3xrlKYWFNvM+gzdSrRvJrVtatl3/gKbK2klYj5A1K2IZ1h3qIBhfp
        nsWYymc1G0PN0MUiUO7Q8KL/yfkO+zix+kTnX7cwXsdiJBaldfXzi6HSRlYNdBWizbSGbHs2nTg
        ==
X-Received: by 2002:a17:90a:c209:: with SMTP id e9mr5352422pjt.104.1618430004537;
        Wed, 14 Apr 2021 12:53:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEh/2amF+8rs/oiiL7UP2cXcIWu3u2+mPCzcyk+4AwCKxBKB/zrjZKAlyO/nJ6zdhqW2ak0w==
X-Received: by 2002:a17:90a:c209:: with SMTP id e9mr5352408pjt.104.1618430004303;
        Wed, 14 Apr 2021 12:53:24 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm215787pjm.0.2021.04.14.12.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:53:24 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH 2/4] xfs: check ag is empty
Date:   Thu, 15 Apr 2021 03:52:38 +0800
Message-Id: <20210414195240.1802221-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210414195240.1802221-1-hsiangkao@redhat.com>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After a perag is stableized as inactive, we could check if such ag
is empty. In order to achieve that, AGFL is also needed to be
emptified in advance to make sure that only one freespace extent
will exist here.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 97 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h |  4 ++
 2 files changed, 101 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 01d4e4d4c1d6..60a8c134c00e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2474,6 +2474,103 @@ xfs_defer_agfl_block(
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
 }
 
+int
+xfs_ag_emptify_agfl(
+	struct xfs_buf		*agfbp)
+{
+	struct xfs_mount	*mp = agfbp->b_mount;
+	struct xfs_perag	*pag = agfbp->b_pag;
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_owner_info	oinfo = XFS_RMAP_OINFO_AG;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, 0, 0,
+				XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
+
+	/* attach to the transaction and keep it from unlocked */
+	xfs_trans_bjoin(tp, agfbp);
+	xfs_trans_bhold(tp, agfbp);
+
+	while (pag->pagf_flcount) {
+		xfs_agblock_t	bno;
+		int		error;
+
+		error = xfs_alloc_get_freelist(tp, agfbp, &bno, 0);
+		if (error)
+			break;
+
+		ASSERT(bno != NULLAGBLOCK);
+		xfs_defer_agfl_block(tp, pag->pag_agno, bno, &oinfo);
+	}
+	xfs_trans_set_sync(tp);
+	xfs_trans_commit(tp);
+	return error;
+}
+
+int
+xfs_ag_is_empty(
+	struct xfs_buf		*agfbp)
+{
+	struct xfs_mount	*mp = agfbp->b_mount;
+	struct xfs_perag	*pag = agfbp->b_pag;
+	struct xfs_agf		*agf = agfbp->b_addr;
+	struct xfs_btree_cur	*cnt_cur;
+	xfs_agblock_t		nfbno;
+	xfs_extlen_t		nflen;
+	int			error, i;
+
+	if (!pag->pag_inactive)
+		return -EINVAL;
+
+	if (pag->pagf_freeblks + pag->pagf_flcount !=
+	    be32_to_cpu(agf->agf_length) - mp->m_ag_prealloc_blocks)
+		return -ENOTEMPTY;
+
+	if (pag->pagf_flcount) {
+		error = xfs_ag_emptify_agfl(agfbp);
+		if (error)
+			return error;
+
+		if (pag->pagf_freeblks !=
+		    be32_to_cpu(agf->agf_length) - mp->m_ag_prealloc_blocks)
+			return -ENOTEMPTY;
+	}
+
+	if (pag->pagi_count > 0 || pag->pagi_freecount > 0)
+		return -ENOTEMPTY;
+
+	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > 1 ||
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > 1)
+		return -ENOTEMPTY;
+
+	cnt_cur = xfs_allocbt_init_cursor(mp, NULL, agfbp,
+					  pag->pag_agno, XFS_BTNUM_CNT);
+	ASSERT(cnt_cur->bc_nlevels == 1);
+	error = xfs_alloc_lookup_ge(cnt_cur, 0,
+				    be32_to_cpu(agf->agf_longest), &i);
+	if (error || !i)
+		goto out;
+
+	error = xfs_alloc_get_rec(cnt_cur, &nfbno, &nflen, &i);
+	if (error)
+		goto out;
+
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	error = -ENOTEMPTY;
+	if (nfbno == mp->m_ag_prealloc_blocks &&
+	    nflen == pag->pagf_freeblks)
+		error = 0;
+out:
+	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+	return error;
+}
+
 #ifdef DEBUG
 /*
  * Check if an AGF has a free extent record whose length is equal to
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a4427c5775c2..a7015b971075 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -156,6 +156,10 @@ xfs_alloc_read_agf(
 	int		flags,		/* XFS_ALLOC_FLAG_... */
 	struct xfs_buf	**bpp);		/* buffer for the ag freelist header */
 
+int
+xfs_ag_is_empty(
+	struct xfs_buf		*agfbp);
+
 /*
  * Allocate an extent (variable-size).
  */
-- 
2.27.0

