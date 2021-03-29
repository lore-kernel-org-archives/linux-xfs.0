Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E59BC433E8
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374D86196E
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhC2Fkb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhC2FkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:40:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00BDC061765
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=wDzv2wDzRoKWtxt6Yt+oSrz0sC/jHVfVOinww9/4sdU=; b=IKsOaalTg9kjF4OdfCKatZDSut
        loTc9b2ibMkZW5CGP3QQq1kkzCsN++rL0zYPED1VTS5rUzXqP/VlYfWXnEr2RhakHBv5/dmj4tU0I
        p4JnHSiaCzo451ciyR1IXBeKnoVQLjR6Po1v+e52Wi/ZSu7EAGfITGlN3QqGcNFXgrS/AhvgiHl2v
        C5dlvD3jYYB5n/OJcfW73dxQOJawRxkN7c7TPOyeevZ31cC0yWEK6nIQGZM6MCpn2jewMC4Rf+yO6
        uA49B1xy5xldjm9D77osNru4RNCOxUew8DcWn0YQlPPwtg9I824e9x+YbZXBHUWFliNMWJrELyhaK
        36BsDbNg==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkcG-006oQ5-3p
        for linux-xfs@vger.kernel.org; Mon, 29 Mar 2021 05:39:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/20] xfs: use a union for i_cowextsize and i_flushiter
Date:   Mon, 29 Mar 2021 07:38:24 +0200
Message-Id: <20210329053829.1851318-16-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The i_cowextsize field is only used for v3 inodes, and the i_flushiter
field is only used for v1/v2 inodes.  Use a union to pack the inode a
littler better after adding a few missing guards around their usage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  3 ++-
 fs/xfs/xfs_inode.c            |  6 ++++--
 fs/xfs/xfs_inode.h            |  7 +++++--
 fs/xfs/xfs_ioctl.c            | 15 +++++++++------
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3c7eb01c66ace4..88ec7be551a89d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -193,7 +193,8 @@ xfs_inode_from_disk(
 	 * inode. If the inode is unused, mode is zero and we shouldn't mess
 	 * with the uninitialized part of it.
 	 */
-	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
+	if (!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb))
+		ip->i_flushiter = be16_to_cpu(from->di_flushiter);
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
 	if (!inode->i_mode)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 06d779c9334b80..e483c380afd1db 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3483,8 +3483,10 @@ xfs_iflush(
 	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
-	if (ip->i_flushiter == DI_MAX_FLUSH)
-		ip->i_flushiter = 0;
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb)) {
+		if (ip->i_flushiter == DI_MAX_FLUSH)
+			ip->i_flushiter = 0;
+	}
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
 	if (XFS_IFORK_Q(ip))
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index abe5b44b46220a..abb8672da0ceb4 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -58,8 +58,11 @@ typedef struct xfs_inode {
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	prid_t			i_projid;	/* owner's project id */
 	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
-	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
-	uint16_t		i_flushiter;	/* incremented on flush */
+	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
+	union {
+		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
+		uint16_t	i_flushiter;	/* incremented on flush */
+	};
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7909e46b5c5a18..2028a4aa2bb20a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1123,7 +1123,8 @@ xfs_fill_fsxattr(
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
 
 	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
-	fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
+	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
 	fa->fsx_projid = ip->i_projid;
 	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
 		fa->fsx_nextents = xfs_iext_count(ifp);
@@ -1523,11 +1524,13 @@ xfs_ioctl_setattr(
 		ip->i_extsize = XFS_B_TO_FSB(mp, fa->fsx_extsize);
 	else
 		ip->i_extsize = 0;
-	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
-	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		ip->i_cowextsize = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
-	else
-		ip->i_cowextsize = 0;
+
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+		if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+			ip->i_cowextsize = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
+		else
+			ip->i_cowextsize = 0;
+	}
 
 	error = xfs_trans_commit(tp);
 
-- 
2.30.1

