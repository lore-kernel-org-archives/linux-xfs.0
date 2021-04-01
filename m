Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF64C433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 01:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDFAA61004
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 01:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhDAB7I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 21:59:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14657 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhDAB7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 21:59:03 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9mWB0zgLzmcfY;
        Thu,  1 Apr 2021 09:56:22 +0800 (CST)
Received: from [10.174.176.35] (10.174.176.35) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 1 Apr 2021 09:58:53 +0800
To:     <linux-xfs@vger.kernel.org>, <bfoster@redhat.com>,
        <sandeen@redhat.com>, <darrick.wong@oracle.com>
CC:     linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
From:   lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH] xfs: fix SIGFPE bug in align_ag_geometry
Message-ID: <61b82c3c-5bcf-0c91-4fa5-fa138b52a6a6@huawei.com>
Date:   Thu, 1 Apr 2021 09:58:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.35]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In some case, the cfg->dsunit is 32, the cfg->dswidth is zero
and cfg->agsize is 6400 in align_ag_geometry. So, the
(cfg->agsize % cfg->dswidth) will lead to coredump.

Here add check cfg->dswidth. If it is zero, goto validate.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 mkfs/xfs_mkfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a135e06..71d3f74 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2725,6 +2725,9 @@ _("agsize rounded to %lld, sunit = %d\n"),
 				(long long)cfg->agsize, dsunit);
 	}

+	if (!cfg->dswidth)
+		goto validate;
+
 	if ((cfg->agsize % cfg->dswidth) == 0 &&
 	    cfg->dswidth != cfg->dsunit &&
 	    cfg->agcount > 1) {
-- 
