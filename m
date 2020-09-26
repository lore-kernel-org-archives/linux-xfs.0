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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CFCC4741F
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED0F2221ED
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H9lcqYn4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIZNOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Sep 2020 09:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIZNOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Sep 2020 09:14:41 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57095C0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k13so5636818pfg.1
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eMEw8aj1+EZZQz39IsZVFuuk1cuV37KYytSO8uCLZCw=;
        b=H9lcqYn4Q6SSjAQ+YmKcNHipiGskt9HswBP0IZu53MkXcWWdMkCZFF00jMgp/+tZ9B
         GBWPHcfEfGleoUmyYrx1KQ1Vig0Vl1e3pDQDTJT2SFYb1/QN3WJJ/OWOe0ozJpSYcC5m
         22F2+4i2cDay/YAM8/HJ5ZxG1IJT57ySwODShjV4Esegw2St7rjOUqxpl1Ze8n3OP3f3
         yGy8iUTHnEDznVe6WoCgT2iJxVXjdxiSQ0yLxn30GM++7ZVR03qbuGSOVh38n8RZQo7P
         Hrxo4Vhgvr+3A4ykjToh87ZuyHyK1kRUFnN2f6h/yd0adzPF8uB71GYU4TimtHlbLhTg
         OYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eMEw8aj1+EZZQz39IsZVFuuk1cuV37KYytSO8uCLZCw=;
        b=hO7Ggvh4LGxk3NC+TGvAzBkwKDTQIza7VPdi+aYeUNuO2JUSCpGR8PjgNTwL8ZIfXD
         oZFT0WGqDD1KARUoXaE98IohMuH0C4fhiNEu/fEYZu2Q2vZJOYhUwBdWpepCoK215Xvg
         Kzy+devJwLjk74NVQHPUSot7QBLKnuS1aMgw1LHwYZU39bn0IG7J2UDo++6krPJsp4H7
         u9FO1jKGCxSh6OHRlKWf6T+aWPBA9XoMcG3whVz+kaW/NWR9CVeIlYPbLs+EmTbDJPQD
         XZWOdF+UF6P8zvRA4kFYcOwqJ5lVmbFpHg9rLounHOgGeu60IDzxMbYlGdJUnn15vT5q
         bBmg==
X-Gm-Message-State: AOAM5323ASCnojJiHbXcfxP3Y4maziQDmLuGVQwzUsI1+3VkVc/9Ysej
        WBuGClsamzOnX26aWr2BEzUQunx4/w==
X-Google-Smtp-Source: ABdhPJwsdYFcWPc/Loj8kjnwaQGITPnNYc3IfWkla3OBGTOP5fiwilfgal6TQXp0NQJMEcaBufAoew==
X-Received: by 2002:a62:7b94:0:b029:142:2501:35e4 with SMTP id w142-20020a627b940000b0290142250135e4mr3656982pfc.68.1601126080541;
        Sat, 26 Sep 2020 06:14:40 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h12sm5623846pfo.68.2020.09.26.06.14.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Sep 2020 06:14:39 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 1/4] xfs: do the ASSERT for the arguments O_{u,g,p}dqpp
Date:   Sat, 26 Sep 2020 21:14:30 +0800
Message-Id: <1601126073-32453-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

If we pass in XFS_QMOPT_{U,G,P}QUOTA flags and different uid/gid/prid
than them currently associated with the inode, the arguments
O_{u,g,p}dqpp shouldn't be NULL, so add the ASSERT for them.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
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

