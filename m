Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:22504 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932386AbdJZIdm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:42 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003DP-S3
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005Mp-Qm
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/14] xfs: add growfs support for changing usable blocks
Date: Thu, 26 Oct 2017 19:33:22 +1100
Message-Id: <20171026083322.20428-15-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we have persistent usable block counts, we need to be able
to change them. This allows us to control thin provisioned
filesystem space usage at the filesystem level, not the block device
level.

If the grow operation grows the usable space beyond the current
LBA size of the filesystem, then we also need to physically grow the
filesystem to match the new size of the underlying device. Hence
grow behaves like it always has, expect for the fact that it wont'
grow physically until usable space would exceed the LBA size.

Being able to modify usable space also allows us to shrink the
filesystem on thin devices as easily as growing it. We simply reduce
the usable space and the free space, and we're done. The user then
needs to run a fstrim pass to ensure all the unused space in the
filesystem LBA is marked as unused by the underlying device. No data
or metadata movement is required as the underlying LBA space has not
changed.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_shared.h |   1 +
 fs/xfs/xfs_fsops.c         | 106 +++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_trans.c         |  21 +++++++++
 fs/xfs/xfs_trans.h         |   1 +
 4 files changed, 111 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 536fb353de03..41a34fb96047 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -106,6 +106,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_TRANS_SB_RBLOCKS		0x00000800
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
+#define	XFS_TRANS_SB_USABLE_DBLOCKS	0x00004000
 
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index e0565eb01c0b..d0a6e723e924 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -504,7 +504,7 @@ xfs_grow_ag_headers(
 }
 
 static int
-xfs_growfs_data_private(
+xfs_growfs_data_physical(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
 	xfs_growfs_data_t	*in)		/* growfs data input struct */
 {
@@ -520,11 +520,11 @@ xfs_growfs_data_private(
 	xfs_trans_t		*tp;
 	LIST_HEAD		(buffer_list);
 	struct aghdr_init_data	id = {};
+	struct xfs_owner_info	oinfo;
 
 	nb = in->newblocks;
-	if (nb < mp->m_LBA_size)
-		return -EINVAL;
-	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
+	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
+	if (error)
 		return error;
 	error = xfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
@@ -539,7 +539,7 @@ xfs_growfs_data_private(
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
-		if (nb < mp->m_LBA_size)
+		if (nb <= mp->m_LBA_size)
 			return -EINVAL;
 	}
 	new = nb - mp->m_LBA_size;
@@ -596,7 +596,6 @@ xfs_growfs_data_private(
 	 * There are new blocks in the old last a.g.
 	 */
 	if (new) {
-		struct xfs_owner_info	oinfo;
 
 		/*
 		 * Change the agi length.
@@ -649,9 +648,12 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (nb > mp->m_LBA_size)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
-				 nb - mp->m_LBA_size);
+	if (nb > mp->m_LBA_size) {
+		int64_t delta = nb - mp->m_sb.sb_dblocks;
+
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_USABLE_DBLOCKS, delta);
+	}
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
 	xfs_trans_set_sync(tp);
@@ -660,13 +662,12 @@ xfs_growfs_data_private(
 		return error;
 
 	/* New allocation groups fully initialized, so update mount struct */
-	mp->m_usable_blocks = mp->m_sb.sb_dblocks;
-	mp->m_LBA_size = mp->m_sb.sb_dblocks;
-
 	if (nagimax)
 		mp->m_maxagi = nagimax;
-	xfs_set_low_space_thresholds(mp);
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+
+	/* This is a physical grow so the usable size matches the device size */
+	mp->m_LBA_size = mp->m_sb.sb_dblocks;
+	mp->m_usable_blocks = mp->m_LBA_size;
 
 	/*
 	 * If we expanded the last AG, free the per-AG reservation
@@ -801,6 +802,61 @@ xfs_growfs_update_superblocks(
 	return saved_error ? saved_error : error;
 }
 
+/*
+ * For thin filesystems, first we adjust the logical size of the filesystem
+ * to match the desired change. If the filesystem is physically not large
+ * enough, then we grow to the maximum logical size and leave the rest to
+ * the physical grow step. We also leave the the secondary superblock update
+ * to the physical grow step.
+ */
+static int
+xfs_growfs_data_thinspace(
+	struct xfs_mount	*mp,
+	struct xfs_growfs_data	*in)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	struct xfs_trans	*tp;
+	int64_t			delta;
+	int			error;
+
+	if (!xfs_sb_version_hasthinspace(sbp))
+		return 0;
+
+	delta = in->newblocks - sbp->sb_usable_dblocks;
+	if (!delta)
+		return 0;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
+			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
+
+	/* grow to maximum logical size */
+	if (delta > 0) {
+		delta = min_t(int64_t, delta,
+			     sbp->sb_dblocks - sbp->sb_usable_dblocks);
+	}
+
+	/*
+	 * Modify incore free block counter. Shrink will return ENOSPC here if
+	 * there isn't free space available to shrink the amount requested.
+	 * We need this ENOSPC check here, which is why we can't use
+	 * xfs_trans_mod_sb() for this set of superblock modifications.
+	 */
+	error = xfs_mod_fdblocks(mp, delta, false);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	/* Update the new size and log the superblock. */
+	sbp->sb_usable_dblocks += delta;
+	mp->m_usable_blocks += delta;
+	xfs_log_sb(tp);
+	xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp);
+}
+
 /*
  * protected versions of growfs function acquire and release locks on the mount
  * point - exported through ioctls: XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG,
@@ -822,12 +878,24 @@ xfs_growfs_data(
 	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
 		error = xfs_growfs_imaxpct(mp, in->imaxpct);
 		if (error)
-			goto out_error;
+			goto out_unlock;
 	}
 
-	error = xfs_growfs_data_private(mp, in);
+	error = xfs_growfs_data_thinspace(mp, in);
 	if (error)
-		goto out_error;
+		goto out_unlock;
+
+	/*
+	 * For thinspace filesystems, we can shrink the logical size and hence
+	 * newblocks can be less than the sb_dblocks. Shrinks will be done
+	 * entirely in thinspace, so only do a physical grow if it is needed.
+	 */
+	if (!xfs_sb_version_hasthinspace(&mp->m_sb) ||
+	    in->newblocks > mp->m_LBA_size) {
+		error = xfs_growfs_data_physical(mp, in);
+		if (error)
+			goto out_unlock;
+	}
 
 	/*
 	 * Post growfs calculations needed to reflect new state in operations
@@ -838,13 +906,15 @@ xfs_growfs_data(
 		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
 	} else
 		mp->m_maxicount = 0;
+	xfs_set_low_space_thresholds(mp);
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
 	/*
 	 * Update secondary superblocks now the physical grow has completed
 	 */
 	error = xfs_growfs_update_superblocks(mp);
 
-out_error:
+out_unlock:
 	/*
 	 * Increment the generation unconditionally, the error could be from
 	 * updating the secondary superblocks, in which case the new size
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a87f657f59c9..eb1658deacd6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -391,6 +391,9 @@ xfs_trans_mod_sb(
 	case XFS_TRANS_SB_REXTSLOG:
 		tp->t_rextslog_delta += delta;
 		break;
+	case XFS_TRANS_SB_USABLE_DBLOCKS:
+		tp->t_usable_dblock_delta += delta;
+		break;
 	default:
 		ASSERT(0);
 		return;
@@ -477,6 +480,15 @@ xfs_trans_apply_sb_deltas(
 		whole = 1;
 	}
 
+	/* Only modify the thinspace sb fields if enabled */
+	if (xfs_sb_version_hasthinspace(&tp->t_mountp->m_sb) &&
+	    tp->t_usable_dblock_delta) {
+		be64_add_cpu(&sbp->sb_usable_dblocks,
+			     tp->t_usable_dblock_delta);
+		whole = 1;
+	}
+
+
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	if (whole)
 		/*
@@ -659,9 +671,18 @@ xfs_trans_unreserve_and_mod_sb(
 		if (error)
 			goto out_undo_rextents;
 	}
+	if (tp->t_usable_dblock_delta != 0) {
+		error = xfs_sb_mod64(&mp->m_sb.sb_usable_dblocks,
+				     tp->t_usable_dblock_delta);
+		if (error)
+			goto out_undo_rextslog;
+	}
 	spin_unlock(&mp->m_sb_lock);
 	return;
 
+out_undo_rextslog:
+	if (tp->t_rextslog_delta)
+		xfs_sb_mod8(&mp->m_sb.sb_rextslog, -tp->t_rextslog_delta);
 out_undo_rextents:
 	if (tp->t_rextents_delta)
 		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 815b53d20e26..f8c816956ba2 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -131,6 +131,7 @@ typedef struct xfs_trans {
 	int64_t			t_rblocks_delta;/* superblock rblocks change */
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_usable_dblock_delta;/* usable space */
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
-- 
2.15.0.rc0

