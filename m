Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF94C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8A5664DD8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbhA1GFh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhA1GFD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:05:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC3BC64DD9;
        Thu, 28 Jan 2021 06:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813862;
        bh=2sgOrhWmpnemUzBZNTxGX+IlWOc0lMIucaZ4Of3fuJc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m5aW3PMwv/9cus2o+B/o9zOQL9ET6H4JSii8+4hH77RzNU9JwAbu92wsLEQPADEqe
         0r7nApxOsQiZfhJAyLVFeEu5oH+SNrX3QfQBnj3p+DJh9qwl9UHTR0aVjR6jYM/p1z
         0yfuaY+XLbe8BDf5WsN9JOlUVyi0L9AvrHr/uZnLp7MQ+E2GCtKZeifI/d1uNkJL70
         28Lz1wX6haa4Y1ni87pcmBCJP0VmpJje/hJg2jOo/MnB3rnsXHYaG3Ihd0YOfXpNwZ
         HMa1alVKzSpFLKcvyWV3IfByJDLmST+hJHTI04OshWsXwLjSzwV2haqetJAlYajMe7
         EYBeOo87N95LQ==
Subject: [PATCH 07/11] xfs: only walk the incore inode tree once per blockgc
 scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:04:19 -0800
Message-ID: <161181385904.1525433.780225995842501821.stgit@magnolia>
In-Reply-To: <161181381898.1525433.10723801103841220046.stgit@magnolia>
References: <161181381898.1525433.10723801103841220046.stgit@magnolia>
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
index 0d0462268711..b32400b8e1ee 100644
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

