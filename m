Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A22ECDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjJSQaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbjJSQan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:30:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8792E11B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:30:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAC6C433C8;
        Thu, 19 Oct 2023 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697733041;
        bh=W8UQs7cQ0fsWF8IaOh4icITPUxohx6TMKUZSGhMjdw4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=G6A9cSSMWn4D+efKv9fZOCuQX0HRZgB68Y0THlU98ym7+NoA3+zB/9PEkW1g3bha0
         Dcvr7r63VcIF32b3Z907/tn+p9rHi/S/jppvolzn6uYwk1f3RXujmc4XCJyxAqKcYU
         LaOs5rbjPJVnRtSusHl0+28FApauOdFU9xHgmarLOTCf9v34zLOx/aCMg8tn+xayEZ
         TPQy1mDUNsI6kke8lMPnpcNamWYphkH3pQxE6MqMObNei36UrdRe9TCXfd7UIksn+k
         eywiCLPLzlY/WvEdK8wuCkxXiGtxddtHVAwBfrSzJwlruxUvNwuavMvw3weYQnSwq9
         eiNApgQZjp1nA==
Date:   Thu, 19 Oct 2023 09:30:40 -0700
Subject: [PATCH 8/9] xfs: don't try redundant allocations in
 xfs_rtallocate_extent_near()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, osandov@osandov.com, osandov@fb.com,
        hch@lst.de
Message-ID: <169773211847.225862.10218692865813765251.stgit@frogsfrogsfrogs>
In-Reply-To: <169773211712.225862.9408784830071081083.stgit@frogsfrogsfrogs>
References: <169773211712.225862.9408784830071081083.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

xfs_rtallocate_extent_near() tries to find a free extent as close to a
target bitmap block given by bbno as possible, which may be before or
after bbno. Searching backwards has a complication: the realtime summary
accounts for free space _starting_ in a bitmap block, but not straddling
or ending in a bitmap block. So, when the negative search finds a free
extent in the realtime summary, in order to end up closer to the target,
it looks for the end of the free extent. For example, if bbno - 2 has a
free extent, then it will check bbno - 1, then bbno - 2. But then if
bbno - 3 has a free extent, it will check bbno - 1 again, then bbno - 2
again, and then bbno - 3. This results in a quadratic loop, which is
completely pointless since the repeated checks won't find anything new.

Fix it by remembering where we last checked up to and continue from
there. This also obviates the need for a check of the realtime summary.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   54 ++++++--------------------------------------------
 1 file changed, 7 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3aa9634a9e76..b743da885ed6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -477,6 +477,7 @@ xfs_rtallocate_extent_near(
 	}
 	bbno = xfs_rtx_to_rbmblock(mp, start);
 	i = 0;
+	j = -1;
 	ASSERT(minlen != 0);
 	log2len = xfs_highbit32(minlen);
 	/*
@@ -527,33 +528,13 @@ xfs_rtallocate_extent_near(
 			 */
 			else {		/* i < 0 */
 				/*
-				 * Loop backwards through the bitmap blocks from
-				 * the starting point-1 up to where we are now.
-				 * There should be an extent which ends in this
-				 * bitmap block and is long enough.
+				 * Loop backwards through the bitmap blocks
+				 * from where we last checked down to where we
+				 * are now.  There should be an extent which
+				 * ends in this bitmap block and is long
+				 * enough.
 				 */
-				for (j = -1; j > i; j--) {
-					/*
-					 * Grab the summary information for
-					 * this bitmap block.
-					 */
-					error = xfs_rtany_summary(args,
-							log2len,
-							mp->m_rsumlevels - 1,
-							bbno + j, &maxlog);
-					if (error) {
-						return error;
-					}
-					/*
-					 * If there's no extent given in the
-					 * summary that means the extent we
-					 * found must carry over from an
-					 * earlier block.  If there is an
-					 * extent given, we've already tried
-					 * that allocation, don't do it again.
-					 */
-					if (maxlog >= 0)
-						continue;
+				for (; j >= i; j--) {
 					error = xfs_rtallocate_extent_block(args,
 							bbno + j, minlen,
 							maxavail, len, &n, prod,
@@ -569,27 +550,6 @@ xfs_rtallocate_extent_near(
 						return 0;
 					}
 				}
-				/*
-				 * There weren't intervening bitmap blocks
-				 * with a long enough extent, or the
-				 * allocation didn't work for some reason
-				 * (i.e. it's a little * too short).
-				 * Try to allocate from the summary block
-				 * that we found.
-				 */
-				error = xfs_rtallocate_extent_block(args,
-						bbno + i, minlen, maxavail, len,
-						&n, prod, &r);
-				if (error) {
-					return error;
-				}
-				/*
-				 * If it works, return the extent.
-				 */
-				if (r != NULLRTEXTNO) {
-					*rtx = r;
-					return 0;
-				}
 			}
 		}
 		/*

