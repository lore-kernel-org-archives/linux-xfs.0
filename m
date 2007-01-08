Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Jan 2007 20:45:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l084jHqw010322
	for <xfs@oss.sgi.com>; Sun, 7 Jan 2007 20:45:19 -0800
Date: Mon, 8 Jan 2007 15:44:14 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: make growing by >2TB work
Message-ID: <20070108044414.GC44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

Growing a filesystem by > 2TB currently causes an overflow
in the transaction subsystem. Make transaction deltas and associated
elements explicitly 64 bit types so that we don't get overflows.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_bmap.c  |   26 +++++++++++++-------------
 fs/xfs/xfs_mount.c |   18 ++++++------------
 fs/xfs/xfs_mount.h |    7 ++++---
 fs/xfs/xfs_trans.c |   32 ++++++++++++++++----------------
 fs/xfs/xfs_trans.h |   42 +++++++++++++++++++++---------------------
 5 files changed, 60 insertions(+), 65 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-12-04 11:25:57.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-12-04 11:33:31.470695330 +1100
@@ -52,11 +52,11 @@ STATIC void	xfs_unmountfs_wait(xfs_mount
 
 #ifdef HAVE_PERCPU_SB
 STATIC void	xfs_icsb_destroy_counters(xfs_mount_t *);
-STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t, int,
-int);
+STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
+						int, int);
 STATIC void	xfs_icsb_sync_counters(xfs_mount_t *);
 STATIC int	xfs_icsb_modify_counters(xfs_mount_t *, xfs_sb_field_t,
-						int, int);
+						int64_t, int);
 STATIC int	xfs_icsb_disable_counter(xfs_mount_t *, xfs_sb_field_t);
 
 #else
@@ -136,14 +136,9 @@ xfs_mount_init(void)
 		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
 	}
 
-	AIL_LOCKINIT(&mp->m_ail_lock, "xfs_ail");
 	spinlock_init(&mp->m_sb_lock, "xfs_sb");
 	mutex_init(&mp->m_ilock);
 	initnsema(&mp->m_growlock, 1, "xfs_grow");
-	/*
-	 * Initialize the AIL.
-	 */
-	xfs_trans_ail_init(mp);
 
 	atomic_set(&mp->m_active_trans, 0);
 
@@ -1255,7 +1250,7 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
  */
 int
 xfs_mod_incore_sb_unlocked(xfs_mount_t *mp, xfs_sb_field_t field,
-			int delta, int rsvd)
+			int64_t delta, int rsvd)
 {
 	int		scounter;	/* short counter for 32 bit fields */
 	long long	lcounter;	/* long counter for 64 bit fields */
@@ -1287,7 +1282,6 @@ xfs_mod_incore_sb_unlocked(xfs_mount_t *
 		mp->m_sb.sb_ifree = lcounter;
 		return 0;
 	case XFS_SBS_FDBLOCKS:
-
 		lcounter = (long long)
 			mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
@@ -1418,7 +1412,7 @@ xfs_mod_incore_sb_unlocked(xfs_mount_t *
  * routine to do the work.
  */
 int
-xfs_mod_incore_sb(xfs_mount_t *mp, xfs_sb_field_t field, int delta, int rsvd)
+xfs_mod_incore_sb(xfs_mount_t *mp, xfs_sb_field_t field, int64_t delta, int rsvd)
 {
 	unsigned long	s;
 	int	status;
@@ -2091,7 +2085,7 @@ int
 xfs_icsb_modify_counters(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field,
-	int		delta,
+	int64_t		delta,
 	int		rsvd)
 {
 	xfs_icsb_cnts_t	*icsbp;
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2006-12-04 11:25:57.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2006-12-04 11:33:31.470695330 +1100
@@ -565,10 +565,11 @@ xfs_daddr_to_agbno(struct xfs_mount *mp,
 
 /*
  * This structure is for use by the xfs_mod_incore_sb_batch() routine.
+ * xfs_growfs can specify a few fields which are more than int limit
  */
 typedef struct xfs_mod_sb {
 	xfs_sb_field_t	msb_field;	/* Field to modify, see below */
-	int		msb_delta;	/* Change to make to specified field */
+	int64_t		msb_delta;	/* Change to make to specified field */
 } xfs_mod_sb_t;
 
 #define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock))
@@ -586,9 +587,9 @@ extern int	xfs_unmountfs(xfs_mount_t *, 
 extern void	xfs_unmountfs_close(xfs_mount_t *, struct cred *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_unmount_flush(xfs_mount_t *, int);
-extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int, int);
+extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 extern int	xfs_mod_incore_sb_unlocked(xfs_mount_t *, xfs_sb_field_t,
-			int, int);
+			int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.c	2006-12-04 11:25:38.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.c	2006-12-04 11:33:31.470695330 +1100
@@ -339,7 +339,7 @@ xfs_trans_reserve(
 	 */
 	if (blocks > 0) {
 		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					  -blocks, rsvd);
+					  -((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 			return (XFS_ERROR(ENOSPC));
@@ -380,7 +380,7 @@ xfs_trans_reserve(
 	 */
 	if (rtextents > 0) {
 		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FREXTENTS,
-					  -rtextents, rsvd);
+					  -((int64_t)rtextents), rsvd);
 		if (error) {
 			error = XFS_ERROR(ENOSPC);
 			goto undo_log;
@@ -410,7 +410,7 @@ undo_log:
 undo_blocks:
 	if (blocks > 0) {
 		(void) xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					 blocks, rsvd);
+					 (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
 
@@ -432,7 +432,7 @@ void
 xfs_trans_mod_sb(
 	xfs_trans_t	*tp,
 	uint		field,
-	long		delta)
+	int64_t		delta)
 {
 
 	switch (field) {
@@ -663,62 +663,62 @@ xfs_trans_unreserve_and_mod_sb(
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		if (tp->t_icount_delta != 0) {
 			msbp->msb_field = XFS_SBS_ICOUNT;
-			msbp->msb_delta = (int)tp->t_icount_delta;
+			msbp->msb_delta = tp->t_icount_delta;
 			msbp++;
 		}
 		if (tp->t_ifree_delta != 0) {
 			msbp->msb_field = XFS_SBS_IFREE;
-			msbp->msb_delta = (int)tp->t_ifree_delta;
+			msbp->msb_delta = tp->t_ifree_delta;
 			msbp++;
 		}
 		if (tp->t_fdblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_FDBLOCKS;
-			msbp->msb_delta = (int)tp->t_fdblocks_delta;
+			msbp->msb_delta = tp->t_fdblocks_delta;
 			msbp++;
 		}
 		if (tp->t_frextents_delta != 0) {
 			msbp->msb_field = XFS_SBS_FREXTENTS;
-			msbp->msb_delta = (int)tp->t_frextents_delta;
+			msbp->msb_delta = tp->t_frextents_delta;
 			msbp++;
 		}
 		if (tp->t_dblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_DBLOCKS;
-			msbp->msb_delta = (int)tp->t_dblocks_delta;
+			msbp->msb_delta = tp->t_dblocks_delta;
 			msbp++;
 		}
 		if (tp->t_agcount_delta != 0) {
 			msbp->msb_field = XFS_SBS_AGCOUNT;
-			msbp->msb_delta = (int)tp->t_agcount_delta;
+			msbp->msb_delta = tp->t_agcount_delta;
 			msbp++;
 		}
 		if (tp->t_imaxpct_delta != 0) {
 			msbp->msb_field = XFS_SBS_IMAX_PCT;
-			msbp->msb_delta = (int)tp->t_imaxpct_delta;
+			msbp->msb_delta = tp->t_imaxpct_delta;
 			msbp++;
 		}
 		if (tp->t_rextsize_delta != 0) {
 			msbp->msb_field = XFS_SBS_REXTSIZE;
-			msbp->msb_delta = (int)tp->t_rextsize_delta;
+			msbp->msb_delta = tp->t_rextsize_delta;
 			msbp++;
 		}
 		if (tp->t_rbmblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_RBMBLOCKS;
-			msbp->msb_delta = (int)tp->t_rbmblocks_delta;
+			msbp->msb_delta = tp->t_rbmblocks_delta;
 			msbp++;
 		}
 		if (tp->t_rblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_RBLOCKS;
-			msbp->msb_delta = (int)tp->t_rblocks_delta;
+			msbp->msb_delta = tp->t_rblocks_delta;
 			msbp++;
 		}
 		if (tp->t_rextents_delta != 0) {
 			msbp->msb_field = XFS_SBS_REXTENTS;
-			msbp->msb_delta = (int)tp->t_rextents_delta;
+			msbp->msb_delta = tp->t_rextents_delta;
 			msbp++;
 		}
 		if (tp->t_rextslog_delta != 0) {
 			msbp->msb_field = XFS_SBS_REXTSLOG;
-			msbp->msb_delta = (int)tp->t_rextslog_delta;
+			msbp->msb_delta = tp->t_rextslog_delta;
 			msbp++;
 		}
 	}
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.h	2006-12-04 11:25:57.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.h	2006-12-04 11:33:31.474694802 +1100
@@ -350,25 +350,25 @@ typedef struct xfs_trans {
 	xfs_trans_callback_t	t_callback;	/* transaction callback */
 	void			*t_callarg;	/* callback arg */
 	unsigned int		t_flags;	/* misc flags */
-	long			t_icount_delta;	/* superblock icount change */
-	long			t_ifree_delta;	/* superblock ifree change */
-	long			t_fdblocks_delta; /* superblock fdblocks chg */
-	long			t_res_fdblocks_delta; /* on-disk only chg */
-	long			t_frextents_delta;/* superblock freextents chg*/
-	long			t_res_frextents_delta; /* on-disk only chg */
+	int64_t			t_icount_delta;	/* superblock icount change */
+	int64_t			t_ifree_delta;	/* superblock ifree change */
+	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
+	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
+	int64_t			t_frextents_delta;/* superblock freextents chg*/
+	int64_t			t_res_frextents_delta; /* on-disk only chg */
 #ifdef DEBUG
-	long			t_ag_freeblks_delta; /* debugging counter */
-	long			t_ag_flist_delta; /* debugging counter */
-	long			t_ag_btree_delta; /* debugging counter */
+	int64_t			t_ag_freeblks_delta; /* debugging counter */
+	int64_t			t_ag_flist_delta; /* debugging counter */
+	int64_t			t_ag_btree_delta; /* debugging counter */
 #endif
-	long			t_dblocks_delta;/* superblock dblocks change */
-	long			t_agcount_delta;/* superblock agcount change */
-	long			t_imaxpct_delta;/* superblock imaxpct change */
-	long			t_rextsize_delta;/* superblock rextsize chg */
-	long			t_rbmblocks_delta;/* superblock rbmblocks chg */
-	long			t_rblocks_delta;/* superblock rblocks change */
-	long			t_rextents_delta;/* superblocks rextents chg */
-	long			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_dblocks_delta;/* superblock dblocks change */
+	int64_t			t_agcount_delta;/* superblock agcount change */
+	int64_t			t_imaxpct_delta;/* superblock imaxpct change */
+	int64_t			t_rextsize_delta;/* superblock rextsize chg */
+	int64_t			t_rbmblocks_delta;/* superblock rbmblocks chg */
+	int64_t			t_rblocks_delta;/* superblock rblocks change */
+	int64_t			t_rextents_delta;/* superblocks rextents chg */
+	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
 	unsigned int		t_items_free;	/* log item descs free */
 	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
 	xfs_trans_header_t	t_header;	/* header for in-log trans */
@@ -932,9 +932,9 @@ typedef struct xfs_trans {
 #define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
 
 #ifdef DEBUG
-#define	xfs_trans_agblocks_delta(tp, d)	((tp)->t_ag_freeblks_delta += (long)d)
-#define	xfs_trans_agflist_delta(tp, d)	((tp)->t_ag_flist_delta += (long)d)
-#define	xfs_trans_agbtree_delta(tp, d)	((tp)->t_ag_btree_delta += (long)d)
+#define	xfs_trans_agblocks_delta(tp, d)	((tp)->t_ag_freeblks_delta += (int64_t)d)
+#define	xfs_trans_agflist_delta(tp, d)	((tp)->t_ag_flist_delta += (int64_t)d)
+#define	xfs_trans_agbtree_delta(tp, d)	((tp)->t_ag_btree_delta += (int64_t)d)
 #else
 #define	xfs_trans_agblocks_delta(tp, d)
 #define	xfs_trans_agflist_delta(tp, d)
@@ -950,7 +950,7 @@ xfs_trans_t	*_xfs_trans_alloc(struct xfs
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
-void		xfs_trans_mod_sb(xfs_trans_t *, uint, long);
+void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 struct xfs_buf	*xfs_trans_get_buf(xfs_trans_t *, struct xfs_buftarg *, xfs_daddr_t,
 				   int, uint);
 int		xfs_trans_read_buf(struct xfs_mount *, xfs_trans_t *,
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2006-12-04 11:25:38.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2006-12-04 11:33:31.478694275 +1100
@@ -684,7 +684,7 @@ xfs_bmap_add_extent(
 		ASSERT(nblks <= da_old);
 		if (nblks < da_old)
 			xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
-				(int)(da_old - nblks), rsvd);
+				(int64_t)(da_old - nblks), rsvd);
 	}
 	/*
 	 * Clear out the allocated field, done with it now in any case.
@@ -1209,7 +1209,7 @@ xfs_bmap_add_extent_delay_real(
 		diff = (int)(temp + temp2 - STARTBLOCKVAL(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
-		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -diff, rsvd)) {
+		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {
 			/*
 			 * Ick gross gag me with a spoon.
 			 */
@@ -1220,7 +1220,7 @@ xfs_bmap_add_extent_delay_real(
 					diff--;
 					if (!diff ||
 					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -diff, rsvd))
+						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
 						break;
 				}
 				if (temp2) {
@@ -1228,7 +1228,7 @@ xfs_bmap_add_extent_delay_real(
 					diff--;
 					if (!diff ||
 					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -diff, rsvd))
+						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
 						break;
 				}
 			}
@@ -2015,7 +2015,7 @@ xfs_bmap_add_extent_hole_delay(
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
 		xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
-			(int)(oldlen - newlen), rsvd);
+			(int64_t)(oldlen - newlen), rsvd);
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
@@ -3359,7 +3359,7 @@ xfs_bmap_del_extent(
 	 */
 	ASSERT(da_old >= da_new);
 	if (da_old > da_new)
-		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int)(da_old - da_new),
+		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int64_t)(da_old - da_new),
 			rsvd);
 	if (delta) {
 		/* DELTA: report the original extent. */
@@ -4929,28 +4929,28 @@ xfs_bmapi(
 				if (rt) {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FREXTENTS,
-							-(extsz), (flags &
+							-((int64_t)extsz), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				} else {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							-(alen), (flags &
+							-((int64_t)alen), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				}
 				if (!error) {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							-(indlen), (flags &
+							-((int64_t)indlen), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 					if (error && rt)
 						xfs_mod_incore_sb(mp,
 							XFS_SBS_FREXTENTS,
-							extsz, (flags &
+							(int64_t)extsz, (flags &
 							XFS_BMAPI_RSVBLOCKS));
 					else if (error)
 						xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							alen, (flags &
+							(int64_t)alen, (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				}
 
@@ -5616,13 +5616,13 @@ xfs_bunmapi(
 				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
 				do_div(rtexts, mp->m_sb.sb_rextsize);
 				xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
-						(int)rtexts, rsvd);
+						(int64_t)rtexts, rsvd);
 				(void)XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,
 					NULL, ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
 				xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS,
-						(int)del.br_blockcount, rsvd);
+						(int64_t)del.br_blockcount, rsvd);
 				(void)XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,
 					NULL, ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_REGBLKS);
