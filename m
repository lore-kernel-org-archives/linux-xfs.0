Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A22CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjJSQaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjJSQaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:30:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B78811D
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:30:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D75C433C8;
        Thu, 19 Oct 2023 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697733009;
        bh=qEl8dy0NWO606fpPfCIiWFIdCN8Kj5Ua3qqCpUbiNzY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=eCMc6NzFzgxZW7yaiV4EpWZWQU8zOLPwBJ9QWrwx4RX9A8mnUOi1SvsyXiTNmTsAD
         nNdZCFwbZoZLYWIKqPe3pWkxCu/K3Hkkjfz9A00bd7/eBfwve9BQqR5wO1+VhHV/ou
         025bXnnIjG1E1HQKU7y6LxrOG3Ct3iAyGvPAmUtH8VGagWBJhffO0X/I4TNOXDxT79
         dTu+m2qV0sjcAKBKuL4Tcb2vfo1RAsGnnexs4IlgBW06YNc+RxEvU1/Avg3C3CF/IO
         pnJDPADiOvl3swYKL5WlAbxGa/UZP76RzCs8bx3nKNPlpIHmY7lMNZiK0G2+rhlURR
         YVNKkqbW24t8w==
Date:   Thu, 19 Oct 2023 09:30:09 -0700
Subject: [PATCH 6/9] xfs: return maximum free size from xfs_rtany_summary()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, osandov@osandov.com, osandov@fb.com,
        hch@lst.de
Message-ID: <169773211816.225862.16807245833883101795.stgit@frogsfrogsfrogs>
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

