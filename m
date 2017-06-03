Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58160 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCNLU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:11:20 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/23] xfs: drop iolock from reclaim context to appease lockdep
Date: Sat,  3 Jun 2017 15:10:44 +0200
Message-Id: <20170603131103.23712-5-hch@lst.de>
In-Reply-To: <20170603131103.23712-1-hch@lst.de>
References: <20170603131103.23712-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 3b4683c294095b5f777c03307ef8c60f47320e12 upstream.

Lockdep complains about use of the iolock in inode reclaim context
because it doesn't understand that reclaim has the last reference to
the inode, and thus an iolock->reclaim->iolock deadlock is not
possible.

The iolock is technically not necessary in xfs_inactive() and was
only added to appease an assert in xfs_free_eofblocks(), which can
be called from other non-reclaim contexts. Therefore, just kill the
assert and drop the use of the iolock from reclaim context to quiet
lockdep.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 8 +++-----
 fs/xfs/xfs_inode.c     | 9 +++++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 828532ce0adc..cad4e3e2df00 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -904,9 +904,9 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
 }
 
 /*
- * This is called by xfs_inactive to free any blocks beyond eof
- * when the link count isn't zero and by xfs_dm_punch_hole() when
- * punching a hole to EOF.
+ * This is called to free any blocks beyond eof. The caller must hold
+ * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
+ * reference to the inode.
  */
 int
 xfs_free_eofblocks(
@@ -921,8 +921,6 @@ xfs_free_eofblocks(
 	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-
 	/*
 	 * Figure out if there are any blocks beyond the end
 	 * of the file.  If not, then there is nothing to do.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7605d8396596..ec9826c56500 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1906,12 +1906,13 @@ xfs_inactive(
 		 * force is true because we are evicting an inode from the
 		 * cache. Post-eof blocks must be freed, lest we end up with
 		 * broken free space accounting.
+		 *
+		 * Note: don't bother with iolock here since lockdep complains
+		 * about acquiring it in reclaim context. We have the only
+		 * reference to the inode at this point anyways.
 		 */
-		if (xfs_can_free_eofblocks(ip, true)) {
-			xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		if (xfs_can_free_eofblocks(ip, true))
 			xfs_free_eofblocks(ip);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-		}
 
 		return;
 	}
-- 
2.11.0

