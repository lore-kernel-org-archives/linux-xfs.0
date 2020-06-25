Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED32C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1608B20781
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hMZIKCkE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404320AbgFYLb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 07:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404274AbgFYLb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 07:31:58 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CEAC061795;
        Thu, 25 Jun 2020 04:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=25KfWqTg5VgYg3/Dyq0fuOQ2ndu57hg32uRL8rzgLQM=; b=hMZIKCkEzhGgbe7QeG+ypRFK/O
        qk5gq28BAHhlWFdwae7+1BKIcUcsn8Gsec4d1/FOm89F3owYZdYRN+Z7dxR8EwX1ryuxs5Qdlzztm
        GiiMOPMto2/02VlUcETaNqI3K8ggTBChPeDZ7L7ah8hdi2N/TzJBsI8zpUByP5HI4vKWa/VKCuYiY
        m1HDAbN2U7h85AjVikVhadfIROzsOemw2XieblpHZyhvlfB/UFzUsULjKMFgJszZkEcF2glew+P2i
        3PI+EVE6gCanw/RAdqMvGgcCC0tI8oc3d3pvvIqXMHnfPozLveID5hj+mCWbbNp19qETJT6EwIJz/
        K24Fe3Ig==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joQ6X-0001zi-Ea; Thu, 25 Jun 2020 11:31:41 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: [PATCH 6/6] mm: Add memalloc_nowait
Date:   Thu, 25 Jun 2020 12:31:22 +0100
Message-Id: <20200625113122.7540-7-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
guarantees we will not sleep to reclaim memory.  Use it to simplify
dm-bufio's allocations.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/dm-bufio.c    | 30 ++++++++----------------------
 include/linux/sched.h    |  1 +
 include/linux/sched/mm.h | 12 ++++++++----
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 6d1565021d74..140ada9a2c8f 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -412,23 +412,6 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 
 	*data_mode = DATA_MODE_VMALLOC;
 
-	/*
-	 * __vmalloc allocates the data pages and auxiliary structures with
-	 * gfp_flags that were specified, but pagetables are always allocated
-	 * with GFP_KERNEL, no matter what was specified as gfp_mask.
-	 *
-	 * Consequently, we must set per-process flag PF_MEMALLOC_NOIO so that
-	 * all allocations done by this process (including pagetables) are done
-	 * as if GFP_NOIO was specified.
-	 */
-	if (gfp_mask & __GFP_NORETRY) {
-		unsigned noio_flag = memalloc_noio_save();
-		void *ptr = __vmalloc(c->block_size, gfp_mask);
-
-		memalloc_noio_restore(noio_flag);
-		return ptr;
-	}
-
 	return __vmalloc(c->block_size, gfp_mask);
 }
 
@@ -866,9 +849,6 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
 	 * dm-bufio is resistant to allocation failures (it just keeps
 	 * one buffer reserved in cases all the allocations fail).
 	 * So set flags to not try too hard:
-	 *	GFP_NOWAIT: don't wait; if we need to sleep we'll release our
-	 *		    mutex and wait ourselves.
-	 *	__GFP_NORETRY: don't retry and rather return failure
 	 *	__GFP_NOMEMALLOC: don't use emergency reserves
 	 *	__GFP_NOWARN: don't print a warning in case of failure
 	 *
@@ -877,7 +857,9 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
 	 */
 	while (1) {
 		if (dm_bufio_cache_size_latch != 1) {
-			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+			unsigned nowait_flag = memalloc_nowait_save();
+			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
+			memalloc_nowait_restore(nowait_flag);
 			if (b)
 				return b;
 		}
@@ -886,8 +868,12 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
 			return NULL;
 
 		if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
+			unsigned noio_flag;
+
 			dm_bufio_unlock(c);
-			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+			noio_flag = memalloc_noio_save();
+			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
+			memalloc_noio_restore(noio_flag);
 			dm_bufio_lock(c);
 			if (b)
 				return b;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 90336850e940..b1c2cddd366c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -803,6 +803,7 @@ struct task_struct {
 #endif
 	unsigned			memalloc_noio:1;
 	unsigned			memalloc_nofs:1;
+	unsigned			memalloc_nowait:1;
 	unsigned			memalloc_nocma:1;
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 6f7b59a848a6..6484569f50df 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -179,12 +179,16 @@ static inline bool in_vfork(struct task_struct *tsk)
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
 	if (unlikely(current->memalloc_noio || current->memalloc_nofs ||
-		     current->memalloc_nocma)) {
+		     current->memalloc_nocma) || current->memalloc_nowait) {
 		/*
-		 * NOIO implies both NOIO and NOFS and it is a weaker context
-		 * so always make sure it makes precedence
+		 * Clearing DIRECT_RECLAIM means we won't get to the point
+		 * of testing IO or FS, so we don't need to bother clearing
+		 * them.  noio implies neither IO nor FS and it is a weaker
+		 * context so always make sure it takes precedence.
 		 */
-		if (current->memalloc_noio)
+		if (current->memalloc_nowait)
+			flags &= ~__GFP_DIRECT_RECLAIM;
+		else if (current->memalloc_noio)
 			flags &= ~(__GFP_IO | __GFP_FS);
 		else if (current->memalloc_nofs)
 			flags &= ~__GFP_FS;
-- 
2.27.0

