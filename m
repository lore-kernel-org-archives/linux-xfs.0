Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB26C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Mar 2022 16:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbiC0RAd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Mar 2022 13:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbiC0RAa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Mar 2022 13:00:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E783527F
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 09:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76FD9610A6
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 16:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37AAC340EC;
        Sun, 27 Mar 2022 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648400330;
        bh=KwVg5xgXTEC0LmaSEuKrgNvZJnLKQECmltIheHZRis0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RasNF5cMxq81EsPf/4xzOdEiSnFXnl/Iomtvg01D8J5HEfC7jo5h6pEKcz4wnK8Ob
         TEwRChbZeaXVRUDlwuO5/00SCIxPLVyJzawGEft4S0Z/cU7yoUPWVXynrxA6G5ShJc
         HtYdOGV0D2kBxnyQnT/lT3Cz76luy2EdIYqqvZ7mwcIeKF1j0mT51ggnYF0w2YV/eJ
         cxoa4ES6PY9knED68ZwJPUHtcsl/w6EhK3H+yqUbf1icui0j9VPkDDtSEBcHveKFgX
         R7BnwB7K3zwA9PEM8qqKueuqyw1nXy3XCru3awqguE+X4k0Jl1n2LPmZQ6y/nqHihx
         y1/IZbm2PKMOQ==
Subject: [PATCH 6/6] xfs: don't report reserved bnobt space as available
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 27 Mar 2022 09:58:50 -0700
Message-ID: <164840033043.54920.18407468773094720534.stgit@magnolia>
In-Reply-To: <164840029642.54920.17464512987764939427.stgit@magnolia>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
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
operations, or the internal per-AG set-aside that prevents unwanted
filesystem shutdowns due to ENOSPC during a bmap btree split.

Since we now consider freespace btree blocks as unavailable for
allocation for data storage, we shouldn't report those blocks via statfs
either.  This makes the numbers that we return via the statfs f_bavail
and f_bfree fields a more conservative estimate of actual free space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c |    2 +-
 fs/xfs/xfs_super.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5b5b68affe66..196e2c51309c 100644
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

