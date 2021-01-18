Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07378C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B32F9229C6
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387862AbhARIjU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 03:39:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387627AbhARIjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 03:39:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610959073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yj/GOWRwBDw0c1+mW/E8aP8Mn2Emy0ggtn2GQGWqU6A=;
        b=FPnttXL1fATAemWJBM5OC6Xcy0a0hBBms7wAIAPg3qFiyeQJpx7Apf4Zc/cqUaaL9/2buE
        ponzkH4MoLn+ktZ5UxTS3oTLroYkKvDznTHqSIHw3fz/tXYxSSsGuN3w1uVQoeErZAiXsY
        BmJNRwBHR+KVJqVPiU3xyin6dYtfHDE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-yxhAiaLIOOqHxKuGRgZI6Q-1; Mon, 18 Jan 2021 03:37:51 -0500
X-MC-Unique: yxhAiaLIOOqHxKuGRgZI6Q-1
Received: by mail-pl1-f198.google.com with SMTP id e3so6639011pls.7
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 00:37:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yj/GOWRwBDw0c1+mW/E8aP8Mn2Emy0ggtn2GQGWqU6A=;
        b=udSdhiyly0p2SCtqYuOFgb7EzZzZDcFPCjtt/PaC3I+04tF5Fdo/r3G9vX6r48QHXf
         RFOtJfIiU3GRBvzd/ETAcLgzjtOOdqiQz1Yy3mMpHD8ww18Xhm+GpEYrlmM/l+nPt/rd
         /OyZfnQyeVUZqJtC53dDcf54fC8aIGzRCjNJF42Y/xYVu4zURCHE8HHdskZsdS79ZafN
         I0/jiW64InbzKMIXP1zz3y4RPEdyTSLY89etZe+aQ+TecV5AF9wUqH/FqAenHbJVTS0i
         kp6P1fIwwDJHQBoUrOXTs0WwT1lpXbOyAIgj4e/a/GpjbQPb39doRHV9tnq24jYaO5Jk
         IXpg==
X-Gm-Message-State: AOAM532We9lwsejhaBdAM+Nng+1X16znDgadoo0xy+w2AuCzPjYvCLm8
        Rw3kDdos8B+JtGyWByWMh2G+uHvw0zFrEFsI32vsSHZbePTazzpP/FTq6LiUpRIfERJHVpW1wKw
        e3iizb1FvWbOW03oAacBIuarbW9d85Z0sSuSNBHh59ELib0QYhBPAN2YJA4QOGz1ODpdPjaTDUg
        ==
X-Received: by 2002:a62:25c7:0:b029:156:72a3:b0c0 with SMTP id l190-20020a6225c70000b029015672a3b0c0mr24586675pfl.59.1610959070383;
        Mon, 18 Jan 2021 00:37:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdiCwVvwWfgiqy5d6iHZETktn3ZvZFkKjUr1h9YvnRs/2pzNHnpKNl6patl2l6l048aobFkQ==
X-Received: by 2002:a62:25c7:0:b029:156:72a3:b0c0 with SMTP id l190-20020a6225c70000b029015672a3b0c0mr24586645pfl.59.1610959070006;
        Mon, 18 Jan 2021 00:37:50 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e5sm16293916pjs.0.2021.01.18.00.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 00:37:49 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 1/5] xfs: rename `new' to `delta' in xfs_growfs_data_private()
Date:   Mon, 18 Jan 2021 16:36:56 +0800
Message-Id: <20210118083700.2384277-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210118083700.2384277-1-hsiangkao@redhat.com>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It actually means the delta block count of growfs. Rename it in order
to make it clear. Also introduce nb_div to avoid reusing `delta`.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

