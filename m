Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7428EC7EE24
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 10:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbjEaKEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 06:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235774AbjEaKEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 06:04:21 -0400
Received: from out-49.mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DA010E
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 03:04:19 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685527099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lnzxWyBrjsXVofp7h2XNt51t4g+fsU+gJXs/ea1cFR8=;
        b=sxRHWVlLu+rreVBFxwIJMsPglUs7BP6JtCkUt3t8Jj4/N9ua1Q2/SjbYdZXtKFG7R9C7pt
        2t9WN+oDIJxf1PqTSf920IDKgkWQRBFGYeyKYjIsrWLrD8tL2dxfTRirVmdU/LhybNhnyd
        QK69UVOEAmxZHnZIIPi+vT1ngAY56cU=
From:   Qi Zheng <qi.zheng@linux.dev>
To:     akpm@linux-foundation.org, tkhai@ya.ru, roman.gushchin@linux.dev,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, brauner@kernel.org,
        djwong@kernel.org, hughd@google.com, paulmck@kernel.org,
        muchun.song@linux.dev
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 1/8] mm: vmscan: move shrinker_debugfs_remove() before synchronize_srcu()
Date:   Wed, 31 May 2023 09:57:35 +0000
Message-Id: <20230531095742.2480623-2-qi.zheng@linux.dev>
In-Reply-To: <20230531095742.2480623-1-qi.zheng@linux.dev>
References: <20230531095742.2480623-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>

The debugfs_remove_recursive() will wait for debugfs_file_put()
to return, so there is no need to put it after synchronize_srcu()
to wait for the rcu read-side critical section to exit.

Just move it before synchronize_srcu(), which is also convenient
to put the heavy synchronize_srcu() in the delayed work later.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eeca83e28c9b..a773e97e152e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -818,11 +818,11 @@ void unregister_shrinker(struct shrinker *shrinker)
 	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
 	mutex_unlock(&shrinker_mutex);
 
+	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
+
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 
-	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
-
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
 }
-- 
2.30.2

