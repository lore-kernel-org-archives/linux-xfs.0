Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A851FCDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 00:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjJSABg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjJSABd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 20:01:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6615A119
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 17:01:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FA6C433C8;
        Thu, 19 Oct 2023 00:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697673690;
        bh=6vv3xVqJpajTXx3S+iwxB0KeYu60hx+uePFok+0jkao=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XgN9+0eyv6BUJl3yoeFXJDQTLcxvoSuHI34tSSdUgCXTASNZ3O8XJf1OCnr7icSkp
         LCF/IRmsodzROXJSCAmktSX9bDy84vkdE1wvZ2Nlz+3irCN7mF1WiP8adA6flOGgMl
         TVayX+Iyg/f/8DBuHjmi6X+NUhvZEiAkmxFdWAiaQS9ZUhx+dgppWfE5KV7zMFaf6T
         nlQDiTFKYIDYwETynrB7/YUUtD4yVzStTcQjHH2Xb+MmAfZbz7GvG3Z0n23iqhgRYc
         9ZnntyUsqhCqp9JWT7fPKoqJ9NhABQULbDpgXcqDmrIgXBBZzx7xng5qrfEAa1XnJm
         EzGZ87gkm201g==
Subject: [PATCH 7/9] xfs: limit maxlen based on available space in
 xfs_rtallocate_extent_near()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@fb.com, linux-xfs@vger.kernel.org, osandov@osandov.com,
        hch@lst.de
Date:   Wed, 18 Oct 2023 17:01:29 -0700
Message-ID: <169767368947.4127997.1529811893671633810.stgit@frogsfrogsfrogs>
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
index c774a4ccdd15..3aa9634a9e76 100644
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

