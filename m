Return-Path: <SRS0=kies=2K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C49C43603
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 09:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B96B24680
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 09:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfLTJhP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 04:37:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7723 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727269AbfLTJhO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Dec 2019 04:37:14 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7471C67DC73F0406B35C;
        Fri, 20 Dec 2019 17:37:11 +0800 (CST)
Received: from euler.huawei.com (10.175.104.193) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Fri, 20 Dec 2019 17:37:02 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>,
        <bfoster@redhat.com>, <dchinner@redhat.com>, <preichl@redhat.com>,
        <sandeen@sandeen.net>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH next] xfs: Make the symbol 'xfs_rtalloc_log_count' static
Date:   Fri, 20 Dec 2019 17:51:57 +0800
Message-ID: <20191220095157.42619-1-chenwandun@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.193]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix the following sparse warning:

fs/xfs/libxfs/xfs_trans_resv.c:206:1: warning: symbol 'xfs_rtalloc_log_count' was not declared. Should it be static?

Fixes: b1de6fc7520f ("xfs: fix log reservation overflows when allocating large rt extents")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 824073a839ac..7a9c04920505 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -202,7 +202,7 @@ xfs_calc_inode_chunk_res(
  * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
  * as well as the realtime summary block.
  */
-unsigned int
+static unsigned int
 xfs_rtalloc_log_count(
 	struct xfs_mount	*mp,
 	unsigned int		num_ops)
-- 
2.17.1

