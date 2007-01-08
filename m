Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Jan 2007 22:11:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l086Bhqw020794
	for <xfs@oss.sgi.com>; Sun, 7 Jan 2007 22:11:45 -0800
Date: Mon, 8 Jan 2007 17:10:40 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: fix block reservation to work with per-cpu counters
Message-ID: <20070108061040.GD44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

Currently, XFS_IOC_SET_RESBLKS will not work properly when
per-cpu superblock counters are enabled. Reservations can be lost
silently as they are applied to the incore superblock instead of
the currently active counters.

Rather than try to shoe-horn the current reservation code into
the per-cpu counters or vice-versa, we lock the superblock
and snap the current counter state and work on that number.
Once we work out exactly how much we need to "allocate" to
the reserved area, we drop the lock and call xfs_mod_incore_sb()
which will do all the right things w.r.t to the counter state.

If we fail to get as much as we want (i.e. ENOSPC is returned)
we go back to the start and try to allocate as much of what is
left.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_fsops.c  |   54 +++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_mount.c  |   16 ++-------------
 fs/xfs/xfs_mount.h  |    2 -
 fs/xfs/xfs_vfsops.c |    2 -
 4 files changed, 54 insertions(+), 20 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_fsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fsops.c	2006-12-12 12:05:20.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_fsops.c	2006-12-22 00:30:53.770384646 +1100
@@ -460,7 +460,7 @@ xfs_fs_counts(
 {
 	unsigned long	s;
 
-	xfs_icsb_sync_counters_lazy(mp);
+	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_LAZY_COUNT);
 	s = XFS_SB_LOCK(mp);
 	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	cnt->freertx = mp->m_sb.sb_frextents;
@@ -491,7 +491,7 @@ xfs_reserve_blocks(
 	__uint64_t              *inval,
 	xfs_fsop_resblks_t      *outval)
 {
-	__int64_t		lcounter, delta;
+	__int64_t		lcounter, delta, fdblks_delta;
 	__uint64_t		request;
 	unsigned long		s;
 
@@ -504,17 +504,35 @@ xfs_reserve_blocks(
 	}
 
 	request = *inval;
+
+	/*
+	 * With per-cpu counters, this becomes an interesting
+	 * problem. we needto work out if we are freeing or allocation
+	 * blocks first, then we can do the modification as necessary.
+	 *
+	 * We do this under the XFS_SB_LOCK so that if we are near
+	 * ENOSPC, we will hold out any changes while we work out
+	 * what to do. This means that the amount of free space can
+	 * change while we do this, so we need to retry if we end up
+	 * trying to reserve more space than is available.
+	 *
+	 * We also use the xfs_mod_incore_sb() interface so that we
+	 * don't have to care about whether per cpu counter are
+	 * enabled, disabled or even compiled in....
+	 */
+retry:
 	s = XFS_SB_LOCK(mp);
+	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_SB_LOCKED);
 
 	/*
 	 * If our previous reservation was larger than the current value,
 	 * then move any unused blocks back to the free pool.
 	 */
-
+	fdblks_delta = 0;
 	if (mp->m_resblks > request) {
 		lcounter = mp->m_resblks_avail - request;
 		if (lcounter  > 0) {		/* release unused blocks */
-			mp->m_sb.sb_fdblocks += lcounter;
+			fdblks_delta = lcounter;
 			mp->m_resblks_avail -= lcounter;
 		}
 		mp->m_resblks = request;
@@ -522,24 +540,50 @@ xfs_reserve_blocks(
 		__int64_t	free;
 
 		free =  mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+		if (!free)
+			goto out; /* ENOSPC and fdblks_delta = 0 */
+
 		delta = request - mp->m_resblks;
 		lcounter = free - delta;
 		if (lcounter < 0) {
 			/* We can't satisfy the request, just get what we can */
 			mp->m_resblks += free;
 			mp->m_resblks_avail += free;
+			fdblks_delta = -free;
 			mp->m_sb.sb_fdblocks = XFS_ALLOC_SET_ASIDE(mp);
 		} else {
+			fdblks_delta = -delta;
 			mp->m_sb.sb_fdblocks =
 				lcounter + XFS_ALLOC_SET_ASIDE(mp);
 			mp->m_resblks = request;
 			mp->m_resblks_avail += delta;
 		}
 	}
-
+out:
 	outval->resblks = mp->m_resblks;
 	outval->resblks_avail = mp->m_resblks_avail;
 	XFS_SB_UNLOCK(mp, s);
+
+	if (fdblks_delta) {
+		/*
+		 * If we are putting blocks back here, m_resblks_avail is
+		 * already at it's max so this will put it in the free pool.
+		 *
+		 * If we need space, we'll either succeed in getting it
+		 * from the free block count or we'll get an enospc. If
+		 * we get a ENOSPC, it means things changed while we were
+		 * calculating fdblks_delta and so we should try again to
+		 * see if there is anything left to reserve.
+		 *
+		 * Don't set the reserved flag here - we don't want to reserve
+		 * the extra reserve blocks from the reserve.....
+		 */
+		int error;
+		error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, fdblks_delta, 0);
+		if (error == ENOSPC)
+			goto retry;
+	}
+
 	return 0;
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-12-12 18:02:03.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-12-21 22:53:35.669131775 +1100
@@ -1963,8 +1963,8 @@ xfs_icsb_enable_counter(
 	xfs_icsb_unlock_all_counters(mp);
 }
 
-STATIC void
-xfs_icsb_sync_counters_int(
+void
+xfs_icsb_sync_counters_flags(
 	xfs_mount_t	*mp,
 	int		flags)
 {
@@ -1996,17 +1996,7 @@ STATIC void
 xfs_icsb_sync_counters(
 	xfs_mount_t	*mp)
 {
-	xfs_icsb_sync_counters_int(mp, 0);
-}
-
-/*
- * lazy addition used for things like df, background sb syncs, etc
- */
-void
-xfs_icsb_sync_counters_lazy(
-	xfs_mount_t	*mp)
-{
-	xfs_icsb_sync_counters_int(mp, XFS_ICSB_LAZY_COUNT);
+	xfs_icsb_sync_counters_flags(mp, 0);
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2006-12-20 22:59:33.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2006-12-21 22:52:35.596932143 +1100
@@ -312,7 +312,7 @@ typedef struct xfs_icsb_cnts {
 #define XFS_ICSB_LAZY_COUNT	(1 << 1)	/* accuracy not needed */
 
 extern int	xfs_icsb_init_counters(struct xfs_mount *);
-extern void	xfs_icsb_sync_counters_lazy(struct xfs_mount *);
+extern void	xfs_icsb_sync_counters_flags(struct xfs_mount *, int);
 
 #else
 #define xfs_icsb_init_counters(mp)	(0)
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2006-12-12 15:40:58.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2006-12-22 00:28:42.851623181 +1100
@@ -815,7 +815,7 @@ xfs_statvfs(
 
 	statp->f_type = XFS_SB_MAGIC;
 
-	xfs_icsb_sync_counters_lazy(mp);
+	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_LAZY_COUNT);
 	s = XFS_SB_LOCK(mp);
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
