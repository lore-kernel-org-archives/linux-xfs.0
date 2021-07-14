Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83BAC11F6E
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3D9A613B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhGNEWR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 00:22:17 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51719 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237725AbhGNEWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 00:22:10 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id A319210AE37
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 14:19:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3WMe-006JJu-5N
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 14:19:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3WMd-00B154-T0
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 14:19:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/16] xfs: convert mount flags to features
Date:   Wed, 14 Jul 2021 14:19:03 +1000
Message-Id: <20210714041912.2625692-8-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714041912.2625692-1-david@fromorbit.com>
References: <20210714041912.2625692-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=QmtM_vsPyjFOj0wD2psA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Replace m_flags feature checks with xfs_has_<feature>() calls and
rework the setup code to set flags in m_features.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |  36 +++++----
 fs/xfs/libxfs/xfs_bmap.c      |   4 +-
 fs/xfs/libxfs/xfs_ialloc.c    |  10 +--
 fs/xfs/scrub/scrub.c          |   2 +-
 fs/xfs/xfs_acl.c              |   2 +-
 fs/xfs/xfs_bmap_util.c        |   2 +-
 fs/xfs/xfs_discard.c          |   2 +-
 fs/xfs/xfs_export.c           |   2 +-
 fs/xfs/xfs_file.c             |   2 +-
 fs/xfs/xfs_filestream.h       |   2 +-
 fs/xfs/xfs_icache.c           |   7 +-
 fs/xfs/xfs_inode.c            |  13 ++--
 fs/xfs/xfs_inode.h            |   3 +-
 fs/xfs/xfs_ioctl.c            |   5 +-
 fs/xfs/xfs_iomap.c            |   4 +-
 fs/xfs/xfs_iops.c             |  12 +--
 fs/xfs/xfs_log.c              |  14 ++--
 fs/xfs/xfs_log_cil.c          |   4 +-
 fs/xfs/xfs_mount.c            |  24 +++---
 fs/xfs/xfs_mount.h            |  26 +------
 fs/xfs/xfs_super.c            | 141 ++++++++++++++++------------------
 fs/xfs/xfs_symlink.c          |   3 +-
 23 files changed, 148 insertions(+), 176 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d31ea7f1a7fc..11fb9e3ccf95 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -224,7 +224,7 @@ xfs_attr_try_sf_addname(
 	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
-	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(dp->i_mount))
 		xfs_trans_set_sync(args->trans);
 
 	return error;
@@ -790,7 +790,7 @@ xfs_attr_set(
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(args->trans);
 
 	if (!(args->op_flags & XFS_DA_OP_NOTIME))
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 37d72a344ab2..058b1342be4e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -568,7 +568,7 @@ xfs_attr_shortform_bytesfit(
 	 * literal area, but for the old format we are done if there is no
 	 * space in the fixed attribute fork.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_ATTR2))
+	if (!xfs_has_attr2(mp))
 		return 0;
 
 	dsize = dp->i_df.if_bytes;
@@ -621,21 +621,26 @@ xfs_attr_shortform_bytesfit(
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
-			xfs_add_attr2(mp);
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
+	xfs_add_attr2(mp);
+	spin_unlock(&mp->m_sb_lock);
+	xfs_log_sb(tp);
 }
 
 /*
@@ -810,8 +815,7 @@ xfs_attr_sf_removename(
 	 * Fix up the start offset of the attribute fork
 	 */
 	totsize -= size;
-	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
-	    (mp->m_flags & XFS_MOUNT_ATTR2) &&
+	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
 		xfs_attr_fork_remove(dp, args->trans);
@@ -821,7 +825,7 @@ xfs_attr_sf_removename(
 		ASSERT(dp->i_forkoff);
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
-				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
+				!xfs_has_attr2(mp) ||
 				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
@@ -997,7 +1001,7 @@ xfs_attr_shortform_allfit(
 		bytes += xfs_attr_sf_entsize_byname(name_loc->namelen,
 					be16_to_cpu(name_loc->valuelen));
 	}
-	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
+	if (xfs_has_attr2(dp->i_mount) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    (bytes == sizeof(struct xfs_attr_sf_hdr)))
 		return -1;
@@ -1122,7 +1126,7 @@ xfs_attr3_leaf_to_shortform(
 		goto out;
 
 	if (forkoff == -1) {
-		ASSERT(dp->i_mount->m_flags & XFS_MOUNT_ATTR2);
+		ASSERT(xfs_has_attr2(dp->i_mount));
 		ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_BTREE);
 		xfs_attr_fork_remove(dp, args->trans);
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e806f8517012..51f091108a20 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1047,7 +1047,7 @@ xfs_bmap_set_attrforkoff(
 		ip->i_forkoff = xfs_attr_shortform_bytesfit(ip, size);
 		if (!ip->i_forkoff)
 			ip->i_forkoff = default_size;
-		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
+		else if (xfs_has_attr2(ip->i_mount) && version)
 			*version = 2;
 		break;
 	default:
@@ -3422,7 +3422,7 @@ xfs_bmap_compute_alignments(
 	int			stripe_align = 0;
 
 	/* stripe alignment for allocation is determined by mount parameters */
-	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+	if (mp->m_swidth && xfs_has_swalloc(mp))
 		stripe_align = mp->m_swidth;
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4bb6a936670f..a9fc71a96666 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -712,7 +712,7 @@ xfs_ialloc_ag_alloc(
 		 */
 		isaligned = 0;
 		if (igeo->ialloc_align) {
-			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
+			ASSERT(!xfs_has_noalign(args.mp));
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
 		} else
@@ -1953,8 +1953,7 @@ xfs_difree_inobt(
 	 * remove the chunk if the block size is large enough for multiple inode
 	 * chunks (that might not be free).
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    rec.ir_free == XFS_INOBT_ALL_FREE &&
+	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		struct xfs_perag	*pag = agbp->b_pag;
 
@@ -2098,9 +2097,8 @@ xfs_difree_finobt(
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
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 2bed6bc573da..d9534fe0c69b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -483,7 +483,7 @@ xfs_scrub_metadata(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		goto out;
 	error = -ENOTRECOVERABLE;
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+	if (xfs_has_norecovery(mp))
 		goto out;
 
 	error = xchk_validate_inputs(mp, sm);
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index d02bef24b32b..f7fc1d25b058 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -232,7 +232,7 @@ xfs_acl_set_mode(
 	inode->i_ctime = current_time(inode);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index af0a61134d1f..a43220dba739 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1822,7 +1822,7 @@ xfs_swap_extents(
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 736df5660f1f..0191de8ce9ce 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -169,7 +169,7 @@ xfs_ioc_trim(
 	 * We haven't recovered the log, so we cannot use our bnobt-guided
 	 * storage zapping commands.
 	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+	if (xfs_has_norecovery(mp))
 		return -EROFS;
 
 	if (copy_from_user(&range, urange, sizeof(range)))
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 1da59bdff245..cb359ec3389b 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -63,7 +63,7 @@ xfs_fs_encode_fh(
 	 * large enough filesystem may contain them, thus the slightly
 	 * confusing looking conditional below.
 	 */
-	if (!(XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_SMALL_INUMS) ||
+	if (!xfs_has_small_inums(XFS_M(inode->i_sb)) ||
 	    (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES))
 		fileid_type |= XFS_FILEID_TYPE_64FLAG;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index fe31b53274ce..0fa02ea21ade 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1122,7 +1122,7 @@ static inline bool xfs_file_sync_writes(struct file *filp)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(filp));
 
-	if (ip->i_mount->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(ip->i_mount))
 		return true;
 	if (filp->f_flags & (__O_SYNC | O_DSYNC))
 		return true;
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 3af963743e4d..403226ebb80b 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -21,7 +21,7 @@ static inline int
 xfs_inode_is_filestream(
 	struct xfs_inode	*ip)
 {
-	return (ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
+	return xfs_has_filestreams(ip->i_mount) ||
 		(ip->i_diflags & XFS_DIFLAG_FILESTREAM);
 }
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 764fb33b5c88..81da0a59a106 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -597,7 +597,7 @@ xfs_iget_cache_miss(
 
 	/*
 	 * For version 5 superblocks, if we are initialising a new inode and we
-	 * are not utilising the XFS_MOUNT_IKEEP inode cluster mode, we can
+	 * are not utilising the XFS_FEAT_IKEEP inode cluster mode, we can
 	 * simply build the new inode core with a random generation number.
 	 *
 	 * For version 4 (and older) superblocks, log recovery is dependent on
@@ -606,7 +606,7 @@ xfs_iget_cache_miss(
 	 * initializing new inodes.
 	 */
 	if (xfs_has_v3inodes(mp) &&
-	    (flags & XFS_IGET_CREATE) && !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+	    (flags & XFS_IGET_CREATE) && !xfs_has_ikeep(mp)) {
 		VFS_I(ip)->i_generation = prandom_u32();
 	} else {
 		struct xfs_buf		*bp;
@@ -1052,8 +1052,7 @@ static inline bool
 xfs_want_reclaim_sick(
 	struct xfs_mount	*mp)
 {
-	return (mp->m_flags & XFS_MOUNT_UNMOUNTING) ||
-	       (mp->m_flags & XFS_MOUNT_NORECOVERY) ||
+	return (mp->m_flags & XFS_MOUNT_UNMOUNTING) || xfs_has_norecovery(mp) ||
 	       XFS_FORCED_SHUTDOWN(mp);
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 67e3d8dd723f..59cea74df9a7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -826,8 +826,7 @@ xfs_init_new_inode(
 	inode->i_rdev = rdev;
 	ip->i_projid = prid;
 
-	if (dir && !(dir->i_mode & S_ISGID) &&
-	    (mp->m_flags & XFS_MOUNT_GRPID)) {
+	if (dir && !(dir->i_mode & S_ISGID) && xfs_has_grpid(mp)) {
 		inode_fsuid_set(inode, mnt_userns);
 		inode->i_gid = dir->i_gid;
 		inode->i_mode = mode;
@@ -1068,7 +1067,7 @@ xfs_create(
 	 * create transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
 	/*
@@ -1160,7 +1159,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 
 	/*
@@ -1294,7 +1293,7 @@ xfs_link(
 	 * link transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
 	return xfs_trans_commit(tp);
@@ -2789,7 +2788,7 @@ xfs_remove(
 	 * remove transaction goes to disk before returning to
 	 * the user.
 	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp);
@@ -2866,7 +2865,7 @@ xfs_finish_rename(
 	 * If this is a synchronous mount, make sure that the rename transaction
 	 * goes to disk before returning to the user.
 	 */
-	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+	if (xfs_has_wsync(tp->t_mountp) || xfs_has_dirsync(tp->t_mountp))
 		xfs_trans_set_sync(tp);
 
 	return xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4b6703dbffb8..b33790167113 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -382,8 +382,7 @@ enum layout_break_reason {
  * new subdirectory gets S_ISGID bit from parent.
  */
 #define XFS_INHERIT_GID(pip)	\
-	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
-	 (VFS_I(pip)->i_mode & S_ISGID))
+	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
 
 int		xfs_release(struct xfs_inode *ip);
 void		xfs_inactive(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8851e3c65ef1..1c7f01cdba71 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1220,8 +1220,7 @@ xfs_ioctl_setattr_prepare_dax(
 	if (S_ISDIR(inode->i_mode))
 		return;
 
-	if ((mp->m_flags & XFS_MOUNT_DAX_ALWAYS) ||
-	    (mp->m_flags & XFS_MOUNT_DAX_NEVER))
+	if (xfs_has_dax_always(mp) || xfs_has_dax_never(mp))
 		return;
 
 	if (((fa->fsx_xflags & FS_XFLAG_DAX) &&
@@ -1257,7 +1256,7 @@ xfs_ioctl_setattr_get_trans(
 	if (error)
 		goto out_error;
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 
 	return tp;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d8cd2583dedb..3e46ad99dd63 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -132,7 +132,7 @@ xfs_eof_alignment(
 		 * If mounted with the "-o swalloc" option the alignment is
 		 * increased from the strip unit size to the stripe width.
 		 */
-		if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+		if (mp->m_swidth && xfs_has_swalloc(mp))
 			align = mp->m_swidth;
 		else if (mp->m_dalign)
 			align = mp->m_dalign;
@@ -994,7 +994,7 @@ xfs_buffered_write_iomap_begin(
 		 * Determine the initial size of the preallocation.
 		 * We clean up any extra preallocation when the file is closed.
 		 */
-		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
+		if (xfs_has_allocsize(mp))
 			prealloc_blocks = mp->m_allocsize_blocks;
 		else
 			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9c525a8b6d90..2208345546c1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -558,10 +558,10 @@ xfs_stat_blksize(
 	 * default buffered I/O size, return that, otherwise return the compat
 	 * default.
 	 */
-	if (mp->m_flags & XFS_MOUNT_LARGEIO) {
+	if (xfs_has_large_iosize(mp)) {
 		if (mp->m_swidth)
 			return XFS_FSB_TO_B(mp, mp->m_swidth);
-		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
+		if (xfs_has_allocsize(mp))
 			return 1U << mp->m_allocsize_log;
 	}
 
@@ -808,7 +808,7 @@ xfs_setattr_nonsize(
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 
@@ -1037,7 +1037,7 @@ xfs_setattr_size(
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp);
@@ -1287,11 +1287,11 @@ xfs_inode_should_enable_dax(
 {
 	if (!IS_ENABLED(CONFIG_FS_DAX))
 		return false;
-	if (ip->i_mount->m_flags & XFS_MOUNT_DAX_NEVER)
+	if (xfs_has_dax_never(ip->i_mount))
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
-	if (ip->i_mount->m_flags & XFS_MOUNT_DAX_ALWAYS)
+	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
 		return true;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d4247914a2c5..ac18fe03a630 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -362,7 +362,7 @@ xfs_log_writable(
 	 * mounts allow internal writes for log recovery and unmount purposes,
 	 * so don't restrict that case.
 	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+	if (xfs_has_norecovery(mp))
 		return false;
 	if (xfs_readonly_buftarg(mp->m_ddev_targp))
 		return false;
@@ -614,7 +614,7 @@ xfs_log_mount(
 	int		error = 0;
 	int		min_logfsbs;
 
-	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
+	if (!xfs_has_norecovery(mp)) {
 		xfs_notice(mp, "Mounting V%d Filesystem",
 			   XFS_SB_VERSION_NUM(&mp->m_sb));
 	} else {
@@ -700,8 +700,8 @@ xfs_log_mount(
 	 * skip log recovery on a norecovery mount.  pretend it all
 	 * just worked.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
-		int	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
+	if (!xfs_has_norecovery(mp)) {
+		bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 		if (readonly)
 			mp->m_flags &= ~XFS_MOUNT_RDONLY;
@@ -761,8 +761,8 @@ xfs_log_mount_finish(
 	bool			readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 	int			error = 0;
 
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+	if (xfs_has_norecovery(mp)) {
+		ASSERT(readonly);
 		return 0;
 	} else if (readonly) {
 		/* Allow unlinked processing to proceed */
@@ -3820,7 +3820,7 @@ xfs_log_check_lsn(
 	 * resets the in-core LSN. We can't validate in this mode, but
 	 * modifications are not allowed anyways so just return true.
 	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+	if (xfs_has_norecovery(mp))
 		return true;
 
 	/*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5ef47aed10f9..7739ff2419e1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -535,7 +535,7 @@ xlog_discard_busy_extents(
 	struct blk_plug		plug;
 	int			error = 0;
 
-	ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
+	ASSERT(xfs_has_discard(mp));
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, list, list) {
@@ -597,7 +597,7 @@ xlog_cil_committed(
 
 	xfs_extent_busy_sort(&ctx->busy_extents);
 	xfs_extent_busy_clear(mp, &ctx->busy_extents,
-			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
+			      xfs_has_discard(mp) && !abort);
 
 	spin_lock(&ctx->cil->xc_push_lock);
 	list_del(&ctx->committing);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2ef58db9f0f0..0750b2a0a6c5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -62,7 +62,7 @@ xfs_uuid_mount(
 	/* Publish UUID in struct super_block */
 	uuid_copy(&mp->m_super->s_uuid, uuid);
 
-	if (mp->m_flags & XFS_MOUNT_NOUUID)
+	if (xfs_has_nouuid(mp))
 		return 0;
 
 	if (uuid_is_null(uuid)) {
@@ -104,7 +104,7 @@ xfs_uuid_unmount(
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
 	int			i;
 
-	if (mp->m_flags & XFS_MOUNT_NOUUID)
+	if (xfs_has_nouuid(mp))
 		return;
 
 	mutex_lock(&xfs_uuid_table_mutex);
@@ -350,8 +350,7 @@ xfs_update_alignment(
 		sbp->sb_unit = mp->m_dalign;
 		sbp->sb_width = mp->m_swidth;
 		mp->m_update_sb = true;
-	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
-		    xfs_has_dalign(mp)) {
+	} else if (!xfs_has_noalign(mp) && xfs_has_dalign(mp)) {
 		mp->m_dalign = sbp->sb_unit;
 		mp->m_swidth = sbp->sb_width;
 	}
@@ -770,12 +769,15 @@ xfs_mountfs(
 	/*
 	 * Now that we've recovered any pending superblock feature bit
 	 * additions, we can finish setting up the attr2 behaviour for the
-	 * mount. If no attr2 mount options were specified, the we use the
-	 * behaviour specified by the superblock feature bit.
+	 * mount. The noattr2 option overrides the superblock flag, so only
+	 * check the superblock feature flag if the mount option is not set.
 	 */
-	if (!(mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) &&
-	    xfs_has_attr2(mp))
-		mp->m_flags |= XFS_MOUNT_ATTR2;
+	if (xfs_has_noattr2(mp)) {
+		mp->m_features &= ~XFS_FEAT_ATTR2;
+	} else if (!xfs_has_attr2(mp) &&
+		   (mp->m_sb.sb_features2 & XFS_SB_VERSION2_ATTR2BIT)) {
+		mp->m_features |= XFS_FEAT_ATTR2;
+	}
 
 	/*
 	 * Get and sanity-check the root inode.
@@ -879,10 +881,8 @@ xfs_mountfs(
 	 * We use the same quiesce mechanism as the rw->ro remount, as they are
 	 * semantically identical operations.
 	 */
-	if ((mp->m_flags & (XFS_MOUNT_RDONLY|XFS_MOUNT_NORECOVERY)) ==
-							XFS_MOUNT_RDONLY) {
+	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !xfs_has_norecovery(mp))
 		xfs_log_clean(mp);
-	}
 
 	/*
 	 * Complete the quota initialisation, post-log-replay component.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b0e8c3825ce8..387be1bfb431 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -351,32 +351,12 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 						   must be synchronous except
 						   for space allocations */
 #define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
-#define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
-#define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
+#define XFS_MOUNT_WAS_CLEAN	(1ULL << 2)
+#define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 3)	/* atomic stop of all filesystem
 						   operations, typically for
 						   disk errors in metadata */
-#define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
-#define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
-						   allocations */
-#define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
-#define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
-#define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
-#define XFS_MOUNT_ALLOCSIZE	(1ULL << 12)	/* specified allocation size */
-#define XFS_MOUNT_SMALL_INUMS	(1ULL << 14)	/* user wants 32bit inodes */
 #define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
-#define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
-#define XFS_MOUNT_IKEEP		(1ULL << 18)	/* keep empty inode clusters*/
-#define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
-						 * allocation */
-#define XFS_MOUNT_RDONLY	(1ULL << 20)	/* read-only fs */
-#define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
-#define XFS_MOUNT_LARGEIO	(1ULL << 22)	/* report large preferred
-						 * I/O size in stat() */
-#define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
-						   allocator */
-#define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
-#define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
-#define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
+#define XFS_MOUNT_RDONLY	(1ULL << 4)	/* read-only fs */
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5aaf34572c06..9c3fc7f5e5ab 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -62,15 +62,15 @@ xfs_mount_set_dax_mode(
 {
 	switch (mode) {
 	case XFS_DAX_INODE:
-		mp->m_flags &= ~(XFS_MOUNT_DAX_ALWAYS | XFS_MOUNT_DAX_NEVER);
+		mp->m_features &= ~(XFS_FEAT_DAX_ALWAYS | XFS_FEAT_DAX_NEVER);
 		break;
 	case XFS_DAX_ALWAYS:
-		mp->m_flags |= XFS_MOUNT_DAX_ALWAYS;
-		mp->m_flags &= ~XFS_MOUNT_DAX_NEVER;
+		mp->m_features |= XFS_FEAT_DAX_ALWAYS;
+		mp->m_features &= ~XFS_FEAT_DAX_NEVER;
 		break;
 	case XFS_DAX_NEVER:
-		mp->m_flags |= XFS_MOUNT_DAX_NEVER;
-		mp->m_flags &= ~XFS_MOUNT_DAX_ALWAYS;
+		mp->m_features |= XFS_FEAT_DAX_NEVER;
+		mp->m_features &= ~XFS_FEAT_DAX_ALWAYS;
 		break;
 	}
 }
@@ -154,33 +154,32 @@ xfs_fs_show_options(
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
-		{ XFS_MOUNT_LARGEIO,		",largeio" },
-		{ XFS_MOUNT_DAX_ALWAYS,		",dax=always" },
-		{ XFS_MOUNT_DAX_NEVER,		",dax=never" },
+		{ XFS_FEAT_IKEEP,		",ikeep" },
+		{ XFS_FEAT_WSYNC,		",wsync" },
+		{ XFS_FEAT_NOALIGN,		",noalign" },
+		{ XFS_FEAT_SWALLOC,		",swalloc" },
+		{ XFS_FEAT_NOUUID,		",nouuid" },
+		{ XFS_FEAT_NORECOVERY,		",norecovery" },
+		{ XFS_FEAT_ATTR2,		",attr2" },
+		{ XFS_FEAT_FILESTREAMS,		",filestreams" },
+		{ XFS_FEAT_GRPID,		",grpid" },
+		{ XFS_FEAT_DISCARD,		",discard" },
+		{ XFS_FEAT_LARGE_IOSIZE,	",largeio" },
+		{ XFS_FEAT_DAX_ALWAYS,		",dax=always" },
+		{ XFS_FEAT_DAX_NEVER,		",dax=never" },
 		{ 0, NULL }
 	};
 	struct xfs_mount	*mp = XFS_M(root->d_sb);
 	struct proc_xfs_info	*xfs_infop;
 
 	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
-		if (mp->m_flags & xfs_infop->flag)
+		if (mp->m_features & xfs_infop->flag)
 			seq_puts(m, xfs_infop->str);
 	}
 
-	seq_printf(m, ",inode%d",
-		(mp->m_flags & XFS_MOUNT_SMALL_INUMS) ? 32 : 64);
+	seq_printf(m, ",inode%d", xfs_has_small_inums(mp) ? 32 : 64);
 
-	if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
+	if (xfs_has_allocsize(mp))
 		seq_printf(m, ",allocsize=%dk",
 			   (1 << mp->m_allocsize_log) >> 10);
 
@@ -230,10 +229,10 @@ xfs_fs_show_options(
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
@@ -279,7 +278,7 @@ xfs_set_inode_alloc(
 	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
 	 * the allocator to accommodate the request.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
+	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
 		mp->m_flags |= XFS_MOUNT_32BITINODES;
 	else
 		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
@@ -938,8 +937,7 @@ xfs_finish_flags(
 	/*
 	 * V5 filesystems always use attr2 format for attributes.
 	 */
-	if (xfs_has_crc(mp) &&
-	    (mp->m_flags & XFS_MOUNT_NOATTR2)) {
+	if (xfs_has_crc(mp) && xfs_has_noattr2(mp)) {
 		xfs_warn(mp, "Cannot mount a V5 filesystem as noattr2. "
 			     "attr2 is always enabled for V5 filesystems.");
 		return -EINVAL;
@@ -1123,7 +1121,7 @@ xfs_fs_warn_deprecated(
 	 * already had the flag set
 	 */
 	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
-			!!(XFS_M(fc->root->d_sb)->m_flags & flag) == value)
+            !!(XFS_M(fc->root->d_sb)->m_features & flag) == value)
 		return;
 	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
 }
@@ -1171,27 +1169,27 @@ xfs_fs_parse_param(
 		if (suffix_kstrtoint(param->string, 10, &size))
 			return -EINVAL;
 		parsing_mp->m_allocsize_log = ffs(size) - 1;
-		parsing_mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
+		parsing_mp->m_features |= XFS_FEAT_ALLOCSIZE;
 		return 0;
 	case Opt_grpid:
 	case Opt_bsdgroups:
-		parsing_mp->m_flags |= XFS_MOUNT_GRPID;
+		parsing_mp->m_features |= XFS_FEAT_GRPID;
 		return 0;
 	case Opt_nogrpid:
 	case Opt_sysvgroups:
-		parsing_mp->m_flags &= ~XFS_MOUNT_GRPID;
+		parsing_mp->m_features &= ~XFS_FEAT_GRPID;
 		return 0;
 	case Opt_wsync:
-		parsing_mp->m_flags |= XFS_MOUNT_WSYNC;
+		parsing_mp->m_features |= XFS_FEAT_WSYNC;
 		return 0;
 	case Opt_norecovery:
-		parsing_mp->m_flags |= XFS_MOUNT_NORECOVERY;
+		parsing_mp->m_features |= XFS_FEAT_NORECOVERY;
 		return 0;
 	case Opt_noalign:
-		parsing_mp->m_flags |= XFS_MOUNT_NOALIGN;
+		parsing_mp->m_features |= XFS_FEAT_NOALIGN;
 		return 0;
 	case Opt_swalloc:
-		parsing_mp->m_flags |= XFS_MOUNT_SWALLOC;
+		parsing_mp->m_features |= XFS_FEAT_SWALLOC;
 		return 0;
 	case Opt_sunit:
 		parsing_mp->m_dalign = result.uint_32;
@@ -1200,22 +1198,22 @@ xfs_fs_parse_param(
 		parsing_mp->m_swidth = result.uint_32;
 		return 0;
 	case Opt_inode32:
-		parsing_mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+		parsing_mp->m_features |= XFS_FEAT_SMALL_INUMS;
 		return 0;
 	case Opt_inode64:
-		parsing_mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+		parsing_mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
 		return 0;
 	case Opt_nouuid:
-		parsing_mp->m_flags |= XFS_MOUNT_NOUUID;
+		parsing_mp->m_features |= XFS_FEAT_NOUUID;
 		return 0;
 	case Opt_largeio:
-		parsing_mp->m_flags |= XFS_MOUNT_LARGEIO;
+		parsing_mp->m_features |= XFS_FEAT_LARGE_IOSIZE;
 		return 0;
 	case Opt_nolargeio:
-		parsing_mp->m_flags &= ~XFS_MOUNT_LARGEIO;
+		parsing_mp->m_features &= ~XFS_FEAT_LARGE_IOSIZE;
 		return 0;
 	case Opt_filestreams:
-		parsing_mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+		parsing_mp->m_features |= XFS_FEAT_FILESTREAMS;
 		return 0;
 	case Opt_noquota:
 		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
@@ -1252,10 +1250,10 @@ xfs_fs_parse_param(
 		parsing_mp->m_qflags &= ~XFS_GQUOTA_ENFD;
 		return 0;
 	case Opt_discard:
-		parsing_mp->m_flags |= XFS_MOUNT_DISCARD;
+		parsing_mp->m_features |= XFS_FEAT_DISCARD;
 		return 0;
 	case Opt_nodiscard:
-		parsing_mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		parsing_mp->m_features &= ~XFS_FEAT_DISCARD;
 		return 0;
 #ifdef CONFIG_FS_DAX
 	case Opt_dax:
@@ -1267,20 +1265,20 @@ xfs_fs_parse_param(
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
-		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
+		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, true);
+		parsing_mp->m_features |= XFS_FEAT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, false);
-		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, false);
+		parsing_mp->m_features &= ~XFS_FEAT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_ATTR2, true);
-		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
+		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_ATTR2, true);
+		parsing_mp->m_features |= XFS_FEAT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_NOATTR2, true);
-		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
+		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_NOATTR2, true);
+		parsing_mp->m_features |= XFS_FEAT_NOATTR2;
 		return 0;
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
@@ -1294,24 +1292,23 @@ static int
 xfs_fs_validate_params(
 	struct xfs_mount	*mp)
 {
-	/*
-	 * no recovery flag requires a read-only mount
-	 */
-	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
-	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	/* No recovery flag requires a read-only mount */
+	if (xfs_has_norecovery(mp) && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_warn(mp, "no-recovery mounts must be read-only.");
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) ==
-			  (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) {
+	/*
+	 * We have not read the superblock at this point, so only the attr2
+	 * mount option can set the attr2 feature by this stage.
+	 */
+	if (xfs_has_attr2(mp) && xfs_has_noattr2(mp)) {
 		xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
 		return -EINVAL;
 	}
 
 
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
-	    (mp->m_dalign || mp->m_swidth)) {
+	if (xfs_has_noalign(mp) && (mp->m_dalign || mp->m_swidth)) {
 		xfs_warn(mp,
 	"sunit and swidth options incompatible with the noalign option");
 		return -EINVAL;
@@ -1355,7 +1352,7 @@ xfs_fs_validate_params(
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
+	if (xfs_has_allocsize(mp) &&
 	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
 	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
 		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
@@ -1541,7 +1538,7 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
  "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
 
-	if (mp->m_flags & XFS_MOUNT_DAX_ALWAYS) {
+	if (xfs_has_dax_always(mp)) {
 		bool rtdev_is_dax = false, datadev_is_dax;
 
 		xfs_warn(mp,
@@ -1565,13 +1562,13 @@ xfs_fs_fill_super(
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
 
@@ -1654,7 +1651,7 @@ xfs_remount_rw(
 	struct xfs_sb		*sbp = &mp->m_sb;
 	int error;
 
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
+	if (xfs_has_norecovery(mp)) {
 		xfs_warn(mp,
 			"ro->rw transition prohibited on norecovery mount");
 		return -EINVAL;
@@ -1783,16 +1780,14 @@ xfs_fs_reconfigure(
 	sync_filesystem(mp->m_super);
 
 	/* inode32 -> inode64 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
-	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
-		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
+		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
 		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
 	}
 
 	/* inode64 -> inode32 */
-	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
-	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
-		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+	if (!xfs_has_small_inums(mp) && xfs_has_small_inums(new_mp)) {
+		mp->m_features |= XFS_FEAT_SMALL_INUMS;
 		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
 	}
 
@@ -1873,9 +1868,9 @@ static int xfs_init_fs_context(
 	if (fc->sb_flags & SB_RDONLY)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	if (fc->sb_flags & SB_DIRSYNC)
-		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+		mp->m_features |= XFS_FEAT_DIRSYNC;
 	if (fc->sb_flags & SB_SYNCHRONOUS)
-		mp->m_flags |= XFS_MOUNT_WSYNC;
+		mp->m_features |= XFS_FEAT_WSYNC;
 
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 707d36556bc5..701a78fbf7a9 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -321,9 +321,8 @@ xfs_symlink(
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
2.31.1

