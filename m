Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AC3C47082
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Jun 2021 08:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC936139A
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Jun 2021 08:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFEIy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Jun 2021 04:54:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3439 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhFEIyz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Jun 2021 04:54:55 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxtcY3fQqz6tpN;
        Sat,  5 Jun 2021 16:50:05 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 16:53:05 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 16:53:05 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-xfs@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH] xfs: remove redundant initialization of variable error
Date:   Sat, 5 Jun 2021 16:52:50 +0800
Message-ID: <1622883170-33317-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

'error' will be initialized, so clean up the redundant initialization.

Cc: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 592800c8852f..59991c8c7127 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -707,7 +707,7 @@ xfs_buf_get_map(
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
-	int			error = 0;
+	int			error;
 
 	*bpp = NULL;
 	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
-- 
2.7.4

