Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdDAGgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 02:36:33 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/26] xfs: fix uninitialized variable in _reflink_convert_cow
Date: Sat,  1 Apr 2017 08:35:04 +0200
Message-Id: <20170401063512.25313-19-hch@lst.de>
In-Reply-To: <20170401063512.25313-1-hch@lst.de>
References: <20170401063512.25313-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 93aaead52a9eebdc20dc8fa673c350e592a06949 upstream.

Fix an uninitialize variable.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d8c51248e207..22d631b08ee4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -363,7 +363,7 @@ xfs_reflink_convert_cow(
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
 	xfs_extnum_t		idx;
 	bool			found;
-	int			error;
+	int			error = 0;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-- 
2.11.0

