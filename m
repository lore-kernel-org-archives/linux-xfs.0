Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A57C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72A422B2D
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhAWSyn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbhAWSyk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:54:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F73722B2D;
        Sat, 23 Jan 2021 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611428039;
        bh=73Lz1PJE8mWgCvdeTXXMsyE/XzG1Gt+7xpNRAkrf2fw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mIggsENk4lF96aL0G5fw8an3W3gDOTcnwtDbEBNG7xEjNzeNYsQkpYsMtOfrqr9vW
         /oTPSizJ1GN/tlnVott9AKRKo1wwc9rBajDIRjkQ1MYXbfj01DQJS2x0ZhJ37Li2P2
         PiYH5JLwUB22mvLSzSddyKNuhmz+EOrk5x4MyNyrxQVv+MGg+5jMvpKe6v6N1Tr62h
         lkL4ZMlZGVgSS9UMEpDDwO/jB2JsFLKsr5xR8F/VlbwNwC0oQhnzhknKhXSOPb8kDi
         RF7RHlP2TQu08lsGsK/Np4l3MgDS6hR9qIZvxzE9VNMCbdqYqBIyq4n8rfiu/btEnK
         a1mu8ePbWy8dg==
Subject: [PATCH 7/9] xfs: only walk the incore inode tree once per blockgc
 scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:54:01 -0800
Message-ID: <161142804090.2173480.6851634520746499947.stgit@magnolia>
In-Reply-To: <161142800187.2173480.17415824680111946713.stgit@magnolia>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Perform background block preallocation gc scans more efficiently by
walking the incore inode tree once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 038e0b764aa8..61d06f34fdd7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1571,21 +1571,19 @@ xfs_start_block_reaping(
 	xfs_blockgc_queue(mp);
 }
 
-/* Scan all incore inodes for block preallocations that we can remove. */
-static inline int
-xfs_blockgc_scan(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+/* Scan one incore inode for block preallocations that we can remove. */
+static int
+xfs_blockgc_scan_inode(
+	struct xfs_inode	*ip,
+	void			*args)
 {
 	int			error;
 
-	error = xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
-			XFS_ICI_BLOCKGC_TAG);
+	error = xfs_inode_free_eofblocks(ip, args);
 	if (error)
 		return error;
 
-	error = xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
-			XFS_ICI_BLOCKGC_TAG);
+	error = xfs_inode_free_cowblocks(ip, args);
 	if (error)
 		return error;
 
@@ -1603,7 +1601,8 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_blockgc_scan(mp, NULL);
+	error = xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, NULL,
+			XFS_ICI_BLOCKGC_TAG);
 	if (error)
 		xfs_info(mp, "preallocation gc worker failed, err=%d", error);
 	sb_end_write(mp->m_super);
@@ -1620,7 +1619,8 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_blockgc_scan(mp, eofb);
+	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
+			XFS_ICI_BLOCKGC_TAG);
 }
 
 /*

