Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56724 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757983AbdAIPjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:24 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/32] xfs: check minimum block size for CRC filesystems
Date: Mon,  9 Jan 2017 16:38:37 +0100
Message-Id: <1483976343-661-7-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit bec9d48d7a303a5bb95c05961ff07ec7eeb59058 upstream.

Check the minimum block size on v5 filesystems.

[dchinner: cleaned up XFS_MIN_CRC_BLOCKSIZE check]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_sb.c    | 6 ++++++
 fs/xfs/libxfs/xfs_types.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7a39240..2580262 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -262,6 +262,12 @@ xfs_mount_validate_sb(
 		return -EFSCORRUPTED;
 	}
 
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
+		xfs_notice(mp, "v5 SB sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Until this is fixed only page-sized or smaller data blocks work.
 	 */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 8d74870..cf044c0 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -75,11 +75,14 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
  * The sectorsize upper limit is due to sizeof(sb_sectsize).
+ * CRC enable filesystems use 512 byte inodes, meaning 512 byte block sizes
+ * cannot be used.
  */
 #define XFS_MIN_BLOCKSIZE_LOG	9	/* i.e. 512 bytes */
 #define XFS_MAX_BLOCKSIZE_LOG	16	/* i.e. 65536 bytes */
 #define XFS_MIN_BLOCKSIZE	(1 << XFS_MIN_BLOCKSIZE_LOG)
 #define XFS_MAX_BLOCKSIZE	(1 << XFS_MAX_BLOCKSIZE_LOG)
+#define XFS_MIN_CRC_BLOCKSIZE	(1 << (XFS_MIN_BLOCKSIZE_LOG + 1))
 #define XFS_MIN_SECTORSIZE_LOG	9	/* i.e. 512 bytes */
 #define XFS_MAX_SECTORSIZE_LOG	15	/* i.e. 32768 bytes */
 #define XFS_MIN_SECTORSIZE	(1 << XFS_MIN_SECTORSIZE_LOG)
-- 
2.1.4

