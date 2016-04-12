Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C8BB7CA6
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 11:42:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 962758F8035
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id F6JInF6ITs0FzCaf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:55 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 07/10] xfs: adopt a reserved allocation model on
	dm-thin devices
Date: Tue, 12 Apr 2016 12:42:50 -0400
Message-Id: <1460479373-63317-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com

Adopt a reservation-based block allocation model when XFS runs on top of
a dm-thin device with accompanying support. As of today, the filesystem
has no indication of available space in the underlying device. If the
thin pool is depleted, the filesystem has no recourse but to handle the
read-only state change of the device. This results in unexpected higher
level behavior, error returns and can result in data loss if the
filesystem is ultimately shutdown before more space is provisioned to
the pool.

The reservation model enables XFS to manage thin pool space similar to
how delayed allocation blocks are managed today. Delalloc blocks are
reserved up front (e.g., at write time) to guarantee physical space is
available at writeback time and thus prevent data loss due to
overprovisioning. Similarly, block device reservation allows XFS to
reserve space for various operations in advance and thus guarantee an
operation will not fail for lack of space, or otherwise return an error
to the user.

To accomplish this, tie in the device block reservation calls to the
existing filesystem reservation mechanism. Each transaction now reserves
physical space in the underlying thin pool along with other such
reserved resources (e.g., filesystem blocks, log space). Delayed
allocation blocks are similarly reserved in the thin device when the
associated filesystem blocks are reserved. If a reservation cannot be
satisfied, the associated operation returns -ENOSPC as if the filesystem
itself were out of space.

Note that this is proof-of-concept and highly experimental. The purpose
is to explore the potential effectiveness of such a scheme between the
filesystem and a thinly provisioned device. As such, the implementation
is hacky, broken and geared towards proof-of-concept over correctness or
completeness.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  25 +++++++++++
 fs/xfs/xfs_mount.c        | 103 +++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_mount.h        |   3 ++
 fs/xfs/xfs_trans.c        |  77 +++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trans.h        |   1 +
 5 files changed, 193 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a708e38..af21c93 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -35,6 +35,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_thin.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -652,6 +653,30 @@ xfs_alloc_ag_vextent(
 				 XFS_TRANS_SB_RES_FDBLOCKS :
 				 XFS_TRANS_SB_FDBLOCKS,
 				 -((long)(args->len)));
+
+		if (args->mp->m_thin_reserve) {
+			sector_t	res;
+			xfs_fsblock_t	fsbno = XFS_AGB_TO_FSB(args->mp,
+							       args->agno,
+							       args->agbno);
+			if (args->wasdel)
+				res = xfs_fsb_res(args->mp, args->len, false);
+			else
+				res = args->tp->t_blk_thin_res;
+			error = xfs_thin_provision(args->mp, fsbno, args->len,
+						   &res);
+			WARN_ON(error);
+
+			if (args->wasdel) {
+				if (res)
+					error = xfs_thin_unreserve(args->mp, res);
+				WARN_ON(error);
+			} else if (args->tp) {
+				args->tp->t_blk_thin_res = res;
+			}
+
+			error = 0;
+		}
 	}
 
 	XFS_STATS_INC(args->mp, xs_allocx);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 50a6ccc..d2d9c85 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -41,6 +41,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_sysfs.h"
+#include "xfs_thin.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -929,6 +930,8 @@ xfs_mountfs(
 		xfs_qm_mount_quotas(mp);
 	}
 
+	xfs_thin_init(mp);
+
 	/*
 	 * Now we are mounted, reserve a small amount of unused space for
 	 * privileged transactions. This is needed so that transaction
@@ -1147,7 +1150,7 @@ xfs_mod_ifree(
  */
 #define XFS_FDBLOCKS_BATCH	1024
 int
-xfs_mod_fdblocks(
+__xfs_mod_fdblocks(
 	struct xfs_mount	*mp,
 	int64_t			delta,
 	uint32_t		flags)
@@ -1156,13 +1159,27 @@ xfs_mod_fdblocks(
 	long long		res_used;
 	s32			batch;
 	bool			rsvd = (flags & XFS_FDBLOCKS_RSVD);
+	bool			blkres = (flags & XFS_BLK_RES);
+	int			error;
+	int64_t			res_delta = 0;
+
+	ASSERT(!(rsvd && !blkres && delta < 0));
 
 	if (delta > 0) {
 		/*
-		 * If the reserve pool is depleted, put blocks back into it
-		 * first. Most of the time the pool is full.
+		 * If the reserve pool is full (the typical case), return the
+		 * blocks to the general fs pool. Otherwise, return what we can
+		 * to the reserve pool first.
 		 */
 		if (likely(mp->m_resblks == mp->m_resblks_avail)) {
+main_pool:
+			if (mp->m_thin_reserve && blkres) {
+				error = xfs_thin_unreserve(mp,
+						xfs_fsb_res(mp, delta, false));
+				if (error)
+					return error;
+			}
+
 			percpu_counter_add(&mp->m_fdblocks, delta);
 			return 0;
 		}
@@ -1170,17 +1187,69 @@ xfs_mod_fdblocks(
 		spin_lock(&mp->m_sb_lock);
 		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
 
-		if (res_used > delta) {
-			mp->m_resblks_avail += delta;
+		/*
+		 * The reserve pool is not full. Blocks in the reserve pool must
+		 * hold a bdev reservation which means we may need to re-reserve
+		 * blocks depending on what the caller is giving us.
+		 *
+		 * If the blocks are already reserved (i.e., via a transaction
+		 * reservation), simply update the reserve pool counter. If not,
+		 * reserve as many blocks as we can, return those to the reserve
+		 * pool, and then jump back above to return whatever is left
+		 * back to the general filesystem pool.
+		 */
+		if (!blkres) {
+			while (delta) {
+				if (res_delta >= res_used)
+					break;
+
+				spin_unlock(&mp->m_sb_lock);
+
+				/*
+				 * XXX: This is racy/leaky. Somebody else could
+				 * replenish m_resblks_avail once we've dropped
+				 * the lock.
+				 */
+				error = xfs_thin_reserve(mp,
+						xfs_fsb_res(mp, 1, false));
+				if (error) {
+					spin_lock(&mp->m_sb_lock);
+					break;
+				}
+
+				spin_lock(&mp->m_sb_lock);
+
+				res_delta++;
+				delta--;
+				res_used = (long long)(mp->m_resblks -
+							mp->m_resblks_avail);
+			}
 		} else {
-			delta -= res_used;
-			mp->m_resblks_avail = mp->m_resblks;
-			percpu_counter_add(&mp->m_fdblocks, delta);
+			res_delta = min(delta, res_used);
+			delta -= res_delta;
 		}
+
+		if (res_used > res_delta)
+			mp->m_resblks_avail += res_delta;
+		else
+			mp->m_resblks_avail = mp->m_resblks;
 		spin_unlock(&mp->m_sb_lock);
+		if (delta)
+			goto main_pool;
 		return 0;
 	}
 
+	/* res calls take positive value */
+	if (mp->m_thin_reserve && blkres) {
+		error = xfs_thin_reserve(mp, xfs_fsb_res(mp, -delta, false));
+		if (error == -ENOSPC && rsvd) {
+			spin_lock(&mp->m_sb_lock);
+			goto fdblocks_rsvd;
+		}
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Taking blocks away, need to be more accurate the closer we
 	 * are to zero.
@@ -1203,14 +1272,17 @@ xfs_mod_fdblocks(
 	}
 
 	/*
-	 * lock up the sb for dipping into reserves before releasing the space
-	 * that took us to ENOSPC.
+	 * Release bdev reservation then lock up the sb for dipping into local
+	 * reserves before releasing the space that took us to ENOSPC.
 	 */
+	if (mp->m_thin_reserve && blkres)
+		error = xfs_thin_unreserve(mp, xfs_fsb_res(mp, -delta, false));
 	spin_lock(&mp->m_sb_lock);
 	percpu_counter_add(&mp->m_fdblocks, -delta);
 	if (!rsvd)
 		goto fdblocks_enospc;
 
+fdblocks_rsvd:
 	lcounter = (long long)mp->m_resblks_avail + delta;
 	if (lcounter >= 0) {
 		mp->m_resblks_avail = lcounter;
@@ -1227,6 +1299,17 @@ fdblocks_enospc:
 }
 
 int
+xfs_mod_fdblocks(
+	struct xfs_mount	*mp,
+	int64_t			delta,
+	uint32_t		flags)
+{
+	/* unres is the common case */
+	flags |= XFS_BLK_RES;
+	return __xfs_mod_fdblocks(mp, delta, flags);
+}
+
+int
 xfs_mod_frextents(
 	struct xfs_mount	*mp,
 	int64_t			delta)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8d54c56..958f815 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -354,6 +354,9 @@ extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
 extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
 
 #define	XFS_FDBLOCKS_RSVD	(1 << 0)
+#define XFS_BLK_RES		(1 << 1)
+extern int	__xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
+				   uint32_t flags);
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 uint32_t flags);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8aa9d9a..26e6288 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -31,6 +31,7 @@
 #include "xfs_log.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_thin.h"
 
 kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
@@ -174,6 +175,7 @@ xfs_trans_reserve(
 {
 	int			error = 0;
 	int			flags = 0;
+	struct xfs_mount	*mp = tp->t_mountp;
 
 	if (tp->t_flags & XFS_TRANS_RESERVE)
 		flags |= XFS_FDBLOCKS_RSVD;
@@ -187,13 +189,14 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks),
-					 flags);
+		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), flags);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 			return -ENOSPC;
 		}
 		tp->t_blk_res += blocks;
+		if (mp->m_thin_res)
+			tp->t_blk_thin_res += xfs_fsb_res(mp, blocks, false);
 	}
 
 	/*
@@ -265,6 +268,8 @@ undo_blocks:
 	if (blocks > 0) {
 		xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), flags);
 		tp->t_blk_res = 0;
+		if (tp->t_blk_thin_res)
+			tp->t_blk_thin_res = 0;
 	}
 
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
@@ -551,6 +556,7 @@ xfs_trans_unreserve_and_mod_sb(
 	int64_t			rtxdelta = 0;
 	int64_t			idelta = 0;
 	int64_t			ifreedelta = 0;
+	int64_t			resdelta = 0;
 	int			error;
 	int			flags = 0;
 
@@ -558,8 +564,41 @@ xfs_trans_unreserve_and_mod_sb(
 		flags |= XFS_FDBLOCKS_RSVD;
 
 	/* calculate deltas */
-	if (tp->t_blk_res > 0)
-		blkdelta = tp->t_blk_res;
+	if (tp->t_blk_res > 0) {
+		/*
+		 * The transaction may have some number of unused fs blocks and
+		 * unused bdev reservation. It might also have non-reserved free
+		 * blocks (i.e., freed extents) that need to make it back into
+		 * the fs general pool. We need to distinguish between these
+		 * cases when unwinding the unused resources.
+		 *
+		 * We do this as follows:
+		 *
+		 * - resdelta - For every unused fs block and bdev reservation
+		 *   combination, account one fs+bdev reserved block that can be
+		 *   returned to the fs. These are blocks that can go directly
+		 *   back into the XFS reserve pool, if necessary, because they
+		 *   are already reserved. If the reserve pool is full, they are
+		 *   unreserved and returned to the general pool.
+		 * - blkdelta - Freed filesystem blocks without any bdev
+		 *   reservation. These can get into the XFS reserve pool as
+		 *   well, but they are reserved from the bdev first. If
+		 *   reservation fails, they are returned to the general pool.
+		 * - t_blk_thin_res - Unused bdev reservation from the
+		 *   transaction. Extra bdev reservation remains when newly
+		 *   allocated fs blocks might have already been provisioned in
+		 *   the bdev (due to larger bdev blocks). This reservation is
+		 *   returned directly to the bdev.
+		 */
+		blkdelta = tp->t_blk_res - tp->t_blk_res_used;
+		while (blkdelta && tp->t_blk_thin_res) {
+			tp->t_blk_thin_res -= xfs_fsb_res(mp, 1, false);
+			blkdelta--;
+			resdelta++;
+		}
+		blkdelta = tp->t_blk_res - resdelta;
+	}
+
 	if ((tp->t_fdblocks_delta != 0) &&
 	    (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
 	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
@@ -578,11 +617,34 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	/* apply the per-cpu counters */
-	if (blkdelta) {
-		error = xfs_mod_fdblocks(mp, blkdelta, flags);
+	if (resdelta) {
+		error = __xfs_mod_fdblocks(mp, resdelta, flags | XFS_BLK_RES);
 		if (error)
 			goto out;
 	}
+	/*
+	 * Return any bdev reservation that hasn't been returned in the form of
+	 * reserved blocks above. Do this before returning unreserved blocks to
+	 * improve the chance that bdev reservation is available if the XFS
+	 * reserve pool must be replenished.
+	 *
+	 * XXX: This logic is kind of wonky now that the bdev res. is tracked
+	 * separately. If we have a bunch of freed blocks, can't we just return
+	 * however many we have reservation for as 'reserved blocks?' Also need
+	 * to fix up the code above to kill the while loop.
+	 */
+	if (tp->t_blk_thin_res) {
+		error = xfs_thin_unreserve(mp, tp->t_blk_thin_res);
+		if (error)
+			goto out_undo_resblocks;
+		tp->t_blk_thin_res = 0;
+	}
+
+	if (blkdelta) {
+		error = __xfs_mod_fdblocks(mp, blkdelta, flags);
+		if (error)
+			goto out_undo_resblocks;
+	}
 
 	if (idelta) {
 		error = xfs_mod_icount(mp, idelta);
@@ -688,6 +750,9 @@ out_undo_icount:
 out_undo_fdblocks:
 	if (blkdelta)
 		xfs_mod_fdblocks(mp, -blkdelta, flags);
+out_undo_resblocks:
+	if (resdelta)
+		xfs_mod_fdblocks(mp, -resdelta, flags);
 out:
 	ASSERT(error == 0);
 	return;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index e7c49cf..18685d9 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -95,6 +95,7 @@ typedef struct xfs_trans {
 	unsigned int		t_log_count;	/* count for perm log res */
 	unsigned int		t_blk_res;	/* # of blocks resvd */
 	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
+	unsigned int		t_blk_thin_res;
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
