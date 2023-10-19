Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E843CDB483
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 00:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjJSAB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbjJSAB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 20:01:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6159115
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 17:01:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1C5C433C8;
        Thu, 19 Oct 2023 00:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697673684;
        bh=qEl8dy0NWO606fpPfCIiWFIdCN8Kj5Ua3qqCpUbiNzY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RleYVLXym/5fE0B/D0du/5PMLtLEoQbqsniOjoDNy3etTkOEpKd8qB9zQ04KdcMQM
         iB+VL0Yx3I1OQWDeNGj2rMEW/uzL6BhzO7au71dSyBp6IoFH/1dDjowB5C/W5KD5z4
         +0JF7jq+97k762j5BvtyDfMNXy+ijU2M539X5imJIUt7L1KB2Y58a0ixGdqhRIHfKc
         GFOetxn9zfEKGCTk3XC9nOGJBgBewdc/zSRyHHIPI7RxFanAbC1UspacTFd8F8AGjg
         KsErmhuP/IevGkEGREBZcsH4Mj/XFEB7pM8sV8/ch3vzOdFZPfas7gX6PRNJWtUgOm
         s7o3AC92r5xgg==
Subject: [PATCH 6/9] xfs: return maximum free size from xfs_rtany_summary()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@fb.com, linux-xfs@vger.kernel.org, osandov@osandov.com,
        hch@lst.de
Date:   Wed, 18 Oct 2023 17:01:23 -0700
Message-ID: <169767368381.4127997.215213369441088455.stgit@frogsfrogsfrogs>
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

Instead of only returning whether there is any free space, return the
maximum size, which is fast thanks to the previous commit. This will be
used by two upcoming optimizations.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6bde64584a37..c774a4ccdd15 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -47,7 +47,7 @@ xfs_rtany_summary(
 	int			low,	/* low log2 extent size */
 	int			high,	/* high log2 extent size */
 	xfs_fileoff_t		bbno,	/* bitmap block number */
-	int			*stat)	/* out: any good extents here? */
+	int			*maxlog) /* out: max log2 extent size free */
 {
 	struct xfs_mount	*mp = args->mp;
 	int			error;
@@ -58,7 +58,7 @@ xfs_rtany_summary(
 	if (mp->m_rsum_cache) {
 		high = min(high, mp->m_rsum_cache[bbno] - 1);
 		if (low > high) {
-			*stat = 0;
+			*maxlog = -1;
 			return 0;
 		}
 	}
@@ -78,14 +78,14 @@ xfs_rtany_summary(
 		 * If there are any, return success.
 		 */
 		if (sum) {
-			*stat = 1;
+			*maxlog = log;
 			goto out;
 		}
 	}
 	/*
 	 * Found nothing, return failure.
 	 */
-	*stat = 0;
+	*maxlog = -1;
 out:
 	/* There were no extents at levels > log. */
 	if (mp->m_rsum_cache && log + 1 < mp->m_rsum_cache[bbno])
@@ -434,7 +434,7 @@ xfs_rtallocate_extent_near(
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
 	struct xfs_mount	*mp = args->mp;
-	int			any;	/* any useful extents from summary */
+	int			maxlog;	/* max useful extent from summary */
 	xfs_fileoff_t		bbno;	/* bitmap block number */
 	int			error;
 	int			i;	/* bitmap block offset (loop control) */
@@ -488,7 +488,7 @@ xfs_rtallocate_extent_near(
 		 * starting in this bitmap block.
 		 */
 		error = xfs_rtany_summary(args, log2len, mp->m_rsumlevels - 1,
-				bbno + i, &any);
+				bbno + i, &maxlog);
 		if (error) {
 			return error;
 		}
@@ -496,7 +496,7 @@ xfs_rtallocate_extent_near(
 		 * If there are any useful extents starting here, try
 		 * allocating one.
 		 */
-		if (any) {
+		if (maxlog >= 0) {
 			/*
 			 * On the positive side of the starting location.
 			 */
@@ -537,7 +537,7 @@ xfs_rtallocate_extent_near(
 					error = xfs_rtany_summary(args,
 							log2len,
 							mp->m_rsumlevels - 1,
-							bbno + j, &any);
+							bbno + j, &maxlog);
 					if (error) {
 						return error;
 					}
@@ -549,7 +549,7 @@ xfs_rtallocate_extent_near(
 					 * extent given, we've already tried
 					 * that allocation, don't do it again.
 					 */
-					if (any)
+					if (maxlog >= 0)
 						continue;
 					error = xfs_rtallocate_extent_block(args,
 							bbno + j, minlen,

