Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CA3C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 17:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0149E208C7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 17:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FGTNd+Wu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbgFRRT7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 13:19:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33544 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727822AbgFRRT7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 13:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592500798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=vWkZ8x9ESZ+H19yNGq/vE2s97IdfpRVB5RW0AK54FPY=;
        b=FGTNd+WuvZsw7eHYWWHuTPs6vG5oJLHbOsVZiQvVPw0ZmAoZqrwwv2XnshKkpv/H9mYCBe
        gkNyEIl8p2Olr4OhWqL65OHRKuIhmqRpdRq6r6zAkKXs37zTQOxEwL1vZuQP5ikjFSvF9U
        /FscMJQd4GIFRbxNBB54ia59OPycJZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-AkZenXu9NRSMOV-MofjFJQ-1; Thu, 18 Jun 2020 13:19:56 -0400
X-MC-Unique: AkZenXu9NRSMOV-MofjFJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E33F91883618;
        Thu, 18 Jun 2020 17:19:54 +0000 (UTC)
Received: from llong.com (ovpn-118-66.rdu2.redhat.com [10.10.118.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58E5C7166E;
        Thu, 18 Jun 2020 17:19:48 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v4] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim
Date:   Thu, 18 Jun 2020 13:19:41 -0400
Message-Id: <20200618171941.9475-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

One way to avoid this splat is to add GFP_NOFS to the affected allocation
calls. This is what PF_MEMALLOC_NOFS per-process flag is for. This does
reduce the potential source of memory where reclaim can be done. This
shouldn't matter unless the system is really running out of memory.
In that particular case, the filesystem freeze operation may fail while
it was succeeding previously.

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
 fs/xfs/xfs_super.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 379cbff438bc..1b94b9bfa4d7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -913,11 +913,33 @@ xfs_fs_freeze(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
+	unsigned long		pflags;
+	int			ret;
 
+	/*
+	 * A fs_reclaim pseudo lock is added to check for potential deadlock
+	 * condition with fs reclaim. The following lockdep splat was hit
+	 * occasionally. This is actually a false positive as the allocation
+	 * is being done only after the frozen filesystem is no longer dirty.
+	 * One way to avoid this splat is to add GFP_NOFS to the affected
+	 * allocation calls. This is what PF_MEMALLOC_NOFS is for.
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
+	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
 	xfs_stop_block_reaping(mp);
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
-	return xfs_sync_sb(mp, true);
+	ret = xfs_sync_sb(mp, true);
+	current_restore_flags_nested(&pflags, PF_MEMALLOC_NOFS);
+	return ret;
 }
 
 STATIC int
-- 
2.18.1

