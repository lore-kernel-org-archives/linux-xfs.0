Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49086C433E7
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 03:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C5F2076B
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 03:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FgSL/02v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgJJDIz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 23:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730275AbgJJCy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 22:54:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A485C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2020 19:54:29 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 144so8444284pfb.4
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 19:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=grMtHrVJnuO1/5gZY4FNBnCjlk4Yy5SwmCx7waNeeeE=;
        b=FgSL/02vr5H+eJcnO4Kv8HGkBBjpQKw2P/oq7LNVrVxacR4iuswEK+oj9F67yQLxkw
         0qCJsBs7Lbt6gjtZjPDRTOSMFvUDgJWsvSjPnJ1Xn646Ue40fpUsD/0YxbyaAG7DpwGf
         WJPFM8Qzkt++51whNTZf8dlHcb3muGpzi/yB7uDLaxTuvg1SISRcvusHTsqRTKov4ehG
         BxmxjWfADotLvoHR2V/RIDnkqjlyZyeB3JPrRb+SUsfhZzYgjrEpUMogkB/xRwYDksp1
         Qr+keyOjzYmRFUwZdZ85dK34SI7TjEIc/hULt2VoGurkV0dW076YbczM9fqCbvsaBohX
         7nPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=grMtHrVJnuO1/5gZY4FNBnCjlk4Yy5SwmCx7waNeeeE=;
        b=gZ4S5FTfoCIY09HqmosettEkjuTidb1RDHUPQxlVtETvOV3dPHGfwzuPRN0rTzbSmr
         VlBDpWFOTjv7pfQvZcIuSjQp0jWArkk01hmt5UIsXA/YNNjC7MKtF7pAfZl99GJYfWxC
         d0xlGOsxg6KkXvQejmT242RVMyfzAHkMKY//KQjxkmeDWp9tPVllK7Y5Ouxku7gFEukG
         N3fAX2tMOpm562Z/FdCitip/5r4YYZ40dnl3gJOp27cMlLU4/tfaWIgeLIufKMxTS4ev
         2IWY/++oUiEUdIOlo6IOwVX0Ex1T/qFEsWC3zjLRQ0c0xCUb6YWgJ4xpTcmXMId0PFdk
         VJUA==
X-Gm-Message-State: AOAM532kJK+94O5kB1/vrdPo6Bu5uVSLdS+Zrttw8SbRuCyP+HDJNwPJ
        xxSl9bTSACPZancZvqP0JI2gEITZyd5r
X-Google-Smtp-Source: ABdhPJzRA31Xs4rZxbtZg5Mugmf72c9HKMHBZW7q4YltwtCQB7fBQxy8nCOr/0m2pcBZnf54EUkOBw==
X-Received: by 2002:a62:3882:0:b029:152:127a:e852 with SMTP id f124-20020a6238820000b0290152127ae852mr14921522pfa.21.1602298468516;
        Fri, 09 Oct 2020 19:54:28 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id kc21sm4800826pjb.36.2020.10.09.19.54.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Oct 2020 19:54:27 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v5 1/3] xfs: delete duplicated tp->t_dqinfo null check and allocation
Date:   Sat, 10 Oct 2020 10:54:19 +0800
Message-Id: <1602298461-32576-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
References: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The function xfs_trans_mod_dquot_byino() wrap around xfs_trans_mod_dquot()
to account for quotas, and also there is the function call chain
xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv -> xfs_trans_mod_dquot,
both of them do the duplicated null check and allocation. Thus
we can delete the duplicated operation from them.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_dquot.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index fe45b0c3970c..67f1e275b34d 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -143,9 +143,6 @@ xfs_trans_mod_dquot_byino(
 	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
-	if (tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
-
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
 	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
@@ -698,7 +695,6 @@ xfs_trans_dqresv(
 	 * because we don't have the luxury of a transaction envelope then.
 	 */
 	if (tp) {
-		ASSERT(tp->t_dqinfo);
 		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 		if (nblks != 0)
 			xfs_trans_mod_dquot(tp, dqp,
@@ -752,9 +748,6 @@ xfs_trans_reserve_quota_bydquots(
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
-	if (tp && tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
-
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
 	if (udqp) {
-- 
2.20.0

