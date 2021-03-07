Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEFBC433E6
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 20:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D6465166
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 20:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhCGU0H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 15:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232869AbhCGU0D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Mar 2021 15:26:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1587065167;
        Sun,  7 Mar 2021 20:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615148763;
        bh=ZS9NOBvBR9f8TybCq716fQ3WJNwDXvoCEpC/6WHW6ag=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uK4yC9vXLplC0KryYY+WQ7+Y0z/klnvvfavPfbJksIYSOUNFGrI1cvHAEAo18y3sL
         URz6ySCZkVewX5Nwhh3q4kcjJQuh5048Q+ou85UHZg3grYGBYqpnBn0bD15yCBY7r3
         vs0sXPTOK2v9wxLcqZbF7RgJXMXsXiCtPVJTwN4RNP07Puzm01DAGDoiT0l9Zp8vxe
         fxh5R1oHtgiI6UJoIjlYFtP7xc2Ec7ISD0bCbthn69e7ridUooB9sQU+jD0axnmwPY
         VAd+FOuvVOV50q29gi9+zGBpgCdlDaBQHA5FB2VxQvcgf/zGStU/TNFnKw0eh3x6sN
         3bpBog4ROYcdQ==
Subject: [PATCH 4/4] xfs: drop freeze protection when running GETFSMAP
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Date:   Sun, 07 Mar 2021 12:26:02 -0800
Message-ID: <161514876275.698643.12226309352552265069.stgit@magnolia>
In-Reply-To: <161514874040.698643.2749449122589431232.stgit@magnolia>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A recent log refactoring patchset from Brian Foster relaxed fsfreeze
behavior with regards to the buffer cache -- now freeze only waits for
pending buffer IO to finish, and does not try to drain the buffer cache
LRU.  As a result, fsfreeze should no longer stall indefinitely while
fsmap runs.  Drop the sb_start_write calls around fsmap invocations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 9ce5e7d5bf8f..34f2b971ce43 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -904,14 +904,6 @@ xfs_getfsmap(
 	info.fsmap_recs = fsmap_recs;
 	info.head = head;
 
-	/*
-	 * If fsmap runs concurrently with a scrub, the freeze can be delayed
-	 * indefinitely as we walk the rmapbt and iterate over metadata
-	 * buffers.  Freeze quiesces the log (which waits for the buffer LRU to
-	 * be emptied) and that won't happen while we're reading buffers.
-	 */
-	sb_start_write(mp->m_super);
-
 	/* For each device we support... */
 	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
 		/* Is this device within the range the user asked for? */
@@ -934,6 +926,11 @@ xfs_getfsmap(
 		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
 			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
 
+		/*
+		 * Grab an empty transaction so that we can use its recursive
+		 * buffer locking abilities to detect cycles in the rmapbt
+		 * without deadlocking.
+		 */
 		error = xfs_trans_alloc_empty(mp, &tp);
 		if (error)
 			break;
@@ -951,7 +948,6 @@ xfs_getfsmap(
 
 	if (tp)
 		xfs_trans_cancel(tp);
-	sb_end_write(mp->m_super);
 	head->fmh_oflags = FMH_OF_DEV_T;
 	return error;
 }

