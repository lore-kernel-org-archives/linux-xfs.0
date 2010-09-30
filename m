Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8U2P258114034 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 21:25:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D461D188D339
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 19:26:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jH9Llqj7UP4ipMn8 for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 19:26:01 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P18qP-0007xL-Et
	for xfs@oss.sgi.com; Thu, 30 Sep 2010 02:26:01 +0000
Message-Id: <20100930022601.268875972@bombadil.infradead.org>
Date: Wed, 29 Sep 2010 22:25:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] [PATCH 2/3] xfs: do not use xfs_mod_incore_sb for per-cpu
	counters
References: <20100930022553.391390964@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-dont-use-xfs_mod_incore_sb-for-percpu-counters
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

Export xfs_icsb_modify_counters and always use it for modifying the per-cpu
counters.  Remove support for per-cpu counters from xfs_mod_incore_sb to
simplify it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-09-30 08:11:34.638709458 +0900
+++ xfs/fs/xfs/xfs_bmap.c	2010-09-30 08:12:38.111709458 +0900
@@ -614,7 +614,7 @@ xfs_bmap_add_extent(
 			nblks += cur->bc_private.b.allocated;
 		ASSERT(nblks <= da_old);
 		if (nblks < da_old)
-			xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
+			xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
 				(int64_t)(da_old - nblks), rsvd);
 	}
 	/*
@@ -1079,7 +1079,8 @@ xfs_bmap_add_extent_delay_real(
 		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
-		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {
+		    xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
+					     -((int64_t)diff), rsvd)) {
 			/*
 			 * Ick gross gag me with a spoon.
 			 */
@@ -1089,16 +1090,18 @@ xfs_bmap_add_extent_delay_real(
 					temp--;
 					diff--;
 					if (!diff ||
-					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
+					    !xfs_icsb_modify_counters(ip->i_mount,
+						    XFS_SBS_FDBLOCKS,
+						    -((int64_t)diff), rsvd))
 						break;
 				}
 				if (temp2) {
 					temp2--;
 					diff--;
 					if (!diff ||
-					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
+					    !xfs_icsb_modify_counters(ip->i_mount,
+						    XFS_SBS_FDBLOCKS,
+						    -((int64_t)diff), rsvd))
 						break;
 				}
 			}
@@ -1766,7 +1769,7 @@ xfs_bmap_add_extent_hole_delay(
 	}
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
-		xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
+		xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
 			(int64_t)(oldlen - newlen), rsvd);
 		/*
 		 * Nothing to do for disk quota accounting here.
@@ -3111,9 +3114,10 @@ xfs_bmap_del_extent(
 	 * Nothing to do for disk quota accounting here.
 	 */
 	ASSERT(da_old >= da_new);
-	if (da_old > da_new)
-		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int64_t)(da_old - da_new),
-			rsvd);
+	if (da_old > da_new) {
+		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+			(int64_t)(da_old - da_new), rsvd);
+	}
 done:
 	*logflagsp = flags;
 	return error;
@@ -4526,13 +4530,13 @@ xfs_bmapi(
 							-((int64_t)extsz), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				} else {
-					error = xfs_mod_incore_sb(mp,
+					error = xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
 							-((int64_t)alen), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				}
 				if (!error) {
-					error = xfs_mod_incore_sb(mp,
+					error = xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
 							-((int64_t)indlen), (flags &
 							XFS_BMAPI_RSVBLOCKS));
@@ -4542,7 +4546,7 @@ xfs_bmapi(
 							(int64_t)extsz, (flags &
 							XFS_BMAPI_RSVBLOCKS));
 					else if (error)
-						xfs_mod_incore_sb(mp,
+						xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
 							(int64_t)alen, (flags &
 							XFS_BMAPI_RSVBLOCKS));
@@ -5206,7 +5210,7 @@ xfs_bunmapi(
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
-				xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS,
+				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
 						(int64_t)del.br_blockcount, rsvd);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2010-09-30 08:11:34.653709458 +0900
+++ xfs/fs/xfs/xfs_fsops.c	2010-09-30 08:11:54.328709458 +0900
@@ -596,7 +596,8 @@ out:
 		 * the extra reserve blocks from the reserve.....
 		 */
 		int error;
-		error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, fdblks_delta, 0);
+		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+						 fdblks_delta, 0);
 		if (error == ENOSPC)
 			goto retry;
 	}
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-09-30 08:11:34.660709458 +0900
+++ xfs/fs/xfs/xfs_mount.c	2010-09-30 08:11:54.332709458 +0900
@@ -52,16 +52,11 @@ STATIC void	xfs_icsb_balance_counter(xfs
 						int);
 STATIC void	xfs_icsb_balance_counter_locked(xfs_mount_t *, xfs_sb_field_t,
 						int);
-STATIC int	xfs_icsb_modify_counters(xfs_mount_t *, xfs_sb_field_t,
-						int64_t, int);
 STATIC void	xfs_icsb_disable_counter(xfs_mount_t *, xfs_sb_field_t);
-
 #else
 
 #define xfs_icsb_balance_counter(mp, a, b)		do { } while (0)
 #define xfs_icsb_balance_counter_locked(mp, a, b)	do { } while (0)
-#define xfs_icsb_modify_counters(mp, a, b, c)		do { } while (0)
-
 #endif
 
 static const struct {
@@ -1843,28 +1838,19 @@ xfs_mod_incore_sb_unlocked(
  */
 int
 xfs_mod_incore_sb(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field,
-	int64_t		delta,
-	int		rsvd)
+	struct xfs_mount	*mp,
+	xfs_sb_field_t		field,
+	int64_t			delta,
+	int			rsvd)
 {
-	int	status;
+	int			status;
 
-	/* check for per-cpu counters */
-	switch (field) {
 #ifdef HAVE_PERCPU_SB
-	case XFS_SBS_ICOUNT:
-	case XFS_SBS_IFREE:
-	case XFS_SBS_FDBLOCKS:
-		status = xfs_icsb_modify_counters(mp, field, delta, rsvd);
-		break;
+	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
 #endif
-	default:
-		spin_lock(&mp->m_sb_lock);
-		status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
-		spin_unlock(&mp->m_sb_lock);
-		break;
-	}
+	spin_lock(&mp->m_sb_lock);
+	status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
+	spin_unlock(&mp->m_sb_lock);
 
 	return status;
 }
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2010-09-30 08:11:34.669709458 +0900
+++ xfs/fs/xfs/xfs_mount.h	2010-09-30 08:11:54.336709458 +0900
@@ -90,6 +90,8 @@ extern void	xfs_icsb_reinit_counters(str
 extern void	xfs_icsb_destroy_counters(struct xfs_mount *);
 extern void	xfs_icsb_sync_counters(struct xfs_mount *, int);
 extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
+extern int	xfs_icsb_modify_counters(struct xfs_mount *, xfs_sb_field_t,
+						int64_t, int);
 
 #else
 #define xfs_icsb_init_counters(mp)		(0)
@@ -97,6 +99,8 @@ extern void	xfs_icsb_sync_counters_locke
 #define xfs_icsb_reinit_counters(mp)		do { } while (0)
 #define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
 #define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
+#define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
+	xfs_mod_incore_sb(mp, field, delta, rsvd)
 #endif
 
 typedef struct xfs_mount {
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-09-30 08:11:34.682709458 +0900
+++ xfs/fs/xfs/xfs_trans.c	2010-09-30 08:11:54.342709458 +0900
@@ -696,7 +696,7 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
+		error = xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
 					  -((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
@@ -767,7 +767,7 @@ undo_log:
 
 undo_blocks:
 	if (blocks > 0) {
-		(void) xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
+		xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
 					 (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
