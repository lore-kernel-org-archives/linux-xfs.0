Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59668CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 00:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjJSABo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbjJSABn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 20:01:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE2A113
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 17:01:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56123C433C9;
        Thu, 19 Oct 2023 00:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697673701;
        bh=3GZ7RxLbYG6GfPXLdRRlbnjzLxzhE1OoyJaGgc+3fS8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EfDyH6OANsSqqyCM+YI70K1dJRHgAcsUjC3aQsb98vvBQbpfs2oTko623njinlHv4
         8DqBmpIyljNqu7BwPkG5e14qdINoCkliQKZbI+cVM8pZMjIsednBtIlS0TTAvtvXi9
         OMY5jDKgR09ohKWwk5+ozWIEg5yUAZ1TcIFMpOvae5Na5dQB64migBEmQMihwTS/8J
         bjdIeEw2BUFmDAGX3918eHkiexYqrSM0HEQEm1W86cnWEIDkYPbao/botyBWnKquB8
         WnsiSnTgLm40lFUglVutbXjtrxGg+NpOrrNMT1ypXj//O1gj54uhGboYQb0OwjE6cK
         zy0+OFjDBLTZQ==
Subject: [PATCH 9/9] xfs: don't look for end of extent further than necessary
 in xfs_rtallocate_extent_near()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@fb.com, linux-xfs@vger.kernel.org, osandov@osandov.com,
        hch@lst.de
Date:   Wed, 18 Oct 2023 17:01:40 -0700
Message-ID: <169767370083.4127997.6969768755256045688.stgit@frogsfrogsfrogs>
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

As explained in the previous commit, xfs_rtallocate_extent_near() looks
for the end of a free extent when searching backwards from the target
bitmap block. Since the previous commit, it searches from the last
bitmap block it checked to the bitmap block containing the start of the
extent.

This may still be more than necessary, since the free extent may not be
that long. We know the maximum size of the free extent from the realtime
summary. Use that to compute how many bitmap blocks we actually need to
check.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b743da885ed6..ba66442910b1 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -527,13 +527,30 @@ xfs_rtallocate_extent_near(
 			 * On the negative side of the starting location.
 			 */
 			else {		/* i < 0 */
+				int	maxblocks;
+
 				/*
-				 * Loop backwards through the bitmap blocks
-				 * from where we last checked down to where we
-				 * are now.  There should be an extent which
-				 * ends in this bitmap block and is long
-				 * enough.
+				 * Loop backwards to find the end of the extent
+				 * we found in the realtime summary.
+				 *
+				 * maxblocks is the maximum possible number of
+				 * bitmap blocks from the start of the extent
+				 * to the end of the extent.
 				 */
+				if (maxlog == 0)
+					maxblocks = 0;
+				else if (maxlog < mp->m_blkbit_log)
+					maxblocks = 1;
+				else
+					maxblocks = 2 << (maxlog - mp->m_blkbit_log);
+
+				/*
+				 * We need to check bbno + i + maxblocks down to
+				 * bbno + i. We already checked bbno down to
+				 * bbno + j + 1, so we don't need to check those
+				 * again.
+				 */
+				j = min(i + maxblocks, j);
 				for (; j >= i; j--) {
 					error = xfs_rtallocate_extent_block(args,
 							bbno + j, minlen,

