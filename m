Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36989 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbcKEALA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:11:00 -0400
Subject: [PATCH 10/10] xfs: check minimum block size for CRC filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:10:57 -0700
Message-ID: <147830465785.27129.17151401159795461152.stgit@birch.djwong.org>
In-Reply-To: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
References: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Check the minimum block size on v5 filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c    |    7 +++++++
 fs/xfs/libxfs/xfs_types.h |    3 +++
 2 files changed, 10 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7a39240..49b03e6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -262,6 +262,13 @@ xfs_mount_validate_sb(
 		return -EFSCORRUPTED;
 	}
 
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    unlikely(
+	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE)) {
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

