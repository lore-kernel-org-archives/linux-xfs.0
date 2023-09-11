Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6999ACA0EC2
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Sep 2023 21:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345535AbjIKVVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242464AbjIKPhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2023 11:37:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF902E9
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 08:37:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D02C433C9;
        Mon, 11 Sep 2023 15:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694446653;
        bh=QW4pb4R6Ccpb8384BjgXZniEg+jxpzOwMWDVqj1BEFw=;
        h=Date:From:To:Cc:Subject:From;
        b=EAr9mFNZdQ4DFI4b0vdExjwb44nggD677WpCMr8p30gqPMGPWLQ3CZOYrcnG6g7gv
         10igkOyWRD3TLtFLoWZO0IGEgRWBeNBZ6V8kxdTNorUb4dfaz2ZXl66tapZ3Vq/ISY
         JfPc1Emb0tkdYFaZYFmd1ssegUf+SqyJUz9jkfHGeJfDzpFm460KETfPgfo+02Wgor
         /wl1N6Oj2DfpZicnup2lqj3i3Twigix3WX1QoqXk76I2vd8Xby5YfFqrNOYeihcB+q
         SLdEAwY3//juMgigowHLnQ72lnQxNpNO89nGZ2CYT0z7bn4/Ld32zzatPVDl4RpN9v
         ujibFNqa87TJg==
Date:   Mon, 11 Sep 2023 08:37:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        xfs <linux-xfs@vger.kernel.org>, harshit.m.mogalapalli@oracle.com
Subject: [PATCH] xfs: only call xchk_stats_merge after validating scrub inputs
Message-ID: <20230911153732.GZ28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Harshit Mogalapalli slogged through several reports from our internal
syzbot instance and observed that they all had a common stack trace:

BUG: KASAN: user-memory-access in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
BUG: KASAN: user-memory-access in atomic_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:1294 [inline]
BUG: KASAN: user-memory-access in queued_spin_lock include/asm-generic/qspinlock.h:111 [inline]
BUG: KASAN: user-memory-access in do_raw_spin_lock include/linux/spinlock.h:187 [inline]
BUG: KASAN: user-memory-access in __raw_spin_lock include/linux/spinlock_api_smp.h:134 [inline]
BUG: KASAN: user-memory-access in _raw_spin_lock+0x76/0xe0 kernel/locking/spinlock.c:154
Write of size 4 at addr 0000001dd87ee280 by task syz-executor365/1543

CPU: 2 PID: 1543 Comm: syz-executor365 Not tainted 6.5.0-syzk #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x83/0xb0 lib/dump_stack.c:106
 print_report+0x3f8/0x620 mm/kasan/report.c:478
 kasan_report+0xb0/0xe0 mm/kasan/report.c:588
 check_region_inline mm/kasan/generic.c:181 [inline]
 kasan_check_range+0x139/0x1e0 mm/kasan/generic.c:187
 instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
 atomic_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:1294 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:111 [inline]
 do_raw_spin_lock include/linux/spinlock.h:187 [inline]
 __raw_spin_lock include/linux/spinlock_api_smp.h:134 [inline]
 _raw_spin_lock+0x76/0xe0 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 xchk_stats_merge_one.isra.1+0x39/0x650 fs/xfs/scrub/stats.c:191
 xchk_stats_merge+0x5f/0xe0 fs/xfs/scrub/stats.c:225
 xfs_scrub_metadata+0x252/0x14e0 fs/xfs/scrub/scrub.c:599
 xfs_ioc_scrub_metadata+0xc8/0x160 fs/xfs/xfs_ioctl.c:1646
 xfs_file_ioctl+0x3fd/0x1870 fs/xfs/xfs_ioctl.c:1955
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:871 [inline]
 __se_sys_ioctl fs/ioctl.c:857 [inline]
 __x64_sys_ioctl+0x199/0x220 fs/ioctl.c:857
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3e/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8
RIP: 0033:0x7ff155af753d
Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1b 79 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc006e2568 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff155af753d
RDX: 00000000200000c0 RSI: 00000000c040583c RDI: 0000000000000003
RBP: 00000000ffffffff R08: 00000000004010c0 R09: 00000000004010c0
R10: 00000000004010c0 R11: 0000000000000246 R12: 0000000000400cb0
R13: 00007ffc006e2670 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

The root cause here is that xchk_stats_merge_one walks off the end of
the xchk_scrub_stats.cs_stats array because it has been fed a garbage
value in sm->sm_type.  That occurs because I put the xchk_stats_merge
in the wrong place -- it should have been after the last xchk_teardown
call on our way out of xfs_scrub_metadata because we only call the
teardown function if we called the setup function, and we don't call the
setup functions if the inputs are obviously garbage.

Thanks to Harshit for triaging the bug reports and bringing this to my
attention.  This is a helluva better way to handle syzbot reports than
spraying sploits on the public list like Googlers do.

Fixes: d7a74cad8f45 ("xfs: track usage statistics of online fsck")
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |    4 ++--
 fs/xfs/scrub/stats.c |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7d3aa14d81b5..4849efcaa33a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -588,6 +588,8 @@ xfs_scrub_metadata(
 out_teardown:
 	error = xchk_teardown(sc, error);
 out_sc:
+	if (error != -ENOENT)
+		xchk_stats_merge(mp, sm, &run);
 	kfree(sc);
 out:
 	trace_xchk_done(XFS_I(file_inode(file)), sm, error);
@@ -595,8 +597,6 @@ xfs_scrub_metadata(
 		sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		error = 0;
 	}
-	if (error != -ENOENT)
-		xchk_stats_merge(mp, sm, &run);
 	return error;
 need_drain:
 	error = xchk_teardown(sc, 0);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index aeb92624176b..cd91db4a5548 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -185,7 +185,10 @@ xchk_stats_merge_one(
 {
 	struct xchk_scrub_stats		*css;
 
-	ASSERT(sm->sm_type < XFS_SCRUB_TYPE_NR);
+	if (sm->sm_type >= XFS_SCRUB_TYPE_NR) {
+		ASSERT(sm->sm_type < XFS_SCRUB_TYPE_NR);
+		return;
+	}
 
 	css = &cs->cs_stats[sm->sm_type];
 	spin_lock(&css->css_lock);
