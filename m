Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C47C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 21:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiCQVWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 17:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiCQVWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 17:22:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E41A15857B
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 14:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 233A6B81F99
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 21:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7619C340E9;
        Thu, 17 Mar 2022 21:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647552083;
        bh=vuXTfwyMCXLwA4/53OsUr7WwO6LGZBU98yr+14z9zig=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lgf7R4gVFMbd/u2KianzsRq4gsaJr7aEOvAhMVlVkZSk9pIhRLSsW6nmWTDjqetSr
         mWQ0IfYbU5guvtTqNunHDDj1oO+jLO5YpkRdU9Uf1gGo4KWl1RZdQueZRys8MVf4m0
         yh5f8HA4VWLkgLrr1+Rm0O2EsyF7O7YZFH1sckGSD0gxYC773W6Z8goe6cf7qNoncu
         hsBx1Q1c/NnvegtHm7JK8qiLdSRBpc/hWKlsruZldDVEzgnpjw/OJn+Aqis7UVRIHK
         Vq6TOBYZgAkcwu9JV2WgIGF06b8ycZf+6RuyiP8pNquusUmFXTtBS2YU+bYYQb5jFW
         iUti6jyUeH+Yw==
Subject: [PATCH 5/6] xfs: don't report reserved bnobt space as available
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Date:   Thu, 17 Mar 2022 14:21:23 -0700
Message-ID: <164755208338.4194202.6258724683699525828.stgit@magnolia>
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

On a modern filesystem, we don't allow userspace to allocate blocks for
data storage from the per-AG space reservations, the user-controlled
reservation pool that prevents ENOSPC in the middle of internal
operations, or the internal per-AG set-aside that prevents ENOSPC.
Since we now consider free space btree blocks as unavailable for
allocation for data storage, we shouldn't report those blocks via statfs
either.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |    3 +--
 fs/xfs/xfs_mount.h |   13 +++++++++++++
 fs/xfs/xfs_super.c |    4 +---
 3 files changed, 15 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 4076b9004077..b42b8bc55729 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -346,8 +346,7 @@ xfs_fs_counts(
 {
 	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
 	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
-	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
+	cnt->freedata = xfs_fdblocks_available_fast(mp);
 
 	spin_lock(&mp->m_sb_lock);
 	cnt->freertx = mp->m_sb.sb_frextents;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 998b54c3c454..74e9b8558162 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -508,6 +508,19 @@ xfs_fdblocks_available(
 	return free;
 }
 
+/* Same as above, but don't take the slow path. */
+static inline int64_t
+xfs_fdblocks_available_fast(
+	struct xfs_mount	*mp)
+{
+	int64_t			free;
+
+	free = percpu_counter_read_positive(&mp->m_fdblocks);
+	free -= mp->m_alloc_set_aside;
+	free -= atomic64_read(&mp->m_allocbt_blks);
+	return free;
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d84714e4e46a..7b6c147e63c4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -791,7 +791,6 @@ xfs_fs_statfs(
 	uint64_t		fakeinos, id;
 	uint64_t		icount;
 	uint64_t		ifree;
-	uint64_t		fdblocks;
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
@@ -806,7 +805,6 @@ xfs_fs_statfs(
 
 	icount = percpu_counter_sum(&mp->m_icount);
 	ifree = percpu_counter_sum(&mp->m_ifree);
-	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
@@ -815,7 +813,7 @@ xfs_fs_statfs(
 	spin_unlock(&mp->m_sb_lock);
 
 	/* make sure statp->f_bfree does not underflow */
-	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
+	statp->f_bfree = max_t(int64_t, xfs_fdblocks_available(mp), 0);
 	statp->f_bavail = statp->f_bfree;
 
 	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);

