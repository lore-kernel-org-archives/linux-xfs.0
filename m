Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476F8C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 12:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF5F923109
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 12:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391957AbhAZM7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:59:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31560 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404133AbhAZM6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 07:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611665830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k2a8zh6/Vjgp6yyKkfoZEgFd0CwCEMmLHh5QE+DIIBs=;
        b=O9d+kS537QjlgyZVmLeljWFkcokxa6EWnqGkdw4VU39ncIr6YxCxMjRHd/2uGTneO7HGQq
        pBo3UxQDOo3cuV1YtcAVqjKZCf4xGopjPhxZRNCg8Db9BpeAkjXArbcAqPsBosw7CbTc92
        14Jd6iUKm7UhvoLIu+V+JqYOHVXsaXw=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-47mZkMW3PBGK78n0I5-Y3A-1; Tue, 26 Jan 2021 07:57:07 -0500
X-MC-Unique: 47mZkMW3PBGK78n0I5-Y3A-1
Received: by mail-pf1-f200.google.com with SMTP id o77so8010101pfd.9
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 04:57:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k2a8zh6/Vjgp6yyKkfoZEgFd0CwCEMmLHh5QE+DIIBs=;
        b=UQidwTkiR4hr4ay4YDmaz7S5mlH6DrKPTeT6zR+DEortPqk9B9rLXg+P3QFR08ryDb
         VWuFnpeqXGwluk5pgyZ6awhmICYztfqb9y6vt+WBbJ05I1H3qvvkmhCUfZuPyCleI7ls
         yQTg0td2og+tw7erntjv5TYCkuKL7tkZwLiw3oWfVlmtH2EwzabQ6cOaIZU+y/A6p34w
         gl6u96FENaQR8Z+6mPbSAJjHZIUZmsRI4hw2qmT3JXWRKxDqMeG4yRFkBJVfLfYzLfm5
         msFJSHIMu4QdGBvyw5qXKa82tP4eq7Rc5oaoBkLsxGXAEmozmJqcOBX9XGWGqagxcs58
         FT7w==
X-Gm-Message-State: AOAM5328wgiPhcrebzcsow4rZC8pqbHlJ2bVusiiZsZydNDvkDXPf8ZG
        TfUZLzuI4VKaS63quGc32C4Qt8gnd/32RsM55QDuB0nyk5U8xyJJRXDG6ShuS8AkcfqCxNq6S6+
        QbW2WB0n3h9TpBIHJXUmT9SmUB0CYrYxytgXFj3z4uz3GwUevN8mcgT30mGputCjWxZVde54ASw
        ==
X-Received: by 2002:a17:90a:8006:: with SMTP id b6mr6112684pjn.108.1611665826663;
        Tue, 26 Jan 2021 04:57:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvTXnuoHaNDjyEcOOevCjSmE8zrdXkvd+MU2yhpmUhWe4+qpgPWOjLsaOns4oAiJNqhdt/Tw==
X-Received: by 2002:a17:90a:8006:: with SMTP id b6mr6112660pjn.108.1611665826423;
        Tue, 26 Jan 2021 04:57:06 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b203sm19243174pfb.11.2021.01.26.04.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:57:06 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 1/7] xfs: rename `new' to `delta' in xfs_growfs_data_private()
Date:   Tue, 26 Jan 2021 20:56:15 +0800
Message-Id: <20210126125621.3846735-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126125621.3846735-1-hsiangkao@redhat.com>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
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
index 959ce91a3755..62600d78bbf1 100644
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

