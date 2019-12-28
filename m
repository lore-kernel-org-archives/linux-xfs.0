Return-Path: <SRS0=BnrD=2S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA680C2D0C8
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Dec 2019 03:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD8CE206E4
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Dec 2019 03:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfL1Des (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Dec 2019 22:34:48 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:37682 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfL1Des (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Dec 2019 22:34:48 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 60220C96481FAD65F11E;
        Sat, 28 Dec 2019 11:34:46 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Sat, 28 Dec 2019
 11:34:39 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>, <bfoster@redhat.com>,
        <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <cmaiolino@redhat.com>, <hch@lst.de>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH V2] xfs: fix stale data exposure problem when punch hole, collapse range or zero range across a delalloc extent
Date:   Sat, 28 Dec 2019 11:34:04 +0800
Message-ID: <20191228033404.14654-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In xfs_file_fallocate, when punch hole, zero range or collapse range is
performed, xfs_fulsh_unmap_range() need to be called first. However,
xfs_map_blocks will convert the whole extent to real, even if there are
some blocks not related. Furthermore, the unrelated blocks will hold stale
data since xfs_fulsh_unmap_range didn't flush the correspond dirty pages
to disk.

In this case, if user shutdown file system through xfsioctl with cmd
'XFS_IOC_GOINGDOWN' and arg 'XFS_FSOP_GOING_FLAGS_LOGFLUSH'. All the
completed transactions will be flushed to disk, while dirty pages will
never be flushed to disk. And after remount, the file will hold stale
data.

Fix the problem by spliting delalloc extent before xfs_flush_unmap_range
is called.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---

Changes in V2:
I thought no transaction need to commit when we split a da extent. However,
kernel test robot found that it will cause xfs/011 failed:
XFS: Assertion failed: XFS_FORCED_SHUTDOWN(mp) || percpu_counter_sum(
&mp->m_delalloc_blks) == 0, file: fs/xfs/xfs_super.c, line: 1037
see details in https://patchwork.kernel.org/patch/11310513/

Delete the patch "xfs: introduce xfs_bmap_split_da_extent" and use
xfs_bmap_split_extent instead.

 fs/xfs/xfs_file.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c93250108952..e53da982ca7a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -786,6 +786,50 @@ xfs_break_layouts(
 
 	return error;
 }
+static int
+try_split_da_extent(
+	struct xfs_inode	*ip,
+	loff_t			offset,
+	loff_t			len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		start = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end = XFS_B_TO_FSBT(mp, offset + len - 1);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_iext_cursor	cur;
+	struct xfs_bmbt_irec	imap;
+	int error;
+
+	/*
+	 * if start belong to a delalloc extent and it's not the first block,
+	 * split the extent at start.
+	 */
+	if (xfs_iext_lookup_extent(ip, ifp, start, &cur, &imap) &&
+	    imap.br_startblock != HOLESTARTBLOCK &&
+	    isnullstartblock(imap.br_startblock) &&
+	    start > imap.br_startoff) {
+		error = xfs_bmap_split_extent(ip, start);
+		if (error)
+			return error;
+		ip->i_d.di_nextents--;
+	}
+
+	/*
+	 * if end + 1 belong to a delalloc extent and it's not the first block,
+	 * split the extent at end + 1.
+	 */
+	if (xfs_iext_lookup_extent(ip, ifp, end + 1, &cur, &imap) &&
+	    imap.br_startblock != HOLESTARTBLOCK &&
+	    isnullstartblock(imap.br_startblock) &&
+	    end + 1 > imap.br_startoff) {
+		error = xfs_bmap_split_extent(ip, end + 1);
+		if (error)
+			return error;
+		ip->i_d.di_nextents--;
+	}
+
+	return 0;
+}
 
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
@@ -842,6 +886,9 @@ xfs_file_fallocate(
 	 */
 	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
 		    FALLOC_FL_COLLAPSE_RANGE)) {
+		error = try_split_da_extent(ip, offset, len);
+		if (error)
+			goto out_unlock;
 		error = xfs_flush_unmap_range(ip, offset, len);
 		if (error)
 			goto out_unlock;
-- 
2.17.2

