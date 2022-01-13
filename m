Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9424C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 13:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiAMNhG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 08:37:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233675AbiAMNhF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 08:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642081025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tVypJNJXKV55ig1dCQVylR2lwqbTZ5Jamedq0D3z3q8=;
        b=SZYhODgCnQuQ6fIL0kXWlUWgN3HObHHUeudNHGly1mlOyz95Ol7qC630rZ8RGzxHgT09Mv
        6lsyWeBzouBqoAQLzSQvKiuCYWJCSNU2dj/bFS2QwnowveAUcRlHDRfn42kAstx0jWqQiy
        v+BpTt8Q7+AC4q78bUorRS6i8ZqDmN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-GaphWMlWPxa_CEwDbP3uAA-1; Thu, 13 Jan 2022 08:37:03 -0500
X-MC-Unique: GaphWMlWPxa_CEwDbP3uAA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 098CA83DD28
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 13:37:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA9D984A26
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 13:37:02 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: flush inodegc workqueue tasks before cancel
Date:   Thu, 13 Jan 2022 08:37:00 -0500
Message-Id: <20220113133701.629593-2-bfoster@redhat.com>
In-Reply-To: <20220113133701.629593-1-bfoster@redhat.com>
References: <20220113133701.629593-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
---
 fs/xfs/xfs_icache.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d019c98eb839..7a2a5e2be3cf 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1852,28 +1852,20 @@ xfs_inodegc_worker(
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
@@ -1884,18 +1876,12 @@ void
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
2.31.1

