Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39951 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbeHTIDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:15 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006S0-5P
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QG-4H
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/10] xfs: convert mount flags to features
Date: Mon, 20 Aug 2018 14:48:45 +1000
Message-Id: <20180820044851.414-5-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Replace m_flags feature checks with xfs_has_<feature>() calls and
rework the setup code to set flags in m_features.

Fallout is that there are some attr2/noattr2 changes - there's no
longer separate feature flags for the attr2 superblock and attr2
mount options - they both set the same flag. Hence we use the
noattr2 feature to trigger turning off attr2 at mount time - it
doesn't matter if it is the mount option or the sb feature that set
it, specifying noattr2 will turn off attr2 for the current mount and
clear it from the sb feature set.

[Discuss: Might be worth moving the attr2 changes into a separate
patch so it's clear what changes are being made.]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      |   6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |  36 +++++-----
 fs/xfs/libxfs/xfs_bmap.c      |   4 +-
 fs/xfs/libxfs/xfs_ialloc.c    |  10 ++-
 fs/xfs/libxfs/xfs_inode_buf.c |   5 +-
 fs/xfs/scrub/scrub.c          |   2 +-
 fs/xfs/xfs_bmap_util.c        |   2 +-
 fs/xfs/xfs_export.c           |   2 +-
 fs/xfs/xfs_filestream.h       |   2 +-
 fs/xfs/xfs_inode.c            |  10 +--
 fs/xfs/xfs_inode.h            |   3 +-
 fs/xfs/xfs_ioctl.c            |   2 +-
 fs/xfs/xfs_iomap.c            |   6 +-
 fs/xfs/xfs_iops.c             |   7 +-
 fs/xfs/xfs_log.c              |  14 ++--
 fs/xfs/xfs_log_cil.c          |   4 +-
 fs/xfs/xfs_mount.c            |  43 +++++-------
 fs/xfs/xfs_mount.h            |  52 +++++----------
 fs/xfs/xfs_super.c            | 119 +++++++++++++++-------------------
 fs/xfs/xfs_symlink.c          |   3 +-
 20 files changed, 144 insertions(+), 188 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1e671d4eb6fa..5ca0233fe135 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -294,7 +294,7 @@ xfs_attr_set(
 			 * the transaction goes to disk before returning
 			 * to the user.
 			 */
-			if (mp->m_flags & XFS_MOUNT_WSYNC)
+			if (xfs_has_wsync(mp))
 				xfs_trans_set_sync(args.trans);
 
 			if (!error && (flags & ATTR_KERNOTIME) == 0) {
@@ -347,7 +347,7 @@ xfs_attr_set(
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(args.trans);
 
 	if ((flags & ATTR_KERNOTIME) == 0)
@@ -441,7 +441,7 @@ xfs_attr_remove(
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(args.trans);
 
 	if ((flags & ATTR_KERNOTIME) == 0)
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fbd53362b5bc..f9e536d6dd72 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -448,7 +448,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 	 * literal area, but for the old format we are done if there is no
 	 * space in the fixed attribute fork.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_ATTR2))
+	if (!xfs_has_attr2(mp))
 		return 0;
 
 	dsize = dp->i_df.if_bytes;
@@ -502,21 +502,26 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 }
 
 /*
- * Switch on the ATTR2 superblock bit (implies also FEATURES2)
+ * Switch on the ATTR2 superblock bit (implies also FEATURES2) by default unless
+ * we've explicitly been told not to use attr2 (i.e. noattr2 mount option).
  */
 STATIC void
 xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
 {
-	if ((mp->m_flags & XFS_MOUNT_ATTR2) &&
-	    !(xfs_has_attr2(mp))) {
-		spin_lock(&mp->m_sb_lock);
-		if (!xfs_has_attr2(mp)) {
-			xfs_feat_add_attr2(mp);
-			spin_unlock(&mp->m_sb_lock);
-			xfs_log_sb(tp);
-		} else
-			spin_unlock(&mp->m_sb_lock);
+	if (xfs_has_attr2(mp))
+		return;
+	if (xfs_has_noattr2(mp))
+		return;
+
+	spin_lock(&mp->m_sb_lock);
+	if (xfs_has_attr2(mp)) {
+		spin_unlock(&mp->m_sb_lock);
+		return;
 	}
+
+	xfs_feat_add_attr2(mp);
+	spin_unlock(&mp->m_sb_lock);
+	xfs_log_sb(tp);
 }
 
 /*
@@ -671,8 +676,7 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	 * Fix up the start offset of the attribute fork
 	 */
 	totsize -= size;
-	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
-	    (mp->m_flags & XFS_MOUNT_ATTR2) &&
+	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
 		xfs_attr_fork_remove(dp, args->trans);
@@ -682,7 +686,7 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 		ASSERT(dp->i_d.di_forkoff);
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
-				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
+				!xfs_has_attr2(mp) ||
 				dp->i_d.di_format == XFS_DINODE_FMT_BTREE);
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
@@ -888,7 +892,7 @@ xfs_attr_shortform_allfit(
 				+ name_loc->namelen
 				+ be16_to_cpu(name_loc->valuelen);
 	}
-	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
+	if (xfs_has_attr2(mp) &&
 	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
 	    (bytes == sizeof(struct xfs_attr_sf_hdr)))
 		return -1;
@@ -1011,7 +1015,7 @@ xfs_attr3_leaf_to_shortform(
 		goto out;
 
 	if (forkoff == -1) {
-		ASSERT(dp->i_mount->m_flags & XFS_MOUNT_ATTR2);
+		ASSERT(xfs_has_attr2(dp->i_mount));
 		ASSERT(dp->i_d.di_format != XFS_DINODE_FMT_BTREE);
 		xfs_attr_fork_remove(dp, args->trans);
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 777630f3066a..459b08856f3f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1079,7 +1079,7 @@ xfs_bmap_add_attrfork(
 		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
 		if (!ip->i_d.di_forkoff)
 			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
-		else if (mp->m_flags & XFS_MOUNT_ATTR2)
+		else if (!xfs_has_noattr2(mp))
 			version = 2;
 		break;
 	default:
@@ -3386,7 +3386,7 @@ xfs_bmap_btalloc(
 
 	/* stripe alignment for allocation is determined by mount parameters */
 	stripe_align = 0;
-	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+	if (mp->m_swidth && xfs_has_swalloc(mp))
 		stripe_align = mp->m_swidth;
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 8d23491badb7..ffb1caf4c34a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -723,7 +723,7 @@ xfs_ialloc_ag_alloc(
 		 */
 		isaligned = 0;
 		if (args.mp->m_sinoalign) {
-			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
+			ASSERT(!xfs_has_noalign(args.mp));
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
 		} else
@@ -1974,8 +1974,7 @@ xfs_difree_inobt(
 	 * remove the chunk if the block size is large enough for multiple inode
 	 * chunks (that might not be free).
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    rec.ir_free == XFS_INOBT_ALL_FREE &&
+	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		xic->deleted = true;
 		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
@@ -2112,9 +2111,8 @@ xfs_difree_finobt(
 	 * enough for multiple chunks. Leave the finobt record to remain in sync
 	 * with the inobt.
 	 */
-	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
-	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK &&
-	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
+	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto error;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6eb9f967d087..1d5389ad6502 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -573,7 +573,7 @@ xfs_dinode_calc_crc(
  * Read the disk inode attributes into the in-core inode structure.
  *
  * For version 5 superblocks, if we are initialising a new inode and we are not
- * utilising the XFS_MOUNT_IKEEP inode cluster mode, we can simple build the new
+ * utilising the XFS_FEAT_IKEEP inode cluster mode, we can simple build the new
  * inode core with a random generation number. If we are keeping inodes around,
  * we need to read the inode cluster to get the existing generation number off
  * disk. Further, if we are using version 4 superblocks (i.e. v1/v2 inode
@@ -602,8 +602,7 @@ xfs_iread(
 
 	/* shortcut IO on inode allocation if possible */
 	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_has_crc(mp) &&
-	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+	    xfs_has_crc(mp) && !xfs_has_ikeep(mp)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
 		VFS_I(ip)->i_generation = prandom_u32();
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4c486e89829d..a3698e9b084a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -495,7 +495,7 @@ xfs_scrub_metadata(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		goto out;
 	error = -ENOTRECOVERABLE;
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+	if (xfs_has_norecovery(mp))
 		goto out;
 
 	error = xchk_validate_inputs(mp, sm);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2647e4ef8dc5..bd733b256fee 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1978,7 +1978,7 @@ xfs_swap_extents(
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index f2284ceb129f..cc1f7d09102f 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -66,7 +66,7 @@ xfs_fs_encode_fh(
 	 * large enough filesystem may contain them, thus the slightly
 	 * confusing looking conditional below.
 	 */
-	if (!(XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_SMALL_INUMS) ||
+	if (!xfs_has_small_inums(XFS_M(inode->i_sb)) ||
 	    (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES))
 		fileid_type |= XFS_FILEID_TYPE_64FLAG;
 
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 5cc7665e93c9..c8760fffdda7 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -21,7 +21,7 @@ static inline int
 xfs_inode_is_filestream(
 	struct xfs_inode	*ip)
 {
-	return (ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
+	return xfs_has_filestreams(ip->i_mount) ||
 		(ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM);
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d957a46dc1cb..0f67ca516c87 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1245,7 +1245,7 @@ xfs_create(
 	 * create transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
 	/*
@@ -1336,7 +1336,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 
 	/*
@@ -1463,7 +1463,7 @@ xfs_link(
 	 * link transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
 	return xfs_trans_commit(tp);
@@ -2627,7 +2627,7 @@ xfs_remove(
 	 * remove transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp);
@@ -2704,7 +2704,7 @@ xfs_finish_rename(
 	 * If this is a synchronous mount, make sure that the rename transaction
 	 * goes to disk before returning to the user.
 	 */
-	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+	if (xfs_has_wsync(tp->t_mountp) || xfs_has_dirsync(tp->t_mountp))
 		xfs_trans_set_sync(tp);
 
 	return xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index be2014520155..40bc71d49220 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -394,8 +394,7 @@ enum layout_break_reason {
  * new subdirectory gets S_ISGID bit from parent.
  */
 #define XFS_INHERIT_GID(pip)	\
-	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
-	 (VFS_I(pip)->i_mode & S_ISGID))
+	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
 
 int		xfs_release(struct xfs_inode *ip);
 void		xfs_inactive(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4f4c6cd81b54..350b9276e6fe 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1167,7 +1167,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_cancel;
 	}
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 
 	return tp;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6320aca39f39..3c999ea64021 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -79,7 +79,7 @@ xfs_eof_alignment(
 		 * If mounted with the "-o swalloc" option the alignment is
 		 * increased from the strip unit size to the stripe width.
 		 */
-		if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+		if (mp->m_swidth && xfs_has_swalloc(mp))
 			align = mp->m_swidth;
 		else if (mp->m_dalign)
 			align = mp->m_dalign;
@@ -385,7 +385,7 @@ xfs_iomap_prealloc_size(
 	if (offset + count <= XFS_ISIZE(ip))
 		return 0;
 
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
+	if (!xfs_has_iosize(mp) &&
 	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_writeio_blocks)))
 		return 0;
 
@@ -393,7 +393,7 @@ xfs_iomap_prealloc_size(
 	 * If an explicit allocsize is set, the file is small, or we
 	 * are writing behind a hole, then use the minimum prealloc:
 	 */
-	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
+	if (xfs_has_iosize(mp) ||
 	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
 	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
 	    prev.br_startoff + prev.br_blockcount < offset_fsb)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 066a97d108f5..0241471916d9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -742,7 +742,7 @@ xfs_setattr_nonsize(
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 
@@ -980,7 +980,7 @@ xfs_setattr_size(
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp);
@@ -1200,8 +1200,7 @@ xfs_inode_supports_dax(
 		return false;
 
 	/* DAX mount option or DAX iflag must be set. */
-	if (!(mp->m_flags & XFS_MOUNT_DAX) &&
-	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
+	if (!xfs_has_dax(mp) && !(ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
 		return false;
 
 	/* Block size must match page size */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7ad8c7bb1345..bcc068dee92a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -600,7 +600,7 @@ xfs_log_mount(
 	int		error = 0;
 	int		min_logfsbs;
 
-	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
+	if (!xfs_has_norecovery(mp)) {
 		xfs_notice(mp, "Mounting V%d Filesystem",
 			   XFS_SB_VERSION_NUM(&mp->m_sb));
 	} else {
@@ -685,8 +685,8 @@ xfs_log_mount(
 	 * skip log recovery on a norecovery mount.  pretend it all
 	 * just worked.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
-		int	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
+	if (!xfs_has_norecovery(mp)) {
+		bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 		if (readonly)
 			mp->m_flags &= ~XFS_MOUNT_RDONLY;
@@ -746,8 +746,8 @@ xfs_log_mount_finish(
 	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
 
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+	if (xfs_has_norecovery(mp)) {
+		ASSERT(readonly);
 		return 0;
 	} else if (readonly) {
 		/* Allow unlinked processing to proceed */
@@ -930,7 +930,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	 * Don't write out unmount record on norecovery mounts or ro devices.
 	 * Or, if we are doing a forced umount (typically because of IO errors).
 	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
+	if (xfs_has_norecovery(mp) ||
 	    xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 		return 0;
@@ -4079,7 +4079,7 @@ xfs_log_check_lsn(
 	 * resets the in-core LSN. We can't validate in this mode, but
 	 * modifications are not allowed anyways so just return true.
 	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+	if (xfs_has_norecovery(mp))
 		return true;
 
 	/*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d3884e08b43c..c4f71e600f00 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -538,7 +538,7 @@ xlog_discard_busy_extents(
 	struct blk_plug		plug;
 	int			error = 0;
 
-	ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
+	ASSERT(xfs_has_discard(mp));
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, list, list) {
@@ -587,7 +587,7 @@ xlog_cil_committed(
 
 	xfs_extent_busy_sort(&ctx->busy_extents);
 	xfs_extent_busy_clear(mp, &ctx->busy_extents,
-			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
+			      xfs_has_discard(mp) && !abort);
 
 	/*
 	 * If we are aborting the commit, wake up anyone waiting on the
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 212ae2695b88..624387661cbc 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -64,7 +64,7 @@ xfs_uuid_mount(
 	/* Publish UUID in struct super_block */
 	uuid_copy(&mp->m_super->s_uuid, uuid);
 
-	if (mp->m_flags & XFS_MOUNT_NOUUID)
+	if (xfs_has_nouuid(mp))
 		return 0;
 
 	if (uuid_is_null(uuid)) {
@@ -106,7 +106,7 @@ xfs_uuid_unmount(
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
 	int			i;
 
-	if (mp->m_flags & XFS_MOUNT_NOUUID)
+	if (xfs_has_nouuid(mp))
 		return;
 
 	mutex_lock(&xfs_uuid_table_mutex);
@@ -414,8 +414,7 @@ xfs_update_alignment(xfs_mount_t *mp)
 	"cannot change alignment: superblock does not support data alignment");
 			return -EINVAL;
 		}
-	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
-		    xfs_has_dalign(mp)) {
+	} else if (xfs_has_dalign(mp) && !xfs_has_noalign(mp)) {
 			mp->m_dalign = sbp->sb_unit;
 			mp->m_swidth = sbp->sb_width;
 	}
@@ -454,22 +453,21 @@ xfs_set_maxicount(xfs_mount_t *mp)
  * is being used for NFS service (wsync mount option).
  */
 STATIC void
-xfs_set_rw_sizes(xfs_mount_t *mp)
+xfs_set_rw_sizes(
+	struct xfs_mount *mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	struct xfs_sb	*sbp = &mp->m_sb;
 	int		readio_log, writeio_log;
 
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
-		if (mp->m_flags & XFS_MOUNT_WSYNC) {
-			readio_log = XFS_WSYNC_READIO_LOG;
-			writeio_log = XFS_WSYNC_WRITEIO_LOG;
-		} else {
-			readio_log = XFS_READIO_LOG_LARGE;
-			writeio_log = XFS_WRITEIO_LOG_LARGE;
-		}
-	} else {
+	if (xfs_has_iosize(mp)) {
 		readio_log = mp->m_readio_log;
 		writeio_log = mp->m_writeio_log;
+	} else if (xfs_has_wsync(mp)) {
+		readio_log = XFS_WSYNC_READIO_LOG;
+		writeio_log = XFS_WSYNC_WRITEIO_LOG;
+	} else {
+		readio_log = XFS_READIO_LOG_LARGE;
+		writeio_log = XFS_WRITEIO_LOG_LARGE;
 	}
 
 	if (sbp->sb_blocklog > readio_log) {
@@ -704,18 +702,9 @@ xfs_mountfs(
 		xfs_warn(mp, "correcting sb_features alignment problem");
 		sbp->sb_features2 |= sbp->sb_bad_features2;
 		mp->m_update_sb = true;
-
-		/*
-		 * Re-check for ATTR2 in case it was found in bad_features2
-		 * slot.
-		 */
-		if (xfs_has_attr2(mp) &&
-		   !(mp->m_flags & XFS_MOUNT_NOATTR2))
-			mp->m_flags |= XFS_MOUNT_ATTR2;
 	}
 
-	if (xfs_has_attr2(mp) &&
-	   (mp->m_flags & XFS_MOUNT_NOATTR2)) {
+	if (xfs_has_attr2(mp) && xfs_has_noattr2(mp)) {
 		xfs_feat_remove_attr2(mp);
 		mp->m_update_sb = true;
 
@@ -988,10 +977,8 @@ xfs_mountfs(
 	 * We use the same quiesce mechanism as the rw->ro remount, as they are
 	 * semantically identical operations.
 	 */
-	if ((mp->m_flags & (XFS_MOUNT_RDONLY|XFS_MOUNT_NORECOVERY)) ==
-							XFS_MOUNT_RDONLY) {
+	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !xfs_has_norecovery(mp))
 		xfs_quiesce_attr(mp);
-	}
 
 	/*
 	 * Complete the quota initialisation, post-log-replay component.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 74a128fe316b..fee11d015b5a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -228,17 +228,19 @@ typedef struct xfs_mount {
 #define XFS_FEAT_WSYNC		(1ULL << 22)	/* synchronous metadata ops */
 #define XFS_FEAT_DIRSYNC	(1ULL << 23)	/* synchronous directory ops */
 #define XFS_FEAT_DISCARD	(1ULL << 24)	/* discard unused blocks */
-#define XFS_FEAT_GRPID		(1ULL << 25)	/* group-ID assigned from directory */
+#define XFS_FEAT_GRPID		(1ULL << 25)	/* GID assigned from directory */
 #define XFS_FEAT_SMALL_INUMS	(1ULL << 26)	/* user wants 32bit inodes */
 #define XFS_FEAT_IKEEP		(1ULL << 27)	/* keep empty inode clusters*/
 #define XFS_FEAT_SWALLOC	(1ULL << 28)	/* stripe width allocation */
-#define XFS_FEAT_FILESTREAMS	(1ULL << 29)	/* enable the filestreams
-						   allocator */
+#define XFS_FEAT_FILESTREAMS	(1ULL << 29)	/* use filestreams allocator */
 #define XFS_FEAT_DAX		(1ULL << 30)	/* TEST ONLY! */
-#define XFS_FEAT_COMPAT_IOSIZE	(1ULL << 31)	/* don't report large preferred
+#define XFS_FEAT_IOSIZE		(1ULL << 31)	/* user specified iosize */
+#define XFS_FEAT_COMPAT_IOSIZE	(1ULL << 32)	/* don't report large preferred
 						 * I/O size in stat() */
-#define XFS_FEAT_NORECOVERY	(1ULL << 32)	/* no recovery - dirty fs */
-#define XFS_FEAT_NOUUID		(1ULL << 33)	/* ignore uuid during mount */
+#define XFS_FEAT_NORECOVERY	(1ULL << 33)	/* no recovery - dirty fs */
+#define XFS_FEAT_NOUUID		(1ULL << 34)	/* ignore uuid during mount */
+#define XFS_FEAT_NOATTR2	(1ULL << 35)	/* disable attr2 completely */
+#define XFS_FEAT_NOALIGN	(1ULL << 36)	/* ignore alignment */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -306,44 +308,24 @@ __XFS_HAS_FEAT(ikeep, IKEEP)
 __XFS_HAS_FEAT(swalloc, SWALLOC)
 __XFS_HAS_FEAT(filestreams, FILESTREAMS)
 __XFS_HAS_FEAT(dax, DAX)
+__XFS_HAS_FEAT(iosize, IOSIZE)
 __XFS_HAS_FEAT(compat_iosize, COMPAT_IOSIZE)
 __XFS_HAS_FEAT(norecovery, NORECOVERY)
 __XFS_HAS_FEAT(nouuid, NOUUID)
+__XFS_HAS_FEAT(noattr2, NOATTR2)
+__XFS_HAS_FEAT(noalign, NOALIGN)
 
 /*
  * Flags for m_flags.
  */
-#define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
-						   must be synchronous except
-						   for space allocations */
 #define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
 #define XFS_MOUNT_BAD_SUMMARY	(1ULL << 2)	/* summary counters are bad */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
 						   disk errors in metadata */
-#define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
-#define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
-						   allocations */
-#define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
-#define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
-#define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
-#define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
-#define XFS_MOUNT_SMALL_INUMS	(1ULL << 14)	/* user wants 32bit inodes */
 #define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
-#define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
-#define XFS_MOUNT_IKEEP		(1ULL << 18)	/* keep empty inode clusters*/
-#define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
-						 * allocation */
 #define XFS_MOUNT_RDONLY	(1ULL << 20)	/* read-only fs */
-#define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
-#define XFS_MOUNT_COMPAT_IOSIZE	(1ULL << 22)	/* don't report large preferred
-						 * I/O size in stat() */
-#define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
-						   allocator */
-#define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
-
-#define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
 
 
 /*
@@ -381,13 +363,13 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 static inline unsigned long
 xfs_preferred_iosize(xfs_mount_t *mp)
 {
-	if (mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)
+	if (xfs_has_compat_iosize(mp))
 		return PAGE_SIZE;
-	return (mp->m_swidth ?
-		(mp->m_swidth << mp->m_sb.sb_blocklog) :
-		((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ?
-			(1 << (int)max(mp->m_readio_log, mp->m_writeio_log)) :
-			PAGE_SIZE));
+	if (mp->m_swidth)
+		return mp->m_swidth << mp->m_sb.sb_blocklog;
+	if (xfs_has_iosize(mp))
+		return 1 << (int)max(mp->m_readio_log, mp->m_writeio_log);
+	return PAGE_SIZE;
 }
 
 #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index cf76884c2a95..d3dff878be99 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -193,15 +193,15 @@ xfs_parseargs(
 	if (sb_rdonly(sb))
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	if (sb->s_flags & SB_DIRSYNC)
-		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+		mp->m_features |= XFS_FEAT_DIRSYNC;
 	if (sb->s_flags & SB_SYNCHRONOUS)
-		mp->m_flags |= XFS_MOUNT_WSYNC;
+		mp->m_features |= XFS_FEAT_WSYNC;
 
 	/*
 	 * Set some default flags that could be cleared by the mount option
 	 * parsing.
 	 */
-	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+	mp->m_features |= XFS_FEAT_COMPAT_IOSIZE;
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -251,23 +251,23 @@ xfs_parseargs(
 			break;
 		case Opt_grpid:
 		case Opt_bsdgroups:
-			mp->m_flags |= XFS_MOUNT_GRPID;
+			mp->m_features |= XFS_FEAT_GRPID;
 			break;
 		case Opt_nogrpid:
 		case Opt_sysvgroups:
-			mp->m_flags &= ~XFS_MOUNT_GRPID;
+			mp->m_features &= ~XFS_FEAT_GRPID;
 			break;
 		case Opt_wsync:
-			mp->m_flags |= XFS_MOUNT_WSYNC;
+			mp->m_features |= XFS_FEAT_WSYNC;
 			break;
 		case Opt_norecovery:
-			mp->m_flags |= XFS_MOUNT_NORECOVERY;
+			mp->m_features |= XFS_FEAT_NORECOVERY;
 			break;
 		case Opt_noalign:
-			mp->m_flags |= XFS_MOUNT_NOALIGN;
+			mp->m_features |= XFS_FEAT_NOALIGN;
 			break;
 		case Opt_swalloc:
-			mp->m_flags |= XFS_MOUNT_SWALLOC;
+			mp->m_features |= XFS_FEAT_SWALLOC;
 			break;
 		case Opt_sunit:
 			if (match_int(args, &dsunit))
@@ -278,35 +278,34 @@ xfs_parseargs(
 				return -EINVAL;
 			break;
 		case Opt_inode32:
-			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+			mp->m_features |= XFS_FEAT_SMALL_INUMS;
 			break;
 		case Opt_inode64:
-			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+			mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
 			break;
 		case Opt_nouuid:
-			mp->m_flags |= XFS_MOUNT_NOUUID;
+			mp->m_features |= XFS_FEAT_NOUUID;
 			break;
 		case Opt_ikeep:
-			mp->m_flags |= XFS_MOUNT_IKEEP;
+			mp->m_features |= XFS_FEAT_IKEEP;
 			break;
 		case Opt_noikeep:
-			mp->m_flags &= ~XFS_MOUNT_IKEEP;
+			mp->m_features &= ~XFS_FEAT_IKEEP;
 			break;
 		case Opt_largeio:
-			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
+			mp->m_features &= ~XFS_FEAT_COMPAT_IOSIZE;
 			break;
 		case Opt_nolargeio:
-			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+			mp->m_features |= XFS_FEAT_COMPAT_IOSIZE;
 			break;
 		case Opt_attr2:
-			mp->m_flags |= XFS_MOUNT_ATTR2;
+			mp->m_features |= XFS_FEAT_ATTR2;
 			break;
 		case Opt_noattr2:
-			mp->m_flags &= ~XFS_MOUNT_ATTR2;
-			mp->m_flags |= XFS_MOUNT_NOATTR2;
+			mp->m_features |= XFS_FEAT_NOATTR2;
 			break;
 		case Opt_filestreams:
-			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+			mp->m_features |= XFS_FEAT_FILESTREAMS;
 			break;
 		case Opt_noquota:
 			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
@@ -343,14 +342,14 @@ xfs_parseargs(
 			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
 			break;
 		case Opt_discard:
-			mp->m_flags |= XFS_MOUNT_DISCARD;
+			mp->m_features |= XFS_FEAT_DISCARD;
 			break;
 		case Opt_nodiscard:
-			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+			mp->m_features &= ~XFS_FEAT_DISCARD;
 			break;
 #ifdef CONFIG_FS_DAX
 		case Opt_dax:
-			mp->m_flags |= XFS_MOUNT_DAX;
+			mp->m_features |= XFS_FEAT_DAX;
 			break;
 #endif
 		default:
@@ -362,13 +361,12 @@ xfs_parseargs(
 	/*
 	 * no recovery flag requires a read-only mount
 	 */
-	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
-	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (xfs_has_norecovery(mp) && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_warn(mp, "no-recovery mounts must be read-only.");
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
+	if (xfs_has_noalign(mp) && (dsunit || dswidth)) {
 		xfs_warn(mp,
 	"sunit and swidth options incompatible with the noalign option");
 		return -EINVAL;
@@ -394,7 +392,7 @@ xfs_parseargs(
 	}
 
 done:
-	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
+	if (dsunit && !xfs_has_noalign(mp)) {
 		/*
 		 * At this point the superblock has not been read
 		 * in, therefore we do not know the block size.
@@ -433,7 +431,7 @@ xfs_parseargs(
 			return -EINVAL;
 		}
 
-		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
+		mp->m_features |= XFS_FEAT_IOSIZE;
 		mp->m_readio_log = iosizelog;
 		mp->m_writeio_log = iosizelog;
 	}
@@ -453,38 +451,38 @@ xfs_showargs(
 {
 	static struct proc_xfs_info xfs_info_set[] = {
 		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_IKEEP,		",ikeep" },
-		{ XFS_MOUNT_WSYNC,		",wsync" },
-		{ XFS_MOUNT_NOALIGN,		",noalign" },
-		{ XFS_MOUNT_SWALLOC,		",swalloc" },
-		{ XFS_MOUNT_NOUUID,		",nouuid" },
-		{ XFS_MOUNT_NORECOVERY,		",norecovery" },
-		{ XFS_MOUNT_ATTR2,		",attr2" },
-		{ XFS_MOUNT_FILESTREAMS,	",filestreams" },
-		{ XFS_MOUNT_GRPID,		",grpid" },
-		{ XFS_MOUNT_DISCARD,		",discard" },
-		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
-		{ XFS_MOUNT_DAX,		",dax" },
+		{ XFS_FEAT_IKEEP,	",ikeep" },
+		{ XFS_FEAT_WSYNC,	",wsync" },
+		{ XFS_FEAT_NOALIGN,	",noalign" },
+		{ XFS_FEAT_SWALLOC,	",swalloc" },
+		{ XFS_FEAT_NOUUID,	",nouuid" },
+		{ XFS_FEAT_NORECOVERY,	",norecovery" },
+		{ XFS_FEAT_ATTR2,	",attr2" },
+		{ XFS_FEAT_FILESTREAMS,	",filestreams" },
+		{ XFS_FEAT_GRPID,	",grpid" },
+		{ XFS_FEAT_DISCARD,	",discard" },
+		{ XFS_FEAT_SMALL_INUMS,	",inode32" },
+		{ XFS_FEAT_DAX,		",dax" },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
 		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_COMPAT_IOSIZE,	",largeio" },
-		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
+		{ XFS_FEAT_COMPAT_IOSIZE, ",largeio" },
+		{ XFS_FEAT_SMALL_INUMS,	",inode64" },
 		{ 0, NULL }
 	};
 	struct proc_xfs_info	*xfs_infop;
 
 	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
-		if (mp->m_flags & xfs_infop->flag)
+		if (mp->m_features & xfs_infop->flag)
 			seq_puts(m, xfs_infop->str);
 	}
 	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
-		if (!(mp->m_flags & xfs_infop->flag))
+		if (!(mp->m_features & xfs_infop->flag))
 			seq_puts(m, xfs_infop->str);
 	}
 
-	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
+	if (xfs_has_iosize(mp))
 		seq_printf(m, ",allocsize=%dk",
 				(int)(1 << mp->m_writeio_log) >> 10);
 
@@ -565,10 +563,10 @@ xfs_max_file_offset(
 /*
  * Set parameters for inode allocation heuristics, taking into account
  * filesystem size and inode32/inode64 mount options; i.e. specifically
- * whether or not XFS_MOUNT_SMALL_INUMS is set.
+ * whether or not XFS_FEAT_SMALL_INUMS is set.
  *
  * Inode allocation patterns are altered only if inode32 is requested
- * (XFS_MOUNT_SMALL_INUMS), and the filesystem is sufficiently large.
+ * (XFS_FEAT_SMALL_INUMS), and the filesystem is sufficiently large.
  * If altered, XFS_MOUNT_32BITINODES is set as well.
  *
  * An agcount independent of that in the mount structure is provided
@@ -614,7 +612,7 @@ xfs_set_inode_alloc(
 	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
 	 * the allocator to accommodate the request.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
+	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
 		mp->m_flags |= XFS_MOUNT_32BITINODES;
 	else
 		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
@@ -1261,11 +1259,11 @@ xfs_fs_remount(
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_inode64:
-			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+			mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
 			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
 			break;
 		case Opt_inode32:
-			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+			mp->m_features |= XFS_FEAT_SMALL_INUMS;
 			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
 			break;
 		default:
@@ -1297,7 +1295,7 @@ xfs_fs_remount(
 
 	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
-		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
+		if (xfs_has_norecovery(mp)) {
 			xfs_warn(mp,
 		"ro->rw transition prohibited on norecovery mount");
 			return -EINVAL;
@@ -1460,21 +1458,12 @@ xfs_finish_flags(
 	/*
 	 * V5 filesystems always use attr2 format for attributes.
 	 */
-	if (xfs_has_crc(mp) &&
-	    (mp->m_flags & XFS_MOUNT_NOATTR2)) {
+	if (xfs_has_crc(mp) && xfs_has_noattr2(mp)) {
 		xfs_warn(mp, "Cannot mount a V5 filesystem as noattr2. "
 			     "attr2 is always enabled for V5 filesystems.");
 		return -EINVAL;
 	}
 
-	/*
-	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
-	 * told by noattr2 to turn it off
-	 */
-	if (xfs_has_attr2(mp) &&
-	    !(mp->m_flags & XFS_MOUNT_NOATTR2))
-		mp->m_flags |= XFS_MOUNT_ATTR2;
-
 	/*
 	 * prohibit r/w mounts of read-only filesystems
 	 */
@@ -1662,7 +1651,7 @@ xfs_fs_fill_super(
 	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
 		sb->s_flags |= SB_I_VERSION;
 
-	if (mp->m_flags & XFS_MOUNT_DAX) {
+	if (xfs_has_dax(mp)) {
 		bool rtdev_is_dax = false, datadev_is_dax;
 
 		xfs_warn(mp,
@@ -1676,7 +1665,7 @@ xfs_fs_fill_super(
 		if (!rtdev_is_dax && !datadev_is_dax) {
 			xfs_alert(mp,
 			"DAX unsupported by block device. Turning off DAX.");
-			mp->m_flags &= ~XFS_MOUNT_DAX;
+			mp->m_features &= ~XFS_FEAT_DAX;
 		}
 		if (xfs_has_reflink(mp)) {
 			xfs_alert(mp,
@@ -1686,13 +1675,13 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (mp->m_flags & XFS_MOUNT_DISCARD) {
+	if (xfs_has_discard(mp)) {
 		struct request_queue *q = bdev_get_queue(sb->s_bdev);
 
 		if (!blk_queue_discard(q)) {
 			xfs_warn(mp, "mounting with \"discard\" option, but "
 					"the device does not support discard");
-			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+			mp->m_features &= ~XFS_FEAT_DISCARD;
 		}
 	}
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 647a9aa98646..675481028292 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -339,9 +339,8 @@ xfs_symlink(
 	 * symlink transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
+	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
-	}
 
 	error = xfs_trans_commit(tp);
 	if (error)
-- 
2.17.0
