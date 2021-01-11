Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C824DC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C73E22DCC
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbhALAZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404099AbhAKXY1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:24:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A619D22D3E;
        Mon, 11 Jan 2021 23:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407426;
        bh=Ve7iXhoKb07lvaGRPBL4HwAKDOudC2jx5OsRkT7x5FQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HjDuS7X+/ZQ6GR9AFWrlRtON3MOciHLRiowzX7vvJVXj3HHeyBR/fFXWEkEMrWxKY
         FwakNe/xX9VFEI5a61v3JPGjp6aqtABcd+JYp6snnl0xFWcROFCEB7D3qsb+I8dzLV
         0HTWXQ2MdPlDdefXlJs2TLUXEr7BOzuH6Zqa5VFtIUdftsDhaJKxXhdZ8p/r11x9mo
         Ykppj/98mVUrYQFSRlMK1g38IM2984g2uPllKC7aAmVPWFA0hrdqP9iKC/RoZyemr4
         cxCKszs8SsBuH8wGyFLMMT60Do0zkcEq5kESGL6CkgwPxB4KnTjFlcXYXKsHauIA2E
         6qWs6VpJxt5/Q==
Subject: [PATCH 5/7] xfs: only walk the incore inode tree once per blockgc
 scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:46 -0800
Message-ID: <161040742666.1582286.3910636058356753098.stgit@magnolia>
In-Reply-To: <161040739544.1582286.11068012972712089066.stgit@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
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
---
 fs/xfs/xfs_icache.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 92fcec349054..4f68375cf873 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -31,6 +31,9 @@
  */
 #define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
 
+STATIC int xfs_inode_free_eofblocks(struct xfs_inode *ip, void *args);
+STATIC int xfs_inode_free_cowblocks(struct xfs_inode *ip, void *args);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -950,19 +953,29 @@ xfs_queue_blockgc(
 	rcu_read_unlock();
 }
 
+/* Scan one incore inode for block preallocations that we can remove. */
+static int
+xfs_blockgc_scan_inode(
+	struct xfs_inode	*ip,
+	void			*args)
+{
+	int			error;
+
+	error = xfs_inode_free_eofblocks(ip, args);
+	if (error && error != -EAGAIN)
+		return error;
+
+	return xfs_inode_free_cowblocks(ip, args);
+}
+
 /* Scan all incore inodes for block preallocations that we can remove. */
 static inline int
 xfs_blockgc_scan(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	int			error;
-
-	error = xfs_icache_free_eofblocks(mp, eofb);
-	if (error && error != -EAGAIN)
-		return error;
-
-	return xfs_icache_free_cowblocks(mp, eofb);
+	return __xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
+			XFS_ICI_BLOCK_GC_TAG);
 }
 
 /* Background worker that trims preallocated space. */

