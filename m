Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD40AC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8D0207E8
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fOFHT436"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404355AbgFYLcF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 07:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404274AbgFYLcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 07:32:03 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0233C061573;
        Thu, 25 Jun 2020 04:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=mFSG9oe6oASQv2j0OrxMcHvjeIF6oUGHMTMcMkcCnrM=; b=fOFHT4360Ni6vzSN6CHRl8qOUN
        SC+/ARqKz2mtW6UlT3JYoXonGt4ZrqId3cqJAw7Dso1Nh731SuantntDxFDkBFc4F2Db7rJWZ/RXn
        vRv/iBqYr4CeD86rVERzGCksxjKka0U0LS5t+f0TtaSlqvJSB8OMSs5WO67dPNSXWl7p0Wpsre4q1
        gloJGO/sgYxcQ2Dt1axIVhfw+fRppDFUFRBEkw1jRFihwMSwNo4R1dG3AWqxVYPXHuTYVdLiM3WHX
        uFwoeqnq95Bv7UQXQEXf3KTQRysK1fjEaYq0sx4gctVgcxSKSS4U2F7kxjQjYkv00XZSL/xlAUz5H
        zey0QKGQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joQ6W-0001zO-Ks; Thu, 25 Jun 2020 11:31:40 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: [PATCH 1/6] mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
Date:   Thu, 25 Jun 2020 12:31:17 +0100
Message-Id: <20200625113122.7540-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We're short on PF_* flags, so make memalloc_noio its own bit where we
have plenty of space.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/block/loop.c           |  3 ++-
 drivers/md/dm-zoned-metadata.c |  5 ++---
 include/linux/sched.h          |  2 +-
 include/linux/sched/mm.h       | 30 +++++++++++++++++++++++-------
 kernel/sys.c                   |  8 +++-----
 5 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 475e1a738560..c8742e25e58a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -52,6 +52,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/stat.h>
@@ -929,7 +930,7 @@ static void loop_unprepare_queue(struct loop_device *lo)
 
 static int loop_kthread_worker_fn(void *worker_ptr)
 {
-	current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
+	set_current_io_flusher();
 	return kthread_worker_fn(worker_ptr);
 }
 
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 130b5a6d9f12..1c5ae674ba20 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1599,9 +1599,8 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 	/*
 	 * Get zone information from disk. Since blkdev_report_zones() uses
-	 * GFP_KERNEL by default for memory allocations, set the per-task
-	 * PF_MEMALLOC_NOIO flag so that all allocations are done as if
-	 * GFP_NOIO was specified.
+	 * GFP_KERNEL by default for memory allocations, use
+	 * memalloc_noio_save() to prevent recursion into the driver.
 	 */
 	noio_flag = memalloc_noio_save();
 	ret = blkdev_report_zones(dev->bdev, dmz_start_sect(zmd, zone), 1,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b62e6aaf28f0..cf18a3d2bc4c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -801,6 +801,7 @@ struct task_struct {
 	/* Stalled due to lack of memory */
 	unsigned			in_memstall:1;
 #endif
+	unsigned			memalloc_noio:1;
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
@@ -1505,7 +1506,6 @@ extern struct pid *cad_pid;
 #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
-#define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
 #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 480a4d1b7dd8..1a7e1ab1be85 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -175,19 +175,18 @@ static inline bool in_vfork(struct task_struct *tsk)
 
 /*
  * Applies per-task gfp context to the given allocation flags.
- * PF_MEMALLOC_NOIO implies GFP_NOIO
  * PF_MEMALLOC_NOFS implies GFP_NOFS
  * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely(current->flags &
-		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
+	if (unlikely(current->flags & (PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA) ||
+		     current->memalloc_noio)) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
 		 */
-		if (current->flags & PF_MEMALLOC_NOIO)
+		if (current->memalloc_noio)
 			flags &= ~(__GFP_IO | __GFP_FS);
 		else if (current->flags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
@@ -224,8 +223,8 @@ static inline void fs_reclaim_release(gfp_t gfp_mask) { }
  */
 static inline unsigned int memalloc_noio_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_NOIO;
-	current->flags |= PF_MEMALLOC_NOIO;
+	unsigned int flags = current->memalloc_noio;
+	current->memalloc_noio = 1;
 	return flags;
 }
 
@@ -239,7 +238,7 @@ static inline unsigned int memalloc_noio_save(void)
  */
 static inline void memalloc_noio_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
+	current->memalloc_noio = flags ? 1 : 0;
 }
 
 /**
@@ -309,6 +308,23 @@ static inline void memalloc_nocma_restore(unsigned int flags)
 }
 #endif
 
+static inline void set_current_io_flusher(void)
+{
+	current->flags |= PF_LOCAL_THROTTLE;
+	current->memalloc_noio = 1;
+}
+
+static inline void clear_current_io_flusher(void)
+{
+	current->flags &= ~PF_LOCAL_THROTTLE;
+	current->memalloc_noio = 0;
+}
+
+static inline bool get_current_io_flusher(void)
+{
+	return current->flags & PF_LOCAL_THROTTLE;
+}
+
 #ifdef CONFIG_MEMCG
 /**
  * memalloc_use_memcg - Starts the remote memcg charging scope.
diff --git a/kernel/sys.c b/kernel/sys.c
index 00a96746e28a..78c90d1e92f4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2275,8 +2275,6 @@ int __weak arch_prctl_spec_ctrl_set(struct task_struct *t, unsigned long which,
 	return -EINVAL;
 }
 
-#define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LOCAL_THROTTLE)
-
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2512,9 +2510,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			return -EINVAL;
 
 		if (arg2 == 1)
-			current->flags |= PR_IO_FLUSHER;
+			set_current_io_flusher();
 		else if (!arg2)
-			current->flags &= ~PR_IO_FLUSHER;
+			clear_current_io_flusher();
 		else
 			return -EINVAL;
 		break;
@@ -2525,7 +2523,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
 
-		error = (current->flags & PR_IO_FLUSHER) == PR_IO_FLUSHER;
+		error = get_current_io_flusher();
 		break;
 	default:
 		error = -EINVAL;
-- 
2.27.0

