Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C583C11D2A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 04:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D5D824656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 04:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgBUEkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 23:40:13 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:43070 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729229AbgBUEkN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Feb 2020 23:40:13 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3D5AB1C728F956295E84;
        Fri, 21 Feb 2020 12:40:10 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 21 Feb 2020
 12:40:00 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <sandeen@sandeen.net>, <bfoster@redhat.com>, <dchinner@redhat.com>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <renxudong1@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v3] xfs: add agf freeblocks verify in xfs_agf_verify
Date:   Fri, 21 Feb 2020 12:47:15 +0800
Message-ID: <1582260435-20939-1-git-send-email-zhengbin13@huawei.com>
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

xfs_repair information(just one AG):
agf_freeblks 0, counted 3224 in ag 0
agf_longest 536874136, counted 3224 in ag 0
sb_fdblocks 613, counted 3228

Test as follows:
mount tmp.img tmpdir
cp file1M tmpdir
sync

In 4.19-stable, sync will stuck, the reason is:
xfs_mountfs
  xfs_check_summary_counts
    if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
       XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
       !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
	return 0;  -->just return, incore sb_fdblocks still be 613
    xfs_initialize_perag_data

cp file1M tmpdir -->ok(write file to pagecache)
sync -->stuck(write pagecache to disk)
xfs_map_blocks
  xfs_iomap_write_allocate
    while (count_fsb != 0) {
      nimaps = 0;
      while (nimaps == 0) { --> endless loop
         nimaps = 1;
         xfs_bmapi_write(..., &nimaps) --> nimaps becomes 0 again
xfs_bmapi_write
  xfs_bmap_alloc
    xfs_bmap_btalloc
      xfs_alloc_vextent
        xfs_alloc_fix_freelist
          xfs_alloc_space_available -->fail(agf_freeblks is 0)

In linux-next, sync not stuck, cause commit c2b3164320b5 ("xfs:
use the latest extent at writeback delalloc conversion time") remove
the above while, dmesg is as follows:
[   55.250114] XFS (loop0): page discard on page ffffea0008bc7380, inode 0x1b0c, offset 0.

Users do not know why this page is discard, the better soultion is:
1. Like xfs_repair, make sure sb_fdblocks is equal to counted
(xfs_initialize_perag_data did this, who is not called at this mount)
2. Add agf verify, if fail, will tell users to repair

This patch use the second soultion.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: Ren Xudong <renxudong1@huawei.com>
---

v1->v2: modify comment, add more agf verify
v2->v3: modify code which is suggested by hellwig & darrick
besides, remove the agf_freeblks < sb_fdblocks check, sb_fdblocks may not be true,
if we have lazysbcount or not umount clean. If we check this, we need to add
if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
    XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
like function xfs_check_summary_counts does.

 fs/xfs/libxfs/xfs_alloc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d8053bc..183dc25 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2858,6 +2858,13 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
 		return __this_address;

+	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
+		return __this_address;
+
+	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
+	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
+		return __this_address;
+
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
@@ -2869,6 +2876,10 @@ xfs_agf_verify(
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
 		return __this_address;

+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
+		return __this_address;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2883,6 +2894,11 @@ xfs_agf_verify(
 		return __this_address;

 	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_blocks) >
+	    be32_to_cpu(agf->agf_length))
+		return __this_address;
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
 	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
 		return __this_address;
--
2.7.4

