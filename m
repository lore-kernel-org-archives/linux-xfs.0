Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B87C8300E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 09:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B22722244
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 09:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="NHf9AOhA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgKTJ4l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbgKTJ4O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Nov 2020 04:56:14 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483BAC061A48
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 01:56:14 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id u12so9444909wrt.0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 01:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7+q8vKHO3EFjaJ879GkRcmDKHJR9JgE21VUyxKW3mY0=;
        b=NHf9AOhApOcnNW/Sr7K7lwSXd9Ck9Z5/C9QZ4NYblHO1KiG0SUmf/3/kmWsXvPhkQT
         4FJM/oryQSQIsGzo7RJ1DYRxlHGoSPqMsoUII89W+KZZMQA32qYyL67Mj55nLL5PhTVd
         UhLCk32vlvzz7bBzhH/KI4Qlskc0xIQ5mkZWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7+q8vKHO3EFjaJ879GkRcmDKHJR9JgE21VUyxKW3mY0=;
        b=B/6WqlagEk540/2/A0nyXjTtIfChomADZY3fIZ/UBk9v4zoMrAcFQMGGQJ0/qJ6tXN
         x/HPkg4nSEeAp7NsGcCIDmFqN2hp+9RGWsgBAoSSov1bmV0EQzALUjo1naoqNjNZSr1e
         nPLGDNqsils8G+f5tWOs9QYOCI2EvQM4pDwEPZ7/Oc0QPYs+VB5foa31WHB903h05lTD
         VkRLfsVIPp9BLD1vTAII7HnR1k+/raZKroKuKKhWWgGFmc1wOiu+BSTETmFX7qEOJmEE
         OkfyAVaW4tzC8kLqAsyZYE5d1Kdqd1vs5kxECTYHg64L9BC/fpJLGXqCPdurFFQcvgwS
         Hz1A==
X-Gm-Message-State: AOAM531criwF6yuhXQboi2sHOypO/bXdVdYln8otNrS5fw2tmanSRomP
        In4qu3RrFM77l73TlsBWKZRVRA==
X-Google-Smtp-Source: ABdhPJwJqZ9GhiqgSrImpdEVhjBbuglJqMxiUAwvoL3/huYCtyyfr42+HCgkw04wdaJDXAX4ODo8vQ==
X-Received: by 2002:a5d:654b:: with SMTP id z11mr14013175wrv.291.1605866173041;
        Fri, 20 Nov 2020 01:56:13 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id t9sm4500208wrr.49.2020.11.20.01.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:56:12 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        Waiman Long <longman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 2/3] mm: Extract might_alloc() debug check
Date:   Fri, 20 Nov 2020 10:54:43 +0100
Message-Id: <20201120095445.1195585-3-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120095445.1195585-1-daniel.vetter@ffwll.ch>
References: <20201120095445.1195585-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Extracted from slab.h, which seems to have the most complete version
including the correct might_sleep() check. Roll it out to slob.c.

Motivated by a discussion with Paul about possibly changing call_rcu
behaviour to allocate memory, but only roughly every 500th call.

There are a lot fewer places in the kernel that care about whether
allocating memory is allowed or not (due to deadlocks with reclaim
code) than places that care whether sleeping is allowed. But debugging
these also tends to be a lot harder, so nice descriptive checks could
come in handy. I might have some use eventually for annotations in
drivers/gpu.

Note that unlike fs_reclaim_acquire/release gfpflags_allow_blocking
does not consult the PF_MEMALLOC flags. But there is no flag
equivalent for GFP_NOWAIT, hence this check can't go wrong due to
memalloc_no*_save/restore contexts. Willy is working on a patch series
which might change this:

https://lore.kernel.org/linux-mm/20200625113122.7540-7-willy@infradead.org/

I think best would be if that updates gfpflags_allow_blocking(), since
there's a ton of callers all over the place for that already.

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qian Cai <cai@lca.pw>
Cc: linux-xfs@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 include/linux/sched/mm.h | 16 ++++++++++++++++
 mm/slab.h                |  5 +----
 mm/slob.c                |  6 ++----
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index d5ece7a9a403..f94405d43fd1 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -180,6 +180,22 @@ static inline void fs_reclaim_acquire(gfp_t gfp_mask) { }
 static inline void fs_reclaim_release(gfp_t gfp_mask) { }
 #endif
 
+/**
+ * might_alloc - Marks possible allocation sites
+ * @gfp_mask: gfp_t flags that would be use to allocate
+ *
+ * Similar to might_sleep() and other annotations this can be used in functions
+ * that might allocate, but often dont. Compiles to nothing without
+ * CONFIG_LOCKDEP. Includes a conditional might_sleep() if @gfp allows blocking.
+ */
+static inline void might_alloc(gfp_t gfp_mask)
+{
+	fs_reclaim_acquire(gfp_mask);
+	fs_reclaim_release(gfp_mask);
+
+	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
+}
+
 /**
  * memalloc_noio_save - Marks implicit GFP_NOIO allocation scope.
  *
diff --git a/mm/slab.h b/mm/slab.h
index 6d7c6a5056ba..37b981247e5d 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -500,10 +500,7 @@ static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
 {
 	flags &= gfp_allowed_mask;
 
-	fs_reclaim_acquire(flags);
-	fs_reclaim_release(flags);
-
-	might_sleep_if(gfpflags_allow_blocking(flags));
+	might_alloc(flags);
 
 	if (should_failslab(s, flags))
 		return NULL;
diff --git a/mm/slob.c b/mm/slob.c
index 7cc9805c8091..8d4bfa46247f 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -474,8 +474,7 @@ __do_kmalloc_node(size_t size, gfp_t gfp, int node, unsigned long caller)
 
 	gfp &= gfp_allowed_mask;
 
-	fs_reclaim_acquire(gfp);
-	fs_reclaim_release(gfp);
+	might_alloc(gfp);
 
 	if (size < PAGE_SIZE - minalign) {
 		int align = minalign;
@@ -597,8 +596,7 @@ static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	flags &= gfp_allowed_mask;
 
-	fs_reclaim_acquire(flags);
-	fs_reclaim_release(flags);
+	might_alloc(flags);
 
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node, 0);
-- 
2.29.2

