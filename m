Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1D9C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 08:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8603761A55
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 08:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhKSIVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 03:21:00 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:13683 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234075AbhKSIU7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Nov 2021 03:20:59 -0500
X-UUID: 238683d19bac415d9c468d56e9c1c579-20211119
X-UUID: 238683d19bac415d9c468d56e9c1c579-20211119
X-User: zhangyue1@kylinos.cn
Received: from localhost.localdomain [(172.17.127.2)] by nksmu.kylinos.cn
        (envelope-from <zhangyue1@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 2112012704; Fri, 19 Nov 2021 16:26:34 +0800
From:   zhangyue <zhangyue1@kylinos.cn>
To:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: fix the problem that the array may be out of bound
Date:   Fri, 19 Nov 2021 16:17:58 +0800
Message-Id: <20211119081758.399167-1-zhangyue1@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In function 'xfs_btree_delrec()', if all data in array
'cur->bc_ptrs[level]' is 0, the 'level' may be greater than
or equal to 'XFS_BTREE_MAXLEVELS'.

At this time, the array may be out of bound.

Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
---
 fs/xfs/libxfs/xfs_btree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index bbdae2b4559f..fe66d1adc169 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3694,6 +3694,9 @@ xfs_btree_delrec(
 	tcur = NULL;
 
 	/* Get the index of the entry being deleted, check for nothing there. */
+	if (level >= XFS_BTREE_MAXLEVELS)
+		return -EFSCORRUPTED;
+
 	ptr = cur->bc_ptrs[level];
 	if (ptr == 0) {
 		*stat = 0;
-- 
2.30.0

