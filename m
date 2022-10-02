Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB6BC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJBShx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJBShw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:37:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1873C141
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C850B80D88
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C0CC433C1;
        Sun,  2 Oct 2022 18:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735869;
        bh=Ff+PzEQi81SEz7dDIcNFIb6zqlxVpNJvBTp5ukh9zO8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SSJwzf6Ub9prOdpVx85F8WgfdRcB90lFcVuvjOWU0leIoZJJGAXaGUEm39T6FHNPz
         8UYX476sxaPNLBoMOcdPH5hEkkwj9B1ZP5BPctMPweqKSzm1JevA3abHczJ4/8l2a+
         zqT8xSl9XkkO+tPFfE6PvXwEi2h3NLN77t57THa+VHYpvLGP0kVhPND4f2466ve/Jx
         4M7tP4xdRsQkioMbqK5ey3r/P8pi+N5ioS63/h8UBdOluH1ih1usZX+7f+B6B9JK7p
         eVOhR9q16HLbEOPUEsry5a3Xt+Cvc9UdLW2wVndd6eEB9BNhiw85uoSPUKxlRLcqyI
         09ly9mkMeH0PQ==
Subject: [PATCH 8/9] xfs: clean up xattr scrub initialization
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:41 -0700
Message-ID: <166473484107.1085108.12782439057163728511.stgit@magnolia>
In-Reply-To: <166473483982.1085108.101544412199880535.stgit@magnolia>
References: <166473483982.1085108.101544412199880535.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up local variable initialization and error returns in xchk_xattr.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 23c559c4ce80..f6eb6070488b 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -554,7 +554,16 @@ int
 xchk_xattr(
 	struct xfs_scrub		*sc)
 {
-	struct xchk_xattr		sx;
+	struct xchk_xattr		sx = {
+		.sc			= sc,
+		.context		= {
+			.dp		= sc->ip,
+			.tp		= sc->tp,
+			.resynch	= 1,
+			.put_listent	= xchk_xattr_listent,
+			.allow_incomplete = true,
+		},
+	};
 	xfs_dablk_t			last_checked = -1U;
 	int				error = 0;
 
@@ -575,22 +584,13 @@ xchk_xattr(
 		error = xchk_da_btree(sc, XFS_ATTR_FORK, xchk_xattr_rec,
 				&last_checked);
 	if (error)
-		goto out;
+		return error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		goto out;
-
-	/* Check that every attr key can also be looked up by hash. */
-	memset(&sx, 0, sizeof(sx));
-	sx.context.dp = sc->ip;
-	sx.context.resynch = 1;
-	sx.context.put_listent = xchk_xattr_listent;
-	sx.context.tp = sc->tp;
-	sx.context.allow_incomplete = true;
-	sx.sc = sc;
+		return 0;
 
 	/*
-	 * Look up every xattr in this file by name.
+	 * Look up every xattr in this file by name and hash.
 	 *
 	 * Use the backend implementation of xfs_attr_list to call
 	 * xchk_xattr_listent on every attribute key in this inode.
@@ -607,11 +607,11 @@ xchk_xattr(
 	 */
 	error = xfs_attr_list_ilocked(&sx.context);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
-		goto out;
+		return error;
 
 	/* Did our listent function try to return any errors? */
 	if (sx.context.seen_enough < 0)
-		error = sx.context.seen_enough;
-out:
-	return error;
+		return sx.context.seen_enough;
+
+	return 0;
 }

