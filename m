Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BC2C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24BE823122
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391332AbhAZNFV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:05:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392464AbhAZM7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 07:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611665850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3XE6o4p8i7YP4aavLFmsYgUv+HesdqfQJ9QVaJANWyc=;
        b=HEbdTG/b2tLOG/HrxN0g5Ca7maJBeWFUYSb6+qTFDzYcvYYNorQGtcN4rW9Klwl4/X2O64
        YVDLCjhEWEMikUyMBS0BrxJVV67GvU0rOSBGARzOtytuKzW6uQfeXZd/d5HePd2WnuUyUg
        rSREiLZZBExUMOYvWwK3KmrJ+lrv/bo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-LP0Ubj8sONashVrI-0Znhw-1; Tue, 26 Jan 2021 07:57:26 -0500
X-MC-Unique: LP0Ubj8sONashVrI-0Znhw-1
Received: by mail-pf1-f199.google.com with SMTP id m65so7960850pfb.20
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 04:57:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3XE6o4p8i7YP4aavLFmsYgUv+HesdqfQJ9QVaJANWyc=;
        b=X22ilbkhAHc7C/c/HvONy9Wbs61LoOM+kS38WRPUYyOYzDzK1IZo/e4frLnVsQ9xyC
         8AtZHIkpd4pWFB71MzziAHMvRRimbSrlC/7+ZzuLHAnJr3CZV9y8MRNRTFCzeptY8ff9
         rIYOmOaAuZPl5iTMPcBaey+KDvAdKsTZJwjVHkFBNfKkV5zlzlgFxgG/3ThEtYLMN7uq
         145taclUjY1BZruc9VpM8E4y8jCal1VdjJz3Evv5sSkYmHj9PlFn2O/hYlokuC+6Gm2W
         Yi3ugDPq2tLI3xJuyBCOdyIXV5nPiHmImihvN/h/lfKz+fFOJ2ykVMNyco9uypD20Zi+
         yepg==
X-Gm-Message-State: AOAM533a0qpQwyoqfG+/6rE4G3Ib+aBCT15AUv2lkcrycuYKfkoj9wYw
        S/BvxzHKQcmx57AVxcQlrw65x6JMczi+7zX3U6h3i/oZuxcXeLAvfXdwp4emfIVGvkX5Zur7X7s
        khOKL8RC2dKAp873Ig6nN1HNbz+CIefwwDHnz9u2vYqGgT3ssRL1MlII4K45DRc6DyZoPFuCtYw
        ==
X-Received: by 2002:a17:902:ac87:b029:e0:17b:68d2 with SMTP id h7-20020a170902ac87b02900e0017b68d2mr6043027plr.0.1611665844764;
        Tue, 26 Jan 2021 04:57:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsvo+lEWzEWC5GBPXAXOVdAmBWRykHUoJVFCJxge13kHPoJxIq/qvjPx4dDRFW5vq8G2AQ3g==
X-Received: by 2002:a17:902:ac87:b029:e0:17b:68d2 with SMTP id h7-20020a170902ac87b02900e0017b68d2mr6042998plr.0.1611665844450;
        Tue, 26 Jan 2021 04:57:24 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b203sm19243174pfb.11.2021.01.26.04.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:57:24 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 5/7] xfs: introduce xfs_ag_shrink_space()
Date:   Tue, 26 Jan 2021 20:56:19 +0800
Message-Id: <20210126125621.3846735-6-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126125621.3846735-1-hsiangkao@redhat.com>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
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
 fs/xfs/libxfs/xfs_ag.c | 108 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |   2 +
 2 files changed, 110 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9331f3516afa..c6e68e265269 100644
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
@@ -485,6 +490,109 @@ xfs_ag_init_headers(
 	return error;
 }
 
+int
+xfs_ag_shrink_space(
+	struct xfs_mount	*mp,
+	struct xfs_trans	**tpp,
+	struct aghdr_init_data	*id,
+	xfs_extlen_t		len)
+{
+	struct xfs_alloc_arg	args = {
+		.tp	= *tpp,
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
+	error = xfs_ialloc_read_agi(mp, *tpp, id->agno, &agibp);
+	if (error)
+		return error;
+
+	agi = agibp->b_addr;
+
+	error = xfs_alloc_read_agf(mp, *tpp, id->agno, 0, &agfbp);
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
+	be32_add_cpu(&agi->agi_length, -len);
+	be32_add_cpu(&agf->agf_length, -len);
+
+	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
+	if (err2) {
+		be32_add_cpu(&agi->agi_length, len);
+		be32_add_cpu(&agf->agf_length, len);
+		if (err2 != -ENOSPC)
+			goto resv_err;
+
+		__xfs_bmap_add_free(*tpp, args.fsbno, len, NULL, true);
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
index 5166322807e7..ca65c2553889 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -24,6 +24,8 @@ struct aghdr_init_data {
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
+int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
+			struct aghdr_init_data *id, xfs_extlen_t len);
 int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
 			struct aghdr_init_data *id, xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
-- 
2.27.0

