Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D3DC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F936207D8
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U9LYcEKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbgEXJSX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387483AbgEXJSX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C165C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=Km3GMSfBfoS0dXB2DTlvyCgDDfd/hWfSP5E3D0FjPSk=; b=U9LYcEKGD0ygYQaLNiZrg5j1dj
        eUGtkWPgtAeP9ewL5ResZokgR/pW+53o268hoaz/tFzZDP/KaZZK2uTbmYKAwC/WDwY5O1RYhfsp2
        ksl33qmdY6UMUHy4vYWTDSkM1QLGTCJW4wdJ5RUfGdxw8xFXRJ6qSIv0D8kwlX+r6djO7WG42yXwb
        J8VFDTRxEqR4egb8mYrSi8zFEqfzu/G8RRiuJhdOjnS8JT0m1wAOJMB3xw6jlpMq3u06Q2wTMDhJ5
        LCsIpJYstV7173qKPr2DFqYVMcvBnjqpO4v9TyKpxGdobDJCgPBoKwEpH8mLc+S28rBX9wzrA2Sk4
        HcliIgOA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmly-0004sQ-EH
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/14] xfs: use a union for i_cowextsize and i_flushiter
Date:   Sun, 24 May 2020 11:17:51 +0200
Message-Id: <20200524091757.128995-9-hch@lst.de>
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

The i_cowextsize field is only used for v3 inodes, and the i_flushiter
field is only used for v1/v2 inodes.  Use a union to pack the inode a
littler better after adding a few missing guards around their usage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 3 ++-
 fs/xfs/xfs_inode.c            | 6 ++++--
 fs/xfs/xfs_inode.h            | 7 +++++--
 fs/xfs/xfs_ioctl.c            | 6 +++++-
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 03bd7cdd0ddc8..8c4b7bd69285f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -205,7 +205,8 @@ xfs_inode_from_disk(
 	 * inode. If the inode is unused, mode is zero and we shouldn't mess
 	 * with the unitialized part of it.
 	 */
-	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
+	if (!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb))
+		ip->i_flushiter = be16_to_cpu(from->di_flushiter);
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
 	if (!inode->i_mode)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 805f63fb3c8b4..dff853a7ed0c3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3792,8 +3792,10 @@ xfs_iflush_int(
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
index 91259403ba741..59f7341ece285 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -58,8 +58,11 @@ typedef struct xfs_inode {
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	uint32_t		i_projid;	/* owner's project id */
 	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
-	uint32_t		i_cowextsize;	/* basic cow extent size */
-	uint16_t		i_flushiter;	/* incremented on flush */
+	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
+	union {
+		uint32_t	i_cowextsize;	/* basic cow extent size */
+		uint16_t	i_flushiter;	/* incremented on flush */
+	};
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a9b31ae3c28c0..18ea8b76c7d53 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1108,7 +1108,11 @@ xfs_fill_fsxattr(
 
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
 	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_cowextsize = ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
+	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
+		fa->fsx_cowextsize =
+			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
+	}
 	fa->fsx_projid = ip->i_projid;
 	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
 		fa->fsx_nextents = xfs_iext_count(ifp);
-- 
2.26.2

