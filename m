Return-Path: <SRS0=Ja7n=76=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCCBC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 17:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD6B21556
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 17:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mb1P1tdb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgFQRxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 13:53:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24053 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726972AbgFQRxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 13:53:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592416416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=B+UlJ4P87byIkRZMfG/um1z/JjWpEWmUueHIhB4rGvM=;
        b=Mb1P1tdbElepKMRlfZBmUT6/t4wfDnDfEH+r3WyTn+wuEvGU1foBWcBYIBZOz4hIAWk7C/
        wHCy9a06z3KalZvmiSgvbQJ/UPUUBJIVpXPeXLvfHyfxExziQFO8QGclyfrxi939G5tInK
        zmc/rHA+BafLDzE/JGL2J8UQT20KXxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-KawU4X3xMuWXkkwKMo-YEA-1; Wed, 17 Jun 2020 13:53:34 -0400
X-MC-Unique: KawU4X3xMuWXkkwKMo-YEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40AE2107ACCA;
        Wed, 17 Jun 2020 17:53:33 +0000 (UTC)
Received: from llong.com (ovpn-117-167.rdu2.redhat.com [10.10.117.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3FB56ED96;
        Wed, 17 Jun 2020 17:53:31 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v2 2/2] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim
Date:   Wed, 17 Jun 2020 13:53:10 -0400
Message-Id: <20200617175310.20912-3-longman@redhat.com>
In-Reply-To: <20200617175310.20912-1-longman@redhat.com>
References: <20200617175310.20912-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Depending on the workloads, the following circular locking dependency
warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
lock) may show up:

======================================================
WARNING: possible circular locking dependency detected
5.0.0-rc1+ #60 Tainted: G        W
------------------------------------------------------
fsfreeze/4346 is trying to acquire lock:
0000000026f1d784 (fs_reclaim){+.+.}, at:
fs_reclaim_acquire.part.19+0x5/0x30

but task is already holding lock:
0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650

which lock already depends on the new lock.
  :
 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(sb_internal);
                               lock(fs_reclaim);
                               lock(sb_internal);
  lock(fs_reclaim);

 *** DEADLOCK ***

4 locks held by fsfreeze/4346:
 #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
 #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
 #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
 #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650

stack backtrace:
Call Trace:
 dump_stack+0xe0/0x19a
 print_circular_bug.isra.10.cold.34+0x2f4/0x435
 check_prev_add.constprop.19+0xca1/0x15f0
 validate_chain.isra.14+0x11af/0x3b50
 __lock_acquire+0x728/0x1200
 lock_acquire+0x269/0x5a0
 fs_reclaim_acquire.part.19+0x29/0x30
 fs_reclaim_acquire+0x19/0x20
 kmem_cache_alloc+0x3e/0x3f0
 kmem_zone_alloc+0x79/0x150
 xfs_trans_alloc+0xfa/0x9d0
 xfs_sync_sb+0x86/0x170
 xfs_log_sbcount+0x10f/0x140
 xfs_quiesce_attr+0x134/0x270
 xfs_fs_freeze+0x4a/0x70
 freeze_super+0x1af/0x290
 do_vfs_ioctl+0xedc/0x16c0
 ksys_ioctl+0x41/0x80
 __x64_sys_ioctl+0x73/0xa9
 do_syscall_64+0x18f/0xd23
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

This is a false positive as all the dirty pages are flushed out before
the filesystem can be frozen.

Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
may fix the issue. However, that will greatly complicate the logic and
may not be worth it.

Another way to fix it is to disable the taking of the fs_reclaim
pseudo lock when in the freezing code path as a reclaim on the
freezed filesystem is not possible. By using the newly introduced
PF_MEMALLOC_NOLOCKDEP flag, lockdep checking is disabled in
xfs_trans_alloc() if both XFS_TRANS_NO_WRITECOUNT flag and the
frozen flag are set.

In the freezing path, there is another path where memory allocation
is being done without the XFS_TRANS_NO_WRITECOUNT flag:

  xfs_fs_freeze()
  => xfs_quiesce_attr()
     => xfs_log_quiesce()
        => xfs_log_unmount_write()
           => xlog_unmount_write()
              => xfs_log_reserve()
	         => xlog_ticket_alloc()

In this case, we just disable fs reclaim for this particular 600 bytes
memory allocation.

Without this patch, the command sequence below will show that the lock
dependency chain sb_internal -> fs_reclaim exists.

 # fsfreeze -f /home
 # fsfreeze --unfreeze /home
 # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal

After applying the patch, such sb_internal -> fs_reclaim lock dependency
chain can no longer be found. Because of that, the locking dependency
warning will not be shown.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 fs/xfs/xfs_log.c   |  9 +++++++++
 fs/xfs/xfs_trans.c | 31 +++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 00fda2e8e738..33244680d0d4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -830,8 +830,17 @@ xlog_unmount_write(
 	xfs_lsn_t		lsn;
 	uint			flags = XLOG_UNMOUNT_TRANS;
 	int			error;
+	unsigned long		pflags;
 
+	/*
+	 * xfs_log_reserve() allocates memory. This can lead to fs reclaim
+	 * which may conflicts with the unmount process. To avoid that,
+	 * disable fs reclaim for this allocation.
+	 */
+	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
 	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
+	current_restore_flags_nested(&pflags, PF_MEMALLOC_NOFS);
+
 	if (error)
 		goto out_err;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3c94e5ff4316..ecb46939b276 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -255,7 +255,28 @@ xfs_trans_alloc(
 	struct xfs_trans	**tpp)
 {
 	struct xfs_trans	*tp;
-	int			error;
+	int			error = 0;
+	unsigned long		pflags = -1;
+
+	/*
+	 * When both XFS_TRANS_NO_WRITECOUNT and the frozen flag are set,
+	 * it means there are no dirty data pages in the filesystem at this
+	 * point. So even if fs reclaim is being done, it won't happen to
+	 * this filesystem. In this case, PF_MEMALLOC_NOLOCKDEP should be
+	 * set to avoid false positive lockdep splat like:
+	 *
+	 *       CPU0                    CPU1
+	 *       ----                    ----
+	 *  lock(sb_internal);
+	 *                               lock(fs_reclaim);
+	 *                               lock(sb_internal);
+	 *  lock(fs_reclaim);
+	 *
+	 *  *** DEADLOCK ***
+	 */
+	if (PF_MEMALLOC_NOLOCKDEP && (flags & XFS_TRANS_NO_WRITECOUNT) &&
+	    mp->m_super->s_writers.frozen)
+		current_set_flags_nested(&pflags, PF_MEMALLOC_NOLOCKDEP);
 
 	/*
 	 * Allocate the handle before we do our freeze accounting and setting up
@@ -284,13 +305,15 @@ xfs_trans_alloc(
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error) {
 		xfs_trans_cancel(tp);
-		return error;
+		goto out;
 	}
 
 	trace_xfs_trans_alloc(tp, _RET_IP_);
-
 	*tpp = tp;
-	return 0;
+out:
+	if (PF_MEMALLOC_NOLOCKDEP && (pflags != -1))
+		current_restore_flags_nested(&pflags, PF_MEMALLOC_NOLOCKDEP);
+	return error;
 }
 
 /*
-- 
2.18.1

