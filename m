Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B18B87CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 11:42:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 839B5304059
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gl7hA8j6mP04DzjG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:55 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 02/10] xfs: replace xfs_mod_fdblocks() bool param with
	flags
Date: Tue, 12 Apr 2016 12:42:45 -0400
Message-Id: <1460479373-63317-3-git-send-email-bfoster@redhat.com>
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

xfs_mod_fdblocks() takes a boolean parameter to indicate whether the
requested allocation can dip into the XFS reserve block pool, if
necessary, to satisfy the allocation.

This function will also require caller control over block device
reservation. In preparation, convert the bool parameter to a flags
parameter and update all callers to use the appropriate reserved pool
flag as appropriate.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 17 ++++++++---------
 fs/xfs/xfs_mount.c       |  3 ++-
 fs/xfs/xfs_mount.h       |  4 +++-
 fs/xfs/xfs_trans.c       | 21 ++++++++++++++-------
 4 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ce41d7f..1a805b0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2186,7 +2186,7 @@ xfs_bmap_add_extent_delay_real(
 			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
 		if (diff > 0) {
 			error = xfs_mod_fdblocks(bma->ip->i_mount,
-						 -((int64_t)diff), false);
+						 -((int64_t)diff), 0);
 			ASSERT(!error);
 			if (error)
 				goto done;
@@ -2238,7 +2238,7 @@ xfs_bmap_add_extent_delay_real(
 		ASSERT(temp <= da_old);
 		if (temp < da_old)
 			xfs_mod_fdblocks(bma->ip->i_mount,
-					(int64_t)(da_old - temp), false);
+					(int64_t)(da_old - temp), 0);
 	}
 
 	/* clear out the allocated field, done with it now in any case. */
@@ -2916,8 +2916,7 @@ xfs_bmap_add_extent_hole_delay(
 	}
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
-		xfs_mod_fdblocks(ip->i_mount, (int64_t)(oldlen - newlen),
-				 false);
+		xfs_mod_fdblocks(ip->i_mount, (int64_t)(oldlen - newlen), 0);
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
@@ -4149,13 +4148,13 @@ xfs_bmapi_reserve_delalloc(
 	if (rt) {
 		error = xfs_mod_frextents(mp, -((int64_t)extsz));
 	} else {
-		error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
+		error = xfs_mod_fdblocks(mp, -((int64_t)alen), 0);
 	}
 
 	if (error)
 		goto out_unreserve_quota;
 
-	error = xfs_mod_fdblocks(mp, -((int64_t)indlen), false);
+	error = xfs_mod_fdblocks(mp, -((int64_t)indlen), 0);
 	if (error)
 		goto out_unreserve_blocks;
 
@@ -4184,7 +4183,7 @@ out_unreserve_blocks:
 	if (rt)
 		xfs_mod_frextents(mp, extsz);
 	else
-		xfs_mod_fdblocks(mp, alen, false);
+		xfs_mod_fdblocks(mp, alen, 0);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0, rt ?
@@ -5093,7 +5092,7 @@ xfs_bmap_del_extent(
 	 */
 	ASSERT(da_old >= da_new);
 	if (da_old > da_new)
-		xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new), false);
+		xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new), 0);
 done:
 	*logflagsp = flags;
 	return error;
@@ -5413,7 +5412,7 @@ xfs_bunmapi(
 			goto error0;
 
 		if (!isrt && wasdel)
-			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
+			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, 0);
 
 		bno = del.br_startoff - 1;
 nodelete:
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index cfd4210..50a6ccc 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1150,11 +1150,12 @@ int
 xfs_mod_fdblocks(
 	struct xfs_mount	*mp,
 	int64_t			delta,
-	bool			rsvd)
+	uint32_t		flags)
 {
 	int64_t			lcounter;
 	long long		res_used;
 	s32			batch;
+	bool			rsvd = (flags & XFS_FDBLOCKS_RSVD);
 
 	if (delta > 0) {
 		/*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index eafe257..bd1043f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -347,8 +347,10 @@ extern void	xfs_unmountfs(xfs_mount_t *);
 
 extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
 extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
+
+#define	XFS_FDBLOCKS_RSVD	(1 << 0)
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
-				 bool reserved);
+				 uint32_t flags);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
 
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 20c5366..8aa9d9a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -172,8 +172,11 @@ xfs_trans_reserve(
 	uint			blocks,
 	uint			rtextents)
 {
-	int		error = 0;
-	bool		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	int			error = 0;
+	int			flags = 0;
+
+	if (tp->t_flags & XFS_TRANS_RESERVE)
+		flags |= XFS_FDBLOCKS_RSVD;
 
 	/* Mark this thread as being in a transaction */
 	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
@@ -184,7 +187,8 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
+		error = xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks),
+					 flags);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 			return -ENOSPC;
@@ -259,7 +263,7 @@ undo_log:
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
+		xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), flags);
 		tp->t_blk_res = 0;
 	}
 
@@ -543,12 +547,15 @@ xfs_trans_unreserve_and_mod_sb(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 	int64_t			blkdelta = 0;
 	int64_t			rtxdelta = 0;
 	int64_t			idelta = 0;
 	int64_t			ifreedelta = 0;
 	int			error;
+	int			flags = 0;
+
+	if (tp->t_flags & XFS_TRANS_RESERVE)
+		flags |= XFS_FDBLOCKS_RSVD;
 
 	/* calculate deltas */
 	if (tp->t_blk_res > 0)
@@ -572,7 +579,7 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply the per-cpu counters */
 	if (blkdelta) {
-		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
+		error = xfs_mod_fdblocks(mp, blkdelta, flags);
 		if (error)
 			goto out;
 	}
@@ -680,7 +687,7 @@ out_undo_icount:
 		xfs_mod_icount(mp, -idelta);
 out_undo_fdblocks:
 	if (blkdelta)
-		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
+		xfs_mod_fdblocks(mp, -blkdelta, flags);
 out:
 	ASSERT(error == 0);
 	return;
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
