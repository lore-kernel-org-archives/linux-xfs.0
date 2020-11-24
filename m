Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BAEC2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 10:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6524E206F9
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 10:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732217AbgKXKp7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 05:45:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8023 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731939AbgKXKp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 05:45:59 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CgLJy2dMSzhYvw;
        Tue, 24 Nov 2020 18:45:38 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.208) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 18:45:47 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/2] xfs: check the return value of krealloc()
Date:   Tue, 24 Nov 2020 18:45:30 +0800
Message-ID: <20201124104531.561-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20201124104531.561-1-thunder.leizhen@huawei.com>
References: <20201124104531.561-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.208]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

krealloc() may fail to expand the memory space. Add sanity checks to it,
and WARN() if that really happened.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7575de5cecb1..4e457aea8493 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -366,6 +366,8 @@ xfs_iroot_realloc(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (rec_diff > 0) {
+		struct xfs_btree_block *if_broot;
+
 		/*
 		 * If there wasn't any memory allocated before, just
 		 * allocate it now and get out.
@@ -386,8 +388,13 @@ xfs_iroot_realloc(
 		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
-		ifp->if_broot = krealloc(ifp->if_broot, new_size,
-					 GFP_NOFS | __GFP_NOFAIL);
+		if_broot = krealloc(ifp->if_broot, new_size,
+				    GFP_NOFS | __GFP_NOFAIL);
+		if (!if_broot) {
+			WARN(1, "if_broot realloc failed\n");
+			return;
+		}
+		ifp->if_broot = if_broot;
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -477,6 +484,7 @@ xfs_idata_realloc(
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int64_t			new_size = ifp->if_bytes + byte_diff;
+	char *if_data;
 
 	ASSERT(new_size >= 0);
 	ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));
@@ -496,8 +504,13 @@ xfs_idata_realloc(
 	 * in size so that it can be logged and stay on word boundaries.
 	 * We enforce that here.
 	 */
-	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
+	if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
 				      GFP_NOFS | __GFP_NOFAIL);
+	if (!if_data) {
+		WARN(1, "if_data realloc failed\n");
+		return;
+	}
+	ifp->if_u1.if_data = if_data;
 	ifp->if_bytes = new_size;
 }
 
-- 
2.26.0.106.g9fadedd


