Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E542C433E5
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E3461981
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhC2Fk3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhC2FkU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:40:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8E8C0613D9
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cqAuX2xdUJxN4DeEdsVutvCyMfH3TQz1ZVbnzGMeYnQ=; b=NSY0N4cxPSFFARumc/sCRl2k7L
        H5O5UmexEObNU4BMOAcFBzPX0uQf6pWgTSd0GPgDmTdKzHaTO7bEolgHCsIb8828ZRBU7fbaYTN6X
        dHPr1rzqUTnwmCIubitFTvqUPxGtpqkBBGoW2lonfMmKUr0eKXp9BvibgWO+luTQJhBDNPuGCE2jY
        8hSxGgufwi0MOYW8QXy/JJj3V6wVC+fKnwPOjoTkk8YT5nosl3AvsDoea3+0qnc8EtxN7UjYzuS25
        J2JfgJaSPuxxj9WPkFEVpmWwD9H1ykgk6LxGn0h/sHVTZcZ8NYFddmu4Ae0Lx37ba3looFB2iMfuT
        e5FXvHhw==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkcK-006oQC-FI; Mon, 29 Mar 2021 05:39:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 17/20] xfs: move the di_flags field to struct xfs_inode
Date:   Mon, 29 Mar 2021 07:38:26 +0200
Message-Id: <20210329053829.1851318-18-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the flags
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h  |  2 --
 fs/xfs/libxfs/xfs_rtbitmap.c   |  4 ++--
 fs/xfs/scrub/common.c          |  2 +-
 fs/xfs/xfs_bmap_util.c         |  4 ++--
 fs/xfs/xfs_file.c              |  4 ++--
 fs/xfs/xfs_filestream.h        |  2 +-
 fs/xfs/xfs_inode.c             | 38 +++++++++++++++++-----------------
 fs/xfs/xfs_inode.h             |  3 ++-
 fs/xfs/xfs_inode_item.c        |  2 +-
 fs/xfs/xfs_ioctl.c             |  8 +++----
 fs/xfs/xfs_iops.c              |  6 +++---
 fs/xfs/xfs_linux.h             |  2 +-
 fs/xfs/xfs_rtalloc.c           |  4 ++--
 fs/xfs/xfs_super.c             |  4 ++--
 fs/xfs/xfs_symlink.c           |  2 +-
 17 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 520db0c8f10a2d..1ceba020940e83 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -183,7 +183,7 @@ xfs_bmbt_update_cursor(
 	struct xfs_btree_cur	*dst)
 {
 	ASSERT((dst->bc_tp->t_firstblock != NULLFSBLOCK) ||
-	       (dst->bc_ino.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
+	       (dst->bc_ino.ip->i_diflags & XFS_DIFLAG_REALTIME));
 
 	dst->bc_ino.allocated += src->bc_ino.allocated;
 	dst->bc_tp->t_firstblock = src->bc_tp->t_firstblock;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index df16b05e60c462..6c81474a94a51f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -231,7 +231,7 @@ xfs_inode_from_disk(
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
 	ip->i_extsize = be32_to_cpu(from->di_extsize);
 	ip->i_forkoff = from->di_forkoff;
-	to->di_flags	= be16_to_cpu(from->di_flags);
+	ip->i_diflags	= be16_to_cpu(from->di_flags);
 
 	if (from->di_dmevmask || from->di_dmstate)
 		xfs_iflags_set(ip, XFS_IPRESERVE_DM_FIELDS);
@@ -313,7 +313,7 @@ xfs_inode_to_disk(
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
-	to->di_flags = cpu_to_be16(from->di_flags);
+	to->di_flags = cpu_to_be16(ip->i_diflags);
 
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 39f4ad4419fe41..cfad369e735040 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,8 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
-
 	uint64_t	di_flags2;	/* more random flags */
 
 	struct timespec64 di_crtime;	/* time created */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index fe3a49575ff3c0..483375c6a735ac 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -997,8 +997,8 @@ xfs_rtfree_extent(
 	 */
 	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
 	    mp->m_sb.sb_rextents) {
-		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
-			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+		if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
+			mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 		*(uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index da60e7d1f895be..d8da0ea772bc4c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -818,7 +818,7 @@ xchk_metadata_inode_forks(
 		return 0;
 
 	/* Metadata inodes don't live on the rt device. */
-	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
+	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME) {
 		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		return 0;
 	}
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ce1a32df01210e..9c4b89f3844ecf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -439,7 +439,7 @@ xfs_getbmap(
 		}
 
 		if (xfs_get_extsz_hint(ip) ||
-		    (ip->i_d.di_flags &
+		    (ip->i_diflags &
 		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
 			max_len = mp->m_super->s_maxbytes;
 		else
@@ -620,7 +620,7 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
 	 * Do not free real preallocated or append-only files unless the file
 	 * has delalloc blocks and we are forced to remove them.
 	 */
-	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
 		if (!force || ip->i_delayed_blks == 0)
 			return false;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d755fbf3640bee..ffbf94515e11a2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -90,9 +90,9 @@ xfs_update_prealloc_flags(
 	}
 
 	if (flags & XFS_PREALLOC_SET)
-		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
 	if (flags & XFS_PREALLOC_CLEAR)
-		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
+		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	if (flags & XFS_PREALLOC_SYNC)
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 5cc7665e93c92b..3af963743e4d0b 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -22,7 +22,7 @@ xfs_inode_is_filestream(
 	struct xfs_inode	*ip)
 {
 	return (ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
-		(ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM);
+		(ip->i_diflags & XFS_DIFLAG_FILESTREAM);
 }
 
 #endif /* __XFS_FILESTREAM_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3e53235bea2ac2..97044b5b957823 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -60,7 +60,7 @@ xfs_get_extsz_hint(
 	 */
 	if (xfs_is_always_cow_inode(ip))
 		return 0;
-	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
 		return ip->i_extsize;
 	if (XFS_IS_REALTIME_INODE(ip))
 		return ip->i_mount->m_sb.sb_rextsize;
@@ -656,7 +656,7 @@ xfs_ip2xflags(
 {
 	struct xfs_icdinode	*dic = &ip->i_d;
 
-	return _xfs_dic2xflags(dic->di_flags, dic->di_flags2, XFS_IFORK_Q(ip));
+	return _xfs_dic2xflags(ip->i_diflags, dic->di_flags2, XFS_IFORK_Q(ip));
 }
 
 /*
@@ -708,42 +708,42 @@ xfs_inode_inherit_flags(
 	umode_t			mode = VFS_I(ip)->i_mode;
 
 	if (S_ISDIR(mode)) {
-		if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
 			di_flags |= XFS_DIFLAG_RTINHERIT;
-		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
 			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
 			ip->i_extsize = pip->i_extsize;
 		}
-		if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
 			di_flags |= XFS_DIFLAG_PROJINHERIT;
 	} else if (S_ISREG(mode)) {
-		if ((pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) &&
+		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 		    xfs_sb_version_hasrealtime(&ip->i_mount->m_sb))
 			di_flags |= XFS_DIFLAG_REALTIME;
-		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
 			di_flags |= XFS_DIFLAG_EXTSIZE;
 			ip->i_extsize = pip->i_extsize;
 		}
 	}
-	if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
+	if ((pip->i_diflags & XFS_DIFLAG_NOATIME) &&
 	    xfs_inherit_noatime)
 		di_flags |= XFS_DIFLAG_NOATIME;
-	if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
+	if ((pip->i_diflags & XFS_DIFLAG_NODUMP) &&
 	    xfs_inherit_nodump)
 		di_flags |= XFS_DIFLAG_NODUMP;
-	if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
+	if ((pip->i_diflags & XFS_DIFLAG_SYNC) &&
 	    xfs_inherit_sync)
 		di_flags |= XFS_DIFLAG_SYNC;
-	if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
+	if ((pip->i_diflags & XFS_DIFLAG_NOSYMLINKS) &&
 	    xfs_inherit_nosymlinks)
 		di_flags |= XFS_DIFLAG_NOSYMLINKS;
-	if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
+	if ((pip->i_diflags & XFS_DIFLAG_NODEFRAG) &&
 	    xfs_inherit_nodefrag)
 		di_flags |= XFS_DIFLAG_NODEFRAG;
-	if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
+	if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
 		di_flags |= XFS_DIFLAG_FILESTREAM;
 
-	ip->i_d.di_flags |= di_flags;
+	ip->i_diflags |= di_flags;
 }
 
 /* Propagate di_flags2 from a parent inode to a child inode. */
@@ -840,7 +840,7 @@ xfs_init_new_inode(
 	inode->i_ctime = tv;
 
 	ip->i_extsize = 0;
-	ip->i_d.di_flags = 0;
+	ip->i_diflags = 0;
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
@@ -860,7 +860,7 @@ xfs_init_new_inode(
 		break;
 	case S_IFREG:
 	case S_IFDIR:
-		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY))
+		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
 			xfs_inode_inherit_flags(ip, pip);
 		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY))
 			xfs_inode_inherit_flags2(ip, pip);
@@ -1287,7 +1287,7 @@ xfs_link(
 	 * creation in our tree when the project IDs are the same; else
 	 * the tree quota mechanism could be circumvented.
 	 */
-	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     tdp->i_projid != sip->i_projid)) {
 		error = -EXDEV;
 		goto error_return;
@@ -2611,7 +2611,7 @@ xfs_ifree(
 	}
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
-	ip->i_d.di_flags = 0;
+	ip->i_diflags = 0;
 	ip->i_d.di_flags2 = ip->i_mount->m_ino_geo.new_diflags2;
 	ip->i_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
@@ -3125,7 +3125,7 @@ xfs_rename(
 	 * into our tree when the project IDs are the same; else the
 	 * tree quota mechanism would be circumvented.
 	 */
-	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     target_dp->i_projid != src_ip->i_projid)) {
 		error = -EXDEV;
 		goto out_trans_cancel;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ae7c846e7874ad..5bbc02922c6c06 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -64,6 +64,7 @@ typedef struct xfs_inode {
 		uint16_t	i_flushiter;	/* incremented on flush */
 	};
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
+	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
@@ -184,7 +185,7 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 static inline prid_t
 xfs_get_initial_prid(struct xfs_inode *dp)
 {
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
 		return dp->i_projid;
 
 	return XFS_PROJID_DEFAULT;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 65d05f67b1d5cd..c001166139d406 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -376,7 +376,7 @@ xfs_inode_to_log_dinode(
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
-	to->di_flags = from->di_flags;
+	to->di_flags = ip->i_diflags;
 
 	xfs_copy_dm_fields_to_log_dinode(ip, to);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2028a4aa2bb20a..cf54cf58e2dbeb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1156,7 +1156,7 @@ xfs_flags2diflags(
 {
 	/* can't set PREALLOC this way, just preserve it */
 	uint16_t		di_flags =
-		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+		(ip->i_diflags & XFS_DIFLAG_PREALLOC);
 
 	if (xflags & FS_XFLAG_IMMUTABLE)
 		di_flags |= XFS_DIFLAG_IMMUTABLE;
@@ -1242,7 +1242,7 @@ xfs_ioctl_setattr_xflags(
 	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
 		return -EINVAL;
 
-	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
+	ip->i_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
 	ip->i_d.di_flags2 = di_flags2;
 
 	xfs_diflags_to_iflags(ip, false);
@@ -1520,7 +1520,7 @@ xfs_ioctl_setattr(
 	 * extent size hint should be set on the inode. If no extent size flags
 	 * are set on the inode then unconditionally clear the extent size hint.
 	 */
-	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
+	if (ip->i_diflags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
 		ip->i_extsize = XFS_B_TO_FSB(mp, fa->fsx_extsize);
 	else
 		ip->i_extsize = 0;
@@ -1575,7 +1575,7 @@ xfs_ioc_getxflags(
 {
 	unsigned int		flags;
 
-	flags = xfs_di2lxflags(ip->i_d.di_flags, ip->i_d.di_flags2);
+	flags = xfs_di2lxflags(ip->i_diflags, ip->i_d.di_flags2);
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
 	return 0;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 5f093b7261b408..07fcf0fdbbf762 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -607,11 +607,11 @@ xfs_vn_getattr(
 	 * Note: If you add another clause to set an attribute flag, please
 	 * update attributes_mask below.
 	 */
-	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
+	if (ip->i_diflags & XFS_DIFLAG_IMMUTABLE)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
-	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
+	if (ip->i_diflags & XFS_DIFLAG_APPEND)
 		stat->attributes |= STATX_ATTR_APPEND;
-	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
+	if (ip->i_diflags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
 
 	stat->attributes_mask |= (STATX_ATTR_IMMUTABLE |
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index af6be9b9ccdf81..7688663b977356 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -233,7 +233,7 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
  * configured realtime device.
  */
 #define XFS_IS_REALTIME_INODE(ip)			\
-	(((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME) &&	\
+	(((ip)->i_diflags & XFS_DIFLAG_REALTIME) &&	\
 	 (ip)->i_mount->m_rtdev_targp)
 #define XFS_IS_REALTIME_MOUNT(mp) ((mp)->m_rtdev_targp ? 1 : 0)
 #else
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4fa0aed0774410..4e7be6b4ca8e85 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1318,8 +1318,8 @@ xfs_rtpick_extent(
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
 	seqp = (uint64_t *)&VFS_I(mp->m_rbmip)->i_atime;
-	if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM)) {
-		mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+	if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM)) {
+		mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 		*seqp = 0;
 	}
 	seq = *seqp;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8d079c5e70997c..a2dab05332ac27 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -834,13 +834,13 @@ xfs_fs_statfs(
 	statp->f_ffree = max_t(int64_t, ffree, 0);
 
 
-	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
 			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);
 
 	if (XFS_IS_REALTIME_MOUNT(mp) &&
-	    (ip->i_d.di_flags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
+	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
 		statp->f_blocks = sbp->sb_rblocks;
 		statp->f_bavail = statp->f_bfree =
 			sbp->sb_frextents * sbp->sb_rextsize;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 194f52b3abb16d..1a625920ddff94 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -210,7 +210,7 @@ xfs_symlink(
 	/*
 	 * Check whether the directory allows new symlinks or not.
 	 */
-	if (dp->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) {
+	if (dp->i_diflags & XFS_DIFLAG_NOSYMLINKS) {
 		error = -EPERM;
 		goto out_trans_cancel;
 	}
-- 
2.30.1

