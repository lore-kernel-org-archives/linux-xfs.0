Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD23BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356519AbiD0AzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356529AbiD0AzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9347413DC5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41909B8240D
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FF8C385A4;
        Wed, 27 Apr 2022 00:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020724;
        bh=helY6zdcPgYj6ENJ2qdCh4eFVMqVdBCJQcLb/lwb5+w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fR0QVJfIpgfzYnFt/SGnseepAxLMwNpc+ehWlIiBXZrIgrFCwksvxKe1gPkPPjhtn
         dmxuBp/Wt9uNBgh8QG3gmhmwmy9WRXFGddv5E4BYsBVFSn4SmpqOsWwC84DkQV0Cpu
         QPj98ys68g1oNj3IsrGTPnuMW51KQctxsnWx079M+6B/e0E1YtUQMpTR3O17y98aDz
         GULiv74cTk7GEqvtiHbaSM75Krfrwyx/birbUzcgouz++nbQrlECRrwWOsz02SPQZa
         KW3BarRTY9VJ2xCS3YJdvZS32/ZdJShMMA1vNwd9uF6lSBhacpJzKKjZufmt5fDW2P
         UA9nD/MHs/gTQ==
Subject: [PATCH 2/9] xfs: stop artificially limiting the length of bunmap
 calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:52:03 -0700
Message-ID: <165102072359.3922658.10110553526152188988.stgit@magnolia>
In-Reply-To: <165102071223.3922658.5241787533081256670.stgit@magnolia>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit e1a4e37cc7b6, we clamped the length of bunmapi calls on the
data forks of shared files to avoid two failure scenarios: one where the
extent being unmapped is so sparsely shared that we exceed the
transaction reservation with the sheer number of refcount btree updates
and EFI intent items; and the other where we attach so many deferred
updates to the transaction that we pin the log tail and later the log
head meets the tail, causing the log to livelock.

We avoid triggering the first problem by tracking the number of ops in
the refcount btree cursor and forcing a requeue of the refcount intent
item any time we think that we might be close to overflowing.  This has
been baked into XFS since before the original e1a4 patch.

A recent patchset fixed the second problem by changing the deferred ops
code to finish all the work items created by each round of trying to
complete a refcount intent item, which eliminates the long chains of
deferred items (27dad); and causing long-running transactions to relog
their intent log items when space in the log gets low (74f4d).

Because this clamp affects /any/ unmapping request regardless of the
sharing factors of the component blocks, it degrades the performance of
all large unmapping requests -- whereas with an unshared file we can
unmap millions of blocks in one go, shared files are limited to
unmapping a few thousand blocks at a time, which causes the upper level
code to spin in a bunmapi loop even if it wasn't needed.

This also eliminates one more place where log recovery behavior can
differ from online behavior, because bunmapi operations no longer need
to requeue.  The fstest generic/447 was created to test the old fix, and
it still passes with this applied.

Partial-revert-of: e1a4e37cc7b6 ("xfs: try to avoid blowing out the transaction reservation when bunmaping a shared extent")
Depends: 27dada070d59 ("xfs: change the order in which child and parent defer ops ar finished")
Depends: 74f4d6a1e065 ("xfs: only relog deferred intent items if free space in the log gets low")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 24462bdfd8e7..6833110d1bd4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5280,7 +5280,6 @@ __xfs_bunmapi(
 	int			whichfork;	/* data or attribute fork */
 	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
-	xfs_fileoff_t		max_len;
 	xfs_fileoff_t		end;
 	struct xfs_iext_cursor	icur;
 	bool			done = false;
@@ -5299,16 +5298,6 @@ __xfs_bunmapi(
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
 
-	/*
-	 * Guesstimate how many blocks we can unmap without running the risk of
-	 * blowing out the transaction with a mix of EFIs and reflink
-	 * adjustments.
-	 */
-	if (tp && xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK)
-		max_len = min(len, xfs_refcount_max_unmap(tp->t_log_res));
-	else
-		max_len = len;
-
 	error = xfs_iread_extents(tp, ip, whichfork);
 	if (error)
 		return error;
@@ -5347,7 +5336,7 @@ __xfs_bunmapi(
 
 	extno = 0;
 	while (end != (xfs_fileoff_t)-1 && end >= start &&
-	       (nexts == 0 || extno < nexts) && max_len > 0) {
+	       (nexts == 0 || extno < nexts)) {
 		/*
 		 * Is the found extent after a hole in which end lives?
 		 * Just back up to the previous extent, if so.
@@ -5381,14 +5370,6 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
-		/* How much can we safely unmap? */
-		if (max_len < del.br_blockcount) {
-			del.br_startoff += del.br_blockcount - max_len;
-			if (!wasdel)
-				del.br_startblock += del.br_blockcount - max_len;
-			del.br_blockcount = max_len;
-		}
-
 		if (!isrt)
 			goto delete;
 
@@ -5524,7 +5505,6 @@ __xfs_bunmapi(
 		if (error)
 			goto error0;
 
-		max_len -= del.br_blockcount;
 		end = del.br_startoff - 1;
 nodelete:
 		/*

