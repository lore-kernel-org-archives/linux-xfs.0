Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1CCC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiLTAFY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLTAFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:05:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC31063D0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 16:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C185B8109D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 00:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D75C433D2;
        Tue, 20 Dec 2022 00:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494720;
        bh=dVgoqvQsHHKZMeb0S1hnhUhqNcQNmkJdHQCZUjdjT6s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m2aJOHJR7D6zRUxdtF2DN6Nd8cnQUJ0FqzZu7eUhoC6v3I0B38YwLN504wiXgqIag
         Klj8cG1uctCQh/Hpyl4if+OAmGj8pDpfCIVVHydnXW4JA60CcWxoEx9fSa7h3TVYrJ
         oLi+NTlXiwtPM/W+avdLKrdnQWoUVah3NC+yxB+cKMYWvJaS3nPLm/2DQcGSGvdYqW
         YA0lAiRcDNeF3b2PjRyNwGFnUvU5CCJ53lSwt4W9WJ9IHLJmd0Pj6QCaS/rMGRfXgb
         hVaOQ67kICVZ5ghuQjpZvjZ1v4mWlHEywf++3CLezEA01l+BilWRVamy5wKuJFwmow
         yazgasLq2eWtQ==
Subject: [PATCH 4/4] xfs: fix off-by-one error in xfs_btree_space_to_height
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 19 Dec 2022 16:05:19 -0800
Message-ID: <167149471987.336919.3277522603824048839.stgit@magnolia>
In-Reply-To: <167149469744.336919.13748690081866673267.stgit@magnolia>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Lately I've been stress-testing extreme-sized rmap btrees by using the
(new) xfs_db bmap_inflate command to clone bmbt mappings billions of
times and then using xfs_repair to build new rmap and refcount btrees.
This of course is /much/ faster than actually FICLONEing a file billions
of times.

Unfortunately, xfs_repair fails in xfs_btree_bload_compute_geometry with
EOVERFLOW, which indicates that xfs_mount.m_rmap_maxlevels is not
sufficiently large for the test scenario.  For a 1TB filesystem (~67
million AG blocks, 4 AGs) the btheight command reports:

$ xfs_db -c 'btheight -n 4400801200 -w min rmapbt' /dev/sda
rmapbt: worst case per 4096-byte block: 84 records (leaf) / 45 keyptrs (node)
level 0: 4400801200 records, 52390491 blocks
level 1: 52390491 records, 1164234 blocks
level 2: 1164234 records, 25872 blocks
level 3: 25872 records, 575 blocks
level 4: 575 records, 13 blocks
level 5: 13 records, 1 block
6 levels, 53581186 blocks total

The AG is sufficiently large to build this rmap btree.  Unfortunately,
m_rmap_maxlevels is 5.  Augmenting the loop in the space->height
function to report height, node blocks, and blocks remaining produces
this:

ht 1 node_blocks 45 blockleft 67108863
ht 2 node_blocks 2025 blockleft 67108818
ht 3 node_blocks 91125 blockleft 67106793
ht 4 node_blocks 4100625 blockleft 67015668
final height: 5

The goal of this function is to compute the maximum height btree that
can be stored in the given number of ondisk fsblocks.  Starting with the
top level of the tree, each iteration through the loop adds the fanout
factor of the next level down until we run out of blocks.  IOWs, maximum
height is achieved by using the smallest fanout factor that can apply
to that level.

However, the loop setup is not correct.  Top level btree blocks are
allowed to contain fewer than minrecs items, so the computation is
incorrect because the first time through the loop it should be using a
fanout factor of 2.  With this corrected, the above becomes:

ht 1 node_blocks 2 blockleft 67108863
ht 2 node_blocks 90 blockleft 67108861
ht 3 node_blocks 4050 blockleft 67108771
ht 4 node_blocks 182250 blockleft 67104721
ht 5 node_blocks 8201250 blockleft 66922471
final height: 6

Fixes: 9ec691205e7d ("xfs: compute the maximum height of the rmap btree when reflink enabled")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4c16c8c31fcb..8d11d3f5e529 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4666,7 +4666,11 @@ xfs_btree_space_to_height(
 	const unsigned int	*limits,
 	unsigned long long	leaf_blocks)
 {
-	unsigned long long	node_blocks = limits[1];
+	/*
+	 * The root btree block can have a fanout between 2 and maxrecs because
+	 * the tree might not be big enough to fill it.
+	 */
+	unsigned long long	node_blocks = 2;
 	unsigned long long	blocks_left = leaf_blocks - 1;
 	unsigned int		height = 1;
 

