Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17E3E7D0C2
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Sep 2023 01:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjIVBCO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjIVBCN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 21:02:13 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9885191;
        Thu, 21 Sep 2023 18:02:07 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c59c40b840so14732805ad.3;
        Thu, 21 Sep 2023 18:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695344527; x=1695949327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5EQwThOiasL4de5Y5vJ+ZLwZXFoPo1unIHxbqTwkXC8=;
        b=ERMOA85BazzCj7u5gk3carKu3tcRfeXsc9XTfVxfNkvCsF7+u0cbeB+aT6QPSsp/Fz
         +GvQIGyfKHekxZsmk8E00aR8jcnB/ww1a7EWmJwbEyzJodHQ1IVoT5DLWTx4ScPWqVBa
         ocIqZTBFkdc6yqSKx9nkxBBUiR9Ci4ksFS+xQHow3jSJD8bc+6CnzXZLrF8OKEcFDeqx
         xTUd5x3xhxwUQyfUaE7Ch3QCBtV35jHl3LTgPfsdamXDvhm5EavBtlrpmVtgl5OiPAhr
         KJjZpozISXbyuXNdFIUQDFl5nWbGfjFaAI1Qb6PrmmGWqjVNQSDcZRjQ194FkMcVa+dI
         riRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695344527; x=1695949327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5EQwThOiasL4de5Y5vJ+ZLwZXFoPo1unIHxbqTwkXC8=;
        b=AkUQltsGSGUTBbPdezGpAT8puepzB3EM5XH0rgCiM2j6iZ0zw4e+z2myIFBE0Hkuml
         8As90FSs11Q2Kwbhnr31mXNLCyCSXFz7XEbp7Ulfzf8Xm6FuR9hHuCxqhPh4QkY588RH
         JVKlyDNdB4kbBMp3jjUj67mBVJ0Tc94IvlIvfXCoycCwjGwlQ7GeKx8y2rSW+wFNtPPl
         RWhcdeMZQnLBXktgn/UW/61WmJ8ECNdotUbZ4+1PMuiDGA/1zkS00hFZSED2S3g6qOeW
         xO8nrUMdyvDRGImH6M2ISWMswjqm61xq47qbSDBGFZqkoD33w/jbfx+cPTBPY4pybG7I
         WJIQ==
X-Gm-Message-State: AOJu0YxEltKiwPCOc01K+esjQkL31L90b4J3+0M5+gO15RBtgoHXq4gO
        RInr2rGZL0u8qWe00HeqvDgorAQlfaHeBQ==
X-Google-Smtp-Source: AGHT+IH5MjAHpRSKHDzuu+1w7S2b6diJbtxDrdjHHxc51XoPVd/FrrmjiDSGio4AcAs6/mz29RBfjg==
X-Received: by 2002:a17:90a:bb8b:b0:268:b682:23de with SMTP id v11-20020a17090abb8b00b00268b68223demr7562891pjr.28.1695344527027;
        Thu, 21 Sep 2023 18:02:07 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d5ff:b7b0:7028:8af6])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090282c200b001bc445e2497sm2178815plz.79.2023.09.21.18.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 18:02:06 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 6/6] xfs: fix xfs_inodegc_stop racing with mod_delayed_work
Date:   Thu, 21 Sep 2023 18:01:56 -0700
Message-ID: <20230922010156.1718782-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
In-Reply-To: <20230922010156.1718782-1-leah.rumancik@gmail.com>
References: <20230922010156.1718782-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 2254a7396a0ca6309854948ee1c0a33fa4268cec ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 02022164772d..eab98d76dbe1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -448,18 +448,23 @@ xfs_iget_check_free_state(
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
@@ -1902,24 +1907,41 @@ xfs_inodegc_flush(
 
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
2.42.0.515.g380fc7ccd1-goog

