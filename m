Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3953EC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Mar 2022 16:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbiCTQpQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 12:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiCTQpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 12:45:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E1828998
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 09:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24EE7B80EDE
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09D2C340E9;
        Sun, 20 Mar 2022 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647794629;
        bh=fYj3WQrF+NCVtiB2NH+2Pa4fypp4Z8XqpAMCTDfkvlg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NfsXuFIIMCbN3/9Fir4hHpZSgwgdwQutzgWDclkQKBXFOkxoyWaTrvUeLn13AcVHy
         8b7GmpFPVlLFUux4CcK65IGQcQDtkDS/wqs7XJNvHKhq13KSRPWPQX1tpOCr5u9m1O
         22hRfbHbcUaLYQEIA4cUQ1GcyUNfry/nREGuQMnYhvZAAw4CPkvQmJjT3Yq3gcOD6J
         WF6kLgqErVOzJCv2SFdd1jZ2KiExXAD8RO+FyuxuiLxLIIQhyZyu8AUnZe+dcl4/Gr
         YIJ4MVMbkXjmopoAHfI3YIRZBiNYF+oWTNYtMeMHT2/Y3vvjLgTQ3waR5iiHBAg/vT
         RUupwVFQhkh8w==
Subject: [PATCH 4/6] xfs: fix infinite loop when reserving free block pool
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 20 Mar 2022 09:43:49 -0700
Message-ID: <164779462946.550479.3987400627869935198.stgit@magnolia>
In-Reply-To: <164779460699.550479.5112721232994728564.stgit@magnolia>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't spin in an infinite loop trying to reserve blocks -- if we can't
do it after 30 tries, we're racing with a nearly full filesystem, so
just give up.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fsops.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 710e857bb825..615334e4f689 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -379,6 +379,7 @@ xfs_reserve_blocks(
 	int64_t			fdblks_delta = 0;
 	uint64_t		request;
 	int64_t			free;
+	unsigned int		tries;
 	int			error = 0;
 
 	/* If inval is null, report current values and return */
@@ -430,9 +431,16 @@ xfs_reserve_blocks(
 	 * If the request is larger than the current reservation, reserve the
 	 * blocks before we update the reserve counters. Sample m_fdblocks and
 	 * perform a partial reservation if the request exceeds free space.
+	 *
+	 * The loop body estimates how many blocks it can request from fdblocks
+	 * to stash in the reserve pool.  This is a classic TOCTOU race since
+	 * fdblocks updates are not always coordinated via m_sb_lock.  We also
+	 * cannot tell if @free remaining unchanged between iterations is due
+	 * to an idle system or freed blocks being consumed immediately, so
+	 * we'll try a finite number of times to satisfy the request.
 	 */
 	error = -ENOSPC;
-	do {
+	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
 		free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
 		if (free <= 0)
@@ -459,7 +467,7 @@ xfs_reserve_blocks(
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
+	}
 
 	/*
 	 * Update the reserve counters if blocks have been successfully

