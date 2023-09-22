Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DCCE7D0BB
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Sep 2023 01:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjIVBCK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjIVBCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 21:02:09 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40B1102;
        Thu, 21 Sep 2023 18:02:02 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c328b53aeaso14246165ad.2;
        Thu, 21 Sep 2023 18:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695344522; x=1695949322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3ej1VaYkETo5to6v5QOq2ep9cnGTeTAFm8phePWQ360=;
        b=WZnR8173aLmjgtVpyUyMFcXQASwsmgFLQTce8Xq7jnUCNsaQNAedO8x/K6W5D7P7HY
         Tt4ASUl3qgmVnzhZ0D/owTr+fjUh8MgRIsGFBuPglMcocjj9SCyyvdcpCAZJlzkDzgUR
         2Cac4+6d23bw2dOMdwJJJcA2CNrkdNtLJF2o0J6YqEILjpwbMywLEK+fA5BGAwf9MtXq
         TJ2hcUn1HEpEC/1EAN0gJWsSVJriWZyaswI+u+P6GR0le32ghh0CNScRm28jP5JaIy+G
         rt0V3aSGtoZf0lFuyu+OSKRIeJ2q51H/5EQXK9n+69aVAV4BXmjA1c2JQ/klQLyNiZ+3
         rYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695344522; x=1695949322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ej1VaYkETo5to6v5QOq2ep9cnGTeTAFm8phePWQ360=;
        b=ZzT5g4dXGGkRI0bQXhiGKkI7t/7lFPQCtTaZ9ddVj0zPL4LdzkLZq+3gPO0rj5AbTY
         hlwGP/a9BQLLxPuELWEIs9rhyyCBxRfRITtaRWgV8fuzp1p2R6PFUINnGhvuzHZnu68Z
         Kr/GemzLgYBzm4MQquClBWfSFfRq/b6jTLqkACrIurk+o7mQnIE5Dmf9V2RPglifcW9x
         qAFeLY7Mds7U8bDWRh1B3cv2L4RQ1oQ7vVGjsVdiKx6ja/Bd0cJv4lJo0hQfHMiAK7X9
         A4ulq/d34NCkzGvRJFuQO5I7m8x76SXq2KsMBbY7N3K5AD8bN1VMz0iRaVM7PY1fyj8L
         6YHw==
X-Gm-Message-State: AOJu0YwucuMJkaTKgsWqW635EyRg8zNlH4hnsP8lrW+Iv50ahJlaFEJ7
        IDk2jejRMuBw+3SfExEsqBGnsSLSm4fxNA==
X-Google-Smtp-Source: AGHT+IEHlUXYjdpsDLHS4fD/eeIWItgFnydKzl/JDBO05DpymUtRp17MaP1HftrjNq7qs3x6MA0dcw==
X-Received: by 2002:a17:903:2786:b0:1c5:6309:e1e2 with SMTP id jw6-20020a170903278600b001c56309e1e2mr6706842plb.48.1695344521837;
        Thu, 21 Sep 2023 18:02:01 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d5ff:b7b0:7028:8af6])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090282c200b001bc445e2497sm2178815plz.79.2023.09.21.18.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 18:02:01 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 1/6] xfs: bound maximum wait time for inodegc work
Date:   Thu, 21 Sep 2023 18:01:51 -0700
Message-ID: <20230922010156.1718782-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 7cf2b0f9611b9971d663e1fc3206eeda3b902922 ]

Currently inodegc work can sit queued on the per-cpu queue until
the workqueue is either flushed of the queue reaches a depth that
triggers work queuing (and later throttling). This means that we
could queue work that waits for a long time for some other event to
trigger flushing.

Hence instead of just queueing work at a specific depth, use a
delayed work that queues the work at a bound time. We can still
schedule the work immediately at a given depth, but we no long need
to worry about leaving a number of items on the list that won't get
processed until external events prevail.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
 fs/xfs/xfs_mount.h  |  2 +-
 fs/xfs/xfs_super.c  |  2 +-
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5e44d7bbd8fc..2c3ef553f5ef 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -458,7 +458,7 @@ xfs_inodegc_queue_all(
 	for_each_online_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
 		if (!llist_empty(&gc->list))
-			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
+			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
 	}
 }
 
@@ -1851,8 +1851,8 @@ void
 xfs_inodegc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_inodegc	*gc = container_of(work, struct xfs_inodegc,
-							work);
+	struct xfs_inodegc	*gc = container_of(to_delayed_work(work),
+						struct xfs_inodegc, work);
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
 
@@ -2021,6 +2021,7 @@ xfs_inodegc_queue(
 	struct xfs_inodegc	*gc;
 	int			items;
 	unsigned int		shrinker_hits;
+	unsigned long		queue_delay = 1;
 
 	trace_xfs_inode_set_need_inactive(ip);
 	spin_lock(&ip->i_flags_lock);
@@ -2032,19 +2033,26 @@ xfs_inodegc_queue(
 	items = READ_ONCE(gc->items);
 	WRITE_ONCE(gc->items, items + 1);
 	shrinker_hits = READ_ONCE(gc->shrinker_hits);
-	put_cpu_ptr(gc);
 
-	if (!xfs_is_inodegc_enabled(mp))
+	/*
+	 * We queue the work while holding the current CPU so that the work
+	 * is scheduled to run on this CPU.
+	 */
+	if (!xfs_is_inodegc_enabled(mp)) {
+		put_cpu_ptr(gc);
 		return;
-
-	if (xfs_inodegc_want_queue_work(ip, items)) {
-		trace_xfs_inodegc_queue(mp, __return_address);
-		queue_work(mp->m_inodegc_wq, &gc->work);
 	}
 
+	if (xfs_inodegc_want_queue_work(ip, items))
+		queue_delay = 0;
+
+	trace_xfs_inodegc_queue(mp, __return_address);
+	mod_delayed_work(mp->m_inodegc_wq, &gc->work, queue_delay);
+	put_cpu_ptr(gc);
+
 	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
 		trace_xfs_inodegc_throttle(mp, __return_address);
-		flush_work(&gc->work);
+		flush_delayed_work(&gc->work);
 	}
 }
 
@@ -2061,7 +2069,7 @@ xfs_inodegc_cpu_dead(
 	unsigned int		count = 0;
 
 	dead_gc = per_cpu_ptr(mp->m_inodegc, dead_cpu);
-	cancel_work_sync(&dead_gc->work);
+	cancel_delayed_work_sync(&dead_gc->work);
 
 	if (llist_empty(&dead_gc->list))
 		return;
@@ -2080,12 +2088,12 @@ xfs_inodegc_cpu_dead(
 	llist_add_batch(first, last, &gc->list);
 	count += READ_ONCE(gc->items);
 	WRITE_ONCE(gc->items, count);
-	put_cpu_ptr(gc);
 
 	if (xfs_is_inodegc_enabled(mp)) {
 		trace_xfs_inodegc_queue(mp, __return_address);
-		queue_work(mp->m_inodegc_wq, &gc->work);
+		mod_delayed_work(mp->m_inodegc_wq, &gc->work, 0);
 	}
+	put_cpu_ptr(gc);
 }
 
 /*
@@ -2180,7 +2188,7 @@ xfs_inodegc_shrinker_scan(
 			unsigned int	h = READ_ONCE(gc->shrinker_hits);
 
 			WRITE_ONCE(gc->shrinker_hits, h + 1);
-			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
+			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
 			no_items = false;
 		}
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 86564295fce6..3d58938a6f75 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -61,7 +61,7 @@ struct xfs_error_cfg {
  */
 struct xfs_inodegc {
 	struct llist_head	list;
-	struct work_struct	work;
+	struct delayed_work	work;
 
 	/* approximate count of inodes in the list */
 	unsigned int		items;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index df1d6be61bfa..8fe6ca9208de 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1061,7 +1061,7 @@ xfs_inodegc_init_percpu(
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
 		init_llist_head(&gc->list);
 		gc->items = 0;
-		INIT_WORK(&gc->work, xfs_inodegc_worker);
+		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
 	}
 	return 0;
 }
-- 
2.42.0.515.g380fc7ccd1-goog

