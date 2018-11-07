Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63760 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728363AbeKGQBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:17 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/16] xfs: enable block size larger than page size support
Date: Wed,  7 Nov 2018 17:31:27 +1100
Message-Id: <20181107063127.3902-17-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c |  2 ++
 fs/xfs/xfs_mount.c     | 11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b5a82acd7dfe..e0881545a929 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -354,6 +354,7 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
+#if 0
 	/*
 	 * Until this is fixed only page-sized or smaller data blocks work.
 	 */
@@ -364,6 +365,7 @@ xfs_validate_sb_common(
 				sbp->sb_blocksize, PAGE_SIZE);
 		return -ENOSYS;
 	}
+#endif
 
 	/*
 	 * Currently only very few inode sizes are supported.
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 02d15098dbee..e0d95d56f776 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -164,7 +164,16 @@ xfs_sb_validate_fsb_count(
 	xfs_sb_t	*sbp,
 	uint64_t	nblocks)
 {
-	ASSERT(PAGE_SHIFT >= sbp->sb_blocklog);
+	int		shift = PAGE_SHIFT - sbp->sb_blocklog;
+
+	/*
+	 * block size larger than page size still limited to page cache
+	 * page size limits.
+	 */
+	if (shift < 0)
+		shift = 0;
+
+	//ASSERT(PAGE_SHIFT >= sbp->sb_blocklog);
 	ASSERT(sbp->sb_blocklog >= BBSHIFT);
 
 	/* Limited by ULONG_MAX of page cache index */
-- 
2.19.1
