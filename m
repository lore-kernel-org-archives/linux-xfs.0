Return-Path: <SRS0=V5eY=2Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2E8C3F68F
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Dec 2019 13:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C904A20CC7
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Dec 2019 13:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfLZNsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Dec 2019 08:48:06 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8623 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726475AbfLZNsG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Dec 2019 08:48:06 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DA9A0EDE30359A9F38C2;
        Thu, 26 Dec 2019 21:48:01 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 26 Dec 2019
 21:47:55 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>, <bfoster@redhat.com>,
        <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <cmaiolino@redhat.com>, <hch@lst.de>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH 1/2] xfs: introduce xfs_bmap_split_da_extent
Date:   Thu, 26 Dec 2019 21:47:20 +0800
Message-ID: <20191226134721.43797-2-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191226134721.43797-1-yukuai3@huawei.com>
References: <20191226134721.43797-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a new function xfs_bmap_split_da_extent to split a delalloc extent
into two delalloc extents.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 26 ++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h |  1 +
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4c2e046fbfad..8247054c1e2b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6117,7 +6117,7 @@ xfs_bmap_split_extent_at(
 	/*
 	 * Convert to a btree if necessary.
 	 */
-	if (xfs_bmap_needs_btree(ip, whichfork)) {
+	if (tp && xfs_bmap_needs_btree(ip, whichfork)) {
 		int tmp_logflags; /* partial log flag return val */
 
 		ASSERT(cur == NULL);
@@ -6132,7 +6132,7 @@ xfs_bmap_split_extent_at(
 		xfs_btree_del_cursor(cur, error);
 	}
 
-	if (logflags)
+	if (tp && logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	return error;
 }
@@ -6165,6 +6165,28 @@ xfs_bmap_split_extent(
 	return error;
 }
 
+/*
+ * Splits a delalloc extent into two delalloc extents at split_fsb block
+ * such that it is the first block of the current_ext. Caller has to make
+ * sure split_fsb belong to a delalloc extent.
+ * If split_fsb is not the first block of the extent, caller need to sub
+ * the @ip->i_d.di_nextents to prevent crash in log recovery.
+ */
+int
+xfs_bmap_split_da_extent(
+	struct xfs_inode        *ip,
+	xfs_fileoff_t           split_fsb)
+{
+	struct xfs_trans        *tp = NULL;
+	int error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_bmap_split_extent_at(tp, ip, split_fsb);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return error;
+}
+
 /* Deferred mapping is only for real extents in the data fork. */
 static bool
 xfs_bmap_is_update_needed(
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 14d25e0b7d9c..d8d969aa17ef 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -223,6 +223,7 @@ int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		bool *done, xfs_fileoff_t stop_fsb);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
+int	xfs_bmap_split_da_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
-- 
2.17.2

