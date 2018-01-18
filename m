Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49694 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754736AbeARHmn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jan 2018 02:42:43 -0500
Subject: [PATCH 2/2] xfs: try to unshare extents before granting pnfs leases
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 23:42:39 -0800
Message-ID: <151626135947.25794.13152244142083119314.stgit@magnolia>
In-Reply-To: <151626134674.25794.7913544634631149739.stgit@magnolia>
References: <151626134674.25794.7913544634631149739.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@lst.de, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Try to unshare an extent before granting a lease to pnfs; if this isn't
possible, then bail out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_pnfs.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index aa6c5c1..a76140d 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -19,6 +19,7 @@
 #include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_pnfs.h"
+#include "xfs_reflink.h"
 
 /*
  * Ensure that we do not have any outstanding pNFS layouts that can be used by
@@ -110,13 +111,6 @@ xfs_fs_map_blocks(
 		return -ENXIO;
 
 	/*
-	 * The pNFS block layout spec actually supports reflink like
-	 * functionality, but the Linux pNFS server doesn't implement it yet.
-	 */
-	if (xfs_is_reflink_inode(ip))
-		return -ENXIO;
-
-	/*
 	 * Lock out any other I/O before we flush and invalidate the pagecache,
 	 * and then hand out a layout to the remote system.  This is very
 	 * similar to direct I/O, except that the synchronization is much more
@@ -125,6 +119,14 @@ xfs_fs_map_blocks(
 	 */
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
+	/* Try to unshare the blocks if we want write access */
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	if (write) {
+		error = xfs_reflink_unshare(ip, offset, length);
+		if (error)
+			goto out_unlock;
+	}
+
 	error = -EINVAL;
 	limit = mp->m_super->s_maxbytes;
 	if (!write)
@@ -140,7 +142,7 @@ xfs_fs_map_blocks(
 		goto out_unlock;
 	error = invalidate_inode_pages2(inode->i_mapping);
 	if (WARN_ON_ONCE(error))
-		return error;
+		goto out_unlock;
 
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -176,18 +178,32 @@ xfs_fs_map_blocks(
 			 * present even after a server crash.
 			 */
 			flags |= XFS_PREALLOC_SET | XFS_PREALLOC_SYNC;
+		} else {
+			bool	shared, trimmed;
+
+			/* Make sure the extent really isn't shared. */
+			error = xfs_reflink_trim_around_shared(ip, &imap,
+					&shared, &trimmed);
+			if (error)
+				goto out_unlock;
+			if (shared || trimmed) {
+				error = -ENXIO;
+				goto out_unlock;
+			}
 		}
 
 		error = xfs_update_prealloc_flags(ip, flags);
 		if (error)
 			goto out_unlock;
 	}
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 	xfs_bmbt_to_iomap(ip, iomap, &imap);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return error;
 }

