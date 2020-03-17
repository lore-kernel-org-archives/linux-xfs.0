Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AA2C10F29
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 06:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B61E4205ED
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 06:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgCQG6A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 02:58:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37536 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbgCQG6A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Mar 2020 02:58:00 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 929B4FBF695B085BF7E5;
        Tue, 17 Mar 2020 14:57:55 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 17 Mar 2020
 14:57:49 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH v2 2/2] xfs: avoid f_bfree overflow
Date:   Tue, 17 Mar 2020 15:05:02 +0800
Message-ID: <1584428702-127436-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584428702-127436-1-git-send-email-zhengbin13@huawei.com>
References: <1584428702-127436-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If fdblocks < mp->m_alloc_set_aside, statp->f_bfree will overflow.
When we df -h /mnt(xfs mount point), will show this:
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0       17M  -64Z  -32K 100% /mnt

We can construct an img like this:

dd if=/dev/zero of=xfs.img bs=1M count=20
mkfs.xfs -d agcount=1 xfs.img
xfs_db -x xfs.img
sb 0
write fdblocks 0
agf 0
write freeblks 0
write longest 0
quit

Make sure statp->f_bfree does not underflow.
PS: add fdblocks check in mount.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 fs/xfs/xfs_mount.c | 6 ++++++
 fs/xfs/xfs_super.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index dc41801..a223af4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -816,6 +816,12 @@ xfs_mountfs(
 	if (error)
 		goto out_log_dealloc;

+	if (sbp->sb_fdblocks < mp->m_alloc_set_aside) {
+		xfs_alert(mp, "Corruption detected. Please run xfs_repair.");
+		error = -EFSCORRUPTED;
+		goto out_log_dealloc;
+	}
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2094386..9dcf772 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -755,7 +755,8 @@ xfs_fs_statfs(
 	statp->f_blocks = sbp->sb_dblocks - lsize;
 	spin_unlock(&mp->m_sb_lock);

-	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
+	/* make sure statp->f_bfree does not underflow */
+	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
 	statp->f_bavail = statp->f_bfree;

 	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
--
2.7.4

