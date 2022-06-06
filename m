Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198C2C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbiFFMdI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237117AbiFFMdI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:33:08 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2751C7CB42
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 05:33:06 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LGtCQ6ymgzjXJL;
        Mon,  6 Jun 2022 20:31:46 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 20:33:04 +0800
Received: from [10.174.176.102] (10.174.176.102) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 20:33:04 +0800
Message-ID: <44ef0950-791d-e17e-1fe8-f58d3148603f@huawei.com>
Date:   Mon, 6 Jun 2022 20:33:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: [PATCH 1/3] mkfs/proto.c: avoid to use NULL pointer
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

Change malloc to xmalloc.

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
---
  mkfs/proto.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 127d87dd..f3b8710c 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -70,7 +70,7 @@ setup_proto(
  		goto out_fail;
  	}

-	buf = malloc(size + 1);
+	buf = xmalloc(size + 1);
  	if (read(fd, buf, size) < size) {
  		fprintf(stderr, _("%s: read failed on %s: %s\n"),
  			progname, fname, strerror(errno));
@@ -303,7 +303,7 @@ newregfile(
  		exit(1);
  	}
  	if ((*len = (int)size)) {
-		buf = malloc(size);
+		buf = xmalloc(size);
  		if (read(fd, buf, size) < size) {
  			fprintf(stderr, _("%s: read failed on %s: %s\n"),
  				progname, fname, strerror(errno));
-- 
2.27.0
