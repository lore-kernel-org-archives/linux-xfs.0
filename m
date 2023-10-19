Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E339CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 00:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjJSABY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjJSABV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 20:01:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07322113
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 17:01:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB40C433CB;
        Thu, 19 Oct 2023 00:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697673678;
        bh=InkiRMpgGSXGhna/tMAkhLx1wC6Uumc62RS8+eg0DMA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=imLXwuVQ3LszqZANbAXctRjB9Yi/Gey6K9UIIV7z2V0jAHh/XLUZ+niyD36nmjo/g
         KRmcAjgJtp3toZkIu4GK6a7yUp6PDw6KYT8U4uhsK4Ub8oiMO4nX+i/AhVkYwdxRP0
         qOell4Do0cYUW3zy0wFMqrwtLQt+ERu08hzOaYN0IDEnrdWfRETqpu67bhXXXfJA46
         K5g6KeBBAvaeoCitSCgkcyyVCdNGoXviWxnBZrSqtDJz81j0etcjyIEjVHov2f4Fn9
         eCQ+kSyKHebPyCgvyWw9rTsJr0A2izXAGIriePUoX/o22YYMhitE8lj1/dpH3zlDki
         eC9KiFrq12yUg==
Subject: [PATCH 5/9] xfs: invert the realtime summary cache
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@fb.com, linux-xfs@vger.kernel.org, osandov@osandov.com,
        hch@lst.de
Date:   Wed, 18 Oct 2023 17:01:18 -0700
Message-ID: <169767367822.4127997.11830982811104670142.stgit@frogsfrogsfrogs>
In-Reply-To: <169767364977.4127997.1556211251650244714.stgit@frogsfrogsfrogs>
References: <169767364977.4127997.1556211251650244714.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

In commit 355e3532132b ("xfs: cache minimum realtime summary level"), I
added a cache of the minimum level of the realtime summary that has any
free extents. However, it turns out that the _maximum_ level is more
useful for upcoming optimizations, and basically equivalent for the
existing usage. So, let's change the meaning of the cache to be the
maximum level + 1, or 0 if there are no free extents.

For example, if the cache contains:

{0, 4}

then there are no free extents starting in realtime bitmap block 0, and
there are no free extents larger than or equal to 2^4 blocks starting in
realtime bitmap block 1. The cache is a loose upper bound, so there may
or may not be free extents smaller than 2^4 blocks in realtime bitmap
block 1.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    6 +++---
 fs/xfs/xfs_mount.h           |    6 +++---
 fs/xfs/xfs_rtalloc.c         |   31 +++++++++++++++++++------------
 3 files changed, 25 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9f806af4f720..b332ab490a48 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -495,10 +495,10 @@ xfs_rtmodify_summary_int(
 		xfs_suminfo_t	val = xfs_suminfo_add(args, infoword, delta);
 
 		if (mp->m_rsum_cache) {
-			if (val == 0 && log == mp->m_rsum_cache[bbno])
-				mp->m_rsum_cache[bbno]++;
-			if (val != 0 && log < mp->m_rsum_cache[bbno])
+			if (val == 0 && log + 1 == mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
+			if (val != 0 && log >= mp->m_rsum_cache[bbno])
+				mp->m_rsum_cache[bbno] = log + 1;
 		}
 		xfs_trans_log_rtsummary(args, infoword);
 		if (sum)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d8769dc5f6dd..9cd1d570d24d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -101,9 +101,9 @@ typedef struct xfs_mount {
 
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
-	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
-	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
-	 * inode lock.
+	 * invariant that m_rsum_cache[bbno] > the maximum i for which
+	 * rsum[i][bbno] != 0, or 0 if rsum[i][bbno] == 0 for all i.
+	 * Reads and writes are serialized by the rsumip inode lock.
 	 */
 	uint8_t			*m_rsum_cache;
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d5b6be45755f..6bde64584a37 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -54,14 +54,19 @@ xfs_rtany_summary(
 	int			log;	/* loop counter, log2 of ext. size */
 	xfs_suminfo_t		sum;	/* summary data */
 
-	/* There are no extents at levels < m_rsum_cache[bbno]. */
-	if (mp->m_rsum_cache && low < mp->m_rsum_cache[bbno])
-		low = mp->m_rsum_cache[bbno];
+	/* There are no extents at levels >= m_rsum_cache[bbno]. */
+	if (mp->m_rsum_cache) {
+		high = min(high, mp->m_rsum_cache[bbno] - 1);
+		if (low > high) {
+			*stat = 0;
+			return 0;
+		}
+	}
 
 	/*
 	 * Loop over logs of extent sizes.
 	 */
-	for (log = low; log <= high; log++) {
+	for (log = high; log >= low; log--) {
 		/*
 		 * Get one summary datum.
 		 */
@@ -82,9 +87,9 @@ xfs_rtany_summary(
 	 */
 	*stat = 0;
 out:
-	/* There were no extents at levels < log. */
-	if (mp->m_rsum_cache && log > mp->m_rsum_cache[bbno])
-		mp->m_rsum_cache[bbno] = log;
+	/* There were no extents at levels > log. */
+	if (mp->m_rsum_cache && log + 1 < mp->m_rsum_cache[bbno])
+		mp->m_rsum_cache[bbno] = log + 1;
 	return 0;
 }
 
@@ -887,12 +892,14 @@ xfs_alloc_rsum_cache(
 	xfs_extlen_t	rbmblocks)	/* number of rt bitmap blocks */
 {
 	/*
-	 * The rsum cache is initialized to all zeroes, which is trivially a
-	 * lower bound on the minimum level with any free extents. We can
-	 * continue without the cache if it couldn't be allocated.
+	 * The rsum cache is initialized to the maximum value, which is
+	 * trivially an upper bound on the maximum level with any free extents.
+	 * We can continue without the cache if it couldn't be allocated.
 	 */
-	mp->m_rsum_cache = kvzalloc(rbmblocks, GFP_KERNEL);
-	if (!mp->m_rsum_cache)
+	mp->m_rsum_cache = kvmalloc(rbmblocks, GFP_KERNEL);
+	if (mp->m_rsum_cache)
+		memset(mp->m_rsum_cache, -1, rbmblocks);
+	else
 		xfs_warn(mp, "could not allocate realtime summary cache");
 }
 

