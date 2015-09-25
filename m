Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C3587F72
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 18:23:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF6308F8049
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 16:23:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Nmoch1M6DC1rJSlg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2015 16:23:20 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 2DE2CA0BAC
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 23:23:20 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-55-243.rdu2.redhat.com
	[10.10.55.243])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8PNNBp7021662
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 19:23:19 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 7/7] xfs: per-filesystem stats counter implementation
Date: Fri, 25 Sep 2015 18:23:00 -0500
Message-Id: <1443223380-18870-8-git-send-email-billodo@redhat.com>
In-Reply-To: <1443223380-18870-1-git-send-email-billodo@redhat.com>
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
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

This patch modifies the stats counting macros and the callers
to those macros to properly increment, decrement, and add-to
the xfs stats counts. The counts for global and per-fs stats
are correctly advanced, and cleared by writing a "1" to the
corresponding clear file.

global counts: /sys/fs/xfs/stats/stats
per-fs counts: /sys/fs/xfs/sda*/stats/stats

global clear:  /sys/fs/xfs/stats/stats_clear
per-fs clear:  /sys/fs/xfs/sda*/stats/stats_clear

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  8 ++++----
 fs/xfs/libxfs/xfs_attr.c  |  6 +++---
 fs/xfs/libxfs/xfs_bmap.c  | 20 ++++++++++----------
 fs/xfs/libxfs/xfs_btree.h | 21 +++++++++++----------
 fs/xfs/libxfs/xfs_dir2.c  |  6 +++---
 fs/xfs/xfs_attr_list.c    |  2 +-
 fs/xfs/xfs_buf.c          | 18 +++++++++---------
 fs/xfs/xfs_dir2_readdir.c |  2 +-
 fs/xfs/xfs_dquot.c        | 12 ++++++------
 fs/xfs/xfs_file.c         | 12 ++++++------
 fs/xfs/xfs_icache.c       | 18 +++++++++---------
 fs/xfs/xfs_inode.c        |  6 +++---
 fs/xfs/xfs_ioctl.c        |  2 +-
 fs/xfs/xfs_iomap.c        |  4 ++--
 fs/xfs/xfs_iops.c         |  4 ++--
 fs/xfs/xfs_log.c          | 22 +++++++++++-----------
 fs/xfs/xfs_qm.c           | 14 +++++++-------
 fs/xfs/xfs_stats.c        |  8 +++-----
 fs/xfs/xfs_stats.h        | 23 +++++++++++++++++++----
 fs/xfs/xfs_super.c        |  6 +++---
 fs/xfs/xfs_trans.c        |  6 +++---
 fs/xfs/xfs_trans_ail.c    | 12 ++++++------
 22 files changed, 123 insertions(+), 109 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ffad7f2..9b5da7e3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -651,8 +651,8 @@ xfs_alloc_ag_vextent(
 				 -((long)(args->len)));
 	}
 
-	XFS_STATS_INC(xs_allocx);
-	XFS_STATS_ADD(xs_allocb, args->len);
+	XFS_STATS_INC(args->mp, xs_allocx);
+	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
 	return error;
 }
 
@@ -1808,8 +1808,8 @@ xfs_free_ag_extent(
 
 	if (!isfl)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (long)len);
-	XFS_STATS_INC(xs_freex);
-	XFS_STATS_ADD(xs_freeb, len);
+	XFS_STATS_INC(mp, xs_freex);
+	XFS_STATS_ADD(mp, xs_freeb, len);
 
 	trace_xfs_free_extent(mp, agno, bno, len, isfl, haveleft, haveright);
 
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ff06557..f949818 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -125,7 +125,7 @@ xfs_attr_get(
 	uint			lock_mode;
 	int			error;
 
-	XFS_STATS_INC(xs_attr_get);
+	XFS_STATS_INC(ip->i_mount, xs_attr_get);
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
@@ -209,7 +209,7 @@ xfs_attr_set(
 	int			rsvd = (flags & ATTR_ROOT) != 0;
 	int			error, err2, committed, local;
 
-	XFS_STATS_INC(xs_attr_set);
+	XFS_STATS_INC(mp, xs_attr_set);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
@@ -412,7 +412,7 @@ xfs_attr_remove(
 	xfs_fsblock_t		firstblock;
 	int			error;
 
-	XFS_STATS_INC(xs_attr_remove);
+	XFS_STATS_INC(mp, xs_attr_remove);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8e2010d..5256fe5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1435,7 +1435,7 @@ xfs_bmap_search_extents(
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
 	xfs_bmbt_rec_host_t  *ep;            /* extent record pointer */
 
-	XFS_STATS_INC(xs_look_exlist);
+	XFS_STATS_INC(ip->i_mount, xs_look_exlist);
 	ifp = XFS_IFORK_PTR(ip, fork);
 
 	ep = xfs_bmap_search_multi_extents(ifp, bno, eofp, lastxp, gotp, prevp);
@@ -1732,7 +1732,7 @@ xfs_bmap_add_extent_delay_real(
 	ASSERT(!bma->cur ||
 	       (bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
 
-	XFS_STATS_INC(xs_add_exlist);
+	XFS_STATS_INC(mp, xs_add_exlist);
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
@@ -2286,7 +2286,7 @@ xfs_bmap_add_extent_unwritten_real(
 	ASSERT(*idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
 	ASSERT(!isnullstartblock(new->br_startblock));
 
-	XFS_STATS_INC(xs_add_exlist);
+	XFS_STATS_INC(mp, xs_add_exlist);
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
@@ -2946,7 +2946,7 @@ xfs_bmap_add_extent_hole_real(
 	ASSERT(!bma->cur ||
 	       !(bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
 
-	XFS_STATS_INC(xs_add_exlist);
+	XFS_STATS_INC(mp, xs_add_exlist);
 
 	state = 0;
 	if (whichfork == XFS_ATTR_FORK)
@@ -4036,7 +4036,7 @@ xfs_bmapi_read(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	XFS_STATS_INC(xs_blk_mapr);
+	XFS_STATS_INC(mp, xs_blk_mapr);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
@@ -4221,7 +4221,7 @@ xfs_bmapi_delay(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	XFS_STATS_INC(xs_blk_mapw);
+	XFS_STATS_INC(mp, xs_blk_mapw);
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
@@ -4525,7 +4525,7 @@ xfs_bmapi_write(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
-	XFS_STATS_INC(xs_blk_mapw);
+	XFS_STATS_INC(mp, xs_blk_mapw);
 
 	if (*firstblock == NULLFSBLOCK) {
 		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
@@ -4718,12 +4718,12 @@ xfs_bmap_del_extent(
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
@@ -5070,7 +5070,7 @@ xfs_bunmapi(
 		*done = 1;
 		return 0;
 	}
-	XFS_STATS_INC(xs_blk_unmap);
+	XFS_STATS_INC(mp, xs_blk_unmap);
 	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
 	start = bno;
 	bno = start + len - 1;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8f18bab..e42d969 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -84,22 +84,23 @@ union xfs_btree_rec {
 /*
  * Generic stats interface
  */
-#define __XFS_BTREE_STATS_INC(type, stat) \
-	XFS_STATS_INC(xs_ ## type ## _2_ ## stat)
-#define XFS_BTREE_STATS_INC(cur, stat)  \
+#define __XFS_BTREE_STATS_INC(mp, type, stat)		\
+	XFS_STATS_INC(mp, xs_ ## type ## _2_ ## stat)
+#define XFS_BTREE_STATS_INC(cur, stat)	\
 do {    \
+	struct xfs_mount *mp = cur->bc_mp; \
 	switch (cur->bc_btnum) {  \
-	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(abtb, stat); break;	\
-	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(abtc, stat); break;	\
-	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
-	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
-	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
+	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(mp, abtb, stat); break; \
+	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(mp, abtc, stat); break; \
+	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(mp, bmbt, stat); break; \
+	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(mp, ibt, stat); break; \
+	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(mp, fibt, stat); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
 
 #define __XFS_BTREE_STATS_ADD(type, stat, val) \
-	XFS_STATS_ADD(xs_ ## type ## _2_ ## stat, val)
+	XFS_STATS_ADD(cur->bc_mp, xs_ ## type ## _2_ ## stat, val)
 #define XFS_BTREE_STATS_ADD(cur, stat, val)  \
 do {    \
 	switch (cur->bc_btnum) {  \
@@ -108,7 +109,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break; \
 	}       \
 } while (0)
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 9de401d..2fb53a5 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -271,7 +271,7 @@ xfs_dir_createname(
 		rval = xfs_dir_ino_validate(tp->t_mountp, inum);
 		if (rval)
 			return rval;
-		XFS_STATS_INC(xs_dir_create);
+		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
@@ -365,7 +365,7 @@ xfs_dir_lookup(
 	int		lock_mode;
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
-	XFS_STATS_INC(xs_dir_lookup);
+	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
 
 	/*
 	 * We need to use KM_NOFS here so that lockdep will not throw false
@@ -444,7 +444,7 @@ xfs_dir_removename(
 	int		v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
-	XFS_STATS_INC(xs_dir_remove);
+	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
 	if (!args)
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 65fb37a..0ef7c2e 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -511,7 +511,7 @@ xfs_attr_list_int(
 	xfs_inode_t *dp = context->dp;
 	uint		lock_mode;
 
-	XFS_STATS_INC(xs_attr_list);
+	XFS_STATS_INC(dp->i_mount, xs_attr_list);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8ecffb3..90815c2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -201,7 +201,7 @@ _xfs_buf_alloc(
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
 
-	XFS_STATS_INC(xb_create);
+	XFS_STATS_INC(target->bt_mount, xb_create);
 	trace_xfs_buf_init(bp, _RET_IP_);
 
 	return bp;
@@ -357,12 +357,12 @@ retry:
 		"possible memory allocation deadlock in %s (mode:0x%x)",
 					__func__, gfp_mask);
 
-			XFS_STATS_INC(xb_page_retries);
+			XFS_STATS_INC(bp->b_target->bt_mount, xb_page_retries);
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
 			goto retry;
 		}
 
-		XFS_STATS_INC(xb_page_found);
+		XFS_STATS_INC(bp->b_target->bt_mount, xb_page_found);
 
 		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
 		size -= nbytes;
@@ -516,7 +516,7 @@ _xfs_buf_find(
 		new_bp->b_pag = pag;
 		spin_unlock(&pag->pag_buf_lock);
 	} else {
-		XFS_STATS_INC(xb_miss_locked);
+		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
 		spin_unlock(&pag->pag_buf_lock);
 		xfs_perag_put(pag);
 	}
@@ -529,11 +529,11 @@ found:
 	if (!xfs_buf_trylock(bp)) {
 		if (flags & XBF_TRYLOCK) {
 			xfs_buf_rele(bp);
-			XFS_STATS_INC(xb_busy_locked);
+			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
 			return NULL;
 		}
 		xfs_buf_lock(bp);
-		XFS_STATS_INC(xb_get_locked_waited);
+		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
 	}
 
 	/*
@@ -549,7 +549,7 @@ found:
 	}
 
 	trace_xfs_buf_find(bp, flags, _RET_IP_);
-	XFS_STATS_INC(xb_get_locked);
+	XFS_STATS_INC(btp->bt_mount, xb_get_locked);
 	return bp;
 }
 
@@ -603,7 +603,7 @@ found:
 		}
 	}
 
-	XFS_STATS_INC(xb_get);
+	XFS_STATS_INC(target->bt_mount, xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	return bp;
 }
@@ -643,7 +643,7 @@ xfs_buf_read_map(
 		trace_xfs_buf_read(bp, flags, _RET_IP_);
 
 		if (!XFS_BUF_ISDONE(bp)) {
-			XFS_STATS_INC(xb_get_read);
+			XFS_STATS_INC(target->bt_mount, xb_get_read);
 			bp->b_ops = ops;
 			_xfs_buf_read(bp, flags);
 		} else if (flags & XBF_ASYNC) {
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index a989a9c..642d55d 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -666,7 +666,7 @@ xfs_readdir(
 		return -EIO;
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
-	XFS_STATS_INC(xs_dir_getdents);
+	XFS_STATS_INC(dp->i_mount, xs_dir_getdents);
 
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 30cb3af..c801a0b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -77,7 +77,7 @@ xfs_qm_dqdestroy(
 	mutex_destroy(&dqp->q_qlock);
 	kmem_zone_free(xfs_qm_dqzone, dqp);
 
-	XFS_STATS_DEC(xs_qm_dquot);
+	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot);
 }
 
 /*
@@ -605,7 +605,7 @@ xfs_qm_dqread(
 		break;
 	}
 
-	XFS_STATS_INC(xs_qm_dquot);
+	XFS_STATS_INC(dqp->q_mount, xs_qm_dquot);
 
 	trace_xfs_dqread(dqp);
 
@@ -747,12 +747,12 @@ restart:
 		mutex_unlock(&qi->qi_tree_lock);
 
 		trace_xfs_dqget_hit(dqp);
-		XFS_STATS_INC(xs_qm_dqcachehits);
+		XFS_STATS_INC(dqp->q_mount, xs_qm_dqcachehits);
 		*O_dqpp = dqp;
 		return 0;
 	}
 	mutex_unlock(&qi->qi_tree_lock);
-	XFS_STATS_INC(xs_qm_dqcachemisses);
+	XFS_STATS_INC(dqp->q_mount, xs_qm_dqcachemisses);
 
 	/*
 	 * Dquot cache miss. We don't want to keep the inode lock across
@@ -806,7 +806,7 @@ restart:
 		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_dup(dqp);
 		xfs_qm_dqdestroy(dqp);
-		XFS_STATS_INC(xs_qm_dquot_dups);
+		XFS_STATS_INC(dqp->q_mount, xs_qm_dquot_dups);
 		goto restart;
 	}
 
@@ -846,7 +846,7 @@ xfs_qm_dqput(
 		trace_xfs_dqput_free(dqp);
 
 		if (list_lru_add(&qi->qi_lru, &dqp->q_lru))
-			XFS_STATS_INC(xs_qm_dquot_unused);
+			XFS_STATS_INC(dqp->q_mount, xs_qm_dquot_unused);
 	}
 	xfs_dqunlock(dqp);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e78feb4..088e509 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -287,7 +287,7 @@ xfs_file_read_iter(
 	xfs_fsize_t		n;
 	loff_t			pos = iocb->ki_pos;
 
-	XFS_STATS_INC(xs_read_calls);
+	XFS_STATS_INC(mp, xs_read_calls);
 
 	if (unlikely(iocb->ki_flags & IOCB_DIRECT))
 		ioflags |= XFS_IO_ISDIRECT;
@@ -365,7 +365,7 @@ xfs_file_read_iter(
 
 	ret = generic_file_read_iter(iocb, to);
 	if (ret > 0)
-		XFS_STATS_ADD(xs_read_bytes, ret);
+		XFS_STATS_ADD(mp, xs_read_bytes, ret);
 
 	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 	return ret;
@@ -383,7 +383,7 @@ xfs_file_splice_read(
 	int			ioflags = 0;
 	ssize_t			ret;
 
-	XFS_STATS_INC(xs_read_calls);
+	XFS_STATS_INC(ip->i_mount, xs_read_calls);
 
 	if (infilp->f_mode & FMODE_NOCMTIME)
 		ioflags |= XFS_IO_INVIS;
@@ -401,7 +401,7 @@ xfs_file_splice_read(
 	else
 		ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
 	if (ret > 0)
-		XFS_STATS_ADD(xs_read_bytes, ret);
+		XFS_STATS_ADD(ip->i_mount, xs_read_bytes, ret);
 
 	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 	return ret;
@@ -867,7 +867,7 @@ xfs_file_write_iter(
 	ssize_t			ret;
 	size_t			ocount = iov_iter_count(from);
 
-	XFS_STATS_INC(xs_write_calls);
+	XFS_STATS_INC(ip->i_mount, xs_write_calls);
 
 	if (ocount == 0)
 		return 0;
@@ -883,7 +883,7 @@ xfs_file_write_iter(
 	if (ret > 0) {
 		ssize_t err;
 
-		XFS_STATS_ADD(xs_write_bytes, ret);
+		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
 
 		/* Handle various SYNC-type writes */
 		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0a326bd..d7a490f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -63,7 +63,7 @@ xfs_inode_alloc(
 		return NULL;
 	}
 
-	XFS_STATS_INC(vn_active);
+	XFS_STATS_INC(mp, vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(!xfs_isiflocked(ip));
@@ -129,7 +129,7 @@ xfs_inode_free(
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!xfs_isiflocked(ip));
-	XFS_STATS_DEC(vn_active);
+	XFS_STATS_DEC(ip->i_mount, vn_active);
 
 	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
 }
@@ -159,7 +159,7 @@ xfs_iget_cache_hit(
 	spin_lock(&ip->i_flags_lock);
 	if (ip->i_ino != ino) {
 		trace_xfs_iget_skip(ip);
-		XFS_STATS_INC(xs_ig_frecycle);
+		XFS_STATS_INC(mp, xs_ig_frecycle);
 		error = -EAGAIN;
 		goto out_error;
 	}
@@ -177,7 +177,7 @@ xfs_iget_cache_hit(
 	 */
 	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
 		trace_xfs_iget_skip(ip);
-		XFS_STATS_INC(xs_ig_frecycle);
+		XFS_STATS_INC(mp, xs_ig_frecycle);
 		error = -EAGAIN;
 		goto out_error;
 	}
@@ -259,7 +259,7 @@ xfs_iget_cache_hit(
 		xfs_ilock(ip, lock_flags);
 
 	xfs_iflags_clear(ip, XFS_ISTALE | XFS_IDONTCACHE);
-	XFS_STATS_INC(xs_ig_found);
+	XFS_STATS_INC(mp, xs_ig_found);
 
 	return 0;
 
@@ -342,7 +342,7 @@ xfs_iget_cache_miss(
 	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
 	if (unlikely(error)) {
 		WARN_ON(error != -EEXIST);
-		XFS_STATS_INC(xs_ig_dup);
+		XFS_STATS_INC(mp, xs_ig_dup);
 		error = -EAGAIN;
 		goto out_preload_end;
 	}
@@ -412,7 +412,7 @@ xfs_iget(
 	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
 		return -EINVAL;
 
-	XFS_STATS_INC(xs_ig_attempts);
+	XFS_STATS_INC(mp, xs_ig_attempts);
 
 	/* get the perag structure and ensure that it's inode capable */
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
@@ -429,7 +429,7 @@ again:
 			goto out_error_or_again;
 	} else {
 		rcu_read_unlock();
-		XFS_STATS_INC(xs_ig_missed);
+		XFS_STATS_INC(mp, xs_ig_missed);
 
 		error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip,
 							flags, lock_flags);
@@ -965,7 +965,7 @@ reclaim:
 	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
-	XFS_STATS_INC(xs_ig_reclaims);
+	XFS_STATS_INC(ip->i_mount, xs_ig_reclaims);
 	/*
 	 * Remove the inode from the per-AG radix tree.
 	 *
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dc40a6d..a0f2bae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3271,8 +3271,8 @@ xfs_iflush_cluster(
 	}
 
 	if (clcount) {
-		XFS_STATS_INC(xs_icluster_flushcnt);
-		XFS_STATS_ADD(xs_icluster_flushinode, clcount);
+		XFS_STATS_INC(mp, xs_icluster_flushcnt);
+		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
 	}
 
 out_free:
@@ -3345,7 +3345,7 @@ xfs_iflush(
 	struct xfs_dinode	*dip;
 	int			error;
 
-	XFS_STATS_INC(xs_iflush_count);
+	XFS_STATS_INC(mp, xs_iflush_count);
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ea7d85a..b67a130 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1028,7 +1028,7 @@ xfs_ioctl_setattr_xflags(
 	xfs_diflags_to_linux(ip);
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	XFS_STATS_INC(xs_ig_attrchg);
+	XFS_STATS_INC(mp, xs_ig_attrchg);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1f86033..dca69c6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -670,7 +670,7 @@ xfs_iomap_write_allocate(
 	count_fsb = imap->br_blockcount;
 	map_start_fsb = imap->br_startoff;
 
-	XFS_STATS_ADD(xs_xstrat_bytes, XFS_FSB_TO_B(mp, count_fsb));
+	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, count_fsb));
 
 	while (count_fsb != 0) {
 		/*
@@ -777,7 +777,7 @@ xfs_iomap_write_allocate(
 		if ((offset_fsb >= imap->br_startoff) &&
 		    (offset_fsb < (imap->br_startoff +
 				   imap->br_blockcount))) {
-			XFS_STATS_INC(xs_xstrat_quick);
+			XFS_STATS_INC(mp, xs_xstrat_quick);
 			return 0;
 		}
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8294132..245268a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -695,7 +695,7 @@ xfs_setattr_nonsize(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	XFS_STATS_INC(xs_ig_attrchg);
+	XFS_STATS_INC(mp, xs_ig_attrchg);
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
@@ -922,7 +922,7 @@ xfs_setattr_size(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	XFS_STATS_INC(xs_ig_attrchg);
+	XFS_STATS_INC(mp, xs_ig_attrchg);
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index aaadee0..4012523 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -268,7 +268,7 @@ xlog_grant_head_wait(
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock(&head->lock);
 
-		XFS_STATS_INC(xs_sleep_logspace);
+		XFS_STATS_INC(log->l_mp, xs_sleep_logspace);
 
 		trace_xfs_log_grant_sleep(log, tic);
 		schedule();
@@ -379,7 +379,7 @@ xfs_log_regrant(
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
-	XFS_STATS_INC(xs_try_logspace);
+	XFS_STATS_INC(mp, xs_try_logspace);
 
 	/*
 	 * This is a new transaction on the ticket, so we need to change the
@@ -448,7 +448,7 @@ xfs_log_reserve(
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
-	XFS_STATS_INC(xs_try_logspace);
+	XFS_STATS_INC(mp, xs_try_logspace);
 
 	ASSERT(*ticp == NULL);
 	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
@@ -1768,7 +1768,7 @@ xlog_sync(
 	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
 	int		size;
 
-	XFS_STATS_INC(xs_log_writes);
+	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
 	/* Add for LR header */
@@ -1805,7 +1805,7 @@ xlog_sync(
 	bp = iclog->ic_bp;
 	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn)));
 
-	XFS_STATS_ADD(xs_log_blocks, BTOBB(count));
+	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
 
 	/* Do we need to split this write into 2 parts? */
 	if (XFS_BUF_ADDR(bp) + BTOBB(count) > log->l_logBBsize) {
@@ -2913,7 +2913,7 @@ restart:
 
 	iclog = log->l_iclog;
 	if (iclog->ic_state != XLOG_STATE_ACTIVE) {
-		XFS_STATS_INC(xs_log_noiclogs);
+		XFS_STATS_INC(log->l_mp, xs_log_noiclogs);
 
 		/* Wait for log writes to have flushed */
 		xlog_wait(&log->l_flush_wait, &log->l_icloglock);
@@ -3212,7 +3212,7 @@ _xfs_log_force(
 	struct xlog_in_core	*iclog;
 	xfs_lsn_t		lsn;
 
-	XFS_STATS_INC(xs_log_force);
+	XFS_STATS_INC(mp, xs_log_force);
 
 	xlog_cil_force(log);
 
@@ -3297,7 +3297,7 @@ maybe_sleep:
 			spin_unlock(&log->l_icloglock);
 			return -EIO;
 		}
-		XFS_STATS_INC(xs_log_force_sleep);
+		XFS_STATS_INC(mp, xs_log_force_sleep);
 		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
 		/*
 		 * No need to grab the log lock here since we're
@@ -3362,7 +3362,7 @@ _xfs_log_force_lsn(
 
 	ASSERT(lsn != 0);
 
-	XFS_STATS_INC(xs_log_force);
+	XFS_STATS_INC(mp, xs_log_force);
 
 	lsn = xlog_cil_force_lsn(log, lsn);
 	if (lsn == NULLCOMMITLSN)
@@ -3411,7 +3411,7 @@ try_again:
 			     (XLOG_STATE_WANT_SYNC | XLOG_STATE_SYNCING))) {
 				ASSERT(!(iclog->ic_state & XLOG_STATE_IOERROR));
 
-				XFS_STATS_INC(xs_log_force_sleep);
+				XFS_STATS_INC(mp, xs_log_force_sleep);
 
 				xlog_wait(&iclog->ic_prev->ic_write_wait,
 							&log->l_icloglock);
@@ -3441,7 +3441,7 @@ try_again:
 				spin_unlock(&log->l_icloglock);
 				return -EIO;
 			}
-			XFS_STATS_INC(xs_log_force_sleep);
+			XFS_STATS_INC(mp, xs_log_force_sleep);
 			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
 			/*
 			 * No need to grab the log lock here since we're
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index eac9549..7af7648 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -184,7 +184,7 @@ xfs_qm_dqpurge(
 	 */
 	ASSERT(!list_empty(&dqp->q_lru));
 	list_lru_del(&qi->qi_lru, &dqp->q_lru);
-	XFS_STATS_DEC(xs_qm_dquot_unused);
+	XFS_STATS_DEC(mp, xs_qm_dquot_unused);
 
 	xfs_qm_dqdestroy(dqp);
 	return 0;
@@ -448,11 +448,11 @@ xfs_qm_dquot_isolate(
 	 */
 	if (dqp->q_nrefs) {
 		xfs_dqunlock(dqp);
-		XFS_STATS_INC(xs_qm_dqwants);
+		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
 
 		trace_xfs_dqreclaim_want(dqp);
 		list_lru_isolate(lru, &dqp->q_lru);
-		XFS_STATS_DEC(xs_qm_dquot_unused);
+		XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
 		return LRU_REMOVED;
 	}
 
@@ -496,19 +496,19 @@ xfs_qm_dquot_isolate(
 
 	ASSERT(dqp->q_nrefs == 0);
 	list_lru_isolate_move(lru, &dqp->q_lru, &isol->dispose);
-	XFS_STATS_DEC(xs_qm_dquot_unused);
+	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
 	trace_xfs_dqreclaim_done(dqp);
-	XFS_STATS_INC(xs_qm_dqreclaims);
+	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaims);
 	return LRU_REMOVED;
 
 out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
-	XFS_STATS_INC(xs_qm_dqreclaim_misses);
+	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
 	return LRU_SKIP;
 
 out_unlock_dirty:
 	trace_xfs_dqreclaim_busy(dqp);
-	XFS_STATS_INC(xs_qm_dqreclaim_misses);
+	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
 	xfs_dqunlock(dqp);
 	spin_lock(lru_lock);
 	return LRU_RETRY;
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index d5b3704..d3c8da3 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -122,11 +122,9 @@ static int xqm_proc_show(struct seq_file *m, void *v)
 {
 	/* maximum; incore; ratio free to inuse; freelist */
 	seq_printf(m, "%d\t%d\t%d\t%u\n",
-			0,
-			counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
-			0,
-			counter_val(xfsstats.xs_stats,
-				XFSSTAT_END_XQMSTAT + 1));
+		       0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
+		       0, counter_val(xfsstats.xs_stats,
+		       XFSSTAT_END_XQMSTAT + 1));
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 00afc13..7e84702 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -224,10 +224,25 @@ struct xfs_mount;
  * We don't disable preempt, not too worried about poking the
  * wrong CPU's stat for now (also aggregated before reporting).
  */
-#define XFS_STATS_INC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v++)
-#define XFS_STATS_DEC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v--)
-#define XFS_STATS_ADD(v, inc)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v \
-				+= (inc))
+#define XFS_STATS_INC(mp, v)		{ per_cpu_ptr(xfsstats.xs_stats, \
+							current_cpu())->v++; \
+							per_cpu_ptr( \
+							mp->m_stats.xs_stats, \
+							current_cpu())->v++; }
+
+#define XFS_STATS_DEC(mp, v)		{ per_cpu_ptr(xfsstats.xs_stats, \
+							current_cpu())->v++; \
+							per_cpu_ptr( \
+							mp->m_stats.xs_stats, \
+							current_cpu())->v--; }
+
+#define XFS_STATS_ADD(mp, v, inc)	{ per_cpu_ptr(xfsstats.xs_stats, \
+							current_cpu())->v \
+							+= (inc); \
+							per_cpu_ptr( \
+							mp->m_stats.xs_stats, \
+							current_cpu())->v \
+							+= (inc); }
 
 extern int xfs_init_procfs(void);
 extern void xfs_cleanup_procfs(void);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3898643..ae07a04 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -922,7 +922,7 @@ xfs_fs_destroy_inode(
 
 	trace_xfs_destroy_inode(ip);
 
-	XFS_STATS_INC(vn_reclaim);
+	XFS_STATS_INC(ip->i_mount, vn_reclaim);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
@@ -983,8 +983,8 @@ xfs_fs_evict_inode(
 
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
-	XFS_STATS_INC(vn_rele);
-	XFS_STATS_INC(vn_remove);
+	XFS_STATS_INC(ip->i_mount, vn_rele);
+	XFS_STATS_INC(ip->i_mount, vn_remove);
 
 	xfs_inactive(ip);
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a0ab1da..748b16a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -930,9 +930,9 @@ __xfs_trans_commit(
 	 */
 	if (sync) {
 		error = _xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
-		XFS_STATS_INC(xs_trans_sync);
+		XFS_STATS_INC(mp, xs_trans_sync);
 	} else {
-		XFS_STATS_INC(xs_trans_async);
+		XFS_STATS_INC(mp, xs_trans_async);
 	}
 
 	return error;
@@ -955,7 +955,7 @@ out_unreserve:
 	xfs_trans_free_items(tp, NULLCOMMITLSN, !!error);
 	xfs_trans_free(tp);
 
-	XFS_STATS_INC(xs_trans_empty);
+	XFS_STATS_INC(mp, xs_trans_empty);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1098cf4..4f18fd9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -349,7 +349,7 @@ xfsaild_push(
 	     xfs_ail_min_lsn(ailp))) {
 		ailp->xa_log_flush = 0;
 
-		XFS_STATS_INC(xs_push_ail_flush);
+		XFS_STATS_INC(mp, xs_push_ail_flush);
 		xfs_log_force(mp, XFS_LOG_SYNC);
 	}
 
@@ -371,7 +371,7 @@ xfsaild_push(
 		goto out_done;
 	}
 
-	XFS_STATS_INC(xs_push_ail);
+	XFS_STATS_INC(mp, xs_push_ail);
 
 	lsn = lip->li_lsn;
 	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
@@ -385,7 +385,7 @@ xfsaild_push(
 		lock_result = lip->li_ops->iop_push(lip, &ailp->xa_buf_list);
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
-			XFS_STATS_INC(xs_push_ail_success);
+			XFS_STATS_INC(mp, xs_push_ail_success);
 			trace_xfs_ail_push(lip);
 
 			ailp->xa_last_pushed_lsn = lsn;
@@ -403,7 +403,7 @@ xfsaild_push(
 			 * re-try the flushing relatively soon if most of the
 			 * AIL is beeing flushed.
 			 */
-			XFS_STATS_INC(xs_push_ail_flushing);
+			XFS_STATS_INC(mp, xs_push_ail_flushing);
 			trace_xfs_ail_flushing(lip);
 
 			flushing++;
@@ -411,14 +411,14 @@ xfsaild_push(
 			break;
 
 		case XFS_ITEM_PINNED:
-			XFS_STATS_INC(xs_push_ail_pinned);
+			XFS_STATS_INC(mp, xs_push_ail_pinned);
 			trace_xfs_ail_pinned(lip);
 
 			stuck++;
 			ailp->xa_log_flush++;
 			break;
 		case XFS_ITEM_LOCKED:
-			XFS_STATS_INC(xs_push_ail_locked);
+			XFS_STATS_INC(mp, xs_push_ail_locked);
 			trace_xfs_ail_locked(lip);
 
 			stuck++;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
