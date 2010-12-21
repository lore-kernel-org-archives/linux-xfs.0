Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7S25S244604 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:02 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B6521CE33C4
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:29:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	mEAqRKyQGOSiDn6u for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:29:57 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50575223-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 17:59:56 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfS-0001Cc-DI
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:54 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfH-0006Yt-1X
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/34] xfs: demultiplex xfs_icsb_modify_counters()
Date: Tue, 21 Dec 2010 18:29:01 +1100
Message-Id: <1292916570-25015-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

With the conversion to percpu counters, xfs_icsb_modify_counters() really does
not need to exist. Convert the inode counter modifications to use a common
helper function for the one place that calls them, and add another function for
the free block modification and convert all the callers to use that.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap.c  |   34 +++++-------
 fs/xfs/xfs_fsops.c |    3 +-
 fs/xfs/xfs_mount.c |  160 ++++++++++++++++++++++++---------------------------
 fs/xfs/xfs_mount.h |    5 +-
 fs/xfs/xfs_trans.c |   23 +++----
 5 files changed, 102 insertions(+), 123 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4111cd3..6a47556 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -614,8 +614,8 @@ xfs_bmap_add_extent(
 			nblks += cur->bc_private.b.allocated;
 		ASSERT(nblks <= da_old);
 		if (nblks < da_old)
-			xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
-				(int64_t)(da_old - nblks), rsvd);
+			xfs_icsb_modify_free_blocks(ip->i_mount,
+					(int64_t)(da_old - nblks), rsvd);
 	}
 	/*
 	 * Clear out the allocated field, done with it now in any case.
@@ -1079,7 +1079,7 @@ xfs_bmap_add_extent_delay_real(
 		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
-		    xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
+		    xfs_icsb_modify_free_blocks(ip->i_mount,
 					     -((int64_t)diff), rsvd)) {
 			/*
 			 * Ick gross gag me with a spoon.
@@ -1090,8 +1090,7 @@ xfs_bmap_add_extent_delay_real(
 					temp--;
 					diff--;
 					if (!diff ||
-					    !xfs_icsb_modify_counters(ip->i_mount,
-						    XFS_SBS_FDBLOCKS,
+					    !xfs_icsb_modify_free_blocks(ip->i_mount,
 						    -((int64_t)diff), rsvd))
 						break;
 				}
@@ -1099,8 +1098,7 @@ xfs_bmap_add_extent_delay_real(
 					temp2--;
 					diff--;
 					if (!diff ||
-					    !xfs_icsb_modify_counters(ip->i_mount,
-						    XFS_SBS_FDBLOCKS,
+					    !xfs_icsb_modify_free_blocks(ip->i_mount,
 						    -((int64_t)diff), rsvd))
 						break;
 				}
@@ -1769,8 +1767,8 @@ xfs_bmap_add_extent_hole_delay(
 	}
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
-		xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
-			(int64_t)(oldlen - newlen), rsvd);
+		xfs_icsb_modify_free_blocks(ip->i_mount,
+					(int64_t)(oldlen - newlen), rsvd);
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
@@ -3114,10 +3112,9 @@ xfs_bmap_del_extent(
 	 * Nothing to do for disk quota accounting here.
 	 */
 	ASSERT(da_old >= da_new);
-	if (da_old > da_new) {
-		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-			(int64_t)(da_old - da_new), rsvd);
-	}
+	if (da_old > da_new)
+		xfs_icsb_modify_free_blocks(ip->i_mount,
+					(int64_t)(da_old - da_new), rsvd);
 done:
 	*logflagsp = flags;
 	return error;
@@ -4530,14 +4527,12 @@ xfs_bmapi(
 							-((int64_t)extsz), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				} else {
-					error = xfs_icsb_modify_counters(mp,
-							XFS_SBS_FDBLOCKS,
+					error = xfs_icsb_modify_free_blocks(mp,
 							-((int64_t)alen), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				}
 				if (!error) {
-					error = xfs_icsb_modify_counters(mp,
-							XFS_SBS_FDBLOCKS,
+					error = xfs_icsb_modify_free_blocks(mp,
 							-((int64_t)indlen), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 					if (error && rt)
@@ -4546,8 +4541,7 @@ xfs_bmapi(
 							(int64_t)extsz, (flags &
 							XFS_BMAPI_RSVBLOCKS));
 					else if (error)
-						xfs_icsb_modify_counters(mp,
-							XFS_SBS_FDBLOCKS,
+						xfs_icsb_modify_free_blocks(mp,
 							(int64_t)alen, (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				}
@@ -5210,7 +5204,7 @@ xfs_bunmapi(
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
-				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+				xfs_icsb_modify_free_blocks(mp,
 						(int64_t)del.br_blockcount, rsvd);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index fb9a9c8..be34ff2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -596,8 +596,7 @@ out:
 		 * the extra reserve blocks from the reserve.....
 		 */
 		int error;
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-						 fdblks_delta, 0);
+		error = xfs_icsb_modify_free_blocks(mp, fdblks_delta, 0);
 		if (error == ENOSPC)
 			goto retry;
 	}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4a99e14..d5710232 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -332,6 +332,80 @@ xfs_icsb_sync_counters(
 		percpu_counter_sum_positive(&mp->m_icsb[XFS_ICSB_FDBLOCKS]);
 }
 
+int
+xfs_icsb_modify_inodes(
+	struct xfs_mount	*mp,
+	int			cntr,
+	int64_t			delta)
+{
+	int			ret;
+
+	ASSERT(cntr == XFS_ICSB_ICOUNT || cntr == XFS_ICSB_IFREE);
+
+	ret = percpu_counter_add_unless_lt(&mp->m_icsb[cntr],
+							delta, 0);
+	if (likely(ret >= 0))
+		return 0;
+	return ret;
+}
+
+int
+xfs_icsb_modify_free_blocks(
+	struct xfs_mount	*mp,
+	int64_t			delta,
+	int			rsvd)
+{
+	int64_t			lcounter;
+	int64_t			res_used;
+	int			ret;
+
+	/*
+	 * if we are putting blocks back, put them into the reserve
+	 * block pool first.
+	 */
+	if (unlikely(mp->m_resblks != mp->m_resblks_avail) && delta > 0) {
+		spin_lock(&mp->m_sb_lock);
+		res_used = (int64_t)(mp->m_resblks -
+					mp->m_resblks_avail);
+		if (res_used > delta) {
+			mp->m_resblks_avail += delta;
+			delta = 0;
+		} else {
+			delta -= res_used;
+			mp->m_resblks_avail = mp->m_resblks;
+		}
+		spin_unlock(&mp->m_sb_lock);
+		if (!delta)
+			return 0;
+	}
+
+	/* try the change */
+	ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_ICSB_FDBLOCKS],
+						delta, XFS_ALLOC_SET_ASIDE(mp));
+	if (likely(ret >= 0))
+		return 0;
+
+	/* ENOSPC */
+	ASSERT(delta < 0);
+
+	if (!rsvd)
+		return XFS_ERROR(ENOSPC);
+
+	spin_lock(&mp->m_sb_lock);
+	lcounter = (int64_t)mp->m_resblks_avail + delta;
+	if (lcounter >= 0) {
+		mp->m_resblks_avail = lcounter;
+		spin_unlock(&mp->m_sb_lock);
+		return 0;
+	}
+	spin_unlock(&mp->m_sb_lock);
+	printk_once(KERN_WARNING
+		"Filesystem \"%s\": reserve blocks depleted! "
+		"Consider increasing reserve pool size.",
+		mp->m_fsname);
+	return XFS_ERROR(ENOSPC);
+}
+
 /*
  * Check size of device based on the (data/realtime) block count.
  * Note: this check is used by the growfs code as well as mount.
@@ -1856,7 +1930,7 @@ xfs_mod_incore_sb(
  *
  * Note that this function may not be used for the superblock values that
  * are tracked with the in-memory per-cpu counters - a direct call to
- * xfs_icsb_modify_counters is required for these.
+ * xfs_icsb_modify_xxx is required for these.
  */
 int
 xfs_mod_incore_sb_batch(
@@ -1894,90 +1968,6 @@ unwind:
 	return error;
 }
 
-int
-xfs_icsb_modify_counters(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field,
-	int64_t		delta,
-	int		rsvd)
-{
-	int64_t		lcounter;
-	int64_t		res_used;
-	int		ret = 0;
-
-
-	switch (field) {
-	case XFS_SBS_ICOUNT:
-		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_SBS_ICOUNT],
-							delta, 0);
-		if (ret < 0) {
-			ASSERT(0);
-			return XFS_ERROR(EINVAL);
-		}
-		return 0;
-
-	case XFS_SBS_IFREE:
-		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_SBS_IFREE],
-							delta, 0);
-		if (ret < 0) {
-			ASSERT(0);
-			return XFS_ERROR(EINVAL);
-		}
-		return 0;
-
-	case XFS_SBS_FDBLOCKS:
-		/*
-		 * if we are putting blocks back, put them into the reserve
-		 * block pool first.
-		 */
-		if (mp->m_resblks != mp->m_resblks_avail && delta > 0) {
-			spin_lock(&mp->m_sb_lock);
-			res_used = (int64_t)(mp->m_resblks -
-						mp->m_resblks_avail);
-			if (res_used > delta) {
-				mp->m_resblks_avail += delta;
-				delta = 0;
-			} else {
-				delta -= res_used;
-				mp->m_resblks_avail = mp->m_resblks;
-			}
-			spin_unlock(&mp->m_sb_lock);
-			if (!delta)
-				return 0;
-		}
-
-		/* try the change */
-		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_ICSB_FDBLOCKS],
-						delta, XFS_ALLOC_SET_ASIDE(mp));
-		if (likely(ret >= 0))
-			return 0;
-
-		/* ENOSPC */
-		ASSERT(delta < 0);
-
-		if (!rsvd)
-			return XFS_ERROR(ENOSPC);
-
-		spin_lock(&mp->m_sb_lock);
-		lcounter = (int64_t)mp->m_resblks_avail + delta;
-		if (lcounter >= 0) {
-			mp->m_resblks_avail = lcounter;
-			spin_unlock(&mp->m_sb_lock);
-			return 0;
-		}
-		spin_unlock(&mp->m_sb_lock);
-		printk_once(KERN_WARNING
-			"Filesystem \"%s\": reserve blocks depleted! "
-			"Consider increasing reserve pool size.",
-			mp->m_fsname);
-		return XFS_ERROR(ENOSPC);
-	default:
-		ASSERT(0);
-		return XFS_ERROR(EINVAL);
-	}
-	return 0;
-}
-
 /*
  * xfs_getsb() is called to obtain the buffer for the superblock.
  * The buffer is returned locked and read in from disk.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 42d31df..03ad25c6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -75,9 +75,6 @@ enum {
 	XFS_ICSB_MAX,
 };
 
-extern int	xfs_icsb_modify_counters(struct xfs_mount *, xfs_sb_field_t,
-						int64_t, int);
-
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
@@ -333,6 +330,8 @@ extern int	xfs_icsb_init_counters(struct xfs_mount *);
 extern void	xfs_icsb_reinit_counters(struct xfs_mount *);
 extern void	xfs_icsb_destroy_counters(struct xfs_mount *);
 extern void	xfs_icsb_sync_counters(struct xfs_mount *);
+extern int	xfs_icsb_modify_inodes(struct xfs_mount *, int, int64_t);
+extern int	xfs_icsb_modify_free_blocks(struct xfs_mount *, int64_t, int);
 
 #endif	/* __KERNEL__ */
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f6d956b..8139a2e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -696,7 +696,7 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
+		error = xfs_icsb_modify_free_blocks(tp->t_mountp,
 					  -((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
@@ -767,8 +767,8 @@ undo_log:
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					 (int64_t)blocks, rsvd);
+		xfs_icsb_modify_free_blocks(tp->t_mountp,
+						(int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
 
@@ -1045,22 +1045,19 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply the per-cpu counters */
 	if (blkdelta) {
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-						 blkdelta, rsvd);
+		error = xfs_icsb_modify_free_blocks(mp, blkdelta, rsvd);
 		if (error)
 			goto out;
 	}
 
 	if (idelta) {
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT,
-						 idelta, rsvd);
+		error = xfs_icsb_modify_inodes(mp, XFS_ICSB_ICOUNT, idelta);
 		if (error)
 			goto out_undo_fdblocks;
 	}
 
 	if (ifreedelta) {
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_IFREE,
-						 ifreedelta, rsvd);
+		error = xfs_icsb_modify_inodes(mp, XFS_ICSB_IFREE, ifreedelta);
 		if (error)
 			goto out_undo_icount;
 	}
@@ -1129,15 +1126,15 @@ xfs_trans_unreserve_and_mod_sb(
 
 out_undo_ifreecount:
 	if (ifreedelta)
-		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, -ifreedelta, rsvd);
+		xfs_icsb_modify_inodes(mp, XFS_ICSB_IFREE, -ifreedelta);
 out_undo_icount:
 	if (idelta)
-		xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT, -idelta, rsvd);
+		xfs_icsb_modify_inodes(mp, XFS_ICSB_ICOUNT, -idelta);
 out_undo_fdblocks:
 	if (blkdelta)
-		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
+		xfs_icsb_modify_free_blocks(mp, -blkdelta, rsvd);
 out:
-	ASSERT(error = 0);
+	ASSERT(error == 0);
 	return;
 }
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
