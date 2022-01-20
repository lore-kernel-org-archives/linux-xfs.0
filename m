Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718F8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345289AbiATAZR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48184 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345320AbiATAZQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7AA3B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93D8C004E1;
        Thu, 20 Jan 2022 00:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638313;
        bh=RmqhmWznKC3FJJE5sbX/QvO++2Ed1Mv+5ILNtl2NLa0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=boYRWtvJ4EkT1IKeFI1YFQLD0X3u9gXRPBjb1pvk9IBgoWEnNU5xPAs7mPrfah7Sq
         BugP0FA8W2IkPDCda6fnVF3sdu9ol4G/np0DveGobbpk4fGYQFtHMAdYVPWn81hWSj
         /TLB40VSouD1IZbYIcZIJN4sbONhbxVEANMIk/zcQ4yIwkfFmqUp70D9CeNlQ3CnI9
         djAmdFUwPWvHwV1WB2fH2Zajw43c82lTskKjypbAuHaWE/NucwhsLkpLSnvLSznuo3
         AZiloiF6OaI+bJWGayNYv2X6wdt88WMfxvYYtX3HbFL6jhO1XlNpIFl6ZeAeDXrB/l
         49wsA81/Jbmpw==
Subject: [PATCH 22/48] xfs: clean up xfs_btree_{calc_size,compute_maxlevels}
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:13 -0800
Message-ID: <164263831338.865554.13825367472651263860.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 1b236ad7ba800bc3e9994881a8a453eb8bf5ca0f

During review of the next patch, Dave remarked that he found these two
btree geometry calculation functions lacking in documentation and that
they performed more work than was really necessary.

These functions take the same parameters and have nearly the same logic;
the only real difference is in the return values.  Reword the function
comment to make it clearer what each function does, and move them to be
adjacent to reinforce their relation.

Clean up both of them to stop opencoding the howmany functions, stop
using the uint typedefs, and make them both support computations for
more than 2^32 leaf records, since we're going to need all of the above
for files with large data forks and large rmap btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   67 ++++++++++++++++++++++++++--------------------------
 libxfs/xfs_btree.h |    6 +++--
 2 files changed, 37 insertions(+), 36 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 6a049c64..5ada6cc4 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4515,21 +4515,43 @@ xfs_btree_sblock_verify(
 }
 
 /*
- * Calculate the number of btree levels needed to store a given number of
- * records in a short-format btree.
+ * For the given limits on leaf and keyptr records per block, calculate the
+ * height of the tree needed to index the number of leaf records.
  */
-uint
+unsigned int
 xfs_btree_compute_maxlevels(
-	uint			*limits,
-	unsigned long		len)
+	const unsigned int	*limits,
+	unsigned long long	records)
 {
-	uint			level;
-	unsigned long		maxblocks;
+	unsigned long long	level_blocks = howmany_64(records, limits[0]);
+	unsigned int		height = 1;
 
-	maxblocks = (len + limits[0] - 1) / limits[0];
-	for (level = 1; maxblocks > 1; level++)
-		maxblocks = (maxblocks + limits[1] - 1) / limits[1];
-	return level;
+	while (level_blocks > 1) {
+		level_blocks = howmany_64(level_blocks, limits[1]);
+		height++;
+	}
+
+	return height;
+}
+
+/*
+ * For the given limits on leaf and keyptr records per block, calculate the
+ * number of blocks needed to index the given number of leaf records.
+ */
+unsigned long long
+xfs_btree_calc_size(
+	const unsigned int	*limits,
+	unsigned long long	records)
+{
+	unsigned long long	level_blocks = howmany_64(records, limits[0]);
+	unsigned long long	blocks = level_blocks;
+
+	while (level_blocks > 1) {
+		level_blocks = howmany_64(level_blocks, limits[1]);
+		blocks += level_blocks;
+	}
+
+	return blocks;
 }
 
 /*
@@ -4823,29 +4845,6 @@ xfs_btree_query_all(
 	return xfs_btree_simple_query_range(cur, &low_key, &high_key, fn, priv);
 }
 
-/*
- * Calculate the number of blocks needed to store a given number of records
- * in a short-format (per-AG metadata) btree.
- */
-unsigned long long
-xfs_btree_calc_size(
-	uint			*limits,
-	unsigned long long	len)
-{
-	int			level;
-	int			maxrecs;
-	unsigned long long	rval;
-
-	maxrecs = limits[0];
-	for (level = 0, rval = 0; len > 1; level++) {
-		len += maxrecs - 1;
-		do_div(len, maxrecs);
-		maxrecs = limits[1];
-		rval += len;
-	}
-	return rval;
-}
-
 static int
 xfs_btree_count_blocks_helper(
 	struct xfs_btree_cur	*cur,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index b46cd983..3bd69fe4 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -487,8 +487,10 @@ xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp,
 xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
 
-uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
-unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
+unsigned int xfs_btree_compute_maxlevels(const unsigned int *limits,
+		unsigned long long records);
+unsigned long long xfs_btree_calc_size(const unsigned int *limits,
+		unsigned long long records);
 
 /*
  * Return codes for the query range iterator function are 0 to continue

