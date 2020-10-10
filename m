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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C8DC433E7
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 03:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F87D2076B
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 03:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pbBBEcwu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgJJDKL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 23:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730340AbgJJCye (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 22:54:34 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD3AC0613D5
        for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2020 19:54:31 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so8429336pfa.10
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 19:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NhUIcrpfUdsQ53/FI9SQiw2l+fKsjZiF1Dyyw8MzMIk=;
        b=pbBBEcwuvwARo4tW+WzErSiJUBKsyB4nstxPH94ZyBCs5BSoUDUl6CU6c+mj8/MWdF
         lf0re6lFMWIVgGqnLNPSHd899hcvxVMaFw3LXXyBzvOAu3lGYE8Bb9+freJQMDoXkb0u
         QZr25uC5xcPBY5SwpYVBCVRRbo4cJ6qV2TG4idfHKeCnT1nxgVG7l8rP5r09wt+l9sNV
         Y+RPFj07BNoaO7DPl6ccyD2SENxw7nZyEOBgevHftifmwt1dhNmL+qrd+CxUDu+XaPza
         tpndRtESHzfkNKFzkQN20Tug5qMp87MI9/+r7dubg2zmER5kN1W46xFtrocXE/z9Ht6M
         gQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NhUIcrpfUdsQ53/FI9SQiw2l+fKsjZiF1Dyyw8MzMIk=;
        b=Dp5Stv10u3VEhHccqOlPnDrfWneeplgZjcWoa9Q1jguYk1R/xUGpqRdD1pIVIxVr2v
         IGkA2I4tYBxDYwgtTnhfrm+5mIxdrZwkCBUmTKRPx/m33rUV+hrYLxzAqnEGo4e5J9QN
         kXQXSUzylxvLrYa3lKXf+xc81RFpmyOyQmIkuYuew08s1cyeUbtzsKI+3zR+3zkvb1MQ
         ADbvOVgRDznbToVo+XQOvu/MxlF5gtTWf9xdraQ+eDb8C0j6dN4UL2A9wfaCk6JeDfH7
         sDQl3eYpJa7V/BXScOdZ/ekfl2ALz4maVLh7LbEWqsUz8gK2iHupucELP9tSa9W4wjoa
         ahJg==
X-Gm-Message-State: AOAM531zuGcQ72HvdAqkWCJWawefD5l9yRpBTZyZsptE5lZmaJF/08/P
        9Nh772NuN8scnfy+XwCZVClPQ4WSYDbz
X-Google-Smtp-Source: ABdhPJyaAIQik1XbC5TCOYoFV5pFlRbF0BaZZDlZYa/6jmFAMi6eMKTDfTCl6vc8IhdnAXOLxV0WXQ==
X-Received: by 2002:a62:7952:0:b029:155:5705:ac76 with SMTP id u79-20020a6279520000b02901555705ac76mr9622390pfc.58.1602298470948;
        Fri, 09 Oct 2020 19:54:30 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id kc21sm4800826pjb.36.2020.10.09.19.54.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Oct 2020 19:54:30 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v5 3/3] xfs: directly return if the delta equal to zero
Date:   Sat, 10 Oct 2020 10:54:21 +0800
Message-Id: <1602298461-32576-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
References: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_dquot.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 0ebfd7930382..6e243e8b30ec 100644
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
 
 
@@ -687,14 +687,12 @@ xfs_trans_dqresv(
 	 */
 	if (tp) {
 		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
-		if (nblks != 0)
-			xfs_trans_mod_dquot(tp, dqp,
-					    flags & XFS_QMOPT_RESBLK_MASK,
-					    nblks);
-		if (ninos != 0)
-			xfs_trans_mod_dquot(tp, dqp,
-					    XFS_TRANS_DQ_RES_INOS,
-					    ninos);
+		xfs_trans_mod_dquot(tp, dqp,
+				    flags & XFS_QMOPT_RESBLK_MASK,
+				    nblks);
+		xfs_trans_mod_dquot(tp, dqp,
+				    XFS_TRANS_DQ_RES_INOS,
+				    ninos);
 	}
 	ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
 	ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
-- 
2.20.0

