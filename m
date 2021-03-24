Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03158C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9C39619F4
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhCXBHn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:07:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234219AbhCXBHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 21:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616548038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ROffmMGKr17jDLXAnqHPgcKmYbffcbj+QeNzV3+R/Go=;
        b=Z3FLCAWDsqvHwUoSAD5gdQJTRAfKtVM/KZRCFpY6cXIq9vTFfSmzECAbcSKIbhq/aPetBi
        q5Z5QNeTLwkz4RDdj4cYQEAonCWf56ZcZqDqxaBz+sQcv2jV0H6a9mBGMgCfnNj6+kf6GY
        An7jbU2JZJ3VXgzGojRLs43CHeZdJBE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-mxBROGK9MZq7FL_h2dD62A-1; Tue, 23 Mar 2021 21:07:16 -0400
X-MC-Unique: mxBROGK9MZq7FL_h2dD62A-1
Received: by mail-pf1-f197.google.com with SMTP id u126so285278pfc.6
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 18:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ROffmMGKr17jDLXAnqHPgcKmYbffcbj+QeNzV3+R/Go=;
        b=cn7bjILIkCSL01FoB/ruxsofWaGNMjMqpRvTiF34//Sp0hSWAd96n16Of2tIV5PQHd
         wLDtas6Mp7xKZ/9w09w49/mHIVfc4LpVF0s1hdfFZtiN+MI0K3OLk+idDYXNetW32T7l
         ByRJN5Up5uhizP/3HOEH2gcThKxPle1ftCa4FXzVcaNtVyq8IQF0l6tz0ouVwlDpTjCm
         GMGzfrvFzzyFQreXzV6Q+kZzKa7h4q8cQ7KJK3oskW+yyhe1zOIjDpyW+T3wVeORHbLj
         9izVCSSMlgEy7uPrwYjYfVmvyZ0y4mNlGmCPQgeu4ls3SZN+twpNLmmSHVl3/0zOWahv
         mTEA==
X-Gm-Message-State: AOAM5336NBuAdF4xKb5QcmP2lNGBEa9LMwzPVViVkpzugAVIHX+s+eFS
        K/uk8lhdaskJNy5pVA0vFI89TToQXNL/xolkXKE/nj5vd0P8djV/C+lX8jBIUmp5P9w+iVunZyw
        cOEbA0ew5bQdUxV3GG5o20u24yg8EikqhHNIXbVAg4m3RQdbLWE4d71ZmSfgYolQjVT/e15MAyg
        ==
X-Received: by 2002:a17:90a:e2ca:: with SMTP id fr10mr756288pjb.154.1616548034629;
        Tue, 23 Mar 2021 18:07:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhCJ/YfNKkJVREtpqXTsB88GBJLqb6F+NdW2Fl2tVSfYCq4bMi4hT1Xiuxp340P7zCv/zJGw==
X-Received: by 2002:a17:90a:e2ca:: with SMTP id fr10mr756259pjb.154.1616548034293;
        Tue, 23 Mar 2021 18:07:14 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t18sm379219pgg.33.2021.03.23.18.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:07:14 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v9 3/5] xfs: introduce xfs_ag_shrink_space()
Date:   Wed, 24 Mar 2021 09:06:19 +0800
Message-Id: <20210324010621.2244671-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324010621.2244671-1-hsiangkao@redhat.com>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c | 115 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |   2 +
 2 files changed, 117 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9331f3516afa..c68a36688474 100644
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
@@ -485,6 +490,116 @@ xfs_ag_init_headers(
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
+	/* some extra paranoid checks before we shrink the ag */
+	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
+		return -EFSCORRUPTED;
+	if (delta >= agi->agi_length)
+		return -EINVAL;
+
+	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
+				    be32_to_cpu(agi->agi_length) - delta);
+
+	/*
+	 * Disable perag reservations so it doesn't cause the allocation request
+	 * to fail. We'll reestablish reservation before we return.
+	 */
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
+		xfs_trans_bhold(*tpp, agfbp);
+		err2 = xfs_trans_roll(tpp);
+		if (err2)
+			return err2;
+		xfs_trans_bjoin(*tpp, agfbp);
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
index 5166322807e7..4535de1d88ea 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -24,6 +24,8 @@ struct aghdr_init_data {
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
+int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
+			xfs_agnumber_t agno, xfs_extlen_t delta);
 int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
 			struct aghdr_init_data *id, xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
-- 
2.27.0

