Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5363CC433E1
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D1A62076C
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EFYCRfHs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgEXJSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgEXJSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6875BC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=j0HCO0xo/zVmu4/FfgRB7pTN8O366L9ZKW2dImKKPCc=; b=EFYCRfHsLvSYYqojCamt3r59z/
        qeUH+a2cshhWzQVk48n+rUp+X6xjMtID6cd5KoGYjeTcJkpGerMrs1SlfY5oJajTzanmTz+bRgZ4g
        X+ZuuFIMvjojfjyAr652crSe2PhKoiAzwse/daV14/YCWIvyB7qiKi/mUPebJqhJEp2pxn0hyUMar
        kUPLOwCBZ65maDQKWZIAd4f5RmXgeToMeaMAKFUxweGakDPX9fZv5mTZBmA+QhXg/nWmVOkSmtQeb
        iYV9aRkq5sN+IMzeyfTQFKSTKwZnDAO+ZjWahhJxBZofBGLvHO1fyd2lpAUuqkvM7ZeGw6K7j4X/4
        kg0oqeFA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmm6-0004te-QC
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/14] xfs: move the di_flags2 field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:54 +0200
Message-Id: <20200524091757.128995-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524091757.128995-1-hch@lst.de>
References: <20200524091757.128995-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the flags2
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h |  2 --
 fs/xfs/xfs_bmap_util.c        | 24 ++++++++++++------------
 fs/xfs/xfs_file.c             |  4 ++--
 fs/xfs/xfs_inode.c            | 22 ++++++++++------------
 fs/xfs/xfs_inode.h            |  3 ++-
 fs/xfs/xfs_inode_item.c       |  2 +-
 fs/xfs/xfs_ioctl.c            | 23 +++++++++++------------
 fs/xfs/xfs_iops.c             |  2 +-
 fs/xfs/xfs_itable.c           |  2 +-
 fs/xfs/xfs_reflink.c          |  8 ++++----
 11 files changed, 46 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index bb9c4775ecaa5..79e470933abfa 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -255,7 +255,7 @@ xfs_inode_from_disk(
 					   be64_to_cpu(from->di_changecount));
 		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
-		to->di_flags2 = be64_to_cpu(from->di_flags2);
+		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
 		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 
@@ -321,7 +321,7 @@ xfs_inode_to_disk(
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
-		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
 		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 5c6a6ac521b11..4bfad6d6d5710 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -19,8 +19,6 @@ struct xfs_icdinode {
 	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
 
-	uint64_t	di_flags2;	/* more random flags */
-
 	struct timespec64 di_crtime;	/* time created */
 };
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0b944aad75e61..8f85a4131983a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1332,9 +1332,9 @@ xfs_swap_extent_rmap(
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
@@ -1405,12 +1405,12 @@ xfs_swap_extent_rmap(
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
 
@@ -1708,13 +1708,13 @@ xfs_swap_extents(
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
index 4f08793f3d6db..193352df48f6b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1052,9 +1052,9 @@ xfs_file_remap_range(
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 347497daa420d..4a98c7d46a302 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -81,7 +81,7 @@ xfs_get_cowextsz_hint(
 	xfs_extlen_t		a, b;
 
 	a = 0;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
 	b = xfs_get_extsz_hint(ip);
 
@@ -671,9 +671,7 @@ uint
 xfs_ip2xflags(
 	struct xfs_inode	*ip)
 {
-	struct xfs_icdinode	*dic = &ip->i_d;
-
-	return _xfs_dic2xflags(ip->i_diflags, dic->di_flags2, XFS_IFORK_Q(ip));
+	return _xfs_dic2xflags(ip->i_diflags, ip->i_diflags2, XFS_IFORK_Q(ip));
 }
 
 /*
@@ -841,7 +839,7 @@ xfs_ialloc(
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
-		ip->i_d.di_flags2 = 0;
+		ip->i_diflags2 = 0;
 		ip->i_cowextsize = 0;
 		ip->i_d.di_crtime = tv;
 	}
@@ -898,13 +896,13 @@ xfs_ialloc(
 
 			ip->i_diflags |= di_flags;
 		}
-		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY)) {
+			if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+				ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
 				ip->i_cowextsize = pip->i_cowextsize;
 			}
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
+			if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
+				ip->i_diflags2 |= XFS_DIFLAG2_DAX;
 		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
@@ -1456,7 +1454,7 @@ xfs_itruncate_clear_reflink_flags(
 	dfork = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	cfork = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	if (dfork->if_bytes == 0 && cfork->if_bytes == 0)
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	if (cfork->if_bytes == 0)
 		xfs_inode_clear_cowblocks_tag(ip);
 }
@@ -2754,7 +2752,7 @@ xfs_ifree(
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_diflags = 0;
-	ip->i_d.di_flags2 = 0;
+	ip->i_diflags2 = 0;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 6540c928c187d..c3ff0f2536dd8 100644
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
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6af8e829dd017..04e671d2957ca 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -342,7 +342,7 @@ xfs_inode_to_log_dinode(
 		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime.t_sec = from->di_crtime.tv_sec;
 		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
-		to->di_flags2 = from->di_flags2;
+		to->di_flags2 = ip->i_diflags2;
 		to->di_cowextsize = ip->i_cowextsize;
 		to->di_ino = ip->i_ino;
 		to->di_lsn = lsn;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 435a6915f53c2..592eebd4d49e9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1109,7 +1109,7 @@ xfs_fill_fsxattr(
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
 	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
-	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
+	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)) {
 		fa->fsx_cowextsize =
 			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
 	}
@@ -1184,15 +1184,14 @@ xfs_flags2diflags2(
 	struct xfs_inode	*ip,
 	unsigned int		xflags)
 {
-	uint64_t		di_flags2 =
-		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
+	uint64_t		i_flags2 = (ip->i_diflags2 & XFS_DIFLAG2_REFLINK);
 
 	if (xflags & FS_XFLAG_DAX)
-		di_flags2 |= XFS_DIFLAG2_DAX;
+		i_flags2 |= XFS_DIFLAG2_DAX;
 	if (xflags & FS_XFLAG_COWEXTSIZE)
-		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		i_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 
-	return di_flags2;
+	return i_flags2;
 }
 
 static int
@@ -1202,7 +1201,7 @@ xfs_ioctl_setattr_xflags(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		di_flags2;
+	uint64_t		i_flags2;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
@@ -1218,19 +1217,19 @@ xfs_ioctl_setattr_xflags(
 
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
@@ -1576,7 +1575,7 @@ xfs_ioctl_setattr(
 	else
 		ip->i_extsize = 0;
 	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
-	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
+	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
 		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
 	else
 		ip->i_cowextsize = 0;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f37154fc9828f..3642f9935cae3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1265,7 +1265,7 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (ip->i_mount->m_flags & XFS_MOUNT_DAX_ALWAYS)
 		return true;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
 		return true;
 	return false;
 }
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7937af9f2ea77..4d1509437c357 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -111,7 +111,7 @@ xfs_bulkstat_one_int(
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
-		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			buf->bs_cowextsize_blks = ip->i_cowextsize;
 	}
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0e07fa7e43117..476ba54d84a9a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -882,7 +882,7 @@ xfs_reflink_set_inode_flag(
 	if (!xfs_is_reflink_inode(src)) {
 		trace_xfs_reflink_set_inode_flag(src);
 		xfs_trans_ijoin(tp, src, XFS_ILOCK_EXCL);
-		src->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+		src->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 		xfs_trans_log_inode(tp, src, XFS_ILOG_CORE);
 		xfs_ifork_init_cow(src);
 	} else
@@ -894,7 +894,7 @@ xfs_reflink_set_inode_flag(
 	if (!xfs_is_reflink_inode(dest)) {
 		trace_xfs_reflink_set_inode_flag(dest);
 		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
-		dest->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+		dest->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 		xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 		xfs_ifork_init_cow(dest);
 	} else
@@ -943,7 +943,7 @@ xfs_reflink_update_dest(
 
 	if (cowextsize) {
 		dest->i_cowextsize = cowextsize;
-		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		dest->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
 	}
 
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
@@ -1463,7 +1463,7 @@ xfs_reflink_clear_inode_flag(
 
 	/* Clear the inode flag. */
 	trace_xfs_reflink_unset_inode_flag(ip);
-	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	xfs_inode_clear_cowblocks_tag(ip);
 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
 
-- 
2.26.2

