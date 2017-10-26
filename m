Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:22504 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932431AbdJZIdp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:45 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003Cu-N0
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005Ma-Lg
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/14] xfs: split usable space from block device size
Date: Thu, 26 Oct 2017 19:33:17 +1100
Message-Id: <20171026083322.20428-10-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The superblock field sb_dblocks is used for two purposes: to define
the size of the block device we are operating, and to define the
maximum usable space in the filesystem. Whilst this definition might
look like I'm splitting hairs, this separation of "block device size
vs usable space in the block device" was made a long time ago by
thinly provisioned devices.

That is, the size of address space presented to the filesystem does
not define the usuable space in the block device, and one of the big
problems we have with thinly provisioned devices is that we can't
make this distinction at the filesystem level.

The first step to supporting thinly provisioned storage directly in
XFS is to fix this mismatch. To do this, we really need to abstract
the two different use cases away from the superblock configuration.
This patch adds two variables to the struct xfs_mount to do this:

	m_LBA_size
	m_usable_blocks

Both are initialised from sb_dblocks, and the rest of the code is
adjusted to use the approprate variable. Where we ar checking for
valid addresses or need to check against the geometry of teh
filesystem, we use m_LBA_size (e.g. fsbno verification). Where we
are using sb_dblocks as an indication as the maximum number of
allocatable blocks in the filesystem, we use m_usable_blocks (e.g.
calculating low space thresholds).

This separation will now allow us to modify the on-disk format
to adjust the usable space separately to teh size of the block
device the filesystem sits on without impacting any other code
or existing filesystem behaviour.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |  6 +++---
 fs/xfs/libxfs/xfs_sb.c     |  6 ++++++
 fs/xfs/libxfs/xfs_types.c  |  2 +-
 fs/xfs/xfs_bmap_item.c     |  7 +++----
 fs/xfs/xfs_buf.c           |  2 +-
 fs/xfs/xfs_discard.c       |  6 +++---
 fs/xfs/xfs_extfree_item.c  |  3 +--
 fs/xfs/xfs_fsmap.c         |  2 +-
 fs/xfs/xfs_fsops.c         | 17 ++++++++++-------
 fs/xfs/xfs_mount.c         | 17 +++++++++--------
 fs/xfs/xfs_mount.h         |  2 ++
 fs/xfs/xfs_refcount_item.c |  4 ++--
 fs/xfs/xfs_rmap_item.c     |  4 ++--
 fs/xfs/xfs_super.c         |  4 ++--
 14 files changed, 46 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 132b8c7af263..f168339423b5 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2388,12 +2388,12 @@ xfs_imap(
 	 * driver.
 	 */
 	if ((imap->im_blkno + imap->im_len) >
-	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
+	    XFS_FSB_TO_BB(mp, mp->m_LBA_size)) {
 		xfs_alert(mp,
-	"%s: (im_blkno (0x%llx) + im_len (0x%llx)) > sb_dblocks (0x%llx)",
+	"%s: (im_blkno (0x%llx) + im_len (0x%llx)) > device size (0x%llx)",
 			__func__, (unsigned long long) imap->im_blkno,
 			(unsigned long long) imap->im_len,
-			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
+			XFS_FSB_TO_BB(mp, mp->m_LBA_size));
 		return -EINVAL;
 	}
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 9b49640a65d6..87b57abeace2 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -728,6 +728,12 @@ xfs_sb_mount_common(
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
 
+	/*
+	 * Set up the filesystem size and addressing limits
+	 */
+	mp->m_LBA_size = sbp->sb_dblocks;
+	mp->m_usable_blocks = sbp->sb_dblocks;
+
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
 	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 16d2488797a1..092c032fee51 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -39,7 +39,7 @@ xfs_ag_block_count(
 
 	if (agno < mp->m_sb.sb_agcount - 1)
 		return mp->m_sb.sb_agblocks;
-	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
+	return mp->m_LBA_size - (agno * mp->m_sb.sb_agblocks);
 }
 
 /*
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index dd136f7275e4..ade97e8180b3 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -435,12 +435,11 @@ xfs_bui_recover(
 		op_ok = false;
 		break;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
+	if (!op_ok ||
+	    !xfs_verify_fsbno(mp, startblock_fsb) ||
+	    !xfs_verify_fsbno(mp, inode_fsb) ||
 	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
 	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
 	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)) {
 		/*
 		 * This will pull the BUI from the AIL and
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2f97c12ca75e..0b51922aeebc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -575,7 +575,7 @@ _xfs_buf_find(
 	 * Corrupted block numbers can get through to here, unfortunately, so we
 	 * have to check that the buffer falls within the filesystem bounds.
 	 */
-	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
+	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_LBA_size);
 	if (cmap.bm_bn < 0 || cmap.bm_bn >= eofs) {
 		/*
 		 * XXX (dgc): we should really be returning -EFSCORRUPTED here,
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index b2cde5426182..be247d61961f 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -183,7 +183,7 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
-	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
+	if (range.start >= XFS_FSB_TO_B(mp, mp->m_LBA_size) ||
 	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
 	    range.len < mp->m_sb.sb_blocksize)
 		return -EINVAL;
@@ -192,8 +192,8 @@ xfs_ioc_trim(
 	end = start + BTOBBT(range.len) - 1;
 	minlen = BTOBB(max_t(u64, granularity, range.minlen));
 
-	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
+	if (end > XFS_FSB_TO_BB(mp, mp->m_LBA_size) - 1)
+		end = XFS_FSB_TO_BB(mp, mp->m_LBA_size)- 1;
 
 	start_agno = xfs_daddr_to_agno(mp, start);
 	end_agno = xfs_daddr_to_agno(mp, end);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 44f8c5451210..c6e5ff779199 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -519,9 +519,8 @@ xfs_efi_recover(
 		extp = &efip->efi_format.efi_extents[i];
 		startblock_fsb = XFS_BB_TO_FSB(mp,
 				   XFS_FSB_TO_DADDR(mp, extp->ext_start));
-		if (startblock_fsb == 0 ||
+		if (!xfs_verify_fsbno(mp, startblock_fsb) ||
 		    extp->ext_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
 		    extp->ext_len >= mp->m_sb.sb_agblocks) {
 			/*
 			 * This will pull the EFI from the AIL and
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 43cfc07996a4..e37c26a5d534 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -585,7 +585,7 @@ __xfs_getfsmap_datadev(
 	xfs_daddr_t			eofs;
 	int				error = 0;
 
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_LBA_size);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
 	if (keys[1].fmr_physical >= eofs)
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 34c9fc257c2f..f33c74f2e925 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -66,7 +66,7 @@ xfs_fs_geometry(
 	geo->sectsize = mp->m_sb.sb_sectsize;
 	geo->inodesize = mp->m_sb.sb_inodesize;
 	geo->imaxpct = mp->m_sb.sb_imax_pct;
-	geo->datablocks = mp->m_sb.sb_dblocks;
+	geo->datablocks = mp->m_LBA_size;
 	geo->rtblocks = mp->m_sb.sb_rblocks;
 	geo->rtextents = mp->m_sb.sb_rextents;
 	geo->logstart = mp->m_sb.sb_logstart;
@@ -513,7 +513,7 @@ xfs_growfs_data_private(
 	struct aghdr_init_data	id = {};
 
 	nb = in->newblocks;
-	if (nb < mp->m_sb.sb_dblocks)
+	if (nb < mp->m_LBA_size)
 		return -EINVAL;
 	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
 		return error;
@@ -530,10 +530,10 @@ xfs_growfs_data_private(
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
-		if (nb < mp->m_sb.sb_dblocks)
+		if (nb < mp->m_LBA_size)
 			return -EINVAL;
 	}
-	new = nb - mp->m_sb.sb_dblocks;
+	new = nb - mp->m_LBA_size;
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
@@ -640,9 +640,9 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (nb > mp->m_sb.sb_dblocks)
+	if (nb > mp->m_LBA_size)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
-				 nb - mp->m_sb.sb_dblocks);
+				 nb - mp->m_LBA_size);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
 	xfs_trans_set_sync(tp);
@@ -651,6 +651,9 @@ xfs_growfs_data_private(
 		return error;
 
 	/* New allocation groups fully initialized, so update mount struct */
+	mp->m_usable_blocks = mp->m_sb.sb_dblocks;
+	mp->m_LBA_size = mp->m_sb.sb_dblocks;
+
 	if (nagimax)
 		mp->m_maxagi = nagimax;
 	xfs_set_low_space_thresholds(mp);
@@ -821,7 +824,7 @@ xfs_growfs_data(
 	 * Post growfs calculations needed to reflect new state in operations
 	 */
 	if (mp->m_sb.sb_imax_pct) {
-		uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
+		uint64_t icount = mp->m_usable_blocks * mp->m_sb.sb_imax_pct;
 		do_div(icount, 100);
 		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
 	} else
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e9727d0a541a..a9874d9dcf3d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -432,17 +432,18 @@ xfs_update_alignment(xfs_mount_t *mp)
  * Set the maximum inode count for this filesystem
  */
 STATIC void
-xfs_set_maxicount(xfs_mount_t *mp)
+xfs_set_maxicount(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
-	uint64_t	icount;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	uint64_t		icount;
 
 	if (sbp->sb_imax_pct) {
 		/*
 		 * Make sure the maximum inode count is a multiple
 		 * of the units we allocate inodes in.
 		 */
-		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
+		icount = mp->m_usable_blocks * sbp->sb_imax_pct;
 		do_div(icount, 100);
 		do_div(icount, mp->m_ialloc_blks);
 		mp->m_maxicount = (icount * mp->m_ialloc_blks)  <<
@@ -501,7 +502,7 @@ xfs_set_low_space_thresholds(
 	int i;
 
 	for (i = 0; i < XFS_LOWSP_MAX; i++) {
-		uint64_t space = mp->m_sb.sb_dblocks;
+		uint64_t space = mp->m_usable_blocks;
 
 		do_div(space, 100);
 		mp->m_low_space[i] = space * (i + 1);
@@ -542,8 +543,8 @@ xfs_check_sizes(
 	xfs_daddr_t	d;
 	int		error;
 
-	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
-	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
+	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_LBA_size);
+	if (XFS_BB_TO_FSB(mp, d) != mp->m_LBA_size) {
 		xfs_warn(mp, "filesystem size mismatch detected");
 		return -EFBIG;
 	}
@@ -609,7 +610,7 @@ xfs_default_resblks(xfs_mount_t *mp)
 	 * block reservation. Hence by default we cover roughly 2000 concurrent
 	 * allocation reservations.
 	 */
-	resblks = mp->m_sb.sb_dblocks;
+	resblks = mp->m_usable_blocks;
 	do_div(resblks, 20);
 	resblks = min_t(uint64_t, resblks, 8192);
 	return resblks;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 37a6c97af394..1918a564bebf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -79,6 +79,8 @@ typedef struct xfs_mount {
 	struct percpu_counter	m_icount;	/* allocated inodes counter */
 	struct percpu_counter	m_ifree;	/* free inodes counter */
 	struct percpu_counter	m_fdblocks;	/* free block counter */
+	xfs_rfsblock_t		m_LBA_size;	/* device address space size */
+	xfs_rfsblock_t		m_usable_blocks; /* max allocatable fs space */
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8f2e2fac4255..fefbc68ebde3 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -434,9 +434,9 @@ xfs_cui_recover(
 			op_ok = false;
 			break;
 		}
-		if (!op_ok || startblock_fsb == 0 ||
+		if (!op_ok ||
+		    !xfs_verify_fsbno(mp, startblock_fsb) ||
 		    refc->pe_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
 		    refc->pe_len >= mp->m_sb.sb_agblocks ||
 		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)) {
 			/*
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index f3b139c9aa16..b83be5ceef14 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -455,9 +455,9 @@ xfs_rui_recover(
 			op_ok = false;
 			break;
 		}
-		if (!op_ok || startblock_fsb == 0 ||
+		if (!op_ok ||
+		    !xfs_verify_fsbno(mp, startblock_fsb) ||
 		    rmap->me_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
 		    rmap->me_len >= mp->m_sb.sb_agblocks ||
 		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)) {
 			/*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 12198055c319..a4e8c313eef1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -624,7 +624,7 @@ xfs_set_inode_alloc(
 	if (mp->m_maxicount) {
 		uint64_t	icount;
 
-		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
+		icount = mp->m_usable_blocks * sbp->sb_imax_pct;
 		do_div(icount, 100);
 		icount += sbp->sb_agblocks - 1;
 		do_div(icount, sbp->sb_agblocks);
@@ -1126,7 +1126,7 @@ xfs_fs_statfs(
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
-	statp->f_blocks = sbp->sb_dblocks - lsize;
+	statp->f_blocks = mp->m_usable_blocks - lsize;
 	spin_unlock(&mp->m_sb_lock);
 
 	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
-- 
2.15.0.rc0

