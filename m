Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DF7C38A2A
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 02:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04DFB208E4
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 02:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgEKCi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 22:38:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4324 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727094AbgEKCi1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 10 May 2020 22:38:27 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2E8068DA4CBC760B06A4;
        Mon, 11 May 2020 10:38:25 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 11 May 2020
 10:38:16 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] xfs: ensure f_bfree returned by statfs() is non-negative
Date:   Mon, 11 May 2020 10:45:24 +0800
Message-ID: <20200511024524.132384-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Construct an img like this:

dd if=/dev/zero of=xfs.img bs=1M count=20
mkfs.xfs -d agcount=1 xfs.img
xfs_db -x xfs.img
sb 0
write fdblocks 0
agf 0
write freeblks 0
write longest 0
quit

mount it, df -h /mnt(xfs mount point), will show this:
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0       17M  -64Z  -32K 100% /mnt

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 fs/xfs/xfs_super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e80bd2c4c279..aae469f73efe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -807,7 +807,8 @@ xfs_fs_statfs(
 	statp->f_blocks = sbp->sb_dblocks - lsize;
 	spin_unlock(&mp->m_sb_lock);

-	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
+	/* make sure statp->f_bfree does not underflow */
+	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
 	statp->f_bavail = statp->f_bfree;

 	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
--
2.26.0.106.g9fadedd

