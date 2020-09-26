Return-Path: <SRS0=Ae7g=DD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC63C2D0A8
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15328206FC
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t93uRqqI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgIZNOo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Sep 2020 09:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIZNOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Sep 2020 09:14:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C22FC0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a9so965321pjg.1
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O5+4pxfm0rIlhTIAygdUSVKVo6uA95EQBJHjeRSVM6Q=;
        b=t93uRqqIHl8MK/04nceO+wcvNi7ikQeXBLo+32Mprfg8tzcwvAf2skK3A9ogMHBxNS
         1MIJpreN+PIMJ8DRejNIVVRdCuduK28isLm1Htrt3TKEvhMQqQIGVJekIQOo2Moe7Hn/
         yRohdJPkLmvbdU66t85lyHDL5TTw/6reFnbQp23FJ+IvCJbLuIaFIcUYgWBmePTTbK1Q
         1v/9oa0Qz5nHTTrdnchf87ff5asZ+syjdu8SoDJ+5d/CreyclLEDjbAtNJlqsoJJm5I1
         FDsr0/k/HD34FoDMRCl+8jJNpPaP1iNxvl4OC7tkAGiB9/Pf5dKBcNrLScink5O16G9S
         MFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O5+4pxfm0rIlhTIAygdUSVKVo6uA95EQBJHjeRSVM6Q=;
        b=bhnSgKvoqf4v53SRclFhTa6RibcV0HdrN0Lz0L/+wk+/0fZvU6INkui09stD6IeHGF
         gTz1hXCaUFXXaiF/zMURvfGcooYiBdGJbCKlyzUkAx78hpTZlZrWPdLiOcfcNur3PBLp
         MYpOTmM71VG2QUlDAHgoKSGzORjsFXMutFFScL4Sw+h49T83WyBDC14bWKA7tWWJ1Ops
         lA6ZUQvlK3Ql+aCJ8nRR3Aq3dQCpouXFFO8YAvzcUmgDgK0vxkn3/T1Khx8vqP0C0yBH
         /wwb7k1+Nete/NZxmNPpwAYxl1sE2nkuMQGFDYJQ5CWPJ0zkiiPlHgp5CfNUFiBhDbvp
         aDLQ==
X-Gm-Message-State: AOAM5303bE5AzZLKFeD8LYNsi+SZCqDi6EdFAwHvstr+ht+SoeVcF1wI
        FzWbSsxnHFsgeFBnaNEVWlEFdM+Czw==
X-Google-Smtp-Source: ABdhPJzCT5DKQJgzDFfz5LRF7d6vxEu/wVPaRiy8Nu6W46bZisYcY61m4EKm1cLOiwVcBem9anqGMA==
X-Received: by 2002:a17:902:8494:b029:d2:63a3:5e87 with SMTP id c20-20020a1709028494b02900d263a35e87mr3818760plo.40.1601126083769;
        Sat, 26 Sep 2020 06:14:43 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h12sm5623846pfo.68.2020.09.26.06.14.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Sep 2020 06:14:43 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 4/4] xfs: directly return if the delta equal to zero
Date:   Sat, 26 Sep 2020 21:14:33 +0800
Message-Id: <1601126073-32453-5-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
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

