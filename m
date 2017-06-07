Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbdFGK47 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Jun 2017 06:56:59 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CB6FC04B31B
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2017 10:56:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D5DA62926
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2017 10:56:58 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix spurious spin_is_locked() assert failures on non-smp kernels
Date: Wed,  7 Jun 2017 06:56:57 -0400
Message-Id: <1496833017-63787-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The 0-day kernel test robot reports assertion failures on
!CONFIG_SMP kernels due to failed spin_is_locked() checks. As it
turns out, spin_is_locked() is hardcoded to return zero on
!CONFIG_SMP kernels and so this function cannot be relied on to
verify spinlock state in this configuration.

To avoid this problem, update the associated asserts to fail only
when CONFIG_SMP is enabled in the kernel. Note that this is not
necessary for one assert that expects a zero return from
spin_is_locked(). Update this assert anyways for consistency and
future proofing.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Darrick,

FYI, this one applies on top of Linus' latest 4.12.0-rc4 tree as that is where
the particular assert that the 0-day test tripped over is. Otherwise this
suppresses these assert failures on some quick !SMP tests and survives some
overnight sanity testing on my normal (SMP) test box. Thanks!

Brian

 fs/xfs/xfs_buf.c    | 2 +-
 fs/xfs/xfs_icache.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 07b77b7..d60f917 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -117,7 +117,7 @@ static inline void
 __xfs_buf_ioacct_dec(
 	struct xfs_buf	*bp)
 {
-	ASSERT(spin_is_locked(&bp->b_lock));
+	ASSERT(spin_is_locked(&bp->b_lock) || !IS_ENABLED(CONFIG_SMP));
 
 	if (bp->b_state & XFS_BSTATE_IN_FLIGHT) {
 		bp->b_state &= ~XFS_BSTATE_IN_FLIGHT;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f61c84f8..5cecb36 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -66,7 +66,7 @@ xfs_inode_alloc(
 
 	XFS_STATS_INC(mp, vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(!spin_is_locked(&ip->i_flags_lock) || !IS_ENABLED(CONFIG_SMP));
 	ASSERT(!xfs_isiflocked(ip));
 	ASSERT(ip->i_ino == 0);
 
@@ -190,7 +190,7 @@ xfs_perag_set_reclaim_tag(
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	ASSERT(spin_is_locked(&pag->pag_ici_lock));
+	ASSERT(spin_is_locked(&pag->pag_ici_lock) || !IS_ENABLED(CONFIG_SMP));
 	if (pag->pag_ici_reclaimable++)
 		return;
 
@@ -212,7 +212,7 @@ xfs_perag_clear_reclaim_tag(
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	ASSERT(spin_is_locked(&pag->pag_ici_lock));
+	ASSERT(spin_is_locked(&pag->pag_ici_lock) || !IS_ENABLED(CONFIG_SMP));
 	if (--pag->pag_ici_reclaimable)
 		return;
 
-- 
2.7.5

