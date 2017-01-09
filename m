Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938665AbdAIPkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:18 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 25/32] xfs: don't allow di_size with high bit set
Date: Mon,  9 Jan 2017 16:38:56 +0100
Message-Id: <1483976343-661-26-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit ef388e2054feedaeb05399ed654bdb06f385d294 upstream.

The on-disk field di_size is used to set i_size, which is a signed
integer of loff_t.  If the high bit of di_size is set, we'll end up with
a negative i_size, which will cause all sorts of problems.  Since the
VFS won't let us create a file with such length, we should catch them
here in the verifier too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 134424f..c906e50 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -392,6 +392,14 @@ xfs_dinode_verify(
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return false;
 
+	/* don't allow invalid i_size */
+	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
+		return false;
+
+	/* No zero-length symlinks. */
+	if (S_ISLNK(be16_to_cpu(dip->di_mode)) && dip->di_size == 0)
+		return false;
+
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
 		return true;
-- 
2.1.4

