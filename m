Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF5AC83012
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E615206F7
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="EwcEQpQn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbgKYQZ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 11:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731510AbgKYQZl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 11:25:41 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA04C061A54
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:25:41 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l1so2478507wrb.9
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jq9JvDrUL/TA9GTf55fSJ4uVoaSHU81yQFdcXJqW7Ws=;
        b=EwcEQpQn9sIUpy3VrHTfZCx3MPEmQJn+LBDPHPCzLmPl19zl8PL/wo6hXJzLXKzkVd
         eTK6d9iOsjq+GfHfZcwVX8jhaHn1fyLOkz1YP3/MrF/8+dgjPE0H/vk2rNTF6cIgsW8N
         OrTbGqPT6yprBftpY5K2pCQQxmIfCizGEPS5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jq9JvDrUL/TA9GTf55fSJ4uVoaSHU81yQFdcXJqW7Ws=;
        b=IgEu0UuJVipggLRS0AKxQ6L2+bKzAe2oMXS92mipv75jMwMpqU3LirSl196FSOe/cJ
         ViQiW9rwW9ovRnPziy8t/a2WGFkJVbTNH+OMXeHf8rtxxJbCaY//tddf/mRu9k3PZ5f+
         r1Jqg2rq0tu/7wUeu+IeHS5vQEMVvVkttL33OcGrLbYhNtKb+8nPzQjSOZXcY1zKhlvP
         iCk+TSkrhCKZD1muoYlmZuBEOKe4ZyXb0P4EA2nmcA5r67/+FcSfdLHkjivKOgHmIwNU
         50ZaEDojhJTrmHHJqf/Q+FwYOSXwt7uzJ+0FnmyfA+XYYbNhCSVAAgwjDQKwfdIid9Nm
         U33w==
X-Gm-Message-State: AOAM533jGCoJ+JUKbKXDSJp1GICqa4Nx1NC9lc9iNA69yUOu2p8I3auy
        RvZnO3EJn2LFfsYofRtMN1r2/g==
X-Google-Smtp-Source: ABdhPJx/RDigUSrDHbk/aNrMeP5KeOA6e2iW4/mH8GTRlb9VB29XGiIfdu01Y9YBBtZepTIzy4xVVA==
X-Received: by 2002:a5d:5505:: with SMTP id b5mr5055205wrv.410.1606321539765;
        Wed, 25 Nov 2020 08:25:39 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id a21sm4855187wmb.38.2020.11.25.08.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 08:25:38 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH v4 1/3] mm: Track mmu notifiers in fs_reclaim_acquire/release
Date:   Wed, 25 Nov 2020 17:25:29 +0100
Message-Id: <20201125162532.1299794-2-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
References: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs_reclaim_acquire/release nicely catch recursion issues when
allocating GFP_KERNEL memory against shrinkers (which gpu drivers tend
to use to keep the excessive caches in check). For mmu notifier
recursions we do have lockdep annotations since 23b68395c7c7
("mm/mmu_notifiers: add a lockdep map for invalidate_range_start/end").

But these only fire if a path actually results in some pte
invalidation - for most small allocations that's very rarely the case.
The other trouble is that pte invalidation can happen any time when
__GFP_RECLAIM is set. Which means only really GFP_ATOMIC is a safe
choice, GFP_NOIO isn't good enough to avoid potential mmu notifier
recursion.

I was pondering whether we should just do the general annotation, but
there's always the risk for false positives. Plus I'm assuming that
the core fs and io code is a lot better reviewed and tested than
random mmu notifier code in drivers. Hence why I decide to only
annotate for that specific case.

Furthermore even if we'd create a lockdep map for direct reclaim, we'd
still need to explicit pull in the mmu notifier map - there's a lot
more places that do pte invalidation than just direct reclaim, these
two contexts arent the same.

Note that the mmu notifiers needing their own independent lockdep map
is also the reason we can't hold them from fs_reclaim_acquire to
fs_reclaim_release - it would nest with the acquistion in the pte
invalidation code, causing a lockdep splat. And we can't remove the
annotations from pte invalidation and all the other places since
they're called from many other places than page reclaim. Hence we can
only do the equivalent of might_lock, but on the raw lockdep map.

With this we can also remove the lockdep priming added in 66204f1d2d1b
("mm/mmu_notifiers: prime lockdep") since the new annotations are
strictly more powerful.

v2: Review from Thomas Hellstrom:
- unbotch the fs_reclaim context check, I accidentally inverted it,
  but it didn't blow up because I inverted it immediately
- fix compiling for !CONFIG_MMU_NOTIFIER

v3: Unbreak the PF_MEMALLOC_ context flags. Thanks to Qian for the
report and Dave for explaining what I failed to see.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qian Cai <cai@lca.pw>
Cc: linux-xfs@vger.kernel.org
Cc: Thomas Hellström (Intel) <thomas_os@shipmail.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-mm@kvack.org
Cc: linux-rdma@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 mm/mmu_notifier.c |  7 -------
 mm/page_alloc.c   | 31 ++++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 5654dd19addc..61ee40ed804e 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -612,13 +612,6 @@ int __mmu_notifier_register(struct mmu_notifier *subscription,
 	mmap_assert_write_locked(mm);
 	BUG_ON(atomic_read(&mm->mm_users) <= 0);
 
-	if (IS_ENABLED(CONFIG_LOCKDEP)) {
-		fs_reclaim_acquire(GFP_KERNEL);
-		lock_map_acquire(&__mmu_notifier_invalidate_range_start_map);
-		lock_map_release(&__mmu_notifier_invalidate_range_start_map);
-		fs_reclaim_release(GFP_KERNEL);
-	}
-
 	if (!mm->notifier_subscriptions) {
 		/*
 		 * kmalloc cannot be called under mm_take_all_locks(), but we
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 23f5066bd4a5..ff0f9a84b8de 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -57,6 +57,7 @@
 #include <trace/events/oom.h>
 #include <linux/prefetch.h>
 #include <linux/mm_inline.h>
+#include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
@@ -4264,10 +4265,8 @@ should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_fla
 static struct lockdep_map __fs_reclaim_map =
 	STATIC_LOCKDEP_MAP_INIT("fs_reclaim", &__fs_reclaim_map);
 
-static bool __need_fs_reclaim(gfp_t gfp_mask)
+static bool __need_reclaim(gfp_t gfp_mask)
 {
-	gfp_mask = current_gfp_context(gfp_mask);
-
 	/* no reclaim without waiting on it */
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return false;
@@ -4276,10 +4275,6 @@ static bool __need_fs_reclaim(gfp_t gfp_mask)
 	if (current->flags & PF_MEMALLOC)
 		return false;
 
-	/* We're only interested __GFP_FS allocations for now */
-	if (!(gfp_mask & __GFP_FS))
-		return false;
-
 	if (gfp_mask & __GFP_NOLOCKDEP)
 		return false;
 
@@ -4298,15 +4293,29 @@ void __fs_reclaim_release(void)
 
 void fs_reclaim_acquire(gfp_t gfp_mask)
 {
-	if (__need_fs_reclaim(gfp_mask))
-		__fs_reclaim_acquire();
+	gfp_mask = current_gfp_context(gfp_mask);
+
+	if (__need_reclaim(gfp_mask)) {
+		if (gfp_mask & __GFP_FS)
+			__fs_reclaim_acquire();
+
+#ifdef CONFIG_MMU_NOTIFIER
+		lock_map_acquire(&__mmu_notifier_invalidate_range_start_map);
+		lock_map_release(&__mmu_notifier_invalidate_range_start_map);
+#endif
+
+	}
 }
 EXPORT_SYMBOL_GPL(fs_reclaim_acquire);
 
 void fs_reclaim_release(gfp_t gfp_mask)
 {
-	if (__need_fs_reclaim(gfp_mask))
-		__fs_reclaim_release();
+	gfp_mask = current_gfp_context(gfp_mask);
+
+	if (__need_reclaim(gfp_mask)) {
+		if (gfp_mask & __GFP_FS)
+			__fs_reclaim_release();
+	}
 }
 EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
-- 
2.29.2

