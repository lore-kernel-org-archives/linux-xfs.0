Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E368FC11D04
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 11:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3D65208C4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 11:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgBTLGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 06:06:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10227 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726825AbgBTLGA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Feb 2020 06:06:00 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7E7EA6C25229BF3A2F2C;
        Thu, 20 Feb 2020 19:05:53 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 19:05:47 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <sandeen@sandeen.net>, <bfoster@redhat.com>, <dchinner@redhat.com>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <renxudong1@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v2] xfs: add agf freeblocks verify in xfs_agf_verify
Date:   Thu, 20 Feb 2020 19:13:02 +0800
Message-ID: <1582197182-142137-1-git-send-email-zhengbin13@huawei.com>
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
 fs/xfs/libxfs/xfs_alloc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d8053bc..5faed42 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2839,6 +2839,7 @@ xfs_agf_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(bp);
+	int i;

 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2858,6 +2859,22 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
 		return __this_address;

+	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks ||
+	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length) ||
+	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length) ||
+	    be32_to_cpu(agf->agf_refcount_blocks) > be32_to_cpu(agf->agf_length) ||
+	    be32_to_cpu(agf->agf_spare2) != 0)
+		return __this_address;
+
+	for (i = 0; i < ARRAY_SIZE(agf->agf_spare64); i++)
+		if (be64_to_cpu(agf->agf_spare64[i]) != 0)
+			return __this_address;
+
+	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
+	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length) ||
+	    be32_to_cpu(agf->agf_freeblks) > mp->m_sb.sb_fdblocks)
+		return __this_address;
+
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
--
2.7.4

