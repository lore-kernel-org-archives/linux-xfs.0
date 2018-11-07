Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:1838 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbeKGQBL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:11 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/16] xfs: expose block size in stat
Date: Wed,  7 Nov 2018 17:31:26 +1100
Message-Id: <20181107063127.3902-16-david@fromorbit.com>
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

For block size larger than page size, the unit of efficient IO is
the block size, not the page size. Leaving stat() to report
PAGE_SIZE as the block size causes test programs like fsx to issue
illegal ranges for operations that require block size alignemnt
(e.g. fallocate() insert range). Hence update the preferred IO size
to reflect the block size in this case.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7964513c3128..a323e362aeb6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -266,13 +266,18 @@ typedef struct xfs_mount {
 static inline unsigned long
 xfs_preferred_iosize(xfs_mount_t *mp)
 {
+	unsigned long	default_size = max_t(unsigned long, PAGE_SIZE,
+						mp->m_sb.sb_blocksize);
+
 	if (mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)
-		return PAGE_SIZE;
-	return (mp->m_swidth ?
-		(mp->m_swidth << mp->m_sb.sb_blocklog) :
-		((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ?
-			(1 << (int)max(mp->m_readio_log, mp->m_writeio_log)) :
-			PAGE_SIZE));
+		return default_size;
+
+	if (mp->m_swidth)
+		return mp->m_swidth << mp->m_sb.sb_blocklog;
+	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
+		return 1UL << max_t(int, mp->m_readio_log, mp->m_writeio_log);
+	return default_size;
+
 }
 
 #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
-- 
2.19.1
