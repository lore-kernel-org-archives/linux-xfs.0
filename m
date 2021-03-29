Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AC7C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C31F86196E
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhC2Fk3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhC2FkC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:40:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B40C061574
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ylu88CwJENOipD7eEhfysfT44+dcmWlxYXNvZln7RJY=; b=UXknQDyfsShaNfBh3QZbH7jyFg
        ujuYfhN5f/uNQ5iu9BN47Gt09KjtnxByQwUAItVYzN5oS9M7hvctkVOwklGi0GwjPG0JWq5nxEiEx
        buBDrnEGfyenLNGTTDfJ7uA/Ii5xt/kzZRRgE44XwSp0FbWYLPXfq/xLGJ3B+Hhy/iuCMUy28sSTS
        KFPlY/Hq14Kym0gcPRlhGwPGbQOQiXOiVzt2GTuNg+p1dTj8XVvvxHBzpmzohLN79aAG0Z+KXDvty
        m0fLKIrq+SUgrBOCp+AlhogjBJZ0nNuz5e1QhGxqRdIyj2o0bHF7e+/YPFpT0wzMwZ2ufrj/82JtO
        JkJ4gmwg==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkc5-006oPm-35; Mon, 29 Mar 2021 05:38:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 10/20] xfs: move the di_extsize field to struct xfs_inode
Date:   Mon, 29 Mar 2021 07:38:19 +0200
Message-Id: <20210329053829.1851318-11-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the extsize
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
index 7fc3e06feeb008..4aae40dda771e8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2937,7 +2937,7 @@ xfs_bmap_add_extent_hole_real(
  */
 
 /*
- * Adjust the size of the new extent based on di_extsize and rt extsize.
+ * Adjust the size of the new extent based on i_extsize and rt extsize.
  */
 int
 xfs_bmap_extsize_align(
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e699669039c3a7..bb709584921d8b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -228,7 +228,7 @@ xfs_inode_from_disk(
 
 	ip->i_disk_size = be64_to_cpu(from->di_size);
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
-	to->di_extsize = be32_to_cpu(from->di_extsize);
+	ip->i_extsize = be32_to_cpu(from->di_extsize);
 	to->di_forkoff = from->di_forkoff;
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
@@ -307,7 +307,7 @@ xfs_inode_to_disk(
 
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
-	to->di_extsize = cpu_to_be32(from->di_extsize);
+	to->di_extsize = cpu_to_be32(ip->i_extsize);
 	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = from->di_forkoff;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index f4e1a9010b0a47..6bc78856373e31 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,6 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 30abf797592443..46b1af91e78ddf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -60,8 +60,8 @@ xfs_get_extsz_hint(
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
@@ -712,7 +712,7 @@ xfs_inode_inherit_flags(
 			di_flags |= XFS_DIFLAG_RTINHERIT;
 		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-			ip->i_d.di_extsize = pip->i_d.di_extsize;
+			ip->i_extsize = pip->i_extsize;
 		}
 		if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 			di_flags |= XFS_DIFLAG_PROJINHERIT;
@@ -722,7 +722,7 @@ xfs_inode_inherit_flags(
 			di_flags |= XFS_DIFLAG_REALTIME;
 		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 			di_flags |= XFS_DIFLAG_EXTSIZE;
-			ip->i_d.di_extsize = pip->i_d.di_extsize;
+			ip->i_extsize = pip->i_extsize;
 		}
 	}
 	if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
@@ -839,7 +839,7 @@ xfs_init_new_inode(
 	inode->i_atime = tv;
 	inode->i_ctime = tv;
 
-	ip->i_d.di_extsize = 0;
+	ip->i_extsize = 0;
 	ip->i_d.di_flags = 0;
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 5cf7f561465a7c..dff9bac658ace1 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -57,6 +57,7 @@ typedef struct xfs_inode {
 	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	prid_t			i_projid;	/* owner's project id */
+	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 1d01cabc2db167..a0136fe771f076 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -371,7 +371,7 @@ xfs_inode_to_log_dinode(
 
 	to->di_size = ip->i_disk_size;
 	to->di_nblocks = ip->i_nblocks;
-	to->di_extsize = from->di_extsize;
+	to->di_extsize = ip->i_extsize;
 	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = from->di_forkoff;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8d22127284d360..ec769219e435e9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1120,7 +1120,7 @@ xfs_fill_fsxattr(
 	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
 
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
-	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
+	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
 			ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_projid = ip->i_projid;
@@ -1223,7 +1223,7 @@ xfs_ioctl_setattr_xflags(
 	/* If realtime flag is set then must have realtime device */
 	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
-		    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize))
+		    (ip->i_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
 	}
 
@@ -1347,7 +1347,7 @@ xfs_ioctl_setattr_check_extsize(
 	xfs_fsblock_t		extsize_fsb;
 
 	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
-	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
+	    ((ip->i_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
 		return -EINVAL;
 
 	if (fa->fsx_extsize == 0)
@@ -1519,9 +1519,9 @@ xfs_ioctl_setattr(
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
index b9dc8523633878..7e2340ee2f37b6 100644
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
2.30.1

