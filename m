Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03014C2BA83
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 09:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C720720848
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 09:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbgBMJq4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:46:56 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:59420 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729531AbgBMJq4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Feb 2020 04:46:56 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E448CDD8D1D68E75F7FD;
        Thu, 13 Feb 2020 17:46:51 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Feb 2020
 17:46:43 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <david@fromorbit.com>, <darrick.wong@oracle.com>,
        <sandeen@redhat.com>, <linux-xfs@vger.kernel.org>
CC:     <renxudong1@huawei.com>
Subject: [PATCH] xfs: add agf freeblocks verify in xfs_agf_verify
Date:   Thu, 13 Feb 2020 17:53:59 +0800
Message-ID: <1581587639-130771-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We recently used fuzz(hydra) to test XFS and automatically generate
tmp.img(XFS v5 format, but some metadata is wrong)

Test as follows:
mount tmp.img tmpdir
cp file1M tmpdir
sync

tmpdir/file1M size is 1M, but its data can not sync to disk.

This is because tmp.img has some problems, using xfs_repair detect
information as follows:

agf_freeblks 0, counted 3224 in ag 0
agf_longest 536874136, counted 3224 in ag 0
sb_fdblocks 613, counted 3228

Add these agf freeblocks checks:
1. agf_longest < agf_freeblks
2. agf_freeblks < sb_fdblocks

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: Ren Xudong <renxudong1@huawei.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d8053bc..0f4b4d1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2858,6 +2858,10 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
 		return __this_address;

+	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
+	    be32_to_cpu(agf->agf_freeblks) >= mp->m_sb.sb_fdblocks)
+		return __this_address;
+
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
--
2.7.4

