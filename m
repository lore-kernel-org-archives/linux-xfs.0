Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEEBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbiLaBR4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbiLaBRz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:17:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181C71D0C6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:17:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2971B81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4742DC433EF;
        Sat, 31 Dec 2022 01:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449472;
        bh=iTVfeaSUzSYQNV3y7Z5Rr0S/v24h0YUodMPOZwXIO60=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EzDuax91BURHEtv62KvQzWHDnCXYO/etC4nWEjbRO11cxBJqzOuQUe3mdhHnGmajm
         dBV+Nj579q3fHL8eIJWMSE9E9xxrT/8LTYlmO8FdTLkNqCYnzwJ5dZIVBphWMDjgZc
         dlmh+3bu40Bs7EiRg3fIb71Lks2atdT7w1eSpN/IrrbSrZ9SXfTHws+x20Dmq+zL/p
         juqBOAePFXfZRP/UrlSju1Qfrmrrqaj/j6VDJbTx24pv0KxhmLumkbrwLohkXtlsIf
         OmBTW1eR4dk/NSioNN7xllwJbtNzT4+W9+n6ajrFdyuurGqkk3Q6Tnd5HCr0+iihYO
         zZGbHrYHRgh8A==
Subject: [PATCH 06/14] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:31 -0800
Message-ID: <167243865194.708933.4077599318945848079.stgit@magnolia>
In-Reply-To: <167243865089.708933.5645420573863731083.stgit@magnolia>
References: <167243865089.708933.5645420573863731083.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The bmap btree cannot ever have zero records in an incore btree block.
If the number of records drops to zero, that means we're converting the
fork to extents format and are trying to remove the tree.  This logic
won't hold for the future realtime rmap btree, so move the logic into
the bmbt code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.h |    7 +++++++
 fs/xfs/libxfs/xfs_inode_fork.c |    6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 3fe9c4f7f1a0..5a3bae94debd 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -162,6 +162,13 @@ xfs_bmap_broot_space_calc(
 	struct xfs_mount	*mp,
 	unsigned int		nrecs)
 {
+	/*
+	 * If the bmbt root block is empty, we should be converting the fork
+	 * to extents format.  Hence, the size is zero.
+	 */
+	if (nrecs == 0)
+		return 0;
+
 	return xfs_bmbt_block_len(mp) + \
 	       (nrecs * (sizeof(struct xfs_bmbt_key) + sizeof(xfs_bmbt_ptr_t)));
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 16782d3630d2..1bd8c1f9ce37 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -488,10 +488,8 @@ xfs_iroot_realloc(
 	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
-	if (new_max > 0)
-		new_size = xfs_bmap_broot_space_calc(mp, new_max);
-	else
-		new_size = 0;
+
+	new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	if (new_size == 0) {
 		xfs_iroot_free(ip, whichfork);
 		return;

