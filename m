Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD38C4727D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 09:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 413AA2396D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 09:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mm+xaDyq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIVJEM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 05:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgIVJEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 05:04:12 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E12C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 02:04:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z18so11853773pfg.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 02:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VaCEnb4aBVLoau6u4JrNFVbw6Erf7UxF1bT/u9yFhYU=;
        b=mm+xaDyqo4xbwf1EenzTmk3IC7dPa8+/CDtpo/mWyVuu1tCuzbQzGh6AsRSnl8Zbrh
         OxMwjUX9AHxqacuzn3V4w1PWqcjfJ2iW8I9MQ8+JjhRvJDW3NZ7UnyyLKf+EtDWLxzQa
         7A9Ud2okZUWtLhgi3BpUyXV/s2ut+goIjFHnlXDYA9c/D8xPTfy+R0DAyNfGCZ/iJ2GO
         SCpP1BNYhh9tZc49pH3aPk/QWwd29/LQdrNYWmrxUi1kFIf1Vd8n6iscl7WU9eJszivy
         xpB0ayX5AKj385BVBbpE4zjgRqZE8qggr8uub7CmRP3/4POWPFvNHuM5XecoMrL6itGA
         t9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VaCEnb4aBVLoau6u4JrNFVbw6Erf7UxF1bT/u9yFhYU=;
        b=eQhzw372OknHjhCSFi/TiZtdj2BKu5WT+ZUGDncF4tQezLEV/RYzKsgGfdGj/Hawas
         MzF6TagCw/rqoHinhaIm5IlyxRcvRSid9CALVI7Z1gFJrg2ZIUUObADOnwEKJRFfq9vO
         rSfISA8rRvjoK/PGhLSOfJLT7fqLYEb7fco/LXlwncTE5SXtNWj4nSHiB5bxR7h4dyLh
         hvzce2ZhKuqIpOsp8nt2yy5Q0xUll4ZXS7wTcdymOofuBXb3I16FEadDLN3u7sam8/oN
         y+KzVwTLCV60Lx/Pi6G1C+si2g00LJPVRXc+0Ce4ZDVB4S92Ipr86M+j1RL4FbtC+zWn
         EAsA==
X-Gm-Message-State: AOAM532t1O7siUs1gXC4Oxkq9Ln0hFA9zpQ4ajtdZg6PD38ZnRLUC9CI
        9esAwtnZCrDkifxDG4dM0NXXfUMeeA==
X-Google-Smtp-Source: ABdhPJyBNS8yf7/AMGwtVpUbB8EgGf2RuyMFX4Vo5mQjvGleGFgUvnwlOxFXbskU6JFgKNS3JNP8ig==
X-Received: by 2002:a17:902:ee06:b029:d1:8c50:b1ba with SMTP id z6-20020a170902ee06b02900d18c50b1bamr3588696plb.35.1600765451822;
        Tue, 22 Sep 2020 02:04:11 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h8sm13815653pfk.19.2020.09.22.02.04.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 02:04:11 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH 3/3] xfs: only do dqget or dqhold for the specified dquots
Date:   Tue, 22 Sep 2020 17:04:02 +0800
Message-Id: <1600765442-12146-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We attach the dquot(s) to the given inode and return udquot, gdquot
or pdquot with references taken by dqget or dqhold in xfs_qm_vop_dqalloc()
funciton. Actually, we only need to do dqget or dqhold for the specified
dquots, it is unnecessary if the passed-in O_{u,g,p}dqpp value is NULL.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 44509decb4cd..38380fc29b4d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1661,7 +1661,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 
-	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
+	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp) && O_udqpp) {
 		if (!uid_eq(inode->i_uid, uid)) {
 			/*
 			 * What we need is the dquot that has this uid, and
@@ -1694,7 +1694,7 @@ xfs_qm_vop_dqalloc(
 			uq = xfs_qm_dqhold(ip->i_udquot);
 		}
 	}
-	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
+	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp) && O_gdqpp) {
 		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
@@ -1711,7 +1711,7 @@ xfs_qm_vop_dqalloc(
 			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
 	}
-	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
+	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp) && O_pdqpp) {
 		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, prid,
@@ -1733,16 +1733,11 @@ xfs_qm_vop_dqalloc(
 	xfs_iunlock(ip, lockflags);
 	if (O_udqpp)
 		*O_udqpp = uq;
-	else
-		xfs_qm_dqrele(uq);
 	if (O_gdqpp)
 		*O_gdqpp = gq;
-	else
-		xfs_qm_dqrele(gq);
 	if (O_pdqpp)
 		*O_pdqpp = pq;
-	else
-		xfs_qm_dqrele(pq);
+
 	return 0;
 
 error_rele:
-- 
2.20.0

