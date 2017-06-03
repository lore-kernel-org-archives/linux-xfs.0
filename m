Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49007 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdFCNQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:16:02 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/23] xfs: bad assertion for delalloc an extent that start at i_size
Date: Sat,  3 Jun 2017 15:15:04 +0200
Message-Id: <20170603131511.25032-17-hch@lst.de>
In-Reply-To: <20170603131511.25032-1-hch@lst.de>
References: <20170603131511.25032-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Zorro Lang <zlang@redhat.com>

commit 892d2a5f705723b2cb488bfb38bcbdcf83273184 upstream.

By run fsstress long enough time enough in RHEL-7, I find an
assertion failure (harder to reproduce on linux-4.11, but problem
is still there):

  XFS: Assertion failed: (iflags & BMV_IF_DELALLOC) != 0, file: fs/xfs/xfs_bmap_util.c

The assertion is in xfs_getbmap() funciton:

  if (map[i].br_startblock == DELAYSTARTBLOCK &&
-->   map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
          ASSERT((iflags & BMV_IF_DELALLOC) != 0);

When map[i].br_startoff == XFS_B_TO_FSB(mp, XFS_ISIZE(ip)), the
startoff is just at EOF. But we only need to make sure delalloc
extents that are within EOF, not include EOF.

Signed-off-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9581e90fd559..70fbecbb2845 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -717,7 +717,7 @@ xfs_getbmap(
 			 * extents.
 			 */
 			if (map[i].br_startblock == DELAYSTARTBLOCK &&
-			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+			    map[i].br_startoff < XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
 				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
 
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
-- 
2.11.0

