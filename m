Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U3ejTV125410 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 22:40:45 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18F843000C6
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:42:50 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id j6motbFJ43Mb85b4 for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:42:50 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 9E3A39E98B7
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 22:42:49 -0500 (CDT)
Message-ID: <4BDA51B9.4010501@sandeen.net>
Date: Thu, 29 Apr 2010 22:42:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: replace E2BIG with EFBIG where appropriate
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Many places in the xfs code return E2BIG when they really
mean EFBIG; trying to grow past 16T on a 32 bit machine,
for example, says "Argument list too long" rather than "File
too large" which is not particularly helpful.

Some of these don't make perfect sense as EFBIG either,
but still better than E2BIG IMHO.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e79b56b..c415ffd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -268,10 +268,10 @@ xfs_sb_validate_fsb_count(
 
 #if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
 	if (nblocks >> (PAGE_CACHE_SHIFT - sbp->sb_blocklog) > ULONG_MAX)
-		return E2BIG;
+		return EFBIG;
 #else                  /* Limited by UINT_MAX of sectors */
 	if (nblocks << (sbp->sb_blocklog - BBSHIFT) > UINT_MAX)
-		return E2BIG;
+		return EFBIG;
 #endif
 	return 0;
 }
@@ -393,7 +393,7 @@ xfs_mount_validate_sb(
 	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
 		xfs_fs_mount_cmn_err(flags,
 			"file system too large to be mounted on this system.");
-		return XFS_ERROR(E2BIG);
+		return XFS_ERROR(EFBIG);
 	}
 
 	if (unlikely(sbp->sb_inprogress)) {
@@ -1009,7 +1009,7 @@ xfs_check_sizes(xfs_mount_t *mp)
 	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
 		cmn_err(CE_WARN, "XFS: size check 1 failed");
-		return XFS_ERROR(E2BIG);
+		return XFS_ERROR(EFBIG);
 	}
 	error = xfs_read_buf(mp, mp->m_ddev_targp,
 			     d - XFS_FSS_TO_BB(mp, 1),
@@ -1019,7 +1019,7 @@ xfs_check_sizes(xfs_mount_t *mp)
 	} else {
 		cmn_err(CE_WARN, "XFS: size check 2 failed");
 		if (error == ENOSPC)
-			error = XFS_ERROR(E2BIG);
+			error = XFS_ERROR(EFBIG);
 		return error;
 	}
 
@@ -1027,7 +1027,7 @@ xfs_check_sizes(xfs_mount_t *mp)
 		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
 			cmn_err(CE_WARN, "XFS: size check 3 failed");
-			return XFS_ERROR(E2BIG);
+			return XFS_ERROR(EFBIG);
 		}
 		error = xfs_read_buf(mp, mp->m_logdev_targp,
 				     d - XFS_FSB_TO_BB(mp, 1),
@@ -1037,7 +1037,7 @@ xfs_check_sizes(xfs_mount_t *mp)
 		} else {
 			cmn_err(CE_WARN, "XFS: size check 3 failed");
 			if (error == ENOSPC)
-				error = XFS_ERROR(E2BIG);
+				error = XFS_ERROR(EFBIG);
 			return error;
 		}
 	}
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6be05f7..1644551 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2247,7 +2247,7 @@ xfs_rtmount_init(
 		cmn_err(CE_WARN, "XFS: realtime mount -- %llu != %llu",
 			(unsigned long long) XFS_BB_TO_FSB(mp, d),
 			(unsigned long long) mp->m_sb.sb_rblocks);
-		return XFS_ERROR(E2BIG);
+		return XFS_ERROR(EFBIG);
 	}
 	error = xfs_read_buf(mp, mp->m_rtdev_targp,
 				d - XFS_FSB_TO_BB(mp, 1),
@@ -2256,7 +2256,7 @@ xfs_rtmount_init(
 		cmn_err(CE_WARN,
 	"XFS: realtime mount -- xfs_read_buf failed, returned %d", error);
 		if (error == ENOSPC)
-			return XFS_ERROR(E2BIG);
+			return XFS_ERROR(EFBIG);
 		return error;
 	}
 	xfs_buf_relse(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
