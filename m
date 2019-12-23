Return-Path: <SRS0=dkq6=2N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A4EC2D0C0
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Dec 2019 07:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09445206CB
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Dec 2019 07:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfLWHtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Dec 2019 02:49:04 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:41742 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbfLWHtE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Dec 2019 02:49:04 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6929C8ABB801E1B18161;
        Mon, 23 Dec 2019 15:49:01 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 23 Dec 2019
 15:48:55 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] xfs: change return value of xfs_inode_need_cow to int
Date:   Mon, 23 Dec 2019 15:56:16 +0800
Message-ID: <1577087776-59093-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fixes coccicheck warning:

fs/xfs/xfs_reflink.c:236:9-10: WARNING: return of 0/1 in function 'xfs_inode_need_cow' with return type bool

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 fs/xfs/xfs_reflink.c | 2 +-
 fs/xfs/xfs_reflink.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index de45123..21eeb94 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -223,7 +223,7 @@ xfs_reflink_trim_around_shared(
 	}
 }

-bool
+int
 xfs_inode_need_cow(
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*imap,
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index d18ad7f..9a288b2 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -22,7 +22,7 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
-bool xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
+int xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
 		bool *shared);

 int xfs_reflink_allocate_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
--
2.7.4

