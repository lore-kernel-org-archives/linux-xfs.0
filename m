Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D9CC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 517C7207D8
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CjAAy6rO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbgEXJSP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgEXJSO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0F7C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=nhf6WmQAfypVxQGNfW6Llb1A+oZARNmaHikMU0Hvs+Q=; b=CjAAy6rOa5bFzKRoT90aeKx6d/
        cNlwvLcalOiCHkH/SoZanWhW7ZBUxkI342MrAUFMJWh/qa/muUDg4dSqfF1E1fDmbVHN5tmE8F4WD
        jch/m46vQ06rjaMi28F0FQU9h8RaScQrQJH3t0cndVaCh8cim+49IlWUMfJC+h/kU3ittNjxpRED7
        Ml4Zsvb8RH9tcAEr97FKhoBHUgFtVW5qqwX5rkuPKYES6aFlyjS/GemZSRocxjByFkIL5YkQWQBhv
        WZmAs3U0uzFnR/fO2rZy2pSfBkq1sRRIRWpdOodZaIcsxX1XUkUSLERZrkWdKHV0V4WOYRrp9Yonk
        17bcbSZw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmlq-0004rN-0U
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/14] xfs: move the di_extsize field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:48 +0200
Message-Id: <20200524091757.128995-6-hch@lst.de>
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

In preparation of removing the historic icinode struct, move the extsize
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c      |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h |  1 -
 fs/xfs/xfs_inode.c            | 10 +++++-----
 fs/xfs/xfs_inode.h            |  1 +
 fs/xfs/xfs_inode_item.c       |  2 +-
 fs/xfs/xfs_ioctl.c            | 10 +++++-----
 fs/xfs/xfs_itable.c           |  2 +-
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9af2c51a450ed..4c7d3f84ca3ff 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2942,7 +2942,7 @@ xfs_bmap_add_extent_hole_real(
  */
 
 /*
- * Adjust the size of the new extent based on di_extsize and rt extsize.
+ * Adjust the size of the new extent based on i_extsize and rt extsize.
  */
 int
 xfs_bmap_extsize_align(
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d1a15778e86a3..e51b15c44bb3e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -243,7 +243,7 @@ xfs_inode_from_disk(
 
 	ip->i_disk_size = be64_to_cpu(from->di_size);
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
-	to->di_extsize = be32_to_cpu(from->di_extsize);
+	ip->i_extsize = be32_to_cpu(from->di_extsize);
 	to->di_forkoff = from->di_forkoff;
 	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
@@ -306,7 +306,7 @@ xfs_inode_to_disk(
 
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
-	to->di_extsize = cpu_to_be32(from->di_extsize);
+	to->di_extsize = cpu_to_be32(ip->i_extsize);
 	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = from->di_forkoff;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index a322e1adf0a34..d420ea835c839 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,6 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f893d732cc89a..777dadc3fd531 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -61,8 +61,8 @@ xfs_get_extsz_hint(
 	 */
 	if (xfs_is_always_cow_inode(ip))
 		return 0;
-	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
-		return ip->i_d.di_extsize;
+	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+		return ip->i_extsize;
 	if (XFS_IS_REALTIME_INODE(ip))
 		return ip->i_mount->m_sb.sb_rextsize;
 	return 0;
@@ -834,7 +834,7 @@ xfs_ialloc(
 	inode->i_atime = tv;
 	inode->i_ctime = tv;
 
-	ip->i_d.di_extsize = 0;
+	ip->i_extsize = 0;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
 	ip->i_d.di_flags = 0;
@@ -866,7 +866,7 @@ xfs_ialloc(
 					di_flags |= XFS_DIFLAG_RTINHERIT;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
+					ip->i_extsize = pip->i_extsize;
 				}
 				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 					di_flags |= XFS_DIFLAG_PROJINHERIT;
@@ -875,7 +875,7 @@ xfs_ialloc(
 					di_flags |= XFS_DIFLAG_REALTIME;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSIZE;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
+					ip->i_extsize = pip->i_extsize;
 				}
 			}
 			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 828f49f109475..af90c6f745549 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -57,6 +57,7 @@ typedef struct xfs_inode {
 	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	uint32_t		i_projid;	/* owner's project id */
+	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0980fa43472cf..8b8c99809f273 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -325,7 +325,7 @@ xfs_inode_to_log_dinode(
 
 	to->di_size = ip->i_disk_size;
 	to->di_nblocks = ip->i_nblocks;
-	to->di_extsize = from->di_extsize;
+	to->di_extsize = ip->i_extsize;
 	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = from->di_forkoff;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9abc65dd20e9d..aeb1de3aec60f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1107,7 +1107,7 @@ xfs_fill_fsxattr(
 	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
 
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
-	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
+	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
 			ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_projid = ip->i_projid;
@@ -1209,7 +1209,7 @@ xfs_ioctl_setattr_xflags(
 	/* If realtime flag is set then must have realtime device */
 	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
-		    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize))
+		    (ip->i_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
 	}
 
@@ -1381,7 +1381,7 @@ xfs_ioctl_setattr_check_extsize(
 	xfs_fsblock_t		extsize_fsb;
 
 	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
-	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
+	    ((ip->i_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
 		return -EINVAL;
 
 	if (fa->fsx_extsize == 0)
@@ -1569,9 +1569,9 @@ xfs_ioctl_setattr(
 	 * are set on the inode then unconditionally clear the extent size hint.
 	 */
 	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
-		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
+		ip->i_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	else
-		ip->i_d.di_extsize = 0;
+		ip->i_extsize = 0;
 	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
 		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7af144500bbfd..b0f0c19fd7822 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -103,7 +103,7 @@ xfs_bulkstat_one_int(
 	buf->bs_mode = inode->i_mode;
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
-	buf->bs_extsize_blks = dic->di_extsize;
+	buf->bs_extsize_blks = ip->i_extsize;
 	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
-- 
2.26.2

