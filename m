Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC22C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78DC164FD4
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCEC5u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:57:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhCEC5t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 21:57:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614913069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vCCpatKjmI8AkfBL08Jn6zsTwQLRzUEgQOAxEIiY/p4=;
        b=M5DMXce/0aaZ3Uxa0O7YLom1D3AtVUNwltOlUbGiNbu122hI+fnq/oKIwvewFVxDUQW2zD
        GamLsByJDaR7JOV/ihw/ar95g8B9Ts3yrMAV2+BGVwc5AlTDKW59bGqppLFCqXF8po6cuo
        cPgp18bNxS/Jxc0EILE9pfssMw4lIqA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-jTHXgZ7YPXCfC5ng-nAk_g-1; Thu, 04 Mar 2021 21:57:45 -0500
X-MC-Unique: jTHXgZ7YPXCfC5ng-nAk_g-1
Received: by mail-pf1-f197.google.com with SMTP id t69so402910pfc.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Mar 2021 18:57:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vCCpatKjmI8AkfBL08Jn6zsTwQLRzUEgQOAxEIiY/p4=;
        b=hzalpqN2S7/UgiZiCyTmioaERfxzz7Lm3i62v1Mobw+GabXTWSwWgqlRBdCfHQjSJZ
         bDjYgg2LS9KoRChiB4q68ZagL0HVf3JbZOBldK/JTA0wqUt+mjWd5ARAnXt4BdKxMTWU
         elpi8OAiA2l8qDygun77f1qvlUJ8qCz0WHYVK24957Dau1V/xEQiRO0O3OnKshEDXr5S
         CH25WBKvoFy96VnVkC4dXzNiwzcOXERp0aNuNT5kfOkBSxEWr44VtTKn5r2roNJGnUyV
         d9Mx7gHaLfTYFDt0dDofqrh1j1V6JNJVBYAroiOPD26eGbeqOcXpL55+nrErcy2mg26Q
         qvYQ==
X-Gm-Message-State: AOAM53180PzSplxQSX4fprLUJI7oI7sNT0gHbqipNCIu1gYzX8HJOxVL
        et4Jko7kpGtaaAwxpT2ykUCR3gK7ABZR1TrsSGOGjh5Ck4mqpfgVGw3effn0PqV/v2WhINxxUdh
        SLhGHDREkZcy7TVCb+KaZs3V/OquhKoSp6OrSQ0ZStWJ07ii5QOuuoGYCFonUj8vZaLw2bKW+5A
        ==
X-Received: by 2002:a17:90a:7309:: with SMTP id m9mr7925467pjk.23.1614913064642;
        Thu, 04 Mar 2021 18:57:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8H6NdxUyrxWZNJXpJVNjEC/S+uch9H41/D5ZeLSXEIGyX7t7dfZw6CNw5zZ14MPlUDQNsXw==
X-Received: by 2002:a17:90a:7309:: with SMTP id m9mr7925441pjk.23.1614913064345;
        Thu, 04 Mar 2021 18:57:44 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m19sm533414pjn.21.2021.03.04.18.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:57:44 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v8 1/5] xfs: update lazy sb counters immediately for resizefs
Date:   Fri,  5 Mar 2021 10:56:59 +0800
Message-Id: <20210305025703.3069469-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305025703.3069469-1-hsiangkao@redhat.com>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

sb_fdblocks will be updated lazily if lazysbcount is enabled,
therefore when shrinking the filesystem sb_fdblocks could be
larger than sb_dblocks and xfs_validate_sb_write() would fail.

Even for growfs case, it'd be better to update lazy sb counters
immediately to reflect the real sb counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a2a407039227..9f9ba8bd0213 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -128,6 +128,15 @@ xfs_growfs_data_private(
 				 nb - mp->m_sb.sb_dblocks);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+
+	/*
+	 * Sync sb counters now to reflect the updated values. This is
+	 * particularly important for shrink because the write verifier
+	 * will fail if sb_fdblocks is ever larger than sb_dblocks.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		xfs_log_sb(tp);
+
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-- 
2.27.0

