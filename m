Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAE6C4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E832168B
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pwk3bko1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgJHETU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 00:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgJHETU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 00:19:20 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EF3C061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 21:19:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f19so2892670pfj.11
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 21:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K6vf635eyYh36W4Zwz3bmb8gkQHJR7yqYDWmDSEmgBo=;
        b=pwk3bko1dg3LI5L6R461RCw1QBIeD5SzeWk+UjA2YhqEyf9ITHC+cslP0Fu4IEr1kD
         NYThf6lODD8+az6sZXfQNutjI+Dbm9MzzmjKrp/tNPhNO07RuQjRG0V1GrYbpuQ+Clay
         8rJ611lKUurqHj1KHX0WEGTpvWsASHp+6ZqlixaI/qyYxKIxBUkVZKoB8ifOOtf0/jmY
         SsLOfJp/xMdxzrqJf8xkZl98lNew89Jf0DNGL42Xbb+LvMXp9N3/TDBA8v9fl0MwuUqd
         c3xzg6Uav/1jUIgJGDcvTlDwgajFPr36nOhnpKdzYpHdFFkX0+XqpNXnuckW1ZAF4BrN
         CPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K6vf635eyYh36W4Zwz3bmb8gkQHJR7yqYDWmDSEmgBo=;
        b=HOrJY3yyZPKN0W7xW4Ki1lfIx4dqKHy9JOS/CTE3b9+sWF0IF9zZBzN406HDz4Dj7e
         6pHO25F8/bDrALr01WmrYdQ8yYRqp4L0g1EkE9O2qVnhYKr1EbK8e/KoDThDQLzU5yDQ
         1pCXZ+2OVMEZX74HS0IJodltv3c7BHvSRGeXokSN0FnQo0RhRNrJJm1NLtXGDwEBgmGL
         07Hy4FRdcvIE4/zn3W/uFaPKYJv8wkALI1hQWRaCGq7AVV4vtCsNM6K9u51MdrXkIF66
         xscTglUmmvbHhOH2dZs2n2Zo6buCZ4c91lUb2z4/bo5xWuQIsqpt8H2xBdN2OIic7lkD
         epeg==
X-Gm-Message-State: AOAM532gVzyILQEB1L30zAT/rtGeAbgOS1+EsnFuC8OTK6goWdCbKLuf
        8Dp4Lz00cfXnKaWmITCdlxrL9ZVZOjes
X-Google-Smtp-Source: ABdhPJyIk1BUJvCYwljxbhnVPWGz4GXFT3zaq4Dwge4BGNEiz0GZP7d7bWbkifuz8iGH4SF8MdJ4PA==
X-Received: by 2002:a17:90b:950:: with SMTP id dw16mr5784312pjb.200.1602130759590;
        Wed, 07 Oct 2020 21:19:19 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id q8sm5299970pff.18.2020.10.07.21.19.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 21:19:18 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v4 3/3] xfs: directly return if the delta equal to zero
Date:   Thu,  8 Oct 2020 12:19:09 +0800
Message-Id: <1602130749-23093-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
References: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The xfs_trans_mod_dquot() function will allocate new tp->t_dqinfo if it is
NULL and make the changes in the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}].
Nowadays seems none of the callers want to join the dquots to the
transaction and push them to device when the delta is zero. Actually,
most of time the caller would check the delta and go on only when the
delta value is not zero, so we should bail out when it is zero.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 0ebfd7930382..3e37501791bf 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -194,6 +194,9 @@ xfs_trans_mod_dquot(
 	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
 	qtrx = NULL;
 
+	if (!delta)
+		return;
+
 	if (tp->t_dqinfo == NULL)
 		xfs_trans_alloc_dqinfo(tp);
 	/*
@@ -205,10 +208,8 @@ xfs_trans_mod_dquot(
 	if (qtrx->qt_dquot == NULL)
 		qtrx->qt_dquot = dqp;
 
-	if (delta) {
-		trace_xfs_trans_mod_dquot_before(qtrx);
-		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
-	}
+	trace_xfs_trans_mod_dquot_before(qtrx);
+	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
 
 	switch (field) {
 	/* regular disk blk reservation */
@@ -261,8 +262,7 @@ xfs_trans_mod_dquot(
 		ASSERT(0);
 	}
 
-	if (delta)
-		trace_xfs_trans_mod_dquot_after(qtrx);
+	trace_xfs_trans_mod_dquot_after(qtrx);
 }
 
 
-- 
2.20.0

