Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24663C28D13
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 01:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbiHWBjZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 21:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiHWBjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 21:39:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CD247BBE;
        Mon, 22 Aug 2022 18:39:23 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MBWxh23RkzXdNt;
        Tue, 23 Aug 2022 09:35:04 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500022.china.huawei.com
 (7.185.36.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 23 Aug
 2022 09:39:20 +0800
From:   Zeng Heng <zengheng4@huawei.com>
To:     <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] xfs: remove the redundant word in comment
Date:   Tue, 23 Aug 2022 09:47:20 +0800
Message-ID: <20220823014720.4156722-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just remove the redundant word "being" in comment.

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 fs/xfs/xfs_inode_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6e19ece916bf..ca2941ab6cbc 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -550,7 +550,7 @@ xfs_inode_item_push(
 
 	if (!bp || (ip->i_flags & XFS_ISTALE)) {
 		/*
-		 * Inode item/buffer is being being aborted due to cluster
+		 * Inode item/buffer is being aborted due to cluster
 		 * buffer deletion. Trigger a log force to have that operation
 		 * completed and items removed from the AIL before the next push
 		 * attempt.
-- 
2.25.1

