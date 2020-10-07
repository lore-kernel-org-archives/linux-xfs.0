Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E938C47095
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3BA1212CC
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NeVaiBAJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgJGOvW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgJGOvW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:51:22 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520FBC061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 07:51:22 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 144so1463857pfb.4
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 07:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GjuRNaGO+7uEJ2NThT1lnUlL/1fBfZSgIc7LSPXVy+s=;
        b=NeVaiBAJuc/Ci8veFhKQgBc1+OYDtd0IKsS/I10i0GKye/t0VgL43ja4ydtHlnYo46
         U5An8tvmOMSdKjI5D8jD6gGGoeSx7BZZu/eB/NUHaJqn6Z+cJNo9c8Wy1tftD/mKHzMJ
         zX0S37RB5PZEdNuerJkGbZcH9OxrpuDh8J5l9gKsJSeCsvxPnAcvCtG6o+ur8+pVbIFR
         y/SWkQxMjk+k4S2kt+aGBr12qZd1BxwOVx2YhOO3mFqBy4OsqFd9pcOYvuQB5uHfs1qX
         ZQT+PA/wU1VWjsHZMXZvwb/SBBymET7VKgs07B8s9wphYWab6mwyhKN5UGL/gHx6DAwL
         rFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GjuRNaGO+7uEJ2NThT1lnUlL/1fBfZSgIc7LSPXVy+s=;
        b=MPUsNjuJwkNSIRldx/gYHIaWmyas29QS6bAUnwwGjlLTz27hQwfROMRvMc7N2Yy/Fz
         /KF8JhXwwRoXVUXOkJzPqT/jG2IWW8FF1ABR5YQHjKISHL06wCGn5TcnUSbYHJXaf/E9
         WLEtpmp+P/3vq9XWWOBldtIDZkXYrl4/X9lu/Be80K+5+3xOktIeamR3cOzPlDowMEiw
         qRUB99eqAkbfPpftqANSdoSemUPbwI8f11tpoczvVnoTux4Frg91ahDAEgpP9csxo4Sg
         cTx7I0dfZqtQR6UKElFsqYvMyil/4KPpbOKSRf5UTj+1JpbObbNSZGAm1OhW9gFe3p2e
         KzPQ==
X-Gm-Message-State: AOAM532EDNdNQXf2ZvuWjLbyfV82BgKyQKAnSx0KwjMx0+Q+YSZTsMmu
        WTDjfE+g9p6NAMgK4sBqDiXZIVPVGA==
X-Google-Smtp-Source: ABdhPJztjSuMvhHNme1x2JOgzTXWGVnrHMbeNXKLaYmjf3RkiUY+nnMAvIV5AhjX5C7EmPpHjoi0UA==
X-Received: by 2002:a63:c34b:: with SMTP id e11mr3428405pgd.25.1602082281548;
        Wed, 07 Oct 2020 07:51:21 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x22sm3443402pfp.181.2020.10.07.07.51.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 07:51:20 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 1/5] xfs: do the ASSERT for the arguments O_{u,g,p}dqpp
Date:   Wed,  7 Oct 2020 22:51:08 +0800
Message-Id: <1602082272-20242-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

If we pass in XFS_QMOPT_{U,G,P}QUOTA flags and different uid/gid/prid
than them currently associated with the inode, the arguments
O_{u,g,p}dqpp shouldn't be NULL, so add the ASSERT for them.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 44509decb4cd..b2a9abee8b2b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1662,6 +1662,7 @@ xfs_qm_vop_dqalloc(
 	}
 
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
+		ASSERT(O_udqpp);
 		if (!uid_eq(inode->i_uid, uid)) {
 			/*
 			 * What we need is the dquot that has this uid, and
@@ -1695,6 +1696,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
+		ASSERT(O_gdqpp);
 		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
@@ -1712,6 +1714,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
+		ASSERT(O_pdqpp);
 		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, prid,
-- 
2.20.0

