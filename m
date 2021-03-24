Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2E3C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B056461A0C
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhCXOWk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbhCXOWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:22:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8471EC0613E1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=EnJngmMXHSfOn+s8p1RiZmrXyCzAxrq6UYiuCnvscDM=; b=4Twr/sjtWL2hVSm7eNoPxJqTdn
        VBKOh98UFS5xz7zHyTeN7/OWucjZxWhpjBE8z0QKKZVzIr8WKiO6DTAL+ZDxuWYbvbWTawu8H4pK0
        NSG+Bn0tuYEEStxgggwB0/jgSalj7d/GVkP3q9OG5OaYQlyPE+zEV+mWldlaGswbIeG6V5VNoQhoW
        nVW4IRc4xcUok/qde9ZqzcI8/Va0kBHCmt6jNNcbMrSo8VENF/tO5e6Ahw0iWqDExv6gPDh7778Tf
        I8D6+xcuEQWMFmqtPgf4AYS77JjYBLaxSnuK4KRI1+uE9VbXvwLUptLm+b1iD649BMc55h16OGf0t
        4ktn6YgA==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4Ol-0045YI-Pt
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:22:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/18] xfs: move the di_flags2 field to struct xfs_inode
Date:   Wed, 24 Mar 2021 15:21:28 +0100
Message-Id: <20210324142129.1011766-18-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the flags2
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h   |  2 --
 fs/xfs/libxfs/xfs_trans_inode.c |  2 +-
 fs/xfs/xfs_bmap_util.c          | 24 ++++++++++++------------
 fs/xfs/xfs_file.c               |  4 ++--
 fs/xfs/xfs_icache.c             |  2 +-
 fs/xfs/xfs_inode.c              | 20 +++++++++-----------
 fs/xfs/xfs_inode.h              |  5 +++--
 fs/xfs/xfs_inode_item.c         |  2 +-
 fs/xfs/xfs_ioctl.c              | 24 ++++++++++++------------
 fs/xfs/xfs_iops.c               |  2 +-
 fs/xfs/xfs_itable.c             |  2 +-
 fs/xfs/xfs_reflink.c            |  8 ++++----
 13 files changed, 49 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d600a33a4bffac..f3df60e3452e1e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -240,7 +240,7 @@ xfs_inode_from_disk(
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
 		to->di_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
-		to->di_flags2 = be64_to_cpu(from->di_flags2);
+		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
 		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 
@@ -319,7 +319,7 @@ xfs_inode_to_disk(
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
-		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
 		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index cfad369e735040..2f6015acfda81b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,8 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	uint64_t	di_flags2;	/* more random flags */
-
 	struct timespec64 di_crtime;	/* time created */
 };
 
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 4f02cb439ab57e..102920303454df 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -138,7 +138,7 @@ xfs_trans_log_inode(
 	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
 	    xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
 	    !xfs_inode_has_bigtime(ip)) {
-		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
+		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
 		flags |= XFS_ILOG_CORE;
 	}
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9c4b89f3844ecf..2b9991e5ea4719 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1323,9 +1323,9 @@ xfs_swap_extent_rmap(
 	 * rmap functions when we go to fix up the rmaps.  The flags
 	 * will be switch for reals later.
 	 */
-	tip_flags2 = tip->i_d.di_flags2;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)
-		tip->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+	tip_flags2 = tip->i_diflags2;
+	if (ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
+		tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 
 	offset_fsb = 0;
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
@@ -1412,12 +1412,12 @@ xfs_swap_extent_rmap(
 		offset_fsb += ilen;
 	}
 
-	tip->i_d.di_flags2 = tip_flags2;
+	tip->i_diflags2 = tip_flags2;
 	return 0;
 
 out:
 	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
-	tip->i_d.di_flags2 = tip_flags2;
+	tip->i_diflags2 = tip_flags2;
 	return error;
 }
 
@@ -1715,13 +1715,13 @@ xfs_swap_extents(
 		goto out_trans_cancel;
 
 	/* Do we have to swap reflink flags? */
-	if ((ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK) ^
-	    (tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)) {
-		f = ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
-		ip->i_d.di_flags2 |= tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
-		tip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
-		tip->i_d.di_flags2 |= f & XFS_DIFLAG2_REFLINK;
+	if ((ip->i_diflags2 & XFS_DIFLAG2_REFLINK) ^
+	    (tip->i_diflags2 & XFS_DIFLAG2_REFLINK)) {
+		f = ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 |= tip->i_diflags2 & XFS_DIFLAG2_REFLINK;
+		tip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		tip->i_diflags2 |= f & XFS_DIFLAG2_REFLINK;
 	}
 
 	/* Swap the cow forks. */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ffbf94515e11a2..396ef36dcd0a10 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1159,9 +1159,9 @@ xfs_file_remap_range(
 	 */
 	cowextsize = 0;
 	if (pos_in == 0 && len == i_size_read(inode_in) &&
-	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    (src->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
 	    pos_out == 0 && len >= i_size_read(inode_out) &&
-	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
+	    !(dest->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
 		cowextsize = src->i_cowextsize;
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3f856a4af428c6..5987b2b1ec0105 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -63,7 +63,7 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
-	ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
+	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_nblocks = 0;
 	ip->i_forkoff = 0;
 	ip->i_sick = 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 48292851f6dc0c..28d57353bdfa57 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -80,7 +80,7 @@ xfs_get_cowextsz_hint(
 	xfs_extlen_t		a, b;
 
 	a = 0;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
 	b = xfs_get_extsz_hint(ip);
 
@@ -654,9 +654,7 @@ uint
 xfs_ip2xflags(
 	struct xfs_inode	*ip)
 {
-	struct xfs_icdinode	*dic = &ip->i_d;
-
-	return _xfs_dic2xflags(ip->i_diflags, dic->di_flags2, XFS_IFORK_Q(ip));
+	return _xfs_dic2xflags(ip->i_diflags, ip->i_diflags2, XFS_IFORK_Q(ip));
 }
 
 /*
@@ -752,12 +750,12 @@ xfs_inode_inherit_flags2(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
-	if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-		ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
 		ip->i_cowextsize = pip->i_cowextsize;
 	}
-	if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-		ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
+	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
+		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
 }
 
 /*
@@ -861,7 +859,7 @@ xfs_init_new_inode(
 	case S_IFDIR:
 		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
 			xfs_inode_inherit_flags(ip, pip);
-		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY))
+		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
 			xfs_inode_inherit_flags2(ip, pip);
 		/* FALLTHROUGH */
 	case S_IFLNK:
@@ -1326,7 +1324,7 @@ xfs_itruncate_clear_reflink_flags(
 	dfork = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	cfork = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	if (dfork->if_bytes == 0 && cfork->if_bytes == 0)
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	if (cfork->if_bytes == 0)
 		xfs_inode_clear_cowblocks_tag(ip);
 }
@@ -2588,7 +2586,7 @@ xfs_ifree(
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_diflags = 0;
-	ip->i_d.di_flags2 = ip->i_mount->m_ino_geo.new_diflags2;
+	ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
 	ip->i_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 	if (xfs_iflags_test(ip, XFS_IDMAPI))
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8ee4c9ab15f1a8..8fb87d3d98d174 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -65,6 +65,7 @@ typedef struct xfs_inode {
 	};
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
+	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
@@ -193,7 +194,7 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 
 static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 {
-	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
+	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
 
 /*
@@ -207,7 +208,7 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
 
 static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 {
-	return ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME;
+	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index dc31976d631d83..912c453b6fe46d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -387,7 +387,7 @@ xfs_inode_to_log_dinode(
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, from->di_crtime);
-		to->di_flags2 = from->di_flags2;
+		to->di_flags2 = ip->i_diflags2;
 		to->di_cowextsize = ip->i_cowextsize;
 		to->di_ino = ip->i_ino;
 		to->di_lsn = lsn;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f355b9d39a592f..3aede3b69ac9a5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1123,7 +1123,7 @@ xfs_fill_fsxattr(
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
 	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
 	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
-	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
+	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
 		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
 	fa->fsx_projid = ip->i_projid;
 	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
@@ -1197,8 +1197,8 @@ xfs_flags2diflags2(
 	unsigned int		xflags)
 {
 	uint64_t		di_flags2 =
-		(ip->i_d.di_flags2 & (XFS_DIFLAG2_REFLINK |
-				      XFS_DIFLAG2_BIGTIME));
+		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
+				   XFS_DIFLAG2_BIGTIME));
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
@@ -1215,7 +1215,7 @@ xfs_ioctl_setattr_xflags(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		di_flags2;
+	uint64_t		i_flags2;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
@@ -1231,19 +1231,19 @@ xfs_ioctl_setattr_xflags(
 
 	/* Clear reflink if we are actually able to set the rt flag. */
 	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 
 	/* Don't allow us to set DAX mode for a reflinked file for now. */
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
 		return -EINVAL;
 
 	/* diflags2 only valid for v3 inodes. */
-	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
+	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
+	if (i_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
 		return -EINVAL;
 
 	ip->i_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
-	ip->i_d.di_flags2 = di_flags2;
+	ip->i_diflags2 = i_flags2;
 
 	xfs_diflags_to_iflags(ip, false);
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
@@ -1268,9 +1268,9 @@ xfs_ioctl_setattr_prepare_dax(
 		return;
 
 	if (((fa->fsx_xflags & FS_XFLAG_DAX) &&
-	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_DAX)) ||
+	    !(ip->i_diflags2 & XFS_DIFLAG2_DAX)) ||
 	    (!(fa->fsx_xflags & FS_XFLAG_DAX) &&
-	     (ip->i_d.di_flags2 & XFS_DIFLAG2_DAX)))
+	     (ip->i_diflags2 & XFS_DIFLAG2_DAX)))
 		d_mark_dontcache(inode);
 }
 
@@ -1525,7 +1525,7 @@ xfs_ioctl_setattr(
 	else
 		ip->i_extsize = 0;
 	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
-	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
+	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
 		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
 	else
 		ip->i_cowextsize = 0;
@@ -1573,7 +1573,7 @@ xfs_ioc_getxflags(
 {
 	unsigned int		flags;
 
-	flags = xfs_di2lxflags(ip->i_diflags, ip->i_d.di_flags2);
+	flags = xfs_di2lxflags(ip->i_diflags, ip->i_diflags2);
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
 	return 0;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 886593c02845c7..df958611e854af 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1254,7 +1254,7 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (ip->i_mount->m_flags & XFS_MOUNT_DAX_ALWAYS)
 		return true;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
 		return true;
 	return false;
 }
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 43f8a89c9786c7..1f33f13d33a901 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -113,7 +113,7 @@ xfs_bulkstat_one_int(
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		buf->bs_btime = dic->di_crtime.tv_sec;
 		buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
-		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			buf->bs_cowextsize_blks = ip->i_cowextsize;
 	}
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d8735b3ee0f807..323506a6b33947 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -874,7 +874,7 @@ xfs_reflink_set_inode_flag(
 	if (!xfs_is_reflink_inode(src)) {
 		trace_xfs_reflink_set_inode_flag(src);
 		xfs_trans_ijoin(tp, src, XFS_ILOCK_EXCL);
-		src->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+		src->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 		xfs_trans_log_inode(tp, src, XFS_ILOG_CORE);
 		xfs_ifork_init_cow(src);
 	} else
@@ -886,7 +886,7 @@ xfs_reflink_set_inode_flag(
 	if (!xfs_is_reflink_inode(dest)) {
 		trace_xfs_reflink_set_inode_flag(dest);
 		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
-		dest->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+		dest->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 		xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 		xfs_ifork_init_cow(dest);
 	} else
@@ -935,7 +935,7 @@ xfs_reflink_update_dest(
 
 	if (cowextsize) {
 		dest->i_cowextsize = cowextsize;
-		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		dest->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
 	}
 
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
@@ -1455,7 +1455,7 @@ xfs_reflink_clear_inode_flag(
 
 	/* Clear the inode flag. */
 	trace_xfs_reflink_unset_inode_flag(ip);
-	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	xfs_inode_clear_cowblocks_tag(ip);
 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
 
-- 
2.30.1

