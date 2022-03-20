Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D75C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Mar 2022 16:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbiCTQpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 12:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245510AbiCTQpW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 12:45:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E30D2DD5A
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 09:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D44A0B80EE0
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF3C340E9;
        Sun, 20 Mar 2022 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647794635;
        bh=QSGAK/fIcjfoiDBSgxWqWxeF8D6ga3o+2AK4De7MXfE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y4WXdVMt7bc6+y5DqYvGWE8QLjGgcSM29u8fUmjqKUZRbObzP1JEuEQA5KY6Hcck1
         naEKpdHxBXPI5hP2uSIwxxp55GbjTOjv6fgVFiHhiamM7NFXkrZlp7kJYrnduuC3CF
         OvgIXF8MRr7Y7A/2FQYY1g0KW+tI+6PRdKwQrvCdSexunJyBSFrerqLnM6oL/4zdnJ
         BAELR4hgPVFwqfyDMV3pFgsCEshgZW8lwXXJRpfj3xeFws1kxWXOy44fGAY5SeLKRX
         /9SILvamj0OqwekoonVIq3urBcQ+2nXoCwU1MDQBmUJNxlKObuhuyxnPvEv/hFHVFZ
         4H/iVfBy08MZQ==
Subject: [PATCH 5/6] xfs: don't report reserved bnobt space as available
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 20 Mar 2022 09:43:55 -0700
Message-ID: <164779463505.550479.1031616651852906518.stgit@magnolia>
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

On a modern filesystem, we don't allow userspace to allocate blocks for
data storage from the per-AG space reservations, the user-controlled
reservation pool that prevents ENOSPC in the middle of internal
operations, or the internal per-AG set-aside that prevents ENOSPC.
Since we now consider free space btree blocks as unavailable for
allocation for data storage, we shouldn't report those blocks via statfs
either.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |    2 +-
 fs/xfs/xfs_super.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 615334e4f689..863e6389c6ff 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -347,7 +347,7 @@ xfs_fs_counts(
 	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
 	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
 	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
+						xfs_fdblocks_unavailable(mp);
 
 	spin_lock(&mp->m_sb_lock);
 	cnt->freertx = mp->m_sb.sb_frextents;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d84714e4e46a..54be9d64093e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -815,7 +815,8 @@ xfs_fs_statfs(
 	spin_unlock(&mp->m_sb_lock);
 
 	/* make sure statp->f_bfree does not underflow */
-	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
+	statp->f_bfree = max_t(int64_t, 0,
+				fdblocks - xfs_fdblocks_unavailable(mp));
 	statp->f_bavail = statp->f_bfree;
 
 	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);

