Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8U2P1Zh114023 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 21:25:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90BF7188D335
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 19:26:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AlFWNBIF9U2PREqz for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 19:26:01 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P18qP-0007wp-5K
	for xfs@oss.sgi.com; Thu, 30 Sep 2010 02:26:01 +0000
Message-Id: <20100930022600.975540107@bombadil.infradead.org>
Date: Wed, 29 Sep 2010 22:25:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] [PATCH 1/3] xfs: remove XFS_MOUNT_NO_PERCPU_SB
References: <20100930022553.391390964@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_MOUNT_NO_PERCPU_SB
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Fail the mount if we can't allocate memory for the per-CPU counters.
This is consistent with how we handle everything else in the mount
path and makes the superblock counter modification a lot simpler.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-09-29 20:44:11.711357120 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-09-30 08:11:46.119709459 +0900
@@ -1517,8 +1517,9 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_fsname;
 
-	if (xfs_icsb_init_counters(mp))
-		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
+	error = xfs_icsb_init_counters(mp);
+	if (error)
+		goto out_close_devices;
 
 	error = xfs_readsb(mp, flags);
 	if (error)
@@ -1579,6 +1580,7 @@ xfs_fs_fill_super(
 	xfs_freesb(mp);
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
+ out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
 	xfs_free_fsname(mp);
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-09-29 20:44:11.716357120 +0900
+++ xfs/fs/xfs/xfs_mount.c	2010-09-30 08:11:34.660709458 +0900
@@ -1856,12 +1856,8 @@ xfs_mod_incore_sb(
 	case XFS_SBS_ICOUNT:
 	case XFS_SBS_IFREE:
 	case XFS_SBS_FDBLOCKS:
-		if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-			status = xfs_icsb_modify_counters(mp, field,
-							delta, rsvd);
-			break;
-		}
-		/* FALLTHROUGH */
+		status = xfs_icsb_modify_counters(mp, field, delta, rsvd);
+		break;
 #endif
 	default:
 		spin_lock(&mp->m_sb_lock);
@@ -1910,15 +1906,12 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
 		case XFS_SBS_ICOUNT:
 		case XFS_SBS_IFREE:
 		case XFS_SBS_FDBLOCKS:
-			if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-				spin_unlock(&mp->m_sb_lock);
-				status = xfs_icsb_modify_counters(mp,
-							msbp->msb_field,
-							msbp->msb_delta, rsvd);
-				spin_lock(&mp->m_sb_lock);
-				break;
-			}
-			/* FALLTHROUGH */
+			spin_unlock(&mp->m_sb_lock);
+			status = xfs_icsb_modify_counters(mp,
+						msbp->msb_field,
+						msbp->msb_delta, rsvd);
+			spin_lock(&mp->m_sb_lock);
+			break;
 #endif
 		default:
 			status = xfs_mod_incore_sb_unlocked(mp,
@@ -1948,16 +1941,13 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
 			case XFS_SBS_ICOUNT:
 			case XFS_SBS_IFREE:
 			case XFS_SBS_FDBLOCKS:
-				if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-					spin_unlock(&mp->m_sb_lock);
-					status = xfs_icsb_modify_counters(mp,
-							msbp->msb_field,
-							-(msbp->msb_delta),
-							rsvd);
-					spin_lock(&mp->m_sb_lock);
-					break;
-				}
-				/* FALLTHROUGH */
+				spin_unlock(&mp->m_sb_lock);
+				status = xfs_icsb_modify_counters(mp,
+						msbp->msb_field,
+						-(msbp->msb_delta),
+						rsvd);
+				spin_lock(&mp->m_sb_lock);
+				break;
 #endif
 			default:
 				status = xfs_mod_incore_sb_unlocked(mp,
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2010-09-29 20:44:11.723357120 +0900
+++ xfs/fs/xfs/xfs_mount.h	2010-09-30 08:11:34.669709458 +0900
@@ -231,8 +231,6 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
 #define XFS_MOUNT_COMPAT_IOSIZE	(1ULL << 22)	/* don't report large preferred
 						 * I/O size in stat() */
-#define XFS_MOUNT_NO_PERCPU_SB	(1ULL << 23)	/* don't use per-cpu superblock
-						   counters */
 #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
 						   allocator */
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
