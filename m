Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91F7C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiLaCnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiLaCnd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:43:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25648DF0C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:43:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6BE061CD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE57C433EF;
        Sat, 31 Dec 2022 02:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454612;
        bh=v0rWZTi45+2TBXBVKHfSTxyzHM7nExx0urk7kL3roQc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BvyKcOaXBrj9f/2DPhIta+WDqiBgVHzHDabPakhTYo/M3dm1ohgXVil0UYer1bGA6
         lFAC/l/uNQMi0Fjb0zXl1o+u5FbNWjTQ61QzOUEWo7Z7qPZuTtcVjdKfxaSiaC4jcq
         afwkhQiEhkQGmUDpuXbbYtgoTHovidUkmlBeyWILIh4+xj8Rp08MGO6QxdNA6Ttmo4
         4CLbeEHSuSXG0NO8FW476ZaxRm69IXKi1v2AjDPo5kYE2awMfst2ZHfP6GJgQrGc6q
         VjQIow9sZoiJ4uu7Kk0qWovPlrufQliW6BWlwWZF9Zxgqespc6ZusSMskUnf1mS6Sx
         zKddidum8MF1Q==
Subject: [PATCH 04/41] xfs: realtime rmap btree transaction reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:56 -0800
Message-ID: <167243879648.732820.10272380631860178810.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrmapbt to add the record and a second
split in the regular rmapbt to record the rtrmapbt split.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_swapext.c     |    4 +++-
 libxfs/xfs_trans_resv.c  |   12 ++++++++++--
 libxfs/xfs_trans_space.h |   13 +++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 718600019a7..3c22c1d8e2f 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -700,7 +700,9 @@ xfs_swapext_rmapbt_blocks(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 	if (XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
+		return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)) *
+			XFS_RTRMAPADD_SPACE_RES(mp);
 
 	return howmany_64(req->nr_exchanges,
 					XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) *
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index db0c745a431..42322a42058 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -210,7 +210,9 @@ xfs_calc_inode_chunk_res(
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
  * blocks as needed to mark inuse XFS_BMBT_MAX_EXTLEN blocks' worth of realtime
- * extents, as well as the realtime summary block.
+ * extents, as well as the realtime summary block (t1).  Realtime rmap btree
+ * operations happen in a second transaction, so factor in a couple of rtrmapbt
+ * splits (t2).
  */
 static unsigned int
 xfs_rtalloc_block_count(
@@ -219,10 +221,16 @@ xfs_rtalloc_block_count(
 {
 	unsigned int		rtbmp_blocks;
 	xfs_rtxlen_t		rtxlen;
+	unsigned int		t1, t2 = 0;
 
 	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
 	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, rtxlen);
-	return (rtbmp_blocks + 1) * num_ops;
+	t1 = (rtbmp_blocks + 1) * num_ops;
+
+	if (xfs_has_rmapbt(mp))
+		t2 = num_ops * (2 * mp->m_rtrmap_maxlevels - 1);
+
+	return max(t1, t2);
 }
 
 /*
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 9640fc232c1..8124893a035 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -14,6 +14,19 @@
 #define XFS_MAX_CONTIG_BMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_bmap_dmxr[0]) - ((mp)->m_bmap_dmnr[0]))
 
+/* Worst case number of realtime rmaps that can be held in a block. */
+#define XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)    \
+		(((mp)->m_rtrmap_mxr[0]) - ((mp)->m_rtrmap_mnr[0]))
+
+/* Adding one realtime rmap could split every level to the top of the tree. */
+#define XFS_RTRMAPADD_SPACE_RES(mp) ((mp)->m_rtrmap_maxlevels)
+
+/* Blocks we might need to add "b" realtime rmaps to a tree. */
+#define XFS_NRTRMAPADD_SPACE_RES(mp, b) \
+	((((b) + XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp) - 1) / \
+	  XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)) * \
+	  XFS_RTRMAPADD_SPACE_RES(mp))
+
 /* Worst case number of rmaps that can be held in a block. */
 #define XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_rmap_mxr[0]) - ((mp)->m_rmap_mnr[0]))

