Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A1CC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Dec 2022 09:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiL2JWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Dec 2022 04:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiL2JWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Dec 2022 04:22:04 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E655E0C5
        for <linux-xfs@vger.kernel.org>; Thu, 29 Dec 2022 01:22:02 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NjN871yFkzqTFk;
        Thu, 29 Dec 2022 17:17:27 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 29 Dec
 2022 17:21:59 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <djwong@kernel.org>, <dchinner@redhat.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH -next] xfs: change xfs_iomap_page_ops to static
Date:   Thu, 29 Dec 2022 17:18:59 +0800
Message-ID: <20221229091859.4156792-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iomap_page_ops is only used in xfs_iomap.c now,
change it to static.

Fixes: 304a68b9c63b ("xfs: use iomap_valid method to detect stale cached iomaps")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 669c1bc5c3a7..fc1946f80a4a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -83,7 +83,7 @@ xfs_iomap_valid(
 	return true;
 }
 
-const struct iomap_page_ops xfs_iomap_page_ops = {
+static const struct iomap_page_ops xfs_iomap_page_ops = {
 	.iomap_valid		= xfs_iomap_valid,
 };
 
-- 
2.25.1

