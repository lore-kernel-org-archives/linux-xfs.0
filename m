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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13962C433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFAFB2087D
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfXZe4oZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgJHETS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 00:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgJHETS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 00:19:18 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C14C0613D2
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 21:19:17 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y14so2888708pfp.13
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 21:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5wNjy0lvsNNCc+yE7R/UyV3v93zPFjpqn34BrXXwusI=;
        b=PfXZe4oZcSjnTDbTUPKxjwkQdXAMOkUUkZUF0oo7gSI+/ZowndF1gehuI4hvNwo1G1
         ac73/WdBBLSJ1QdV06mNvWdaTjKf6dYzrBD9mOcVjgyVHGj2z7dw7kddD0dXcPacqodJ
         4xW7E8CkrMLCecmsksYOleoEXTq840jS6Dd7LOVlWYacZzixEDEsvfhoi2I66AbL37ht
         RoLLDVear7N1tP/f0Oly5fOqr+x5NsR2WksqRDdeNwQfxapbWRBuocLSX2Y1FIxAsDbw
         FgrI3aEbZAKrWcABN88QuzaP6DnbXpG7Jaix99kegWEISD6vG58n8IclE3h0e9hxxJdA
         QFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5wNjy0lvsNNCc+yE7R/UyV3v93zPFjpqn34BrXXwusI=;
        b=UdN96E+XO8YLDN49NptUOhD0JRd3Tvw3d1nrDKj8XacWmDV5adPPVWzs+fvJ8p54t8
         qBQDfytJxDcVJnklJn0tHsYhDPf4VBxh5cTBGXDy7HZV1SOT6gUpEatyR/+Zjrv7FoG4
         YyKXGyfoal/nYWuS6BxXui/GF/2/5zG0xKTpiqo91H1qJ7MO+ImCQrLRilBJ0bIoglZ3
         nxw5GHmOI0XLukLQrR4tN9bo5kAqgSleGfKmrt9cw9/yothxMi56tAo72I6F9kR5aSdK
         hEAh09DhWFyjCpbMfXCi8A5wjKhpfGrdO5AjalSFcvTEJ3p16IQnTcfrdHKvFxwkZlhZ
         qK1A==
X-Gm-Message-State: AOAM530Y6zeidwft66t7LJczWjKepKwhke9XCJ+nNijlw+MKWcng3bnp
        /IN+A4cSwcsO66lALXDGVBpR1OSrDWTV
X-Google-Smtp-Source: ABdhPJynsnfV+551Hrcx6lLz2FAtGwkAAD2855xBaT8dpsGo3P8570p9o164Gf2lWPVPI4tweEn3Mw==
X-Received: by 2002:a17:90b:33cf:: with SMTP id lk15mr5713409pjb.81.1602130757255;
        Wed, 07 Oct 2020 21:19:17 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id q8sm5299970pff.18.2020.10.07.21.19.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 21:19:16 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v4 1/3] xfs: delete duplicated tp->t_dqinfo null check and allocation
Date:   Thu,  8 Oct 2020 12:19:07 +0800
Message-Id: <1602130749-23093-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
References: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
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

