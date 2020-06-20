Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B16EC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666DA225A9
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pagMa1He"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgFTHLa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFTHL3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 03:11:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C48C06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 00:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=1qHoiyAbP+K44i4Mx/L0/MhAp/ZYEg5dHT3dGVe8Sic=; b=pagMa1HeF/mXX3o5tbbSO658vD
        +Ucpj529p6xmpbE2Fku/O0xk9kYPTMbl7tpTuGF5K+TRvGTJkdsHTKsVuMWnxYDKvr56yxnEBJkZZ
        oVMS+94+pCL/lX7yPpK2m8sqp7G16236tthpQA8Lwcx/iPcQQ0beVNZUnsVU1st+wXAyNQqXaGzdG
        zjxQTaKa7iaIpg0Td+Z5b6UaexAgYEC7y66rQkdUoKaG2RvA8h4E6h0rS6SlBHYGRk71qtr2roLQg
        fjCTGTu2B+lzL7Ka+qhxWVo3i5EsM7g8FQTTP9Z2rkAqEKIxxePifn5oXun/ePDip+bpxO6aSieGL
        NSvEH+DA==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmXez-00010R-5M
        for linux-xfs@vger.kernel.org; Sat, 20 Jun 2020 07:11:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/15] xfs: use a union for i_cowextsize and i_flushiter
Date:   Sat, 20 Jun 2020 09:10:55 +0200
Message-Id: <20200620071102.462554-9-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200620071102.462554-1-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de>
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
index 03bd7cdd0ddc81..8c4b7bd69285fa 100644
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
index 5e0336e0dbae44..fd111e05c0bb2e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3794,8 +3794,10 @@ xfs_iflush_int(
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
index 581618ea1156da..a0444b9ce3f792 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -58,8 +58,11 @@ typedef struct xfs_inode {
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	uint32_t		i_projid;	/* owner's project id */
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
index a1937900ad84be..60544dd0f875b8 100644
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

