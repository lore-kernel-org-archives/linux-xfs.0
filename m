Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B418FC56202
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D649206F7
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:26:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="jVHAscAY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgKYQZp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 11:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731575AbgKYQZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 11:25:44 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B56CC061A55
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:25:44 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id p19so1898642wmg.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S5C08Hy1XMQFC0buOh9jSFHuZ0iwVVw80p1E5iRWSvg=;
        b=jVHAscAYlfUZpaUDcWeAN+ImydgMtSo0J4j+H0r2qtoN4JmJx9Vve4jifNb53zuGqi
         Ho1AFwAoWORedY91OsjnrVbKw6hwQJ2Kv5B8EMyK5Y7KSllnc5Cw2fu9iTZNFFbiKE7V
         xTc7fqCfuiYJbUWlEUEfD8UXGnYqpwS8fW1sk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S5C08Hy1XMQFC0buOh9jSFHuZ0iwVVw80p1E5iRWSvg=;
        b=ll8NlwTy/nPvYB7PJVO9giRD2wsjVI5tRoFE1/xcZQk6aSHLtnRnqgyEIPEukR8L6w
         4u++KwPHDy0y1RAX4BYEvxpdV1g2ZNwvI/cekOdiXoXkv8JeMXHxNjDSrzEcMg/Uat80
         SJArPrer4FCfXWSyqcllPrcrEzInX2v4cea3tbnVaBSfwJLru7Cvtm0nGBVdSfn3ZSDw
         YeFosFfQYftFVW5MqtfqXpUpWdm36HvI0qd7o/l+lTO8hEflLGzImKyAYEdZetqwLa68
         aHpP3d6FMSlu6N1VnvBR3YQ6zXvlCdqDOPwIaSqTntn/qXsi7BFPGbDHe///bAQDNoT7
         k44A==
X-Gm-Message-State: AOAM531BcHk/1v5h7EfZ1Q8vHk8ycIA9obF412KMynl/OIEG6UH+Fpqt
        k1MlTuH/REBFBVw2XX7JjE4dZg==
X-Google-Smtp-Source: ABdhPJxvYwNleTXWY/S3WavDz5/k2r0sp2h9zjamdvz+WUc8Vx3B5vSrofONxe4Fcqlg5PcbCQYGaQ==
X-Received: by 2002:a7b:c3ce:: with SMTP id t14mr4768131wmj.170.1606321543202;
        Wed, 25 Nov 2020 08:25:43 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id a21sm4855187wmb.38.2020.11.25.08.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 08:25:42 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v4 3/3] locking/selftests: Add testcases for fs_reclaim
Date:   Wed, 25 Nov 2020 17:25:31 +0100
Message-Id: <20201125162532.1299794-4-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
References: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since I butchered this I figured better to make sure we have testcases
for this now. Since we only have a locking context for __GFP_FS that's
the only thing we're testing right now.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 lib/locking-selftest.c | 47 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index a899b3f0e2e5..ad47c3358e30 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/ww_mutex.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/delay.h>
 #include <linux/lockdep.h>
 #include <linux/spinlock.h>
@@ -2357,6 +2358,50 @@ static void queued_read_lock_tests(void)
 	pr_cont("\n");
 }
 
+static void fs_reclaim_correct_nesting(void)
+{
+	fs_reclaim_acquire(GFP_KERNEL);
+	might_alloc(GFP_NOFS);
+	fs_reclaim_release(GFP_KERNEL);
+}
+
+static void fs_reclaim_wrong_nesting(void)
+{
+	fs_reclaim_acquire(GFP_KERNEL);
+	might_alloc(GFP_KERNEL);
+	fs_reclaim_release(GFP_KERNEL);
+}
+
+static void fs_reclaim_protected_nesting(void)
+{
+	unsigned int flags;
+
+	fs_reclaim_acquire(GFP_KERNEL);
+	flags = memalloc_nofs_save();
+	might_alloc(GFP_KERNEL);
+	memalloc_nofs_restore(flags);
+	fs_reclaim_release(GFP_KERNEL);
+}
+
+static void fs_reclaim_tests(void)
+{
+	printk("  --------------------\n");
+	printk("  | fs_reclaim tests |\n");
+	printk("  --------------------\n");
+
+	print_testname("correct nesting");
+	dotest(fs_reclaim_correct_nesting, SUCCESS, 0);
+	pr_cont("\n");
+
+	print_testname("wrong nesting");
+	dotest(fs_reclaim_wrong_nesting, FAILURE, 0);
+	pr_cont("\n");
+
+	print_testname("protected nesting");
+	dotest(fs_reclaim_protected_nesting, SUCCESS, 0);
+	pr_cont("\n");
+}
+
 void locking_selftest(void)
 {
 	/*
@@ -2478,6 +2523,8 @@ void locking_selftest(void)
 	if (IS_ENABLED(CONFIG_QUEUED_RWLOCKS))
 		queued_read_lock_tests();
 
+	fs_reclaim_tests();
+
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
 		debug_locks = 0;
-- 
2.29.2

