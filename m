Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E7407CA1
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 021728F8059
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YLfbfrG4wujx16w7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:40 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 9/9] xfs: adopt a reserved allocation model on dm-thin
	devices
Date: Thu, 17 Mar 2016 10:30:37 -0400
Message-Id: <1458225037-24155-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
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
satisfied, the associated operation returns -ENOSPC precisely as if the
filesystem itself were out of space.

Note that this is proof-of-concept and highly experimental. The purpose
is to explore the potential effectiveness of such a scheme between the
filesystem and a thinly provisioned device. As such, the implementation
is hacky, broken and geared towards proof-of-concept over correctness or
completeness.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  6 ++++
 fs/xfs/xfs_mount.c        | 81 +++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_mount.h        |  2 ++
 fs/xfs/xfs_trans.c        | 26 +++++++++++++--
 4 files changed, 103 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a708e38..2497fd3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -35,6 +35,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_thin.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -2650,6 +2651,11 @@ xfs_alloc_vextent(
 				goto error0;
 		}
 
+		if (mp->m_thin_reserve) {
+			error = xfs_thin_provision(mp, args->fsbno, args->len);
+			WARN_ON(error);
+			error = 0;
+		}
 	}
 	xfs_perag_put(args->pag);
 	return 0;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bb753b3..98c437b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -41,6 +41,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_sysfs.h"
+#include "xfs_thin.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -947,6 +948,8 @@ xfs_mountfs(
 		xfs_qm_mount_quotas(mp);
 	}
 
+	xfs_thin_init(mp);
+
 	/*
 	 * Now we are mounted, reserve a small amount of unused space for
 	 * privileged transactions. This is needed so that transaction
@@ -1165,21 +1168,32 @@ xfs_mod_ifree(
  */
 #define XFS_FDBLOCKS_BATCH	1024
 int
-xfs_mod_fdblocks(
+__xfs_mod_fdblocks(
 	struct xfs_mount	*mp,
 	int64_t			delta,
-	bool			rsvd)
+	bool			rsvd,
+	bool			unres)
 {
 	int64_t			lcounter;
 	long long		res_used;
 	s32			batch;
+	int			error;
+	int64_t			res_delta = 0;
 
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
+			if (mp->m_thin_reserve && unres) {
+				error = xfs_thin_unreserve(mp, delta);
+				if (error)
+					return error;
+			}
+
 			percpu_counter_add(&mp->m_fdblocks, delta);
 			return 0;
 		}
@@ -1187,17 +1201,56 @@ xfs_mod_fdblocks(
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
+		if (!unres) {
+			while (!unres && delta) {
+				if (res_delta >= res_used)
+					break;
+
+				/* XXX: shouldn't call this w/ m_sb_lock */
+				error = xfs_thin_reserve(mp, 1);
+				if (error)
+					break;
+
+				res_delta++;
+				delta--;
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
+	if (mp->m_thin_reserve) {
+		error = xfs_thin_reserve(mp, -delta);
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
@@ -1228,6 +1281,7 @@ xfs_mod_fdblocks(
 	if (!rsvd)
 		goto fdblocks_enospc;
 
+fdblocks_rsvd:
 	lcounter = (long long)mp->m_resblks_avail + delta;
 	if (lcounter >= 0) {
 		mp->m_resblks_avail = lcounter;
@@ -1244,6 +1298,15 @@ fdblocks_enospc:
 }
 
 int
+xfs_mod_fdblocks(
+	struct xfs_mount	*mp,
+	int64_t			delta,
+	bool			rsvd)
+{
+	return __xfs_mod_fdblocks(mp, delta, rsvd, true);
+}
+
+int
 xfs_mod_frextents(
 	struct xfs_mount	*mp,
 	int64_t			delta)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3696700..2d43422 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -328,6 +328,8 @@ extern void	xfs_unmountfs(xfs_mount_t *);
 
 extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
 extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
+extern int	__xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
+				   bool reserved, bool unres);
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 748b16a..729367c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -548,11 +548,22 @@ xfs_trans_unreserve_and_mod_sb(
 	int64_t			rtxdelta = 0;
 	int64_t			idelta = 0;
 	int64_t			ifreedelta = 0;
+	int64_t			resdelta = 0;
 	int			error;
 
 	/* calculate deltas */
-	if (tp->t_blk_res > 0)
+	if (tp->t_blk_res > 0) {
+		/*
+		 * Distinguish between what should be unreserved from an
+		 * underlying thin pool and and what is only returned to the
+		 * free blocks counter.
+		 */
 		blkdelta = tp->t_blk_res;
+		if (tp->t_blk_res > tp->t_blk_res_used) {
+			resdelta = tp->t_blk_res - tp->t_blk_res_used;
+			blkdelta -= resdelta;
+		}
+	}
 	if ((tp->t_fdblocks_delta != 0) &&
 	    (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
 	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
@@ -571,12 +582,18 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	/* apply the per-cpu counters */
-	if (blkdelta) {
-		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
+	if (resdelta) {
+		error = __xfs_mod_fdblocks(mp, resdelta, rsvd, true);
 		if (error)
 			goto out;
 	}
 
+	if (blkdelta) {
+		error = __xfs_mod_fdblocks(mp, blkdelta, rsvd, false);
+		if (error)
+			goto out_undo_resblocks;
+	}
+
 	if (idelta) {
 		error = xfs_mod_icount(mp, idelta);
 		if (error)
@@ -681,6 +698,9 @@ out_undo_icount:
 out_undo_fdblocks:
 	if (blkdelta)
 		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
+out_undo_resblocks:
+	if (resdelta)
+		xfs_mod_fdblocks(mp, -resdelta, rsvd);
 out:
 	ASSERT(error == 0);
 	return;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
