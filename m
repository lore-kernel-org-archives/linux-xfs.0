Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33860C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 21:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0525D206E6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 21:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ezd6V6GQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgFDVBx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 17:01:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbgFDVBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 17:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591304511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=2KClr5NiOIWHiuhB5usfKiNb03ChHaaNAYDguDN289c=;
        b=ezd6V6GQhtp/v753MRk5+G+hUohnptF4WGBooD+hkrVjQLtl8fYfR+Z+Ivl/RHgeb2hhks
        qO4rpIAvx3P5vpw2WSxh0TaCOaOaMCSrlV/68k2noVm1VrUHkwyFc3Uke4+PryzZPJXtVU
        0cKuUG5o7q/7TyGDv9D3C6B30FtAtM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-FAp4gH5uPZKm5qnek9q_Jg-1; Thu, 04 Jun 2020 17:01:49 -0400
X-MC-Unique: FAp4gH5uPZKm5qnek9q_Jg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A797483DB38;
        Thu,  4 Jun 2020 21:01:48 +0000 (UTC)
Received: from llong.com (ovpn-114-13.rdu2.redhat.com [10.10.114.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 413FF5FC2C;
        Thu,  4 Jun 2020 21:01:40 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v2] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim
Date:   Thu,  4 Jun 2020 17:01:30 -0400
Message-Id: <20200604210130.697-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

According to Dave Chinner:

  Freezing the filesystem, after all the data has been cleaned. IOWs
  memory reclaim will never run the above writeback path when
  the freeze process is trying to allocate a transaction here because
  there are no dirty data pages in the filesystem at this point.

  Indeed, this xfs_sync_sb() path sets XFS_TRANS_NO_WRITECOUNT so that
  it /doesn't deadlock/ by taking freeze references for the
  transaction. We've just drained all the transactions
  in progress and written back all the dirty metadata, too, and so the
  filesystem is completely clean and only needs the superblock to be
  updated to complete the freeze process. And to do that, it does not
  take a freeze reference because calling sb_start_intwrite() here
  would deadlock.

  IOWs, this is a false positive, caused by the fact that
  xfs_trans_alloc() is called from both above and below memory reclaim
  as well as within /every level/ of freeze processing. Lockdep is
  unable to describe the staged flush logic in the freeze process that
  prevents deadlocks from occurring, and hence we will pretty much
  always see false positives in the freeze path....

Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
may fix the issue. However, that will greatly complicate the logic and
may not be worth it.

Another way to fix it is to disable the taking of the fs_reclaim
pseudo lock when in the freezing code path as a reclaim on the freezed
filesystem is not possible as stated above. Given that a KM_NOLOCKDEP
flag has been introduced in commit 6dcde60efd94 ("xfs: more lockdep
whackamole with kmem_alloc*"), this flag can be used to disable lockdep
when the filesystem has been freezed.

Without this patch, the command sequence below will show that the lock
dependency chain sb_internal -> fs_reclaim exists.

 # fsfreeze -f /home
 # fsfreeze --unfreeze /home
 # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal

After applying the patch, such sb_internal -> fs_reclaim lock dependency
chain can no longer be found. Because of that, the locking dependency
warning will not be shown.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 fs/xfs/xfs_log.c   | 3 ++-
 fs/xfs/xfs_trans.c | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 00fda2e8e738..d273d4e74ef8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -433,7 +433,8 @@ xfs_log_reserve(
 	XFS_STATS_INC(mp, xs_try_logspace);
 
 	ASSERT(*ticp == NULL);
-	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
+	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
+			mp->m_super->s_writers.frozen ? KM_NOLOCKDEP : 0);
 	*ticp = tic;
 
 	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3c94e5ff4316..3a9f394a0f02 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -261,8 +261,14 @@ xfs_trans_alloc(
 	 * Allocate the handle before we do our freeze accounting and setting up
 	 * GFP_NOFS allocation context so that we avoid lockdep false positives
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
+	 *
+	 * To prevent false positive lockdep warning of circular locking
+	 * dependency between sb_internal and fs_reclaim, disable the
+	 * acquisition of the fs_reclaim pseudo-lock when the superblock
+	 * has been frozen or in the process of being frozen.
 	 */
-	tp = kmem_zone_zalloc(xfs_trans_zone, 0);
+	tp = kmem_zone_zalloc(xfs_trans_zone,
+		mp->m_super->s_writers.frozen ? KM_NOLOCKDEP : 0);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
 
-- 
2.18.1

