Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A162DC2BB1D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84C432051A
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbgCPNAT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:00:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45316 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731066AbgCPNAQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 09:00:16 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D2D73CE9D52DCDF33171;
        Mon, 16 Mar 2020 21:00:01 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 16 Mar 2020
 20:59:55 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH 1/2] xfs: always init fdblocks in mount
Date:   Mon, 16 Mar 2020 21:07:07 +0800
Message-ID: <1584364028-122886-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
References: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
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
 fs/xfs/xfs_mount.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

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

