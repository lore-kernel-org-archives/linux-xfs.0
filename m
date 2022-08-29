Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC51ECAAA2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 03:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiH2Dej (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 23:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiH2Dei (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 23:34:38 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B51F21E18;
        Sun, 28 Aug 2022 20:34:35 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MGGG005HcznTmn;
        Mon, 29 Aug 2022 11:32:08 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500022.china.huawei.com
 (7.185.36.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 29 Aug
 2022 11:34:31 +0800
From:   Zeng Heng <zengheng4@huawei.com>
To:     <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zengheng4@huawei.com>
Subject: [PATCH -next 1/2] xfs: replace unnecessary seq_printf with seq_puts
Date:   Mon, 29 Aug 2022 11:42:17 +0800
Message-ID: <20220829034217.732635-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace seq_printf with seq_puts when const string
in reference, which would avoid to deal with
unnecessary string format.

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 fs/xfs/xfs_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 20e0534a772c..70d38b77682b 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -125,7 +125,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
 {
 	int j;
 
-	seq_printf(m, "qm");
+	seq_puts(m, "qm");
 	for (j = XFSSTAT_START_XQMSTAT; j < XFSSTAT_END_XQMSTAT; j++)
 		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
 	seq_putc(m, '\n');
-- 
2.25.1

