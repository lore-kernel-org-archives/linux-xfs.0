Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34665 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdBBH4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:56:42 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/19] xfs: sanity check directory inode di_size
Date: Thu,  2 Feb 2017 08:55:59 +0100
Message-Id: <1486022171-8076-8-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

From: Amir Goldstein <amir73il@gmail.com>

commit 3c6f46eacd876bd723a9bad3c6882714c052fd8e upstream.

This changes fixes an assertion hit when fuzzing on-disk
i_mode values.

The easy case to fix is when changing an empty file
i_mode to S_IFDIR. In this case, xfs_dinode_verify()
detects an illegal zero size for directory and fails
to load the inode structure from disk.

For the case of non empty file whose i_mode is changed
to S_IFDIR, the ASSERT() statement in xfs_dir2_isblock()
is replaced with return -EFSCORRUPTED, to avoid interacting
with corrupted jusk also when XFS_DEBUG is disabled.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c      | 3 ++-
 fs/xfs/libxfs/xfs_inode_buf.c | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 20a96dd..ec326d2 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -631,7 +631,8 @@ xfs_dir2_isblock(
 	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
-	ASSERT(rval == 0 || args->dp->i_d.di_size == args->geo->blksize);
+	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize)
+		return -EFSCORRUPTED;
 	*vp = rval;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c906e50..977245d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -386,6 +386,7 @@ xfs_dinode_verify(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	uint16_t		mode;
 	uint16_t		flags;
 	uint64_t		flags2;
 
@@ -396,8 +397,10 @@ xfs_dinode_verify(
 	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
 		return false;
 
-	/* No zero-length symlinks. */
-	if (S_ISLNK(be16_to_cpu(dip->di_mode)) && dip->di_size == 0)
+	mode = be16_to_cpu(dip->di_mode);
+
+	/* No zero-length symlinks/dirs. */
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
 		return false;
 
 	/* only version 3 or greater inodes are extensively verified here */
-- 
2.1.4

