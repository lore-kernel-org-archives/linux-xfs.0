Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 74C248028
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 15:50:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 35DB08F8071
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 13:50:46 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 93gA0isoPG3wSc84 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2015 13:50:43 -0800 (PST)
Date: Tue, 3 Feb 2015 13:50:43 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/5] xfs: use generic percpu counters for icsb
Message-ID: <20150203215043.GA21885@infradead.org>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422826983-29570-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

FYI, I think we should just get rid of the horrible xfs_mod_incore_sb(_batch)
interface as part of this.  The patch below applies on top of your
series.

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ac4d64e..a45e929b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2212,9 +2212,8 @@ xfs_bmap_add_extent_delay_real(
 		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
 			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
 		if (diff > 0) {
-			error = xfs_mod_incore_sb(bma->ip->i_mount,
-					XFS_SBS_FDBLOCKS,
-					-((int64_t)diff), 0);
+			error = xfs_sb_mod_fdblocks(bma->ip->i_mount,
+					-((int64_t)diff), false);
 			ASSERT(!error);
 			if (error)
 				goto done;
@@ -2265,9 +2264,8 @@ xfs_bmap_add_extent_delay_real(
 			temp += bma->cur->bc_private.b.allocated;
 		ASSERT(temp <= da_old);
 		if (temp < da_old)
-			xfs_mod_incore_sb(bma->ip->i_mount,
-					XFS_SBS_FDBLOCKS,
-					(int64_t)(da_old - temp), 0);
+			xfs_sb_mod_fdblocks(bma->ip->i_mount,
+					(int64_t)(da_old - temp), false);
 	}
 
 	/* clear out the allocated field, done with it now in any case. */
@@ -2944,8 +2942,8 @@ xfs_bmap_add_extent_hole_delay(
 	}
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
-		xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
-			(int64_t)(oldlen - newlen), 0);
+		xfs_sb_mod_fdblocks(ip->i_mount, (int64_t)(oldlen - newlen),
+					false);
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
@@ -4159,19 +4157,15 @@ xfs_bmapi_reserve_delalloc(
 	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
 	ASSERT(indlen > 0);
 
-	if (rt) {
-		error = xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
-					  -((int64_t)extsz), 0);
-	} else {
-		error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS,
-						 -((int64_t)alen), 0);
-	}
+	if (rt)
+		error = xfs_sb_mod_frextents(mp, -((int64_t)extsz));
+	else
+		error = xfs_sb_mod_fdblocks(mp, -((int64_t)alen), false);
 
 	if (error)
 		goto out_unreserve_quota;
 
-	error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS,
-					 -((int64_t)indlen), 0);
+	error = xfs_sb_mod_fdblocks(mp, -((int64_t)indlen), false);
 	if (error)
 		goto out_unreserve_blocks;
 
@@ -4198,9 +4192,9 @@ xfs_bmapi_reserve_delalloc(
 
 out_unreserve_blocks:
 	if (rt)
-		xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS, extsz, 0);
+		xfs_sb_mod_frextents(mp, extsz);
 	else
-		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, alen, 0);
+		xfs_sb_mod_fdblocks(mp, alen, false);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0, rt ?
@@ -5012,10 +5006,8 @@ xfs_bmap_del_extent(
 	 * Nothing to do for disk quota accounting here.
 	 */
 	ASSERT(da_old >= da_new);
-	if (da_old > da_new) {
-		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS,
-			(int64_t)(da_old - da_new), 0);
-	}
+	if (da_old > da_new)
+		xfs_sb_mod_fdblocks(mp, (int64_t)(da_old - da_new), false);
 done:
 	*logflagsp = flags;
 	return error;
@@ -5284,14 +5276,13 @@ xfs_bunmapi(
 
 				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
 				do_div(rtexts, mp->m_sb.sb_rextsize);
-				xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
-						(int64_t)rtexts, 0);
+				xfs_sb_mod_frextents(mp, (int64_t)rtexts);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
-				xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS,
-						(int64_t)del.br_blockcount, 0);
+				xfs_sb_mod_fdblocks(mp,
+					(int64_t)del.br_blockcount, false);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_REGBLKS);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2c8d11f..2a6dfac 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -175,69 +175,6 @@ typedef struct xfs_dsb {
 } xfs_dsb_t;
 
 /*
- * Sequence number values for the fields.
- */
-typedef enum {
-	XFS_SBS_MAGICNUM, XFS_SBS_BLOCKSIZE, XFS_SBS_DBLOCKS, XFS_SBS_RBLOCKS,
-	XFS_SBS_REXTENTS, XFS_SBS_UUID, XFS_SBS_LOGSTART, XFS_SBS_ROOTINO,
-	XFS_SBS_RBMINO, XFS_SBS_RSUMINO, XFS_SBS_REXTSIZE, XFS_SBS_AGBLOCKS,
-	XFS_SBS_AGCOUNT, XFS_SBS_RBMBLOCKS, XFS_SBS_LOGBLOCKS,
-	XFS_SBS_VERSIONNUM, XFS_SBS_SECTSIZE, XFS_SBS_INODESIZE,
-	XFS_SBS_INOPBLOCK, XFS_SBS_FNAME, XFS_SBS_BLOCKLOG,
-	XFS_SBS_SECTLOG, XFS_SBS_INODELOG, XFS_SBS_INOPBLOG, XFS_SBS_AGBLKLOG,
-	XFS_SBS_REXTSLOG, XFS_SBS_INPROGRESS, XFS_SBS_IMAX_PCT, XFS_SBS_ICOUNT,
-	XFS_SBS_IFREE, XFS_SBS_FDBLOCKS, XFS_SBS_FREXTENTS, XFS_SBS_UQUOTINO,
-	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
-	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
-	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
-	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
-	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
-	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
-	XFS_SBS_FIELDCOUNT
-} xfs_sb_field_t;
-
-/*
- * Mask values, defined based on the xfs_sb_field_t values.
- * Only define the ones we're using.
- */
-#define	XFS_SB_MVAL(x)		(1LL << XFS_SBS_ ## x)
-#define	XFS_SB_UUID		XFS_SB_MVAL(UUID)
-#define	XFS_SB_FNAME		XFS_SB_MVAL(FNAME)
-#define	XFS_SB_ROOTINO		XFS_SB_MVAL(ROOTINO)
-#define	XFS_SB_RBMINO		XFS_SB_MVAL(RBMINO)
-#define	XFS_SB_RSUMINO		XFS_SB_MVAL(RSUMINO)
-#define	XFS_SB_VERSIONNUM	XFS_SB_MVAL(VERSIONNUM)
-#define XFS_SB_UQUOTINO		XFS_SB_MVAL(UQUOTINO)
-#define XFS_SB_GQUOTINO		XFS_SB_MVAL(GQUOTINO)
-#define XFS_SB_QFLAGS		XFS_SB_MVAL(QFLAGS)
-#define XFS_SB_SHARED_VN	XFS_SB_MVAL(SHARED_VN)
-#define XFS_SB_UNIT		XFS_SB_MVAL(UNIT)
-#define XFS_SB_WIDTH		XFS_SB_MVAL(WIDTH)
-#define XFS_SB_ICOUNT		XFS_SB_MVAL(ICOUNT)
-#define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
-#define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
-#define XFS_SB_FEATURES2	(XFS_SB_MVAL(FEATURES2) | \
-				 XFS_SB_MVAL(BAD_FEATURES2))
-#define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
-#define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
-#define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
-#define XFS_SB_FEATURES_LOG_INCOMPAT XFS_SB_MVAL(FEATURES_LOG_INCOMPAT)
-#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
-#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
-#define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
-#define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
-#define	XFS_SB_MOD_BITS		\
-	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
-	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
-	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
-	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_FEATURES_COMPAT | XFS_SB_FEATURES_RO_COMPAT | \
-	 XFS_SB_FEATURES_INCOMPAT | XFS_SB_FEATURES_LOG_INCOMPAT | \
-	 XFS_SB_PQUOTINO)
-
-
-/*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
  * a feature bit is set when the flag is used.
  */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 28389e0..be2d795e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -749,7 +749,7 @@ out:
 		 * the extra reserve blocks from the reserve.....
 		 */
 		int error;
-		error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, fdblks_delta, 0);
+		error = xfs_sb_mod_fdblocks(mp, fdblks_delta, false);
 		if (error == -ENOSPC)
 			goto retry;
 	}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 07498f0..8a6bbf4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1082,292 +1082,135 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	return xfs_sync_sb(mp, true);
 }
 
-/*
- * xfs_mod_incore_sb_unlocked() is a utility routine commonly used to apply
- * a delta to a specified field in the in-core superblock.  Simply
- * switch on the field indicated and apply the delta to that field.
- * Fields are not allowed to dip below zero, so if the delta would
- * do this do not apply it and return EINVAL.
- *
- * The m_sb_lock must be held when this routine is called.
- */
-STATIC int
-xfs_mod_incore_sb_unlocked(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field,
-	int64_t		delta,
-	int		rsvd)
+int
+xfs_sb_mod_fdblocks(
+	struct xfs_mount	*mp,
+	int64_t			delta,
+	bool			rsvd)
 {
-	int		scounter;	/* short counter for 32 bit fields */
-	long long	lcounter;	/* long counter for 64 bit fields */
-	long long	res_used;
-	s32		batch;
+	int64_t			lcounter;
+	long long		res_used;
+	s32			batch;
 
-	/*
-	 * With the in-core superblock spin lock held, switch
-	 * on the indicated field.  Apply the delta to the
-	 * proper field.  If the fields value would dip below
-	 * 0, then do not apply the delta and return EINVAL.
-	 */
-	switch (field) {
-	case XFS_SBS_ICOUNT:
-		/* deltas are +/-64, hence the large batch size of 128. */
-		__percpu_counter_add(&mp->m_sb.sb_icount, delta, 128);
-		if (percpu_counter_compare(&mp->m_sb.sb_icount, 0) < 0) {
-			ASSERT(0);
-			percpu_counter_add(&mp->m_sb.sb_icount, -delta);
-			return -EINVAL;
-		}
-		return 0;
-	case XFS_SBS_IFREE:
-		percpu_counter_add(&mp->m_sb.sb_ifree, delta);
-		if (percpu_counter_compare(&mp->m_sb.sb_ifree, 0) < 0) {
-			ASSERT(0);
-			percpu_counter_add(&mp->m_sb.sb_ifree, -delta);
-			return -EINVAL;
+	if (delta > 0) {		/* Putting blocks back */
+		if (mp->m_resblks == mp->m_resblks_avail) {
+			percpu_counter_add(&mp->m_sb.sb_fdblocks, delta);
+			return 0;
 		}
-		return 0;
-	case XFS_SBS_FDBLOCKS:
-
-		if (delta > 0) {		/* Putting blocks back */
-			if (mp->m_resblks == mp->m_resblks_avail) {
-				percpu_counter_add(&mp->m_sb.sb_fdblocks, delta);
-				return 0;
-			}
 
-			/* put blocks back into reserve pool first */
-			spin_lock(&mp->m_sb_lock);
-			res_used = (long long)
-					(mp->m_resblks - mp->m_resblks_avail);
+		/* put blocks back into reserve pool first */
+		spin_lock(&mp->m_sb_lock);
+		res_used = (long long)
+				(mp->m_resblks - mp->m_resblks_avail);
 
-			if (res_used > delta) {
-				mp->m_resblks_avail += delta;
-			} else {
-				delta -= res_used;
+		if (res_used > delta) {
+			mp->m_resblks_avail += delta;
+		} else {
+			delta -= res_used;
 				mp->m_resblks_avail = mp->m_resblks;
-				percpu_counter_add(&mp->m_sb.sb_fdblocks, delta);
-			}
-			spin_unlock(&mp->m_sb_lock);
-			return 0;
-
+			percpu_counter_add(&mp->m_sb.sb_fdblocks, delta);
 		}
+		spin_unlock(&mp->m_sb_lock);
+		return 0;
 
-		/*
-		 * Taking blocks away, need to be more accurate the closer we
-		 * are to zero.
-		 *
-		 * batch size is set to a maximum of 1024 blocks - if we are
-		 * allocating of freeing extents larger than this then we aren't
-		 * going to be hammering the counter lock so a lock per update
-		 * is not a problem.
-		 *
-		 * If the counter has a value of less than 2 * max batch size,
-		 * then make everything serialise as we are real close to
-		 * ENOSPC.
-		 */
-#define __BATCH	1024
-		if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
-					   2 * __BATCH) < 0)
-			batch = 1;
-		else
-			batch = __BATCH;
-
-		__percpu_counter_add(&mp->m_sb.sb_fdblocks, delta, batch);
-		if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
-					   XFS_ALLOC_SET_ASIDE(mp)) >= 0) {
-			/* we had space! */
-			return 0;
-		}
+	}
 
-		/*
-		 * lock up the sb for dipping into reserves before releasing
-		 * the space that took us to ENOSPC.
-		 */
-		spin_lock(&mp->m_sb_lock);
-		percpu_counter_add(&mp->m_sb.sb_fdblocks, -delta);
-		if (!rsvd)
-			goto fdblocks_enospc;
-
-		lcounter = (long long)mp->m_resblks_avail + delta;
-		if (lcounter >= 0) {
-			mp->m_resblks_avail = lcounter;
-			spin_unlock(&mp->m_sb_lock);
-			return 0;
-		}
-		printk_once(KERN_WARNING
-			"Filesystem \"%s\": reserve blocks depleted! "
-			"Consider increasing reserve pool size.",
-			mp->m_fsname);
-fdblocks_enospc:
-		spin_unlock(&mp->m_sb_lock);
-		return -ENOSPC;
+	/*
+	 * Taking blocks away, need to be more accurate the closer we
+	 * are to zero.
+	 *
+	 * batch size is set to a maximum of 1024 blocks - if we are
+	 * allocating of freeing extents larger than this then we aren't
+	 * going to be hammering the counter lock so a lock per update
+	 * is not a problem.
+	 *
+	 * If the counter has a value of less than 2 * max batch size,
+	 * then make everything serialise as we are real close to
+	 * ENOSPC.
+	 */
+#define __BATCH	1024
+	if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
+				   2 * __BATCH) < 0)
+		batch = 1;
+	else
+		batch = __BATCH;
 
-	case XFS_SBS_FREXTENTS:
-		lcounter = (long long)mp->m_sb.sb_frextents;
-		lcounter += delta;
-		if (lcounter < 0) {
-			return -ENOSPC;
-		}
-		mp->m_sb.sb_frextents = lcounter;
-		return 0;
-	case XFS_SBS_DBLOCKS:
-		lcounter = (long long)mp->m_sb.sb_dblocks;
-		lcounter += delta;
-		if (lcounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_dblocks = lcounter;
-		return 0;
-	case XFS_SBS_AGCOUNT:
-		scounter = mp->m_sb.sb_agcount;
-		scounter += delta;
-		if (scounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_agcount = scounter;
-		return 0;
-	case XFS_SBS_IMAX_PCT:
-		scounter = mp->m_sb.sb_imax_pct;
-		scounter += delta;
-		if (scounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_imax_pct = scounter;
+	__percpu_counter_add(&mp->m_sb.sb_fdblocks, delta, batch);
+	if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
+				   XFS_ALLOC_SET_ASIDE(mp)) >= 0) {
+		/* we had space! */
 		return 0;
-	case XFS_SBS_REXTSIZE:
-		scounter = mp->m_sb.sb_rextsize;
-		scounter += delta;
-		if (scounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_rextsize = scounter;
-		return 0;
-	case XFS_SBS_RBMBLOCKS:
-		scounter = mp->m_sb.sb_rbmblocks;
-		scounter += delta;
-		if (scounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_rbmblocks = scounter;
-		return 0;
-	case XFS_SBS_RBLOCKS:
-		lcounter = (long long)mp->m_sb.sb_rblocks;
-		lcounter += delta;
-		if (lcounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_rblocks = lcounter;
-		return 0;
-	case XFS_SBS_REXTENTS:
-		lcounter = (long long)mp->m_sb.sb_rextents;
-		lcounter += delta;
-		if (lcounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_rextents = lcounter;
-		return 0;
-	case XFS_SBS_REXTSLOG:
-		scounter = mp->m_sb.sb_rextslog;
-		scounter += delta;
-		if (scounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_rextslog = scounter;
+	}
+
+	/*
+	 * lock up the sb for dipping into reserves before releasing
+	 * the space that took us to ENOSPC.
+	 */
+	spin_lock(&mp->m_sb_lock);
+	percpu_counter_add(&mp->m_sb.sb_fdblocks, -delta);
+	if (!rsvd)
+		goto fdblocks_enospc;
+
+	lcounter = (long long)mp->m_resblks_avail + delta;
+	if (lcounter >= 0) {
+		mp->m_resblks_avail = lcounter;
+		spin_unlock(&mp->m_sb_lock);
 		return 0;
-	default:
-		ASSERT(0);
-		return -EINVAL;
 	}
+	printk_once(KERN_WARNING
+		"Filesystem \"%s\": reserve blocks depleted! "
+		"Consider increasing reserve pool size.",
+		mp->m_fsname);
+fdblocks_enospc:
+	spin_unlock(&mp->m_sb_lock);
+	return -ENOSPC;
 }
 
-/*
- * xfs_mod_incore_sb() is used to change a field in the in-core
- * superblock structure by the specified delta.  This modification
- * is protected by the m_sb_lock.  Just use the xfs_mod_incore_sb_unlocked()
- * routine to do the work.
- */
 int
-xfs_mod_incore_sb(
+xfs_sb_mod_frextents(
 	struct xfs_mount	*mp,
-	xfs_sb_field_t		field,
-	int64_t			delta,
-	int			rsvd)
+	int64_t			delta)
 {
-	int			status;
-
-	switch (field) {
-	case XFS_SBS_ICOUNT:
-	case XFS_SBS_IFREE:
-	case XFS_SBS_FDBLOCKS:
-		return xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
-	default:
-		break;
-	}
+	int64_t			lcounter = mp->m_sb.sb_frextents;
+	int			ret = 0;
 
 	spin_lock(&mp->m_sb_lock);
-	status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
+	lcounter += delta;
+	if (lcounter < 0)
+		ret = -ENOSPC;
+	else
+		mp->m_sb.sb_frextents = lcounter;
 	spin_unlock(&mp->m_sb_lock);
-
-	return status;
+	return ret;
 }
 
-/*
- * Change more than one field in the in-core superblock structure at a time.
- *
- * The fields and changes to those fields are specified in the array of
- * xfs_mod_sb structures passed in.  Either all of the specified deltas
- * will be applied or none of them will.  If any modified field dips below 0,
- * then all modifications will be backed out and EINVAL will be returned.
- *
- * Note that this function may not be used for the superblock values that
- * are tracked with the in-memory per-cpu counters - a direct call to
- * xfs_mod_incore_sb is required for these.
- */
 int
-xfs_mod_incore_sb_batch(
+xfs_sb_mod_icount(
 	struct xfs_mount	*mp,
-	xfs_mod_sb_t		*msb,
-	uint			nmsb,
-	int			rsvd)
+	int64_t			delta)
 {
-	xfs_mod_sb_t		*msbp;
-	int			error = 0;
-
-	/*
-	 * Loop through the array of mod structures and apply each individually.
-	 * If any fail, then back out all those which have already been applied.
-	 * Do all of this within the scope of the m_sb_lock so that all of the
-	 * changes will be atomic.
-	 */
-	spin_lock(&mp->m_sb_lock);
-	for (msbp = msb; msbp < (msb + nmsb); msbp++) {
-		ASSERT(msbp->msb_field < XFS_SBS_ICOUNT ||
-		       msbp->msb_field > XFS_SBS_FDBLOCKS);
-
-		error = xfs_mod_incore_sb_unlocked(mp, msbp->msb_field,
-						   msbp->msb_delta, rsvd);
-		if (error)
-			goto unwind;
+	/* deltas are +/-64, hence the large batch size of 128. */
+	__percpu_counter_add(&mp->m_sb.sb_icount, delta, 128);
+	if (percpu_counter_compare(&mp->m_sb.sb_icount, 0) < 0) {
+		ASSERT(0);
+		percpu_counter_add(&mp->m_sb.sb_icount, -delta);
+		return -EINVAL;
 	}
-	spin_unlock(&mp->m_sb_lock);
 	return 0;
+}
 
-unwind:
-	while (--msbp >= msb) {
-		error = xfs_mod_incore_sb_unlocked(mp, msbp->msb_field,
-						   -msbp->msb_delta, rsvd);
-		ASSERT(error == 0);
+int
+xfs_sb_mod_ifree(
+	struct xfs_mount	*mp,
+	int64_t			delta)
+{
+	percpu_counter_add(&mp->m_sb.sb_ifree, delta);
+	if (percpu_counter_compare(&mp->m_sb.sb_ifree, 0) < 0) {
+		ASSERT(0);
+		percpu_counter_add(&mp->m_sb.sb_ifree, -delta);
+		return -EINVAL;
 	}
-	spin_unlock(&mp->m_sb_lock);
-	return error;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4e22e96..9bb06eb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -249,15 +249,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 /*
- * This structure is for use by the xfs_mod_incore_sb_batch() routine.
- * xfs_growfs can specify a few fields which are more than int limit
- */
-typedef struct xfs_mod_sb {
-	xfs_sb_field_t	msb_field;	/* Field to modify, see below */
-	int64_t		msb_delta;	/* Change to make to specified field */
-} xfs_mod_sb_t;
-
-/*
  * Per-ag incore structure, copies of information in agf and agi, to improve the
  * performance of allocation group selection.
  */
@@ -313,9 +304,6 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
 				     xfs_agnumber_t *maxagi);
 
 extern void	xfs_unmountfs(xfs_mount_t *);
-extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
-extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
-			uint, int);
 extern int	xfs_mount_log_sb(xfs_mount_t *);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
@@ -327,6 +315,11 @@ extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
 extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
+extern int	xfs_sb_mod_fdblocks(struct xfs_mount *, int64_t, bool);
+extern int	xfs_sb_mod_frextents(struct xfs_mount *, int64_t);
+extern int	xfs_sb_mod_icount(struct xfs_mount *, int64_t);
+extern int	xfs_sb_mod_ifree(struct xfs_mount *, int64_t);
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b7da423..b704d5d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -173,7 +173,7 @@ xfs_trans_reserve(
 	uint			rtextents)
 {
 	int		error = 0;
-	int		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	bool		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
 	/* Mark this thread as being in a transaction */
 	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
@@ -184,8 +184,8 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					  -((int64_t)blocks), rsvd);
+		error = xfs_sb_mod_fdblocks(tp->t_mountp,
+					-((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 			return -ENOSPC;
@@ -236,8 +236,8 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (rtextents > 0) {
-		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FREXTENTS,
-					  -((int64_t)rtextents), rsvd);
+		error = xfs_sb_mod_frextents(tp->t_mountp,
+					  -((int64_t)rtextents));
 		if (error) {
 			error = -ENOSPC;
 			goto undo_log;
@@ -268,8 +268,7 @@ undo_log:
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
-					 (int64_t)blocks, rsvd);
+		xfs_sb_mod_fdblocks(tp->t_mountp, (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
 
@@ -488,6 +487,54 @@ xfs_trans_apply_sb_deltas(
 				  sizeof(sbp->sb_frextents) - 1);
 }
 
+STATIC int
+xfs_sb_mod8(
+	uint8_t			*field,
+	int8_t			delta)
+{
+	int8_t			counter = *field;
+
+	counter += delta;
+	if (counter < 0) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+	*field = counter;
+	return 0;
+}
+
+STATIC int
+xfs_sb_mod32(
+	uint32_t		*field,
+	int32_t			delta)
+{
+	int32_t			counter = *field;
+
+	counter += delta;
+	if (counter < 0) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+	*field = counter;
+	return 0;
+}
+
+STATIC int
+xfs_sb_mod64(
+	uint64_t		*field,
+	int64_t			delta)
+{
+	int64_t			counter = *field;
+
+	counter += delta;
+	if (counter < 0) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+	*field = counter;
+	return 0;
+}
+
 /*
  * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
  * and apply superblock counter changes to the in-core superblock.  The
@@ -495,13 +542,6 @@ xfs_trans_apply_sb_deltas(
  * applied to the in-core superblock.  The idea is that that has already been
  * done.
  *
- * This is done efficiently with a single call to xfs_mod_incore_sb_batch().
- * However, we have to ensure that we only modify each superblock field only
- * once because the application of the delta values may not be atomic. That can
- * lead to ENOSPC races occurring if we have two separate modifcations of the
- * free space counter to put back the entire reservation and then take away
- * what we used.
- *
  * If we are not logging superblock counters, then the inode allocated/free and
  * used block counts are not updated in the on disk superblock. In this case,
  * XFS_TRANS_SB_DIRTY will not be set when the transaction is updated but we
@@ -511,18 +551,14 @@ void
 xfs_trans_unreserve_and_mod_sb(
 	xfs_trans_t	*tp)
 {
-	xfs_mod_sb_t	msb[9];	/* If you add cases, add entries */
-	xfs_mod_sb_t	*msbp;
 	xfs_mount_t	*mp = tp->t_mountp;
-	/* REFERENCED */
 	int		error;
-	int		rsvd;
+	bool		rsvd;
 	int64_t		blkdelta = 0;
 	int64_t		rtxdelta = 0;
 	int64_t		idelta = 0;
 	int64_t		ifreedelta = 0;
 
-	msbp = msb;
 	rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
 	/* calculate deltas */
@@ -547,94 +583,110 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply the per-cpu counters */
 	if (blkdelta) {
-		error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, blkdelta, rsvd);
+		error = xfs_sb_mod_fdblocks(mp, blkdelta, rsvd);
 		if (error)
 			goto out;
 	}
 
 	if (idelta) {
-		error = xfs_mod_incore_sb(mp, XFS_SBS_ICOUNT, idelta, rsvd);
+		error = xfs_sb_mod_icount(mp, idelta);
 		if (error)
 			goto out_undo_fdblocks;
 	}
 
 	if (ifreedelta) {
-		error = xfs_mod_incore_sb(mp, XFS_SBS_IFREE, ifreedelta, rsvd);
+		error = xfs_sb_mod_ifree(mp, ifreedelta);
 		if (error)
 			goto out_undo_icount;
 	}
 
 	/* apply remaining deltas */
-	if (rtxdelta != 0) {
-		msbp->msb_field = XFS_SBS_FREXTENTS;
-		msbp->msb_delta = rtxdelta;
-		msbp++;
-	}
+	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
+		return;
 
-	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
-		if (tp->t_dblocks_delta != 0) {
-			msbp->msb_field = XFS_SBS_DBLOCKS;
-			msbp->msb_delta = tp->t_dblocks_delta;
-			msbp++;
-		}
-		if (tp->t_agcount_delta != 0) {
-			msbp->msb_field = XFS_SBS_AGCOUNT;
-			msbp->msb_delta = tp->t_agcount_delta;
-			msbp++;
-		}
-		if (tp->t_imaxpct_delta != 0) {
-			msbp->msb_field = XFS_SBS_IMAX_PCT;
-			msbp->msb_delta = tp->t_imaxpct_delta;
-			msbp++;
-		}
-		if (tp->t_rextsize_delta != 0) {
-			msbp->msb_field = XFS_SBS_REXTSIZE;
-			msbp->msb_delta = tp->t_rextsize_delta;
-			msbp++;
-		}
-		if (tp->t_rbmblocks_delta != 0) {
-			msbp->msb_field = XFS_SBS_RBMBLOCKS;
-			msbp->msb_delta = tp->t_rbmblocks_delta;
-			msbp++;
-		}
-		if (tp->t_rblocks_delta != 0) {
-			msbp->msb_field = XFS_SBS_RBLOCKS;
-			msbp->msb_delta = tp->t_rblocks_delta;
-			msbp++;
-		}
-		if (tp->t_rextents_delta != 0) {
-			msbp->msb_field = XFS_SBS_REXTENTS;
-			msbp->msb_delta = tp->t_rextents_delta;
-			msbp++;
-		}
-		if (tp->t_rextslog_delta != 0) {
-			msbp->msb_field = XFS_SBS_REXTSLOG;
-			msbp->msb_delta = tp->t_rextslog_delta;
-			msbp++;
-		}
+	spin_lock(&mp->m_sb_lock);
+	if (rtxdelta) {
+		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
+		if (error)
+			goto out_undo_ifree;
 	}
-
-	/*
-	 * If we need to change anything, do it.
-	 */
-	if (msbp > msb) {
-		error = xfs_mod_incore_sb_batch(tp->t_mountp, msb,
-			(uint)(msbp - msb), rsvd);
+	if (tp->t_dblocks_delta != 0) {
+		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
 		if (error)
-			goto out_undo_ifreecount;
+			goto out_undo_frextents;
 	}
-
+	if (tp->t_agcount_delta != 0) {
+		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
+		if (error)
+			goto out_undo_dblocks;
+	}
+	if (tp->t_imaxpct_delta != 0) {
+		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
+		if (error)
+			goto out_undo_agcount;
+	}
+	if (tp->t_rextsize_delta != 0) {
+		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize, tp->t_rextsize_delta);
+		if (error)
+			goto out_undo_imaxpct;
+	}
+	if (tp->t_rbmblocks_delta != 0) {
+		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, tp->t_rbmblocks_delta);
+		if (error)
+			goto out_undo_rextsize;
+	}
+	if (tp->t_rblocks_delta != 0) {
+		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
+		if (error)
+			goto out_undo_rbmblocks;
+	}
+	if (tp->t_rextents_delta != 0) {
+		error = xfs_sb_mod64(&mp->m_sb.sb_rextents, tp->t_rextents_delta);
+		if (error)
+			goto out_undo_rblocks;
+	}
+	if (tp->t_rextslog_delta != 0) {
+		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog, tp->t_rextslog_delta);
+		if (error)
+			goto out_undo_rextents;
+	}
+	spin_unlock(&mp->m_sb_lock);
 	return;
 
-out_undo_ifreecount:
+out_undo_rextents:
+	if (tp->t_rextents_delta)
+		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
+out_undo_rblocks:
+	if (tp->t_rblocks_delta)
+		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
+out_undo_rbmblocks:
+	if (tp->t_rbmblocks_delta)
+		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
+out_undo_rextsize:
+	if (tp->t_rextsize_delta)
+		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
+out_undo_imaxpct:
+	if (tp->t_rextsize_delta)
+		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
+out_undo_agcount:
+	if (tp->t_agcount_delta)
+		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
+out_undo_dblocks:
+	if (tp->t_dblocks_delta)
+		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
+out_undo_frextents:
+	if (rtxdelta)
+		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
+out_undo_ifree:
+	spin_unlock(&mp->m_sb_lock);
 	if (ifreedelta)
-		xfs_mod_incore_sb(mp, XFS_SBS_IFREE, -ifreedelta, rsvd);
+		xfs_sb_mod_ifree(mp, -ifreedelta);
 out_undo_icount:
 	if (idelta)
-		xfs_mod_incore_sb(mp, XFS_SBS_ICOUNT, -idelta, rsvd);
+		xfs_sb_mod_icount(mp, -idelta);
 out_undo_fdblocks:
 	if (blkdelta)
-		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
+		xfs_sb_mod_fdblocks(mp, -blkdelta, rsvd);
 out:
 	ASSERT(error == 0);
 	return;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
