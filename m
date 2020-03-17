Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A79FC10F29
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 06:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA4DA205ED
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 06:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgCQG6J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 02:58:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37570 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbgCQG6J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Mar 2020 02:58:09 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BE233A149EE1AB10C2E5;
        Tue, 17 Mar 2020 14:57:55 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 17 Mar 2020
 14:57:49 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH v2 1/2] xfs: always init fdblocks in mount
Date:   Tue, 17 Mar 2020 15:05:01 +0800
Message-ID: <1584428702-127436-2-git-send-email-zhengbin13@huawei.com>
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

Use fuzz(hydra) to test XFS and automatically generate
tmp.img(XFS v5 format, but some metadata is wrong)

xfs_repair information(just one AG):
agf_freeblks 0, counted 3224 in ag 0
agf_longest 0, counted 3224 in ag 0
sb_fdblocks 3228, counted 3224

Test as follows:
mount tmp.img tmpdir
cp file1M tmpdir
sync

In 4.19-stable, sync will stuck, while in linux-next, sync not stuck.
The reason is same to commit d0c7feaf8767
("xfs: add agf freeblocks verify in xfs_agf_verify"), cause agf_longest
is 0, we can not block this in xfs_agf_verify.

Make sure fdblocks is always inited in mount(also init ifree, icount).

xfs_mountfs
  xfs_check_summary_counts
    xfs_initialize_perag_data

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c | 11 +++++++----
 fs/xfs/xfs_mount.c          | 33 ---------------------------------
 2 files changed, 7 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index fdfe6dc..487961b 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -303,10 +303,13 @@ xfs_ag_resv_init(
 	}

 #ifdef DEBUG
-	/* need to read in the AGF for the ASSERT below to work */
-	error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0);
-	if (error)
-		return error;
+	if (!pag->pagf_init) {
+		/* need to read in the AGF for the ASSERT below to work */
+		error = xfs_alloc_pagf_init(pag->pag_mount, tp,
+					    pag->pag_agno, 0);
+		if (error)
+			return error;
+	}

 	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
 	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c5513e5..dc41801 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -594,39 +594,6 @@ xfs_check_summary_counts(
 		return -EFSCORRUPTED;
 	}

-	/*
-	 * Now the log is mounted, we know if it was an unclean shutdown or
-	 * not. If it was, with the first phase of recovery has completed, we
-	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
-	 * but they are recovered transactionally in the second recovery phase
-	 * later.
-	 *
-	 * If the log was clean when we mounted, we can check the summary
-	 * counters.  If any of them are obviously incorrect, we can recompute
-	 * them from the AGF headers in the next step.
-	 */
-	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
-	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
-	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
-	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
-		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
-
-	/*
-	 * We can safely re-initialise incore superblock counters from the
-	 * per-ag data. These may not be correct if the filesystem was not
-	 * cleanly unmounted, so we waited for recovery to finish before doing
-	 * this.
-	 *
-	 * If the filesystem was cleanly unmounted or the previous check did
-	 * not flag anything weird, then we can trust the values in the
-	 * superblock to be correct and we don't need to do anything here.
-	 * Otherwise, recalculate the summary counters.
-	 */
-	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
-	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
-	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
-		return 0;
-
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
 }

--
2.7.4

