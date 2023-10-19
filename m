Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB46CDB483
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjJSQaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbjJSQa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:30:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7EA11D
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:30:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7521BC433C8;
        Thu, 19 Oct 2023 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697733025;
        bh=6vv3xVqJpajTXx3S+iwxB0KeYu60hx+uePFok+0jkao=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=JGaqM6GDbqdDLynqpA402nkGmwkCZkbaaF9Ll3mgvLQEvigytHel6JUppjaVyAPjk
         7lMFrbFzPNKBU56qk0NpLDBp3Nw3nnhl8Ecm97E1P4nUio7ODRXEcJF/8QuEMVxtaM
         kVXlcAOo6+3we6hm6Sc4dkzoZkM4c74j2GEyBe8qm7xL90EFd8OYxhHGTagEpceCii
         uXWlQ0rD8DtfXaNAsyWgyG2lDGsfIKWrwqOPln+h8uqsY38b3zUS+fIGalMKi+5PgT
         joARsNy0unjH9K1dMynw61TsosQvmU+OtVygnE6Q8dFCZBCoDohMsbX+CDVEF8Mx+t
         DKTw+oCnFEttQ==
Date:   Thu, 19 Oct 2023 09:30:25 -0700
Subject: [PATCH 7/9] xfs: limit maxlen based on available space in
 xfs_rtallocate_extent_near()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, osandov@osandov.com, osandov@fb.com,
        hch@lst.de
Message-ID: <169773211832.225862.8392993672373111972.stgit@frogsfrogsfrogs>
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

