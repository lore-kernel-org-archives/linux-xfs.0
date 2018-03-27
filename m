Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47438 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbeC0OkC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 10:40:02 -0400
From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] xfs: fix zero'ing of ILOG owner bits by using correct bitwise operator
Date: Tue, 27 Mar 2018 15:40:01 +0100
Message-Id: <20180327144001.14074-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the masking of the ili_fields is using the ! operator which
results in masking with 0, which clears all the bits which is not
intended.  Instead, use the ~ operator that negates the inverts the
bits to correctly mask out the XFS_ILOG_AOWNER and XFS_ILOG_DOWNER
bits.

Detected by CoverityScan, CID#1466877 ("Logical vs bitwise operator")

Fixes: 3fdf96830762 ("xfs: do not log swapext extent owner changes for deleted")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a16f48fde4da..3e3aab3888fa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2477,7 +2477,7 @@ xfs_ifree(
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	/* Don't attempt to replay owner changes for a deleted inode */
-	ip->i_itemp->ili_fields &= !(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
+	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
 
 	/*
 	 * Bump the generation count so no one will be confused
-- 
2.15.1

