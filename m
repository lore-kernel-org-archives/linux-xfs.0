Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4683EC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 245D220857
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yz6d60HF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404387AbgFYLcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 07:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404294AbgFYLcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 07:32:13 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB69C061573;
        Thu, 25 Jun 2020 04:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=m3zIJR1GLxQvWQCzE4jnGcCRy0+cfvlIlDcMBi87b1U=; b=Yz6d60HFl8ZOkmuYN8KDj8d4N1
        /pvduhtSNLhN+lYKmZ5AKUNIlGSutu7dEYip3ios1IG5YtI76FG7MW20IWOi5HxsHaCo1W5eZEsz1
        QbVUirW1fbnx8U0HVpL4QAhNPmRttImTnF6nn8WDIVLw3T5bfgN+83mRgi4tdvZ7DR9MbBSHlLwyh
        bzOC4VEcVd922wuCLAGA4ZPQ8RrS3ui1ckYcySCVvhd5rKIiHjC9JwGULQMVHeZQeEUkxRGV9jH9P
        hnKygg85pw7NTrrdiaxJJ83Z+TwmWHnVNe3/BD8JSOWQRMO4Jag5ZuZ8rA1+s7Jdok+pLIbE4DcYY
        tis6kWcg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joQ6X-0001ze-A5; Thu, 25 Jun 2020 11:31:41 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: [PATCH 5/6] mm: Replace PF_MEMALLOC_NOIO with memalloc_nocma
Date:   Thu, 25 Jun 2020 12:31:21 +0100
Message-Id: <20200625113122.7540-6-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We're short on PF_* flags, so make memalloc_nocma its own bit where we
have plenty of space.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/sched.h    |  2 +-
 include/linux/sched/mm.h | 15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index eaf36ae1fde2..90336850e940 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -803,6 +803,7 @@ struct task_struct {
 #endif
 	unsigned			memalloc_noio:1;
 	unsigned			memalloc_nofs:1;
+	unsigned			memalloc_nocma:1;
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
@@ -1514,7 +1515,6 @@ extern struct pid *cad_pid;
 #define PF_UMH			0x02000000	/* I'm an Usermodehelper process */
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
-#define PF_MEMALLOC_NOCMA	0x10000000	/* All allocation request will have _GFP_MOVABLE cleared */
 #define PF_IO_WORKER		0x20000000	/* Task is an IO worker */
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 08bc9d0606a8..6f7b59a848a6 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -175,12 +175,11 @@ static inline bool in_vfork(struct task_struct *tsk)
 
 /*
  * Applies per-task gfp context to the given allocation flags.
- * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely((current->flags & PF_MEMALLOC_NOCMA) ||
-		     current->memalloc_noio || current->memalloc_nofs)) {
+	if (unlikely(current->memalloc_noio || current->memalloc_nofs ||
+		     current->memalloc_nocma)) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
@@ -190,7 +189,8 @@ static inline gfp_t current_gfp_context(gfp_t flags)
 		else if (current->memalloc_nofs)
 			flags &= ~__GFP_FS;
 #ifdef CONFIG_CMA
-		if (current->flags & PF_MEMALLOC_NOCMA)
+		/* memalloc_nocma implies no allocation from movable region */
+		if (current->memalloc_nocma)
 			flags &= ~__GFP_MOVABLE;
 #endif
 	}
@@ -286,15 +286,14 @@ static inline void memalloc_noreclaim_restore(unsigned int flags)
 #ifdef CONFIG_CMA
 static inline unsigned int memalloc_nocma_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_NOCMA;
-
-	current->flags |= PF_MEMALLOC_NOCMA;
+	unsigned int flags = current->memalloc_nocma;
+	current->memalloc_nocma = 1;
 	return flags;
 }
 
 static inline void memalloc_nocma_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_NOCMA) | flags;
+	current->memalloc_nocma = flags ? 1 : 0;
 }
 #else
 static inline unsigned int memalloc_nocma_save(void)
-- 
2.27.0

