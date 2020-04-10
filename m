Return-Path: <SRS0=tPAf=52=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDB5C2D0EC
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 03:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AD2F20769
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 03:25:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q8iufMo2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDJDZv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 23:25:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33602 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgDJDZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 23:25:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id c138so529364pfc.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2020 20:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MCslBzXschWYW4Q0KZhy30q9thsdbtShQ6Lr6h1DO1w=;
        b=q8iufMo2LQ+ABGnD00XgesWPTy0/N5wJBRdH7CWB4zrdo5e3uacs/rOnKeTbkoFnVp
         oyZaoO6c6/f5YvlRQbNRGA3pn8H6vWMcEQu4lSmZWnPiMJBtNT5I9fpCFuZkCWQL4Gye
         xOmxDXaQbo5JcprxgSc41zJRr0imWgf83YX9e0Xb5bW/BQTh/bd1PC57QaVTAava8Q3a
         dzoR9hziCnLLN1rfRQGleCHF7tK6nr3cbVskD6VIcbpRj0ucBd4ScZaJCzhW/1i3E1kH
         yaqb9X74z3B5S71xvFZgvPeSebT56RwzxFqhwJj4vjjUZFqp4HaW43I5n8QBmtG3vgbW
         bluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MCslBzXschWYW4Q0KZhy30q9thsdbtShQ6Lr6h1DO1w=;
        b=Ds3JlSHFk78/2c2tEMHXy+8anTwgC3IEEkqcIp8Kdu3ZpzPEA8sRnBn+KyX6lrPRAZ
         pz1hlb3U6S2pxFfvpi1uE0XxNqivXxTdP1er7HfuftMCI6XynO6VKCEu3hQGJWYkZ9Hf
         eoiMLwnoUx2sGY08OgSklXWzCYjeCAxkC+PGQIClHyl/pFakYSScKhikvsBjjs8uwnLp
         liAt4y5nJhtXrboERN2Ojc+D1PJibm/fYFST7AgMXyUmjmy1Cy+0918i9uW0waCrRaAm
         zKxbZqYMANaAZFt+eRlroy5Z52nDVzofQ1HMkhHbHaAlanRY4es5Oyzl+QshvT4mlqgV
         RYGA==
X-Gm-Message-State: AGi0PuaFiyfHbHLKAxQLUy1Y9RjL/vqsYYlFYMw9G4WNb6n0mM8iYxgZ
        4NsW4VeQJvPtP23EltVeBRImPiDSCQ==
X-Google-Smtp-Source: APiQypJE9DIG4jTWby2eqqnKyihUtct8FKpXDPGwiqLnb0BUY6cKKSahdA+XMcN/ABoMOuAWHAi6ag==
X-Received: by 2002:a62:1601:: with SMTP id 1mr3145083pfw.45.1586489148489;
        Thu, 09 Apr 2020 20:25:48 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id z7sm499431pju.37.2020.04.09.20.25.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Apr 2020 20:25:48 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
Date:   Fri, 10 Apr 2020 11:25:41 +0800
Message-Id: <1586489141-4708-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The check XFS_IS_QUOTA_RUNNING() has been done when enter the
xfs_qm_vop_create_dqattach() function, it will return directly
if the result is false, so maybe the followed XFS_IS_QUOTA_RUNNING()
assertion is unnecessary. If we truly care about this, the check also
can be added to the next if statements.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b684b04..fc93f88 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1932,7 +1932,6 @@ struct xfs_dquot *
 		return;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-- 
1.8.3.1

