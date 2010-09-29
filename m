Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T7LeEK029162 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 02:21:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1F4C188473A
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 00:22:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ob8DHqLVyktu42dG for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 00:22:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P0qzu-0003ZI-1k
	for xfs@oss.sgi.com; Wed, 29 Sep 2010 07:22:38 +0000
Message-Id: <20100929072237.865681186@bombadil.infradead.org>
Date: Wed, 29 Sep 2010 03:22:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] [PATCH 1/3] xfs: remove XFS_MOUNT_NO_PERCPU_SB
References: <20100929072221.583672974@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-09-29 12:37:32.562557720 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-09-29 12:38:33.154557727 +0900
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
--- xfs.orig/fs/xfs/xfs_mount.c	2010-09-29 12:37:39.846557721 +0900
+++ xfs/fs/xfs/xfs_mount.c	2010-09-29 12:39:12.376557727 +0900
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
--- xfs.orig/fs/xfs/xfs_mount.h	2010-09-29 12:37:50.782557721 +0900
+++ xfs/fs/xfs/xfs_mount.h	2010-09-29 12:39:18.410558090 +0900
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
