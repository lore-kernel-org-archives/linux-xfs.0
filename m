Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76808C25B0E
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiHQA4a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237787AbiHQA43 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:29 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB29280343
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:28 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so458942pjf.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=1Znq1maKyw5UUSmsaWTHDyjgWo5hBVcIwQH8KFEYS+Y=;
        b=KoVLJ1PnQd+8paYkaTw2xDFjt+F1kKMUpXva/Cu2tFcTORMR0Td2meRapwFwmGvUkQ
         7EqKHynHacBjWN0JlwgoG/T/Uu9ZFRUURxh3XgitM6w+6a+QG2lAifqajy34B3mdEqik
         chtV8CsubTPT4G0DezyeYY3v/q5mId4YwQC0HGMgl26p4g+CCrSqgPHQu3lxwTAr5yd7
         ZmNAivKeIj4RpOrd9Is1nsdYB6yPd3iIJj89poboDPPjCJ7AOn+G4wxa5WupJzZCw2bu
         YrCqAbV9VQAh1GQHiQ4PjNQttoq9Qg8sp5LERRxPaTuoOublcODdqDGAxBzAyGcxrktC
         MFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=1Znq1maKyw5UUSmsaWTHDyjgWo5hBVcIwQH8KFEYS+Y=;
        b=o4e4uLKs7DbnWOsacQ9m3E/7N3bMEx74L3LxAVriaShAT54fA3Qd01wQ8PC3i8qk3u
         Fxjiz41PQnxJSXmwKGuRXbRp+AklN/CoJsqxvbzfvjqKS1AtX6l29IznW+JAzD6yZFfF
         jLw1NVlqHwg9ftl69YGO6Emjok1QMZ8ihJvC4Iq+HBL4KqdGPd/8gQ0GGCG5wApsjxEK
         L2lmqczzzQOsz/EaaK3Sez+YEgImMN9u/zqUL+E5CcfglCRjZqydGsolzuX+up6+F0fi
         DXaNmeATzZ7cx0cNUFY++j6yCI/5N/FDTB0OJf02RYF9UqrZtrCbGF6Ma1kV3N9jnac+
         wLSQ==
X-Gm-Message-State: ACgBeo3VZYuHQNhWr7qiPdX3+zf31fzbDru7IBrVNAZKPg+/KMTJ3m0B
        zFlS0+HxszeLEBNmXpw+KMTXThLUIjSPlg==
X-Google-Smtp-Source: AA6agR5Auu79t2vocxzM0J7VwN+kujy2mdx5zmduicAIUDR3+j9Ij4ZwdFjuX9Tn0O9pQZ3mxQMo1Q==
X-Received: by 2002:a17:90a:2eca:b0:1fa:a687:cfd9 with SMTP id h10-20020a17090a2eca00b001faa687cfd9mr1267187pjs.78.1660697788016;
        Tue, 16 Aug 2022 17:56:28 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:27 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 1/9] xfs: flush inodegc workqueue tasks before cancel
Date:   Tue, 16 Aug 2022 17:56:02 -0700
Message-Id: <20220817005610.3170067-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 6191cf3ad59fda5901160633fef8e41b064a5246 ]

The xfs_inodegc_stop() helper performs a high level flush of pending
work on the percpu queues and then runs a cancel_work_sync() on each
of the percpu work tasks to ensure all work has completed before
returning.  While cancel_work_sync() waits for wq tasks to complete,
it does not guarantee work tasks have started. This means that the
_stop() helper can queue and instantly cancel a wq task without
having completed the associated work. This can be observed by
tracepoint inspection of a simple "rm -f <file>; fsfreeze -f <mnt>"
test:

	xfs_destroy_inode: ... ino 0x83 ...
	xfs_inode_set_need_inactive: ... ino 0x83 ...
	xfs_inodegc_stop: ...
	...
	xfs_inodegc_start: ...
	xfs_inodegc_worker: ...
	xfs_inode_inactivating: ... ino 0x83 ...

The first few lines show that the inode is removed and need inactive
state set, but the inactivation work has not completed before the
inodegc mechanism stops. The inactivation doesn't actually occur
until the fs is unfrozen and the gc mechanism starts back up. Note
that this test requires fsfreeze to reproduce because xfs_freeze
indirectly invokes xfs_fs_statfs(), which calls xfs_inodegc_flush().

When this occurs, the workqueue try_to_grab_pending() logic first
tries to steal the pending bit, which does not succeed because the
bit has been set by queue_work_on(). Subsequently, it checks for
association of a pool workqueue from the work item under the pool
lock. This association is set at the point a work item is queued and
cleared when dequeued for processing. If the association exists, the
work item is removed from the queue and cancel_work_sync() returns
true. If the pwq association is cleared, the remove attempt assumes
the task is busy and retries (eventually returning false to the
caller after waiting for the work task to complete).

To avoid this race, we can flush each work item explicitly before
cancel. However, since the _queue_all() already schedules each
underlying work item, the workqueue level helpers are sufficient to
achieve the same ordering effect. E.g., the inodegc enabled flag
prevents scheduling any further work in the _stop() case. Use the
drain_workqueue() helper in this particular case to make the intent
a bit more self explanatory.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_icache.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f2210d927481..5e44d7bbd8fc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1872,28 +1872,20 @@ xfs_inodegc_worker(
 }
 
 /*
- * Force all currently queued inode inactivation work to run immediately, and
- * wait for the work to finish. Two pass - queue all the work first pass, wait
- * for it in a second pass.
+ * Force all currently queued inode inactivation work to run immediately and
+ * wait for the work to finish.
  */
 void
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
-	struct xfs_inodegc	*gc;
-	int			cpu;
-
 	if (!xfs_is_inodegc_enabled(mp))
 		return;
 
 	trace_xfs_inodegc_flush(mp, __return_address);
 
 	xfs_inodegc_queue_all(mp);
-
-	for_each_online_cpu(cpu) {
-		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		flush_work(&gc->work);
-	}
+	flush_workqueue(mp->m_inodegc_wq);
 }
 
 /*
@@ -1904,18 +1896,12 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
-	struct xfs_inodegc	*gc;
-	int			cpu;
-
 	if (!xfs_clear_inodegc_enabled(mp))
 		return;
 
 	xfs_inodegc_queue_all(mp);
+	drain_workqueue(mp->m_inodegc_wq);
 
-	for_each_online_cpu(cpu) {
-		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		cancel_work_sync(&gc->work);
-	}
 	trace_xfs_inodegc_stop(mp, __return_address);
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

