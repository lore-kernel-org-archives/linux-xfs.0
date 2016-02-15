Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5E9A7CAB
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA9AD304043
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:19:00 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Z7tJCRk6Ma4i60Qp for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:58 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MC-Hl
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005GO-Gc
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/14] xfs: per-filesystem stats counter implementation
Date: Mon, 15 Feb 2016 17:18:15 +1100
Message-Id: <1455517105-20033-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

From: Bill O'Donnell <billodo@redhat.com>

Source kernel commit ff6d6af2351caea7db681f4539d0d893e400557a

This patch modifies the stats counting macros and the callers
to those macros to properly increment, decrement, and add-to
the xfs stats counts. The counts for global and per-fs stats
are correctly advanced, and cleared by writing a "1" to the
corresponding clear file.

global counts: /sys/fs/xfs/stats/stats
per-fs counts: /sys/fs/xfs/sda*/stats/stats

global clear:  /sys/fs/xfs/stats/stats_clear
per-fs clear:  /sys/fs/xfs/sda*/stats/stats_clear

[dchinner: cleaned up macro variables, removed CONFIG_FS_PROC around
 stats structures and macros. ]

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/libxfs_priv.h |  6 +++---
 libxfs/xfs_alloc.c   |  8 ++++----
 libxfs/xfs_attr.c    |  6 +++---
 libxfs/xfs_bmap.c    | 20 ++++++++++----------
 libxfs/xfs_btree.h   | 41 ++++++++++++++++++++++++-----------------
 libxfs/xfs_dir2.c    |  6 +++---
 6 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 0f4d3e5..e2884a2 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -140,9 +140,9 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_ERRLEVEL_LOW		1
 #define XFS_FORCED_SHUTDOWN(mp)		0
 #define XFS_ILOCK_EXCL			0
-#define XFS_STATS_INC(count)		do { } while (0)
-#define XFS_STATS_DEC(count, x)		do { } while (0)
-#define XFS_STATS_ADD(count, x)		do { } while (0)
+#define XFS_STATS_INC(mp, count)	do { } while (0)
+#define XFS_STATS_DEC(mp, count, x)	do { } while (0)
+#define XFS_STATS_ADD(mp, count, x)	do { } while (0)
 #define XFS_TRANS_MOD_DQUOT_BYINO(mp,tp,ip,field,delta)	do { } while (0)
 #define XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
 #define XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index b43655c..12d59df 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -650,8 +650,8 @@ xfs_alloc_ag_vextent(
 				 -((long)(args->len)));
 	}
 
-	XFS_STATS_INC(xs_allocx);
-	XFS_STATS_ADD(xs_allocb, args->len);
+	XFS_STATS_INC(args->mp, xs_allocx);
+	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
 	return error;
 }
 
@@ -1807,8 +1807,8 @@ xfs_free_ag_extent(
 
 	if (!isfl)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (long)len);
-	XFS_STATS_INC(xs_freex);
-	XFS_STATS_ADD(xs_freeb, len);
+	XFS_STATS_INC(mp, xs_freex);
+	XFS_STATS_ADD(mp, xs_freeb, len);
 
 	trace_xfs_free_extent(mp, agno, bno, len, isfl, haveleft, haveright);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index bdde0f6..5e79f3d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -120,7 +120,7 @@ xfs_attr_get(
 	uint			lock_mode;
 	int			error;
 
-	XFS_STATS_INC(xs_attr_get);
+	XFS_STATS_INC(ip->i_mount, xs_attr_get);
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
@@ -202,7 +202,7 @@ xfs_attr_set(
 	int			rsvd = (flags & ATTR_ROOT) != 0;
 	int			error, err2, committed, local;
 
-	XFS_STATS_INC(xs_attr_set);
+	XFS_STATS_INC(mp, xs_attr_set);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
@@ -405,7 +405,7 @@ xfs_attr_remove(
 	xfs_fsblock_t		firstblock;
 	int			error;
 
-	XFS_STATS_INC(xs_attr_remove);
+	XFS_STATS_INC(mp, xs_attr_remove);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8464810..8e19b50 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1429,7 +1429,7 @@ xfs_bmap_search_extents(
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
 	xfs_bmbt_rec_host_t  *ep;            /* extent record pointer */
 
-	XFS_STATS_INC(xs_look_exlist);
+	XFS_STATS_INC(ip->i_mount, xs_look_exlist);
 	ifp = XFS_IFORK_PTR(ip, fork);
 
 	ep = xfs_bmap_search_multi_extents(ifp, bno, eofp, lastxp, gotp, prevp);
@@ -1727,7 +1727,7 @@ xfs_bmap_add_extent_delay_real(
 	ASSERT(!bma->cur ||
 	       (bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
 
-	XFS_STATS_INC(xs_add_exlist);
+	XFS_STATS_INC(mp, xs_add_exlist);
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
@@ -2281,7 +2281,7 @@ xfs_bmap_add_extent_unwritten_real(
 	ASSERT(*idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
 	ASSERT(!isnullstartblock(new->br_startblock));
 
-	XFS_STATS_INC(xs_add_exlist);
+	XFS_STATS_INC(mp, xs_add_exlist);
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
@@ -2941,7 +2941,7 @@ xfs_bmap_add_extent_hole_real(
 	ASSERT(!bma->cur ||
 	       !(bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
 
-	XFS_STATS_INC(xs_add_exlist);
+	XFS_STATS_INC(mp, xs_add_exlist);
 
 	state = 0;
 	if (whichfork == XFS_ATTR_FORK)
@@ -4031,7 +4031,7 @@ xfs_bmapi_read(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	XFS_STATS_INC(xs_blk_mapr);
+	XFS_STATS_INC(mp, xs_blk_mapr);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
@@ -4216,7 +4216,7 @@ xfs_bmapi_delay(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	XFS_STATS_INC(xs_blk_mapw);
+	XFS_STATS_INC(mp, xs_blk_mapw);
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
@@ -4520,7 +4520,7 @@ xfs_bmapi_write(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
-	XFS_STATS_INC(xs_blk_mapw);
+	XFS_STATS_INC(mp, xs_blk_mapw);
 
 	if (*firstblock == NULLFSBLOCK) {
 		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
@@ -4713,12 +4713,12 @@ xfs_bmap_del_extent(
 	xfs_filblks_t		temp2;	/* for indirect length calculations */
 	int			state = 0;
 
-	XFS_STATS_INC(xs_del_exlist);
+	mp = ip->i_mount;
+	XFS_STATS_INC(mp, xs_del_exlist);
 
 	if (whichfork == XFS_ATTR_FORK)
 		state |= BMAP_ATTRFORK;
 
-	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT((*idx >= 0) && (*idx < ifp->if_bytes /
 		(uint)sizeof(xfs_bmbt_rec_t)));
@@ -5065,7 +5065,7 @@ xfs_bunmapi(
 		*done = 1;
 		return 0;
 	}
-	XFS_STATS_INC(xs_blk_unmap);
+	XFS_STATS_INC(mp, xs_blk_unmap);
 	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
 	start = bno;
 	bno = start + len - 1;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 48cb251..9a88839 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -84,31 +84,38 @@ union xfs_btree_rec {
 /*
  * Generic stats interface
  */
-#define __XFS_BTREE_STATS_INC(type, stat) \
-	XFS_STATS_INC(xs_ ## type ## _2_ ## stat)
-#define XFS_BTREE_STATS_INC(cur, stat)  \
+#define __XFS_BTREE_STATS_INC(mp, type, stat) \
+	XFS_STATS_INC(mp, xs_ ## type ## _2_ ## stat)
+#define XFS_BTREE_STATS_INC(cur, stat)	\
 do {    \
+	struct xfs_mount *__mp = cur->bc_mp; \
 	switch (cur->bc_btnum) {  \
-	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(abtb, stat); break;	\
-	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(abtc, stat); break;	\
-	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
-	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
-	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(__mp, abtb, stat); break; \
+	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(__mp, abtc, stat); break; \
+	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(__mp, bmbt, stat); break; \
+	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
+	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
+	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
 	}       \
 } while (0)
 
-#define __XFS_BTREE_STATS_ADD(type, stat, val) \
-	XFS_STATS_ADD(xs_ ## type ## _2_ ## stat, val)
+#define __XFS_BTREE_STATS_ADD(mp, type, stat, val) \
+	XFS_STATS_ADD(mp, xs_ ## type ## _2_ ## stat, val)
 #define XFS_BTREE_STATS_ADD(cur, stat, val)  \
 do {    \
+	struct xfs_mount *__mp = cur->bc_mp; \
 	switch (cur->bc_btnum) {  \
-	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_ADD(abtb, stat, val); break; \
-	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_ADD(abtc, stat, val); break; \
-	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
-	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
-	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_BNO:	\
+		__XFS_BTREE_STATS_ADD(__mp, abtb, stat, val); break; \
+	case XFS_BTNUM_CNT:	\
+		__XFS_BTREE_STATS_ADD(__mp, abtc, stat, val); break; \
+	case XFS_BTNUM_BMAP:	\
+		__XFS_BTREE_STATS_ADD(__mp, bmbt, stat, val); break; \
+	case XFS_BTNUM_INO:	\
+		__XFS_BTREE_STATS_ADD(__mp, ibt, stat, val); break; \
+	case XFS_BTNUM_FINO:	\
+		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
+	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
 	}       \
 } while (0)
 
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 4a19b76..383401b 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -269,7 +269,7 @@ xfs_dir_createname(
 		rval = xfs_dir_ino_validate(tp->t_mountp, inum);
 		if (rval)
 			return rval;
-		XFS_STATS_INC(xs_dir_create);
+		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
@@ -362,7 +362,7 @@ xfs_dir_lookup(
 	int		v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
-	XFS_STATS_INC(xs_dir_lookup);
+	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
 
 	/*
 	 * We need to use KM_NOFS here so that lockdep will not throw false
@@ -439,7 +439,7 @@ xfs_dir_removename(
 	int		v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
-	XFS_STATS_INC(xs_dir_remove);
+	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
 	if (!args)
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
