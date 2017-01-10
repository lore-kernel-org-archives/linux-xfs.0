Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35509 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936994AbdAJPjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 10:39:33 -0500
Received: by mail-wm0-f65.google.com with SMTP id l2so30686472wml.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 07:39:33 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v7 2/6] xfs: sanity check directory inode di_size
Date: Tue, 10 Jan 2017 17:39:13 +0200
Message-Id: <1484062757-12433-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
References: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

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
---
 fs/xfs/libxfs/xfs_dir2.c      | 3 ++-
 fs/xfs/libxfs/xfs_inode_buf.c | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index c58d72c..4f7913f 100644
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
index dd483e2..0091ac3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -386,6 +386,7 @@ xfs_dinode_verify(
 	xfs_ino_t		ino,
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
2.7.4

