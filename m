Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546D6C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 17:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiGSRDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 13:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbiGSRD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 13:03:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0242F57E35
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 10:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97586B81C53
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 17:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F474C341C6;
        Tue, 19 Jul 2022 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658250205;
        bh=RTkU9GHKfsA0t+1/X8rETWmHFr++1KJ+pGSvOgnbN1U=;
        h=Date:From:To:Cc:Subject:From;
        b=gCD+/MzAfAvCuv3AD3jKQUqnN/IjCwCIkB+9skEozIUalefPuPpX1XbxGWFKO5RfH
         XE5XQAHfboRHpTNtybuQ5rCKjyFJ4csvq3TjZajQzjn9TPba+8XAfYETsUDZJeiJoU
         kkVRgPf+xJC/ixYMebmBGeqRxQ49NiBqFXrGuyMnoH5Dppm/OS9QFfEaa7TqoeAaXv
         l+0X7J3txP/yyMJXQPJ+4cs87Iz7rmJT9/TDWp/ceJZG4Crf/akXLnN7Kh37U5z8ip
         PWb4CXxnDhYY4L06E6EdIB98VlmHRMTII8Mc3/PVpcxpCCh8vjVt5sRycA9jl75Y2n
         wR88p6hMrl/EQ==
Date:   Tue, 19 Jul 2022 10:03:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: don't leak memory when attr fork loading fails
Message-ID: <Ytbj3C3GF6aQJjo4@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I observed the following evidence of a memory leak while running xfs/399
from the xfs fsck test suite (edited for brevity):

XFS (sde): Metadata corruption detected at xfs_attr_shortform_verify_struct.part.0+0x7b/0xb0 [xfs], inode 0x1172 attr fork
XFS: Assertion failed: ip->i_af.if_u1.if_data == NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 315
------------[ cut here ]------------
WARNING: CPU: 2 PID: 91635 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
CPU: 2 PID: 91635 Comm: xfs_scrub Tainted: G        W         5.19.0-rc7-xfsx #rc7 6e6475eb29fd9dda3181f81b7ca7ff961d277a40
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x46/0x4a [xfs]
Call Trace:
 <TASK>
 xfs_ifork_zap_attr+0x7c/0xb0
 xfs_iformat_attr_fork+0x86/0x110
 xfs_inode_from_disk+0x41d/0x480
 xfs_iget+0x389/0xd70
 xfs_bulkstat_one_int+0x5b/0x540
 xfs_bulkstat_iwalk+0x1e/0x30
 xfs_iwalk_ag_recs+0xd1/0x160
 xfs_iwalk_run_callbacks+0xb9/0x180
 xfs_iwalk_ag+0x1d8/0x2e0
 xfs_iwalk+0x141/0x220
 xfs_bulkstat+0x105/0x180
 xfs_ioc_bulkstat.constprop.0.isra.0+0xc5/0x130
 xfs_file_ioctl+0xa5f/0xef0
 __x64_sys_ioctl+0x82/0xa0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

This newly-added assertion checks that there aren't any incore data
structures hanging off the incore fork when we're trying to reset its
contents.  From the call trace, it is evident that iget was trying to
construct an incore inode from the ondisk inode, but the attr fork
verifier failed and we were trying to undo all the memory allocations
that we had done earlier.

The three assertions in xfs_ifork_zap_attr check that the caller has
already called xfs_idestroy_fork, which clearly has not been done here.
As the zap function then zeroes the pointers, we've effectively leaked
the memory.

The shortest change would have been to insert an extra call to
xfs_idestroy_fork, but it makes more sense to bundle the _idestroy_fork
call into _zap_attr, since all other callsites call _idestroy_fork
immediately prior to calling _zap_attr.  IOWs, it eliminates one way to
fail.

Note: This change only applies cleanly to 2ed5b09b3e8f, since we just
reworked the attr fork lifetime.  However, I think this memory leak has
existed since 0f45a1b20cd8, since the chain xfs_iformat_attr_fork ->
xfs_iformat_local -> xfs_init_local_fork will allocate
ifp->if_u1.if_data, but if xfs_ifork_verify_local_attr fails,
xfs_iformat_attr_fork will free i_afp without freeing any of the stuff
hanging off i_afp.  The solution for older kernels I think is to add the
missing call to xfs_idestroy_fork just prior to calling kmem_cache_free.

Found by fuzzing a.sfattr.hdr.totsize = lastbit in xfs/399.

Fixes: 2ed5b09b3e8f ("xfs: make inode attribute forks a permanent part of struct xfs_inode")
Probably-Fixes: 0f45a1b20cd8 ("xfs: improve local fork verification")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |    1 -
 fs/xfs/libxfs/xfs_inode_fork.c |    5 +----
 fs/xfs/xfs_attr_inactive.c     |    1 -
 fs/xfs/xfs_icache.c            |    1 -
 4 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5bd554b88d99..beee51ad75ce 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -799,7 +799,6 @@ xfs_attr_fork_remove(
 {
 	ASSERT(ip->i_af.if_nextents == 0);
 
-	xfs_idestroy_fork(&ip->i_af);
 	xfs_ifork_zap_attr(ip);
 	ip->i_forkoff = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index fa699f3792bf..9327a4f39206 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -290,10 +290,7 @@ void
 xfs_ifork_zap_attr(
 	struct xfs_inode	*ip)
 {
-	ASSERT(ip->i_af.if_broot == NULL);
-	ASSERT(ip->i_af.if_u1.if_data == NULL);
-	ASSERT(ip->i_af.if_height == 0);
-
+	xfs_idestroy_fork(&ip->i_af);
 	memset(&ip->i_af, 0, sizeof(struct xfs_ifork));
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 }
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 895ba8b7a26c..5db87b34fb6e 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -385,7 +385,6 @@ xfs_attr_inactive(
 	xfs_trans_cancel(trans);
 out_destroy_fork:
 	/* kill the in-core attr fork before we drop the inode lock */
-	xfs_idestroy_fork(&dp->i_af);
 	xfs_ifork_zap_attr(dp);
 	if (lock_mode)
 		xfs_iunlock(dp, lock_mode);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1f07b5b8ba3f..e3b2304bb4d2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -133,7 +133,6 @@ xfs_inode_free_callback(
 		break;
 	}
 
-	xfs_idestroy_fork(&ip->i_af);
 	xfs_ifork_zap_attr(ip);
 
 	if (ip->i_cowfp) {
