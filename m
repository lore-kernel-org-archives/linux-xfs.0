Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D754AEB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 09:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjGLJro (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjGLJrn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 05:47:43 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E615B0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:47:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3fbca8935bfso68929075e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689155260; x=1691747260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gy73eiy58V/a+8IBOn3ezPsb/IGZyTDIBKfEVMsCuac=;
        b=e3CvNsYUHZ2d1g5errFL90IxRv4cmlM4V3nZm8jiZlWeojZy+D+axp9nWuFIDJERpV
         4WwD7lHFzGuxVHgVZ23KNwaLrLUTizdpCM2brI01WtmckKqAtdhDAgp22CzZC1OqDfMq
         SKJSB1ACKzbKmG/D76QIdgmBBqmNRabnoZOV1JXCDGLhnVEOoqqBxIy1J6OKI9qTB4xJ
         y+MSHP6Fe6azQmzI+6lw3wDbjT1A0bzM0HPA2QjeO5D5xYtli1eliJqFEXWwusDAvcAh
         OYFkLemQm3J0d0hUflDeJaoz2jDSZSTmA+hPi6jV2GhO7K90l1SvaazdpPeBudXhKY1n
         xJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689155260; x=1691747260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gy73eiy58V/a+8IBOn3ezPsb/IGZyTDIBKfEVMsCuac=;
        b=RUMZOTUlGtd2PIcTAw2xXveg5NKsO7rTD3jgJJeUkb6XXHihSOMzLrRiYkYLpTnyjW
         xNPneMaNWZloGRD0NVOFUZ21+aaqtsk8J2cJeQ975j/7I+XNH08Af+jJiPbJx1UJhRkZ
         Vj8ZFEB/g7CsJjOrv43xJc2dpVDZk49GDE8Oi0/Mn58WB4Hdgr5DhHUXWktphtvhNJzK
         /4xO7K7JAIsRzDzn5U8qG03DKXZ942NzVhpDSV8V40THXKPY+wkR+Cb2Z7+U8SOHuW2C
         W4orAgkizoaFOMBC3ZFzxFfkFvTn6Wd60ysZ0/3FRB30Ym/RjVFVt9MAyMNSzd8OyiL6
         B5vg==
X-Gm-Message-State: ABy/qLZRM05T/7s/5bKVFEK+YeE3Xk0DZBV/zCS2W0aCffhgMiaEWAaR
        dCOgYJEpuk02+8NZoKUIPEs=
X-Google-Smtp-Source: APBJJlFrgF6yXkaN6i43THwh4Z38x+sVx34kLonkAJ+qDA4SjcAPBb+0lcgtWZGfrOsmOnbh/3H/3g==
X-Received: by 2002:a05:600c:2210:b0:3fb:b3aa:1c89 with SMTP id z16-20020a05600c221000b003fbb3aa1c89mr17023877wml.19.1689155260284;
        Wed, 12 Jul 2023 02:47:40 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id u9-20020a7bc049000000b003fbc681c8d1sm15144548wmc.36.2023.07.12.02.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 02:47:39 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 6.1 CANDIDATE 3/3] xfs: fix xfs_inodegc_stop racing with mod_delayed_work
Date:   Wed, 12 Jul 2023 12:47:33 +0300
Message-Id: <20230712094733.1265038-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712094733.1265038-1-amir73il@gmail.com>
References: <20230712094733.1265038-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2254a7396a0ca6309854948ee1c0a33fa4268cec upstream.

syzbot reported this warning from the faux inodegc shrinker that tries
to kick off inodegc work:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 102 at kernel/workqueue.c:1445 __queue_work+0xd44/0x1120 kernel/workqueue.c:1444
RIP: 0010:__queue_work+0xd44/0x1120 kernel/workqueue.c:1444
Call Trace:
 __queue_delayed_work+0x1c8/0x270 kernel/workqueue.c:1672
 mod_delayed_work_on+0xe1/0x220 kernel/workqueue.c:1746
 xfs_inodegc_shrinker_scan fs/xfs/xfs_icache.c:2212 [inline]
 xfs_inodegc_shrinker_scan+0x250/0x4f0 fs/xfs/xfs_icache.c:2191
 do_shrink_slab+0x428/0xaa0 mm/vmscan.c:853
 shrink_slab+0x175/0x660 mm/vmscan.c:1013
 shrink_one+0x502/0x810 mm/vmscan.c:5343
 shrink_many mm/vmscan.c:5394 [inline]
 lru_gen_shrink_node mm/vmscan.c:5511 [inline]
 shrink_node+0x2064/0x35f0 mm/vmscan.c:6459
 kswapd_shrink_node mm/vmscan.c:7262 [inline]
 balance_pgdat+0xa02/0x1ac0 mm/vmscan.c:7452
 kswapd+0x677/0xd60 mm/vmscan.c:7712
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

This warning corresponds to this code in __queue_work:

	/*
	 * For a draining wq, only works from the same workqueue are
	 * allowed. The __WQ_DESTROYING helps to spot the issue that
	 * queues a new work item to a wq after destroy_workqueue(wq).
	 */
	if (unlikely(wq->flags & (__WQ_DESTROYING | __WQ_DRAINING) &&
		     WARN_ON_ONCE(!is_chained_work(wq))))
		return;

For this to trip, we must have a thread draining the inodedgc workqueue
and a second thread trying to queue inodegc work to that workqueue.
This can happen if freezing or a ro remount race with reclaim poking our
faux inodegc shrinker and another thread dropping an unlinked O_RDONLY
file:

Thread 0	Thread 1	Thread 2

xfs_inodegc_stop

				xfs_inodegc_shrinker_scan
				xfs_is_inodegc_enabled
				<yes, will continue>

xfs_clear_inodegc_enabled
xfs_inodegc_queue_all
<list empty, do not queue inodegc worker>

		xfs_inodegc_queue
		<add to list>
		xfs_is_inodegc_enabled
		<no, returns>

drain_workqueue
<set WQ_DRAINING>

				llist_empty
				<no, will queue list>
				mod_delayed_work_on(..., 0)
				__queue_work
				<sees WQ_DRAINING, kaboom>

In other words, everything between the access to inodegc_enabled state
and the decision to poke the inodegc workqueue requires some kind of
coordination to avoid the WQ_DRAINING state.  We could perhaps introduce
a lock here, but we could also try to eliminate WQ_DRAINING from the
picture.

We could replace the drain_workqueue call with a loop that flushes the
workqueue and queues workers as long as there is at least one inode
present in the per-cpu inodegc llists.  We've disabled inodegc at this
point, so we know that the number of queued inodes will eventually hit
zero as long as xfs_inodegc_start cannot reactivate the workers.

There are four callers of xfs_inodegc_start.  Three of them come from the
VFS with s_umount held: filesystem thawing, failed filesystem freezing,
and the rw remount transition.  The fourth caller is mounting rw (no
remount or freezing possible).

There are three callers ofs xfs_inodegc_stop.  One is unmounting (no
remount or thaw possible).  Two of them come from the VFS with s_umount
held: fs freezing and ro remount transition.

Hence, it is correct to replace the drain_workqueue call with a loop
that drains the inodegc llists.

Fixes: 6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_icache.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7ce262dcabca..d884cba1d707 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -431,18 +431,23 @@ xfs_iget_check_free_state(
 }
 
 /* Make all pending inactivation work start immediately. */
-static void
+static bool
 xfs_inodegc_queue_all(
 	struct xfs_mount	*mp)
 {
 	struct xfs_inodegc	*gc;
 	int			cpu;
+	bool			ret = false;
 
 	for_each_online_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		if (!llist_empty(&gc->list))
+		if (!llist_empty(&gc->list)) {
 			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
+			ret = true;
+		}
 	}
+
+	return ret;
 }
 
 /*
@@ -1894,24 +1899,41 @@ xfs_inodegc_flush(
 
 /*
  * Flush all the pending work and then disable the inode inactivation background
- * workers and wait for them to stop.
+ * workers and wait for them to stop.  Caller must hold sb->s_umount to
+ * coordinate changes in the inodegc_enabled state.
  */
 void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
+	bool			rerun;
+
 	if (!xfs_clear_inodegc_enabled(mp))
 		return;
 
+	/*
+	 * Drain all pending inodegc work, including inodes that could be
+	 * queued by racing xfs_inodegc_queue or xfs_inodegc_shrinker_scan
+	 * threads that sample the inodegc state just prior to us clearing it.
+	 * The inodegc flag state prevents new threads from queuing more
+	 * inodes, so we queue pending work items and flush the workqueue until
+	 * all inodegc lists are empty.  IOWs, we cannot use drain_workqueue
+	 * here because it does not allow other unserialized mechanisms to
+	 * reschedule inodegc work while this draining is in progress.
+	 */
 	xfs_inodegc_queue_all(mp);
-	drain_workqueue(mp->m_inodegc_wq);
+	do {
+		flush_workqueue(mp->m_inodegc_wq);
+		rerun = xfs_inodegc_queue_all(mp);
+	} while (rerun);
 
 	trace_xfs_inodegc_stop(mp, __return_address);
 }
 
 /*
  * Enable the inode inactivation background workers and schedule deferred inode
- * inactivation work if there is any.
+ * inactivation work if there is any.  Caller must hold sb->s_umount to
+ * coordinate changes in the inodegc_enabled state.
  */
 void
 xfs_inodegc_start(
-- 
2.34.1

