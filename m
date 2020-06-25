Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8666FC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61DD32088E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZyI8Ej/K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404311AbgFYLb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 07:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404267AbgFYLb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 07:31:58 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEFDC0613ED;
        Thu, 25 Jun 2020 04:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Crp4AhmOUV70+9ieRKgaDTzbnRsfy5cJ4K1WeF+oLJU=; b=ZyI8Ej/KG39B3+hOJXl5accoDV
        ZwIM8vPmUud8fp963KDNrm5eXW6e1KHx8c2Va/h16g6bjDJtLD12Qe1uh0P/oicdhmwRCHppYRBn6
        nvvgIptt7YosCjpWoXpLLZq0Da17Zh4+PigsQDMhDAsc+uIAwq4qB1RTrGvNqVN1gruKDDHNPNQRs
        jZDziVcrAEx8r7CMsH2j5rkZh3auVhtCWKDNB3clJQD2tVb1tSiT3HTck2SfHMVA9fjg7JEchBB+j
        IvZs9j4HumOJu63Khhk9EsWu4iucMoT4wHPlgW2f1mLaIvAy9nlWK6765AApD3g0TrdPmxvmUdgvl
        y9oMaM0w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joQ6X-0001za-5V; Thu, 25 Jun 2020 11:31:41 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: [PATCH 4/6] mm: Replace PF_MEMALLOC_NOFS with memalloc_nofs
Date:   Thu, 25 Jun 2020 12:31:20 +0100
Message-Id: <20200625113122.7540-5-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We're short on PF_* flags, so make memalloc_nofs its own bit where we
have plenty of space.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c   |  2 +-
 include/linux/sched.h    |  2 +-
 include/linux/sched/mm.h | 13 ++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index bcfc288dba3f..87d66c13bf5c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1502,7 +1502,7 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
 	 * Given that we do not allow direct reclaim to call us, we should
 	 * never be called in a recursive filesystem reclaim context.
 	 */
-	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
+	if (WARN_ON_ONCE(current->memalloc_nofs))
 		goto redirty;
 
 	/*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cf18a3d2bc4c..eaf36ae1fde2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -802,6 +802,7 @@ struct task_struct {
 	unsigned			in_memstall:1;
 #endif
 	unsigned			memalloc_noio:1;
+	unsigned			memalloc_nofs:1;
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
@@ -1505,7 +1506,6 @@ extern struct pid *cad_pid;
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
-#define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
 #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index b0089eadc367..08bc9d0606a8 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -175,20 +175,19 @@ static inline bool in_vfork(struct task_struct *tsk)
 
 /*
  * Applies per-task gfp context to the given allocation flags.
- * PF_MEMALLOC_NOFS implies GFP_NOFS
  * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely(current->flags & (PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA) ||
-		     current->memalloc_noio)) {
+	if (unlikely((current->flags & PF_MEMALLOC_NOCMA) ||
+		     current->memalloc_noio || current->memalloc_nofs)) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
 		 */
 		if (current->memalloc_noio)
 			flags &= ~(__GFP_IO | __GFP_FS);
-		else if (current->flags & PF_MEMALLOC_NOFS)
+		else if (current->memalloc_nofs)
 			flags &= ~__GFP_FS;
 #ifdef CONFIG_CMA
 		if (current->flags & PF_MEMALLOC_NOCMA)
@@ -254,8 +253,8 @@ static inline void memalloc_noio_restore(unsigned int flags)
  */
 static inline unsigned int memalloc_nofs_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_NOFS;
-	current->flags |= PF_MEMALLOC_NOFS;
+	unsigned int flags = current->memalloc_nofs;
+	current->memalloc_nofs = 1;
 	return flags;
 }
 
@@ -269,7 +268,7 @@ static inline unsigned int memalloc_nofs_save(void)
  */
 static inline void memalloc_nofs_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_NOFS) | flags;
+	current->memalloc_nofs = flags ? 1 : 0;
 }
 
 static inline unsigned int memalloc_noreclaim_save(void)
-- 
2.27.0

