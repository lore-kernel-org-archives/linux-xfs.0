Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAABC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 21:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiCQVWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 17:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiCQVWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 17:22:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D428FDC2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 14:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90FCCB8200A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 21:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3211FC340E9;
        Thu, 17 Mar 2022 21:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647552078;
        bh=cDTgLB0AEoWwQgkpeG6E9njZZmjZtibAiYYCh0rV2z8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DERiDHMLXRAxhlLIOEtTVtXmA2qp8lZjPl1rcE3DFnqtnXRHkzsp5KvQUOsy7u1rL
         J4P8qutC8lTQdVMMsCfNsRunaUHy6kXs75OE6L01V2VMDuJ+suoFAYcMP8amUftB6A
         xKodxOOiuWj3CVHqnOgYosZuEWjB+dPO/FUVDnV7NYJL5LVJSj6LlHQSzV9bYN/JWG
         xJ9PmYoz6tnRZweymVwl3FW6mGTEu5VwQfGXLfL297C6RixJ0HEB/p1lD3LhqxkNWM
         fWqNnN8+KuIhCul51smFx4yF4cJthJCdLovoNbT6w5tLtaLba/LgzUmTDkZ6DZXjNb
         CTfTlvK0v6h6g==
Subject: [PATCH 4/6] xfs: fix infinite loop when reserving free block pool
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Thu, 17 Mar 2022 14:21:17 -0700
Message-ID: <164755207773.4194202.7639088962184690301.stgit@magnolia>
In-Reply-To: <164755205517.4194202.16256634362046237564.stgit@magnolia>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
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
---
 fs/xfs/xfs_fsops.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b71799a3acd3..4076b9004077 100644
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
 		/*
 		 * The reservation pool cannot take space that xfs_mod_fdblocks
 		 * will not give us.
@@ -462,7 +470,7 @@ xfs_reserve_blocks(
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
+	}
 
 	/*
 	 * Update the reserve counters if blocks have been successfully

