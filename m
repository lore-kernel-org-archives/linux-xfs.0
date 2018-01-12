Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33065 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964832AbeALQhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 11:37:16 -0500
From: Colin King <colin.king@canonical.com>
Subject: [PATCH][xfs-next] xfs: fix check on struct_version for versions 4 or greater
Date: Fri, 12 Jan 2018 16:37:15 +0000
Message-Id: <20180112163715.27169-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

It appears that the check for versions 4 or more is incorrect and is
off-by-one. Fix this.

Detected by CoverityScan, CID#1463775 ("Logically dead code")

Fixes: ac503a4cc9e8 ("xfs: refactor the geometry structure filling function")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 35b005d66977..869a2f3f0375 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -951,7 +951,7 @@ xfs_fs_geometry(
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-	if (struct_version < 3)
+	if (struct_version < 4)
 		return 0;
 
 	if (xfs_sb_version_haslogv2(sbp))
-- 
2.15.1

