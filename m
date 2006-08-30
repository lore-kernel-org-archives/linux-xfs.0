Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Aug 2006 19:17:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7U2GnDW004594
	for <xfs@oss.sgi.com>; Tue, 29 Aug 2006 19:17:03 -0700
Date: Wed, 30 Aug 2006 12:15:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: Prevent free space oversubscription
Message-ID: <20060830021532.GF5737019@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com, Stephane Doyon <sdoyon@max-t.com>, Luciano Chavez <lnx1138@us.ibm.com>


The fix for recent ENOSPC deadlocks introduced certain limitations
on allocations. The fix could cause  xfssyndc to loop endlessly if
we did not leave some space free for the allocator to work
correctly. Basically, we needed to ensure that we had at least 4
blocks free for an AG free list and a block for the inode bmap btree
at all times.

However, this did not take into account the fact that each AG has a
free list that needs 4 blocks. Hence any filesystem with more than
one AG could cause oversubscription of free space and make xfssyncd
spin forever trying to allocate space needed for AG freelists that
was not available in the AG.

The following patch reserves space for the free lists in all AGs
plus the inode bmap btree which prevents oversubscription. It also
prevents those blocks from being reported as free space (as they can
never be used) and makes the SMP in-core superblock accounting code and
the reserved block ioctl respect this requirement.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_alloc.h  |   20 ++++++++++++++++++++
 fs/xfs/xfs_fsops.c  |   16 ++++++++++------
 fs/xfs/xfs_mount.c  |   32 ++++++++------------------------
 fs/xfs/xfs_vfsops.c |    3 ++-
 4 files changed, 40 insertions(+), 31 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-08-18 15:29:28.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-08-29 15:02:41.986914155 +1000
@@ -1243,24 +1243,6 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
-/*
- * In order to avoid ENOSPC-related deadlock caused by
- * out-of-order locking of AGF buffer (PV 947395), we place
- * constraints on the relationship among actual allocations for
- * data blocks, freelist blocks, and potential file data bmap
- * btree blocks. However, these restrictions may result in no
- * actual space allocated for a delayed extent, for example, a data
- * block in a certain AG is allocated but there is no additional
- * block for the additional bmap btree block due to a split of the
- * bmap btree of the file. The result of this may lead to an
- * infinite loop in xfssyncd when the file gets flushed to disk and
- * all delayed extents need to be actually allocated. To get around
- * this, we explicitly set aside a few blocks which will not be
- * reserved in delayed allocation. Considering the minimum number of
- * needed freelist blocks is 4 fsbs, a potential split of file's bmap
- * btree requires 1 fsb, so we set the number of set-aside blocks to 8.
-*/
-#define SET_ASIDE_BLOCKS 8
 
 /*
  * xfs_mod_incore_sb_unlocked() is a utility routine common used to apply
@@ -1306,7 +1288,8 @@ xfs_mod_incore_sb_unlocked(xfs_mount_t *
 		return 0;
 	case XFS_SBS_FDBLOCKS:
 
-		lcounter = (long long)mp->m_sb.sb_fdblocks - SET_ASIDE_BLOCKS;
+		lcounter = (long long)
+			mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
 
 		if (delta > 0) {		/* Putting blocks back */
@@ -1340,7 +1323,7 @@ xfs_mod_incore_sb_unlocked(xfs_mount_t *
 			}
 		}
 
-		mp->m_sb.sb_fdblocks = lcounter + SET_ASIDE_BLOCKS;
+		mp->m_sb.sb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
 		return 0;
 	case XFS_SBS_FREXTENTS:
 		lcounter = (long long)mp->m_sb.sb_frextents;
@@ -2019,7 +2002,8 @@ xfs_icsb_sync_counters_lazy(
  * when we get near ENOSPC.
  */
 #define XFS_ICSB_INO_CNTR_REENABLE	64
-#define XFS_ICSB_FDBLK_CNTR_REENABLE	512
+#define XFS_ICSB_FDBLK_CNTR_REENABLE(mp) \
+		(512 + XFS_ALLOC_SET_ASIDE(mp))
 STATIC void
 xfs_icsb_balance_counter(
 	xfs_mount_t	*mp,
@@ -2053,7 +2037,7 @@ xfs_icsb_balance_counter(
 	case XFS_SBS_FDBLOCKS:
 		count = mp->m_sb.sb_fdblocks;
 		resid = do_div(count, weight);
-		if (count < XFS_ICSB_FDBLK_CNTR_REENABLE)
+		if (count < XFS_ICSB_FDBLK_CNTR_REENABLE(mp))
 			goto out;
 		break;
 	default:
@@ -2108,11 +2092,11 @@ again:
 	case XFS_SBS_FDBLOCKS:
 		BUG_ON((mp->m_resblks - mp->m_resblks_avail) != 0);
 
-		lcounter = icsbp->icsb_fdblocks;
+		lcounter = icsbp->icsb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 		lcounter += delta;
 		if (unlikely(lcounter < 0))
 			goto slow_path;
-		icsbp->icsb_fdblocks = lcounter;
+		icsbp->icsb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
 		break;
 	default:
 		BUG();
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.h	2006-05-29 14:46:25.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.h	2006-08-29 11:13:49.776378306 +1000
@@ -44,6 +44,26 @@ typedef enum xfs_alloctype
 #define	XFS_ALLOC_FLAG_FREEING	0x00000002  /* indicate caller is freeing extents*/
 
 /*
+ * In order to avoid ENOSPC-related deadlock caused by
+ * out-of-order locking of AGF buffer (PV 947395), we place
+ * constraints on the relationship among actual allocations for
+ * data blocks, freelist blocks, and potential file data bmap
+ * btree blocks. However, these restrictions may result in no
+ * actual space allocated for a delayed extent, for example, a data
+ * block in a certain AG is allocated but there is no additional
+ * block for the additional bmap btree block due to a split of the
+ * bmap btree of the file. The result of this may lead to an
+ * infinite loop in xfssyncd when the file gets flushed to disk and
+ * all delayed extents need to be actually allocated. To get around
+ * this, we explicitly set aside a few blocks which will not be
+ * reserved in delayed allocation. Considering the minimum number of
+ * needed freelist blocks is 4 fsbs _per AG_, a potential split of file's bmap
+ * btree requires 1 fsb, so we set the number of set-aside blocks
+ * to 4 + 4*agcount.
+ */
+#define XFS_ALLOC_SET_ASIDE(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
+
+/*
  * Argument structure for xfs_alloc routines.
  * This is turned into a structure to avoid having 20 arguments passed
  * down several levels of the stack.
Index: 2.6.x-xfs-new/fs/xfs/xfs_fsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fsops.c	2006-08-18 15:29:27.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fsops.c	2006-08-29 11:11:29.250743927 +1000
@@ -462,7 +462,7 @@ xfs_fs_counts(
 
 	xfs_icsb_sync_counters_lazy(mp);
 	s = XFS_SB_LOCK(mp);
-	cnt->freedata = mp->m_sb.sb_fdblocks;
+	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	cnt->freeino = mp->m_sb.sb_ifree;
 	cnt->allocino = mp->m_sb.sb_icount;
@@ -519,15 +519,19 @@ xfs_reserve_blocks(
 		}
 		mp->m_resblks = request;
 	} else {
+		__int64_t	free;
+
+		free =  mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 		delta = request - mp->m_resblks;
-		lcounter = mp->m_sb.sb_fdblocks - delta;
+		lcounter = free - delta;
 		if (lcounter < 0) {
 			/* We can't satisfy the request, just get what we can */
-			mp->m_resblks += mp->m_sb.sb_fdblocks;
-			mp->m_resblks_avail += mp->m_sb.sb_fdblocks;
-			mp->m_sb.sb_fdblocks = 0;
+			mp->m_resblks += free;
+			mp->m_resblks_avail += free;
+			mp->m_sb.sb_fdblocks = XFS_ALLOC_SET_ASIDE(mp);
 		} else {
-			mp->m_sb.sb_fdblocks = lcounter;
+			mp->m_sb.sb_fdblocks =
+				lcounter + XFS_ALLOC_SET_ASIDE(mp);
 			mp->m_resblks = request;
 			mp->m_resblks_avail += delta;
 		}
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2006-08-18 15:29:29.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2006-08-29 11:05:32.433399426 +1000
@@ -811,7 +811,8 @@ xfs_statvfs(
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
 	statp->f_blocks = sbp->sb_dblocks - lsize;
-	statp->f_bfree = statp->f_bavail = sbp->sb_fdblocks;
+	statp->f_bfree = statp->f_bavail =
+				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;
 #if XFS_BIG_INUMS
 	fakeinos += mp->m_inoadd;
