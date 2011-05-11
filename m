Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7DAM128047 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B60A814CA3BA
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id r06KxEBMesJUqAdd for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QKB0J-0005dI-DI
	for xfs@oss.sgi.com; Wed, 11 May 2011 15:07:11 +0000
Message-Id: <20110511150711.367977044@bombadil.infradead.org>
Date: Wed, 11 May 2011 11:04:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/9] xfs: remove the unused XFS_BMAPI_RSVBLOCKS flag
References: <20110511150402.258164661@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_BMAPI_RSVBLOCKS
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

The XFS_BMAPI_RSVBLOCKS is unused, and as far as I can see has always been.
Remove it to simplify the bmapi implementation and conserve stack space.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-10 12:05:00.662952211 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-05-10 12:05:19.866950315 +0200
@@ -101,8 +101,7 @@ xfs_bmap_add_extent(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	int			whichfork, /* data or attr fork */
-	int			rsvd);	/* OK to allocate reserved blocks */
+	int			whichfork); /* data or attr fork */
 
 /*
  * Called by xfs_bmap_add_extent to handle cases converting a delayed
@@ -117,8 +116,7 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		*dnew,	/* new delayed-alloc indirect blocks */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	int			*logflagsp, /* inode logging flags */
-	int			rsvd);	/* OK to allocate reserved blocks */
+	int			*logflagsp); /* inode logging flags */
 
 /*
  * Called by xfs_bmap_add_extent to handle cases converting a hole
@@ -129,8 +127,7 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp,/* inode logging flags */
-	int			rsvd);	/* OK to allocate reserved blocks */
+	int			*logflagsp); /* inode logging flags */
 
 /*
  * Called by xfs_bmap_add_extent to handle cases converting a hole
@@ -180,22 +177,6 @@ xfs_bmap_btree_to_extents(
 	int			whichfork); /* data or attr fork */
 
 /*
- * Called by xfs_bmapi to update file extent records and the btree
- * after removing space (or undoing a delayed allocation).
- */
-STATIC int				/* error */
-xfs_bmap_del_extent(
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_trans_t		*tp,	/* current trans pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	xfs_btree_cur_t		*cur,	/* if null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp,/* inode logging flags */
-	int			whichfork, /* data or attr fork */
-	int			rsvd);	 /* OK to allocate reserved blocks */
-
-/*
  * Remove the entry "free" from the free item list.  Prev points to the
  * previous entry, unless "free" is the head of the list.
  */
@@ -480,8 +461,7 @@ xfs_bmap_add_extent(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	int			whichfork, /* data or attr fork */
-	int			rsvd)	/* OK to use reserved data blocks */
+	int			whichfork) /* data or attr fork */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor or null */
 	xfs_filblks_t		da_new; /* new count del alloc blocks used */
@@ -522,8 +502,8 @@ xfs_bmap_add_extent(
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
-		if ((error = xfs_bmap_add_extent_hole_delay(ip, idx, new,
-				&logflags, rsvd)))
+		error = xfs_bmap_add_extent_hole_delay(ip, idx, new, &logflags);
+		if (error)
 			goto done;
 	}
 	/*
@@ -557,9 +537,10 @@ xfs_bmap_add_extent(
 				if (cur)
 					ASSERT(cur->bc_private.b.flags &
 						XFS_BTCUR_BPRV_WASDEL);
-				if ((error = xfs_bmap_add_extent_delay_real(ip,
-					idx, &cur, new, &da_new, first, flist,
-					&logflags, rsvd)))
+				error = xfs_bmap_add_extent_delay_real(ip, idx,
+						&cur, new, &da_new, first,
+						flist, &logflags);
+				if (error)
 					goto done;
 			} else if (new->br_state == XFS_EXT_NORM) {
 				ASSERT(new->br_state == XFS_EXT_NORM);
@@ -615,7 +596,7 @@ xfs_bmap_add_extent(
 		ASSERT(nblks <= da_old);
 		if (nblks < da_old)
 			xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
-				(int64_t)(da_old - nblks), rsvd);
+				(int64_t)(da_old - nblks), 0);
 	}
 	/*
 	 * Clear out the allocated field, done with it now in any case.
@@ -646,8 +627,7 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		*dnew,	/* new delayed-alloc indirect blocks */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	int			*logflagsp, /* inode logging flags */
-	int			rsvd)	/* OK to use reserved data block allocation */
+	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
 	int			diff;	/* temp value */
@@ -1097,7 +1077,7 @@ xfs_bmap_add_extent_delay_real(
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
 		    xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
-					     -((int64_t)diff), rsvd)) {
+					     -((int64_t)diff), 0)) {
 			/*
 			 * Ick gross gag me with a spoon.
 			 */
@@ -1109,7 +1089,7 @@ xfs_bmap_add_extent_delay_real(
 					if (!diff ||
 					    !xfs_icsb_modify_counters(ip->i_mount,
 						    XFS_SBS_FDBLOCKS,
-						    -((int64_t)diff), rsvd))
+						    -((int64_t)diff), 0))
 						break;
 				}
 				if (temp2) {
@@ -1118,7 +1098,7 @@ xfs_bmap_add_extent_delay_real(
 					if (!diff ||
 					    !xfs_icsb_modify_counters(ip->i_mount,
 						    XFS_SBS_FDBLOCKS,
-						    -((int64_t)diff), rsvd))
+						    -((int64_t)diff), 0))
 						break;
 				}
 			}
@@ -1652,8 +1632,7 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp, /* inode logging flags */
-	int			rsvd)		/* OK to allocate reserved blocks */
+	int			*logflagsp) /* inode logging flags */
 {
 	xfs_bmbt_rec_host_t	*ep;	/* extent record for idx */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
@@ -1787,7 +1766,7 @@ xfs_bmap_add_extent_hole_delay(
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
 		xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
-			(int64_t)(oldlen - newlen), rsvd);
+			(int64_t)(oldlen - newlen), 0);
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
@@ -2838,8 +2817,7 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
-	int			whichfork, /* data or attr fork */
-	int			rsvd)	/* OK to allocate reserved blocks */
+	int			whichfork) /* data or attr fork */
 {
 	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
 	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
@@ -3142,7 +3120,7 @@ xfs_bmap_del_extent(
 	ASSERT(da_old >= da_new);
 	if (da_old > da_new) {
 		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-			(int64_t)(da_old - da_new), rsvd);
+			(int64_t)(da_old - da_new), 0);
 	}
 done:
 	*logflagsp = flags;
@@ -4562,29 +4540,24 @@ xfs_bmapi(
 				if (rt) {
 					error = xfs_mod_incore_sb(mp,
 							XFS_SBS_FREXTENTS,
-							-((int64_t)extsz), (flags &
-							XFS_BMAPI_RSVBLOCKS));
+							-((int64_t)extsz), 0);
 				} else {
 					error = xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
-							-((int64_t)alen), (flags &
-							XFS_BMAPI_RSVBLOCKS));
+							-((int64_t)alen), 0);
 				}
 				if (!error) {
 					error = xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
-							-((int64_t)indlen), (flags &
-							XFS_BMAPI_RSVBLOCKS));
+							-((int64_t)indlen), 0);
 					if (error && rt)
 						xfs_mod_incore_sb(mp,
 							XFS_SBS_FREXTENTS,
-							(int64_t)extsz, (flags &
-							XFS_BMAPI_RSVBLOCKS));
+							(int64_t)extsz, 0);
 					else if (error)
 						xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
-							(int64_t)alen, (flags &
-							XFS_BMAPI_RSVBLOCKS));
+							(int64_t)alen, 0);
 				}
 
 				if (error) {
@@ -4703,7 +4676,7 @@ xfs_bmapi(
 			}
 			error = xfs_bmap_add_extent(ip, lastx, &cur, &got,
 				firstblock, flist, &tmp_logflags,
-				whichfork, (flags & XFS_BMAPI_RSVBLOCKS));
+				whichfork);
 			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
@@ -4805,7 +4778,7 @@ xfs_bmapi(
 						: XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent(ip, lastx, &cur, mval,
 				firstblock, flist, &tmp_logflags,
-				whichfork, (flags & XFS_BMAPI_RSVBLOCKS));
+				whichfork);
 			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
@@ -5026,7 +4999,6 @@ xfs_bunmapi(
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
-	int			rsvd;		/* OK to allocate reserved blocks */
 	xfs_fsblock_t		sum;
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
@@ -5044,7 +5016,7 @@ xfs_bunmapi(
 	mp = ip->i_mount;
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
-	rsvd = (flags & XFS_BMAPI_RSVBLOCKS) != 0;
+
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
 	ASSERT(ifp->if_ext_max ==
@@ -5162,7 +5134,7 @@ xfs_bunmapi(
 			del.br_state = XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent(ip, lastx, &cur, &del,
 				firstblock, flist, &logflags,
-				XFS_DATA_FORK, 0);
+				XFS_DATA_FORK);
 			if (error)
 				goto error0;
 			goto nodelete;
@@ -5216,7 +5188,7 @@ xfs_bunmapi(
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent(ip, lastx - 1, &cur,
 					&prev, firstblock, flist, &logflags,
-					XFS_DATA_FORK, 0);
+					XFS_DATA_FORK);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5225,7 +5197,7 @@ xfs_bunmapi(
 				del.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent(ip, lastx, &cur,
 					&del, firstblock, flist, &logflags,
-					XFS_DATA_FORK, 0);
+					XFS_DATA_FORK);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5240,13 +5212,13 @@ xfs_bunmapi(
 				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
 				do_div(rtexts, mp->m_sb.sb_rextsize);
 				xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
-						(int64_t)rtexts, rsvd);
+						(int64_t)rtexts, 0);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
 				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-						(int64_t)del.br_blockcount, rsvd);
+						(int64_t)del.br_blockcount, 0);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_REGBLKS);
@@ -5278,7 +5250,7 @@ xfs_bunmapi(
 			goto error0;
 		}
 		error = xfs_bmap_del_extent(ip, tp, lastx, flist, cur, &del,
-				&tmp_logflags, whichfork, rsvd);
+				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-04-24 20:52:34.171232490 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-05-10 12:05:19.870955293 +0200
@@ -69,7 +69,6 @@ typedef	struct xfs_bmap_free
 #define XFS_BMAPI_ENTIRE	0x004	/* return entire extent, not trimmed */
 #define XFS_BMAPI_METADATA	0x008	/* mapping metadata not user data */
 #define XFS_BMAPI_ATTRFORK	0x010	/* use attribute fork not data */
-#define XFS_BMAPI_RSVBLOCKS	0x020	/* OK to alloc. reserved data blocks */
 #define	XFS_BMAPI_PREALLOC	0x040	/* preallocation op: unwritten space */
 #define	XFS_BMAPI_IGSTATE	0x080	/* Ignore state - */
 					/* combine contig. space */
@@ -87,7 +86,6 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
 	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
-	{ XFS_BMAPI_RSVBLOCKS,	"RSVBLOCKS" }, \
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
