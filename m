Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbdDAGfe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 02:35:34 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/26] xfs: fix toctou race when locking an inode to access the data map
Date: Sat,  1 Apr 2017 08:34:50 +0200
Message-Id: <20170401063512.25313-5-hch@lst.de>
In-Reply-To: <20170401063512.25313-1-hch@lst.de>
References: <20170401063512.25313-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4b5bd5bf3fb182dc504b1b64e0331300f156e756 upstream.

We use di_format and if_flags to decide whether we're grabbing the ilock
in btree mode (btree extents not loaded) or shared mode (anything else),
but the state of those fields can be changed by other threads that are
also trying to load the btree extents -- IFEXTENTS gets set before the
_bmap_read_extents call and cleared if it fails.

We don't actually need to have IFEXTENTS set until after the bmbt
records are successfully loaded and validated, which will fix the race
between multiple threads trying to read the same directory.  The next
patch strengthens directory bmbt validation by refusing to open the
directory if reading the bmbt to start directory readahead fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 222e103356c6..421341f93bea 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -497,15 +497,14 @@ xfs_iread_extents(
 	 * We know that the size is valid (it's checked in iformat_btree)
 	 */
 	ifp->if_bytes = ifp->if_real_bytes = 0;
-	ifp->if_flags |= XFS_IFEXTENTS;
 	xfs_iext_add(ifp, 0, nextents);
 	error = xfs_bmap_read_extents(tp, ip, whichfork);
 	if (error) {
 		xfs_iext_destroy(ifp);
-		ifp->if_flags &= ~XFS_IFEXTENTS;
 		return error;
 	}
 	xfs_validate_extents(ifp, nextents, XFS_EXTFMT_INODE(ip));
+	ifp->if_flags |= XFS_IFEXTENTS;
 	return 0;
 }
 /*
-- 
2.11.0

