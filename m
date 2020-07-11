Return-Path: <SRS0=A882=AW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29A8C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jul 2020 07:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB31B2075F
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jul 2020 07:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgGKHa4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jul 2020 03:30:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7294 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727984AbgGKHa4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Jul 2020 03:30:56 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8B7A4AF53CFD87EFBA87;
        Sat, 11 Jul 2020 15:30:53 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 11 Jul 2020 15:30:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-xfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] xfs: remove duplicated include from xfs_buf_item.c
Date:   Sat, 11 Jul 2020 07:34:58 +0000
Message-ID: <20200711073458.27029-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/xfs/xfs_buf_item.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index e9428c30862a..ed1bf1d99483 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -19,7 +19,6 @@
 #include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
-#include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
 





