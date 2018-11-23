Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49789 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391367AbeKXDoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Nov 2018 22:44:18 -0500
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] xfs: clean up indentation issues, remove an unwanted space
Date: Fri, 23 Nov 2018 16:59:13 +0000
Message-Id: <20181123165913.26671-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a statement that has an unwanted space in the indentation.
Remove it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05db9540e459..f21756751540 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2242,7 +2242,7 @@ xfs_ifree_cluster(
 		 * want it to fail. We can acheive this by adding a write
 		 * verifier to the buffer.
 		 */
-		 bp->b_ops = &xfs_inode_buf_ops;
+		bp->b_ops = &xfs_inode_buf_ops;
 
 		/*
 		 * Walk the inodes already attached to the buffer and mark them
-- 
2.19.1
