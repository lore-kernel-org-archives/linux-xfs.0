Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908DDC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbiFFMeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbiFFMeK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:34:10 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75D82A305C
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 05:34:08 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LGtFp3fNkzpVBj;
        Mon,  6 Jun 2022 20:33:50 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 20:34:07 +0800
Received: from [10.174.176.102] (10.174.176.102) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 20:34:06 +0800
Message-ID: <3725e3ef-2206-8244-e14d-5ffc28e1a68b@huawei.com>
Date:   Mon, 6 Jun 2022 20:34:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: [PATCH 3/3] repair/slab.c: avoid to use NULL pointer
From:   zhanchengbin <zhanchengbin1@huawei.com>
To:     <sandeen@sandeen.net>, <djwong@kernel.org>
CC:     <liuzhiqiang26@huawei.com>, linfeilong <linfeilong@huawei.com>,
        <linux-xfs@vger.kernel.org>
References: <7f4abf2a-5ea5-e2ee-786e-88d871d29475@huawei.com>
In-Reply-To: <7f4abf2a-5ea5-e2ee-786e-88d871d29475@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.102]
X-ClientProxiedBy: dggpeml100019.china.huawei.com (7.185.36.175) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Changed malloc to xmalloc.

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
---
  repair/slab.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/slab.c b/repair/slab.c
index 165f97ef..13fc8203 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -237,7 +237,7 @@ qsort_slab(
  	create_work_queue(&wq, NULL, platform_nproc());
  	hdr = slab->s_first;
  	while (hdr) {
-		qs = malloc(sizeof(struct qsort_slab));
+		qs = xmalloc(sizeof(struct qsort_slab));
  		qs->slab = slab;
  		qs->hdr = hdr;
  		qs->compare_fn = compare_fn;
-- 
2.27.0

