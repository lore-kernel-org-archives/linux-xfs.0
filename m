Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B22C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 09:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A08F22240
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 09:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="frHdTohb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgJSJri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 05:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgJSJri (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 05:47:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4729CC0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 02:47:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id hk7so5376618pjb.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 02:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=diQg8zvNVjpQrTRZzEd7ytmXAPTFhruOMuziAh8qz0w=;
        b=frHdTohbM1PABbSQGW1Mi1CZJjqQMKjKzSQuKbuoH/D8TsytU4Ky+qjiF7fFVD2gwY
         hV2llDfYvW9x7Vu3TMDrDo7aiTZ+a+oWoWVQBrU7PRYFaAhiHNnkRSulzhyRmGfkl8zZ
         0/xKJI71Emg2yi9Nke2sY8z6ZmBt0uevMWebNcq3fFyUM7/5x2Xh/CRyUUG8J1WGur/H
         GtOcntrLbWkkDO9Mx4mumOPkl8p9H5PFb3GLZw5HpEAhAuuyON7JaTIKG8Vjw54U2Noe
         nFe6igS7yhxaatbGeBMO61+6YvqXlQPKtqJIouTZfm09lgV6kqdZ1xW0DkzC2LOBjKi6
         WZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=diQg8zvNVjpQrTRZzEd7ytmXAPTFhruOMuziAh8qz0w=;
        b=KL9WaNAZONqun46KveUTbISX0FIR4qVcj9OZIHItWJDgQkYCVb9NnMw7kKoxlwpRfc
         MwqG7GgMnTuYrBNghzwYrdfzXl78UcUG77KwMi0ZY/pVpPnKqWaYK9tIZ8c0Nw6vGwOH
         81FP2D4mADLlzh1mcxbuOmskaAfTW7LGSvdABSyK50Pc/oEP0lBMVvV4xICnGHlM21Dq
         yRQSkte7pFnV9OI6e8E1RLPLdNaiyCnmjUdWtDCG9Yl2h4ArGzvDwdqdFWve31FJR9+1
         ZNNvjLMQFwfrWdzPFINF94/06hfcGy+/51V2WFm1QVJpWHl4INrbZPB4IGWGx2JpvrNA
         Rz8w==
X-Gm-Message-State: AOAM533vTlnM1k0suhLrs+r1v2y+MUjL7fGYtPml1o9c9iMt2rhYt6Up
        GOnPbZZ3kLEp5chprLn4tAlF0kXGeg==
X-Google-Smtp-Source: ABdhPJxLKO75UFZ0Jmhz/J4Wh3Cb8zLO6d2zuhKPDs8YG6qph2CerhN5ArOsDBP+AcBFiAB+1TyewA==
X-Received: by 2002:a17:902:9f81:b029:d5:e706:3e73 with SMTP id g1-20020a1709029f81b02900d5e7063e73mr4212450plq.78.1603100856567;
        Mon, 19 Oct 2020 02:47:36 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n16sm11413592pfo.150.2020.10.19.02.47.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 02:47:35 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: use the SECTOR_SHIFT macro instead of the magic number
Date:   Mon, 19 Oct 2020 17:47:25 +0800
Message-Id: <1603100845-12205-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
References: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We use the SECTOR_SHIFT macro to define the sector size shift, so maybe
it is more reasonable to use it than the magic number 9.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_bmap_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f2a8a0e75e1f..9f02c1824205 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -63,8 +63,8 @@ xfs_zero_extent(
 	sector_t		block = XFS_BB_TO_FSBT(mp, sector);
 
 	return blkdev_issue_zeroout(target->bt_bdev,
-		block << (mp->m_super->s_blocksize_bits - 9),
-		count_fsb << (mp->m_super->s_blocksize_bits - 9),
+		block << (mp->m_super->s_blocksize_bits - SECTOR_SHIFT),
+		count_fsb << (mp->m_super->s_blocksize_bits - SECTOR_SHIFT),
 		GFP_NOFS, 0);
 }
 
-- 
2.20.0

