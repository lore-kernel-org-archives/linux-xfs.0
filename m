Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6702EE3F0B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 18:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbjILSA6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 14:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjILSA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 14:00:57 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1284FC1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:54 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-68fb46f38f9so2560996b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694541653; x=1695146453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xfGsiwcsHizMHaOKzu3iKRBWmkfdJpJH7C5zwS0iYg=;
        b=DzuAl35jyCBACmleBJloCSIweMlNEQ90BCRaxI9tM+3Rt0oeWDfQYIY2KKdCKN4laA
         fj0BZORVNJSHC1Y9ZfjqSv/+8QQKuSsXhqU65TObw9IgiD11wLOFwlxXirQMMHSXLNOy
         uttTsdnZ/fLtUp2iDwfWHYdaWI2ZVSTL9v4FGNwbdaJgVDUTazA2SLY7oyUT/wiwQdrr
         gQyNGRWAu6ud6bIz5kotDyEMj5BrYtFbGsDPlO4s2+vg1orl2dh9E5C4EFuPieDsqTrs
         Rf35TugQykW9GbEDJi7CGGUIWt9PriL/dVgLH6pYjFkxZkT+OYNiw7xz+MD/c0g+Va32
         AXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694541653; x=1695146453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xfGsiwcsHizMHaOKzu3iKRBWmkfdJpJH7C5zwS0iYg=;
        b=BYGRhreEbtUr30rzlZVPcrzfdtmmvAa8d0jv+VGAf0gMp+wY5I975wTJORJDvSL4h1
         O1c+2yAuyCdCW09pKuujrRJ2n+ydgM4ggnieYrM12GHVnZtQBTRxqRRO7gk2gkZ82ok3
         LioPRvhPigoux3id+W/tPeTrk9zU8svbN1aZylqvt4feBRSeYA0jqzY8FNQEW2kpAM0C
         WH+fUEmq9XWAt+rpN+zGiWjObFYmn1/WSeAfSDENRspvJXgwdhY9yA1kroY6z4EWK9h7
         mgC/DCTtjfuZzXMZmplKx6HeeH6bdsD4leu7VOoYu7yZHGSEv4j4cCAdJOGCIbpMC9jw
         Zvrw==
X-Gm-Message-State: AOJu0YxQvA2pIz9AzgrkMmtq7YSrEsXJBpEw9kEgd7qfIynr5PoT4x3x
        huk1VF17iQlaEmLrcvxCSrgC9Col+4T4ng==
X-Google-Smtp-Source: AGHT+IHAArujfPXq3k0Kx73L0g69PFalDxWBJ6mIprnmlH30sRRhiR0+SyNNcnOrPbmqmgzWYgMdOg==
X-Received: by 2002:a05:6a00:23c7:b0:68e:4955:c405 with SMTP id g7-20020a056a0023c700b0068e4955c405mr495854pfc.27.1694541653252;
        Tue, 12 Sep 2023 11:00:53 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:e951:d95c:9c79:d1b])
        by smtp.gmail.com with ESMTPSA id x12-20020aa784cc000000b0068be7119c70sm3412246pfn.186.2023.09.12.11.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:00:52 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 1/6] xfs: bound maximum wait time for inodegc work
Date:   Tue, 12 Sep 2023 11:00:35 -0700
Message-ID: <20230912180040.3149181-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230912180040.3149181-1-leah.rumancik@gmail.com>
References: <20230912180040.3149181-1-leah.rumancik@gmail.com>
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
2.42.0.283.g2d96d420d3-goog

