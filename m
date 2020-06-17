Return-Path: <SRS0=Ja7n=76=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F852C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 17:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1071421655
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 17:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+5rsh6f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgFQRxn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 13:53:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726966AbgFQRxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 13:53:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592416416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=lG9PxYF7wNWi6hdGvEHaNfAME07JvyZSXBUC+6tT7+4=;
        b=c+5rsh6fD4ZIcKyvD9JZctiBf4E4FbIbbcsSEWK9gUcf/4+XUJZm8RtSQtpzmkkBsdOi8I
        RFxM5zMcJ181mhHGFps3pZGZRqn2fYryy3gO25bjI1knbK3KnmqcACJSQW6QP/otbzjryl
        6oRhljHkPOEPPRd9gFLJ1kNoewU3b5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-9JqNYd6PPsKY6Z_JJ4UIBQ-1; Wed, 17 Jun 2020 13:53:33 -0400
X-MC-Unique: 9JqNYd6PPsKY6Z_JJ4UIBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A01100CCCB;
        Wed, 17 Jun 2020 17:53:31 +0000 (UTC)
Received: from llong.com (ovpn-117-167.rdu2.redhat.com [10.10.117.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D9C57BA1D;
        Wed, 17 Jun 2020 17:53:30 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v2 1/2] sched: Add PF_MEMALLOC_NOLOCKDEP flag
Date:   Wed, 17 Jun 2020 13:53:09 -0400
Message-Id: <20200617175310.20912-2-longman@redhat.com>
In-Reply-To: <20200617175310.20912-1-longman@redhat.com>
References: <20200617175310.20912-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There are cases where calling kmalloc() can lead to false positive
lockdep splat. One notable example that can happen in the freezing of
the xfs filesystem is as follows:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(sb_internal);
                               lock(fs_reclaim);
                               lock(sb_internal);
  lock(fs_reclaim);

 *** DEADLOCK ***

This is a false positive as all the dirty pages are flushed out before
the filesystem can be frozen. However, there is no easy way to modify
lockdep to handle this situation properly.

One possible workaround is to disable lockdep by setting __GFP_NOLOCKDEP
in the appropriate kmalloc() calls.  However, it will be cumbersome to
locate all the right kmalloc() calls to insert __GFP_NOLOCKDEP and it
is easy to miss some especially when the code is updated in the future.

Another alternative is to have a per-process global state that indicates
the equivalent of __GFP_NOLOCKDEP without the need to set the gfp_t flag
individually. To allow the latter case, a new PF_MEMALLOC_NOLOCKDEP
per-process flag is now added. After adding this new bit, there are
still 2 free bits left.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched.h    |  7 +++++++
 include/linux/sched/mm.h | 15 ++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b62e6aaf28f0..44247cbc9073 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1508,6 +1508,7 @@ extern struct pid *cad_pid;
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
 #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
 						 * I am cleaning dirty pages from some other bdi. */
+#define __PF_MEMALLOC_NOLOCKDEP	0x00100000	/* All allocation requests will inherit __GFP_NOLOCKDEP */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
 #define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
@@ -1519,6 +1520,12 @@ extern struct pid *cad_pid;
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
 
+#ifdef CONFIG_LOCKDEP
+#define PF_MEMALLOC_NOLOCKDEP	__PF_MEMALLOC_NOLOCKDEP
+#else
+#define PF_MEMALLOC_NOLOCKDEP	0
+#endif
+
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
  * tasks can access tsk->flags in readonly mode for example
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 480a4d1b7dd8..4a076a148568 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -177,22 +177,27 @@ static inline bool in_vfork(struct task_struct *tsk)
  * Applies per-task gfp context to the given allocation flags.
  * PF_MEMALLOC_NOIO implies GFP_NOIO
  * PF_MEMALLOC_NOFS implies GFP_NOFS
+ * PF_MEMALLOC_NOLOCKDEP implies __GFP_NOLOCKDEP
  * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely(current->flags &
-		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
+	unsigned int pflags = current->flags;
+
+	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS |
+			       PF_MEMALLOC_NOCMA | PF_MEMALLOC_NOLOCKDEP))) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
 		 */
-		if (current->flags & PF_MEMALLOC_NOIO)
+		if (pflags & PF_MEMALLOC_NOIO)
 			flags &= ~(__GFP_IO | __GFP_FS);
-		else if (current->flags & PF_MEMALLOC_NOFS)
+		else if (pflags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
+		if (pflags & PF_MEMALLOC_NOLOCKDEP)
+			flags |= __GFP_NOLOCKDEP;
 #ifdef CONFIG_CMA
-		if (current->flags & PF_MEMALLOC_NOCMA)
+		if (pflags & PF_MEMALLOC_NOCMA)
 			flags &= ~__GFP_MOVABLE;
 #endif
 	}
-- 
2.18.1

