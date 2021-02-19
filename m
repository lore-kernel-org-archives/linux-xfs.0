Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A2BC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 17:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8344264E67
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 17:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhBSRYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 12:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhBSRYX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Feb 2021 12:24:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 728EA64E04;
        Fri, 19 Feb 2021 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613755422;
        bh=3jw7ac55Q9GY23ywF1Kib14FSrqU8BwskpDoC/a9nVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c7twZjcwcBcUON9F5njFLtAHUQuZ6HILMaPSAIocydsHKeAOtlleSi8T80wxFYUsa
         4F+agtzEE3tjZxNDRUhA/awlv/WyXFB/V+EvmrUPzgIYvXcluc0of9/CDlaEn4Ehm2
         lw90f/QMwppr/ftiry4jjuBFSDb76bVQnmj071oms+UQmjg1V3valgke3JT5F732IB
         NDL/LCE4K31Ah+r3kMmLNmfaBJhgVM+/Vy9x3xFvOT4c7tQe1c6UZAOHE7pLCtJP3C
         g31GLeJjgfhRP+GOr8gtE/1ELB92z5wgDwz6Ly0RhsvrSTF4pzYZC+d4a1GdhTONMQ
         fPpf82KbToW8A==
Date:   Fri, 19 Feb 2021 09:23:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs: don't nest transactions when scanning for eofblocks
Message-ID: <20210219172341.GD7193@magnolia>
References: <20210219042940.GB7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219042940.GB7193@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Brian Foster reported a lockdep warning on xfs/167:

============================================
WARNING: possible recursive locking detected
5.11.0-rc4 #35 Tainted: G        W I
--------------------------------------------
fsstress/17733 is trying to acquire lock:
ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_free_eofblocks+0x104/0x1d0 [xfs]

but task is already holding lock:
ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_trans_alloc_inode+0x5f/0x160 [xfs]

stack backtrace:
CPU: 38 PID: 17733 Comm: fsstress Tainted: G        W I       5.11.0-rc4 #35
Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
Call Trace:
 dump_stack+0x8b/0xb0
 __lock_acquire.cold+0x159/0x2ab
 lock_acquire+0x116/0x370
 xfs_trans_alloc+0x1ad/0x310 [xfs]
 xfs_free_eofblocks+0x104/0x1d0 [xfs]
 xfs_blockgc_scan_inode+0x24/0x60 [xfs]
 xfs_inode_walk_ag+0x202/0x4b0 [xfs]
 xfs_inode_walk+0x66/0xc0 [xfs]
 xfs_trans_alloc+0x160/0x310 [xfs]
 xfs_trans_alloc_inode+0x5f/0x160 [xfs]
 xfs_alloc_file_space+0x105/0x300 [xfs]
 xfs_file_fallocate+0x270/0x460 [xfs]
 vfs_fallocate+0x14d/0x3d0
 __x64_sys_fallocate+0x3e/0x70
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The cause of this is the new code that spurs a scan to garbage collect
speculative preallocations if we fail to reserve enough blocks while
allocating a transaction.  While the warning itself is a fairly benign
lockdep complaint, it does expose a potential livelock if the rwsem
behavior ever changes with regards to nesting read locks when someone's
waiting for a write lock.

Fix this by freeing the transaction and jumping back to xfs_trans_alloc
like this patch in the V4 submission[1].

[1] https://lore.kernel.org/linux-xfs/161142798066.2171939.9311024588681972086.stgit@magnolia/

Fixes: a1a7d05a0576 ("xfs: flush speculative space allocations when we run out of space")
Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: fix commit message
---
 fs/xfs/xfs_trans.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 44f72c09c203..377f3961d7ed 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -260,6 +260,7 @@ xfs_trans_alloc(
 	struct xfs_trans	**tpp)
 {
 	struct xfs_trans	*tp;
+	bool			want_retry = true;
 	int			error;
 
 	/*
@@ -267,6 +268,7 @@ xfs_trans_alloc(
 	 * GFP_NOFS allocation context so that we avoid lockdep false positives
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
+retry:
 	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
@@ -289,7 +291,9 @@ xfs_trans_alloc(
 	tp->t_firstblock = NULLFSBLOCK;
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
-	if (error == -ENOSPC) {
+	if (error == -ENOSPC && want_retry) {
+		xfs_trans_cancel(tp);
+
 		/*
 		 * We weren't able to reserve enough space for the transaction.
 		 * Flush the other speculative space allocations to free space.
@@ -297,8 +301,11 @@ xfs_trans_alloc(
 		 * other locks.
 		 */
 		error = xfs_blockgc_free_space(mp, NULL);
-		if (!error)
-			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+		if (error)
+			return error;
+
+		want_retry = false;
+		goto retry;
 	}
 	if (error) {
 		xfs_trans_cancel(tp);
