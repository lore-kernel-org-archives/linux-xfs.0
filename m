Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB238CDB482
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344137AbjJQPzO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344211AbjJQPzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:55:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70860F1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:55:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBB2C433C8;
        Tue, 17 Oct 2023 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697558112;
        bh=+NyOhhJnGCxGZyYVmt4WNFya/oXb+BXe5wf++bwiFC4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uI7w5hEdp6+aCYTOJXjzinJcavZmLtlQlOVsz/xTg8XRvk0xHL/1uJa/RumYtXHUq
         G8fTv6zAXqC/va48vijX5phrQxcGEEDLJ/4j9qjeuf/3pzQjCrNwYWwM9f26GM0xMW
         t60kratnULy1N3PUNoXOVILcsv/uQEWxLDrNRN04pwu+H1IRGzOGsEFs9FgcjR5Jch
         42lxLwcPv7VaJiexg55dhsJS0UyNszD77Dsj5PCp0Wpjh+XrzXJsx/uQvCcKcJp+0W
         h7f/khBC2owcZTK+QFKJpUrJRV/9Baw9lX/Srvf6SmVriNlJLXtb6QipVrMt2rFEMZ
         r6p9awpSaA3cw==
Date:   Tue, 17 Oct 2023 08:55:10 -0700
Subject: [PATCH 5/7] xfs: limit maxlen based on available space in
 xfs_rtallocate_extent_near()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@fb.com, osandov@osandov.com, linux-xfs@vger.kernel.org,
        hch@lst.de
Message-ID: <169755742658.3167911.15145419272250501679.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

xfs_rtallocate_extent_near() calls xfs_rtallocate_extent_block() with
the minlen and maxlen that were passed to it.
xfs_rtallocate_extent_block() then scans the bitmap block looking for a
free range of size maxlen. If there is none, it has to scan the whole
bitmap block before returning the largest range of at least size minlen.
For a fragmented realtime device and a large allocation request, it's
almost certain that this will have to search the whole bitmap block,
leading to high CPU usage.

However, the realtime summary tells us the maximum size available in the
bitmap block. We can limit the search in xfs_rtallocate_extent_block()
to that size and often stop before scanning the whole bitmap block.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9003acad590d..5f94407925ad 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -497,6 +497,9 @@ xfs_rtallocate_extent_near(
 		 * allocating one.
 		 */
 		if (maxlog >= 0) {
+			xfs_extlen_t maxavail =
+				min_t(xfs_rtblock_t, maxlen,
+				      (1ULL << (maxlog + 1)) - 1);
 			/*
 			 * On the positive side of the starting location.
 			 */
@@ -506,7 +509,7 @@ xfs_rtallocate_extent_near(
 				 * this block.
 				 */
 				error = xfs_rtallocate_extent_block(args,
-						bbno + i, minlen, maxlen, len,
+						bbno + i, minlen, maxavail, len,
 						&n, prod, &r);
 				if (error) {
 					return error;
@@ -553,7 +556,7 @@ xfs_rtallocate_extent_near(
 						continue;
 					error = xfs_rtallocate_extent_block(args,
 							bbno + j, minlen,
-							maxlen, len, &n, prod,
+							maxavail, len, &n, prod,
 							&r);
 					if (error) {
 						return error;
@@ -575,7 +578,7 @@ xfs_rtallocate_extent_near(
 				 * that we found.
 				 */
 				error = xfs_rtallocate_extent_block(args,
-						bbno + i, minlen, maxlen, len,
+						bbno + i, minlen, maxavail, len,
 						&n, prod, &r);
 				if (error) {
 					return error;

