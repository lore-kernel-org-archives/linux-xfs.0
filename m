Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8963BECAAD8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 03:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiIVDCo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Sep 2022 23:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiIVDCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2022 23:02:41 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16F8A223C
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 20:02:39 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MY0QM4KXLzHpcc;
        Thu, 22 Sep 2022 11:00:27 +0800 (CST)
Received: from dggpeml500016.china.huawei.com (7.185.36.70) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 11:02:37 +0800
Received: from [10.174.176.102] (10.174.176.102) by
 dggpeml500016.china.huawei.com (7.185.36.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 11:02:37 +0800
Message-ID: <66a008ab-b54a-6f72-727c-efce8654b481@huawei.com>
Date:   Thu, 22 Sep 2022 11:02:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
To:     <cem@kernel.org>
CC:     linfeilong <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>,
        <linux-xfs@vger.kernel.org>
From:   zhanchengbin <zhanchengbin1@huawei.com>
Subject: [PATCH] xfsdump: fix memory leak
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.102]
X-ClientProxiedBy: dggpeml100019.china.huawei.com (7.185.36.175) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Need free tmphdr and newnode before return,
otherwise it will cause memory leak.

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
---
  common/drive_simple.c | 1 +
  invutil/list.c        | 4 +++-
  2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/drive_simple.c b/common/drive_simple.c
index 5c3ed4b..141fdcb 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -456,6 +456,7 @@ do_begin_read(drive_t *drivep)
  	/* can only read one media file
  	 */
  	if (contextp->dc_fmarkcnt > 0) {
+		free(tmphdr);
  		return DRIVE_ERROR_EOM;
  	}

diff --git a/invutil/list.c b/invutil/list.c
index 46fb291..a3a4cfd 100644
--- a/invutil/list.c
+++ b/invutil/list.c
@@ -52,8 +52,10 @@ node_create(int hidden, int expanded, int level, int 
deleted, int file_idx, char
  	return NULL;

      newdata = malloc(sizeof(*newdata));
-    if(newdata == NULL)
+    if(newdata == NULL) {
+	free(newnode);
  	return NULL;
+    }

      newdata->hidden = hidden;
      newdata->expanded = expanded;
-- 
2.33.0

