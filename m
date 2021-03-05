Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2324C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A745364F52
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhCEC56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:57:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhCEC55 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 21:57:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614913076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lf8HT1sgQOy5PL4FdvymMkk3T/a0i14JWEXeaTwHcy0=;
        b=C9ipw8V3Bw+DRQ7hB3T5+1Up9/QEhT25fDn2dCcADAEXnPz9BfokwV1xqjLAkO+oYCRDWe
        VkCvQmrvm+dZ/FAbKcspeeIbk/QOeLlVl3Jm+g776P7l2Nay1dEuJELVzCdoWiHT/sHFkR
        JCzwSEbqK0b0LYj7vjH444hGqfr1sHc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-EI0TYuC4PiC7z9t0n4NY3A-1; Thu, 04 Mar 2021 21:57:55 -0500
X-MC-Unique: EI0TYuC4PiC7z9t0n4NY3A-1
Received: by mail-pf1-f198.google.com with SMTP id b12so373410pfb.15
        for <linux-xfs@vger.kernel.org>; Thu, 04 Mar 2021 18:57:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lf8HT1sgQOy5PL4FdvymMkk3T/a0i14JWEXeaTwHcy0=;
        b=j1o7MUiqdjRl+rL0TzYDcODnTwP2AsYhtWs2tRWaGYlOhqcdy0w3lzAqqoG2ipyoEr
         sAMrMEgb3X1deGFCUz+WhtmCUh3T8x1Xziu7XQl7JOZqoWdB2NftFIWgp7sK3IQTDIRx
         tuIJHHuq2Y5LOMbIkkaVMJoyyrVF8b/+A/hs7CAxeVIiAx1XPdqfmUciYKg62pGROWj5
         KK4PRhbeTIveqrfCnVPNTZOAxbv7hfTOMJAIkjTI6uVKuhB0yl7dJXsALfc0hvl5TxJx
         MV/jtkvgE3mI6aQ0EnEIMbkkLxMhFt7trI5yws69sX/Or80y9V5nA7wdez3AqB6momEo
         Uz2A==
X-Gm-Message-State: AOAM530PxZ+LP9bUnRZO5rphz+I8hO6XoGkKkA4722D4kt0l8pKJgyVk
        2WTdxtujW4tgrqPhghyyFLVD4aWUfeVmYI98WhIWHvpEaYs6axMV5+O0XBNZPQPhH4C2oYUjne6
        vPbNsG0N58qRmD6THxVDbUipjU+tI0GS1oiJHua9lHvFdAvD5VPJBiV35seoBZlNVidldspeScg
        ==
X-Received: by 2002:a17:90a:314:: with SMTP id 20mr8041165pje.72.1614913074093;
        Thu, 04 Mar 2021 18:57:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyv3URLjBUX6aoSa263sgVOTu5eSThSsf76COTkAm+7vOdaFQzbAUXUu+kbX7pZp0Fb9MYyig==
X-Received: by 2002:a17:90a:314:: with SMTP id 20mr8041139pje.72.1614913073786;
        Thu, 04 Mar 2021 18:57:53 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m19sm533414pjn.21.2021.03.04.18.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:57:53 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v8 3/5] xfs: introduce xfs_ag_shrink_space()
Date:   Fri,  5 Mar 2021 10:57:01 +0800
Message-Id: <20210305025703.3069469-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305025703.3069469-1-hsiangkao@redhat.com>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch introduces a helper to shrink unused space in the last AG
by fixing up the freespace btree.

Also make sure that the per-AG reservation works under the new AG
size. If such per-AG reservation or extent allocation fails, roll
the transaction so the new transaction could cancel without any side
effects.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c | 111 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |   4 +-
 2 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9331f3516afa..1f6f9e70e1cb 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -22,6 +22,11 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
+#include "xfs_error.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
 
 static int
 xfs_get_aghdr_buf(
@@ -485,6 +490,112 @@ xfs_ag_init_headers(
 	return error;
 }
 
+int
+xfs_ag_shrink_space(
+	struct xfs_mount	*mp,
+	struct xfs_trans	**tpp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		delta)
+{
+	struct xfs_alloc_arg	args = {
+		.tp	= *tpp,
+		.mp	= mp,
+		.type	= XFS_ALLOCTYPE_THIS_BNO,
+		.minlen = delta,
+		.maxlen = delta,
+		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
+		.resv	= XFS_AG_RESV_NONE,
+		.prod	= 1
+	};
+	struct xfs_buf		*agibp, *agfbp;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	int			error, err2;
+
+	ASSERT(agno == mp->m_sb.sb_agcount - 1);
+	error = xfs_ialloc_read_agi(mp, *tpp, agno, &agibp);
+	if (error)
+		return error;
+
+	agi = agibp->b_addr;
+
+	error = xfs_alloc_read_agf(mp, *tpp, agno, 0, &agfbp);
+	if (error)
+		return error;
+
+	agf = agfbp->b_addr;
+	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
+		return -EFSCORRUPTED;
+
+	if (delta >= agi->agi_length)
+		return -EINVAL;
+
+	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
+				    be32_to_cpu(agi->agi_length) - delta);
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
+		/*
+		 * if extent allocation fails, need to roll the transaction to
+		 * ensure that the AGFL fixup has been committed anyway.
+		 */
+		err2 = xfs_trans_roll(tpp);
+		if (err2)
+			return err2;
+		goto resv_init_out;
+	}
+
+	/*
+	 * if successfully deleted from freespace btrees, need to confirm
+	 * per-AG reservation works as expected.
+	 */
+	be32_add_cpu(&agi->agi_length, -delta);
+	be32_add_cpu(&agf->agf_length, -delta);
+
+	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
+	if (err2) {
+		be32_add_cpu(&agi->agi_length, delta);
+		be32_add_cpu(&agf->agf_length, delta);
+		if (err2 != -ENOSPC)
+			goto resv_err;
+
+		__xfs_bmap_add_free(*tpp, args.fsbno, delta, NULL, true);
+
+		/*
+		 * Roll the transaction before trying to re-init the per-ag
+		 * reservation. The new transaction is clean so it will cancel
+		 * without any side effects.
+		 */
+		error = xfs_defer_finish(tpp);
+		if (error)
+			return error;
+
+		error = -ENOSPC;
+		goto resv_init_out;
+	}
+	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
+	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
+	return 0;
+
+resv_init_out:
+	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
+	if (!err2)
+		return error;
+resv_err:
+	xfs_warn(mp, "Error %d reserving per-AG metadata reserve pool.", err2);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return err2;
+}
+
 /*
  * Extent the AG indicated by the @id by the length passed in
  */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 5166322807e7..41293ebde8da 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -24,8 +24,10 @@ struct aghdr_init_data {
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
+int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
+			xfs_agnumber_t agno, xfs_extlen_t len);
 int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
-			struct aghdr_init_data *id, xfs_extlen_t len);
+			struct aghdr_init_data *id, xfs_extlen_t delta);
 int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
 			struct xfs_ag_geometry *ageo);
 
-- 
2.27.0

