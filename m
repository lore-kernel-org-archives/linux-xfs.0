Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3236C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F2D961A07
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbhCXOWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236239AbhCXOWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:22:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E57DC061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=ihhr7icasKBYE1gBZreEoN9Ctl0/P52zqiae7gwv3Ks=; b=HDd0W7mpUhQbHIZ2XDEOWAdLBa
        K9V62w1ampL32TNe4A6LLF1DFZUAb4XZgcJb9jnqLW5NzekfLm8QxrZ0bLkqhIv2r6+SnZnCLFS3Z
        8REVZGfLF2HAjiOyY41AuIsToO3Ic/RIwqWCSgR7A34cgfsJn9MF+sQXGXdHU8UljmKVkibKquI8s
        XBs28836BoCJU2X7edT/u89DCnGbmQ/uaL2aCukLYXO0rhgyVa7EnVHBzXgIJcFKohzhR4XZanxmt
        fEP+ZUJ5UW0wLav4yvsvaMoZEW8N1GL74OoevAmQ4Fh/5NF1zRQ96P/lPv0hMoBfDZBTxBZUiOcEh
        ++HiI1ow==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4Ob-0045Xv-HC
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:22:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/18] xfs: use a union for i_cowextsize and i_flushiter
Date:   Wed, 24 Mar 2021 15:21:24 +0100
Message-Id: <20210324142129.1011766-14-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_inode_buf.c | 3 ++-
 fs/xfs/xfs_inode.c            | 6 ++++--
 fs/xfs/xfs_inode.h            | 7 +++++--
 fs/xfs/xfs_ioctl.c            | 6 +++++-
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d090274fb8a152..96db2649f6b2fe 100644
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
index e951ea48b3a276..b4b6fddccd1ca0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3459,8 +3459,10 @@ xfs_iflush(
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
index 6246ee8a4359ab..7ba0ffa50ede20 100644
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
index e45bce9b11082c..3405a5f5bacfda 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1121,7 +1121,11 @@ xfs_fill_fsxattr(
 
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
2.30.1

