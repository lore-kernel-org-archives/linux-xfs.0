Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCBECDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344086AbjJQPy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344027AbjJQPy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:54:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30A4ED
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:54:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7539AC433C8;
        Tue, 17 Oct 2023 15:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697558095;
        bh=nc8md4rsH/iXTjUTSBsleGK9a7WdUfZjrtxKdiVNoB4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Ip5SvT2lqfF6DKCpCNJHl63qAxwW4u1LjQtwtgGbBOZOtMZgaUqQw35w98ZHBFgxk
         2Bum38cm8el6pweUydWLC/jn/jLhvBJkMgYaQfAaCExsQKqMrxOcMS4I0cjDp8fBfX
         ihT+tYa6Mx2aUnDiRHLT49ViZ02WYjqUBkBdxsXb7tNFJ6u+Tu8dI/neEzobgG141D
         NtteweAihl3bzB5tKozIB/jga8c+crRKQD9D4DzkFnUmvamVChtjk680ACYOQED2cg
         l4+Uml+afDg7M8gWD7jKjhSN5hSpDqsV0CgXeaQGR8bRbjwyxMb0IwiZa8Q5hAY81j
         9XG9SMMMfjT8g==
Date:   Tue, 17 Oct 2023 08:54:55 -0700
Subject: [PATCH 4/7] xfs: return maximum free size from xfs_rtany_summary()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@fb.com, osandov@osandov.com, linux-xfs@vger.kernel.org,
        hch@lst.de
Message-ID: <169755742642.3167911.175459211600127096.stgit@frogsfrogsfrogs>
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
index 336c130fc90f..9003acad590d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -47,7 +47,7 @@ xfs_rtany_summary(
 	int			low,		/* low log2 extent size */
 	int			high,		/* high log2 extent size */
 	xfs_fileoff_t		bbno,		/* bitmap block number */
-	int			*stat)		/* out: any good extents here? */
+	int			*maxlog)	/* out: max log2 extent size free */
 {
 	struct xfs_mount	*mp = args->mount;
 	int			error;		/* error value */
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
 	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
 	struct xfs_mount	*mp = args->mount;
-	int			any;		/* any useful extents from summary */
+	int			maxlog;		/* max useful extent from summary */
 	xfs_fileoff_t		bbno;		/* bitmap block number */
 	int			error;		/* error value */
 	int			i;		/* bitmap block offset (loop control) */
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

