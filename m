Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA85C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE59D6148E
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344127AbhCBGkP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:40:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242611AbhCBCy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 21:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614653581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yGQqUecRx+rvMXapMkIjCEn36fraMZi5aWsBCX03ces=;
        b=CP1yHEEYhq9hg839aOSjvBhnO6XUaLx3VaPb2ghAPMMboFfafsQYHmRq3PZCAYAKGtXW2Y
        erLDPU49ADBmDM66PUE1IJli1f0SqrXdJTrWWemsauo0Ca61rE3JuUmBamian9wc+MVWPL
        KAisOEsQjgv7EtGBZ638kgtw9fYnYxk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-_-JlCS1SM0CyYI9wQ8SPfg-1; Mon, 01 Mar 2021 21:49:24 -0500
X-MC-Unique: _-JlCS1SM0CyYI9wQ8SPfg-1
Received: by mail-pl1-f199.google.com with SMTP id o8so10438416pls.7
        for <linux-xfs@vger.kernel.org>; Mon, 01 Mar 2021 18:49:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yGQqUecRx+rvMXapMkIjCEn36fraMZi5aWsBCX03ces=;
        b=Sjgel5fc9KUkXdfmohiWS8+L9OeK3F/JP8SabPC91YuB8I4EzAdIg86zD9Jq0bMFSN
         2ZUkS3IM4FQwGy7U6DWKgS2MEn7t9NOS1rWlKI+SUEQkkgT1vef/rt88t+Wwwyv4wnM2
         klWwkyEPuRj8FR0MmuzTcZvbigp8hXMznMql+re0NtYdT1RmzTtU6lDlCFAzCZtYmvrY
         DhQMsTW35HgPorm0cCZftQopxcgUXPyfG08mOZk43i4ZJ9nyy9id4rtRHlaCJjbvnmJc
         rUerd8I5dRTvVs+7sKxlGTJ6pSUz25iEtbMP2p8u2taWgHHktPATXINhp/CytzSb3zKj
         E1mw==
X-Gm-Message-State: AOAM5308UlE3eb1/3BLC0060PRqDiQnkbTj3/HnUUUXOKMFsaW3m/m88
        T5716DWbQIuAxP5SUwScLMi9RRMy8AYxmeTxl36BvSUllM/NC8YBSOgV9SgZlCSFW6RncMGGezN
        auCZwqlUJ6NJ0kQFrjnFfA5BJTKFeNPbetjSB+jaRZ6E+EYQP+hFtBcXPRAOh8nzUp67lQJkGEg
        ==
X-Received: by 2002:a17:902:c317:b029:e4:aecd:8539 with SMTP id k23-20020a170902c317b02900e4aecd8539mr1486067plx.61.1614653362551;
        Mon, 01 Mar 2021 18:49:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpJRu1OMsVY2p7zMtFaEiCXjjP//hYY0Cx3+FggfBPcIk8f/qKvl0DJXVmN8d5PJrB4UouLg==
X-Received: by 2002:a17:902:c317:b029:e4:aecd:8539 with SMTP id k23-20020a170902c317b02900e4aecd8539mr1486051plx.61.1614653362186;
        Mon, 01 Mar 2021 18:49:22 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d24sm18451031pfr.139.2021.03.01.18.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:49:21 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v7 3/5] xfs: introduce xfs_ag_shrink_space()
Date:   Tue,  2 Mar 2021 10:48:14 +0800
Message-Id: <20210302024816.2525095-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210302024816.2525095-1-hsiangkao@redhat.com>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
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
index 9331f3516afa..a1128814630a 100644
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
+	xfs_agnumber_t		agno,
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
+	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
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
index 5166322807e7..f33388eb130a 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -24,6 +24,8 @@ struct aghdr_init_data {
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
+int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
+			xfs_agnumber_t agno, xfs_extlen_t len);
 int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
 			struct aghdr_init_data *id, xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
-- 
2.27.0

