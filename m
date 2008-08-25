Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 08:38:41 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7PFcaL3030171
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 08:38:37 -0700
Received: from coraid.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCDD91A42421
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 08:39:57 -0700 (PDT)
Received: from coraid.com (baron.coraid.com [12.51.113.4]) by cuda.sgi.com with ESMTP id ZVaGiWTdLls5gbHq for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 08:39:57 -0700 (PDT)
Date: Mon, 25 Aug 2008 11:39:31 -0400
From: Ed Cashin <ecashin@coraid.com>
Subject: xfs_growfs fix backport for 2.6.16.y
Message-ID: <20080825153931.GD7575@coraid.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Adrian Bunk <bunk@kernel.org>

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dave Chinner, hello.

Your fix for the counters that had been preventing an XFS from growing
by more than two terabytes went into 2.6.21, after the introduction of
the per-cpu in-core superblock counters.  The per-cpu in-core
superblock counters are not in the latest version of the long-lived
stable kernel 2.6.16.y, maintained by Adrian Bunk.

The problem with growing by more than two terabytes appears to be
there, though.  The 2.6.16.62 kernel will not allow me to grow an XFS
by, e.g., 10 terabytes, so xfs_growfs does not report any change in
the data blocks.

I backported your fix,

    commit 20f4ebf2bf2f57c1a9abb3655391336cc90314b3
    Author: David Chinner <dgc@sgi.com>
    Date:   Sat Feb 10 18:36:10 2007 +1100
    
        [XFS] Make growfs work for amounts greater than 2TB
        
        The free block modification code has a 32bit interface, limiting the size
        the filesystem can be grown even on 64 bit machines. On 32 bit machines,
        there are other 32bit variables in transaction structures and interfaces
        that need to be expanded to allow this to work.
        
        SGI-PV: 959978
        SGI-Modid: xfs-linux-melb:xfs-kern:27894a
        
        Signed-off-by: David Chinner <dgc@sgi.com>
        Signed-off-by: Christoph Hellwig <hch@infradead.org>
        Signed-off-by: Tim Shimmin <tes@sgi.com>

... to the 2.6.16.y git tree, and the result is included below.  When
I apply this backported fix to 2.6.16.62, I can grow an online XFS by
10 terabytes without any trouble.

Do you see any problems with this backport?  If not, I will submit it
for inclusion in the next 2.6.16.y release.

-------------

merge 20f4ebf2: [XFS] Make growfs work for amounts greater than 2TB

This is a fix from David Chinner that went into 2.6.21.  It
followed the introduction of the per-cpu superblock counters,
but 2.6.16.y does not have those.

    The free block modification code has a 32bit interface, limiting the size
    the filesystem can be grown even on 64 bit machines. On 32 bit machines,
    there are other 32bit variables in transaction structures and interfaces
    that need to be expanded to allow this to work.

    SGI-PV: 959978
    SGI-Modid: xfs-linux-melb:xfs-kern:27894a

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 70625e5..18e57b6 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -687,7 +687,7 @@ xfs_bmap_add_extent(
 		ASSERT(nblks <= da_old);
 		if (nblks < da_old)
 			xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
-				(int)(da_old - nblks), rsvd);
+				(int64_t)(da_old - nblks), rsvd);
 	}
 	/*
 	 * Clear out the allocated field, done with it now in any case.
@@ -1180,7 +1180,7 @@ xfs_bmap_add_extent_delay_real(
 		diff = (int)(temp + temp2 - STARTBLOCKVAL(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
-		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -diff, rsvd)) {
+		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {
 			/*
 			 * Ick gross gag me with a spoon.
 			 */
@@ -1191,7 +1191,7 @@ xfs_bmap_add_extent_delay_real(
 					diff--;
 					if (!diff ||
 					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -diff, rsvd))
+						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
 						break;
 				}
 				if (temp2) {
@@ -1199,7 +1199,7 @@ xfs_bmap_add_extent_delay_real(
 					diff--;
 					if (!diff ||
 					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -diff, rsvd))
+						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
 						break;
 				}
 			}
@@ -1916,7 +1916,7 @@ xfs_bmap_add_extent_hole_delay(
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
 		xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
-			(int)(oldlen - newlen), rsvd);
+			(int64_t)(oldlen - newlen), rsvd);
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
@@ -3187,7 +3187,7 @@ xfs_bmap_del_extent(
 	 */
 	ASSERT(da_old >= da_new);
 	if (da_old > da_new)
-		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int)(da_old - da_new),
+		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int64_t)(da_old - da_new),
 			rsvd);
 done:
 	*logflagsp = flags;
@@ -4875,24 +4875,24 @@ xfs_bmapi(
 				if (rt) {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FREXTENTS,
-							-(extsz), rsvd);
+							-((int64_t)extsz), rsvd);
 				} else {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							-(alen), rsvd);
+							-((int64_t)alen), rsvd);
 				}
 				if (!error) {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							-(indlen), rsvd);
+							-((int64_t)indlen), rsvd);
 					if (error && rt)
 						xfs_mod_incore_sb(mp,
 							XFS_SBS_FREXTENTS,
-							extsz, rsvd);
+							(int64_t)extsz, rsvd);
 					else if (error)
 						xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							alen, rsvd);
+							(int64_t)alen, rsvd);
 				}
 
 				if (error) {
@@ -5538,13 +5538,13 @@ xfs_bunmapi(
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
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 62188ea..ab3d014 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1238,8 +1238,11 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
  * The SB_LOCK must be held when this routine is called.
  */
 STATIC int
-xfs_mod_incore_sb_unlocked(xfs_mount_t *mp, xfs_sb_field_t field,
-			int delta, int rsvd)
+xfs_mod_incore_sb_unlocked(
+	xfs_mount_t	*mp,
+	xfs_sb_field_t	field,
+	int64_t		delta,
+	int		rsvd)
 {
 	int		scounter;	/* short counter for 32 bit fields */
 	long long	lcounter;	/* long counter for 64 bit fields */
@@ -1401,7 +1404,11 @@ xfs_mod_incore_sb_unlocked(xfs_mount_t *mp, xfs_sb_field_t field,
  * routine to do the work.
  */
 int
-xfs_mod_incore_sb(xfs_mount_t *mp, xfs_sb_field_t field, int delta, int rsvd)
+xfs_mod_incore_sb(
+	xfs_mount_t	*mp,
+	xfs_sb_field_t	field,
+	int64_t		delta,
+	int		rsvd)
 {
 	unsigned long	s;
 	int	status;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cd3cf96..100d5b9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -526,10 +526,11 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 
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
@@ -547,7 +548,7 @@ extern int	xfs_unmountfs(xfs_mount_t *, struct cred *);
 extern void	xfs_unmountfs_close(xfs_mount_t *, struct cred *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_unmount_flush(xfs_mount_t *, int);
-extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int, int);
+extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d3d714e..68b5895 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -232,7 +232,7 @@ xfs_trans_reserve(
 	 */
 	if (blocks > 0) {
 		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					  -blocks, rsvd);
+					  -((int64_t)blocks), rsvd);
 		if (error != 0) {
                         PFLAGS_RESTORE_FSTRANS(&tp->t_pflags);
 			return (XFS_ERROR(ENOSPC));
@@ -273,7 +273,7 @@ xfs_trans_reserve(
 	 */
 	if (rtextents > 0) {
 		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FREXTENTS,
-					  -rtextents, rsvd);
+					  -((int64_t)rtextents), rsvd);
 		if (error) {
 			error = XFS_ERROR(ENOSPC);
 			goto undo_log;
@@ -303,7 +303,7 @@ undo_log:
 undo_blocks:
 	if (blocks > 0) {
 		(void) xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					 blocks, rsvd);
+					 (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
 
@@ -325,7 +325,7 @@ void
 xfs_trans_mod_sb(
 	xfs_trans_t	*tp,
 	uint		field,
-	long		delta)
+	int64_t		delta)
 {
 
 	switch (field) {
@@ -556,62 +556,62 @@ xfs_trans_unreserve_and_mod_sb(
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
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index d77901c..e4ca245 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -358,23 +358,23 @@ typedef struct xfs_trans {
 	xfs_trans_callback_t	t_callback;	/* transaction callback */
 	void			*t_callarg;	/* callback arg */
 	unsigned int		t_flags;	/* misc flags */
-	long			t_icount_delta;	/* superblock icount change */
-	long			t_ifree_delta;	/* superblock ifree change */
-	long			t_fdblocks_delta; /* superblock fdblocks chg */
-	long			t_res_fdblocks_delta; /* on-disk only chg */
-	long			t_frextents_delta;/* superblock freextents chg*/
-	long			t_res_frextents_delta; /* on-disk only chg */
-	long			t_ag_freeblks_delta; /* debugging counter */
-	long			t_ag_flist_delta; /* debugging counter */
-	long			t_ag_btree_delta; /* debugging counter */
-	long			t_dblocks_delta;/* superblock dblocks change */
-	long			t_agcount_delta;/* superblock agcount change */
-	long			t_imaxpct_delta;/* superblock imaxpct change */
-	long			t_rextsize_delta;/* superblock rextsize chg */
-	long			t_rbmblocks_delta;/* superblock rbmblocks chg */
-	long			t_rblocks_delta;/* superblock rblocks change */
-	long			t_rextents_delta;/* superblocks rextents chg */
-	long			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_icount_delta;	/* superblock icount change */
+	int64_t			t_ifree_delta;	/* superblock ifree change */
+	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
+	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
+	int64_t			t_frextents_delta;/* superblock freextents chg*/
+	int64_t			t_res_frextents_delta; /* on-disk only chg */
+	int64_t			t_ag_freeblks_delta; /* debugging counter */
+	int64_t			t_ag_flist_delta; /* debugging counter */
+	int64_t			t_ag_btree_delta; /* debugging counter */
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
@@ -941,9 +941,9 @@ typedef struct xfs_trans {
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
@@ -959,7 +959,7 @@ xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
-void		xfs_trans_mod_sb(xfs_trans_t *, uint, long);
+void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 struct xfs_buf	*xfs_trans_get_buf(xfs_trans_t *, struct xfs_buftarg *, xfs_daddr_t,
 				   int, uint);
 int		xfs_trans_read_buf(struct xfs_mount *, xfs_trans_t *,


-- 
  Ed Cashin <ecashin@coraid.com>

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="growfix.diff"

commit b4558635478e0c4d0f0761fc6287c7616f8f271f
Author: Ed L. Cashin <ecashin@coraid.com>
Date:   Fri Aug 22 16:46:49 2008 -0400

    merge 20f4ebf2: [XFS] Make growfs work for amounts greater than 2TB
    
    This is a fix from David Chinner that went into 2.6.21.  It
    followed the introduction of the per-cpu superblock counters,
    but 2.6.16.y does not have those.
    
        The free block modification code has a 32bit interface, limiting the size
        the filesystem can be grown even on 64 bit machines. On 32 bit machines,
        there are other 32bit variables in transaction structures and interfaces
        that need to be expanded to allow this to work.
    
        SGI-PV: 959978
        SGI-Modid: xfs-linux-melb:xfs-kern:27894a

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 70625e5..18e57b6 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -687,7 +687,7 @@ xfs_bmap_add_extent(
 		ASSERT(nblks <= da_old);
 		if (nblks < da_old)
 			xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
-				(int)(da_old - nblks), rsvd);
+				(int64_t)(da_old - nblks), rsvd);
 	}
 	/*
 	 * Clear out the allocated field, done with it now in any case.
@@ -1180,7 +1180,7 @@ xfs_bmap_add_extent_delay_real(
 		diff = (int)(temp + temp2 - STARTBLOCKVAL(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
-		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -diff, rsvd)) {
+		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {
 			/*
 			 * Ick gross gag me with a spoon.
 			 */
@@ -1191,7 +1191,7 @@ xfs_bmap_add_extent_delay_real(
 					diff--;
 					if (!diff ||
 					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -diff, rsvd))
+						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
 						break;
 				}
 				if (temp2) {
@@ -1199,7 +1199,7 @@ xfs_bmap_add_extent_delay_real(
 					diff--;
 					if (!diff ||
 					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -diff, rsvd))
+						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
 						break;
 				}
 			}
@@ -1916,7 +1916,7 @@ xfs_bmap_add_extent_hole_delay(
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
 		xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
-			(int)(oldlen - newlen), rsvd);
+			(int64_t)(oldlen - newlen), rsvd);
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
@@ -3187,7 +3187,7 @@ xfs_bmap_del_extent(
 	 */
 	ASSERT(da_old >= da_new);
 	if (da_old > da_new)
-		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int)(da_old - da_new),
+		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int64_t)(da_old - da_new),
 			rsvd);
 done:
 	*logflagsp = flags;
@@ -4875,24 +4875,24 @@ xfs_bmapi(
 				if (rt) {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FREXTENTS,
-							-(extsz), rsvd);
+							-((int64_t)extsz), rsvd);
 				} else {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							-(alen), rsvd);
+							-((int64_t)alen), rsvd);
 				}
 				if (!error) {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							-(indlen), rsvd);
+							-((int64_t)indlen), rsvd);
 					if (error && rt)
 						xfs_mod_incore_sb(mp,
 							XFS_SBS_FREXTENTS,
-							extsz, rsvd);
+							(int64_t)extsz, rsvd);
 					else if (error)
 						xfs_mod_incore_sb(mp,
 							XFS_SBS_FDBLOCKS,
-							alen, rsvd);
+							(int64_t)alen, rsvd);
 				}
 
 				if (error) {
@@ -5538,13 +5538,13 @@ xfs_bunmapi(
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
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 62188ea..ab3d014 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1238,8 +1238,11 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
  * The SB_LOCK must be held when this routine is called.
  */
 STATIC int
-xfs_mod_incore_sb_unlocked(xfs_mount_t *mp, xfs_sb_field_t field,
-			int delta, int rsvd)
+xfs_mod_incore_sb_unlocked(
+	xfs_mount_t	*mp,
+	xfs_sb_field_t	field,
+	int64_t		delta,
+	int		rsvd)
 {
 	int		scounter;	/* short counter for 32 bit fields */
 	long long	lcounter;	/* long counter for 64 bit fields */
@@ -1401,7 +1404,11 @@ xfs_mod_incore_sb_unlocked(xfs_mount_t *mp, xfs_sb_field_t field,
  * routine to do the work.
  */
 int
-xfs_mod_incore_sb(xfs_mount_t *mp, xfs_sb_field_t field, int delta, int rsvd)
+xfs_mod_incore_sb(
+	xfs_mount_t	*mp,
+	xfs_sb_field_t	field,
+	int64_t		delta,
+	int		rsvd)
 {
 	unsigned long	s;
 	int	status;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cd3cf96..100d5b9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -526,10 +526,11 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 
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
@@ -547,7 +548,7 @@ extern int	xfs_unmountfs(xfs_mount_t *, struct cred *);
 extern void	xfs_unmountfs_close(xfs_mount_t *, struct cred *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_unmount_flush(xfs_mount_t *, int);
-extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int, int);
+extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d3d714e..68b5895 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -232,7 +232,7 @@ xfs_trans_reserve(
 	 */
 	if (blocks > 0) {
 		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					  -blocks, rsvd);
+					  -((int64_t)blocks), rsvd);
 		if (error != 0) {
                         PFLAGS_RESTORE_FSTRANS(&tp->t_pflags);
 			return (XFS_ERROR(ENOSPC));
@@ -273,7 +273,7 @@ xfs_trans_reserve(
 	 */
 	if (rtextents > 0) {
 		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FREXTENTS,
-					  -rtextents, rsvd);
+					  -((int64_t)rtextents), rsvd);
 		if (error) {
 			error = XFS_ERROR(ENOSPC);
 			goto undo_log;
@@ -303,7 +303,7 @@ undo_log:
 undo_blocks:
 	if (blocks > 0) {
 		(void) xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					 blocks, rsvd);
+					 (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
 
@@ -325,7 +325,7 @@ void
 xfs_trans_mod_sb(
 	xfs_trans_t	*tp,
 	uint		field,
-	long		delta)
+	int64_t		delta)
 {
 
 	switch (field) {
@@ -556,62 +556,62 @@ xfs_trans_unreserve_and_mod_sb(
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
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index d77901c..e4ca245 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -358,23 +358,23 @@ typedef struct xfs_trans {
 	xfs_trans_callback_t	t_callback;	/* transaction callback */
 	void			*t_callarg;	/* callback arg */
 	unsigned int		t_flags;	/* misc flags */
-	long			t_icount_delta;	/* superblock icount change */
-	long			t_ifree_delta;	/* superblock ifree change */
-	long			t_fdblocks_delta; /* superblock fdblocks chg */
-	long			t_res_fdblocks_delta; /* on-disk only chg */
-	long			t_frextents_delta;/* superblock freextents chg*/
-	long			t_res_frextents_delta; /* on-disk only chg */
-	long			t_ag_freeblks_delta; /* debugging counter */
-	long			t_ag_flist_delta; /* debugging counter */
-	long			t_ag_btree_delta; /* debugging counter */
-	long			t_dblocks_delta;/* superblock dblocks change */
-	long			t_agcount_delta;/* superblock agcount change */
-	long			t_imaxpct_delta;/* superblock imaxpct change */
-	long			t_rextsize_delta;/* superblock rextsize chg */
-	long			t_rbmblocks_delta;/* superblock rbmblocks chg */
-	long			t_rblocks_delta;/* superblock rblocks change */
-	long			t_rextents_delta;/* superblocks rextents chg */
-	long			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_icount_delta;	/* superblock icount change */
+	int64_t			t_ifree_delta;	/* superblock ifree change */
+	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
+	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
+	int64_t			t_frextents_delta;/* superblock freextents chg*/
+	int64_t			t_res_frextents_delta; /* on-disk only chg */
+	int64_t			t_ag_freeblks_delta; /* debugging counter */
+	int64_t			t_ag_flist_delta; /* debugging counter */
+	int64_t			t_ag_btree_delta; /* debugging counter */
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
@@ -941,9 +941,9 @@ typedef struct xfs_trans {
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
@@ -959,7 +959,7 @@ xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
-void		xfs_trans_mod_sb(xfs_trans_t *, uint, long);
+void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 struct xfs_buf	*xfs_trans_get_buf(xfs_trans_t *, struct xfs_buftarg *, xfs_daddr_t,
 				   int, uint);
 int		xfs_trans_read_buf(struct xfs_mount *, xfs_trans_t *,

--cNdxnHkX5QqsyA0e--
