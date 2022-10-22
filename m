Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594C4C38A2D
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Oct 2022 01:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJVBlu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 21:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJVBlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 21:41:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D12C2A17F8
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 18:41:48 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MvPBc0QhpzJn1g;
        Sat, 22 Oct 2022 09:39:04 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 22 Oct
 2022 09:41:45 +0800
Date:   Sat, 22 Oct 2022 10:03:45 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>,
        <linux-xfs@vger.kernel.org>, <leo.lilong@huawei.com>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH v1] xfs: fix sb write verify for lazysbcount
Message-ID: <20221022020345.GA2699923@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When lazysbcount is enabled, multiple threads stress test the xfs report
the following problems:

XFS (loop0): SB summary counter sanity check failed
XFS (loop0): Metadata corruption detected at xfs_sb_write_verify
	     +0x13b/0x460, xfs_sb block 0x0
XFS (loop0): Unmount and run xfs_repair
XFS (loop0): First 128 bytes of corrupted metadata buffer:
00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
XFS (loop0): Please unmount the filesystem and rectify the problem(s)
XFS (loop0): log mount/recovery failed: error -117
XFS (loop0): log mount failed

The cause of the problem is that during the log recovery process, incorrect
icount and ifree are recovered from the log and fail to pass the size check
in xfs_validate_sb_write().

With lazysbcount is enabled, There is no additional lock protection for
reading m_ifree and m_icount in xfs_log_sb(), if other threads modifies
the m_ifree between the read m_icount and the m_ifree, this will make the
m_ifree larger than m_icount and written to the log. If we have an unclean
shutdown, this will be corrected by xfs_initialize_perag_data() rebuilding
the counters from the AGF block counts, and the correction is later than
log recovery. During log recovery, incorrect ifree/icount may be restored
from the log and written to the super block, since ifree and icount have
not been corrected at this time, the relationship between ifree and icount
cannot be checked in xfs_validate_sb_write().

So, don't check the size between ifree and icount in xfs_validate_sb_write()
when lazysbcount is enabled.

Fixes: 8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a20cade590e9..b4a4e57361e7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -245,7 +245,7 @@ xfs_validate_sb_write(
 	if (xfs_buf_daddr(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
 	    (sbp->sb_fdblocks > sbp->sb_dblocks ||
 	     !xfs_verify_icount(mp, sbp->sb_icount) ||
-	     sbp->sb_ifree > sbp->sb_icount)) {
+	     (!xfs_has_lazysbcount(mp) && sbp->sb_ifree > sbp->sb_icount))) {
 		xfs_warn(mp, "SB summary counter sanity check failed");
 		return -EFSCORRUPTED;
 	}
-- 
2.31.1

