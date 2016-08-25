Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16FBD7D17
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:39:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 746C9AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hp0lxDEKxq0BPGv0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:36 -0700 (PDT)
Subject: [PATCH 70/71] xfs: refactor swapext code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:39:32 -0700
Message-ID: <147216837209.867.2761439307500426616.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Refactor the swapext function to pull out the fork swapping piece
into a separate function.  In the next patch we'll add in the bit
we need to make it work with rmap filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |  275 +++++++++++++++++++++++++-----------------------
 1 file changed, 144 insertions(+), 131 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 86cd7d4..3bd85aa 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1627,127 +1627,37 @@ xfs_swap_extent_flush(
 	return 0;
 }
 
-int
-xfs_swap_extents(
-	struct xfs_inode	*ip,	/* target inode */
-	struct xfs_inode	*tip,	/* tmp inode */
-	struct xfs_swapext	*sxp)
+/* Swap the extents of two files by swapping data forks. */
+STATIC int
+xfs_swap_extent_forks(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_inode	*tip,
+	int			*src_log_flags,
+	int			*target_log_flags)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_bstat	*sbp = &sxp->sx_stat;
-	struct xfs_ifork	*tempifp, *ifp, *tifp;
-	int			src_log_flags, target_log_flags;
-	int			error = 0;
+	struct xfs_ifork	tempifp, *ifp, *tifp;
 	int			aforkblks = 0;
 	int			taforkblks = 0;
 	__uint64_t		tmp;
-	int			lock_flags;
-	struct xfs_ifork	*cowfp;
-	__uint64_t		f;
-
-	/* XXX: we can't do this with rmap, will fix later */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		return -EOPNOTSUPP;
-
-	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
-	if (!tempifp) {
-		error = -ENOMEM;
-		goto out;
-	}
-
-	/*
-	 * Lock the inodes against other IO, page faults and truncate to
-	 * begin with.  Then we can ensure the inodes are flushed and have no
-	 * page cache safely. Once we have done this we can take the ilocks and
-	 * do the rest of the checks.
-	 */
-	lock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
-	xfs_lock_two_inodes(ip, tip, XFS_MMAPLOCK_EXCL);
-
-	/* Verify that both files have the same format */
-	if ((VFS_I(ip)->i_mode & S_IFMT) != (VFS_I(tip)->i_mode & S_IFMT)) {
-		error = -EINVAL;
-		goto out_unlock;
-	}
-
-	/* Verify both files are either real-time or non-realtime */
-	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
-		error = -EINVAL;
-		goto out_unlock;
-	}
-
-	error = xfs_swap_extent_flush(ip);
-	if (error)
-		goto out_unlock;
-	error = xfs_swap_extent_flush(tip);
-	if (error)
-		goto out_unlock;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
-	if (error)
-		goto out_unlock;
-
-	/*
-	 * Lock and join the inodes to the tansaction so that transaction commit
-	 * or cancel will unlock the inodes from this point onwards.
-	 */
-	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
-	lock_flags |= XFS_ILOCK_EXCL;
-	xfs_trans_ijoin(tp, ip, lock_flags);
-	xfs_trans_ijoin(tp, tip, lock_flags);
-
-
-	/* Verify all data are being swapped */
-	if (sxp->sx_offset != 0 ||
-	    sxp->sx_length != ip->i_d.di_size ||
-	    sxp->sx_length != tip->i_d.di_size) {
-		error = -EFAULT;
-		goto out_trans_cancel;
-	}
-
-	trace_xfs_swap_extent_before(ip, 0);
-	trace_xfs_swap_extent_before(tip, 1);
-
-	/* check inode formats now that data is flushed */
-	error = xfs_swap_extents_check_format(ip, tip);
-	if (error) {
-		xfs_notice(mp,
-		    "%s: inode 0x%llx format is incompatible for exchanging.",
-				__func__, ip->i_ino);
-		goto out_trans_cancel;
-	}
+	int			error;
 
 	/*
-	 * Compare the current change & modify times with that
-	 * passed in.  If they differ, we abort this swap.
-	 * This is the mechanism used to ensure the calling
-	 * process that the file was not changed out from
-	 * under it.
-	 */
-	if ((sbp->bs_ctime.tv_sec != VFS_I(ip)->i_ctime.tv_sec) ||
-	    (sbp->bs_ctime.tv_nsec != VFS_I(ip)->i_ctime.tv_nsec) ||
-	    (sbp->bs_mtime.tv_sec != VFS_I(ip)->i_mtime.tv_sec) ||
-	    (sbp->bs_mtime.tv_nsec != VFS_I(ip)->i_mtime.tv_nsec)) {
-		error = -EBUSY;
-		goto out_trans_cancel;
-	}
-	/*
 	 * Count the number of extended attribute blocks
 	 */
 	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
 	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
-		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &aforkblks);
+		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK,
+				&aforkblks);
 		if (error)
-			goto out_trans_cancel;
+			return error;
 	}
 	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
 	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
 		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK,
-			&taforkblks);
+				&taforkblks);
 		if (error)
-			goto out_trans_cancel;
+			return error;
 	}
 
 	/*
@@ -1756,31 +1666,23 @@ xfs_swap_extents(
 	 * buffers, and so the validation done on read will expect the owner
 	 * field to be correctly set. Once we change the owners, we can swap the
 	 * inode forks.
-	 *
-	 * Note the trickiness in setting the log flags - we set the owner log
-	 * flag on the opposite inode (i.e. the inode we are setting the new
-	 * owner to be) because once we swap the forks and log that, log
-	 * recovery is going to see the fork as owned by the swapped inode,
-	 * not the pre-swapped inodes.
 	 */
-	src_log_flags = XFS_ILOG_CORE;
-	target_log_flags = XFS_ILOG_CORE;
 	if (ip->i_d.di_version == 3 &&
 	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		target_log_flags |= XFS_ILOG_DOWNER;
+		(*target_log_flags) |= XFS_ILOG_DOWNER;
 		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK,
 					      tip->i_ino, NULL);
 		if (error)
-			goto out_trans_cancel;
+			return error;
 	}
 
 	if (tip->i_d.di_version == 3 &&
 	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		src_log_flags |= XFS_ILOG_DOWNER;
+		(*src_log_flags) |= XFS_ILOG_DOWNER;
 		error = xfs_bmbt_change_owner(tp, tip, XFS_DATA_FORK,
 					      ip->i_ino, NULL);
 		if (error)
-			goto out_trans_cancel;
+			return error;
 	}
 
 	/*
@@ -1788,9 +1690,9 @@ xfs_swap_extents(
 	 */
 	ifp = &ip->i_df;
 	tifp = &tip->i_df;
-	*tempifp = *ifp;	/* struct copy */
+	tempifp = *ifp;		/* struct copy */
 	*ifp = *tifp;		/* struct copy */
-	*tifp = *tempifp;	/* struct copy */
+	*tifp = tempifp;	/* struct copy */
 
 	/*
 	 * Fix the on-disk inode values
@@ -1830,12 +1732,12 @@ xfs_swap_extents(
 			ifp->if_u1.if_extents =
 				ifp->if_u2.if_inline_ext;
 		}
-		src_log_flags |= XFS_ILOG_DEXT;
+		(*src_log_flags) |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		ASSERT(ip->i_d.di_version < 3 ||
-		       (src_log_flags & XFS_ILOG_DOWNER));
-		src_log_flags |= XFS_ILOG_DBROOT;
+		       (*src_log_flags & XFS_ILOG_DOWNER));
+		(*src_log_flags) |= XFS_ILOG_DBROOT;
 		break;
 	}
 
@@ -1849,15 +1751,126 @@ xfs_swap_extents(
 			tifp->if_u1.if_extents =
 				tifp->if_u2.if_inline_ext;
 		}
-		target_log_flags |= XFS_ILOG_DEXT;
+		(*target_log_flags) |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		target_log_flags |= XFS_ILOG_DBROOT;
+		(*target_log_flags) |= XFS_ILOG_DBROOT;
 		ASSERT(tip->i_d.di_version < 3 ||
-		       (target_log_flags & XFS_ILOG_DOWNER));
+		       (*target_log_flags & XFS_ILOG_DOWNER));
 		break;
 	}
 
+	return 0;
+}
+
+int
+xfs_swap_extents(
+	struct xfs_inode	*ip,	/* target inode */
+	struct xfs_inode	*tip,	/* tmp inode */
+	struct xfs_swapext	*sxp)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_bstat	*sbp = &sxp->sx_stat;
+	int			src_log_flags, target_log_flags;
+	int			error = 0;
+	int			lock_flags;
+	struct xfs_ifork	*cowfp;
+	__uint64_t		f;
+
+	/*
+	 * Lock the inodes against other IO, page faults and truncate to
+	 * begin with.  Then we can ensure the inodes are flushed and have no
+	 * page cache safely. Once we have done this we can take the ilocks and
+	 * do the rest of the checks.
+	 */
+	lock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
+	xfs_lock_two_inodes(ip, tip, XFS_MMAPLOCK_EXCL);
+
+	/* Verify that both files have the same format */
+	if ((VFS_I(ip)->i_mode & S_IFMT) != (VFS_I(tip)->i_mode & S_IFMT)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* Verify both files are either real-time or non-realtime */
+	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
+	error = xfs_swap_extent_flush(ip);
+	if (error)
+		goto out_unlock;
+	error = xfs_swap_extent_flush(tip);
+	if (error)
+		goto out_unlock;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		goto out_unlock;
+
+	/*
+	 * Lock and join the inodes to the tansaction so that transaction commit
+	 * or cancel will unlock the inodes from this point onwards.
+	 */
+	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
+	lock_flags |= XFS_ILOCK_EXCL;
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_trans_ijoin(tp, tip, 0);
+
+
+	/* Verify all data are being swapped */
+	if (sxp->sx_offset != 0 ||
+	    sxp->sx_length != ip->i_d.di_size ||
+	    sxp->sx_length != tip->i_d.di_size) {
+		error = -EFAULT;
+		goto out_trans_cancel;
+	}
+
+	trace_xfs_swap_extent_before(ip, 0);
+	trace_xfs_swap_extent_before(tip, 1);
+
+	/* check inode formats now that data is flushed */
+	error = xfs_swap_extents_check_format(ip, tip);
+	if (error) {
+		xfs_notice(mp,
+		    "%s: inode 0x%llx format is incompatible for exchanging.",
+				__func__, ip->i_ino);
+		goto out_trans_cancel;
+	}
+
+	/*
+	 * Compare the current change & modify times with that
+	 * passed in.  If they differ, we abort this swap.
+	 * This is the mechanism used to ensure the calling
+	 * process that the file was not changed out from
+	 * under it.
+	 */
+	if ((sbp->bs_ctime.tv_sec != VFS_I(ip)->i_ctime.tv_sec) ||
+	    (sbp->bs_ctime.tv_nsec != VFS_I(ip)->i_ctime.tv_nsec) ||
+	    (sbp->bs_mtime.tv_sec != VFS_I(ip)->i_mtime.tv_sec) ||
+	    (sbp->bs_mtime.tv_nsec != VFS_I(ip)->i_mtime.tv_nsec)) {
+		error = -EBUSY;
+		goto out_trans_cancel;
+	}
+
+	/*
+	 * Note the trickiness in setting the log flags - we set the owner log
+	 * flag on the opposite inode (i.e. the inode we are setting the new
+	 * owner to be) because once we swap the forks and log that, log
+	 * recovery is going to see the fork as owned by the swapped inode,
+	 * not the pre-swapped inodes.
+	 */
+	src_log_flags = XFS_ILOG_CORE;
+	target_log_flags = XFS_ILOG_CORE;
+
+	error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
+			&target_log_flags);
+	if (error)
+		goto out_trans_cancel;
+
 	/* Do we have to swap reflink flags? */
 	if ((ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK) ^
 	    (tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)) {
@@ -1887,16 +1900,16 @@ xfs_swap_extents(
 
 	trace_xfs_swap_extent_after(ip, 0);
 	trace_xfs_swap_extent_after(tip, 1);
-out:
-	kmem_free(tempifp);
-	return error;
 
-out_unlock:
 	xfs_iunlock(ip, lock_flags);
 	xfs_iunlock(tip, lock_flags);
-	goto out;
+	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
-	goto out;
+
+out_unlock:
+	xfs_iunlock(ip, lock_flags);
+	xfs_iunlock(tip, lock_flags);
+	return error;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
