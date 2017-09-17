Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49419 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdIQVHQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:16 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/47] xfs: don't allow bmap on rt files
Date: Sun, 17 Sep 2017 14:06:32 -0700
Message-Id: <20170917210712.10804-8-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 61d819e7bcb7f33da710bf3f5dcb2bcf1e48203c upstream.

bmap returns a dumb LBA address but not the block device that goes with
that LBA.  Swapfiles don't care about this and will blindly assume that
the data volume is the correct blockdev, which is totally bogus for
files on the rt subvolume.  This results in the swap code doing IOs to
arbitrary locations on the data device(!) if the passed in mapping is a
realtime file, so just turn off bmap for rt files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 578981412615..f750d888bd17 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1566,9 +1566,12 @@ xfs_vm_bmap(
 	 * The swap code (ab-)uses ->bmap to get a block mapping and then
 	 * bypasseѕ the file system for actual I/O.  We really can't allow
 	 * that on reflinks inodes, so we have to skip out here.  And yes,
-	 * 0 is the magic code for a bmap error..
+	 * 0 is the magic code for a bmap error.
+	 *
+	 * Since we don't pass back blockdev info, we can't return bmap
+	 * information for rt files either.
 	 */
-	if (xfs_is_reflink_inode(ip)) {
+	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip)) {
 		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 		return 0;
 	}
-- 
2.14.1

