Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29F3EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 06:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbjGNGqa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 02:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbjGNGqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 02:46:06 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007163AB7
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:22 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3fbf1b82de7so9459555e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689317121; x=1691909121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gy73eiy58V/a+8IBOn3ezPsb/IGZyTDIBKfEVMsCuac=;
        b=EBeQsoJC5ZJb51AFCehMZm6oe8sGi5VeB0a/BzKgw02gQDi4L4QAlRx2slXhaW1hFS
         dRRRR7AkF+DbRbyuV4NUGNDjNw3nfIxD5SE1UAviL5VZ2gbivOLbha8ghDYQZQ/pFV0P
         tqTGR62TcwuuCKRvSpL9CmHGeNla0Ok2vud921sAhS8jvLch1fgJwc1x3+zRo3SH5bTZ
         GHfHKnodMnwWRA1QWfqyv5tI/ZB+WDSyIHXQBj2DyyGqDAMVAlXJHgk5IuwII0GDfeOV
         kjZLjNbaRQhysqeQjjXtbDG7O+J4ch4AvVcif2g+4ueSJtL/43bSOf/NLssmLdgXiGx7
         3gVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689317121; x=1691909121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gy73eiy58V/a+8IBOn3ezPsb/IGZyTDIBKfEVMsCuac=;
        b=bSlqtkJ5aKM6Vj75xbz7AF0pvFXFpjEB9+KLTggK40TcMNkZC8GHUNTIWofUo/0CpV
         jOeArc49hjVY72Sa1ivy+6fByQRk6qUrOKV8zQ4PM5aURkClajewLz0AyNEhoPdcDSUb
         pw8Mw9zk4n3jm4OcaSRNMu2JYQIwzv3VYjvkHLbHDXniwSNhV1qdCn15/F/qU3B5yZla
         hK15hgEviB6BCGxCs00Y7zJ3NIXFn4mwBcrbSPbgDFnsYGWNwLrOcbHUiHxs6g7mMStK
         n9I7g8zd6KzSyHyi4DZ1A3UCxb+FF8pf2y0j10JzFoBrsFDVAQtpWpKmtyTEXx7E8iKZ
         PImg==
X-Gm-Message-State: ABy/qLZ27JfuOCjKtQoPrX2+cVyoTL9hDn76DyIwKKUgZr5umCz4R3RM
        Aiq1c3pHheFDH2T6xE2OGE4=
X-Google-Smtp-Source: APBJJlH7mfNBjqsvYPrT1U4c1n5LMM/XzmFN/uPdPhoMQiXKJTU9ODiPBKZycXMMnBFNlA2Augn5fg==
X-Received: by 2002:a7b:c851:0:b0:3f6:8ba:6ea2 with SMTP id c17-20020a7bc851000000b003f608ba6ea2mr1445080wml.15.1689317121001;
        Thu, 13 Jul 2023 23:45:21 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c234300b003fc04d13242sm709574wmq.0.2023.07.13.23.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 23:45:20 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 6.1 CANDIDATE v2 4/4] xfs: fix xfs_inodegc_stop racing with mod_delayed_work
Date:   Fri, 14 Jul 2023 09:45:09 +0300
Message-Id: <20230714064509.1451122-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714064509.1451122-1-amir73il@gmail.com>
References: <20230714064509.1451122-1-amir73il@gmail.com>
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

