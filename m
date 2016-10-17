Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47073 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938669AbcJQRco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 13:32:44 -0400
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] xfs: remove redundant assignment of ifp
Date: Mon, 17 Oct 2016 18:32:40 +0100
Message-Id: <20161017173240.26542-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Remove redundant ifp = ifp statement, it does nothing. Found with
static analysis by CoverityScan.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c27344c..0283b7e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5204,7 +5204,7 @@ xfs_bunmapi_cow(
 	ep = xfs_bmap_search_extents(ip, del->br_startoff, XFS_COW_FORK, &eof,
 			&eidx, &got, &new);
 
-	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK); ifp = ifp;
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	ASSERT((eidx >= 0) && (eidx < ifp->if_bytes /
 		(uint)sizeof(xfs_bmbt_rec_t)));
 	ASSERT(del->br_blockcount > 0);
-- 
2.9.3

