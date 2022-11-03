Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46141C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 11:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiKCLW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 07:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKCLW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 07:22:27 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2610FCC
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 04:22:25 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N31V037PfzpVsM;
        Thu,  3 Nov 2022 19:18:48 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500019.china.huawei.com
 (7.221.188.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 19:22:21 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <djwong@kernel.org>, <dchinner@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <guoxuenan@huawei.com>,
        <houtao1@huawei.com>, <jack.qiu@huawei.com>, <fangwei1@huawei.com>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <leo.lilong@huawei.com>, <zengheng4@huawei.com>
Subject: [PATCH] xfs: fix incorrect usage of xfs_btree_check_block
Date:   Thu, 3 Nov 2022 19:37:09 +0800
Message-ID: <20221103113709.251669-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_btree_check_block contains a tag XFS_ERRTAG_BTREE_CHECK_{L,S}BLOCK,
it is a fault injection tag, better not use it in the macro ASSERT.

Since with XFS_DEBUG setting up, we can always trigger assert by `echo 1
> /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
It's confusing and strange. Instead of using it in ASSERT, replace it with
xfs_warn.

Fixes: 27d9ee577dcc ("xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index eef27858a013..637513087c18 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -556,8 +556,11 @@ xfs_btree_islastblock(
 	struct xfs_buf		*bp;
 
 	block = xfs_btree_get_block(cur, level, &bp);
-	ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
-
+	ASSERT(block);
+#if defined(DEBUG) || defined(XFS_WARN)
+	if (xfs_btree_check_block(cur, block, level, bp))
+		xfs_warn(cur->bc_mp, "%s: xfs_btree_check_block() error.", __func__);
+#endif
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
 	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
-- 
2.31.1

